FROM alpine:3.9

# install dependencies
RUN apk update && \
    apk add bash git wget curl gzip tar --no-cache && \
    rm -rf /var/cache/apk/*

# set env
ENV HELM_VERSION=v2.14.0 \
    HELM_S3_VERSION=v0.8.0

WORKDIR /app

# install helm
RUN curl -o helm-linux-amd64.tar.gz https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
    tar -zxvf helm-linux-amd64.tar.gz && \
    chmod +x linux-amd64/helm && \
    mv linux-amd64/helm /usr/local/bin/ && \
    rm -rf linux-amd64 helm-linux-amd64.tar.gz

RUN helm init --client-only && \
    helm plugin install https://github.com/hypnoglow/helm-s3.git --version ${HELM_S3_VERSION}

COPY script.sh /app/script.sh

CMD ["sh", "-c", "/app/script.sh"]