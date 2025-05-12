from sqlalchemy import create_engine, text

class ClickhouseClient:
    def __init__(self, db_url):
        """Initialize Clickhouse client with database URL."""
        self.engine = create_engine(db_url)
        self.connection = self.engine.connect()
    
    def fetch_block_arrival_times(self, network, start_slot, end_slot):
        """
        Fetch block arrival times from beacon_api_eth_v1_events_block.
        
        Args:
            network (str): Network name (e.g., 'nft-devnet-2')
            start_slot (int): Starting slot
            end_slot (int): Ending slot
            
        Returns:
            DataFrame: Block arrival times data
        """
        query = text("""
            SELECT
                slot,
                slot_start_date_time,
                propagation_slot_start_diff as arrival_time,
                meta_client_name,
                meta_consensus_implementation
            FROM beacon_api_eth_v1_events_block FINAL
            WHERE
                meta_network_name = :network
                AND slot BETWEEN :start_slot AND :end_slot
                AND meta_client_name != ''
                AND meta_client_name IS NOT NULL
                AND propagation_slot_start_diff < 12000
            ORDER BY slot ASC
        """)
        
        params = {
            "network": network,
            "start_slot": start_slot,
            "end_slot": end_slot
        }
        
        result = self.connection.execute(query, params)
        return result.fetchall()
    
    def fetch_head_arrival_times(self, network, start_slot, end_slot):
        """
        Fetch head arrival times from beacon_api_eth_v1_events_head.
        
        Args:
            network (str): Network name (e.g., 'nft-devnet-2')
            start_slot (int): Starting slot
            end_slot (int): Ending slot
            
        Returns:
            DataFrame: Head arrival times data
        """
        query = text("""
            SELECT
                slot,
                slot_start_date_time,
                propagation_slot_start_diff as arrival_time,
                meta_client_name,
                meta_consensus_implementation
            FROM beacon_api_eth_v1_events_head FINAL
            WHERE
                meta_network_name = :network
                AND slot BETWEEN :start_slot AND :end_slot
                AND meta_client_name != ''
                AND meta_client_name IS NOT NULL
                AND propagation_slot_start_diff < 12000
            ORDER BY slot ASC
        """)
        
        params = {
            "network": network,
            "start_slot": start_slot,
            "end_slot": end_slot
        }
        
        result = self.connection.execute(query, params)
        return result.fetchall()
    
    def fetch_blob_data(self, network, start_slot, end_slot):
        """
        Fetch blob sidecar data from beacon_api_eth_v1_events_blob_sidecar.
        
        Args:
            network (str): Network name (e.g., 'nft-devnet-2')
            start_slot (int): Starting slot
            end_slot (int): Ending slot
            
        Returns:
            DataFrame: Blob sidecar data
        """
        query = text("""
            SELECT
                slot,
                MAX(blob_index) as highest_index
            FROM beacon_api_eth_v1_events_blob_sidecar FINAL
            WHERE
                meta_network_name = :network
                AND slot BETWEEN :start_slot AND :end_slot
            GROUP BY slot
            ORDER BY slot ASC
        """)
        
        params = {
            "network": network,
            "start_slot": start_slot,
            "end_slot": end_slot
        }
        
        result = self.connection.execute(query, params)
        return result.fetchall()
    
