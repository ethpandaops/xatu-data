CREATE TABLE hoodi.fct_execution_gas_limit_signalling_daily
(
    `updated_date_time` DateTime,
    `day_start_date` Date,
    `gas_limit_band_counts` Map(String, UInt32)
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_execution_gas_limit_signalling_daily_local', cityHash64(day_start_date))
