select ma.wlno 品号, ma.name 品名, ma.spec 规格, 
scdt.scdh 生产单号, convert(varchar(20), scdt.scrq, 23) 排单日期, convert(varchar(20), scdt.scjq, 23) 生产交期, scdt.sl 排单数量, 
(case when scrk.sl is null then 0 else scrk.sl end) - (case when sctk.sl is null then 0 else sctk.sl end) 入库数量 

from material as ma
inner join mf_wwd as scdt on scdt.wlno = ma.wlno and scdt.shbz = 1 and scdt.jsbz = 0
left join (
	select distinct scrkd.wlno, scrkd.indh as scdh, sum(scrkd.sl) as sl from tf_scrk as scrkd
	inner join mf_scrk as scrkt on scrkd.crkdh = scrkt.crkdh and scrkt.shbz = 1
	group by scrkd.wlno, scrkd.indh 
) as scrk on scrk.wlno = ma.wlno and scrk.scdh = scdt.scdh
left join (
	select distinct scrkd.wlno, scrkd.indh as scdh, sum(scrkd.osl) as sl from tf_scrk as scrkd
	inner join mf_scrk as scrkt on scrkd.crkdh = scrkt.crkdh and scrkt.shbz = 1
	group by scrkd.wlno, scrkd.indh 
) as sctk on sctk.wlno = ma.wlno and sctk.scdh = scdt.scdh

where 1=1
-- and ma.wllx = '成品'
-- and ma.name = '滑轮'
-- and scdt.scdh = 'SC-1903002-418'
-- and scdt.sl != (case when scrk.sl is null then 0 else scrk.sl end) - (case when sctk.sl is null then 0 else sctk.sl end)
-- and convert(varchar(20), scdt.scrq, 112) < '20190501'
-- and ma.wlno = '3070203007'

order by scdt.scdh, ma.wlno