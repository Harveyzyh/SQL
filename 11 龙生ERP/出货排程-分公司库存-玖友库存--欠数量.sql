select ma.wlno, ma.name, ma.spec, (case when ma.kcsl + convert(numeric(10, 4), jy.kysl) is null then 0 else ma.kcsl + convert(numeric(10, 4), jy.kysl) end) as kcsl from material as ma 
left join WG_DB..JY_KYSL as jy on jy.wlno =  ma.wlno COLLATE Chinese_PRC_CI_AS 
where ma.wllx = '成品' 



select convert(varchar(20), chpdd.chrq, 23) as 出货日期, chpdd.wlno as 品号, chpdd.name as 品名, chpdd.spec as 规格, chpdd.sl as 出货数量, 
(case when ma.kcsl is null then 0 else ma.kcsl end) as 分公司库存, 
(case when jy.kysl is null then 0 else convert(numeric(10,2),jy.kysl) end) as 玖友库存, 
'' as 欠数, chpdd.unit as 单位

from (
	select chpdd.wlno as wlno, chpdd.name as name, chpdd.spec as spec, chpdd.chrq as chrq, chpdd.unit, sum(chpdd.sl) as sl from mf_chpd as chpdt
	inner join tf_chpd as chpdd on chpdt.crkdh = chpdd.crkdh and chpdt.shbz = 1
	where 1=1
	and convert(varchar(20), chpdd.chrq, 112) >= convert(varchar(20), getdate(), 112)
	group by chpdd.wlno, chpdd.name, chpdd.spec, chpdd.chrq, chpdd.unit
) as chpdd 
left join (
	select chpdd.wlno as wlno, convert(varchar(20), min(chpdd.chrq), 112) as minchrq from mf_chpd as chpdt
	inner join tf_chpd as chpdd on chpdt.crkdh = chpdd.crkdh and chpdt.shbz = 1
	where 1=1
	and convert(varchar(20), chpdd.chrq, 112) >= convert(varchar(20), getdate(), 112)
	group by chpdd.wlno 
) as chpdd2 on chpdd2.wlno = chpdd.wlno
left join material as ma on ma.wlno = chpdd.wlno
left join WG_DB..JY_KYSL as jy on jy.wlno =  chpdd.wlno COLLATE Chinese_PRC_CI_AS 
where 1=1
-- and chpdd.wlno = '3070201007'

order by chpdd2.minchrq, chpdd.wlno, chpdd.chrq
