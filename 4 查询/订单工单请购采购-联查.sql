
SELECT 
COPTD.TD001, COPTD.TD002, COPTD.TD003,
MOCTA.TA006 成品品号, MOCTA.TA002 工单号, MOCTB.TB003 材料品号,
PURTB.TB001 请购单别, PURTB.TB002 请购单号, PURTB.TB003 请购单序号, PURTA.TA007 请购单头审核码, PURTB.TB025 请购单身审核码, 
PURTD.TD001 采购单别, PURTD.TD002 采购单号, PURTD.TD003 采购单序号, PURTC.TC014 采购单头审核码, PURTD.TD018 采购单身审核码
FROM COPTD

LEFT JOIN MOCTA ON MOCTA.TA026 = COPTD.TD001 AND MOCTA.TA027 = COPTD.TD002 AND MOCTA.TA028 = COPTD.TD003

LEFT JOIN MOCTB ON MOCTB.TB001 = MOCTA.TA001 AND MOCTB.TB002 = MOCTA.TA002
LEFT JOIN PURTB ON PURTB.TB029 = COPTD.TD001 AND PURTB.TB030 = COPTD.TD002 AND PURTB.TB031 = COPTD.TD003 --AND MOCTB.TB003 = PURTB.TB004
LEFT JOIN PURTA ON PURTA.TA001 = PURTB.TB001 AND PURTA.TA002 = PURTB.TB002
LEFT JOIN PURTD ON PURTD.TD026 = PURTB.TB001 AND PURTD.TD027 = PURTB.TB002 AND PURTD.TD028 = PURTB.TB003 
LEFT JOIN PURTC ON PURTC.TC001 = PURTD.TD001 AND PURTC.TC002 = PURTD.TD002

WHERE 1=1

--AND MOCTA.TA001 + '-' + MOCTA.TA002 = '5101-18070050'
AND RTRIM(COPTD.TD001) + '-' + RTRIM(COPTD.TD002) + '-' + RTRIM(COPTD.TD003) = '2201-015138-0016'


--AND MOCTA.TA013 <> 'V'
ORDER BY MOCTA.TA026, MOCTA.TA027, MOCTA.TA028, MOCTB.TB003