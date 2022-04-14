FROM debian:stable-slim as fetch

RUN apt-get update && apt-get install -y curl
RUN curl -sLo /tmp/csv2rdf.gz https://github.com/Swirrl/csv2rdf/releases/download/graal-linux-0.4.7-SNAPSHOT-c8fe70c/csv2rdf-linux-x86-64-0.4.7-SNAPSHOT.gz
RUN gunzip /tmp/csv2rdf
RUN chmod +x /tmp/csv2rdf

FROM debian:stable-slim
COPY --from=fetch /tmp/csv2rdf /usr/local/bin/

ENV PATH="/usr/local/bin:${PATH}"
