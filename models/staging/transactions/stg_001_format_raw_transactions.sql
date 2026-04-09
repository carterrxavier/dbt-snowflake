with src as (
    select V
    from {{ source('raw_transactions_data', 'RAW_TRANSACTIONS') }}
)

select
    -- identifiers
    v:transaction_id::string as transaction_id,
    v:user_id::number as user_id,
    v:device_id::string as device_id,

    -- transaction details
    v:transaction_type::string as transaction_type,
    v:merchant::string as merchant,
    v:amount::number(38, 2) as amount,
    v:avg_spending::number(38, 2) as avg_spending,

    -- geo
    v:latitude::float as latitude,
    v:longitude::float as longitude,

    -- anomaly
    v:sim_anomaly_type::string as sim_anomaly_type,

    -- time
    try_to_timestamp_ntz(v:timestamp::string) as transaction_ts

from src