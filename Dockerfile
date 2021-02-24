FROM rust:1.50.0

RUN cargo install --version 0.7.2 hal

COPY fzf /fzf

WORKDIR /fzf

RUN bash -c "chmod +x install && yes | ./install"

WORKDIR /immutag
