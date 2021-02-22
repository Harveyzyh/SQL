
SELECT * 
-- DELETE
FROM ATEST..XGDJ_202007 
WHERE d1 IS NULL 

SELECT * FROM ATEST..XGDJ_202007 WHERE NOT EXISTS (SELECT 1 FROM INVLA WHERE d1=LA006 AND d2=LA007 AND d3=LA008) --0行记录


SELECT LA001,MB002,MB003,LA004,LA006,LA007,LA008,LA011,LA012,LA013,LA017,LA018,LA019,LA020,MB025 品号属性
FROM ATEST..XGDJ_202007 INNER JOIN INVLA ON d1=LA006 AND d2=LA007 AND d3=LA008 INNER JOIN INVMB ON MB001 = LA001

-- INNER JOIN INVMB ON LA001=MB001 WHERE MB025='S' --7行记录
--修改加工金额=0
SELECT * FROM ATEST..XGDJ_202007 INNER JOIN INVLA ON d1=LA006 AND d2=LA007 AND d3=LA008
WHERE LA020='0'

SELECT d1, d2, d3, LA011, LA012, LA013, LA017, dj, je 
-- UPDATE INVLA SET LA013=je,LA017=je 
-- UPDATE INVLA SET LA012=je/LA011
FROM INVLA INNER JOIN ATEST..XGDJ_202007 ON d1=LA006 AND d2=LA007 AND d3=LA008
WHERE LA020='0' --(1104 行受影响)

SELECT * 
-- UPDATE INVLH SET LH008=je  -- (1116 行受影响)
FROM INVLH INNER JOIN ATEST..XGDJ_202007  ON d1=LH002 AND d2=LH003 AND d3=LH004

-- 修改加工金额<>0(手动修改维护库存交易明细即可)  -- 可自行修改，不想就打电话给财务去修改
SELECT LA001,LA004,LA006,LA007,LA008,LA011,LA012,LA013,LA017,LA018,LA019,LA020,dj,je 
FROM ATEST..XGDJ_202007 INNER JOIN INVLA ON d1=LA006 AND d2=LA007 AND d3=LA008
WHERE LA020<>'0'

--修改11%单据单身单位成本和金额
SELECT TB001, TB002, TB003, TB010, TB011, dj, je
-- UPDATE INVTB SET TB010=dj,TB011=je 
FROM INVTB INNER JOIN ATEST..XGDJ_202007 ON TB001=d1 AND TB002=d2 AND TB003=d3
WHERE d1 LIKE '11%'
-- (230 行受影响)

SELECT * FROM INVLA WHERE (LA020+LA017+LA018+LA019)<>LA013 AND SUBSTRING(LA004,1,6)>='202007'



-----------------------------------
-- 同步单据与库存交易明细的单价，金额
-- 库存交易单身
SELECT TB001, TB002, TB003, TB004, TB009, TB010, TB011, LA011, LA012, LA013 
-- UPDATE INVTB SET TB010 = LA012, TB011 = LA013
FROM INVTB
INNER JOIN INVLA ON TB001=LA006 AND TB002=LA007 AND TB003=LA008
-- INNER JOIN ATEST..XGDJ_202007  ON d1=LA006 AND d2=LA007 AND d3=LA008 -- 关联需要修改单价的单
WHERE 1=1
-- AND TB001 = '1102' 
-- AND TB002 = '20090227' 
-- AND TB003 = '0014' -- 测试
AND SUBSTRING(LA004, 1, 6) = '202101' 
AND LA013 != TB011
-- AND LA007 = '20070213'
ORDER BY LA006, LA007, LA008

-- 库存交易单头
SELECT TA001, TA002, TA011, TA012, A3
-- UPDATE INVTA SET TA012 = A3 
FROM INVTA
INNER JOIN (
SELECT TB001 AS A1, TB002 AS A2, SUM(TB011) AS A3
FROM INVTB
GROUP BY TB001, TB002
) AS K ON TA001 = A1 AND TA002 = A2 
WHERE 1=1
AND SUBSTRING(TA003, 1, 6) = '202101' 
AND TA012 != A3
ORDER BY TA001, TA002
