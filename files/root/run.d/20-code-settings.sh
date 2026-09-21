#!/bin/bash

if [ ! -d /data/home/code ]; then
	mkdir -p /data/home/code
	chown ubuntu:ubuntu /data/home/code
fi

if [ ! -d /data/home/code/extensions ]; then
	mkdir -p /data/home/code/extensions
	chown ubuntu:ubuntu /data/home/code/extensions
fi

if [ ! -d /data/home/code/User ]; then
	mkdir -p /data/home/code/User
	chown ubuntu:ubuntu /data/home/code/User
fi

if [ "$CODE_SERVER_ENABLE_ADMIN" = "1" ]; then
	sed -i 's|127.0.0.1:8000|0.0.0.0:8000|g' /etc/supervisor.d/code-server.ini
	rm -f /etc/supervisor.d/nginx.ini
fi

if [ ! -f /data/home/code/User ]; then
	mkdir -p /data/home/code/User
	chown -R ubuntu:ubuntu /data/home/code/User
fi

if [ ! -f /data/home/code/User/settings.json ]; then
	cp /opt/code-server/settings/settings.json /data/home/code/User/settings.json
	chown ubuntu:ubuntu /data/home/code/User/settings.json
fi

if [ ! -f /data/home/code/User/keybindings.json ]; then
	cp /opt/code-server/settings/keybindings.json /data/home/code/User/keybindings.json
	chown ubuntu:ubuntu /data/home/code/User/keybindings.json
fi

if [ ! -f /data/home/code/extensions.json ]; then
	install_vsix alefragnani.bookmarks 13.0.1
	install_vsix mblode.twig-language 2-0.9.2
	install_vsix mrcrowl.hg 1.7.1
	install_vsix tht13.html-preview-vscode 0.2.5
	install_vsix ms-python.python 2022.16.1
	install_vsix ms-toolsai.jupyter 2022.8.1002460559
	install_vsix ms-toolsai.jupyter-keymap 1.0.0
	install_vsix ms-toolsai.jupyter-renderers 1.0.9
fi