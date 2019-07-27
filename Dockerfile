FROM debian:buster AS base

# This code is adapted from:
#     https://gist.github.com/dergachev/8441335#gistcomment-2007024
ENV DEBIAN_FRONTEND=noninteractive

## When installed using `apt install squid-deb-proxy`, it listens on port 8000 on the host by dfault.
## Override this variable with "" can disable apt proxy.
ARG APT_PROXY_PORT=8000
COPY detect-apt-proxy.sh /root
RUN /root/detect-apt-proxy.sh ${APT_PROXY_PORT}

# Install dependencies
RUN apt-get update && apt-get dist-upgrade -y
RUN apt-get install -y --no-install-recommends nodejs npm git apt-utils

# Install git-cache-http-server
RUN npm install -g git-cache-http-server

# Setup automatic task to run at 01:30
# Install coreutils for command sleep
RUN apt-get install -y --no-install-recommends coreutils
COPY git-gc.sh /root/
COPY start.sh /root/

# Clean apt-get cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
# Clean npm cache
RUN npm cache clean --force

# Remove useless package
RUN apt-get remove -y apt-utils npm
RUN apt-get autoremove -y

# Clean apt-proxy
COPY remove-apt-proxy.sh /root/
RUN /root/remove-apt-proxy.sh
# Clean scripts
RUN rm /root/detect-apt-proxy.sh /root/remove-apt-proxy.sh

# Config git to tradeoff cache size over decompression time
RUN git config --global core.compression 9
RUN git config --global core.looseCompression 9
RUN git config --global pack.compression 9

# Workaround the problem that multi-stage build cannot copy files between stages when 
# usernamespace is enabled.
RUN chown -R root:root $(ls / | grep -v -e "dev" -e "sys" -e "tmp" -e "proc") || echo

FROM debian:buster
COPY --from=base / /
EXPOSE 8080
CMD ["/root/start.sh"]
