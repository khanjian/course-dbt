{{
  config(
    materialized='table'
  )
}}

with 

events as (
    SELECT * FROM {{ref('stg_postgres__events')}}
),

order_items as (
    SELECT * FROM {{ref('stg_postgres__order_items')}}
),

session_timing_agg as(
    SELECT
        *
    FROM {{ref('int_session_timings')}}
)



{% set event_types = dbt_utils.get_column_values(
    table = ref('stg_postgres__events'),
    column = 'event_type')
    %}


SELECT
    e.user_id,
    e.session_id,
    coalesce(e.product_id, oi.product_id) as product_id,
    session_started_at,
    session_ended_at,
    {% for event_type in event_types %}
    {{ sum_of('e.event_type', event_type) }} as {{ event_type }}s,
    {% endfor %}
    datediff('minute', session_started_at, session_ended_at) as session_length_minutes     
FROM
    events e
LEFT JOIN
    order_items oi ON
        oi.order_id = e.order_id
LEFT JOIN 
    session_timing_agg s ON
        s.session_id = e.session_id
GROUP BY
    1, 2, 3, 4, 5





