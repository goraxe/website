FROM golang:1.22-alpine AS build

RUN apk add --no-cache --repository=https://dl-cdn.alpinelinux.org/alpine/edge/community hugo && \
    apk add --update \
    wget \
    git

COPY ./ /site
WORKDIR /site

RUN <<EOT
go mod download
hugo --buildDrafts --destination ./output
EOT

FROM nginx:1.27.4-alpine-otel

COPY --from=build /site/output /usr/share/nginx/html

EXPOSE 80

#CMD [ "hugo", "server", "--disableFastRender", "--buildDrafts", "--watch", "--bind", "0.0.0.0"]
