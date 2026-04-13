select state, count(*) as user_count from {{ ref('stg_001_format_raw_users') }} 
group by state order by user_count desc limit 10