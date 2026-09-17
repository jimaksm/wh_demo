-- ADS 应用层：每日 GMV 报表
select
    order_date,
    count(distinct order_id) as order_cnt,
    count(distinct customer_id) as buyer_cnt,
    round(sum(item_amount), 2) as gmv,
    round(sum(item_amount) / nullif(count(distinct order_id), 0), 2) as avg_order_amount
from {{ ref('fact_order_detail') }}
where order_status = '已完成'
group by 1
order by 1
