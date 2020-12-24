
-- 检查重复
SELECT MC001  
FROM ASTMB 
INNER JOIN ASTMC ON MB001 = MC001 
INNER JOIN ATEST..ZCBG_20201216_2 ON MC001C = MC001
WHERE 1=1
-- AND MC001 != '11100029'
GROUP BY MC001 HAVING COUNT(*) > 1 
ORDER BY MC001


-- 人员账号替换
SELECT MC001C, MC003S, MC003C, MV001, MV002 
-- UPDATE ATEST..ZCBG_20201216_2 SET MC003C = RTRIM(MV001)
FROM ATEST..ZCBG_20201216_2
INNER JOIN COMFORT..CMSMV ON MV002 = MC003S


-- 原部门信息替换
SELECT MC001C, MC002BC, MC002B, ME001, ME002
-- UPDATE ATEST..ZCBG_20201216_2 SET MC002B = ME001
FROM ATEST..ZCBG_20201216_2 
INNER JOIN COMFORT..CMSME ON ME002 = MC002BC 


-- 新部门信息替换
SELECT MC001C, MC002CC, MC002C, ME001, ME002
-- UPDATE ATEST..ZCBG_20201216_2 SET MC002C = ME001
FROM ATEST..ZCBG_20201216_2 
INNER JOIN COMFORT..CMSME ON ME002 = MC002CC 


-- 查看补全后的数据
SELECT * 
-- 调整放置地点为空的 
-- UPDATE ATEST..ZCBG_20201216_2 SET MC006C = ISNULL(MC006C, '')
FROM ATEST..ZCBG_20201216_2 
ORDER BY MC001C


-- 资产信息替换
SELECT MC001
, MC002, MC003, MC006, 
MC002C, MC003C, MC006C, LEN(MC006C)
-- UPDATE ASTMC SET MC002 = MC002C, MC003 = MC003C, MC006 = SUBSTRING(MC006C, 1, 10)    
FROM ASTMB 
INNER JOIN ASTMC ON MB001 = MC001 
INNER JOIN ATEST..ZCBG_20201216_2 ON MC001C = MC001
WHERE 1=1
-- AND MC001 != '11100029'
-- GROUP BY MC001 HAVING COUNT(*) = 1 
ORDER BY MC001



