SELECT 
RTRIM(COPTD.TD001) + '-' + RTRIM(COPTD.TD002) + '-' + RTRIM(COPTD.TD003) AS 订单号, COPTD.TD021 AS 订单审核码, 
RTRIM(COPTD.TD004) AS 订单品号, CONVERT(FLOAT, COPTD.TD008) AS 订单数量, 
RTRIM(PURTB.TB004) AS 请购品号, RTRIM(INVMB.MB002) AS 品名, RTRIM(INVMB.MB003) AS 规格, 
RTRIM(PURTB.TB001) + '-' + RTRIM(PURTB.TB002) + '-' + RTRIM(PURTB.TB003) AS 请购单号, PURTB.TB025 AS 请购审核码, 
CONVERT(FLOAT, PURTB.TB009) AS 请购数量, 
RTRIM(PURTC.TC004) 采购单供应商编号, RTRIM(PURMA.MA002) 采购单供应商, 
TR019,
RTRIM(PURTD.TD001) + '-' + RTRIM(PURTD.TD002) + '-' + RTRIM(PURTD.TD003) AS 采购单号, PURTD.TD018 AS 采购审核码, 
CONVERT(FLOAT, PURTD.TD008) AS 采购数量, CONVERT(FLOAT, PURTD.TD015) AS 采购已交数量, PURTD.TD016 AS 采购单结束码, 
RTRIM(PURTH.TH001) + '-' + RTRIM(PURTH.TH002) + '-' + RTRIM(PURTH.TH003) AS 进货单号, PURTH.TH030 AS 进货单审核码, 
CONVERT(FLOAT, PURTH.TH015) AS 进货数量, CONVERT(FLOAT, PURTH.TH034) AS 验收库存数量, 
RTRIM(PURTJ.TJ001) + '-' + RTRIM(PURTJ.TJ002) + '-' + RTRIM(PURTJ.TJ003) AS 退货单号, PURTJ.TJ030 AS 退货单审核码, 
CONVERT(FLOAT, PURTJ.TJ009) AS 退货数量
FROM COPTD 
-- FROM PURTD
LEFT JOIN PURTB ON PURTB.TB029 = COPTD.TD001 AND PURTB.TB030 = COPTD.TD002 AND PURTB.TB031 = COPTD.TD003 -- 请购单身
INNER JOIN INVMB ON INVMB.MB001 = PURTB.TB004 -- 品号信息
LEFT JOIN PURTR ON PURTR.TR001 = PURTB.TB001 AND PURTR.TR002 = PURTB.TB002 AND PURTR.TR003 = PURTB.TB003
LEFT JOIN PURTD ON PURTD.TD004 = PURTB.TB004 AND PURTD.TD026 = PURTB.TB001 AND PURTD.TD027 = PURTB.TB002 AND PURTD.TD028 = PURTB.TB003 -- 采购单身
LEFT JOIN PURTC ON PURTC.TC001 = PURTD.TD001 AND PURTD.TD002 = PURTC.TC002 -- 采购单头
LEFT JOIN PURMA ON PURMA.MA001 = PURTC.TC004 -- 采购供应商
LEFT JOIN PURTH ON PURTH.TH011 = PURTD.TD001 AND PURTH.TH012 = PURTD.TD002 AND PURTH.TH013 = PURTD.TD003 -- 进货单身
LEFT JOIN PURTJ ON PURTJ.TJ013 = PURTH.TH001 AND PURTJ.TJ014 = PURTH.TH002 AND PURTJ.TJ015 = PURTH.TH003 -- 退货单身

WHERE 1=1 
AND RTRIM(COPTD.TD001) + '-' + RTRIM(COPTD.TD002) IN ('2201-014467') 
-- AND COPTD.TD003 IN ('0004', '0005', '0006') 

-- AND RTRIM(PURTD.TD001) + '-' + RTRIM(PURTD.TD002) + '-' + RTRIM(PURTD.TD003) = '3301-19031000-0001'

-- AND INVMB.MB001 IN ('408010166') -- 品号 
-- AND PURTB.TB025 = 'Y' -- 请购单审核码 

-- ORDER BY RTRIM(COPTD.TD001) + '-' + RTRIM(COPTD.TD002) + '-' + RTRIM(COPTD.TD003), RTRIM(PURTB.TB004)
