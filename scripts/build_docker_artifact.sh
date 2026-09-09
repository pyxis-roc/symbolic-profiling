#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
cd "${REPO_ROOT}"

IMAGE_TAG="${1:-symbolic-image:latest}"
ARCHIVE="${2:-symbolic-image-linux-amd64.tar.gz}"

docker build --network=host --platform=linux/amd64 \
    --build-arg USER_UID="$(id -u)" \
    --build-arg USER_GID="$(id -g)" \
    --tag "${IMAGE_TAG}" \
    -f Containerfile .

IMAGE_ARCH="$(docker image inspect --format '{{.Architecture}}' "${IMAGE_TAG}")"
if [[ "${IMAGE_ARCH}" != "amd64" ]]; then
    echo "Refusing to package ${IMAGE_TAG}: expected amd64, found ${IMAGE_ARCH}" >&2
    exit 1
fi

TEMP_ARCHIVE="${ARCHIVE}.tmp"
trap 'rm -f "${TEMP_ARCHIVE}"' EXIT
docker save "${IMAGE_TAG}" | gzip -1 > "${TEMP_ARCHIVE}"
mv "${TEMP_ARCHIVE}" "${ARCHIVE}"
sha256sum "${ARCHIVE}" > "${ARCHIVE}.sha256"

echo "Generated ${ARCHIVE}"
echo "Generated ${ARCHIVE}.sha256"
