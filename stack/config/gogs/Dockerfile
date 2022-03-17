FROM alpine:3.15

LABEL Author="Francis Ouellet <fouellet@dminc.com>"
LABEL Description="Base on Alpine"

ENV CONTAINER_NAME gogs
ENV CONTAINER_IMAGE ghandalf/gogs:${CONTAINERS_VERSION}
ENV CONTAINER_VERSION ${CONTAINERS_VERSION}
ENV APP_USER gogs
ENV APP_GROUP ggroup
ENV APP_HOME /usr/share/gogs

ENV GOGS_PORT_HTTP 32294
ENV GOGS_PORT_SSH 32292
ENV GOGS_PORT_HTTPS 32293

RUN mkdir -p ${APP_HOME}/data ${APP_HOME}/logs 

RUN apk add postgresql git wget

RUN wget https://dl.gogs.io/0.11.79/gogs_0.11.79_linux_amd64.tar.gz -P ${APP_HOME} \
    && tar xzf ${APP_HOME}/gogs* -C ${APP_HOME}/

EXPOSE ${GOGS_PORT_HTTP}
EXPOSE ${GOGS_PORT_SSH}
EXPOSE ${GOGS_PORT_HTTPS}

USER ${APP_USER}
ENTRYPOINT [ "/bin/sh" ]