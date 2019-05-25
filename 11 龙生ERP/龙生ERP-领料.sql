
select (CASE wwd.crklx WHEN 'SCD' THEN '生产单' WHEN 'WWD' THEN '委外单' ELSE wwd.crklx END) 单据类型, convert(varchar(20), wwd.zdrq, 23) 生产制单日期, 
scd.scd_no 生产单号, wwd.wlno 生产品号, wwd.name 生产品名, wwd.spec 生产规格, wwd.sl 生产数量, 

-- (CASE scrk.crklx WHEN 'scrk' THEN '生产入库' WHEN 'sctk' THEN '成产退库'  WHEN 'jgrk' THEN '加工入库' WHEN 'wwrk' THEN '委外入库' ELSE scrk.crklx END) 出入库类型, 
scrk.sl 生产入库数量, -- scrk.osl 生产退库数量, 

scd.wlno 物料品号, scd.name 物料品名, material.kcsl 实际库存, scd.BOMSL BOM用量, scd.sqsl 物料用量, 

(CASE ntl.crklx WHEN 'scnl' THEN '领料' WHEN 'sctl' THEN '退料'  WHEN 'wwnl' THEN '委外领料' ELSE ntl.crklx END) 领退料类型, 
(CASE WHEN sum(convert(NUMERIC(10, 2), ntl.sl)) IS NULL THEN 0 ELSE sum(convert(NUMERIC(10, 2), ntl.sl)) END)  退料数量, 
(CASE WHEN sum(convert(NUMERIC(10, 2), ntl.osl)) IS NULL THEN 0 ELSE sum(convert(NUMERIC(10, 2), ntl.osl)) END) 领料出库数量

from TF_SCD as scd

left join mf_wwd as wwd on wwd.scdh = scd.scd_no
left join tf_ntl as ntl on scd.scd_no = ntl.indh and scd.seq = ntl.inseq
left join material on material.wlno = scd.wlno
left join (select indh, crklx, sum(sl) sl, sum(osl) osl from (
select distinct scrk.indh, scrk.crklx, convert(NUMERIC(10, 2), scrk.sl) sl, convert(NUMERIC(10, 2), scrk.osl) osl from tf_scrk as scrk
left join TF_SCD as scd on scrk.indh = scd.scd_no) as scrk
group by indh, crklx
) as scrk on scrk.indh = scd.scd_no
where 1=1
and scd.scd_no in (
	select distinct scd.scd_no
	from TF_SCD as scd
	left join tf_ntl as ntl on scd.scd_no = ntl.indh and scd.seq = ntl.inseq 
	left join tf_scrk as scrk on scrk.indh = scd.scd_no 
	where 1=1
	and (scrk.crklx is not null and rtrim(scrk.crklx) != '') 
	and (ntl.crklx is null or rtrim(ntl.crklx) = '')
	)
	
	
and convert(varchar(20), wwd.zdrq, 112) < '20190501'
-- and material.kcsl >= scd.sqsl
-- and material.name = '轮片盖'
-- and material.wlno = '203007'
-- and scrk.sl = wwd.sl

-- and wwd.crklx = 'SCD'

group by wwd.crklx, convert(varchar(20), wwd.zdrq, 23), scd.scd_no, wwd.wlno, material.kcsl, scd.wlno, wwd.name, wwd.spec, wwd.sl, 
	scd.seq, scd.name, scd.bomsl, scd.sqsl, 
	ntl.crklx, scrk.crklx, scrk.sl, scrk.osl
order by scd.scd_no, scd.seq