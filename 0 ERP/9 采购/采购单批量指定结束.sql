
-- INSERT INTO ATEST..PURTD_CHANGE_TD016
SELECT TC024 单据日期, TC003 采购日期, TC004 供应商编码, MA002 供应商名称, TC014 单头审核码, 
TC001 单别, TC002 单号, TD003 序号, 
TD018 单身审核码, TD016 结束, TD004 品号, TD008 采购数量, TD015 已交数量, TCD01
-- UPDATE PURTD SET TD016 = 'y' -- 更改单身结束码
-- UPDATE PURTC SET TCD01 = 'Y' -- 更改单头结束码
-- INTO ATEST..PURTD_CHANGE_TD016
FROM  PURTC AS TC
INNER JOIN PURTD AS TD ON TC.TC001 = TD.TD001 AND TC.TC002 = TD.TD002
INNER JOIN PURMA ON MA001 = TC.TC004

WHERE 1=1
AND TC014 != 'V'
AND TC024 <= '20190731'
AND TD016 NOT IN ( 'Y', 'y') -- 单身未结束
-- AND TD016 = 'y' -- 单身结束码
-- AND TCD01 = 'N' -- 单头结束码
-- AND NOT EXISTS ( SELECT 1 FROM PURTD AS TD2 WHERE TD2.TD001 = TC.TC001 AND TD2.TD002 = TC.TC002 AND TD2.TD016 = 'N')  -- 找出单身没有未结束但单头也是未结束的

AND TC001 in('3301', '3303', '3307', '3308', '3305') 
AND TC004 in(
'A0007'
, 
'A0010', 'A0016', 'A0062', 'A0066', 'A0067', 'A0094', 'A0106', 'A0150', 'A0261', 'A0263', 'A0231', 
'A0186', 'A0156', 'A0253', 'C0028', 'A0113', 'A0008', 'A0109', 'A0080', 'A0255', 'A0111', 'A0012', 
'A0098', 'A0005', 'A0031', 'A0019', 'A0040', 'A0227', 'A0052', 'A0206', 'A0074', 'A0035', 'A0267'
)


ORDER BY TC024, TC004, TC001, TC002, TD003