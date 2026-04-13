{{ config(materialized="table", tags=["transactions", "aggregate"]) }}

select
    t.user_id,
    max(t.user_segment) as segment,
    max(t.user_state) as state,

    count(*) as lifetime_txn_count,
    sum(t.amount) as lifetime_gmv,
    min(t.transaction_ts) as first_transaction_ts,
    max(t.transaction_ts) as last_transaction_ts,

    sum(iff(t.transaction_ts::date >= dateadd(day, -30, current_date()), 1, 0)) as txn_count_last_30d,
    sum(iff(t.transaction_ts::date >= dateadd(day, -30, current_date()), t.amount, 0)) as gmv_last_30d

from {{ ref("fct_transactions_001_transactions") }} t
group by t.user_id
