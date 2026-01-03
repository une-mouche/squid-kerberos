FROM docker.io/library/debian:13.2-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install compilation requirements
RUN apt update && apt install -y \
        autoconf \
        automake \
        make \
        pkg-config \
        g++

# Install dependancies
RUN apt install -y \
        libcap-dev \
        libssl-dev \
        libtdb-dev \
        libtool \
        libtool-bin \
        libkrb5-dev \
        libkrb5-3 \
        krb5-config \
        krb5-user \
        libgss-dev \
        libpam-krb5 \
        libsasl2-dev \
        libsasl2-modules \
        libsasl2-modules-gssapi-mit \
        libsasl2-modules-ldap \
        libldap-dev

RUN mkdir /squid && \
    mkdir /squid/source

COPY squid-7.3 /squid/source

WORKDIR /squid/source
RUN ./configure --prefix=/usr \
                --localstatedir=/var \
                --libexecdir=${prefix}/lib/squid \
                --datadir=${prefix}/share/squid \
                --sysconfdir=/etc/squid \
                --with-default-user=proxy \
                --with-logdir=/var/log/squid \
                --with-pidfile=/var/run/squid.pid \
                --disable-ipv6 \
                --disable-icmp \
                --with-openssl \
                --enable-ssl-crtd \
                --enable-auth-negotiate="kerberos" \
                --disable-auth-ntlm \
                --disable-auth-basic \
                --disable-auth-digest \
                --enable-external-acl-helpers="kerberos_ldap_group"

CMD ["bash"]
