#!/bin/bash

install_vsix alefragnani.bookmarks 13.0.1
install_vsix mblode.twig-language 2-0.9.2
install_vsix mrcrowl.hg 1.7.1
install_vsix octref.vetur 0.35.0
install_vsix tht13.html-preview-vscode 0.2.5


if [ "$CODE_SERVER_VERSION" == "3.12.0-cuda" ]; then

install_vsix ms-python.python 2021.10.1365161279
install_vsix ms-toolsai.jupyter 2021.8.12

fi


if [ "$CODE_SERVER_VERSION" == "4.7.1-cuda" ]; then

install_vsix ms-python.python 2022.16.0
install_vsix ms-toolsai.jupyter 2022.10.110

fi


if [ ! -f /data/home/code/User ]; then
	mkdir -p /data/home/code/User
	chown -R www-data:www-data /data/home/code/User
fi

if [ ! -f /data/home/code/User/settings.json ]; then
	cp /opt/code-server/settings/settings.json /data/home/code/User/settings.json
	chown www-data:www-data /data/home/code/User/settings.json
fi

if [ ! -f /data/home/code/User/keybindings.json ]; then
	cp /opt/code-server/settings/keybindings.json /data/home/code/User/keybindings.json
	chown www-data:www-data /data/home/code/User/keybindings.json
fi
