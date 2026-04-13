{{ config(materialized="table", tags=["transactions", "aggregate"]) }}

select
    date(t.transaction_ts) as activity_date,
    coalesce(u.segment, 'Unknown') as segment,
    coalesce(u.state, 'Unknown') as state,
    coalesce(t.transaction_type, 'Unknown') as transaction_type,

    count(*) as txn_count,
    sum(t.amount) as gmv,
    count(distinct t.user_id) as distinct_users,
    div0(sum(t.amount), count(*)) as aov

from {{ ref("stg_001_format_raw_transactions") }} t
left join {{ ref("stg_001_format_raw_users") }} u on t.user_id = u.user_id
where t.transaction_ts is not null
group by 1, 2, 3, 4
