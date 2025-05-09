FROM debian:stable-slim

ARG TERRAFORM_VERSION

# hadolint ignore=DL3008
RUN set -ex; \
    apt-get --quiet=2 --assume-yes update; \
    apt-get --quiet=2 --assume-yes upgrade; \
    apt-get --quiet=2 --assume-yes --no-install-recommends --no-install-suggests install \
    curl \
    docker.io \
    gettext-base \
    git \
    jq \
    less \
    openssl \
    python3 \
    python3-pip \
    python3-venv \
    unzip; \
    apt-get --quiet=2 --assume-yes autoremove; \
    rm -rf /tmp/* /var/tmp/* /var/cache/apt/* /var/lib/apt/lists/*

RUN set -ex; \
    temp_arch="$(arch)"; \
    if [ "$temp_arch" = "x86_64" ]; then \
    curl "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip" --output "terraform_${TERRAFORM_VERSION}_linux_amd64.zip"; \
    unzip "terraform_${TERRAFORM_VERSION}_linux_amd64.zip" -d /usr/local/bin/; \
    terraform -install-autocomplete; \
    rm -rf terraform_${TERRAFORM_VERSION}_linux_amd64.zip; \
    elif [ "$temp_arch" = "aarch64" ]; then \
    curl "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_arm64.zip" --output "terraform_${TERRAFORM_VERSION}_linux_arm64.zip"; \
    unzip "terraform_${TERRAFORM_VERSION}_linux_arm64.zip" -d /usr/local/bin/; \
    terraform -install-autocomplete; \
    rm -rf terraform_${TERRAFORM_VERSION}_linux_arm64.zip; \
    else \
    echo "Unknown Architecture: $temp_arch"; \
    exit 1; \
    fi

WORKDIR /tmp

COPY requirements.txt /tmp/

# hadolint ignore=DL3013
RUN set -ex; \
    pip install --no-cache-dir --upgrade --break-system-packages pip; \
    pip install --no-cache-dir --upgrade --break-system-packages --use-pep517 --requirement requirements.txt; \
    rm -rf /tmp/* /var/tmp/* /var/cache/apt/* /var/lib/apt/lists/*

WORKDIR /usr/bin

RUN set -ex; \
    ln --symbolic python3 python

COPY docker-entrypoint.sh /usr/local/bin/

RUN set -ex; \
    chmod +x /usr/local/bin/docker-entrypoint.sh

WORKDIR /app

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]