FROM buildpack-deps:buster
#
# Install nix
# https://github.com/heathdrobertson/ubuntu_nix/blob/main/Dockerfile.
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

#
# Install rust
# https://github.com/rust-lang/docker-rust/blob/master/1.50.0/buster/Dockerfile
ENV RUSTUP_HOME=/usr/local/rustup \
    CARGO_HOME=/usr/local/cargo \
    PATH=/usr/local/cargo/bin:$PATH \
    RUST_VERSION=1.50.0

RUN set -eux; \
    dpkgArch="$(dpkg --print-architecture)"; \
    case "${dpkgArch##*-}" in \
        amd64) rustArch='x86_64-unknown-linux-gnu'; rustupSha256='ed7773edaf1d289656bdec2aacad12413b38ad0193fff54b2231f5140a4b07c5' ;; \
        armhf) rustArch='armv7-unknown-linux-gnueabihf'; rustupSha256='7a7b9d246ad63358705d8d4a7d5c2ef1adfec24525d1d5c44a7739e1b867e84d' ;; \
        arm64) rustArch='aarch64-unknown-linux-gnu'; rustupSha256='f80a0a792b3ab905ab4919474daf4d3f60e574fc6987e69bfba2fd877241a8de' ;; \
        i386) rustArch='i686-unknown-linux-gnu'; rustupSha256='4473c18286aa1831683a772706d9a5c98b87a61cc014d38063e00a63a480afef' ;; \
        *) echo >&2 "unsupported architecture: ${dpkgArch}"; exit 1 ;; \
    esac; \
    url="https://static.rust-lang.org/rustup/archive/1.23.1/${rustArch}/rustup-init"; \
    wget "$url"; \
    echo "${rustupSha256} *rustup-init" | sha256sum -c -; \
    chmod +x rustup-init; \
    ./rustup-init -y --no-modify-path --profile minimal --default-toolchain $RUST_VERSION --default-host ${rustArch}; \
    rm rustup-init; \
    chmod -R a+w $RUSTUP_HOME $CARGO_HOME; \
    rustup --version; \
    cargo --version; \
    rustc --version;

#
# Install packages
RUN apt-get update && \
    apt-get install -y git-annex

RUN nix-env -iA nixpkgs.shunit2

RUN cargo install --version 0.7.2 hal

RUN apt-get install -y jq

COPY fzf /fzf

WORKDIR /fzf

RUN bash -c "chmod +x install && yes | ./install"

# immutag install
WORKDIR /Downloads
WORKDIR /Downloads/immutag
COPY dev /Downloads/immutag/dev
WORKDIR /Downloads/immutag/dev
RUN bash -c "chmod +x install && yes | ./install"

#WORKDIR $HOME/.local
#WORKDIR $HOME/.local/bin
#WORKDIR $HOME/.local/bin/immutag
#
#COPY dev/add_file.sh $HOME/.local/bin/immutag/_add_file

WORKDIR /immutag/dev
