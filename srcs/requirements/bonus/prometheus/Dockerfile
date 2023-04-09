FROM alpine:3.16

RUN apk update && \
	apk add prometheus

COPY conf/prometheus.yml .

ENTRYPOINT prometheus --config.file=prometheus.yml
