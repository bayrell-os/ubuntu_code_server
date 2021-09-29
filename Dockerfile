ARG ARCH=
FROM ${ARCH}ubuntu:focal

RUN cd ~; \
	export DEBIAN_FRONTEND='noninteractive'; \
	apt-get update; \
	apt-get install -y --no-install-recommends apt-utils; \
	apt-get install -y --no-install-recommends mc less nano wget pv zip unzip supervisor net-tools sudo curl gnupg nginx git ca-certificates python3-pip python3-venv; \
	sed -i "s|www-data:x:33:33:www-data:/var/www:/usr/sbin/nologin|www-data:x:33:33:www-data:/data/home:/bin/bash|g" /etc/passwd; \
	curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -; \
	echo 'deb https://deb.nodesource.com/node_16.x focal main' > /etc/apt/sources.list.d/nodesource.list; \
	apt-get update; \
	apt-get install -y --no-install-recommends nodejs; \
	ln -sf /dev/stdout /var/log/nginx/access.log; \
	ln -sf /dev/stderr /var/log/nginx/error.log; \
	ln -sf /dev/stdout /var/log/nginx/php_error.log; \
	echo "%wheel ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers; \
	groupadd -r wheel; \
	usermod -a -G wheel www-data; \
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
	
RUN cd ~; \
	export DEBIAN_FRONTEND='noninteractive'; \
	apt-get update; \
	apt-get install -y --no-install-recommends php7.4 php7.4-fpm php7.4-mysql php7.4-json php7.4-curl php7.4-curl php7.4-xml php7.4-xmlrpc php7.4-mysql php7.4-pgsql php7.4-opcache php7.4-mbstring php7.4-mbstring php7.4-soap php7.4-intl; \
	sed -i 's|;date.timezone =.*|date.timezone = UTC|g' /etc/php/7.4/cli/php.ini; \
	sed -i 's|short_open_tag =.*|short_open_tag = On|g' /etc/php/7.4/cli/php.ini; \
	sed -i 's|display_errors =.*|display_errors = On|g' /etc/php/7.4/cli/php.ini; \
	sed -i 's|error_reporting =.*|display_errors = E_ALL|g' /etc/php/7.4/cli/php.ini; \
	sed -i 's|max_execution_time =.*|max_execution_time = -1|g' /etc/php/7.4/cli/php.ini; \
	sed -i 's|;date.timezone =.*|date.timezone = UTC|g' /etc/php/7.4/fpm/php.ini; \
	sed -i 's|short_open_tag =.*|short_open_tag = On|g' /etc/php/7.4/fpm/php.ini; \
	sed -i 's|display_errors =.*|display_errors = On|g' /etc/php/7.4/fpm/php.ini; \
	sed -i 's|error_reporting =.*|display_errors = E_ALL|g' /etc/php/7.4/fpm/php.ini; \
	sed -i 's|listen =.*|listen = /var/run/php7.4-fpm.sock|g' /etc/php/7.4/fpm/pool.d/www.conf; \
	sed -i 's|;clear_env =.*|clear_env = no|g' /etc/php/7.4/fpm/pool.d/www.conf; \
	sed -i 's|;catch_workers_output =.*|catch_workers_output = yes|g' /etc/php/7.4/fpm/pool.d/www.conf; \
	echo 'php_admin_value[error_log] = /var/log/nginx/php_error.log' >> /etc/php/7.4/fpm/pool.d/www.conf; \
	echo 'php_admin_value[memory_limit] = 128M' >> /etc/php/7.4/fpm/pool.d/www.conf; \
	echo 'php_admin_value[post_max_size] = 128M' >> /etc/php/7.4/fpm/pool.d/www.conf; \
	echo 'php_admin_value[upload_max_filesize] = 128M' >> /etc/php/7.4/fpm/pool.d/www.conf; \
	echo 'php_admin_value[file_uploads] = on' >> /etc/php/7.4/fpm/pool.d/www.conf; \
	echo 'php_admin_value[upload_tmp_dir] = /tmp' >> /etc/php/7.4/fpm/pool.d/www.conf; \
	echo 'php_admin_value[precision] = 16' >> /etc/php/7.4/fpm/pool.d/www.conf; \
	echo 'php_admin_value[max_execution_time] = 30' >> /etc/php/7.4/fpm/pool.d/www.conf; \
	echo 'php_admin_value[session.save_path] = /data/php/session' >> /etc/php/7.4/fpm/pool.d/www.conf; \
	echo 'php_admin_value[soap.wsdl_cache_dir] = /data/php/wsdlcache' >> /etc/php/7.4/fpm/pool.d/www.conf; \
	ln -sf /dev/stderr /var/log/nginx/php_error.log; \
	echo 'Ok'
	
ADD files /src/files
RUN cd ~; \
	cp -rf /src/files/etc/* /etc/; \
	cp -rf /src/files/root/* /root/; \
	cp -rf /src/files/usr/* /usr/; \
	cp -rf /src/files/var/* /var/; \
	rm -rf /src/*; \
	chmod +x /root/run.sh; \
	echo 'Ok'

CMD ["/root/run.sh"]