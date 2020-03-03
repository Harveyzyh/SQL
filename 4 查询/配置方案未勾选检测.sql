-- 查询未勾选的配置
SELECT DISTINCT RTRIM(TR1.TR001), RTRIM(TR002), --RTRIM(TR003), 
TR1.TR004-- , TR009, TR017, CB015, CB004, MB002 
FROM 
(
	SELECT DISTINCT CA003 AS CA003C, SUBSTRING(TR003, 1, LEN(TR003) - 3) AS TR003C FROM BOMCA
	INNER JOIN INVMB ON MB001 = CA003
	INNER JOIN COPTR ON TR004 = CA003
	WHERE 1=1
	AND CA017 = 'Y'
	AND MB025 = 'C'
	AND CA013 = '1'
	GROUP BY CA003, SUBSTRING(TR003, 1, LEN(TR003) -3)
) AS KK
INNER JOIN COPTR AS TR1 ON TR004 = CA003C AND TR003C = SUBSTRING(TR003, 1, LEN(TR003) - 3)
INNER JOIN INVMB ON MB001 = TR009
-- LEFT JOIN BOMCB ON CB001 = TR004 AND CB005 = TR009 
WHERE 1=1
AND NOT EXISTS (SELECT 1 FROM COPTR AS TR2 WHERE TR2.TR001 = TR1.TR001 AND TR2.TR002 = TR1.TR002 AND SUBSTRING(TR2.TR003, 1, LEN(TR2.TR003) - 3) = TR003C AND TR017 = 'Y')
AND EXISTS (SELECT 1 FROM  BOMCB WHERE CB001 = TR1.TR004 AND CB005 = TR1.TR009 AND CB015 = 'Y')
AND TR001 LIKE '1%'
-- AND TR001 = '24001302'

ORDER BY RTRIM(TR1.TR001), RTRIM(TR002), 
TR1.TR004-- , CB004


-- 更新勾选项，存在未勾选的配置
SELECT RTRIM(TR001), RTRIM(TR002), RTRIM(TR003), TR004, TR009, TR017, CB015, CB004, MB002, TR1.TR200 
-- UPDATE COPTR SET TR017 = CB015
FROM COPTR AS TR1 
INNER JOIN INVMB ON MB001 = TR009
LEFT JOIN BOMCB ON CB001 = TR004 AND CB005 = TR009 
WHERE 1=1
AND NOT EXISTS (SELECT 1 FROM COPTR AS TR2 WHERE TR2.TR001 = TR1.TR001 AND TR2.TR002 = TR1.TR002 
	AND SUBSTRING(TR2.TR003, 1, LEN(TR2.TR003) - 3) = SUBSTRING(TR1.TR003, 1, LEN(TR1.TR003) - 3) AND TR017 = 'Y')
AND TR001 LIKE '1%'
-- AND TR001 = '10900111'
AND TR004 = '24001122'
AND CB015 = 'Y'
ORDER BY RTRIM(TR001), RTRIM(TR002), TR004, RTRIM(TR003), CB004, MB002


-- BOM里没有勾默认选择的
SELECT CA003, MB002, MB003 FROM BOMCA
INNER JOIN INVMB ON MB001 = CA003
WHERE 1=1
AND MB025 = 'C'
AND CA013 = '1'
AND NOT EXISTS (SELECT 1 FROM  BOMCB WHERE CB001 = CA003 AND CB015 = 'Y')


-- 配置方案勾选两个的
SELECT TR001, TR002, SUBSTRING(TR003, 1, LEN(TR003) - 3)
FROM COPTR 
WHERE 1=1
AND TR017 = 'Y'
GROUP BY TR001, TR002, SUBSTRING(TR003, 1, LEN(TR003) - 3) HAVING COUNT(*) > 1

