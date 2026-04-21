#!/bin/bash

SCRIPT=$(readlink -f $0)
SCRIPT_PATH=`dirname $SCRIPT`
BASE_PATH=`dirname $SCRIPT_PATH`

RETVAL=0
IMAGE="ubuntu_code_server"
VERSION=4.98.2
SUBVERSION=2
TAG=`date '+%Y%m%d_%H%M%S'`

case "$1" in
	
	download)
		mkdir -p downloads
		if [ ! -f downloads/code-server-$VERSION-linux-amd64.tar.gz ]; then
			wget https://github.com/coder/code-server/releases/download/v$VERSION/code-server-$VERSION-linux-amd64.tar.gz -O "downloads/code-server-$VERSION-linux-amd64.tar.gz"
		fi
		if [ ! -f downloads/code-server-$VERSION-linux-arm64.tar.gz ]; then
			wget https://github.com/coder/code-server/releases/download/v$VERSION/code-server-$VERSION-linux-arm64.tar.gz -O "downloads/code-server-$VERSION-linux-arm64.tar.gz"
		fi
	;;
	
	test-cuda)
		export DOCKER_DEFAULT_PLATFORM=linux/amd64
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION-$TAG-cuda \
			--file Dockerfile.cuda
	;;
	
	test-amd64)
		export DOCKER_DEFAULT_PLATFORM=linux/amd64
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION-$TAG-amd64 \
			--file Dockerfile
	;;
	
	test-arm64)
		export DOCKER_DEFAULT_PLATFORM=linux/arm64/v8
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION-$TAG-arm64 \
			--file Dockerfile
	;;
	
	amd64)
		export DOCKER_DEFAULT_PLATFORM=linux/amd64
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION-amd64 \
			--file Dockerfile
	;;
	
	arm64)
		export DOCKER_DEFAULT_PLATFORM=linux/arm64/v8
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION-arm64 \
			--file Dockerfile
	;;
	
	cuda-amd64)
		export DOCKER_DEFAULT_PLATFORM=linux/amd64
		docker build ./ -t bayrell/$IMAGE:$VERSION-$SUBVERSION-cuda \
			--file Dockerfile.cuda
	;;
	
	cuda-push)
		docker push bayrell/$IMAGE:$VERSION-$SUBVERSION-cuda
		docker tag bayrell/$IMAGE:$VERSION-$SUBVERSION-cuda bayrell/$IMAGE:$VERSION-cuda
		docker push bayrell/$IMAGE:$VERSION-cuda
	;;
	
	manifest)
		rm -rf ~/.docker/manifests/docker.io_bayrell_$IMAGE-*
		
		docker tag bayrell/$IMAGE:$VERSION-$SUBVERSION-amd64 bayrell/$IMAGE:$VERSION-amd64
		docker tag bayrell/$IMAGE:$VERSION-$SUBVERSION-arm64 bayrell/$IMAGE:$VERSION-arm64
		
		docker push bayrell/$IMAGE:$VERSION-$SUBVERSION-amd64
		docker push bayrell/$IMAGE:$VERSION-$SUBVERSION-arm64
		
		docker push bayrell/$IMAGE:$VERSION-amd64
		docker push bayrell/$IMAGE:$VERSION-arm64
		
		docker manifest create bayrell/$IMAGE:$VERSION-$SUBVERSION \
			--amend bayrell/$IMAGE:$VERSION-$SUBVERSION-amd64 \
			--amend bayrell/$IMAGE:$VERSION-$SUBVERSION-arm64
		docker manifest push bayrell/$IMAGE:$VERSION-$SUBVERSION
		
		docker manifest create bayrell/$IMAGE:$VERSION \
			--amend bayrell/$IMAGE:$VERSION-amd64 \
			--amend bayrell/$IMAGE:$VERSION-arm64
		docker manifest push bayrell/$IMAGE:$VERSION
	;;
	
	upload-github)
		docker pull bayrell/$IMAGE:$VERSION-arm64
		docker pull bayrell/$IMAGE:$VERSION-amd64
		docker pull bayrell/$IMAGE:$VERSION-$SUBVERSION-arm64
		docker pull bayrell/$IMAGE:$VERSION-$SUBVERSION-amd64
		
		docker tag bayrell/$IMAGE:$VERSION-$SUBVERSION-arm64 \
			ghcr.io/bayrell-os/$IMAGE:$VERSION-$SUBVERSION-arm64
		
		docker tag bayrell/$IMAGE:$VERSION-$SUBVERSION-amd64 \
			ghcr.io/bayrell-os/$IMAGE:$VERSION-$SUBVERSION-amd64
		
		docker push ghcr.io/bayrell-os/$IMAGE:$VERSION-$SUBVERSION-amd64
		docker push ghcr.io/bayrell-os/$IMAGE:$VERSION-$SUBVERSION-arm64
		
		docker manifest create --amend \
			ghcr.io/bayrell-os/$IMAGE:$VERSION-$SUBVERSION \
			ghcr.io/bayrell-os/$IMAGE:$VERSION-$SUBVERSION-amd64 \
			ghcr.io/bayrell-os/$IMAGE:$VERSION-$SUBVERSION-arm64
		docker manifest push --purge ghcr.io/bayrell-os/$IMAGE:$VERSION-$SUBVERSION
		
		docker tag bayrell/$IMAGE:$VERSION-arm64 \
			ghcr.io/bayrell-os/$IMAGE:$VERSION-arm64
		
		docker tag bayrell/$IMAGE:$VERSION-amd64 \
			ghcr.io/bayrell-os/$IMAGE:$VERSION-amd64
		
		docker push ghcr.io/bayrell-os/$IMAGE:$VERSION-amd64
		docker push ghcr.io/bayrell-os/$IMAGE:$VERSION-arm64
		
		docker manifest create --amend \
			ghcr.io/bayrell-os/$IMAGE:$VERSION \
			ghcr.io/bayrell-os/$IMAGE:$VERSION-amd64 \
			ghcr.io/bayrell-os/$IMAGE:$VERSION-arm64
		docker manifest push --purge ghcr.io/bayrell-os/$IMAGE:$VERSION
	;;
	
	all)
		$0 amd64
		$0 arm64
		$0 manifest
		#$0 cuda-amd64
	;;
	
	*)
		echo "Usage: $0 {download|all|amd64|arm64|cuda-amd64|test-amd64|test-arm64|test-cuda}"
		RETVAL=1

esac

exit $RETVAL
