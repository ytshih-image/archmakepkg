FROM archlinux:base-devel

RUN pacman-key --init && pacman-key --populate
RUN pacman -Syu --needed --noconfirm nodejs minio-client git

ADD rootca.pem /root
RUN trust anchor /root/rootca.pem && update-ca-trust

RUN echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN useradd -G wheel -d /build builder

WORKDIR /build
ENTRYPOINT ["/usr/bin/env"]
CMD ["bash"]
