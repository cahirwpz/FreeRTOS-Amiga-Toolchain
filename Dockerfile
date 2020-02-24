# To build and publish image run following commands:
# > docker build -t cahirwpz/freertos-amiga-toolchain:latest .
# > docker login
# > docker push cahirwpz/freertos-amiga-toolchain:latest

FROM debian:buster

WORKDIR /root

RUN apt-get -q update && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends \
            automake bison ca-certificates curl flex gcc g++ gettext lhasa \
            libtool make patch  pkg-config python3 python3-setuptools quilt \
            texinfo xz-utils zip
RUN apt-get install -y --no-install-recommends \
            libc6-dev libglib2.0-dev libncurses-dev libpng-dev libsdl2-dev \
            libopenal-dev libpython3-dev 
