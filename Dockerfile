FROM debian:stable AS build-stage
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && apt-get install -y --no-install-recommends apt-utils

RUN apt-get install -y g++
RUN apt-get install -y wget
RUN apt-get install -y build-essential autoconf automake libtool pkg-config git

COPY . /src/bx
WORKDIR /src/bx
RUN ./install.sh --with-icu --with-png --with-qrencode --build-icu --build-zlib --build-png --build-qrencode --build-boost --build-zmq --disable-shared

USER bx-user
ENTRYPOINT ["bx"]
