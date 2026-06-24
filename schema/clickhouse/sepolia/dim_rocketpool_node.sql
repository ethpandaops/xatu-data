CREATE TABLE sepolia.dim_rocketpool_node
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `node_operator` String COMMENT 'The Rocket Pool node operator address, lowercase 0x-prefixed' CODEC(ZSTD(1)),
    `timezone` String COMMENT 'The self-reported timezone location string (e.g. Europe/London), empty if unknown' CODEC(ZSTD(1)),
    `registered_date_time` DateTime COMMENT 'Wall clock time the node registered with Rocket Pool' CODEC(DoubleDelta, ZSTD(1)),
    `minipool_count` UInt32 COMMENT 'Total number of minipools ever created by this node operator' CODEC(ZSTD(1)),
    `active_minipool_count` UInt32 COMMENT 'Number of minipools created minus destroyed for this node operator' CODEC(ZSTD(1)),
    `megapool_validator_count` UInt32 COMMENT 'Number of Saturn megapool validators for this node operator' CODEC(ZSTD(1)),
    `validator_count` UInt32 COMMENT 'Total number of beacon chain validators (minipool and megapool) linked to this node operator' CODEC(ZSTD(1)),
    `rpl_staked_wei` UInt256 COMMENT 'Net RPL staked in wei (lifetime staked minus withdrawn), derived from events' CODEC(ZSTD(1)),
    `in_smoothing_pool` Bool COMMENT 'Whether the node operator is currently registered for the smoothing pool',
    `first_seen_date_time` DateTime COMMENT 'Wall clock time of the node operators earliest observed Rocket Pool activity' CODEC(DoubleDelta, ZSTD(1)),
    `last_activity_date_time` DateTime COMMENT 'Wall clock time of the node operators latest observed minipool or megapool activity' CODEC(DoubleDelta, ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'dim_rocketpool_node_local', cityHash64(node_operator))
COMMENT 'Rocket Pool node operators with timezone, RPL stake, smoothing pool membership and minipool/validator counts'
