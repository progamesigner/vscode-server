ARG DISTRO=ubuntu
ARG VARIANT=jammy

FROM ${DISTRO}:${VARIANT}

ARG FEATURE_VERSION=master
ARG VSCODE_URL=

ARG USERNAME=vscode
ARG USER_UID=1000
ARG USER_GID=1000

ENV CARGO_HOME=/usr/local/cargo
ENV GOPATH=/opt/go
ENV GOROOT=/usr/local/go
ENV NPM_HOME=/usr/local/npm

ENV PATH=${CARGO_HOME}/bin:${GOROOT}/bin:${GOPATH}/bin:${NPM_HOME}/bin:${PATH}

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install --no-install-recommends --yes apt-utils ca-certificates curl gnupg2 lsb-release pinentry-tty \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/images/ubuntu/setup.sh)" -- "${USERNAME}" "${USER_UID}" "${USER_GID}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/devtools/install.sh)" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/android/install.sh)" -- "${ANDROID_PLATFORM_VERSION:-none}" "${ANDROID_BUILD_TOOLS_VERSION:-none}" "${ANDROID_EXTRA_COMPONENTS:-}" "${ANDROID_COMMANDLINE_VERSION:-none}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/aws-cli/install.sh)" -- "${AWS_CLI_VERSION:-none}" "${AWS_CLI_SSM_PLUGIN:-false}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/blackbox/install.sh)" -- "${BLACKBOX_VERSION:-none}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/deno/install.sh)" -- "${DENO_VERSION:-none}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/docker/install.sh)" -- "${DOCKER_VERSION:-none}" "${DOCKER_BUILDX_VERSION:-none}" "${DOCKER_COMPOSE_VERSION:-none}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/flutter/install.sh)" -- "${FLUTTER_VERSION:-none}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/gcloud-cli/install.sh)" -- "${GCLOUD_CLI_VERSION:-none}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/go/install.sh)" -- "${GO_VERSION:-none}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/hugo/install.sh)" -- "${HUGO_VERSION:-none}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/java/install.sh)" -- "${JAVA_VERSION:-none}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/k6/install.sh)" -- "${K6_VERSION:-none}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/kubernetes/install.sh)" -- "${KUBECTL_VERSION:-none}" "${HELM_VERSION:-none}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/node/install.sh)" -- "${NODE_VERSION:-none}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/php/install.sh)" -- "${PHP_VERSION:-none}" "${PHP_COMPOSER_VERSION:-none}" "${PHP_XDEBUG_VERSION:-none}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/pulumi/install.sh)" -- "${PULUMI_VERSION:-none}" "${CRD2PULUMI_VERSION:-none}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/python/install.sh)" -- "${PYTHON_VERSION:-none}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/ruby/install.sh)" -- "${RUBY_VERSION:-none}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/rust/install.sh)" -- "${RUST_VERSION:-none}" \
 && bash -c "$(curl -fsSL https://raw.githubusercontent.com/progamesigner/devcontainers/${FEATURE_VERSION}/features/terraform/install.sh)" -- "${TERRAFORM_VERSION:-none}" \
 # Temporal fix for SSL_ERROR_SYSCALL error on arm64
 # see: https://github.com/curl/curl/issues/14154
 && if [ "$(dpkg --print-architecture)" = "arm64" ] && [ "$(cat /etc/os-release | grep VERSION_CODENAME | cut -d '=' -f2)" = "noble" ]; then echo 'insecure' >> ~/.curlrc; fi \
 && curl -sSL ${VSCODE_URL} -o /tmp/code.tar.gz \
 && tar --directory=/usr/local/bin --extract --file /tmp/code.tar.gz \
 && apt-get remove pinentry-curses \
 && apt-get autoremove --yes \
 && apt-get clean --yes \
 && rm -rf /tmp/code.tar.gz \
 && rm -rf /var/lib/apt/lists/* \
 && echo "export GPG_TTY=\$(tty)" >> /home/${USERNAME}/.bashrc

USER ${USERNAME}

WORKDIR /home/${USERNAME}

ENTRYPOINT ["/usr/local/bin/code", "tunnel", "--no-sleep"]
