# Витрина RFM

## 1.4. Подготовьте витрину данных

### 1.4.1. Сделайте VIEW для таблиц из базы production.**

```SQL
create view analysis.users as (
    select * from production.users
);

create view analysis.orderitems as (
    select * from production.orderitems
);

create view analysis.orderstatuses as (
    select * from production.orderstatuses
);

create view analysis.products as (
    select * from production.products
);

create view analysis.orders as (
    select * from production.orders
);
```

### 1.4.2. Напишите DDL-запрос для создания витрины.**

```sql
create table analysis.datamart_ddl as (
with last_order_date as (
    select user_id, max(order_ts)::date as order_date
    from analysis.orders o 
    where o.status  = 4
    group by user_id
),
order_count as (
    select user_id, count(*) as counter
    from analysis.orders o 
    where o.status  = 4
    group by user_id
),
order_sum as (
    select user_id, sum(payment) as sum_paid
    from analysis.orders o 
    where o.status  = 4
    group by user_id
)
select o.user_id, 
    order_date as last_order_date, ntile(5) over(order by order_date) as recency,
    coalesce(counter,0) as total_orders, ntile(5) over(order by coalesce(counter,0)) as frequency,
    coalesce(sum_paid,0) as order_sum, ntile(5) over(order by coalesce(sum_paid,0)) as monetary_value
from analysis.orders o 
    left join last_order_date od using(user_id)
    left join order_count oc using(user_id)
    left join order_sum using(user_id)
where
    o.order_ts > '2022-01-01'
group by 1,2,4,6
);
```

### 1.4.3. Напишите SQL запрос для заполнения витрины

```SQL
insert into analysis.tmp_rfm_recency 
select user_id, recency from analysis.datamart_ddl;

insert into analysis.tmp_rfm_frequency
select user_id, frequency from analysis.datamart_ddl;

insert into analysis.tmp_rfm_monetary_value
select user_id, monetary_value from analysis.datamart_ddl;
```



