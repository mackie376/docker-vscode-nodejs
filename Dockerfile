FROM node:14.17.6-bullseye-slim
LABEL maintainer="Takashi Makimoto <mackie@beehive-dev.com>"

EXPOSE 8000

ARG USER=user
ARG GROUP=user
ARG PASS=password
ARG UID=1000
ARG GID=1000

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND=noninteractive

RUN \
      apt-get update && \
      apt-get install -y --no-install-recommends \
        bash \
        ca-certificates \
        curl \
        git \
        git-lfs \
        gnupg \
        libc6 \
        libstdc++6 \
        locales \
        python3.9-minimal \
        sudo \
        openssh-client \
        tar \
        wget && \
      userdel -r node && \
      groupadd -g "$GID" "$GROUP" && \
      useradd -m -s /bin/bash -u "$UID" -g "$GID" "$USER" && \
      usermod -aG sudo "$USER" && \
      echo "${USER}:${PASS}" | chpasswd && \
      sed -i -E 's/# (ja_JP.UTF-8)/\1/' /etc/locale.gen && \
      locale-gen && \
      mkdir /run/sshd && \
      apt-get clean && \
      rm -rf /var/lib/apt/lists/*

COPY "${PWD}/entrypoint.sh" /usr/local/bin

USER "$USER"
WORKDIR "/home/${USER}"

RUN mkdir -p "/home/${USER}/.config/git"

ENV SHELL=/bin/bash \
    PATH="/home/${USER}/.yarn/bin:$PATH" \
    LANGUAGE=en_US:en \
    LANG=ja_JP.UTF-8

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
