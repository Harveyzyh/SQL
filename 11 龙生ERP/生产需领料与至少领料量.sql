select (case scdt.jsbz when 1 then '是' when 0 then '否' end) 结案,  (case scdt.wcbz when 1 then '是' when 0 then '否' end) 完工, 
ma.wlno 品号, ma.name 品名, ma.spec 规格, 
scdt.scdh 生产单号, scdt.csname 生产部门, convert(varchar(20), scdt.scrq, 23) 排单日期, convert(varchar(20), scdt.scjq, 23) 生产交期, scdt.sl 排单数量, 
(case when scrk.sl is null then 0 else scrk.sl end) - (case when sctk.sl is null then 0 else sctk.sl end) 入库数量, scdd.wlno 物料编号, scdd.name 物料名称, scdd.spec 物料规格, convert(numeric(10,4), scdd.bomsl) BOM用量, 
scdd.sl 需领料数量, convert(numeric(10,4), scdd.bomsl*((case when scrk.sl is null then 0 else scrk.sl end) - (case when sctk.sl is null then 0 else sctk.sl end))) 至少领用数量, 
(case when scnl.sl is null then 0 else scnl.sl end) - (case when sctl.sl is null then 0 else sctl.sl end) 已领数量, 
(case when scbl.sl is null then 0 else scbl.sl end) 补料数量, 
ma_wl.kcsl 库存数量, ma_wl.unit 单位,
((convert(numeric(10,4), scdd.bomsl*((case when scrk.sl is null then 0 else scrk.sl end) - (case when sctk.sl is null then 0 else sctk.sl end)))) - ((case when scnl.sl is null then 0 else scnl.sl end) - (case when sctl.sl is null then 0 else sctl.sl end))) * -1  '需领/退数量'

from material as ma
inner join mf_wwd as scdt on scdt.wlno = ma.wlno and scdt.shbz = 1 -- and scdt.wcbz = 0 /*完工标志*/
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
inner join tf_scd as scdd on scdd.scd_no = scdt.scdh
inner join material as ma_wl on ma_wl.wlno = scdd.wlno
left join (
	select tf_ntl.wlno, tf_ntl.indh as scdh, sum(osl) as sl from tf_ntl
	inner join mf_ntl on mf_ntl.crkdh = tf_ntl.crkdh and mf_ntl.shbz = 1 and tf_ntl.crklx = 'scnl'
	group by tf_ntl.indh, tf_ntl.wlno 
) as scnl on scnl.scdh = scdt.scdh and scnl.wlno = scdd.wlno
left join (
	select tf_ntl.wlno, tf_ntl.indh as scdh, sum(sl) as sl from tf_ntl
	inner join mf_ntl on mf_ntl.crkdh = tf_ntl.crkdh and mf_ntl.shbz = 1 and tf_ntl.crklx = 'sctl'
	group by tf_ntl.indh, tf_ntl.wlno 
) as sctl on sctl.scdh = scdt.scdh and sctl.wlno = scdd.wlno
left join (
	select tf_ntl.wlno, tf_ntl.indh as scdh, sum(osl) as sl from tf_ntl
	inner join mf_ntl on mf_ntl.crkdh = tf_ntl.crkdh and mf_ntl.shbz = 1 and tf_ntl.crklx = 'scbl'
	group by tf_ntl.indh, tf_ntl.wlno 
) as scbl on sctl.scdh = scdt.scdh and sctl.wlno = scdd.wlno

where 1=1
-- and ma.wllx = '成品'
-- and ma.name = '滑轮'
-- and scdt.scdh like 'SC-1905092-1'
-- and scdt.sl = (case when scrk.sl is null then 0 else scrk.sl end) - (case when sctk.sl is null then 0 else sctk.sl end)
-- and convert(varchar(20), scdt.scjq, 112) < '20190501'
-- and scdt.csname = '注塑车间'
-- and (convert(numeric(10,4), scdd.bomsl*((case when scrk.sl is null then 0 else scrk.sl end) - (case when sctk.sl is null then 0 else sctk.sl end)))) - ((case when scnl.sl is null then 0 else scnl.sl end) - (case when sctl.sl is null then 0 else sctl.sl end)) <0

order by scdt.scdh, scdd.seq