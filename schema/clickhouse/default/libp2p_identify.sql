CREATE TABLE default.libp2p_identify AS default.libp2p_identify_local
ENGINE = Distributed('{cluster}', 'default', 'libp2p_identify_local', cityHash64(event_date_time, meta_network_name, meta_client_name, remote_peer_id_unique_key, direction))
COMMENT 'Contains the details of the IDENTIFY events from the libp2p client.'
