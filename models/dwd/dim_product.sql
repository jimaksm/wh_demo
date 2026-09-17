-- DWD 商品维度：类目标准化 + 毛利率
select
    product_id,
    trim(product_name) as product_name,
    case lower(category)
        when '数码' then '数码家电'
        when '服饰' then '服饰鞋包'
        when '家居' then '家居生活'
        when '食品' then '食品生鲜'
        else '其他'
    end as category_name,
    price,
    cost,
    case
        when price <= 0 or cost is null then '异常'
        when price > cost then '正常'
        else '异常'
    end as price_status,
    round((price - cost) / nullif(price, 0) * 100, 1) as gross_margin_pct
from {{ ref('ods_products') }}
