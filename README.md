# stash-debian-ai

Debian-based (glibc) Docker image for [Stash](https://github.com/stashapp/stash), a drop-in replacement for `stashapp/stash`.

The official image is based on Alpine (musl), where PyTorch cannot be installed. This one lets AI plugins
such as Haven VLM Connector install their dependencies (CPU-only PyTorch, OpenCV, decord).

## Differences from `stashapp/stash`

- Debian base instead of Alpine; same paths (`/root/.stash`), same user (root), same port (9999).
- Git included (required by PythonDepManager).
- `PIP_EXTRA_INDEX_URL` points to the PyTorch CPU index: no multi-GB NVIDIA libraries.
- Official Stash binary, verified against `CHECKSUMS_SHA1`.
- x86_64 only.

## Usage

Replace `stashapp/stash:latest` with `ghcr.io/rometi/stash-debian-ai:latest`; nothing else needs to change.

## Updates

GitHub Actions checks for the latest Stash release every day and only publishes an image when it is new.
The image is also rebuilt on the 1st of each month to pick up Debian security updates.
Published tags: `latest` and `vX.Y.Z`.
