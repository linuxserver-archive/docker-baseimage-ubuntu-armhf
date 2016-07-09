FROM armv7/armhf-ubuntu:16.04
MAINTAINER sparklyballs

# set environment variables
ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME="/root"
ENV TERM="xterm"

# set version for s6 overlay
ARG OVERLAY_VERSION="v1.18.1.3"
ARG OVERLAY_ARCH="armhf"
ARG OVERLAY_URL="https://github.com/just-containers/s6-overlay/releases/download"
ARG OVERLAY_WWW="${OVERLAY_URL}"/"${OVERLAY_VERSION}"/s6-overlay-"${OVERLAY_ARCH}".tar.gz

# create abc user and make folders
RUN \
 useradd -u 911 -U -d /config -s /bin/false abc && \
 usermod -G users abc && \
 mkdir -p \
	/app \
	/config \
	/defaults

# install packages
RUN \
 apt-get update && \
 apt-get install -y \
	apt-utils && \
 apt-get install -y \
	curl && \

# add s6 overlay
 curl -o \
 /tmp/s6-overlay.tar.gz -L \
	"${OVERLAY_WWW}" && \
 tar xvfz /tmp/s6-overlay.tar.gz -C / && \

# cleanup
 apt-get clean && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# add local files
COPY root/ /

ENTRYPOINT ["/init"]
