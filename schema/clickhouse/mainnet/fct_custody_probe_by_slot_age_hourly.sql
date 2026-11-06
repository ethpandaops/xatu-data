CREATE TABLE mainnet.fct_custody_probe_by_slot_age_hourly
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `hour_start_date_time` DateTime COMMENT 'The hour the probes ran' CODEC(DoubleDelta, ZSTD(1)),
    `slot_age_bucket` LowCardinality(String) COMMENT 'Age of the probed slot when the probe ran: 0-1d, 1-3d, 3-7d, 7-14d, 14-18d, or 18d+ (past the 4096-epoch retention of about 18.2 days)',
    `slot_age_min_days` UInt8 COMMENT 'Start of the slot age bucket in days, for ordering the buckets' CODEC(ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Consensus client of the probed P2P peer, from its agent (erigon is caplin, unknown when the agent is empty)',
    `probe_count` UInt64 COMMENT 'Number of column probes, one per column a probe asked for' CODEC(ZSTD(1)),
    `success_count` UInt64 COMMENT 'Column probes the peer answered with the column' CODEC(ZSTD(1)),
    `missing_count` UInt64 COMMENT 'Column probes the peer answered without the column' CODEC(ZSTD(1)),
    `failure_count` UInt64 COMMENT 'Column probes that failed' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_custody_probe_by_slot_age_hourly_local', cityHash64(hour_start_date_time))
COMMENT 'Data column custody probes per hour the probes ran, age of the probed slot and P2P peer client. Late age buckets show peers that stop custodying columns before retention ends'
