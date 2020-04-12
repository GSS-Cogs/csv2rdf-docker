ARG version_default=0.4.4

FROM clojure:openjdk-8-lein-alpine AS build
MAINTAINER Alex Tucker <alex@floop.org.uk>

ARG version_default
ENV VERSION=$version_default
ENV CLOJURE_CLI_VERSION=1.10.1.536
WORKDIR /usr/src/
RUN \
    apk add --no-cache curl bash libarchive-tools && \
    curl -fsL https://github.com/Swirrl/csv2rdf/archive/${VERSION}.tar.gz | bsdtar -xf-
RUN \
    cd /tmp && \
    curl -O https://download.clojure.org/install/linux-install-${CLOJURE_CLI_VERSION}.sh && \
    chmod +x linux-install-${CLOJURE_CLI_VERSION}.sh && \
    ./linux-install-${CLOJURE_CLI_VERSION}.sh
RUN \
    cd /usr/src/csv2rdf-${VERSION} && \
    lein uberjar

FROM openjdk:8-alpine
ARG version_default
ENV VERSION=$version_default
COPY --from=build /usr/src/csv2rdf-${VERSION}/target/csv2rdf-${VERSION}-standalone.jar /usr/local/share/java/csv2rdf.jar
COPY csv2rdf /usr/local/bin/csv2rdf
COPY log4j2.xml /usr/local/share/log4j2.xml
RUN \
    apk add --no-cache coreutils raptor2 pigz

