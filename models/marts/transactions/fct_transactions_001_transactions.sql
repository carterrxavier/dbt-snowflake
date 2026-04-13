{{ config(tags=["transactions", "fact"]) }}

with transactions_raw as (
    select * from {{ ref("stg_001_format_raw_transactions") }}
),

transactions as (
    select
        transaction_id,
        user_id,
        device_id,
        transaction_type,
        merchant,
        amount,
        avg_spending,
        latitude,
        longitude,
        sim_anomaly_type,
        transaction_ts
    from (
        select
            transactions_raw.*,
            row_number() over (
                partition by transaction_id
                order by transaction_ts desc nulls last
            ) as _txn_rn
        from transactions_raw
    )
    where _txn_rn = 1
),

users_raw as (
    select * from {{ ref("stg_001_format_raw_users") }}
),

users as (
    select
        user_id,
        segment,
        state,
        avg_spending
    from (
        select
            user_id,
            segment,
            state,
            avg_spending,
            row_number() over (
                partition by user_id
                order by customer_since desc nulls last, full_name nulls last
            ) as _user_rn
        from users_raw
    )
    where _user_rn = 1
),

segment_txn_avg as (
    select
        coalesce(u.segment, 'Unknown') as segment,
        avg(t.amount) as avg_amount_in_segment
    from transactions t
    left join users u on t.user_id = u.user_id
    group by 1
),

enriched as (
    select
        t.transaction_id,
        t.user_id,
        t.device_id,
        t.transaction_type,
        t.merchant,
        t.amount,
        t.avg_spending as txn_stated_avg_spending,
        t.latitude,
        t.longitude,
        t.sim_anomaly_type,
        t.transaction_ts,
        u.segment as user_segment,
        u.state as user_state,
        u.avg_spending as user_profile_avg_spending,
        sta.avg_amount_in_segment
    from transactions t
    left join users u on t.user_id = u.user_id
    left join
        segment_txn_avg sta
        on coalesce(u.segment, 'Unknown') = sta.segment
)

select
    transaction_id,
    user_id,
    device_id,
    transaction_type,
    merchant,
    amount,
    txn_stated_avg_spending,
    latitude,
    longitude,
    sim_anomaly_type,
    transaction_ts,

    user_segment,
    user_state,
    user_profile_avg_spending,
    avg_amount_in_segment,

    case
        when user_profile_avg_spending is not null and amount > user_profile_avg_spending then true
        else false
    end as is_high_vs_user_profile_avg,

    case
        when avg_amount_in_segment is not null and amount > avg_amount_in_segment then true
        else false
    end as is_high_vs_segment_avg_txn

from enriched
