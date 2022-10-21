#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0
IMAGE="ubuntu_code_server"
VERSION=3.12.0
SUBVERSION=1
TAG=`date '+%Y%m%d_%H%M%S'`

if [ "$APT_MIRROR" = "" ]; then
	APT_MIRROR=""
fi

case "$1" in
	
	download)
		mkdir -p downloads
		if [ ! -f downloads/code-server-3.12.0-linux-amd64.tar.gz ]; then
			wget https://github.com/coder/code-server/releases/download/v3.12.0/code-server-3.12.0-linux-amd64.tar.gz -O "downloads/code-server-3.12.0-linux-amd64.tar.gz"
		fi
		if [ ! -f downloads/code-server-4.7.1-linux-amd64.tar.gz ]; then
			wget https://github.com/coder/code-server/releases/download/v4.7.1/code-server-4.7.1-linux-amd64.tar.gz -O "downloads/code-server-4.7.1-linux-amd64.tar.gz"
		fi
	;;
	
	test-cuda)
		export DOCKER_DEFAULT_PLATFORM=linux/amd64
		docker build ./ -t bayrell/$IMAGE:4.7.1-1-$TAG-cuda \
			--file Dockerfile.cuda --build-arg ARCH=amd64
	;;
	
	test-amd64)
		export DOCKER_DEFAULT_PLATFORM=linux/amd64
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION-$TAG-amd64 \
			--file Dockerfile --build-arg ARCH=amd64 --build-arg APT_MIRROR=$APT_MIRROR
	;;
	
	test-arm64v8)
		export DOCKER_DEFAULT_PLATFORM=linux/arm64/v8
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION-$TAG-arm64v8 \
			--file Dockerfile --build-arg ARCH=arm64v8 --build-arg APT_MIRROR=$APT_MIRROR
	;;
	
	stage0-amd64)
		export DOCKER_DEFAULT_PLATFORM=linux/arm64/v8
		docker build ./ -t bayrell/$IMAGE:stage0-$TAG-amd64 \
			--file stages/Dockerfile0 --build-arg ARCH=amd64 --build-arg APT_MIRROR=$APT_MIRROR
	;;
	
	stage0-arm64v8)
		export DOCKER_DEFAULT_PLATFORM=linux/arm64/v8
		docker build ./ -t bayrell/$IMAGE:stage0-$TAG-arm64v8 \
			--file stages/Dockerfile0 --build-arg ARCH=arm64v8 --build-arg APT_MIRROR=$APT_MIRROR
	;;
	
	amd64)
		export DOCKER_DEFAULT_PLATFORM=linux/amd64
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION-amd64 \
			--file Dockerfile --build-arg ARCH=amd64 --build-arg APT_MIRROR=$APT_MIRROR
	;;
	
	arm64v8)
		export DOCKER_DEFAULT_PLATFORM=linux/arm64/v8
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION-arm64v8 \
			--file Dockerfile --build-arg ARCH=arm64v8 --build-arg APT_MIRROR=$APT_MIRROR
	;;
	
	cuda-amd64)
		export DOCKER_DEFAULT_PLATFORM=linux/amd64
		docker build ./ -t bayrell/$IMAGE:4.7.1-1-cuda \
			--file Dockerfile.cuda --build-arg ARCH=amd64
		docker push bayrell/$IMAGE:4.7.1-1-cuda
		docker tag bayrell/$IMAGE:4.7.1-1-cuda bayrell/$IMAGE:4.7.1-cuda
		docker push bayrell/$IMAGE:4.7.1-cuda
	;;
	
	manifest)
		rm -rf ~/.docker/manifests/docker.io_bayrell_$IMAGE-*
		
		docker tag bayrell/$IMAGE:$VERSION-$SUBVERSION-amd64 bayrell/$IMAGE:$VERSION-amd64
		docker tag bayrell/$IMAGE:$VERSION-$SUBVERSION-arm64v8 bayrell/$IMAGE:$VERSION-arm64v8
		
		docker push bayrell/$IMAGE:$VERSION-$SUBVERSION-amd64
		docker push bayrell/$IMAGE:$VERSION-$SUBVERSION-arm64v8
		
		docker push bayrell/$IMAGE:$VERSION-amd64
		docker push bayrell/$IMAGE:$VERSION-arm64v8
		
		docker manifest create bayrell/$IMAGE:$VERSION-$SUBVERSION \
			--amend bayrell/$IMAGE:$VERSION-$SUBVERSION-amd64 \
			--amend bayrell/$IMAGE:$VERSION-$SUBVERSION-arm64v8
		docker manifest push bayrell/$IMAGE:$VERSION-$SUBVERSION
		
		docker manifest create bayrell/$IMAGE:$VERSION \
			--amend bayrell/$IMAGE:$VERSION-amd64 \
			--amend bayrell/$IMAGE:$VERSION-arm64v8
		docker manifest push bayrell/$IMAGE:$VERSION
	;;
	
	all)
		$0 amd64
		$0 arm64v8
		$0 manifest
		$0 cuda-amd64
	;;
	
	*)
		echo "Usage: $0 {download|all|amd64|arm64v8|cuda-amd64|test-amd64|test-arm64v8|test-cuda|stage0-amd64|stage0-arm64v8}"
		RETVAL=1

esac

exit $RETVAL
