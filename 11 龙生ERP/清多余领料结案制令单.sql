select mf_ntl.crkcpt, mf_ntl.crkdh, mf_ntl.zy, mf_ntl.shbz, tf_ntl.bz, tf_ntl.indh, mf_wwd.jsbz
-- update mf_ntl set zy = '清除4月多余领料及结案制令单'
-- update tf_ntl set bz = '清除4月多余领料及结案制令单'
-- update mf_wwd set jsbz = 1
from mf_ntl
inner join tf_ntl on mf_ntl.crkdh = tf_ntl.crkdh
inner join mf_wwd on tf_ntl.indh = mf_wwd.scdh
where mf_ntl.crklx = 'sctl'
and convert(varchar(20), crkrq, 112) in ('20190525', '20190526')
and mf_ntl.crkcpt like '%DS'
and mf_ntl.zy not like '%3月%'
order by mf_ntl.crkdh


-- select * from mf_ntl where crkdh = 'TL-19050019'