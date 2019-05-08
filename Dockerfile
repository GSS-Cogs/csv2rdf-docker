ARG version_default=0.2.7

FROM clojure:lein-alpine AS build
MAINTAINER Alex Tucker <alex@floop.org.uk>

ARG version_default
ENV VERSION=$version_default
WORKDIR /usr/src/
RUN \
    apk add --no-cache curl bash libarchive-tools && \
    curl -fsL https://github.com/Swirrl/csv2rdf/archive/${VERSION}.tar.gz | bsdtar -xf-
RUN \
    cd /tmp && \
    curl -O https://download.clojure.org/install/linux-install-1.10.0.442.sh && \
    chmod +x linux-install-1.10.0.442.sh && \
    ./linux-install-1.10.0.442.sh
RUN \
    cd /usr/src/csv2rdf-${VERSION} && \
    lein uberjar

FROM openjdk:13-alpine
ARG version_default
ENV VERSION=$version_default
COPY --from=build /usr/src/csv2rdf-${VERSION}/target/csv2rdf-${VERSION}-standalone.jar /usr/share/java/csv2rdf.jar
COPY csv2rdf /usr/local/bin/csv2rdf
