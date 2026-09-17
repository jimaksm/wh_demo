-- DWD 事实明细：四表关联 + 状态清洗 + 配送时长
select
    oi.item_id,
    o.order_id,
    o.customer_id,
    oi.product_id,
    o.order_date,
    oi.quantity,
    oi.price as item_price,
    round(oi.quantity * oi.price, 2) as item_amount,
    o.order_amount,
    case upper(coalesce(o.status, ''))
        when 'COMPLETED' then '已完成'
        when 'PENDING' then '待支付'
        when 'CANCELLED' then '已取消'
        else '未知'
    end as order_status,
    p.pay_type,
    p.pay_amount,
    p.pay_status,
    s.carrier,
    s.ship_date,
    s.delivery_date,
    date_diff('day', s.ship_date, s.delivery_date) as delivery_days
from {{ ref('ods_orders') }} o
inner join {{ ref('ods_order_items') }} oi on o.order_id = oi.order_id
left join {{ ref('ods_payments') }} p on o.order_id = p.order_id
left join {{ ref('ods_shipping') }} s on o.order_id = s.order_id
