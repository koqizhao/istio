#!/bin/bash

go mod tidy
go mod vendor

# This defines the docker hub to use when running integration tests and building docker images
# eg: HUB="docker.io/istio", HUB="gcr.io/istio-testing"
#export HUB="docker.io/${user}"
export HUB=${HUB:-"192.168.56.11:5000"}

export DOCKER_TARGETS=${DOCKER_TARGETS:-"docker.pilot docker.proxyv2 docker.app docker.istioctl docker.operator docker.install-cni"}

# This defines the docker tag to use when running integration tests and
# building docker images to be your user id. You may also set this variable
# this to any other legitimate docker tag.
#export TAG=${user}

export TAG=${TAG:-V$(date "+%Y%m%d%H%M%S")}
export VERSION="1.11-$TAG"

# This defines a shortcut to change directories to $HOME/istio.io
export ISTIO=${ISTIO:-"$HOME/istio.io"}

export BUILD_WITH_CONTAINER=${BUILD_WITH_CONTAINER:-1}

# On Mac
#export DOCKER_SOCKET_MOUNT=${DOCKER_SOCKET_MOUNT:-"-v /var/run/docker.sock.raw:/var/run/docker.sock"}

export GOPROXY=${GOPROXY:-"https://goproxy.cn,https://goproxy.io,https://mirrors.aliyun.com/goproxy/,direct"}
export GOSUMDB=${GOSUMDB:-off}

# Envoy binary variables Keep the default URLs up-to-date with the latest push from istio/proxy.
#export ISTIO_ENVOY_BASE_URL=https://storage.googleapis.com/istio-build/proxy

# Use local envoy build
#export USE_LOCAL_PROXY=${USE_LOCAL_PROXY:-1}
#export TARGET_OS=${TARGET_OS:-linux}
#ISTIO_ENVOY_LINUX_RELEASE_NAME=envoy
#export ISTIO_ENVOY_CENTOS_LINUX_RELEASE_NAME=$ISTIO_ENVOY_LINUX_RELEASE_NAME
#ISTIO_ENVOY_LOCAL_DIR=${ISTIO_ENVOY_LOCAL_DIR:-"proxy"}
#export ISTIO_ENVOY_LOCAL="/work/$ISTIO_ENVOY_LOCAL_DIR/$ISTIO_ENVOY_LINUX_RELEASE_NAME"

# Use mosn
#address=127.0.0.1:10000 # your download service address
#export ISTIO_ENVOY_RELEASE_URL=http://$address/mosn.tar.gz
#export ISTIO_ENVOY_CENTOS_RELEASE_URL=http://$address/mosn-centos.tar.gz
#export SIDECAR=mosn

# set local proxy
#export https_proxy=socks5://127.0.0.1:1080
#export http_proxy=socks5://127.0.0.1:1080

make $@

if [ "$1" = "clean" ]; then
    envoy_local=$ISTIO_ENVOY_LOCAL_DIR/$ISTIO_ENVOY_LINUX_RELEASE_NAME
    if [ -f "$envoy_local" ]; then
        mv $envoy_local ./
	    rm -rf $ISTIO_ENVOY_LOCAL_DIR
	    mkdir $ISTIO_ENVOY_LOCAL_DIR
	    mv ./$ISTIO_ENVOY_LINUX_RELEASE_NAME $ISTIO_ENVOY_LOCAL_DIR
    fi

    rm -rf ./out/.env
    rm -rf ./vendor
fi

echo -e "\n\nTAG: $TAG\n\n"
