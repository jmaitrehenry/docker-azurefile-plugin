FROM alpine:3.6

RUN apk --update add ca-certificates cifs-utils
RUN mkdir -p /run/docker/plugins /var/lib/azurefile/volumes

ADD azurefile-driver /usr/bin/azurefile-driver

CMD [ "azurefile-driver" ]