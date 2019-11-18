SELECT  DISTINCT LA006 单别,LA007 单号,LA008 序号,TR020 ,LA012 单价,LA011 交易数量, LA001 品号, MB065 金额, MB064 数量, TA001, TA002, TA012, TB003, TB010, TB011 ,ABS(MB065/MB064) 
-- 更新品号信息金额
-- UPDATE INVMB SET MB065 = MB064 * LA012
-- 注释待定
-- UPDATE INVTB SET TB010 = '' -- 财务给出单价
-- 注释待定
-- UPDATE INVTB SET TB011 = TB010 * LA011
-- 注释待定
-- UPDATE INVTA SET TA012 = '' -- 总数

-- 当品号信息里的库存小于0.0001时，把库存量更新为0
-- UPDATE INVMB SET MB064 = 0

FROM COPTR
INNER JOIN INVMB ON MB001=TR009 
INNER JOIN INVLA ON LA001=MB001 
INNER JOIN INVTA ON TA001 = LA006 AND TA002 = LA007 
INNER JOIN INVTB ON TB001 = LA006 AND TB002 = LA007 AND TB003 = LA008
WHERE 1=1 
-- AND ABS(MB065/MB064)>9999 AND MB064<>0  -- 查询序号1  -- 因部分库存为0的，但数据里显示为0.000004，所以金额/数量=单价会超大
-- AND ABS(LA012)>99999   -- 查询序号2  -- 存在记录需打开 维护库存交易明细 根据单据把成本要素维护进去，系统会自动获取单价
-- AND TR020='N' 
-- AND TR020='Y' 
AND MB064 < 0.0001 AND MB064 != 0  -- 当品号信息里的库存小于0.0001时，把库存量更新为0

-- AND TR001='10720501' -- AND TR002='专友 CI-00+LE2095黑色 铝脚 无轮子 无APP'

AND SUBSTRING(LA004,1,6)>='201501'






--修改原单
SELECT TB001,TB002,TB003,TB004,TB007,TA012,TB010,TB011  FROM INVTA
LEFT JOIN INVTB ON TA001=TB001 AND TA002=TB002
WHERE TA001='1101' AND TA002='18110171' AND TB004='404040040'

--合计单身
SELECT TB001,TB002,SUM(TB011)  FROM INVTA
LEFT JOIN INVTB ON TA001=TB001 AND TA002=TB002
WHERE  TA001='1101' AND TA002='18110171'
GROUP BY TB001,TB002

UPDATE INVTB SET TB010='1.3724',TB011='1.3724' FROM INVTA
LEFT JOIN INVTB ON TA001=TB001 AND TA002=TB002
WHERE  TA001='1101' AND TA002='18110171' AND TB004='404040038'

UPDATE INVTA SET TA012='3549.09'FROM INVTA
LEFT JOIN INVTB ON TA001=TB001 AND TA002=TB002
WHERE TA001='1101' AND TA002='18110171' 

UPDATE INVMB SET MB065='0.8707' FROM INVMB WHERE MB001='3060356001'