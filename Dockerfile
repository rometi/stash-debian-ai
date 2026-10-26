# Stash on Debian: equivalent to the official stashapp/stash image (Alpine),
# but with glibc so that PyTorch (required by Haven VLM Connector) can be installed.
# Same paths (/root/.stash), same user (root), same port (9999).
FROM debian:trixie-slim

ARG STASH_VERSION

# Same packages as the official image, plus git (required by PythonDepManager)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates curl git tzdata ffmpeg libvips-tools \
        python3 python3-pip python3-requests python3-requests-toolbelt python3-lxml \
    && pip install --break-system-packages --no-cache-dir mechanicalsoup cloudscraper stashapp-tools \
    && rm -rf /var/lib/apt/lists/*

# Official Stash binary, verified against the published checksum
RUN test -n "${STASH_VERSION}" \
    && cd /tmp \
    && curl -fsSLO "https://github.com/stashapp/stash/releases/download/v${STASH_VERSION}/stash-linux" \
    && curl -fsSLO "https://github.com/stashapp/stash/releases/download/v${STASH_VERSION}/CHECKSUMS_SHA1" \
    && grep ' stash-linux$' CHECKSUMS_SHA1 | sha1sum -c - \
    && install -m 755 stash-linux /usr/bin/stash \
    && rm -f stash-linux CHECKSUMS_SHA1

ENV STASH_CONFIG_FILE=/root/.stash/config.yml
# CPU-only PyTorch (avoids several GB of NVIDIA libraries)
ENV PIP_EXTRA_INDEX_URL=https://download.pytorch.org/whl/cpu

LABEL org.opencontainers.image.title="stash-debian-ai" \
    org.opencontainers.image.description="stashapp/stash on Debian (glibc), PyTorch-compatible for AI plugins" \
    org.opencontainers.image.version="${STASH_VERSION}" \
    org.opencontainers.image.licenses="AGPL-3.0"

EXPOSE 9999
CMD ["stash"]
