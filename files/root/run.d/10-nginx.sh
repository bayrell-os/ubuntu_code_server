if [ ! -z $ANY_PHP ] && [ "$ANY_PHP" = "1" ]; then
	sed -i 's|%REWRITE_PHP%|try_files $uri $uri/ /index.php?$args;|g' /etc/nginx/sites-available/default
	sed -i 's|%LOCATION_PHP%|location ~ \\.php$|g' /etc/nginx/sites-available/default
else
	sed -i 's|%REWRITE_PHP%|rewrite ^/. /index.html last;|g' /etc/nginx/sites-available/default
	sed -i 's|%LOCATION_PHP%|location /index.php|g' /etc/nginx/sites-available/default
fi
if [ ! -z $DOCUMENT_ROOT ]; then
	sed -i "s|root /var/www/html;|root $DOCUMENT_ROOT;|g" /etc/nginx/sites-available/default
fi
