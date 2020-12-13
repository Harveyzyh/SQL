/* 易飞的数据字典，按照表查询
*/


--单头
/*
SELECT DISTINCT RTRIM(MC002) 表中文名, RTRIM(MD001) 表名
FROM DSCSYS.dbo.ADMMD
INNER JOIN DSCSYS.dbo.ADMMC ON MD001 = MC001
WHERE 1=1
AND MD001 LIKE '%%' --表名
AND MC002 LIKE '%仓库%' -- 表名称
ORDER BY RTRIM(MD001), RTRIM(MC002)
*/

--单身
SELECT RTRIM(MC002) 表中文名, RTRIM(MD001) 表名, RTRIM(MD002) 序号, RTRIM(MD003) 字段名, RTRIM(MD004) 字段中文, 
RTRIM(MD005) 字段类型, RTRIM(MD006) 长度, RTRIM(MD007) 字段说明, RTRIM(MD008) 实体类型 
FROM DSCSYS.dbo.ADMMD
INNER JOIN DSCSYS.dbo.ADMMC ON MD001 = MC001
WHERE 1=1
-- AND MD001 LIKE '%INVME%' --表名
AND MD001 IN ('INVMC', '', '', '', '', '', '', '', '', '', '', '', '')
-- AND MD001 LIKE ('%%')
ORDER BY MD001, MD002



