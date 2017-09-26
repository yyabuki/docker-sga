FROM ubuntu:16.04
MAINTAINER Yukimitsu Yabuki, yukimitsu.yabuki@gmail.com
# a bit modified Michael Barton's Dockerfile

ENV PACKAGES zlib1g-dev libsparsehash-dev wget make automake g++ cmake


ENV BAM_TAR https://github.com/pezmaster31/bamtools/archive/v2.3.0.tar.gz
ENV BAM_DIR /tmp/bam

ENV SGA_TAR https://github.com/jts/sga/archive/v0.10.13.tar.gz
ENV SGA_DIR /tmp/sga

RUN apt-get update -y && \
    apt-get install -y --no-install-recommends ${PACKAGES}

RUN mkdir ${BAM_DIR}
RUN cd ${BAM_DIR} && \
    wget ${BAM_TAR} --no-check-certificate --output-document - \
    | tar xzf - --directory . --strip-components=1
RUN cd ${BAM_DIR} && \
    mkdir build && \
    cd build && \
    cmake .. && \
    make

RUN mkdir ${SGA_DIR}
RUN cd ${SGA_DIR} && \
    wget ${SGA_TAR} --no-check-certificate --output-document - \
    | tar xzf - --directory . --strip-components=2 && \
    ./autogen.sh && \
    ./configure --with-bamtools=${BAM_DIR} && \
    make && \
    make install && \
    rm -rf ${SGA_DIR}




ADD run /usr/local/bin/
ADD Procfile /

ENTRYPOINT ["run"]
