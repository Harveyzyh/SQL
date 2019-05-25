
declare @day1 varchar(20), @day2 varchar(20), @day3 varchar(20)
set @day2 = convert(varchar(20), getdate() - 1, 112)
set @day1 = convert(varchar(20), getdate(), 112)

select ma.wlno 品号, ma.name 品名, ma.spec 规格, 
scdt.scdh 生产单号, convert(varchar(20), scdt.scrq, 23) 排单日期, convert(varchar(20), scdt.scjq, 23) 生产交期, scdt.sl 排单数量, 
(case when scrk.sl is null then 0 else scrk.sl end) - (case when sctk.sl is null then 0 else sctk.sl end) 总入库数量, 
(case when scdt.sl - (scrk.sl - sctk.sl) is null then scdt.sl else scdt.sl - (scrk.sl - sctk.sl) end) 欠数,
(case when sctk_day2.sl is null then 0 else sctk_day2.sl end) as 昨日入库量,
(case when sctk_day1.sl is null then 0 else sctk_day1.sl end) as 今日入库量, 
ma.unit 单位

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
left join (
select distinct scrkd.wlno, scrkd.indh as scdh, convert(varchar(20), scrkt.shrq, 112) as shrq, sum(scrkd.sl) - sum(scrkd.osl) as sl from tf_scrk as scrkd
	inner join mf_scrk as scrkt on scrkd.crkdh = scrkt.crkdh and scrkt.shbz = 1 
	group by scrkd.indh, scrkd.wlno, convert(varchar(20), scrkt.shrq, 112)
) as sctk_day2 on sctk_day2.wlno = ma.wlno and sctk_day2.scdh = scdt.scdh and sctk_day2.shrq = @day2
left join (
select distinct scrkd.wlno, scrkd.indh as scdh, convert(varchar(20), scrkt.shrq, 112) as shrq, sum(scrkd.sl) - sum(scrkd.osl) as sl from tf_scrk as scrkd
	inner join mf_scrk as scrkt on scrkd.crkdh = scrkt.crkdh and scrkt.shbz = 1 
	group by scrkd.indh, scrkd.wlno, convert(varchar(20), scrkt.shrq, 112)
) as sctk_day1 on sctk_day1.wlno = ma.wlno and sctk_day1.scdh = scdt.scdh and sctk_day1.shrq = @day1
where 1=1
and scdt.crklx = 'SCD'
order by scdt.scdh