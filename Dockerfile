ARG BASE_DIGEST=""
ARG RHEL_VERSION=""

FROM registry.access.redhat.com/ubi8/ubi-minimal:${RHEL_VERSION} as rpms

ARG ARCH="x86_64"
ARG HABANA_VERSION=""

WORKDIR /opt/habanalabs
RUN microdnf install cpio && microdnf clean all \
    && rpm2cpio https://vault.habana.ai/artifactory/centos/8/8.3/habanalabs-firmware-tools-${HABANA_VERSION}.el8.${ARCH}.rpm | cpio -id

FROM registry.access.redhat.com/ubi8/ubi-micro@${BASE_DIGEST}

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

COPY --from=rpms /opt/habanalabs/usr/bin/hl-smi /usr/bin/hl-smi
COPY --from=rpms /opt/habanalabs/usr/lib/habanalabs/libhlml.a /usr/lib/habanalabs/libhlml.a
COPY --from=rpms /opt/habanalabs/usr/lib/habanalabs/libhlml.so /usr/lib/habanalabs/libhlml.so
COPY --from=rpms /opt/habanalabs/usr/share/licenses/habanalabs-firmware-tools-1.4.1/ /usr/share/licenses/habanalabs-firmware-tools-1.4.1/

ENTRYPOINT ["/usr/bin/hl-smi"]
