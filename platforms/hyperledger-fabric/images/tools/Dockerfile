# Copyright Accenture. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0
#
# Dockerfile for bevel-fabric-tools v3.0.0
# Provides configtxgen, peer CLI and other Fabric v3.0 tools needed by Bevel genesis and chaincode jobs.
# NOTE: hyperledger/fabric-tools:3.0.0 does not exist on Docker Hub.
# This image downloads the official Fabric v3.0.0 release binaries from GitHub.

ARG FABRIC_VERSION=3.0.0
ARG TARGETARCH=amd64

FROM alpine:3.19

LABEL org.opencontainers.image.title="bevel-fabric-tools" \
      org.opencontainers.image.description="Hyperledger Fabric CLI tools (configtxgen, peer) for Bevel automation" \
      org.opencontainers.image.version="${FABRIC_VERSION}"

ARG FABRIC_VERSION
ARG TARGETARCH

RUN apk add --no-cache \
      bash \
      curl \
      jq \
      libc6-compat \
      openssl \
      tar \
      wget \
    && FABRIC_RELEASE="hyperledger-fabric-linux-${TARGETARCH}-${FABRIC_VERSION}.tar.gz" \
    && wget -q "https://github.com/hyperledger/fabric/releases/download/v${FABRIC_VERSION}/${FABRIC_RELEASE}" -O /tmp/fabric.tar.gz \
    && tar -xzf /tmp/fabric.tar.gz -C /usr/local --strip-components=1 \
    && rm /tmp/fabric.tar.gz \
    && chmod +x /usr/local/bin/configtxgen /usr/local/bin/peer \
    && configtxgen --version \
    && peer version

ENV FABRIC_CFG_PATH=/etc/hyperledger/fabric

WORKDIR /opt/gopath/src/github.com/hyperledger/fabric/peer

CMD ["sh"]
