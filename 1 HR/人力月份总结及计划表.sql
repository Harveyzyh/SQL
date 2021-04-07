

-- 根据表头，增加字段
if object_id(N'tempdb..#monthlysummeryreport', N'U') is not null
begin 
	drop table #monthlysummeryreport
end
create table #monthlysummeryreport (
	yymm varchar(6) default '199001', -- 当月年月
	lastyymm varchar(6) default '199001', -- 上月年月
	deptid varchar(12), deptautoid varchar(12), deptname varchar(50), 
	deptfullid varchar(12), -- 根据deptid后补零，用于表格排序
	deptlevel int, -- 部门层级
	当月期初人数 int, -- 当月期初人数
	当月期末人数 int, -- 当月期末人数
	入职人数 int, -- 入职人数
	应转正人数 int, -- 应转正人数
	实转正人数 int, -- 实转正人数
	晋升人数 int, -- 晋升人数
	当月离职人数 int, -- 当月离职人数
	自愿性离职人数 int, 
	非自愿性离职人数 int, 
	试用工离职人数 int, 
	转正工离职人数 int,
	应续签合同人数 int, 
	实续签合同人数 int
)
	 

-- 写入一级部门信息
insert into #monthlysummeryreport(deptid, deptautoid, deptname, deptfullid, deptlevel) 
select d1.deptid, d1.autoid, d1.deptname, left(cast(d1.deptid as varchar(12)) + '000000000000', 12) deptfullid, 1
from vorg_department as d1 
inner join vorg_department as d0 on d0.autoid = d1.parentid and d0.parentid = 0 and d1.isused = 1 

-- 根据已写入的一级部门，写入二级部门信息
insert into #monthlysummeryreport(deptid, deptautoid, deptname, deptfullid, deptlevel) 
select d1.deptid, d1.autoid, d1.deptname, left(cast(d1.deptid as varchar(12)) + '000000000000', 12) dptfullid, 2
from vorg_department as d1 
inner join #monthlysummeryreport as d0 on d0.deptautoid = d1.parentid and d1.isused = 1 and d0.deptlevel = 1

-- 根据已写入的二级部门，写入三级部门信息
-- insert into #monthlysummeryreport(deptid, deptautoid, deptname, deptfullid, deptlevel) 
-- select d1.deptid, d1.autoid, d1.deptname, left(cast(d1.deptid as varchar(12)) + '000000000000', 12) dptfullid, 3
-- from vorg_department as d1 
-- inner join #monthlysummeryreport as d0 on d0.deptautoid = d1.parentid and d1.isused = 1 and d0.deptlevel = 2 
-- and d0.deptid in ('00122') -- 因并非所有部门都需要带出三级，需要带出的可以在这里限定

-- 根据已写入的二级部门，写入三级部门信息(联友生产部的deptid特殊，需要重新构建三级部门的deptid)
insert into #monthlysummeryreport(deptid, deptautoid, deptname, deptfullid, deptlevel) 
select d1.deptid, d1.autoid, d1.deptname, left(cast(d0.deptid as varchar(12)) + right('00' + cast((row_number() over (order by d1.autoid)) as varchar(2)), 2) + '000000000000', 12) dptfullid, 3
from vorg_department as d1 
inner join #monthlysummeryreport as d0 on d0.deptautoid = d1.parentid and d1.isused = 1 and d0.deptlevel = 2 
and d0.deptid in ('00122') -- 因并非所有部门都需要带出三级，需要带出的可以在这里限定


-- 更新当月年月以及上月年月信息
declare @yymm  varchar(6),@lastyymm  varchar(6) 
set @yymm='202101'
set @lastyymm= convert(varchar(6), dateadd(month,-1,cast(@yymm+'01' as smalldatetime)),112)

update #monthlysummeryreport set yymm = @yymm, lastyymm = @lastyymm 

-- 更新当月期初人数
update #monthlysummeryreport set 当月期初人数 = isnull(c, 0) 
from #monthlysummeryreport as m
left join (
	select m.deptid, count(*) as c
	from vps_empinfo as e
	inner join #monthlysummeryreport as m on (e.deptid1 = m.deptid or e.deptid2 = m.deptid)
	where convert(varchar(6),entrydate,112)<= m.lastyymm 
	and (isactive=1 or isactive=0 and convert(varchar(6), dimissiondate,112)>m.lastyymm)
	group by m.deptid
) as e on e.deptid = m.deptid

-- 更新当月期末人数
update #monthlysummeryreport set 当月期末人数 = isnull(c, 0) 
from #monthlysummeryreport as m
left join (
	select m.deptid, count(*) as c
	from vps_empinfo as e
	inner join #monthlysummeryreport as m on (e.deptid1 = m.deptid or e.deptid2 = m.deptid)
	where convert(varchar(6),entrydate,112)<= m.yymm 
	and (isactive=1 or isactive=0 and  convert(varchar(6),dimissiondate,112)> m.yymm)
	group by m.deptid
) as e on e.deptid = m.deptid


-- 结果返回
select * from #monthlysummeryreport
	
order by deptfullid

