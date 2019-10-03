#
# Postgis tolerance adjusted from default 1E-8 to 1E-6
#
# Orginal container build mdillon/postgis

#FROM postgres:11.2-alpine
#FROM postgres:12-beta3-alpine
#FROM postgres:12-rc1-alpine
FROM postgres:12-alpine
# MAINTAINER Régis Belson <me@regisbelson.fr>
MAINTAINER tvijlbrief@gmail.com

# COPY ./lwstroke.c /

RUN set -ex \
    \
    && apk add --no-cache --virtual .fetch-deps \
        ca-certificates \
        openssl \
        tar \
	subversion \
	zip \
    \
    && cd /usr/src && wget https://github.com/CGAL/cgal/archive/releases/CGAL-4.13.1.tar.gz && tar xzf CGAL*gz && rm CGAL*gz \
    && wget https://github.com/Oslandia/SFCGAL/archive/master.zip && unzip master.zip && rm master.zip \
    && svn checkout https://svn.osgeo.org/postgis/trunk/ /usr/src/postgis \
    \
    && apk add --no-cache --virtual .build-deps \
        autoconf \
        automake \
        g++ \
        json-c-dev \
        libtool \
        libxml2-dev \
        make \
        perl \
	bison \
	cmake \
    \
    && apk add --no-cache --virtual .build-deps-edge \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \    
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
        gdal-dev \
        geos-dev \
	proj-dev \
        # protobuf-c-dev \
	gmp-dev \
	mpfr-dev \
	boost-dev \
    && cd /usr/src/cgal* && cmake . && make install \
    && cd /usr/src/SFCGAL-master* && cmake . && make install \ 
    # && cp /lwstroke.c /usr/src/postgis/liblwgeom/ \
    && cd /usr/src/postgis \
    # && sed 's/EPSILON_SQLMM 1e-8/EPSILON_SQLMM 1e-1/' < liblwgeom/liblwgeom_internal.h > tmp.h \
    # && mv tmp.h liblwgeom/liblwgeom_internal.h \
    && ./autogen.sh \
# configure options taken from:
# https://anonscm.debian.org/cgit/pkg-grass/postgis.git/tree/debian/rules?h=jessie
    && ./configure \
#       --with-gui \
    && make \
    && make install \
    && apk add --no-cache \
        json-c \
    && apk add --no-cache \
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing \    
        --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \        
        geos \
        gdal \
        proj \
        # protobuf-c \
	gmp \
	mpfr4 \
        boost \
    && cd /usr/local/lib \
    && ln -s /usr/local/lib64/* . \
    && rm -rf /usr/src/postgis \
    && rm -rf /usr/src/cgal* \
    && rm -rf /usr/src/SFCGAL* \
    && apk del .fetch-deps .build-deps .build-deps-edge

COPY ./initdb-postgis.sh /docker-entrypoint-initdb.d/postgis.sh
COPY ./update-postgis.sh /usr/local/bin
