FROM ubuntu:latest

HEALTHCHECK --interval=30s --timeout=2s CMD nc -z localhost 80

COPY entry.sh /entry.sh
RUN apt-get update && \
    apt-get install curl gnupg -y && \
    curl -L https://nginx.org/keys/nginx_signing.key | apt-key add - && \
    echo "deb https://nginx.org/packages/mainline/ubuntu/ $(grep UBUNTU_CODENAME /etc/os-release | cut -d "=" -f2) nginx" >> /etc/apt/sources.list.d/nginx.list && \
    echo "deb-src https://nginx.org/packages/mainline/ubuntu/ $(grep UBUNTU_CODENAME /etc/os-release | cut -d "=" -f2) nginx" >> /etc/apt/sources.list.d/nginx.list && \
    apt-get purge curl gnupg -y && \
    apt-get autoremove -y && \
    apt-get update && \
    apt-get install -y nginx openssl tzdata && \
    apt-get upgrade -y && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +x /entry.sh && \
    rm -f /etc/nginx/conf.d/*
EXPOSE 80 443
ENTRYPOINT ["/entry.sh"]
CMD ["nginx", "-g", "daemon off;"]
