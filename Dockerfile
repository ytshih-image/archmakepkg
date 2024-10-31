FROM archlinux:base-devel

RUN cat > /etc/pacman.d/mirrorlist <<'EOF'
Server = https://archlinux.cs.nycu.edu.tw/$repo/os/$arch
EOF

RUN cat >> /etc/pacman.conf <<'EOF'
[custom]
SigLevel = Optional TrustAll
Server = http://repo.konchin.com/$repo/os/$arch
EOF

RUN pacman-key --init && pacman-key --populate
RUN pacman -Syu --needed --noconfirm nodejs minio-client git

ADD rootca.pem /root
RUN trust anchor /root/rootca.pem && update-ca-trust

RUN echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' >> /etc/sudoers
RUN useradd -mG wheel -d /build builder

WORKDIR /build
ENTRYPOINT ["/usr/bin/env"]
CMD ["bash"]
