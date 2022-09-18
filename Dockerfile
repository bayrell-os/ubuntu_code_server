ARG ARCH=amd64
FROM bayrell/ubuntu:jammy-${ARCH}

ARG APT_MIRROR

RUN cd ~; \
	export DEBIAN_FRONTEND='noninteractive'; \
	/etc/apt/apt.mirror/mirror.install.sh; \
	wget -O - https://openresty.org/package/pubkey.gpg | sudo gpg --dearmor -o /usr/share/keyrings/openresty.gpg; \
	echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/openresty.gpg] http://openresty.org/package/ubuntu jammy main" | sudo tee /etc/apt/sources.list.d/openresty.list > /dev/null; \
	apt-get update; \
	apt-get install -y --no-install-recommends mc less nano wget pv zip \
		unzip supervisor net-tools iputils-ping sudo curl gnupg \
		openresty lua-cjson lua-md5 lua-curl luarocks php \
		git ca-certificates python3-pip python3-venv make build-essential \
		docker.io python3-dev openjdk-8-jre openjdk-11-jre openjdk-17-jre; \
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
	echo 'Ok'
	
COPY downloads/code-server-3.11.0-linux-$ARCH.tar.gz /src/downloads/code-server.tar.gz
COPY downloads/go1.16.6.linux-$ARCH.tar.gz /src/downloads/go.tar.gz

RUN cd /src/downloads; \
	tar -xzf code-server.tar.gz; \
	mv code-server-3.11.0-linux-* code-server; \
	tar -xzf go.tar.gz; \
	cp -r code-server /usr/lib/code-server; \
	cp -r go /usr/lib/go; \
	ln -sf /usr/lib/go/bin/go /usr/bin/go; \
	ln -sf /usr/lib/go/bin/gofmt /usr/bin/gofmt; \
	rm -rf /src/downloads; \
	echo 'Ok'
	
RUN cd ~; \
	npm set registry https://registry.npmjs.org/; \
	echo 'npm set registry https://registry.npmmirror.com/' > /dev/null; \
	echo 'Update npm'; \
	npm install -g npm@8.10.0; \
	echo 'Ok'
	
ADD files /src/files
RUN cd ~; \
	yes | cp -rf /src/files/etc/* /etc/; \
	yes | cp -rf /src/files/root/* /root/; \
	yes | cp -rf /src/files/usr/* /usr/; \
	yes | cp -rf /src/files/var/* /var/; \
	rm -rf /src/*; \
	chmod +x /root/run.sh; \
	usermod -a -G docker www-data; \
	echo 'Ok'

CMD ["/root/run.sh"]