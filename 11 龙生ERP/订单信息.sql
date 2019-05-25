

SELECT convert(varchar(20), mf_pos.cgrq, 112) ddrq, mf_pos.cgdh, tf_pos.seq, convert(varchar(20), tf_pos.cgjq, 112) ddjq, 
tf_pos.wlno, tf_pos.name, tf_pos.spec, tf_pos.ys, tf_pos.sl, tf_pos.dddh, tf_pos.csdh, tf_pos.bz
FROM mf_pos
inner join tf_pos on mf_pos.cgdh = tf_pos.cgdh
where mf_pos.polx = 'PA' and mf_pos.gysname = '联友'
and mf_pos.cgdh like '%%'
and convert(varchar(20), mf_pos.cgrq, 112) like '%20190423%'

order by convert(varchar(20), mf_pos.cgrq, 112), mf_pos.cgdh, tf_pos.seq