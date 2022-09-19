if [ ! -z $WWW_UID ]; then
	sed -i "s|:33:33:|:$WWW_UID:$WWW_GID:|g" /etc/passwd
fi
if [ ! -z $WWW_GID ]; then
	sed -i "s|:33:|:$WWW_GID:|g" /etc/group
fi
if [ ! -z $DOCKER_GID ]; then
	sed -i "s|:101:|:$DOCKER_GID:|g" /etc/group
fi
if [ ! -d /data/home ]; then
	mkdir -p /data/home
	chown -R www-data:www-data /data/home
fi
if [ ! -f /data/home/.profile ]; then
	cp -f /root/files/.profile /data/home/.profile
	chown $WWW_UID:$WWW_GID /data/home/.profile
fi
if [ ! -f /data/home/.bashrc ]; then
	cp -f /root/files/.bashrc /data/home/.bashrc
	chown $WWW_UID:$WWW_GID /data/home/.bashrc
fi
if [ ! -d /data/home/node_modules/.bin ]; then
	mkdir -p /data/home/node_modules/.bin
	chown -R $WWW_UID:$WWW_GID /data/home/node_modules
fi
if [ ! -d /data/home/bin ]; then
	mkdir -p /data/home/bin
	chown -R $WWW_UID:$WWW_GID /data/home/bin
fi