ARG ARCH=
FROM ${ARCH}ubuntu:focal

ENV GOROOT /usr/lib/go
ENV GOPATH /data/golang
ENV GO111MODULE auto

RUN cd ~; \
	export DEBIAN_FRONTEND='noninteractive'; \
	apt-get update; \
	apt-get install -y --no-install-recommends apt-utils; \
	apt-get install -y --no-install-recommends mc less nano wget pv zip unzip supervisor net-tools sudo curl gnupg nginx git ca-certificates; \
	sed -i "s|www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin|www-data:x:33:33:www-data:/data/home:/bin/bash|g" /etc/passwd; \
	curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -; \
	echo 'deb https://deb.nodesource.com/node_14.x focal main' > /etc/apt/sources.list.d/nodesource.list; \
	apt-get update; \
	apt-get install -y --no-install-recommends nodejs; \
	echo 'Ok'
	
ADD downloads /src/downloads
RUN cd /src/downloads; \
	tar -xzf code-server-3.11.0-linux-amd64.tar.gz; \
	cp -r code-server-3.11.0-linux-amd64 /usr/lib/code-server; \
	tar -xzf go1.16.6.linux-amd64.tar.gz; \
	cp -r go /usr/lib/go; \
	ln -sf /usr/lib/go/bin/go /usr/bin/go; \
	ln -sf /usr/lib/go/bin/gofmt /usr/bin/gofmt; \
	rm -rf /src/*; \
	echo 'Ok'
	
ADD files /src/files
RUN cd ~; \
	cp -rf /src/files/etc/* /etc/; \
	cp -rf /src/files/root/* /root/; \
	cp -rf /src/files/var/* /var/; \
	rm -rf /src/*; \
	chmod +x /root/run.sh; \
	echo 'Ok'

CMD ["/root/run.sh"]