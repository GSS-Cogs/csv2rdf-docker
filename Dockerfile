ARG version_default=0.4.5

FROM clojure:openjdk-8-lein-alpine AS build
MAINTAINER Alex Tucker <alex@floop.org.uk>

ARG version_default
ENV VERSION=$version_default
ENV CLOJURE_CLI_VERSION=1.10.1.763
WORKDIR /usr/src/
RUN \
    apk add --no-cache curl bash libarchive-tools && \
    cd /tmp && \
    curl -O https://download.clojure.org/install/linux-install-${CLOJURE_CLI_VERSION}.sh && \
    chmod +x linux-install-${CLOJURE_CLI_VERSION}.sh && \
    ./linux-install-${CLOJURE_CLI_VERSION}.sh
RUN \
    curl -fsL https://github.com/Swirrl/csv2rdf/archive/${VERSION}.tar.gz | bsdtar -xf-
RUN \
    cd /usr/src/csv2rdf-${VERSION} && \
    lein uberjar

FROM rdfhdt/hdt-java AS hdt
RUN \
    apt-get update && \
    apt-get install rename && \
    cd /opt/hdt-java/bin && \
    rename 's/.sh//' rdf*.sh hdt*.sh && \
    rm *.bat && \
    cd .. && \
    rm -rf examples
    

FROM openjdk:8-alpine
ARG version_default
ENV VERSION=$version_default
COPY --from=build /usr/src/csv2rdf-${VERSION}/target/csv2rdf*-standalone.jar /usr/local/share/java/csv2rdf.jar
COPY csv2rdf /usr/local/bin/csv2rdf
COPY log4j2.xml /usr/local/share/log4j2.xml
RUN \
    apk add --no-cache coreutils raptor2 pigz curl
RUN \
    cd /tmp && \
    curl -o jena.tar.gz https://archive.apache.org/dist/jena/binaries/apache-jena-3.17.0.tar.gz && \
    tar xf jena.tar.gz && \
    cd apache-jena* && \
    cp bin/* /usr/local/bin/ && \
    cp lib/* /usr/local/lib/ && \
    cp log4j2.properties /usr/local/ && \
    cd /tmp && \
    rm -rf apache-jena*
RUN \
    apk add --no-cache bash
COPY --from=hdt /opt/hdt-java /opt/hdt-java
ENV PATH="/opt/hdt-java/bin:${PATH}"
