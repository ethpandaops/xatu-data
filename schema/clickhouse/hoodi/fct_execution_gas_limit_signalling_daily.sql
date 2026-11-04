CREATE TABLE hoodi.fct_execution_gas_limit_signalling_daily
(
    `updated_date_time` DateTime,
    `day_start_date` Date,
    `gas_limit_band_counts` Map(String, UInt32)
)
ENGINE = Distributed('{cluster}', 'hoodi', 'fct_execution_gas_limit_signalling_daily_local', cityHash64(day_start_date))
COMMENT 'Daily gas limit signalling by validators, from their MEV relay validator registrations. For each UTC day, each validator counts once at the highest gas limit it registered in the 7 days ending that day, rounded up to a multiple of 1M gas. gas_limit_band_counts maps each band to its validator count. Validators that do not register with the relays xatu polls are not counted'
