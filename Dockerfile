FROM alpine

MAINTAINER mixool0204@gmail.com

RUN ALPINE_GLIBC_BASE_URL="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" \
    && ALPINE_GLIBC_PACKAGE_VERSION="2.25-r0" \
    && ALPINE_GLIBC_BASE_PACKAGE_FILENAME="glibc-$ALPINE_GLIBC_PACKAGE_VERSION.apk" \
    && ALPINE_GLIBC_BIN_PACKAGE_FILENAME="glibc-bin-$ALPINE_GLIBC_PACKAGE_VERSION.apk" \
    && ALPINE_GLIBC_I18N_PACKAGE_FILENAME="glibc-i18n-$ALPINE_GLIBC_PACKAGE_VERSION.apk" \
    && apk add --no-cache --virtual=.build-dependencies wget ca-certificates \
    && wget https://raw.githubusercontent.com/andyshinn/alpine-pkg-glibc/master/sgerrand.rsa.pub -O /etc/apk/keys/sgerrand.rsa.pub \
    && wget \
        $ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BASE_PACKAGE_FILENAME \
        $ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_BIN_PACKAGE_FILENAME \
        $ALPINE_GLIBC_BASE_URL/$ALPINE_GLIBC_PACKAGE_VERSION/$ALPINE_GLIBC_I18N_PACKAGE_FILENAME \
    && apk add --no-cache \
        $ALPINE_GLIBC_BASE_PACKAGE_FILENAME \
        $ALPINE_GLIBC_BIN_PACKAGE_FILENAME \
        $ALPINE_GLIBC_I18N_PACKAGE_FILENAME \
    && wget --no-check-certificate https://github.com/ginuerzh/gost/releases/download/v2.4-dev/gost_2.4-dev20170303_linux_amd64.tar.gz \
    && tar -xzf gost_2.4-dev20170303_linux_amd64.tar.gz \
    && mv gost_2.4-dev20170303_linux_amd64/gost /root/ \
    && /usr/glibc-compat/bin/localedef --force --inputfile POSIX --charmap UTF-8 C.UTF-8 || true \
    && echo "export LANG=C.UTF-8" > /etc/profile.d/locale.sh\
    && apk del .build-dependencies glibc-i18n \
    && rm -rf /root/.wget-hsts /etc/apk/keys/sgerrand.rsa.pub /root/gost_2.4-dev20170303_linux_amd64.tar.gz \
       $ALPINE_GLIBC_BASE_PACKAGE_FILENAME $ALPINE_GLIBC_BIN_PACKAGE_FILENAME $ALPINE_GLIBC_I18N_PACKAGE_FILENAME 

ENTRYPOINT ["/root/gost"]
