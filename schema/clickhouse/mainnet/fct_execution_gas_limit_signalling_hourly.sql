CREATE TABLE mainnet.fct_execution_gas_limit_signalling_hourly
(
    `updated_date_time` DateTime,
    `hour_start_date_time` DateTime,
    `gas_limit_band_counts` Map(String, UInt32)
)
ENGINE = Distributed('{cluster}', 'mainnet', 'fct_execution_gas_limit_signalling_hourly_local', cityHash64(hour_start_date_time))
