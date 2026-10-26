# stash-debian-ai

Image Docker [Stash](https://github.com/stashapp/stash) basée sur Debian (glibc), remplaçant direct de `stashapp/stash`.

L'image officielle est basée sur Alpine (musl), où PyTorch ne s'installe pas. Celle-ci permet aux plugins IA
comme Haven VLM Connector d'installer leurs dépendances (PyTorch en version CPU, OpenCV, decord).

## Différences avec `stashapp/stash`

- Base Debian au lieu d'Alpine ; mêmes chemins (`/root/.stash`), même utilisateur (root), même port (9999).
- Git inclus (exigé par PythonDepManager).
- `PIP_EXTRA_INDEX_URL` pointe vers l'index PyTorch CPU : pas de bibliothèques NVIDIA de plusieurs Go.
- Binaire Stash officiel, vérifié avec `CHECKSUMS_SHA1`.
- x86_64 uniquement.

## Utilisation

Remplacer `stashapp/stash:latest` par `ghcr.io/rometi/stash-debian-ai:latest`, sans rien changer d'autre.

## Mises à jour

GitHub Actions vérifie chaque jour la dernière version de Stash et ne publie une image que si elle est nouvelle.
L'image est aussi reconstruite le 1er de chaque mois pour les mises à jour de sécurité Debian.
Tags publiés : `latest` et `vX.Y.Z`.
