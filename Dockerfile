FROM ubuntu:18.04
LABEL maintainer="Sean Cheung <theoxuanx@gmail.com>"

ARG CN_MIRROR=false
RUN if [ "$CN_MIRROR" = true ]; then sed -i 's#http://\(archive\|security\).ubuntu.com/#http://mirrors.aliyun.com/#' /etc/apt/sources.list; fi

RUN set -ex \
    && apt-get update \
    && echo "Install Dependencies..." \
    && apt-get update \
    && apt-get install -y --no-install-recommends curl ca-certificates unzip bash openssl \
    && echo "Clean Up..." \
    && rm -rf /var/lib/apt/lists/*

COPY entrypoint.sh /entrypoint.sh

VOLUME ["/data"]
EXPOSE 19132/udp

WORKDIR /var/bedrock
ENV LD_LIBRARY_PATH=.

ENTRYPOINT ["/entrypoint.sh"]
CMD ["/var/bedrock/bedrock_server"]