FROM docker.io/library/debian:bookworm-slim
ENV DEBIAN_FRONTEND noninteractive
COPY entrypoint.sh /entrypoint.sh
COPY *.sh /github/workspace
RUN mkdir /github/workspace/toolchains
COPY toolchains/* /github/workspace/toolchains/*
ENTRYPOINT [ "/entrypoint.sh" ]
