create view analysis.dm_rfm_segments as (
with last_order_date as (
    select user_id, max(order_ts)::date as order_date
    from production.orders o 
    join production.users u on u.id=o.user_id 
    join production.orderstatuses os on os.id=o.status 
    where key='Closed'
    group by user_id
    ),
order_count as (
    select user_id, count(*) as counter
    from production.orders o 
    join production.users u on u.id=o.user_id 
    join production.orderstatuses os on os.id=o.status 
    where key='Closed'
    group by user_id
    ),
order_sum as (
    select user_id, sum(payment) as sum_paid
    from production.orders o 
    join production.users u on u.id=o.user_id 
    join production.orderstatuses os on os.id=o.status 
    where key='Closed'
    group by user_id
)
select o.user_id, 
    order_date as last_order_date, ntile(5) over(order by order_date) as recency,
    coalesce(counter,0) as total_orders, ntile(5) over(order by coalesce(counter,0)) as frequency,
	coalesce(sum_paid,0) as order_sum, ntile(5) over(order by coalesce(sum_paid,0)) as monetary_value
from production.orders o 
    left join last_order_date od using(user_id)
    left join order_count oc using(user_id)
    left join order_sum using(user_id)
group by 1,2,4,6
having min(order_ts)>to_timestamp('2022-01-01', 'YYYY-MM-DD'));



