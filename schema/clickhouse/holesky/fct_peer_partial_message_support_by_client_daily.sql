CREATE TABLE holesky.fct_peer_partial_message_support_by_client_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `peer_implementation` LowCardinality(String) COMMENT 'Client implementation of the peer from its libp2p agent, empty when no heartbeat identified it' CODEC(ZSTD(1)),
    `peer_version` LowCardinality(String) COMMENT 'Client version of the peer as major.minor.patch, or the raw agent version when it does not parse' CODEC(ZSTD(1)),
    `hour_count` UInt32 COMMENT 'Hours of the day with peer data on the network, the divisor of the averages' CODEC(ZSTD(1)),
    `avg_connected_peer_count` Float64 COMMENT 'Hourly distinct connected peers, averaged over the hours of the day' CODEC(ZSTD(1)),
    `avg_gossipsub_v13_peer_count` Float64 COMMENT 'Hourly connected peers that support gossipsub v1.3, averaged over the hours of the day' CODEC(ZSTD(1)),
    `avg_subscribed_peer_count` Float64 COMMENT 'Hourly peers seen subscribing to a data column topic by a sentry node that reports the partial flags, averaged over the hours of the day' CODEC(ZSTD(1)),
    `avg_requests_partial_peer_count` Float64 COMMENT 'Hourly subscribed peers that requested partial messages, averaged over the hours of the day' CODEC(ZSTD(1)),
    `avg_supports_sending_partial_peer_count` Float64 COMMENT 'Hourly subscribed peers that support sending partial messages, averaged over the hours of the day' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'holesky', 'fct_peer_partial_message_support_by_client_daily_local', cityHash64(day_start_date, peer_implementation, peer_version))
COMMENT 'Daily gossipsub partial messages adoption by peer client and version, as averages of the hourly peer counts'
