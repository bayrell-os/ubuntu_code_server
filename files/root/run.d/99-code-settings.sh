#!/bin/bash

function check_vsix_is_installed {
	
	VSIX_NAME=$1
	JSON_PATH="/data/home/code/extensions.json"
	
	if [ ! -f $JSON_PATH ]; then
		return 0
	fi
	
	CMD="cat $JSON_PATH | jq -r '.\"$VSIX_NAME\"'"
	res=$( eval $CMD )
	
	#echo $CMD
	#echo $res
	
	if [ "$res" != "null" ]; then
		return 1
	fi
	
	return 0
}

function extract_vsix {
	
	VSIX_NAME=$1
	VSIX_VERSION=$2
	VSIX_PATH="/opt/code-server/extensions/${VSIX_NAME}-${VSIX_VERSION}.vsix"
	DEST_PATH="/data/home/code/extensions/${VSIX_NAME}-${VSIX_VERSION}"
	
	if [ -d "${DEST_PATH}" ]; then
		return 1
	fi
	
	if [ -d /tmp/vsix ]; then
		rm -rf /tmp/vsix
	fi
	mkdir /tmp/vsix
	
	unzip -q $VSIX_PATH -d /tmp/vsix
	
	if [ ! -d /tmp/vsix/extension ]; then
		return 1
	fi
	
	mkdir -p ${DEST_PATH}
	cp -rf /tmp/vsix/extension/* ${DEST_PATH}
	rm -rf /tmp/vsix
	
	chown -R www-data:www-data ${DEST_PATH}
	
	return 0
}

function install_vsix {
	
	VSIX_NAME=$1
	VSIX_VERSION=$2
	VSIX_PATH="/opt/code-server/extensions/${VSIX_NAME}-${VSIX_VERSION}.vsix"
	
	check_vsix_is_installed $VSIX_NAME
	res=$?
	if [ "$res" -ne "0" ]; then
		return 1
	fi
	
	echo "Install extension $VSIX_NAME"
	
	extract_vsix $VSIX_NAME $VSIX_VERSION
	res=$?
	
	JSON_PATH="/data/home/code/extensions.json"
	if [ ! -f $JSON_PATH ]; then
		echo "{}" > $JSON_PATH
	fi
	
	JSON_CONTENT=`cat $JSON_PATH`
	jq ". + { \"${VSIX_NAME}\": \"${VSIX_VERSION}\" }" <<< "$JSON_CONTENT" > $JSON_PATH
	
	chown www-data:www-data ${JSON_PATH}
	
	return $res
}

install_vsix alefragnani.bookmarks 13.0.1
install_vsix mblode.twig-language 2-0.9.2
install_vsix mrcrowl.hg 1.7.1
install_vsix octref.vetur 0.35.0

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
