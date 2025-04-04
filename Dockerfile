ARG ARCH=amd64
FROM ${ARCH}/ubuntu:jammy

ARG ARCH
ENV ARCH=${ARCH}

RUN cd ~; \
	export DEBIAN_FRONTEND='noninteractive'; \
	apt-get update; \
	apt-get upgrade -y; \
	apt-get install -y --no-install-recommends apt-utils locales ca-certificates; \
	apt-get clean all; \
	ln -snf /usr/share/zoneinfo/Asia/Almaty /etc/localtime; \
	echo "Asia/Almaty" > /etc/timezone; \
	locale-gen en_US en_US.UTF-8 ru_RU.UTF-8; \
	update-locale LANG=en_US.utf8 LANGUAGE=en_US:en; \
	echo "LANG="en_US.utf8" \n\
LANGUAGE="en_US:en" \n\
export LANG \n\
export LANGUAGE\n" >> /etc/bash.bashrc; \
	echo 'Ok'

RUN cd ~; \
	apt-get install -y --no-install-recommends tzdata debconf-utils mc less nano wget pv zip unrar \
		unzip supervisor net-tools dnsutils iputils-ping sudo curl gnupg linux-tools-common man-db; \
	apt-get install -y --no-install-recommends autoconf automake libtool pkg-config mysql-client sqlite3; \
	yes | unminimize; \
	apt-get clean all; \
	echo "set enable-bracketed-paste off" >> /etc/inputrc; \
	echo 'Ok'

RUN cd ~; \
	export DEBIAN_FRONTEND='noninteractive'; \
	wget https://openresty.org/package/pubkey.gpg; \
	gpg --dearmor -o /usr/share/keyrings/openresty.gpg pubkey.gpg; \
	rm pubkey.gpg; \
	if [ "$ARCH" = "amd64" ]; then echo "deb [signed-by=/usr/share/keyrings/openresty.gpg] http://openresty.org/package/ubuntu jammy main" > /etc/apt/sources.list.d/openresty.list; fi; \
	if [ "$ARCH" = "arm64v8" ]; then echo "deb [signed-by=/usr/share/keyrings/openresty.gpg] http://openresty.org/package/arm64/ubuntu jammy main" > /etc/apt/sources.list.d/openresty.list; fi; \
	apt-get update; \
	apt-get install -y --no-install-recommends mc less nano wget pv zip \
		unzip supervisor net-tools iputils-ping sudo curl gnupg \
		openresty lua-cjson lua-md5 lua-curl luarocks php jq \
		git ca-certificates python3-pip python3-venv make build-essential \
		docker.io docker-buildx python3-dev openjdk-8-jre openjdk-11-jre openjdk-17-jre \
		openssh-client rsync lftp; \
	luarocks install lua-resty-jwt; \
	pip3 install mercurial; \
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
	wget https://raw.githubusercontent.com/bayrell/make_git_hash/befba30cf0548d27c9411ed4ec795db46aeac269/make_git_hash.py -O "/usr/bin/make_git_hash"; \
	chmod +x /usr/bin/make_git_hash; \
	echo 'Ok'

ENV CODE_SERVER_VERSION=4.98.2
ADD downloads/code-server-4.98.2-linux-$ARCH.tar.gz /opt
COPY files /

RUN cd ~; \
	ln -s /opt/code-server-4.98.2-linux-$ARCH /usr/lib/code-server; \
	ln -s /usr/lib/code-server/bin/code-server /usr/bin/code-server; \
	chmod +x /root/*.sh; \
	chmod +x /usr/bin/composer; \
	chmod +x /usr/bin/install_vsix; \
	usermod -a -G docker www-data; \
	echo 'Ok'

CMD ["/root/run.sh"]