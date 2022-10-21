ARG ARCH=amd64
FROM bayrell/ubuntu:jammy-${ARCH}

ARG APT_MIRROR

RUN cd ~; \
	export DEBIAN_FRONTEND='noninteractive'; \
	/etc/apt/apt.mirror/mirror.install.sh; \
	wget -O - https://openresty.org/package/pubkey.gpg | sudo gpg --dearmor -o /usr/share/keyrings/openresty.gpg; \
	if [ "$ARCH" = "amd64" ]; then echo "deb [signed-by=/usr/share/keyrings/openresty.gpg] http://openresty.org/package/ubuntu jammy main" > /etc/apt/sources.list.d/openresty.list; fi; \
	if [ "$ARCH" = "arm64v8" ]; then echo "deb [signed-by=/usr/share/keyrings/openresty.gpg] http://openresty.org/package/arm64/ubuntu jammy main" > /etc/apt/sources.list.d/openresty.list; fi; \
	apt-get update; \
	apt-get install -y --no-install-recommends mc less nano wget pv zip \
		unzip supervisor net-tools iputils-ping sudo curl gnupg \
		openresty lua-cjson lua-md5 lua-curl luarocks php jq \
		git ca-certificates python3-pip python3-venv make build-essential \
		docker.io python3-dev openjdk-8-jre openjdk-11-jre openjdk-17-jre \
		openssh-client rsync lftp; \
	luarocks install lua-resty-jwt; \
	pip3 install mercurial; \
	/etc/apt/apt.mirror/mirror.restore.sh; \
	apt-get clean all; \
	sed -i "s|www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin|www-data:x:33:33:www-data:/data/home:/bin/bash|g" /etc/passwd; \
	ln -sf /dev/stdout /usr/local/openresty/nginx/logs/access.log; \
	ln -sf /dev/stderr /usr/local/openresty/nginx/logs/error.log; \
	test -f /usr/lib/jvm/java-8-openjdk-amd64/bin/java && \
		ln -sf /usr/lib/jvm/java-8-openjdk-amd64/bin/java /usr/bin/java8; \
	test -f /usr/lib/jvm/java-11-openjdk-amd64/bin/java && \
		ln -sf /usr/lib/jvm/java-11-openjdk-amd64/bin/java /usr/bin/java11; \
	test -f /usr/lib/jvm/java-17-openjdk-amd64/bin/java && \
		ln -sf /usr/lib/jvm/java-17-openjdk-amd64/bin/java /usr/bin/java17; \
	test -f /usr/lib/jvm/java-8-openjdk-arm64/bin/java && \
		ln -sf /usr/lib/jvm/java-8-openjdk-arm64/bin/java /usr/bin/java8; \
	test -f /usr/lib/jvm/java-11-openjdk-arm64/bin/java && \
		ln -sf /usr/lib/jvm/java-11-openjdk-arm64/bin/java /usr/bin/java11; \
	test -f /usr/lib/jvm/java-17-openjdk-arm64/bin/java && \
		ln -sf /usr/lib/jvm/java-17-openjdk-arm64/bin/java /usr/bin/java17; \
	echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers; \
	groupadd -r wheel; \
	usermod -a -G wheel www-data; \
	echo 'Ok'
	
RUN cd ~; \
	export DEBIAN_FRONTEND='noninteractive'; \
	/etc/apt/apt.mirror/mirror.install.sh; \
	curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -; \
	echo 'deb https://deb.nodesource.com/node_16.x focal main' > /etc/apt/sources.list.d/nodesource.list; \
	apt-get update; \
	apt-get install -y --no-install-recommends nodejs; \
	/etc/apt/apt.mirror/mirror.restore.sh; \
	apt-get clean all; \
	npm set registry https://registry.npmjs.org/; \
	echo 'npm set registry https://registry.npmmirror.com/' > /dev/null; \
	echo 'Update npm'; \
	npm install -g npm@8.19.2; \
	npm install -g vsce; \
	echo 'Ok'

ENV CODE_SERVER_VERSION=3.12.0
ADD downloads/code-server-3.12.0-linux-$ARCH.tar.gz /opt
COPY files /

RUN cd ~; \
	ln -s /opt/code-server-3.12.0-linux-$ARCH /usr/lib/code-server; \
	ln -s /usr/lib/code-server/bin/code-server /usr/bin/code-server; \
	chmod +x /root/*.sh; \
	chmod +x /usr/bin/composer; \
	chmod +x /usr/bin/install_vsix; \
	usermod -a -G docker www-data; \
	echo 'Ok'

CMD ["/root/run.sh"]