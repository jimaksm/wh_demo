-- DWS 类目主题：按天+类目汇总
select
    f.order_date,
    p.category_name,
    count(distinct f.order_id) as order_cnt,
    sum(f.quantity) as item_cnt,
    round(sum(f.item_amount), 2) as gmv
from {{ ref('fact_order_detail') }} f
join {{ ref('dim_product') }} p on f.product_id = p.product_id
where f.order_status = '已完成'
group by 1, 2
