CREATE TABLE sepolia.fct_execution_gas_limit_signalling_hourly
(
    `updated_date_time` DateTime,
    `hour_start_date_time` DateTime,
    `gas_limit_band_counts` Map(String, UInt32)
)
ENGINE = Distributed('{cluster}', 'sepolia', 'fct_execution_gas_limit_signalling_hourly_local', cityHash64(hour_start_date_time))
COMMENT 'Hourly gas limit signalling by validators, from their MEV relay validator registrations. For each hour, each validator counts once at the highest gas limit it registered on that UTC day or the 7 days before, rounded up to a multiple of 1M gas. gas_limit_band_counts maps each band to its validator count. Validators that do not register with the relays xatu polls are not counted'
