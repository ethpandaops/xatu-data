CREATE TABLE mainnet.dim_peer_node
(
    `updated_date_time` DateTime COMMENT 'Timestamp when the record was last updated' CODEC(DoubleDelta, ZSTD(1)),
    `peer_id_unique_key` Int64 COMMENT 'Hash of the peer ID and network, the key shared by the libp2p tables' CODEC(ZSTD(1)),
    `peer_id` String COMMENT 'libp2p peer ID' CODEC(ZSTD(1)),
    `node_id` String COMMENT 'discv5 node ID (hex, the keccak256 of the uncompressed secp256k1 public key in the peer ID), empty when the peer ID holds another key type' CODEC(ZSTD(1)),
    `custody_group_order` Array(UInt8) COMMENT 'All 128 custody groups in the order the node ID assigns them (get_custody_groups): a peer with custody group count n custodies the first n, and group g is data column g. Empty without a node ID' CODEC(ZSTD(1))
)
ENGINE = Distributed('{cluster}', 'mainnet', 'dim_peer_node_local', cityHash64(peer_id_unique_key))
COMMENT 'Consensus peers in int_peer_daily with a peer ID, with their discv5 node ID and the order their node ID assigns custody groups in.'
