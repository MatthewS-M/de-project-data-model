CREATE TABLE analysis.tmp_rfm_recency (
 user_id INT NOT NULL PRIMARY KEY,
 recency INT NOT NULL CHECK(recency >= 1 AND recency <= 5)
);

with last_order_date as (
    select user_id, max(order_ts)::date as order_date
    from analysis.orders o 
    where o.status  = 4
    group by user_id
)
insert into analysis.tmp_rfm_recency
select o.user_id, case when order_date is null then 1 else ntile(5) over(order by order_date) end as recency
from analysis.orders o 
    left join last_order_date od using(user_id)
where
    o.order_ts > '2022-01-01'
group by 1, order_date;
