# Copyright Accenture. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0
#
# Dockerfile for Hyperledger Fabric Orderer v3.0.0 with BFT (SmartBFT) support
# Builds from the official Hyperledger Fabric orderer image

ARG FABRIC_VERSION=3.0.0

FROM hyperledger/fabric-orderer:${FABRIC_VERSION}

LABEL org.opencontainers.image.title="bevel-fabric-orderer" \
      org.opencontainers.image.description="Hyperledger Fabric Orderer with BFT consensus support" \
      org.opencontainers.image.version="${FABRIC_VERSION}"

# BFT orderer uses channel participation API (BOOTSTRAPMETHOD=none)
# WAL dir for SmartBFT write-ahead logs must be on persistent storage
ENV ORDERER_GENERAL_BOOTSTRAPMETHOD=none \
    ORDERER_CHANNELPARTICIPATION_ENABLED=true

EXPOSE 7050 7055 9443

ENTRYPOINT ["orderer"]
