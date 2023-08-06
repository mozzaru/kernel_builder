FROM docker.io/library/debian:bookworm-slim
ENV DEBIAN_FRONTEND noninteractive
COPY entrypoint.sh /entrypoint.sh
COPY ../*.sh /github/workspace
COPY ../toolchains /github/workspace
ENTRYPOINT [ "/entrypoint.sh" ]
