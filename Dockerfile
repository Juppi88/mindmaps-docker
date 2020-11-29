FROM nginx:alpine

RUN addgroup -S mindmaps && \
    adduser -S mindmaps -G mindmaps

RUN apk update && \
    apk add --no-cache git && \
    apk add --no-cache wget && \
    apk add --no-cache nodejs npm && \
    npm install -g jake

RUN line=$(cat /etc/nginx/mime.types | grep -n text/x-component | grep -o '^[0-9]*') && \
    sed -i "$line"'i\    text/cache-manifest appcache;' /etc/nginx/mime.types

ADD nginx.conf /etc/nginx/

RUN chown -Rf mindmaps:mindmaps /opt

USER mindmaps

RUN cd /opt && \
    git clone https://github.com/drichard/mindmaps.git && \
    cd /opt/mindmaps && \
    npm install && \
    jake

USER root

EXPOSE 80

ENTRYPOINT ["/usr/sbin/nginx"]

