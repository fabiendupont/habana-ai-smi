ARG BASE_DIGEST=""
ARG RHEL_VERSION=""

FROM registry.access.redhat.com/ubi8/ubi-minimal:${RHEL_VERSION} as rpms

ARG ARCH="x86_64"
ARG HABANA_VERSION=""
ARG RHEL_VERSION=""

WORKDIR /opt/habanalabs
RUN microdnf install cpio && microdnf clean all \
    && rpm2cpio https://vault.habana.ai/artifactory/rhel/8/${RHEL_VERSION}/habanalabs-firmware-tools-${HABANA_VERSION}.el8.${ARCH}.rpm | cpio -id

FROM registry.access.redhat.com/ubi8/ubi-minimal@${BASE_DIGEST}

ARG HABANA_VERSION=""
ARG RHEL_VERSION=""

LABEL io.k8s.description="Habana Labs SMI reports information about devices" \
      io.k8s.display-name="Habana Labs SMI" \
      io.openshift.release.operator=true \
      org.opencontainers.image.base.name="registry.access.redhat.com/ubi8/ubi-micro:${RHEL_VERSION}" \
      org.opencontainers.image.base.digest="${BASE_DIGEST}" \
      org.opencontainers.image.source="https://github.com/HabanaAI/habana-ai-smi" \
      org.opencontainers.image.vendor="Habana Labs" \
      org.opencontainers.image.title="Habana Labs SMI" \
      org.opencontainers.image.description="Habana Labs SMI reports information about devices" \
      maintainer="Habana Labs" \
      name="habana-ai-workload" \
      vendor="Habana Labs" \
      version="${HABANA_VERSION}"

RUN microdnf install lsof && microdnf clean all
COPY --from=rpms /opt/habanalabs/usr/bin/hl-smi /usr/bin/hl-smi

ENTRYPOINT ["/usr/bin/hl-smi"]
