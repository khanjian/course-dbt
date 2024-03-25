# Project 1 Answers

## How many users do we have?

```
SELECT
    count(*)
FROM 
    stg_postgres__users
```

**Answer: 130 users**

## On average, how many orders do we receive per hour?

```
SELECT
    AVG(num_orders_per_hour) as orders_per_hour
FROM(    
SELECT
    -- count(session_id) as counts,
    TIMESTAMP_FROM_PARTS(
        DATE_PART(YEAR, created_at),
        DATE_PART(MONTH, created_at),
        DATE_PART(DAY, created_at),
        DATE_PART(HOUR, created_at),
        0,
        0) as hours,
    count(hours) as num_orders_per_hour
FROM
    stg_postgres__orders
GROUP BY
    hours
ORDER BY 
    hours
)
```

**Answer: About 7.5 order per hour**


## On average, how long does an order take from being placed to being delivered?

```
SELECT
    AVG(TIMEDIFF(hour, created_at, delivered_at)) AS avg_num_hours,
    AVG(TIMEDIFF(day, created_at, delivered_at)) AS avg_num_days    
FROM
    stg_postgres__orders
WHERE delivered_at is not null    
```

**Answer: About 3.89 days or about 93.4 hours**

## How many users have only made one purchase? Two purchases? Three+ purchases?

```
with num_orders_per_user as(
SELECT
    count(order_id) as orders_per_users,
    user_id
FROM
    stg_postgres__orders
GROUP BY user_id
)

SELECT
    orders_per_users,
    count(orders_per_users) as num_order_numbers
FROM
    num_orders_per_user    
GROUP BY     
    orders_per_users
ORDER BY     
    orders_per_users
```

### One purchase

**Answer: 25 users**

### Two purchases

**Answer: 28 users**

### Three+ purchases

```
with num_orders_per_user as(
SELECT
    count(order_id) as orders_per_users,
    user_id
FROM
    stg_postgres__orders
GROUP BY user_id
)
SELECT
    SUM(num_order_numbers_over_2) AS total_order_over_2
FROM(   
SELECT
    orders_per_users,
    count(orders_per_users) as num_order_numbers_over_2
FROM
    num_orders_per_user
WHERE 
    orders_per_users > 2    
GROUP BY     
    orders_per_users
    ) 
```

**Answer: 71 users**

* Note: you should consider a purchase to be a single order. In other words, if a user places one order for 3 products, they are considered to have made 1 purchase. * 

## On average, how many unique sessions do we have per hour?

```
with unique_session_per_hour as(

SELECT
    -- count(session_id) as counts,
    TIMESTAMP_FROM_PARTS(
        DATE_PART(YEAR, created_at),
        DATE_PART(MONTH, created_at),
        DATE_PART(DAY, created_at),
        DATE_PART(HOUR, created_at),
        0,
        0) as hours,
    session_id,
    count(hours, session_id)
FROM
    stg_postgres__events
GROUP BY
    session_id, hours
)

SELECT
    AVG(num_session_per_hour) as avg_sessions_per_hour
FROM(
SELECT
    COUNT(hours) as num_session_per_hour,
    hours
FROM
    unique_session_per_hour
GROUP BY 
    hours   
ORDER BY 
    hours  
)    

```

**Answer: There are about 16.2 unique sessions per hour.** 