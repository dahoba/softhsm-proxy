FROM alpine:3.8

ENV SOFTHSM_VERSION=2.5.0

# install build dependencies
RUN apk --update --no-cache add \
        alpine-sdk \
        autoconf \
        automake \
        git \
        libtool \
        libseccomp-dev \
        cmake \
        p11-kit-dev \
        openssl-dev \
        stunnel

# build and install
RUN git clone https://github.com/opendnssec/SoftHSMv2.git /tmp/softhsm2
WORKDIR /tmp/softhsm2

RUN git checkout ${SOFTHSM_VERSION} -b ${SOFTHSM_VERSION} \
    && sh autogen.sh \
    && ./configure \
    && make \
    && make install

RUN git clone https://github.com/SUNET/pkcs11-proxy /tmp/pkcs11-proxy && \
    cd /tmp/pkcs11-proxy && \
    cmake . && make && make install

RUN rm -fr /tmp/softhsm2 /tmp/pkcs11-proxy
WORKDIR /root


# install pkcs11-tool
RUN apk --update --no-cache add opensc && \
    echo "0:/var/lib/softhsm/slot0.db" > /etc/softhsm2.conf && \
    softhsm2-util --init-token --slot 0 --label key --pin 1234 --so-pin 0000

EXPOSE 5657
ENV PKCS11_DAEMON_SOCKET="tcp://0.0.0.0:5657"
CMD [ "/usr/local/bin/pkcs11-daemon", "/usr/local/lib/softhsm/libsofthsm2.so" ]