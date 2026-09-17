-- ODS 贴源层：原样接入客户表
select * from {{ ref('customers') }}
