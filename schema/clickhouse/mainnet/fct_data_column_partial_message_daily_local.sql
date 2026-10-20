CREATE TABLE mainnet.fct_data_column_partial_message_daily_local
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period, by wall clock slot' CODEC(DoubleDelta, ZSTD(1)),
    `meta_consensus_implementation` LowCardinality(String) COMMENT 'Consensus client of the sentry nodes. Prysm sentries capture every partial RPC on the wire, Lighthouse sentries only those the gossipsub router passed on' CODEC(ZSTD(1)),
    `node_count` UInt32 COMMENT 'Distinct sentry nodes that sent or received a partial message' CODEC(ZSTD(1)),
    `received_metadata_count` UInt32 COMMENT 'Received partial messages that only carried parts metadata' CODEC(ZSTD(1)),
    `received_message_count` UInt32 COMMENT 'Received partial messages with a body, header-only pushes included' CODEC(ZSTD(1)),
    `received_cell_message_count` UInt32 COMMENT 'Received partial messages that carried at least one cell' CODEC(ZSTD(1)),
    `received_cells` UInt64 COMMENT 'Cells carried by received partial messages, duplicates included' CODEC(ZSTD(1)),
    `received_header_count` UInt32 COMMENT 'Received partial messages that carried the partial data column header' CODEC(ZSTD(1)),
    `cell_sender_peer_count` UInt32 COMMENT 'Distinct peers that sent a sentry node at least one cell' CODEC(ZSTD(1)),
    `sent_metadata_count` UInt32 COMMENT 'Sent partial messages that only carried parts metadata' CODEC(ZSTD(1)),
    `sent_message_count` UInt32 COMMENT 'Sent partial messages with a body, header-only pushes included' CODEC(ZSTD(1)),
    `sent_cell_message_count` UInt32 COMMENT 'Sent partial messages that carried at least one cell' CODEC(ZSTD(1)),
    `sent_cells` UInt64 COMMENT 'Cells carried by sent partial messages' CODEC(ZSTD(1)),
    `sent_header_count` UInt32 COMMENT 'Sent partial messages that carried the partial data column header' CODEC(ZSTD(1)),
    `cells_accept_count` UInt32 COMMENT 'Cell verdicts that accepted a received partial message' CODEC(ZSTD(1)),
    `cells_ignore_count` UInt32 COMMENT 'Cell verdicts that ignored a received partial message, for example because its cells were already known' CODEC(ZSTD(1)),
    `cells_reject_count` UInt32 COMMENT 'Cell verdicts that rejected a received partial message' CODEC(ZSTD(1)),
    `verdict_cells` UInt64 COMMENT 'Cells carried by the partial messages that got a cell verdict' CODEC(ZSTD(1)),
    `new_cells` UInt64 COMMENT 'Cells new to the receiving node that passed verification. Divided by verdict_cells this is the useful cell ratio' CODEC(ZSTD(1)),
    `header_accept_count` UInt32 COMMENT 'Header verdicts that accepted a partial data column header' CODEC(ZSTD(1)),
    `header_ignore_count` UInt32 COMMENT 'Header verdicts that ignored a partial data column header' CODEC(ZSTD(1)),
    `header_reject_count` UInt32 COMMENT 'Header verdicts that rejected a partial data column header' CODEC(ZSTD(1)),
    `header_node_block_count` UInt32 COMMENT 'Node and Fulu block pairs where the node received a partial data column header' CODEC(ZSTD(1)),
    `p50_header_seen_slot_start_diff` UInt32 COMMENT 'Median time a node first received the header for a block, in milliseconds from slot start, 0 when there was none' CODEC(ZSTD(1)),
    `p90_header_seen_slot_start_diff` UInt32 COMMENT '90th percentile time a node first received the header for a block, in milliseconds from slot start, 0 when there was none' CODEC(ZSTD(1))
)
ENGINE = ReplicatedReplacingMergeTree('/clickhouse/{installation}/{cluster}/tables/{shard}/mainnet/fct_data_column_partial_message_daily_local', '{replica}', updated_date_time)
PARTITION BY toStartOfMonth(day_start_date)
ORDER BY (day_start_date, meta_consensus_implementation)
SETTINGS deduplicate_merge_projection_mode = 'rebuild', index_granularity = 8192
COMMENT 'Daily gossipsub partial data column traffic on sentry nodes by consensus client: messages and cells sent and received, validation verdicts, useful cells and header push timing'
