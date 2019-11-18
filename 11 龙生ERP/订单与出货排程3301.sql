
-- 创建单号
declare @dh varchar(20)
declare @sl int
declare @uid varchar(20)
set @uid = 'DS'
set @dh = (select top 1 'XP-' +convert(varchar(20), substring(crkdh, 4, 9) +1) as crkdh from mf_chpd order by crkdh desc )
set @sl = (
	select count(*) from (
		select distinct posd.wlno, posd.name, posd.cz, posd.ys, posd.spec, posd.unit, (posd.sl - (case when chpdd.sl is null then 0 else chpdd.sl end)) as sl, 0 as dj, post.cgrq + 1 as chrq, 
		posd.bz, dh.crkdh, ROW_NUMBER() over(order by posd.seq) as seq, post.cgdh as indh, posd.seq as inseq, 'CHPD' as crklx, 0 as jsbz, posd.dddh as dddh, 
		posd.csdh, posd.ck, 0 as chsl, '联友公司' as gxss, null as thinkdh, null as thinseq
		from mf_pos as post
		inner join tf_pos as posd on post.cgdh = posd.cgdh
		left join tf_chpd as chpdd on chpdd.wlno = posd.wlno and chpdd.indh = posd.cgdh and chpdd.inseq = posd.seq
		left join (select '' as crkdh) as dh on 1=1
		where 1=1
		and post.polx = 'PA' -- 客户订单
		and post.gysno = 'C001'
		and post.shbz = 1
		and posd.dddh like '3301%'
-- 		and posd.sl - (case when chpdd.sl is null then 0 else chpdd.sl end) != 0
-- 		and convert(datetime, post.cgrq, 112) = convert(varchar(20), getdate(), 112)	
		and posd.csdh = '66430'
	) as sl
)

if(@sl > 0)
begin

	-- 写入单头
-- 	insert into mf_chpd
	select @dh as crkdh, @uid as zydm, null as zy, null as crkcpt, 'TS01' as gsdm, '仓库部' as zbdm , 
	0 as jsbz, 'CHPD' as crklx, convert(datetime, convert(varchar(20), getdate(), 112), 112) as crkrq, 
	@uid as shr, getdate() as shrq, 1 as shbz, null as shdh, getdate() as ZDRQ, 'C001' as khno, '联友' as khname 

	-- 写入单身
-- 	insert into tf_chpd
	select distinct posd.wlno, posd.name, posd.cz, posd.ys, posd.spec, posd.unit, (posd.sl - (case when chpdd.sl is null then 0 else chpdd.sl end)) as sl, 0 as dj, post.cgrq + 1 as chrq, 
	posd.bz, dh.crkdh, ROW_NUMBER() over(order by posd.seq) as seq, post.cgdh as indh, posd.seq as inseq, 'CHPD' as crklx, 0 as jsbz, posd.dddh as dddh, 
	posd.csdh, posd.ck, 0 as chsl, '联友公司' as gxss, null as thinkdh, null as thinseq
	-- update tf_pos set cgjq = post.cgrq + 1
	from mf_pos as post
	inner join tf_pos as posd on post.cgdh = posd.cgdh
	left join tf_chpd as chpdd on chpdd.wlno = posd.wlno and chpdd.indh = posd.cgdh and chpdd.inseq = posd.seq
	left join (select @dh as crkdh) as dh on 1=1
	where 1=1
	and post.polx = 'PA' -- 客户订单
	and post.gysno = 'C001'
	and post.shbz = 1
	and (posd.dddh like '3308%' or posd.dddh like '3305%')
	and convert(datetime, post.cgrq, 112) = convert(varchar(20), getdate(), 112)
	order by post.cgdh, posd.seq
end

select @dh as a, @sl as a 

/*
-- 更新订单里的已排单数量
select posd.cgdh, posd.seq, posd.wlno, posd.name, posd.spec, posd.chpdsl, (case when chpd.sl is null then 0 else chpd.sl end)
-- update tf_pos set pdsl = sl
from tf_pos as posd
left join 
(
select indh, inseq, wlno, sum(sl) as sl from tf_chpd group by indh, inseq, wlno
) as chpd on chpd.wlno = posd.wlno and chpd.indh = posd.cgdh and chpd.inseq = posd.seq
where 1=1
-- and posd.cgdh = 'SA-1905158'
and posd.chpdsl != (case when chpd.sl is null then 0 else chpd.sl end)
*/