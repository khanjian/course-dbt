## Part 1

Conversion rate is defined as the # of unique sessions with a purchase event / total number of unique sessions. 

Conversion rate by product is defined as the # of unique sessions with a purchase event of that product / total number of unique sessions that viewed that product

### What is our overall conversion rate?

```
with total_unique_sessions as (
select
 count(*) as total_unique_sessions_count
    from
    (
SELECT 
    distinct
    session_id
from fact_page_views
)
),

sessions_with_purchase_event as (
select 
    count(*) as num_sessions_purchase_event
from(
select 
    distinct
    package_shipped,
    session_id
from fact_page_views
where package_shipped = 1
)
)

select
    n.num_sessions_purchase_event / d.total_unique_sessions_count as Conversion_rate
from sessions_with_purchase_event n
join total_unique_sessions d
```

conversion rate: 0.579585

### What is our conversion rate by product?

```
with total_unique_sessions_per_prod as (
select
    product_id,
    count(session_id) as total_unique_sessions_per_prod_count
from(    
SELECT 
    distinct
    session_id,
    product_id
from fact_page_views
)
group by product_id
),

sessions_with_purchase_event_per_product as (
select 
    product_id,
    count(session_id) as num_sessions_purchase_event_per_product
from(
select 
    distinct
    package_shipped,
    session_id,
    product_id
from fact_page_views
where package_shipped = 1
)
group by product_id
)

select
    n.product_id as product_id,
    n.num_sessions_purchase_event_per_product / d.total_unique_sessions_per_prod_count as Conversion_rate_per_product
from sessions_with_purchase_event_per_product n
inner join total_unique_sessions_per_prod d ON  n.product_id = d.product_id
```

Example of one product's conversion rate, product with the id: fb0e8be7-5ac4-4a76-a1fa-2cc4bf0b2d80 had a conversion rate of 0.59375

### Part 6 dbt Snapshots

```
select
    * 
from
    inventory_snapshot
where DBT_VALID_TO is not null  AND DAY(dbt_valid_to) = 15
```

The following products had their inventory change from week 2 to week 3

Bamboo
Philodendron
Monstera
ZZ Plant