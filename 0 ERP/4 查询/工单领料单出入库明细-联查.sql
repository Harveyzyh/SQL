
-- USE COMFORT

SELECT DISTINCT 
RTRIM(TA001) AS 工单别, RTRIM(TA002) AS 工单号, 
RTRIM(TA006) AS 成品, CAST(TA015 AS FLOAT) 预计产量, CAST(TA017 AS FLOAT) 已生产数量,
-- RTRIM(TB037) AS 树状码, 
(CASE TA011 WHEN '1' THEN '未生产' WHEN '2' THEN '已发料' WHEN '3' THEN '生产中' WHEN 'Y' THEN '已完工' END) AS 工单状态, 
-- (CASE TB011 WHEN '1' THEN '直接材料' WHEN '2' THEN '间接材料' WHEN '3' THEN '供应商供料' WHEN '4' THEN '不发料' WHEN '5' THEN '客户供料' ELSE TB011 END ) AS 品号属性, 
RTRIM(TB003) AS 品号, RTRIM(MB002) AS 品名, TB006 AS 工艺, TB009 AS 工单仓位,CONVERT(FLOAT, TB004) AS 工单需领用量, 
(CONVERT(FLOAT, TB004) - CONVERT(FLOAT, TB005)) AS 工单未领用量, 
RTRIM(TC019) 来源单别, RTRIM(TC020) 来源单号, RTRIM(TC001) AS 领退料单别, RTRIM(TC002) AS 领退料单号, RTRIM(TC009) AS 领退料单头审核码, RTRIM(TE019) AS 领退料单身审核码, 
TE003 AS 领退料单序号, (CASE SUBSTRING(TC001,1,2) WHEN '54' THEN '领料' WHEN '56' THEN '退料' ELSE TC001 END) 领退料, TE005 AS 领退料数量, TE027 AS 领退料库存数量, 
TE008 AS 领料单仓位, TE010 AS 领料单批号, 
LA004 交易日期, LA011 AS 库存交易数量, (CASE WHEN LA005 = '-1' THEN '出库' WHEN LA005 = '+1' THEN '入库' END) AS 出入库, LA009 AS 交易明细仓位, LA016 AS 交易明细批号 

-- UPDATE MOCTE SET TE019 = 'Y' -- 领料单身审核码
-- UPDATE MOCTE SET TE005 = LA011, TE027 = LA011, TE008 = LA009, TE010 = LA016 -- 数量，仓库，批号
-- UPDATE MOCTE SET TE005 = LA011, TE027 = LA011 -- 领退料量
-- UPDATE MOCTE SET TE008 = LA009 -- 领料单仓位
-- UPDATE MOCTE SET TE010 = LA016 -- 批号

-- UPDATE MOCTE SET TE027 = TE005 -- 专用，
-- UPDATE INVLA SET LA011 = TE005 -- 专用，
FROM MOCTA
INNER JOIN MOCTB ON TA001 = TB001 AND TA002 = TB002
LEFT JOIN MOCTE ON TB001 = TE011 AND TB002 = TE012 AND TB003 = TE004 AND TE009 = TB006
LEFT JOIN MOCTC ON TE001 = TC001 AND TE002 = TC002 
LEFT JOIN INVLA ON LA006 = TC001 AND LA007 = TC002 AND LA001 = TE004 AND RTRIM(TA001) + '-' + RTRIM(TA002) = RTRIM(LA024) AND LA008 = TE003
INNER JOIN INVMB ON TB003 = MB001

WHERE 1=1
AND TA013 != 'V' --AND TA011 != 'y' --AND TC009 != 'V'
-- AND TC009 = 'Y' AND TE019 = 'N'
AND TA001 = '5101'
AND TA002 = '21020898' -- 工单号
-- AND TC001 = '5601' 
-- AND TC002 = '210400303'
-- AND TC002 BETWEEN '200850001' AND '20085022'
-- AND CONVERT(FLOAT, TB004) - CONVERT(FLOAT, TB005) > 0  -- 工单需领数量
-- AND TE005 != LA011 -- 领料数量与库存交易明细不一致
-- AND TE010 != LA016 -- 领料批号与库存交易批号不一致
-- AND RTRIM(TC001) + '-' + RTRIM(TC002) = '5401-20090402' -- 领退料单号
AND TB003 = '3990205001' -- 工单品号
-- AND TB006 = '0105' -- 工单工艺
-- AND LA011 IS NOT NULL AND CONVERT(FLOAT, TB004) - CONVERT(FLOAT, TB005) > 0 -- 工单未领用量没发生变化
-- AND TA011 IN ('2', '3') -- 工单状态
-- AND SUBSTRING(MOCTA.CREATE_DATE, 1, 6) >= '201905'
ORDER BY RTRIM(TA001), RTRIM(TA002), TB006, RTRIM(TB003), RTRIM(TC001), RTRIM(TC002), TE003


