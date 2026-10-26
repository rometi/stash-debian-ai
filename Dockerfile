# Stash sur Debian : équivalent de l'image officielle stashapp/stash (Alpine),
# mais avec glibc pour que PyTorch (requis par Haven VLM Connector) s'installe.
# Mêmes chemins (/root/.stash), même utilisateur (root), même port (9999).
FROM debian:trixie-slim

ARG STASH_VERSION

# Paquets équivalents à l'image officielle, plus git (exigé par PythonDepManager)
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates curl git tzdata ffmpeg libvips-tools \
        python3 python3-pip python3-requests python3-requests-toolbelt python3-lxml \
    && pip install --break-system-packages --no-cache-dir mechanicalsoup cloudscraper stashapp-tools \
    && rm -rf /var/lib/apt/lists/*

# Binaire officiel de Stash, vérifié avec la somme de contrôle publiée
RUN test -n "${STASH_VERSION}" \
    && cd /tmp \
    && curl -fsSLO "https://github.com/stashapp/stash/releases/download/v${STASH_VERSION}/stash-linux" \
    && curl -fsSLO "https://github.com/stashapp/stash/releases/download/v${STASH_VERSION}/CHECKSUMS_SHA1" \
    && grep ' stash-linux$' CHECKSUMS_SHA1 | sha1sum -c - \
    && install -m 755 stash-linux /usr/bin/stash \
    && rm -f stash-linux CHECKSUMS_SHA1

ENV STASH_CONFIG_FILE=/root/.stash/config.yml
# PyTorch en version CPU (sans les bibliothèques NVIDIA de plusieurs Go)
ENV PIP_EXTRA_INDEX_URL=https://download.pytorch.org/whl/cpu

LABEL org.opencontainers.image.title="stash-debian-ai" \
    org.opencontainers.image.description="stashapp/stash sur Debian (glibc), compatible PyTorch pour les plugins IA" \
    org.opencontainers.image.version="${STASH_VERSION}" \
    org.opencontainers.image.licenses="AGPL-3.0"

EXPOSE 9999
CMD ["stash"]
