# Habana Labs SMI Container

This repository contains everything needed to build a container image with the
Habana Labs SMI (`hl-smi`) command that allows getting info about Habana AI
accelerators.

## Manual build of the container image

Below is an example for building a container image for the version `1.4.1-11` of
the Habana AI driver.

```shell
export ARCH="x86_64"
export BASE_DIGEST="sha256:083521e65708a64070058313e3d7389e4fcbaa79a7b2f5c6607cc341dfef6f2c"
export HABANA_VERSION="1.4.1-11"
export RHEL_VERSION="8.6"
```

```shell
podman build \
    --build-arg ARCH=${ARCH} \
    --build-arg BASE_DIGEST=${BASE_DIGEST} \
    --build-arg HABANA_VERSION=${HABANA_VERSION} \
    --build-arg RHEL_VERSION=${RHEL_VERSION} \
    --tag ghcr.io/fabiendupont/habana-ai-smi:${HABANA_VERSION} \
    --file Dockerfile .
```

For that image to be usable in our OpenShift clusters, we simply push it to
ghcr.io.

```shell
podman login ghcr.io
podman push ghcr.io/fabiendupont/habana-ai-smi:${HABANA_VERSION}
```

## Maintain a library of Habana AI SMI images

<mark>TODO</mark>
