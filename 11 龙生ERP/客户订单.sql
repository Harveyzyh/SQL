select distinct post.cgdh, posd.seq, posd.dddh, posd.cgjq, post.cgrq 
-- update tf_pos set cgjq = post.cgrq + 1
from mf_pos as post
inner join tf_pos as posd on post.cgdh = posd.cgdh
where 1=1
and post.polx = 'PA' -- 客户订单
and post.shbz = 1
and (dddh like '3308%' or dddh like '3305%')

-- and dddh = '3308-19050465' and seq = 247
and dddh like '3305%'

order by post.cgdh, posd.seq

