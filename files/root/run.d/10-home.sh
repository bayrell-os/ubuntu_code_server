if [ ! -d /data/home ]; then
	mkdir -p /data/home
	chown -R ubuntu:ubuntu /data/home
fi
if [ ! -f /data/home/.profile ]; then
	cp -f /root/files/.profile /data/home/.profile
	chown ubuntu:ubuntu /data/home/.profile
fi
if [ ! -f /data/home/.bashrc ]; then
	cp -f /root/files/.bashrc /data/home/.bashrc
	chown ubuntu:ubuntu /data/home/.bashrc
fi
if [ ! -d /data/home/node_modules/.bin ]; then
	mkdir -p /data/home/node_modules/.bin
	chown -R ubuntu:ubuntu /data/home/node_modules
fi
if [ ! -d /data/home/bin ]; then
	mkdir -p /data/home/bin
	chown -R ubuntu:ubuntu /data/home/bin
fi
if [ ! -z $TZ ]; then
	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime; \
	echo "$TZ" > /etc/timezone; \
fi
