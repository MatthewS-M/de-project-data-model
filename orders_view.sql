create or replace view analysis.orders as 
with order_statuses as (
    select order_id, max(status_id) as new_status, max(dttm) as last_time 
    from production.orderstatuslog osl1 group by 1
)
select order_id, order_ts, user_id, bonus_payment, payment, cost, bonus_grant, status, os.new_status 
from production.orders join order_statuses os using(order_id);
