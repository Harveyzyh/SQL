-- 品号批号每月统计档 
SELECT LN001 AS 品号, MB002 AS 品名, MB003 AS 规格, LN002 AS 批号, LN003 AS 库存年月, LN004  AS 月初总数量, LN005 AS 月初总成本, LN006 AS 备注, 
LN007 AS [月初成本-材料], LN008 AS [月初成本-人工'], LN009 AS [月初成本-制费], LN010 AS [月初成本-加工], 
LN011 AS 单位成本, LN012 AS [单位成本-材料], LN013 AS [单位成本-人工], LN014 AS [单位成本-制费], LN015 AS [单位成本-加工], LN016 AS 月初总包装数量
FROM Comfortseating.dbo.INVLN 
LEFT JOIN Comfortseating.dbo.INVMB ON MB001 = LN001 
WHERE 1=1
AND LN001 = '3010301002a'
AND LN002 = 'LY020-40'
-- AND LN003 = ''
ORDER BY LN003



-- 交易明细当 
SELECT LA001 AS 品号, MB002 AS 品名, MB003 AS 规格, LA004 AS 交易日期, LA005 AS 出入库别, LA006 单别, LA007 单号, LA008 序号, LA009 仓库, LA016 批号, 
LA010 备注, LA011 交易数量, LA012 单据单位成本, LA013 金额, LA014 交易别, LA015 成本码, LA017 [金额-材料], LA018 [金额-人工], LA019 [金额-制费], LA020 [金额-加工], 
LA021 单据交易包装数量, LA022 审核时间, LA023 库位, LA024 对象
FROM Comfortseating.dbo.INVLA 
INNER JOIN Comfortseating.dbo.INVMB ON MB001 = LA001 
WHERE 1=1
AND LA001 = '3010301002a'
AND LA016 = 'LY020-40'
-- AND LA004 BETWEEN '' AND '' 
ORDER BY LA001, LA004
