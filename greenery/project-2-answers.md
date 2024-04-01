## Part 1 Models

### What is our user repeat rate?

```
select 
    count(*) as num_purchases
from(
select 
    distinct
    user_id, session_id
from
    fact_page_views
where 
    package_shipped = 1
) 
group by user_id
having num_purchases > 1
```

95 / 124 = 0.766

## Part 2 Tests

* Added a not_null and uniqueness tests to all the primary keys for the staging models
* Added an accepted_values tests for the `event_type` column in the events staging table to ensure our fact_page_views mart is accurate. 
* Did not find any "bad" data, all the tests passed. 

* To ensure these tests are passing regularly also added source freshness to the yml file of the source tables to ensure the data is not stale. 

## Part 3 dbt Snapshots

```
select
    * 
from
    inventory_snapshot
where DBT_VALID_TO is not null    
```

The following products had their inventory change from week 1 to week 2
* Pothos
* Philodendron
* Monstera
* String of pearls
