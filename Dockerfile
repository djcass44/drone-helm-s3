FROM alpine:3.9

WORKDIR /app

COPY script.sh /app/script.sh

CMD ["sh", "-c", "/app/script.sh"]