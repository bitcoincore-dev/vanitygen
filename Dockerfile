FROM ubuntu:14.04 as vanitygen
RUN apt update
RUN apt -y install git vim bash-completion build-essential libtool autotools-dev \
autoconf libssl-dev libdb-dev libdb++-dev libboost-all-dev libpcre3 \
libpcre3-dev automake opencl-headers ocl-icd-libopencl1 curl libcurl4-openssl-dev
RUN git clone https://github.com/bitcoincore-dev/vanitygen --depth 2
WORKDIR vanitygen
RUN make all
