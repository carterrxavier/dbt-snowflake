with src as (
    select raw as j
    from {{ source('raw_transactions_data', 'RAW_USER_PROFILES') }}
)

select
    j:user_id::number as user_id,
    j:full_name::string as full_name,
    j:email::string as email,
    j:phone::string as phone,
    j:device_id::string as device_id,

    j:segment::string as segment,
    j:avg_spending::number(38, 2) as avg_spending,

    j:address_line1::string as address_line1,
    j:address_line2::string as address_line2,
    j:city::string as city,
    j:state::string as state,
    j:postal_code::string as postal_code,
    j:country::string as country,

    j:home_lat::float as home_lat,
    j:home_lon::float as home_lon,

    try_to_date(j:customer_since::string) as customer_since,
    try_to_date(j:date_of_birth::string) as date_of_birth

from src
where j:state::string not in ('AP','AA','AE')
