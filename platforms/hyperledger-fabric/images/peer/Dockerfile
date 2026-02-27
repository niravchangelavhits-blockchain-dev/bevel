# Copyright Accenture. All Rights Reserved.
# SPDX-License-Identifier: Apache-2.0
#
# Dockerfile for Hyperledger Fabric Peer v3.0.0 with BFT (SmartBFT) support
# Builds from the official Hyperledger Fabric peer image

ARG FABRIC_VERSION=3.0.0

FROM hyperledger/fabric-peer:${FABRIC_VERSION}

LABEL org.opencontainers.image.title="bevel-fabric-peer" \
      org.opencontainers.image.description="Hyperledger Fabric Peer with BFT consensus support" \
      org.opencontainers.image.version="${FABRIC_VERSION}"

# BFT peer settings: disable leader election, enable org leader, use cluster delivery
ENV CORE_PEER_GOSSIP_USELEADERELECTION=false \
    CORE_PEER_GOSSIP_ORGLEADER=true \
    CORE_PEER_DELIVERYCLIENT_POLICY=cluster \
    CORE_PEER_DELIVERYCLIENT_BLOCKGOSSIPENABLED=false

EXPOSE 7051 7053 9443

ENTRYPOINT ["peer"]
CMD ["node", "start"]
