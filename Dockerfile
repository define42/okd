FROM rockylinux:9 AS builder
RUN yum install -y wget
RUN wget https://github.com/okd-project/okd/releases/download/4.15.0-0.okd-2024-03-10-010116/openshift-install-linux-4.15.0-0.okd-2024-03-10-010116.tar.gz
RUN wget https://github.com/okd-project/okd/releases/download/4.15.0-0.okd-2024-03-10-010116/openshift-client-linux-4.15.0-0.okd-2024-03-10-010116.tar.gz
RUN tar -zxvf openshift-client-linux-4.15.0-0.okd-2024-03-10-010116.tar.gz
RUN tar -zxvf openshift-install-linux-4.15.0-0.okd-2024-03-10-010116.tar.gz
RUN mv oc kubectl openshift-install /usr/local/bin/
RUN yum install -y coreos-installer

ENV ARCH=x86_64
RUN export ISO_URL=$(openshift-install coreos print-stream-json | grep location | grep $ARCH | grep iso | cut -d\" -f4) && curl -L $ISO_URL -o fcos-live.iso

COPY install-config.yaml .
RUN openshift-install create single-node-ignition-config


RUN coreos-installer iso ignition embed -fi bootstrap-in-place-for-live-iso.ign fcos-live.iso -o okd.iso
#RUN wget https://builds.coreos.fedoraproject.org/prod/streams/stable/builds/40.20240920.3.0/x86_64/fedora-coreos-40.20240920.3.0-live.x86_64.iso
#RUN ls -la
#RUN ls -la fedora-coreos-40.20240920.3.0-live.x86_64.iso
#RUN coreos-installer iso ignition embed -i bootstrap-in-place-for-live-iso.ign fedora-coreos-40.20240920.3.0-live.x86_64.iso -o okd.iso
#RUN coreos-installer iso ignition embed -fi bootstrap-in-place-for-live-iso.ign fcos-live.iso
#RUN ls -la okd.iso
RUN ls -la

FROM scratch AS export
COPY --from=builder /okd.iso /okd.iso
COPY --from=builder /auth /auth/
