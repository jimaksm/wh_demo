-- DWS 客户主题：指标预计算
select
    c.customer_id,
    c.customer_name,
    c.city,
    c.age_group,
    c.active_flag,
    count(distinct f.order_id) as total_orders,
    count(distinct case when f.order_status = '已完成' then f.order_id end) as completed_orders,
    sum(f.quantity) as total_items,
    round(sum(case when f.order_status = '已完成' then f.item_amount else 0 end), 2) as completed_gmv,
    round(sum(case when f.pay_status = 'success' then f.pay_amount else 0 end), 2) as paid_amount,
    round(
        sum(case when f.order_status = '已完成' then f.item_amount else 0 end)
        / nullif(count(distinct case when f.order_status = '已完成' then f.order_id end), 0)
    , 2) as avg_order_value
from {{ ref('dim_customer') }} c
left join {{ ref('fact_order_detail') }} f on c.customer_id = f.customer_id
group by 1, 2, 3, 4, 5
