#!/usr/bin/env bash
set -e

mkdir -p var

if ! [ -x "$(command -v rsync)" ]; then
  echo 'rsync needs to be installed!'
  sudo apt-get install -y rsync
fi

echo 'Syncing files for local CUDA apt repo...'
rsync -aq /var/cuda-repo-10-2-local-10.2.89/ var/cuda-repo

echo 'Exporting repo keys...'
export APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=DontWarn
apt-key exportall > apt-trusted-keys

echo 'Building cuda-jetpack:4.4-base container...'
sudo DOCKER_BUILDKIT=1 docker build \
    -t cuda-jetpack:4.4-base \
    --build-arg BASE_IMAGE=debian:sid-slim \
    -f Dockerfile.base .

echo 'Building cuda-jetpack:4.4-runtime container...'
sudo DOCKER_BUILDKIT=1 docker build \
    -t cuda-jetpack:4.4-runtime \
    --build-arg BASE_IMAGE=cuda-jetpack:4.4-base \
    -f Dockerfile.runtime .

echo 'Building cuda-jetpack:4.4-devel container...'
sudo DOCKER_BUILDKIT=1 docker build \
    -t cuda-jetpack:4.4-devel \
    --build-arg BASE_IMAGE=cuda-jetpack:4.4-runtime \
    -f Dockerfile.devel .

sudo docker build -t rnvblas --build-arg BASE_IMAGE=cuda-jetpack:4.4-devel -f Dockerfile.rnvblas .

