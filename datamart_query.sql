CREATE TABLE analysis.tmp_rfm_recency (
 user_id INT NOT NULL PRIMARY KEY,
 recency INT NOT NULL CHECK(recency >= 1 AND recency <= 5)
);
CREATE TABLE analysis.tmp_rfm_frequency (
 user_id INT NOT NULL PRIMARY KEY,
 frequency INT NOT NULL CHECK(frequency >= 1 AND frequency <= 5)
);
CREATE TABLE analysis.tmp_rfm_monetary_value (
 user_id INT NOT NULL PRIMARY KEY,
 monetary_value INT NOT NULL CHECK(monetary_value >= 1 AND monetary_value <= 5)
);

insert into analysis.tmp_rfm_recency 
select user_id, recency from analysis.datamart_ddl;

insert into analysis.tmp_rfm_frequency
select user_id, frequency from analysis.datamart_ddl;

insert into analysis.tmp_rfm_monetary_value
select user_id, monetary_value from analysis.datamart_ddl;

create table analysis.dm_rfm_segments as 
select user_id, recency, frequency, monetary_value 
from analysis.tmp_rfm_recency 
    join analysis.tmp_rfm_frequency using(user_id)
    join analysis.tmp_rfm_monetary_value using(user_id);

'
0	1	3	4
1	4	3	3
2	2	3	5
3	2	3	3
4	4	4	3
5	4	5	5
6	1	3	5
7	4	2	2
8	1	1	3
9	1	2	2
10	3	4	2  
  '

