CREATE TABLE analysis.tmp_rfm_frequency (
 user_id INT NOT NULL PRIMARY KEY,
 frequency INT NOT NULL CHECK(frequency >= 1 AND frequency <= 5)
);

with order_count as (
    select user_id, coalesce(count(*),0) as counter
    from analysis.orders o 
    where o.status  = 4
    group by user_id
)
insert into analysis.tmp_rfm_frequency
select o.user_id, case when counter is null then 1 else ntile(5) over(order by counter) end as frequency
from analysis.orders o 
    left join order_count oc using(user_id)
where
    o.order_ts > '2022-01-01'
group by user_id, counter;
