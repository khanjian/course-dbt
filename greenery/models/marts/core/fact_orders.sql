{{
  config(
    materialized='table'
  )
}}

with

orders as (
    SELECT * from {{ref('stg_postgres__orders')}}
),

addresses as (
    SELECT * from {{ref('stg_postgres__addresses')}}
),

products_in_order as (
    SELECT  
        order_id,
        count(product_id) as products_in_order
    FROM 
        {{ref('stg_postgres__order_items')}}
    GROUP BY 
        order_id
)

SELECT
    o.*,
    a.country,
    a.state,
    a.zipcode,
    p.products_in_order
FROM
    orders o
LEFT JOIN
    addresses a ON
        a.address_id = o.address_id
LEFT JOIN products_in_order p ON
        p.order_id = o.order_id