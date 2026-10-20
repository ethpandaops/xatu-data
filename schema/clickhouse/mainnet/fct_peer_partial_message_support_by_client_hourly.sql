CREATE TABLE mainnet.fct_peer_partial_message_support_by_client_hourly
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'The wall clock time at the start of the hour' CODEC(DoubleDelta, ZSTD(1)),
    `peer_implementation` LowCardinality(String) COMMENT 'Client implementation of the peer from its libp2p agent, empty when no heartbeat identified it' CODEC(ZSTD(1)),
    `peer_version` LowCardinality(String) COMMENT 'Client version of the peer as major.minor.patch, or the raw agent version when it does not parse' CODEC(ZSTD(1)),
    `connected_peer_count` UInt32 COMMENT 'Distinct peers connected to a sentry node during the hour, from heartbeats' CODEC(ZSTD(1)),
    `gossipsub_v13_peer_count` UInt32 COMMENT 'Connected peers that support gossipsub v1.3 (/meshsub/1.3.0), which the partial messages extension requires' CODEC(ZSTD(1)),
    `subscribed_peer_count` UInt32 COMMENT 'Distinct peers seen subscribing to a data column topic during the hour by a sentry node that reports the partial flags' CODEC(ZSTD(1)),
    `requests_partial_peer_count` UInt32 COMMENT 'Subscribed peers that requested partial messages on a data column topic' CODEC(ZSTD(1)),
    `supports_sending_partial_peer_count` UInt32 COMMENT 'Subscribed peers that support sending partial messages on a data column topic' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_peer_partial_message_support_by_client_hourly_local', cityHash64(hour_start_date_time, peer_implementation, peer_version))
COMMENT 'Hourly gossipsub partial messages adoption by peer client and version: connected peers, gossipsub v1.3 support and the partial flags peers set when subscribing to data column topics'
