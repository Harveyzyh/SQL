
SELECT PD.*
FROM ATEST..PD_202011_2 AS PD
WHERE 1=1
-- AND NOT EXISTS(SELECT 1 FROM INVMB WHERE 品号 = MB001 AND MB109 = 'Y')
-- AND NOT EXISTS(SELECT 1 FROM INVMC WHERE 品号 = MC001 AND 仓库 = MC002)
AND NOT EXISTS(SELECT 1 FROM INVML WHERE 品号 = ML001 AND 仓库 = ML002 AND 批号 = ML004)
ORDER BY 盘点底稿编号, 序号 


SELECT DISTINCT MB001, MB017 
FROM INVMB 
INNER JOIN ATEST..PD_202011_2 ON 品号 = MB001
WHERE 1=1
AND NOT EXISTS (SELECT 1 FROM INVMC WHERE MC001 = MB001 AND MC002 = MB017) 
ORDER BY MB017, MB001


SELECT PD.* 
FROM ATEST..PD_202011_2 AS PD
INNER JOIN (
	SELECT 品号, 仓库, 批号 FROM ATEST..PD_202011_2 
	GROUP BY 品号, 仓库, 批号 HAVING COUNT(*) > 1
) AS A  ON A.品号 = PD.品号 AND A.仓库 = PD.仓库 AND A.批号 = PD.批号


SELECT TC001, TC002, TC003, TC004, TC005, TC006, TC007, TC008, TC009, 盘点数量 
-- UPDATE INVTC SET TC008 = 盘点数量
FROM INVTC 
INNER JOIN ATEST..PD_202011_2 ON TC001 = 盘点底稿编号 AND TC002 = 序号 AND TC003 = 品号 AND TC004 = 仓库 AND TC007 = 批号
WHERE TC001 = '202011-2'
ORDER BY TC002

