FROM golang:1.22-alpine AS build

RUN apk add --update \
    wget \
    git

ARG HUGO_VERSION="0.127.0"
RUN wget --quiet "https://github.com/gohugoio/hugo/releases/download/v${HUGO_VERSION}/hugo_${HUGO_VERSION}_Linux-64bit.tar.gz" && \
    tar xzf hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    rm -r hugo_${HUGO_VERSION}_Linux-64bit.tar.gz && \
    mv hugo /usr/bin

COPY ./ /site
WORKDIR /site

RUN ["hugo", "--buildDrafts", "--destination", "./output"]

FROM nginx:1.27.3-alpine-otel

COPY --from=build /site/output /usr/share/nginx/html

EXPOSE 80

#CMD [ "hugo", "server", "--disableFastRender", "--buildDrafts", "--watch", "--bind", "0.0.0.0"]
