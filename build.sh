#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0
VERSION=3.11.0
SUBVERSION=4
TAG=`date '+%Y%m%d_%H%M%S'`

case "$1" in
	
	download)
		mkdir -p downloads
		if [ ! -f downloads/code-server-3.11.0-linux-amd64.tar.gz ]; then
			wget https://github.com/cdr/code-server/releases/download/v3.11.0/code-server-3.11.0-linux-amd64.tar.gz -O "downloads/code-server-3.11.0-linux-amd64.tar.gz"
		fi
		if [ ! -f downloads/go1.16.6.linux-amd64.tar.gz ]; then
			wget https://golang.org/dl/go1.16.6.linux-amd64.tar.gz -O "downloads/go1.16.6.linux-amd64.tar.gz"
		fi
	;;
	
	test)
		docker build ./ -t bayrell/ubuntu_code_server:$VERSION-$SUBVERSION-$TAG --file Dockerfile
	;;
	
	amd64)
		docker build ./ -t bayrell/ubuntu_code_server:$VERSION-$SUBVERSION-amd64 \
			--file Dockerfile --build-arg ARCH=amd64/
	;;
	
	*)
		echo "Usage: $0 {download|amd64|test}"
		RETVAL=1

esac

exit $RETVAL
