--工单准时完工率

declare @datestr varchar(6)
declare @dateend varchar(6)
set @datestr = LEFT(CONVERT(varchar(8),20180701,112),6)
set @dateend = LEFT(CONVERT(varchar(8),20180731,112),6)

declare @temp table(d varchar(6))
declare @tmpdate varchar(6)
set @tmpdate = @datestr
while (@tmpdate <> @dateend) 
	begin 
		insert @temp(d)values(@tmpdate)
		set @tmpdate = LEFT(convert(varchar(8),dateadd(month,1,@tmpdate+'01'),112),6)
	end
insert @temp(d)values(@tmpdate)

select d YM,cast((cast(COUNTS1 as decimal(15,4))/ Case When COUNTS2=0 then 1 else COUNTS2 end) as decimal(15,4)) COUNTS
	FROM @temp
	LEFT JOIN 
	(SELECT LEFT(TA003,6) YM1,COUNT(*) COUNTS1		
--按照审核日期统计准时完工的工单笔数
		FROM MOCTA
		WHERE TA013='Y' AND (TA011='3' OR TA011='Y' OR TA011='y') AND TA014<=TA010 
		GROUP BY LEFT(TA003,6)
	) AS CL ON d=YM1
	LEFT JOIN 
	(SELECT LEFT(TA003,6) YM2,COUNT(*) COUNTS2		
--按照审核日期统计完工工单总数+超时未完工工单数（超时判断为当前日期与预计完工日期比较）
		FROM MOCTA
		WHERE TA013='Y' AND ((TA011='Y' OR TA011='y') OR ((TA011='1' OR TA011='2' OR TA011='3') AND CONVERT(varchar(8),GETDATE(),112)>TA010))
		GROUP BY LEFT(TA003,6)
	) AS YL ON d=YM2
	ORDER BY YM
	
