insert into analysis.dm_rfm_segment 
select user_id, recency, frequency, monetary_value 
from analysis.tmp_rfm_recency 
	join analysis.tmp_rfm_frequency using(user_id) 
	join analysis.tmp_rfm_monetary_value using(user_id);

'
0	1	3	4
1	4	3	3
2	2	3	5
3	2	3	3
4	4	3	3
5	4	5	5
6	1	3	5
7	4	3	2
8	1	2	3
9	1	2	2
10	3	5	2    
    '
