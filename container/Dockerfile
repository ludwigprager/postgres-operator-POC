FROM alpine:3.18

RUN apk add --no-cache \
  curl wget jq postgresql-client \
  && update-ca-certificates

#ARG K3D_VERSION=5.6.0
#RUN curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=v${K3D_VERSION} sh

#ARG IONOSCTL_VERSION=6.7.1
#RUN wget https://github.com/ionos-cloud/ionosctl/releases/download/v$IONOSCTL_VERSION/ionosctl-${IONOSCTL_VERSION}-linux-amd64.tar.gz
#RUN tar zxvf ionosctl-${IONOSCTL_VERSION}-linux-amd64.tar.gz
#RUN mv ionosctl /usr/local/bin/

#ARG KUBECTL_VERSION=1.28.3
#RUN curl -LO https://dl.k8s.io/release/v$KUBECTL_VERSION/bin/linux/amd64/kubectl
#RUN chmod +x kubectl
#RUN mv kubectl /usr/local/bin/

#ARG TERRAFORM_VERSION=1.6.2
#RUN curl -LO https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
#RUN unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
#RUN chmod +x terraform
#RUN mv terraform /usr/local/bin/

#ARG HELM_VERSION=3.13.1
#RUN curl -LO https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz
#RUN tar zxvf helm-v${HELM_VERSION}-linux-amd64.tar.gz
#RUN chmod +x linux-amd64/helm
#RUN mv linux-amd64/helm /usr/local/bin/

WORKDIR /work/

