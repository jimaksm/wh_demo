-- DWD 客户维度：清洗标准化
select
    customer_id,
    trim(name) as customer_name,
    case upper(coalesce(gender, 'X'))
        when 'F' then '女'
        when 'M' then '男'
        else '未知'
    end as gender_name,
    age,
    case
        when age is null then '未知'
        when age < 30 then '青年(<30)'
        when age <= 45 then '中年(30-45)'
        else '中老年(>45)'
    end as age_group,
    trim(city) as city,
    register_date,
    case when is_active = 1 then '活跃' else '流失' end as active_flag,
    year(register_date) as register_year
from {{ ref('ods_customers') }}
