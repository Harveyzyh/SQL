-- 查程序打开时间
/*
SELECT * FROM WORKLOG
WHERE 1=1
AND USERID = '000948'
AND PROGID = 'MOCMI05'
AND CONVERT(VARCHAR(20), DTSTART, 112) = '20191230' 
*/


SELECT REPLACE(RTRIM(WORKLOG.STATION), '_', '-') AS 计算机名, RTRIM(WORKLOG2.IP) AS IP, CONVERT(VARCHAR(20), WORKLOG2.DT, 120) AS 最后程序打开时间, UPGRADELOG.DT AS 最后更新时间, 
RTRIM(USERID) 用户ID, RTRIM(MA002) 用户名
FROM 
(
	SELECT CLIENTIP AS IP, MAX(DTSTART) AS DT FROM DSCSYS.dbo.WORKLOG GROUP BY CLIENTIP
) AS WORKLOG2
INNER JOIN DSCSYS.dbo.WORKLOG ON WORKLOG.CLIENTIP = WORKLOG2.IP AND WORKLOG2.DT = WORKLOG.DTSTART
INNER JOIN DSCSYS.dbo.DSCMA ON MA001 = USERID 
LEFT JOIN 
(
	SELECT IpAddress AS IP, MAX(UpgradeDateTime) AS DT FROM YiFeiPublish.dbo.UpgradeLog GROUP BY IpAddress
) AS UPGRADELOG ON WORKLOG2.IP = UPGRADELOG.IP

WHERE 1=1
AND WORKLOG2.DT > DATEADD(DAY, -30, GETDATE()) -- 最近一个月内打开过程序
AND DATEDIFF(DAY, CONVERT(DATE, UPGRADELOG.DT, 120), CONVERT(DATE, WORKLOG2.DT, 120)) > 10 -- 最后更新时间与最后打开程序时间差的天数
-- AND CONVERT(VARCHAR(20), CONVERT(DATE, WORKLOG2.DT, 120), 112) = CONVERT(VARCHAR(20), GETDATE(), 112) -- 最后打开程序日期为今天
-- AND WORKLOG2.IP = '192.168.1.36'
AND WORKLOG.STATION NOT LIKE '%TEST%'
AND (WORKLOG.STATION LIKE '%YW%' OR WORKLOG.STATION LIKE '%SC%' OR WORKLOG.STATION LIKE '%GC%')
-- AND USERID = '001227'

ORDER BY REPLACE(RTRIM(WORKLOG.STATION), '_', '-')
