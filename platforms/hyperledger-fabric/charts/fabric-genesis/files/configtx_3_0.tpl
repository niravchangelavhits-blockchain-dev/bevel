# Configtx template for Fabric 3.0.x with BFT (SmartBFT) consensus
Organizations:
{{- range $org := $.Values.organizations }}
  - &{{ $org.name }}Org
    Name: {{ $org.name }}MSP
    ID: {{ $org.name }}MSP
    MSPDir: ./crypto-config/organizations/{{ $org.name }}/msp
    Policies:
      Readers:
        Type: Signature
        Rule: "OR('{{ $org.name }}MSP.member')"
      Writers:
        Type: Signature
        Rule: "OR('{{ $org.name }}MSP.member')"
      Admins:
        Type: Signature
        Rule: "OR('{{ $org.name }}MSP.admin')"
      Endorsement:
        Type: Signature
        Rule: "OR('{{ $org.name }}MSP.member')"
  {{- if $org.orderers }}
    OrdererEndpoints:
    {{- range $orderer := $org.orderers }}
      - {{ $orderer.ordererAddress }}
    {{- end }}
  {{- end }}
  {{- printf "\n" }}
{{- end }}

Capabilities:
  Channel: &ChannelCapabilities
    V3_0: true
  Orderer: &OrdererCapabilities
    V2_0: true
  Application: &ApplicationCapabilities
    V2_5: true

Application: &ApplicationDefaults
  Organizations:
  Policies:
    LifecycleEndorsement:
        Type: ImplicitMeta
        Rule: "MAJORITY Endorsement"
    Endorsement:
        Type: ImplicitMeta
        Rule: "MAJORITY Endorsement"
    Readers:
        Type: ImplicitMeta
        Rule: "ANY Readers"
    Writers:
        Type: ImplicitMeta
        Rule: "ANY Writers"
    Admins:
        Type: ImplicitMeta
        Rule: "MAJORITY Admins"
  Capabilities:
    <<: *ApplicationCapabilities

Channel: &ChannelDefaults
  Policies:
    Readers:
      Type: ImplicitMeta
      Rule: "ANY Readers"
    Writers:
      Type: ImplicitMeta
      Rule: "ANY Writers"
    Admins:
      Type: ImplicitMeta
      Rule: "MAJORITY Admins"
  Capabilities:
    <<: *ChannelCapabilities

Orderer: &OrdererDefaults
  BatchTimeout: 2s
  BatchSize:
    MaxMessageCount: 10
    AbsoluteMaxBytes: 98 MB
    PreferredMaxBytes: 1024 KB
  Organizations:
  Policies:
    Readers:
      Type: ImplicitMeta
      Rule: "ANY Readers"
    Writers:
      Type: ImplicitMeta
      Rule: "ANY Writers"
    Admins:
      Type: ImplicitMeta
      Rule: "MAJORITY Admins"
    BlockValidation:
      Type: ImplicitMeta
      Rule: "ANY Writers"

Profiles:
{{- range $channel := $.Values.channels }}
  {{ $channel.name }}:
    <<: *ChannelDefaults
    Orderer:
      <<: *OrdererDefaults
      OrdererType: BFT
      SmartBFT:
        RequestBatchMaxCount: 100
        RequestBatchMaxInterval: 50ms
        RequestForwardTimeout: 2s
        RequestComplainTimeout: 20s
        RequestAutoRemoveTimeout: 3m0s
        ViewChangeResendInterval: 5s
        ViewChangeTimeout: 20s
        LeaderHeartbeatTimeout: 1m0s
        CollectTimeout: 1s
        RequestBatchMaxBytes: 10485760
        IncomingMessageBufferSize: 200
        RequestPoolSize: 100000
        LeaderHeartbeatCount: 10
      ConsenterMapping:
    {{- range $org := $.Values.organizations }}
      {{- range $orderer := $org.orderers }}
        {{- $split := split ":" $orderer.ordererAddress }}
        - ID: {{ $orderer.name }}
          Host: {{ $split._0 }}
          Port: {{ $split._1 }}
          MSPID: {{ $org.name }}MSP
          Identity: ./crypto-config/organizations/{{ $org.name }}/orderers/{{ $orderer.name }}/msp/signcerts/server.crt
          ClientTLSCert: ./crypto-config/organizations/{{ $org.name }}/orderers/{{ $orderer.name }}/tls/server.crt
          ServerTLSCert: ./crypto-config/organizations/{{ $org.name }}/orderers/{{ $orderer.name }}/tls/server.crt
      {{- end }}
    {{- end }}
      Organizations:
    {{- range $orderer := $channel.orderers }}
        - *{{ $orderer }}Org
    {{- end }}
      Capabilities: *OrdererCapabilities
    Application:
      <<: *ApplicationDefaults
      Organizations:
    {{- range $org := $channel.participants }}
        - *{{ $org }}Org
    {{- end }}
      Capabilities: *ApplicationCapabilities
  {{- printf "\n" }}
{{- end }}
