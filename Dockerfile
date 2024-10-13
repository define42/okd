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
RUN openshift-install create manifests --dir=. 
RUN cp openshift backup_openshift -R
RUN cp manifests backup -R
RUN openshift-install create single-node-ignition-config

RUN coreos-installer iso ignition embed -fi bootstrap-in-place-for-live-iso.ign fcos-live.iso -o okd.iso

#RUN openshift-install version
#RUN openshift-install version

#RUN oc adm release info --output=json quay.io/openshift/okd:4.15.0-0.okd-2024-03-10-010116
#RUN oc adm release info --output=json quay.io/openshift/okd:4.15.0-0.okd-2024-03-10-010116
#RUN oc adm release info
FROM scratch AS export
COPY --from=builder /okd.iso /okd.iso
COPY --from=builder /auth /auth/
COPY --from=builder /backup /manifests
COPY --from=builder /backup_openshift /openshift
