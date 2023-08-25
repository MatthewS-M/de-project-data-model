CREATE TABLE analysis.tmp_rfm_monetary_value (
 user_id INT NOT NULL PRIMARY KEY,
 monetary_value INT NOT NULL CHECK(monetary_value >= 1 AND monetary_value <= 5)
);

with order_sum as (
    select user_id, coalesce(sum(payment),0) as sum_paid
    from analysis.orders o 
    where o.status  = 4
    group by user_id
)
insert into analysis.tmp_rfm_monetary_value
select o.user_id, sum_paid case when sum_paid is null then 1 else ntile(5) over(order by sum_paid) end as monetary_value
from analysis.orders o 
    left join order_sum using(user_id)
where
    o.order_ts > '2022-01-01'
group by user_id, sum_paid;
