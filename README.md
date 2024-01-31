# DO NOT USE

TPXImpact is now producing docker images of csv2rdf which they are activly maintaining to convert csv-w into RDF. You can find their repository [Swirrl/csv2rdf](https://github.com/Swirrl/csv2rdf). They publisher their docker images the following using a GCP registry, not the DockerHub one.

## Latest release of csv2rdf

```docker run --rm -v .:/data europe-west2-docker.pkg.dev/swirrl-devops-infrastructure-1/public/csv2rdf:master <ARGS>```

## Pin a specific release of csv2rdf (i.e. v0.7.1)

```bash
docker run --rm -v .:/data europe-west2-docker.pkg.dev/swirrl-devops-infrastructure-1/public/csv2rdf:v0.7.1 <ARGS>```
