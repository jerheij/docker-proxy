FROM ubuntu:latest

HEALTHCHECK --interval=30s --timeout=2s CMD nc -z localhost 80

COPY entry.sh /entry.sh
COPY rootfs /
RUN echo "TEMP FIX TO RUN BUILD SUCCESSFULLY:" && \
    sed -i -e 's/^APT/# APT/' -e 's/^DPkg/# DPkg/' /etc/apt/apt.conf.d/docker-clean && \
    apt-get update && \
    apt-get install wget ca-certificates gnupg2 lsb-release ubuntu-keyring -y && \
    wget https://nginx.org/keys/nginx_signing.key && \ 
    cat nginx_signing.key | gpg --dearmor | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null && \
    rm nginx_signing.key && \
    echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] http://nginx.org/packages/mainline/ubuntu `lsb_release -cs` nginx" | tee /etc/apt/sources.list.d/nginx.list && \
    apt-get update && \
    apt-get install -y nginx openssl tzdata netcat && \
    apt-get upgrade -y && \
    apt-get purge wget gnupg2 -y && \
    apt-get autoremove -y && \
    apt-get clean all && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +x /entry.sh && \
    rm -f /etc/nginx/conf.d/*
EXPOSE 80 443
ENTRYPOINT ["/entry.sh"]
CMD ["nginx", "-g", "daemon off;"]
