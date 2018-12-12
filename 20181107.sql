--SELECT MB001,MB002,MB003--,MB064 AS '库存数量',MB065 AS '库存金额'
--FROM INVMB 
--WHERE MB032='A0074'
----MB001 LIKE '4%' -- OR MB001 LIKE '30102'
--AND MB002 NOT LIKE '%停用%' AND MB109='Y'
----AND MB001 LIKE '307%'
--ORDER BY MB001 

----SELECT * FROM PURMA 
----WHERE MA002 LIKE '%耀友%'

--SELECT TC003,TD001,TD002,TD003,TD012,TH014 
--FROM PURTD
--LEFT JOIN PURTC ON TD001=TC001 AND TD002=TC002
--LEFT JOIN PURTH ON TD001=TH014 AND TD002=TH012 AND TD003=TH013
--WHERE 1=1
--AND TC003>='20180301' AND TC003<='20180331'
--AND TD012>TH014


--SELECT TC001,TC002,TC003,TD001,TD002,TD003,TD012,TH014 
--FROM PURTH
--LEFT JOIN PURTG ON TG001=TH001 AND TG002=TH002 
--LEFT JOIN PURTD ON TD001=TH011 AND TD002=TH012  AND TD003=TH013
--LEFT JOIN PURTC ON TD001=TC001 AND TD002=TC002
--WHERE 1=1
--AND TC003>='20181101' AND TC003<='20181130'
--AND TD012>TG003

--SELECT TC001,TC002,TC003 
--FROM PURTC
--WHERE TC003>='20181101' AND TC003<='20181130'

--SELECT  TA001,TA002,TA064 AS '部门',TA009 AS '预计开工日',TA010 AS '预计完工日',TA012 AS '实际开工日',TA014 AS '实际完工日' ,TA011,
----DATEDIFF(DAY,TA009,TA010) AS '预计生产周期'
--DATEDIFF(DAY,TA012,TA014) AS '实际生产周期'
         
--           --061 采购课 080A 生产一部  080B 生产二部  080C 生产四部  080D 生产三部  080E  生产五部
--FROM MOCTA
--WHERE TA003>='20180901' AND TA003<='20180930'
--AND TA064='061'                                   --工单笔数
--AND TA014<='20180930'
--AND (TA011='Y' OR TA011='y')                      --当月齐套笔数

--AND TA012<=TA009
--AND TA012<>''
--AND TA009<>''                                   --准时开工笔数

--AND TA014<=TA010
--AND TA010<>''
--AND TA014<>''                                   --准时完工笔数

--AND TA009<>''
--AND TA010<>''                                   --预计生产周期

--AND TA014<>''
--AND TA012<>''


--SELECT LA005,LA006,LA007,LA008,LA001,LA011,LA013
--FROM INVLA 
--WHERE LA001 LIKE '4%' 
--AND LA005='1'
--AND LA004>='20180701' AND LA004<='20180731'
--ORDER BY LA001

--SELECT LA005,LA006,LA007,LA008,LA001,LA011,LA013
--FROM INVLA 
--WHERE LA001 LIKE '4%' 
--AND LA005='-1'
--AND LA004>='20180701' AND LA004<='20180731'
--ORDER BY LA001
--select object_name(id) as tablename,reserved----查询各个表大小
-- from sys.sysindexes
-- where indid in (0,1) AND (object_name(id)='COPTQ' OR object_name(id)='COPTR')
-- order by reserved desc

--SELECT * FROM COPTQ

--SELECT CREATE_DATE,TQ001,TQ002
--FROM COPTQ 
--WHERE CREATE_DATE LIKE '2018%'

--工单准时完工率

--declare @datestr varchar(6)
--declare @dateend varchar(6)
--set @datestr = LEFT(CONVERT(varchar(8),20180701,112),6)
--set @dateend = LEFT(CONVERT(varchar(8),20180731,112),6)

--declare @temp table(d varchar(6))
--declare @tmpdate varchar(6)
--set @tmpdate = @datestr
--while (@tmpdate <> @dateend) 
--	begin 
--		insert @temp(d)values(@tmpdate)
--		set @tmpdate = LEFT(convert(varchar(8),dateadd(month,1,@tmpdate+'01'),112),6)
--	end
--insert @temp(d)values(@tmpdate)

--select d YM,cast((cast(COUNTS1 as decimal(15,4))/ Case When COUNTS2=0 then 1 else COUNTS2 end) as decimal(15,4)) COUNTS
--	FROM @temp
--	LEFT JOIN 
--	(SELECT LEFT(TA003,6) YM1,COUNT(*) COUNTS1		
----按照审核日期统计准时完工的工单笔数
--		FROM MOCTA
--		WHERE TA013='Y' AND (TA011='3' OR TA011='Y' OR TA011='y') AND TA014<=TA010 
--		GROUP BY LEFT(TA003,6)
--	) AS CL ON d=YM1
--	LEFT JOIN 
--	(SELECT LEFT(TA003,6) YM2,COUNT(*) COUNTS2		
----按照审核日期统计完工工单总数+超时未完工工单数（超时判断为当前日期与预计完工日期比较）
--		FROM MOCTA
--		WHERE TA013='Y' AND ((TA011='Y' OR TA011='y') OR ((TA011='1' OR TA011='2' OR TA011='3') AND CONVERT(varchar(8),GETDATE(),112)>TA010))
--		GROUP BY LEFT(TA003,6)
--	) AS YL ON d=YM2
--	ORDER BY YM
	


SELECT TQ001,TQ002  --3个月未使用的配置方案
FROM COPTQ 
WHERE TQ001+TQ002 NOT IN 
(SELECT TD004+TD053 FROM COPTD 
LEFT JOIN COPTC ON TD001 =TC001 AND TD002=TC002
WHERE TC039>='20171101' AND TC039<='20181031' AND TD053<>'')