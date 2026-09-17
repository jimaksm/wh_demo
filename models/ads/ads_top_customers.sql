-- ADS 应用层：TOP 客户
select
    customer_id,
    customer_name,
    city,
    completed_orders,
    completed_gmv,
    avg_order_value
from {{ ref('dws_customer_stats') }}
where completed_orders > 0
order by completed_gmv desc
