ARG DISTRO=ubuntu
ARG VARIANT=jammy

FROM ${DISTRO}:${VARIANT}

ARG FEATURE_VERSION=master

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000

ARG VSCODE_URL=https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-x64

ARG CRD2PULUMI_VERSION=none
ARG DOCKER_COMPOSE_VERSION=none
ARG DOCKER_VERSION=none
ARG GO_VERSION=none
ARG HUGO_VERSION=none
ARG KUBECTL_VERSION=none
ARG NODE_VERSION=none
ARG PHP_COMPOSER_VERSION=none
ARG PHP_VERSION=none
ARG PHP_XDEBUG_VERSION=none
ARG PULUMI_VERSION=none
ARG PYTHON_VERSION=none
ARG RUST_VERSION=none

ENV CARGO_HOME=/usr/local/cargo
ENV GOPATH=/opt/go
ENV GOROOT=/usr/local/go
ENV NPM_HOME=/usr/local/npm

ENV PATH=${CARGO_HOME}/bin:${GOROOT}/bin:${GOPATH}/bin:${NPM_HOME}/bin:${PATH}

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes apt-utils ca-certificates curl gnupg2 pinentry-tty \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/images/ubuntu/setup.sh)" -- "${USERNAME}" "${USER_UID}" "${USER_GID}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/devtools/install.sh)" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/go/install.sh)" -- "${GO_VERSION}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/node/install.sh)" -- "${NODE_VERSION}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/php/install.sh)" -- "${PHP_VERSION}" "${PHP_COMPOSER_VERSION}" "${PHP_XDEBUG_VERSION}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/python/install.sh)" -- "${PYTHON_VERSION}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/rust/install.sh)" -- "${RUST_VERSION}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/docker/install.sh)" -- "${DOCKER_VERSION}" "${DOCKER_COMPOSE_VERSION}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/kubernetes/install.sh)" -- "${KUBECTL_VERSION}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/pulumi/install.sh)" -- "${PULUMI_VERSION}" "${CRD2PULUMI_VERSION}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/hugo/install.sh)" -- "${HUGO_VERSION}" \
 && curl -sSL ${VSCODE_URL} -o /tmp/code.tar.gz \
 && tar --directory=/usr/local/bin --extract --file /tmp/code.tar.gz \
 && apt-get remove pinentry-curses \
 && apt-get autoremove --yes \
 && apt-get clean --yes \
 && rm -rf /tmp/code.tar.gz \
 && rm -rf /var/lib/apt/lists/* \
 && echo "export GPG_TTY=\$(tty)" >> /home/${USERNAME}/.bashrc

ENTRYPOINT ["/usr/local/bin/code", "tunnel"]
