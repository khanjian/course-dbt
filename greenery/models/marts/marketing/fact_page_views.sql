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

SELECT
    e.user_id,
    e.session_id,
    coalesce(e.product_id, oi.product_id) as product_id,
    session_started_at,
    session_ended_at,
    sum(case when e.event_type = 'page_view' then 1 else 0 end) as page_views,
    sum(case when e.event_type = 'add_to_cart' then 1 else 0 end) as add_to_cart,
    sum(case when e.event_type = 'checkout' then 1 else 0 end) as checkout,
    sum(case when e.event_type = 'package_shipped' then 1 else 0 end) as package_shipped,
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





