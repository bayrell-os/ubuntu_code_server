if [ ! -d /data/home/go ]; then
	mkdir -p /data/home/go
	chown -R www-data:www-data /data/home/go
fi