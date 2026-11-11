CREATE TABLE sepolia.fct_peer_goodbye_by_cl_client_daily
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `day_start_date` Date COMMENT 'Start of the day period' CODEC(DoubleDelta, ZSTD(1)),
    `client` LowCardinality(String) COMMENT 'Consensus client of the remote peer from its agent: lighthouse, lodestar, nimbus, prysm, teku, grandine, caplin (erigon), silver or ethlambda, unknown when the agent was not known, other for every other agent (libp2p tools, crawlers)' CODEC(ZSTD(1)),
    `code` UInt64 COMMENT 'Goodbye reason code the remote peer sent: 1 client shutdown, 2 irrelevant network, 3 fault/error, 128 unable to verify network, 129 too many peers, 250 peer score too low, 251 banned. Other codes are client specific' CODEC(ZSTD(1)),
    `reason` LowCardinality(String) COMMENT 'Reason text our sentries give the code, such as client has too many peers. Codes they do not know read as unknown goodbye value of N received' CODEC(ZSTD(1)),
    `goodbye_count` UInt32 COMMENT 'Goodbye messages with the code our sentries received from the client in the day. A peer that says goodbye to several sentries counts once for each' CODEC(ZSTD(1)),
    `peer_count` UInt32 COMMENT 'Unique remote peers of the client that sent the code in the day. A peer that sent several codes counts under each' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_peer_goodbye_by_cl_client_daily_local', cityHash64(day_start_date))
COMMENT 'Daily libp2p Goodbye messages our sentries received from remote peers, by the consensus client of the peer and the reason code it gave for disconnecting. Rows are written once the day is complete. The first day of data and a day after a whole day without goodbyes are left out, as they are partial.'
