FROM rust:1.50.0

RUN cargo install --version 0.7.2 hal

COPY fzf /fzf

WORKDIR /fzf

RUN bash -c "chmod +x install && yes | ./install"

RUN apt-get update && \
    apt-get install -y git-annex

RUN apt-get update --fix-missing && apt-get install \
    systemd systemd-sysv curl wget git xz-utils -y \
    && echo hosts: dns files > /etc/nsswitch.conf

RUN apt-get clean && apt-get purge && apt-get autoremove --purge -y

WORKDIR /
# Download Nix and install it into the system.
ARG NIX_VERSION=2.3.10
RUN wget https://nixos.org/releases/nix/nix-${NIX_VERSION}/nix-${NIX_VERSION}-x86_64-linux.tar.xz \
    && tar xf nix-${NIX_VERSION}-x86_64-linux.tar.xz \
    && addgroup --system --gid 30000 nixbld \
    && adduser --disabled-login --disabled-password --gecos --create-home --uid 1000 --ingroup nixbld ci \
    && for i in $(seq 1 30); do groupadd --system nixbld$i; done \
    && for i in $(seq 1 30); do useradd --system --uid $((30000 + i)) --comment "Nix build user $i" --groups nixbld,nixbld$i nix$i; done \
    && mkdir -m 0755 /etc/nix \
    && echo 'sandbox = false' > /etc/nix/nix.conf \
    && mkdir -m 0755 /nix \
    && chown -R ci:nixbld /nix \
    && USER=ci /bin/bash /nix-${NIX_VERSION}-x86_64-linux/install \
    && . /root/.nix-profile/etc/profile.d/nix.sh \
    && ln -s /nix/var/nix/profiles/default/etc/profile.d/nix.sh /etc/profile.d/ \
    && rm -r /nix-${NIX_VERSION}-x86_64-linux* \
    && rm -rf /var/cache/apt/* \
    && /nix/var/nix/profiles/default/bin/nix-collect-garbage --delete-old \
    && /nix/var/nix/profiles/default/bin/nix-store --optimise \
    && /nix/var/nix/profiles/default/bin/nix-store --verify --check-contents \
    && cp -r /nix/var/nix/profiles/per-user/root /nix/var/nix/profiles/per-user/ci \
    && chown -R ci:nixbld /nix/var/nix/profiles/per-user/ci \
    && ln -s /nix/var/nix/profiles/default /home/ci/.nix-profile \
    && chown -R ci:nixbld /nix



ONBUILD ENV \
    ENV=/etc/profile \
    USER=ci \
    PATH=/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin \
    GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt \
    NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt

ENV \
    ENV=/etc/profile \
    USER=ci \
    PATH=/nix/var/nix/profiles/default/bin:/nix/var/nix/profiles/default/sbin:/bin:/sbin:/usr/bin:/usr/sbin \
    GIT_SSL_CAINFO=/etc/ssl/certs/ca-certificates.crt \
    NIX_SSL_CERT_FILE=/etc/ssl/certs/ca-certificates.crt \
    NIX_PATH=/nix/var/nix/profiles/per-user/root/channels


RUN nix-channel --add https://nixos.org/channels/nixpkgs-unstable nixpkgs
RUN nix-channel --update; nix-env -iA nixpkgs.nix

RUN nix-env -iA nixpkgs.shunit2

WORKDIR /immutag

# Nix install section is from https://github.com/heathdrobertson/ubuntu_nix/blob/main/Dockerfile.
