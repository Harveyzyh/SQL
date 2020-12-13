
-- USING Comfortseating

-- 同步两边已有品号，若税务无品号，执行239的维护计划--导入BOM
SELECT 
MB.MB001 品号, CMB.MB002 内账品名, MB.MB002 外账品名, CMB.MB003 内账规格, MB.MB003 外账规格, CMB.MB004 内账单位, MB.MB004 外账单位, CMB.MB025 内账品号属性, MB.MB025 外账品号属性, 
CMB.MB109 内账核准状况, MB.MB109 外账核准状况, CMB.MB032 内账供应商编号, MB.MB032 外账供应商编码, CMA.MA002 内账供应商, MA.MA002 外账供应商 
-- UPDATE INVMB SET MB002 = CMB.MB002, MB003 = CMB.MB003 -- 同步内外账品号品名规格
-- UPDATE INVMB SET MB004 = CMB.MB004 -- 同步单位
FROM INVMB AS MB
LEFT JOIN PURMA AS MA ON MA.MA001 = MB.MB032
INNER JOIN [192.168.0.99].[COMFORT].[dbo].[INVMB] AS CMB ON CMB.MB001 = MB.MB001
LEFT JOIN [192.168.0.99].[COMFORT].[dbo].[PURMA] AS CMA ON CMA.MA001 = CMB.MB032
WHERE 1=1
AND (CMB.MB002 != MB.MB002 OR CMB.MB003 != MB.MB003)  -- 品名或规格不相等
-- AND CMA.MA002 != MA.MA002  -- 供应商名称不相等
-- AND CMB.MB004 != MB.MB004  -- 单位不相等
-- AND CMB.MB109 = 'Y'  -- 已核准
-- AND CMB.MB025 = 'M'  -- 自制件
-- AND CMB.MB001 LIKE '1%' -- 成品
-- AND CMB.MB025 = 'P'  -- 采购件
-- AND MB.MB002 = '美国网布'
-- AND MB.MB001 = '10840367'
