-- 因为层级码异常的问题，可能存在着工单漏跑的情况
-- 以下语句是查找配置方案中存在已勾选的项但是工单中没有的
-- 以下只查询轮滑、椅脚、中管气压棒，其他的项因为不确定因素太多，所以不作日常查询
-- 因为同一成品存在着多个配置方案，而且每个配置方案中会存在着不勾选项的记录，所以会与实际存在着差异
-- 所以查询不为空时，需要人工去打开工单，配置方案来确定是否真的漏跑

-- 当查询不为空，人工打开工打开工单、配置方案确定是否真的漏跑，若是ERP邮件通知对应生产部跑单文员做工单变更作业(告知他们需要增加的品号是什么)



DECLARE @NAME1 VARCHAR(20)
DECLARE @NAME2 VARCHAR(20)
DECLARE @NAME3 VARCHAR(20)
DECLARE @NYR VARCHAR(20)
DECLARE @WEEK VARCHAR(2)

-- 通过查询日的周几来设置日期信息
SELECT @WEEK = DATEPART(DW, GETDATE())
IF (@WEEK = 2)
BEGIN
	SELECT @NYR = CONVERT(VARCHAR(20), GETDATE() -3, 112) -- 周一
END
ELSE 
BEGIN 
	SELECT @NYR = CONVERT(VARCHAR(20), GETDATE() -2, 112) -- 非周一
END

-- 需要查询的品名，滑轮，椅脚，中管气压棒
SET @NAME1 = '滑轮'
SET @NAME2 = '椅脚'
SET @NAME3 = '中管气压棒'

SELECT DISTINCT @NAME1 AS INF, 
RTRIM(A26) AS 订单单别, RTRIM(A27) AS 订单单号, RTRIM(A28) AS 订单序号,
RTRIM(TQ001) AS 主件品号, -- A34 AS 主件品名, 
RTRIM(TR002) AS 配置方案, RTRIM(TQ003) AS 配置方案描述,
-- RTRIM(TR009) AS 材料品号, RTRIM(MB002) AS 材料品名,RTRIM(TR017) AS 是否选择, 
-- RTRIM(TR010) AS 组成用量, RTRIM(TR011) AS 底数,TD008 AS 订单数量,
RTRIM(A1) AS 工单单别, RTRIM(A2) AS 工单单号, M2 AS 部门,TA011C AS 状态,
RTRIM(G1) AS 入库单别, RTRIM(G2) AS 入库单号
FROM COPTQ
INNER JOIN COPTR ON TQ001=TR001 AND TQ002=TR002
LEFT JOIN COPTD ON TD004=TQ001 AND TD053=TR002
INNER JOIN COPTC ON TC001=TD001 AND TC002=TD002
LEFT JOIN INVMB ON MB001=TR009
RIGHT JOIN (
SELECT DISTINCT TA026 AS A26,TA027 AS A27,TA028 AS A28,TA001 AS A1,TA002 AS A2,TA006 AS A6,TA034 AS A34,
ME002 AS M2,
(CASE TA011 WHEN '1' THEN '未生产' WHEN '2' THEN '已发料' WHEN '3' THEN '生产中' WHEN 'Y' THEN '已完工'  WHEN 'y' THEN '指定结束' END) as TA011C,
TG001 AS G1,TG002 AS G2
FROM MOCTA as MOCTA  
Left JOIN MOCTB as MOCTB On MOCTA.TA001=MOCTB.TB001 and MOCTA.TA002=MOCTB.TB002 
Left JOIN MOCTG as MOCTG On MOCTA.TA001=MOCTG.TG014 and MOCTA.TA002=MOCTG.TG015 
Left JOIN CMSME as CMSME On MOCTA.TA064=CMSME.ME001
Left JOIN CMSMV as CMSMV On MOCTA.CREATOR=CMSMV.MV001
WHERE MOCTA.TA001 = '5101' 
AND MOCTA.TA006 like '1%' 
AND SUBSTRING(MOCTA.CREATE_DATE,1,8)>=@NYR --创建日期 
-- AND SUBSTRING(MOCTA.TA014,1,8)>=@NYR    --实际完工
AND NOT EXISTS (SELECT 1 FROM MOCTB as MOCTB WHERE MOCTB.TB012 = @NAME1 AND MOCTA.TA001=MOCTB.TB001 AND MOCTA.TA002=MOCTB.TB002)
)A ON (RTRIM(COPTC.TC001) + '-' + RTRIM(COPTC.TC002) + '-' + RTRIM(COPTD.TD003))=(RTRIM(A26) + '-' + RTRIM(A27) + '-' + RTRIM(A28))
WHERE 1=1
AND MB002 = @NAME1
AND TR017 = 'Y'
AND TQ003 NOT LIKE '%无轮子%' AND TQ003 NOT LIKE '%不要轮子%'

UNION

SELECT DISTINCT @NAME2 AS INF, 
RTRIM(A26) AS 订单单别, RTRIM(A27) AS 订单单号, RTRIM(A28) AS 订单序号,
RTRIM(TQ001) AS 主件品号, -- A34 AS 主件品名, 
RTRIM(TR002) AS 配置方案, RTRIM(TQ003) AS 配置方案描述,
-- RTRIM(TR009) AS 材料品号, RTRIM(MB002) AS 材料品名,RTRIM(TR017) AS 是否选择, 
-- RTRIM(TR010) AS 组成用量, RTRIM(TR011) AS 底数,TD008 AS 订单数量,
RTRIM(A1) AS 工单单别, RTRIM(A2) AS 工单单号, M2 AS 部门,TA011C AS 状态,
RTRIM(G1) AS 入库单别, RTRIM(G2) AS 入库单号
FROM COPTQ
INNER JOIN COPTR ON TQ001=TR001 AND TQ002=TR002
LEFT JOIN COPTD ON TD004=TQ001 AND TD053=TR002
INNER JOIN COPTC ON TC001=TD001 AND TC002=TD002
LEFT JOIN INVMB ON MB001=TR009
RIGHT JOIN (
SELECT DISTINCT TA026 AS A26,TA027 AS A27,TA028 AS A28,TA001 AS A1,TA002 AS A2,TA006 AS A6,TA034 AS A34,
ME002 AS M2,
(CASE TA011 WHEN '1' THEN '未生产' WHEN '2' THEN '已发料' WHEN '3' THEN '生产中' WHEN 'Y' THEN '已完工'  WHEN 'y' THEN '指定结束' END) as TA011C,
TG001 AS G1,TG002 AS G2
FROM MOCTA as MOCTA  
Left JOIN MOCTB as MOCTB On MOCTA.TA001=MOCTB.TB001 and MOCTA.TA002=MOCTB.TB002 
Left JOIN MOCTG as MOCTG On MOCTA.TA001=MOCTG.TG014 and MOCTA.TA002=MOCTG.TG015 
Left JOIN CMSME as CMSME On MOCTA.TA064=CMSME.ME001
Left JOIN CMSMV as CMSMV On MOCTA.CREATOR=CMSMV.MV001
WHERE MOCTA.TA001 = '5101' 
AND MOCTA.TA006 like '1%' 
AND SUBSTRING(MOCTA.CREATE_DATE,1,8)>=@NYR --创建日期 
-- AND SUBSTRING(MOCTA.TA014,1,8)>=@NYR    --实际完工
AND NOT EXISTS (SELECT 1 FROM MOCTB as MOCTB WHERE MOCTB.TB012 = @NAME2 AND MOCTA.TA001=MOCTB.TB001 AND MOCTA.TA002=MOCTB.TB002)
)A ON (RTRIM(COPTC.TC001) + '-' + RTRIM(COPTC.TC002) + '-' + RTRIM(COPTD.TD003))=(RTRIM(A26) + '-' + RTRIM(A27) + '-' + RTRIM(A28))
WHERE 1=1
AND MB002 = @NAME2
AND TR017 = 'Y'

UNION 

SELECT DISTINCT @NAME3 AS INF, 
RTRIM(A26) AS 订单单别, RTRIM(A27) AS 订单单号, RTRIM(A28) AS 订单序号,
RTRIM(TQ001) AS 主件品号, -- A34 AS 主件品名, 
RTRIM(TR002) AS 配置方案, RTRIM(TQ003) AS 配置方案描述,
-- RTRIM(TR009) AS 材料品号, RTRIM(MB002) AS 材料品名,RTRIM(TR017) AS 是否选择, 
-- RTRIM(TR010) AS 组成用量, RTRIM(TR011) AS 底数,TD008 AS 订单数量,
RTRIM(A1) AS 工单单别, RTRIM(A2) AS 工单单号, M2 AS 部门,TA011C AS 状态,
RTRIM(G1) AS 入库单别, RTRIM(G2) AS 入库单号
FROM COPTQ
INNER JOIN COPTR ON TQ001=TR001 AND TQ002=TR002
LEFT JOIN COPTD ON TD004=TQ001 AND TD053=TR002
INNER JOIN COPTC ON TC001=TD001 AND TC002=TD002
LEFT JOIN INVMB ON MB001=TR009
RIGHT JOIN (
SELECT DISTINCT TA026 AS A26,TA027 AS A27,TA028 AS A28,TA001 AS A1,TA002 AS A2,TA006 AS A6,TA034 AS A34,
ME002 AS M2,
(CASE TA011 WHEN '1' THEN '未生产' WHEN '2' THEN '已发料' WHEN '3' THEN '生产中' WHEN 'Y' THEN '已完工'  WHEN 'y' THEN '指定结束' END) as TA011C,
TG001 AS G1,TG002 AS G2
FROM MOCTA as MOCTA  
Left JOIN MOCTB as MOCTB On MOCTA.TA001=MOCTB.TB001 and MOCTA.TA002=MOCTB.TB002 
Left JOIN MOCTG as MOCTG On MOCTA.TA001=MOCTG.TG014 and MOCTA.TA002=MOCTG.TG015 
Left JOIN CMSME as CMSME On MOCTA.TA064=CMSME.ME001
Left JOIN CMSMV as CMSMV On MOCTA.CREATOR=CMSMV.MV001
WHERE MOCTA.TA001 = '5101' 
AND MOCTA.TA006 like '1%' 
AND SUBSTRING(MOCTA.CREATE_DATE,1,8)>=@NYR --创建日期 
-- AND SUBSTRING(MOCTA.TA014,1,8)>=@NYR    --实际完工
AND NOT EXISTS (SELECT 1 FROM MOCTB as MOCTB WHERE MOCTB.TB012 = @NAME3 AND MOCTA.TA001=MOCTB.TB001 AND MOCTA.TA002=MOCTB.TB002)
)A ON (RTRIM(COPTC.TC001) + '-' + RTRIM(COPTC.TC002) + '-' + RTRIM(COPTD.TD003))=(RTRIM(A26) + '-' + RTRIM(A27) + '-' + RTRIM(A28))
WHERE 1=1
AND MB002 = @NAME3
AND TR017 = 'Y'

ORDER BY M2, RTRIM(A26), RTRIM(A27), RTRIM(A28)
