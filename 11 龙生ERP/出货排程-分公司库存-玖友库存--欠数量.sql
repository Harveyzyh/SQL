
select convert(varchar(20), chpd.chrq, 23) as 出货日期, chpd.wlno as 品号, chpd.name as 品名, chpd.spec as 规格, chpd.ys as 大小件, convert(int, chpd.sl) as 出货数量, 
(case when ma.kcsl is null then 0 else convert(int, ma.kcsl) end) as 分公司库存, 
(case when jy.kysl is null then 0 else convert(int, jy.kysl) end) as 玖友库存, 
'' as 累计出货数, (case when qjsl.qs is null then 0 else qjsl.qs end) as 欠数, chpd.unit as 单位

from (
	select chpdt.khno as khno, chpdd.wlno as wlno, chpdd.name as name, chpdd.spec as spec, chpdd.chrq as chrq, chpdd.unit as unit, chpdd.ys as ys, sum(chpdd.sl) as sl from mf_chpd as chpdt
	inner join tf_chpd as chpdd on chpdt.crkdh = chpdd.crkdh and chpdt.shbz = 1
	where 1=1
	and convert(varchar(20), chpdd.chrq, 112) >= convert(varchar(20), getdate(), 112)
	group by chpdt.khno, chpdd.wlno, chpdd.name, chpdd.spec, chpdd.chrq, chpdd.unit, chpdd.ys
) as chpd
left join (
	select chpdd.wlno as wlno, convert(varchar(20), min(chpdd.chrq), 112) as minchrq from mf_chpd as chpdt
	inner join tf_chpd as chpdd on chpdt.crkdh = chpdd.crkdh and chpdt.shbz = 1
	where 1=1
	and convert(varchar(20), chpdd.chrq, 112) >= convert(varchar(20), getdate(), 112)
	group by chpdd.wlno 
) as chpd2 on chpd2.wlno = chpd.wlno
left join (
	select chpdd.wlno as wlno, convert(int, sum(chpdd.chsl) - sum(chpdd.sl))as qs from tf_chpd as chpdd
	inner join mf_chpd as chpdt on chpdt.crkdh = chpdd.crkdh 
	where 1=1 
-- 	and convert(varchar(20), chpdd.chrq, 112) >= '20190501'
	and chpdt.shbz = 1 and chpdd.jsbz = 0 and chpdt.jsbz = 0
	group by chpdd.wlno
) as qjsl on qjsl.wlno = chpd.wlno
left join material as ma on ma.wlno = chpd.wlno
left join WG_DB..JY_KYSL as jy on jy.wlno =  chpd.wlno COLLATE Chinese_PRC_CI_AS 
where 1=1
and chpd.khno = 'C001'
-- and chpd.wlno = '3070201007'
order by chpd2.minchrq, chpd.wlno, chpd.chrq



select chpdd.wlno as wlno, sum(chpdd.chsl) - sum(chpdd.sl) as qs from tf_chpd as chpdd
inner join mf_chpd as chpdt on chpdt.crkdh = chpdd.crkdh 
where convert(varchar(20), chpdd.chrq, 112) >= '20190401'
and chpdt.shbz = 1 and chpdd.jsbz = 0 and chpdt.jsbz = 0
group by chpdd.wlno
