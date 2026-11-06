CREATE TABLE hoodi.fct_data_column_availability_by_slot
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `slot` UInt32 COMMENT 'Slot number being probed' CODEC(DoubleDelta, ZSTD(1)),
    `slot_start_date_time` DateTime COMMENT 'The wall clock time when the slot started' CODEC(DoubleDelta, ZSTD(1)),
    `epoch` UInt32 COMMENT 'Epoch number containing the slot' CODEC(DoubleDelta, ZSTD(1)),
    `epoch_start_date_time` DateTime COMMENT 'The wall clock time when the epoch started' CODEC(DoubleDelta, ZSTD(1)),
    `wallclock_request_slot` UInt32 COMMENT 'The slot the probes tested, the same as slot' CODEC(DoubleDelta, ZSTD(1)),
    `wallclock_request_slot_start_date_time` DateTime COMMENT 'The start time of the slot the probes tested, the same as slot_start_date_time' CODEC(DoubleDelta, ZSTD(1)),
    `wallclock_request_epoch` UInt32 COMMENT 'The epoch of the slot the probes tested, the same as epoch' CODEC(DoubleDelta, ZSTD(1)),
    `wallclock_request_epoch_start_date_time` DateTime COMMENT 'The start time of the epoch the probes tested, the same as epoch_start_date_time' CODEC(DoubleDelta, ZSTD(1)),
    `column_index` UInt64 COMMENT 'Column index being probed (0-127)' CODEC(ZSTD(1)),
    `beacon_block_root` Nullable(FixedString(66)) COMMENT 'Beacon block root from the earliest gossipsub sighting of the column, NULL when it was not gossiped' CODEC(ZSTD(1)),
    `beacon_block_root_variants` UInt8 COMMENT 'Number of block roots in the gossipsub sightings (more than 1 means a fork), 0 when not gossiped' CODEC(ZSTD(1)),
    `blob_count` UInt16 COMMENT 'Number of blobs in the slot, from the probes and the gossipsub sightings' CODEC(ZSTD(1)),
    `success_count` UInt32 COMMENT 'Number of custody probes that returned the column' CODEC(DoubleDelta, ZSTD(1)),
    `failure_count` UInt32 COMMENT 'Number of custody probes that failed (result = failure)' CODEC(DoubleDelta, ZSTD(1)),
    `missing_count` UInt32 COMMENT 'Number of custody probes the peer answered without the column (result = missing)' CODEC(DoubleDelta, ZSTD(1)),
    `probe_count` UInt32 COMMENT 'Number of custody probes of the column for this slot' CODEC(DoubleDelta, ZSTD(1)),
    `availability_pct` Float64 COMMENT 'Share of custody probes that returned the column (success / probe_count * 100), rounded to 2 decimal places' CODEC(ZSTD(1)),
    `min_response_time_ms` UInt32 COMMENT 'Minimum response time in milliseconds for successful probes only' CODEC(ZSTD(1)),
    `p50_response_time_ms` UInt32 COMMENT 'Median (p50) response time in milliseconds for successful probes only' CODEC(ZSTD(1)),
    `p95_response_time_ms` UInt32 COMMENT '95th percentile response time in milliseconds for successful probes only' CODEC(ZSTD(1)),
    `p99_response_time_ms` UInt32 COMMENT '99th percentile response time in milliseconds for successful probes only' CODEC(ZSTD(1)),
    `max_response_time_ms` UInt32 COMMENT 'Maximum response time in milliseconds for successful probes only' CODEC(ZSTD(1)),
    `unique_peer_count` UInt32 COMMENT 'Number of distinct P2P peers probed' CODEC(ZSTD(1)),
    `unique_client_count` UInt32 COMMENT 'Number of distinct Xatu nodes that sent the probes' CODEC(ZSTD(1)),
    `unique_implementation_count` UInt32 COMMENT 'Number of distinct client implementations that sent the probes' CODEC(ZSTD(1)),
    `custody_probe_count` UInt32 COMMENT 'Number of custody probes, the same as probe_count' CODEC(ZSTD(1)),
    `gossipsub_count` UInt32 COMMENT 'Number of gossipsub sightings of the column, which do not count towards availability' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_data_column_availability_by_slot_local', cityHash64(slot_start_date_time, column_index))
COMMENT 'Custody probe results by slot and column index. Only custody probes count towards success, failure, missing and availability. Gossipsub sightings are counted separately in gossipsub_count. Probes keep arriving for about 18 days after a slot, so the last 19 days are recounted every hour'
