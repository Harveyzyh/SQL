
--查询PURTH和INVLH表中，金额不相等问题；同时，留意检查当月如果有费用结算单，要检查INVLA档金额是否加上了分摊的进货费用
--(如果进货单存在费用结算单，维护库存交易明细金额要考虑加上分摊的进货费用)
SELECT LH001,TH001,TH002,TH003,TH004,TH005,TH006,TH047 本币税前,SUM(LH008) 成本要素档金额
FROM PURTH INNER JOIN INVLH 
ON TH001=LH002 AND TH002=LH003 AND TH003=LH004  
WHERE LH001='201908'
GROUP BY LH001,TH001,TH001,TH002,TH003,TH004,TH005,TH006,TH047 
HAVING TH047<>SUM(LH008)
ORDER BY PURTH.TH001,TH002,TH003

--查询金额不相等
SELECT LA006,LA007,LA008,LA005,LA001,LA004,LA013,LH002,LH003,LH004,LH008B
FROM INVLA 
LEFT JOIN (SELECT LH002,LH003,LH004,LH005,SUM(LH008)AS LH008B 
	FROM  INVLH
	WHERE LH001='201908'
	GROUP BY LH002,LH003,LH004,LH005
	) AS SJL ON LA006=LH002 AND LA007=LH003 AND LA008=LH004 AND LA005=LH005
WHERE SUBSTRING(LA004,1,6)='201908' AND LA013<>LH008B
ORDER BY LA006,LA007,LA008

--查询INVLH无金额
SELECT LA006,LA007,LA008,LA001,LA004,LA013,LH002,LH003,LH004
FROM INVLA
LEFT JOIN INVLH ON LH002=LA006 AND LH003=LA007 AND LH004=LA008
WHERE SUBSTRING(LA004,1,6)='201908' AND LA013<>0 AND LH002 IS NULL
ORDER BY LA006,LA007,LA008
