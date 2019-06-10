-- 查询信息
select distinct posd.wlno 品号, posd.name 品名, posd.ys 大件产品, posd.spec 规格, posd.unit 单位, 
posd.dddh as 联友采购单号, posd.bz 备注, posd.csdh 生产单号, posd.ck 仓库, 
posd.sl 订单数量, (posd.sl - (case when chpdd.sl is null then 0 else chpdd.sl end)) as 未录入排程数量, 
post.cgdh as 订单号, posd.seq as 订单序号 
from mf_pos as post
inner join tf_pos as posd on post.cgdh = posd.cgdh
left join (
	select wlno, indh, inseq, sum(sl) as sl from tf_chpd group by wlno, indh, inseq
) as chpdd on chpdd.wlno = posd.wlno and chpdd.indh = posd.cgdh and chpdd.inseq = posd.seq
left join (select '' as crkdh) as dh on 1=1
where 1=1
and post.polx = 'PA' -- 客户订单
and post.gysno = 'C001'
and post.shbz = 1
and posd.jsbz = 0
and post.jsbz = 0
and posd.dddh like '3301%'
and posd.csdh = '15795'
order by posd.csdh


-- 检测是否有可写入信息
declare @scdh varchar(20)
declare @rownum int
declare @minnum int
declare @yucount int
declare @shang int
declare @maxnum int
set @scdh = '15795'

select @rownum = count(posd.wlno)
from mf_pos as post
inner join tf_pos as posd on post.cgdh = posd.cgdh
left join (
	select wlno, indh, inseq, sum(sl) as sl from tf_chpd group by wlno, indh, inseq
) as chpdd on chpdd.wlno = posd.wlno and chpdd.indh = posd.cgdh and chpdd.inseq = posd.seq
left join (select '' as crkdh) as dh on 1=1
where 1=1
and post.polx = 'PA' -- 客户订单
and post.gysno = 'C001'
and post.shbz = 1
and posd.jsbz = 0
and post.jsbz = 0
and posd.dddh like '3301%'
and posd.csdh = @scdh
and posd.sl - (case when chpdd.sl is null then 0 else chpdd.sl end) > 0

select @minnum = min(posd.sl - (case when chpdd.sl is null then 0 else chpdd.sl end))
from mf_pos as post
inner join tf_pos as posd on post.cgdh = posd.cgdh
left join (
	select wlno, indh, inseq, sum(sl) as sl from tf_chpd group by wlno, indh, inseq
) as chpdd on chpdd.wlno = posd.wlno and chpdd.indh = posd.cgdh and chpdd.inseq = posd.seq
left join (select '' as crkdh) as dh on 1=1
where 1=1
and post.polx = 'PA' -- 客户订单
and post.gysno = 'C001'
and post.shbz = 1
and posd.jsbz = 0
and post.jsbz = 0
and posd.dddh like '3301%'
and posd.csdh = @scdh
and posd.sl - (case when chpdd.sl is null then 0 else chpdd.sl end) > 0

select @yucount = count(posd.wlno)
from mf_pos as post
inner join tf_pos as posd on post.cgdh = posd.cgdh
left join (
	select wlno, indh, inseq, sum(sl) as sl from tf_chpd group by wlno, indh, inseq
) as chpdd on chpdd.wlno = posd.wlno and chpdd.indh = posd.cgdh and chpdd.inseq = posd.seq
left join (select '' as crkdh) as dh on 1=1
where 1=1
and post.polx = 'PA' -- 客户订单
and post.gysno = 'C001'
and post.shbz = 1
and posd.jsbz = 0
and post.jsbz = 0
and posd.dddh like '3301%'
and posd.csdh = @scdh
and (posd.sl - (case when chpdd.sl is null then 0 else chpdd.sl end)) % @minnum  > 0
and posd.sl - (case when chpdd.sl is null then 0 else chpdd.sl end) > 0

select @shang = max((posd.sl - (case when chpdd.sl is null then 0 else chpdd.sl end)) / @minnum)
from mf_pos as post
inner join tf_pos as posd on post.cgdh = posd.cgdh
left join (
	select wlno, indh, inseq, sum(sl) as sl from tf_chpd group by wlno, indh, inseq
) as chpdd on chpdd.wlno = posd.wlno and chpdd.indh = posd.cgdh and chpdd.inseq = posd.seq
left join (select '' as crkdh) as dh on 1=1
where 1=1
and post.polx = 'PA' -- 客户订单
and post.gysno = 'C001'
and post.shbz = 1
and posd.jsbz = 0
and post.jsbz = 0
and posd.dddh like '3301%'
and posd.csdh = @scdh
and (posd.sl - (case when chpdd.sl is null then 0 else chpdd.sl end)) / @minnum  > 0
and posd.sl - (case when chpdd.sl is null then 0 else chpdd.sl end) > 0

select @maxnum = @minnum - chpc.sl from (
select distinct (case when chpc.sl is null then 0 else chpc.sl end) as sl from zzzz_test as test
left join (select sum(sl) as sl from zzzz_chpc where flag = 0 and scdh =@scdh group by scdh) as chpc on 1=1
) as chpc

select @scdh, @rownum, (case when @minnum is null then 0 else @minnum end), @yucount, 
(case when @shang is null then 0 else @shang end), (case when @maxnum is null then 0 else @maxnum end)


-- 单身数据（有排程套数）
declare @dh varchar(20)
declare @uid varchar(20)
declare @scdh varchar(20)
declare @chrq varchar(20)
declare @chrqDate datetime
declare @maxseq int
declare @addsl int
declare @minnum int
set @uid = 'DS'
set @dh = 'Test'
set @scdh = '66540'
set @chrq = '20190606'

-- 获取最大序号
select @maxseq = (case when max(seq) is null then 0 else max(seq)+1 end) from tf_chpd where crkdh = @dh

-- 获取套数
select @addsl = sl, @chrqDate = chrq from zzzz_chpc where chrq = @chrq and convert(varchar(20), scdh, 112) = @scdh

-- 获取最小值
select @minnum = min(bb.sl) from (
select distinct posd.wlno, posd.name, posd.cz, posd.ys, posd.spec, posd.unit, (posd.sl - (case when chpdd.sl is null then 0 else chpdd.sl end)) as sl, 0 as dj, @chrqDate as chrq, 
posd.bz, dh.crkdh, ROW_NUMBER() over(order by posd.seq) + @maxseq as seq, post.cgdh as indh, posd.seq as inseq, 'CHPD' as crklx, 0 as jsbz, posd.dddh as dddh, 
posd.csdh, posd.ck, 0 as chsl, '联友公司' as gxss, null as thinkdh, null as thinseq
from mf_pos as post
inner join tf_pos as posd on post.cgdh = posd.cgdh
left join (
	select wlno, indh, inseq, sum(sl) as sl from tf_chpd group by wlno, indh, inseq
) as chpdd on chpdd.wlno = posd.wlno and chpdd.indh = posd.cgdh and chpdd.inseq = posd.seq
left join (select @dh as crkdh) as dh on 1=1
inner join zzzz_chpc as chpc on chpc.scdh = posd.csdh
where 1=1
and post.polx = 'PA' -- 客户订单
and post.gysno = 'C001'
and post.shbz = 1
and posd.jsbz = 0
and post.jsbz = 0
and posd.dddh like '3301%'
and (posd.sl - (case when chpdd.sl is null then 0 else chpdd.sl end)) > 0
and posd.csdh = @scdh
) as bb

-- 写入单身
-- insert into tf_chpd
select distinct posd.wlno, posd.name, posd.cz, posd.ys, posd.spec, posd.unit, convert(numeric(10 ,2), (posd.sl - (case when chpdd.sl is null then 0 else chpdd.sl end))/@minnum*@addsl) as sl, 
0 as dj, @chrqDate as chrq, posd.bz, dh.crkdh, ROW_NUMBER() over(order by posd.seq) + @maxseq as seq, post.cgdh as indh, posd.seq as inseq, 'CHPD' as crklx, 0 as jsbz, 
posd.dddh as dddh, posd.csdh, posd.ck, 0 as chsl, '联友公司' as gxss, null as thinkdh, null as thinseq
from mf_pos as post
inner join tf_pos as posd on post.cgdh = posd.cgdh
left join (
	select wlno, indh, inseq, sum(sl) as sl from tf_chpd group by wlno, indh, inseq
) as chpdd on chpdd.wlno = posd.wlno and chpdd.indh = posd.cgdh and chpdd.inseq = posd.seq
left join (select @dh as crkdh) as dh on 1=1
inner join zzzz_chpc as chpc on chpc.scdh = posd.csdh and chpc.chrq = @chrqDate
where 1=1
and post.polx = 'PA' -- 客户订单
and post.gysno = 'C001'
and post.shbz = 1
and posd.jsbz = 0
and post.jsbz = 0
and posd.dddh like '3301%'
and (posd.sl - (case when chpdd.sl is null then 0 else chpdd.sl end)) > 0
and posd.csdh = @scdh
order by post.cgdh, posd.seq


-- 单身数据（无排程套数）
declare @dh varchar(20)
declare @chrq varchar(20)
declare @scdh varchar(20)
declare @maxseq int
set @dh = 'Test'
set @chrq = '20190604'
set @scdh = '9000267'

-- 获取最大序号
select @maxseq = (case when max(seq) is null then 0 else max(seq)+1 end) from tf_chpd where crkdh = @dh

	-- 写入单身
	-- insert into tf_chpd
select distinct posd.wlno, posd.name, posd.cz, posd.ys, posd.spec, posd.unit, (posd.sl - (case when chpdd.sl is null then 0 else chpdd.sl end)) as sl, 0 as dj, convert(datetime, @chrq, 112) as chrq, 
posd.bz, dh.crkdh, ROW_NUMBER() over(order by posd.seq) + @maxseq as seq, post.cgdh as indh, posd.seq as inseq, 'CHPD' as crklx, 0 as jsbz, posd.dddh as dddh, 
posd.csdh, posd.ck, 0 as chsl, '联友公司' as gxss, null as thinkdh, null as thinseq
from mf_pos as post
inner join tf_pos as posd on post.cgdh = posd.cgdh
left join (
	select wlno, indh, inseq, sum(sl) as sl from tf_chpd group by wlno, indh, inseq
) as chpdd on chpdd.wlno = posd.wlno and chpdd.indh = posd.cgdh and chpdd.inseq = posd.seq
left join (select @dh as crkdh) as dh on 1=1
where 1=1
and post.polx = 'PA' -- 客户订单
and post.gysno = 'C001'
and post.shbz = 1
and posd.jsbz = 0
and posd.dddh like '3301%'
and (posd.sl - (case when chpdd.sl is null then 0 else chpdd.sl end)) > 0
and posd.csdh = @scdh
order by post.cgdh, posd.seq


-- 更新订单里的已排单数量
select posd.cgdh, posd.seq, posd.wlno, posd.name, posd.spec, posd.chpdsl, (case when chpd.sl is null then 0 else chpd.sl end)
-- update tf_pos set chpdsl = (case when chpd.sl is null then 0 else chpd.sl end)
from tf_pos as posd
left join 
(
select indh, inseq, wlno, sum(sl) as sl from tf_chpd group by indh, inseq, wlno
) as chpd on chpd.wlno = posd.wlno and chpd.indh = posd.cgdh and chpd.inseq = posd.seq
where 1=1
and posd.cgdh in (select indh from tf_chpd where crkdh = 'SA-1905182')
