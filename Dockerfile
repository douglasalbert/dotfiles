# Dockerfile for testing configuration

FROM ubuntu:latest

RUN apt-get update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:neovim-ppa/stable && \
    add-apt-repository ppa:deadsnakes/ppa && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        vim \
        neovim \
        python3.7
RUN apt-get install -y \
        git

RUN useradd -u 10001 testuser
WORKDIR /home/testuser
COPY . .

USER testuser

CMD ["bash"]
