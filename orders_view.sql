create or replace view analysis.orders as
with order_statuses as (
  select order_id, status_id as new_status, dttm,
         row_number() over (partition by order_id order by dttm desc) as rn
  from production.orderstatuslog
)
select o.order_id, o.order_ts, o.user_id, o.bonus_payment, o.payment, o.cost, o.bonus_grant, new_status
from production.orders o
join order_statuses os on o.order_id = os.order_id
where os.rn = 1;

-- или

create or replace view analysis.orders as
with order_statuses as (
  select order_id, status_id as new_status, dttm,
         rank() over (partition by order_id order by dttm desc) as rnk
  from production.orderstatuslog
)
select o.order_id, o.order_ts, o.user_id, o.bonus_payment, o.payment, o.cost, o.bonus_grant, new_status
from production.orders o
join order_statuses os on o.order_id = os.order_id
where os.rnk = 1;

