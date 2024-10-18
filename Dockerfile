FROM archlinux:base-devel

RUN pacman-key --init && pacman-key --populate
RUN pacman -Syu --needed --noconfirm nodejs minio-client

RUN echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN useradd -G wheel -d /build builder
RUN mkdir /script
COPY run.sh /script

ENV MINIO_HOST="minio.konchin.com"
ENV MINIO_PORT="9000"
ENV MINIO_BUCKET="archrepo"
ENV MINIO_ACCESSKEY=""
ENV MINIO_SECRETKEY=""

ENV REPO_NAME="custom"

WORKDIR /build
ENTRYPOINT ["/usr/bin/env"]
CMD ["/script/run.sh"]
