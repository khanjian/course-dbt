 {{
  config(
    materialized='table'
  )
}}
   
    
    SELECT
        session_id,
        min(created_at) as session_started_at,
        max(created_at) as session_ended_at,
    FROM    
        {{ref('stg_postgres__events')}}
    GROUP BY
        session_id