FROM ubuntu:20.04 as build-stage
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update -y
# Install build dependencies
RUN apt-get install -y g++
RUN apt-get install -y wget
RUN apt-get install -y build-essential autoconf automake libtool pkg-config git
# Build bx
COPY . /src/bx
WORKDIR /src/bx
RUN ./install.sh --with-icu --with-png --with-qrencode --build-icu --build-zlib --build-png --build-qrencode --build-boost --build-zmq --disable-shared

# Export built executable to a minimal runtime image and run as an unprivileged
# user.
FROM ubuntu:20.04
RUN useradd --create-home --user-group user
WORKDIR /home/user
COPY --from=build-stage /usr/local/bin/bx bx
RUN chmod a+x bx
USER user
ENTRYPOINT ["./bx"]
