FROM alpine:latest

ARG VCS_REF
LABEL org.label-schema.vcs-ref=$VCS_REF \
      org.label-schema.vcs-url="https://github.com/jerheij/docker-proxy"
HEALTHCHECK --interval=30s --timeout=2s CMD nc -z localhost 80

COPY entry.sh /entry.sh
RUN apk update && \
    apk add nginx openssl shadow tzdata && \
    deluser $(getent passwd 33 | cut -d: -f1) && \
    delgroup $(getent group 33 | cut -d: -f1) 2>/dev/null || true && \
    chmod +x /entry.sh && \
    rm -rf /var/cache/apk/* && \
    rm -f /etc/nginx/conf.d/* && \
    chown nginx: /run/nginx
EXPOSE 80 443
ENTRYPOINT ["/entry.sh"]
CMD ["nginx", "-g", "daemon off;"]
