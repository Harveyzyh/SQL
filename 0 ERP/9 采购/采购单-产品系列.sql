DECLARE @TC001 VARCHAR(10), @TC002 VARCHAR(30) 
DECLARE TC_cursor  cursor for  SELECT TC001, TC002 FROM PURTC WHERE ISNULL(PURTC.UDF08, '排程未维护') = '排程未维护' AND PURTC.TC003 >= '20210101' AND PURTC.TC001 IN ('3301', '3308') ORDER BY TC004, TC001, TC002 
OPEN TC_cursor

fetch next from TC_cursor into @TC001, @TC002
while @@FETCH_STATUS = 0    --返回被 FETCH语句执行的最后游标的状态–
begin
	PRINT(@TC001+'-'+@TC002)
		UPDATE PURTC SET PURTC.UDF07 = 
		ISNULL(STUFF((SELECT DISTINCT ',' +  INVMB.UDF12 FROM PURTD(NOLOCK)
		INNER JOIN PURTR(NOLOCK) ON PURTD.TD001+'-'+PURTD.TD002+'-'+PURTD.TD003 = PURTR.TR019 
		INNER JOIN PURTB(NOLOCK) ON PURTB.TB001 = PURTR.TR001 AND PURTB.TB002 = PURTR.TR002 AND PURTB.TB003 = PURTR.TR003 
		INNER JOIN COPTD(NOLOCK) ON COPTD.TD001 = PURTB.TB029 AND COPTD.TD002 = PURTB.TB030 AND COPTD.TD003 = PURTB.TB031
		INNER JOIN INVMB(NOLOCK) ON INVMB.MB001 = COPTD.TD004 
		WHERE PURTC.TC001 = PURTD.TD001 AND PURTC.TC002 = PURTD.TD002
		AND ISNULL(INVMB.UDF12, '') != '' 
		FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')
		FROM PURTC(NOLOCK) 
		WHERE PURTC.TC001 = @TC001 AND PURTC.TC002 = @TC002
	fetch next from TC_cursor into @TC001, @TC002  
end
close TC_cursor  --关闭游标
deallocate TC_cursor   --释放游标




SELECT TC001, TC002 FROM PURTC WHERE (ISNULL(PURTC.UDF08, '') != '' OR ISNULL(PURTC.UDF07, '') != '') AND PURTC.TC003 >= '20210429' AND PURTC.TC001 IN ('3301', '3308') ORDER BY TC003, TC001, TC002 

SELECT TC001, TC002, PURTC.UDF07, PURTC.UDF08, 
-- UPDATE PURTC SET PURTC.UDF08 = 
		ISNULL(STUFF((SELECT DISTINCT ',' + INVMB.UDF11 FROM PURTD(NOLOCK)
		INNER JOIN PURTR(NOLOCK) ON PURTD.TD001+'-'+PURTD.TD002+'-'+PURTD.TD003 = PURTR.TR019 
		INNER JOIN PURTB(NOLOCK) ON PURTB.TB001 = PURTR.TR001 AND PURTB.TB002 = PURTR.TR002 AND PURTB.TB003 = PURTR.TR003 
		INNER JOIN COPTD(NOLOCK) ON COPTD.TD001 = PURTB.TB029 AND COPTD.TD002 = PURTB.TB030 AND COPTD.TD003 = PURTB.TB031
		INNER JOIN INVMB(NOLOCK) ON INVMB.MB001 = COPTD.TD004 
		WHERE PURTC.TC001 = PURTD.TD001 AND PURTC.TC002 = PURTD.TD002
		AND ISNULL(INVMB.UDF12, '') != '' 
		FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), ''), 
		ISNULL(STUFF((SELECT DISTINCT ',' + INVMB.UDF11 FROM PURTD(NOLOCK)
		INNER JOIN PURTR(NOLOCK) ON PURTD.TD001+'-'+PURTD.TD002+'-'+PURTD.TD003 = PURTR.TR019 
		INNER JOIN PURTB(NOLOCK) ON PURTB.TB001 = PURTR.TR001 AND PURTB.TB002 = PURTR.TR002 AND PURTB.TB003 = PURTR.TR003 
		INNER JOIN COPTD(NOLOCK) ON COPTD.TD001 = PURTB.TB029 AND COPTD.TD002 = PURTB.TB030 AND COPTD.TD003 = PURTB.TB031
		INNER JOIN INVMB(NOLOCK) ON INVMB.MB001 = COPTD.TD004 
		WHERE PURTC.TC001 = PURTD.TD001 AND PURTC.TC002 = PURTD.TD002
		AND ISNULL(INVMB.UDF12, '') != '' 
		FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')
		FROM PURTC(NOLOCK) 
		WHERE PURTC.TC001 = '3301' AND PURTC.TC002 = '21040937'
		
		
