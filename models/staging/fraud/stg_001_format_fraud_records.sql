with src as (
  select v as j
  from {{ source('raw_transactions_data', 'RAW_FRAUD_DECISIONS') }}
)
select
  j:decision_id::string as decision_id,
  j:detector::string as detector,
  try_to_timestamp_tz(j:evaluated_at::string) as evaluated_at,
  j:fraud_flag::string as fraud_flag,
  j:transaction_id::string as transaction_id,
  j:transaction_key::string as transaction_key,
  j:user_id::number as user_id,

  -- nested object fields
  j:features:amount::number(38,2) as feature_amount,
  j:features:high_amount_threshold::float as feature_high_amount_threshold,
  j:features:is_new_device::boolean as feature_is_new_device
  
from src