---AST 固定资产


--月统计档

SELECT * FROM ASTLA WHERE LA002<='201612'

DELETE FROM ASTLA WHERE LA002<='201612'

DELETE FROM ASTLB WHERE LB001+LB002 NOT IN (SELECT LA001+LA002 FROM ASTLA)

DELETE FROM ASTLC WHERE LC001+LC002 NOT IN (SELECT LA001+LA002 FROM ASTLA)

---资产盘点

SELECT * FROM ASTMF 

DELETE FROM ASTMF WHERE MF002 <='20161231'

DELETE FROM ASTMG WHERE MG001 NOT IN (SELECT MF001 FROM ASTMF)

--资产交易单

SELECT * FROM ASTTC WHERE TC003<='20161231' AND TC031='Y' AND TC039='Y'

DELETE FROM ASTTC WHERE TC003<='20161231' AND TC031='Y' AND TC039='Y'--生成分录及开票

DELETE FROM ASTTD WHERE TD001+TD002+TD010 NOT IN (SELECT TC001+TC002+TC004 FROM ASTTC )

--资产转移外送收回

--SELECT * FROM ASTTE 

--DELETE FROM ASTTE WHERE TE003<='20161231' AND TE006='Y'

--DELETE FROM ASTTF WHERE TF001+TF002 NOT IN (SELECT TE001+TE002 FROM ASTTE )

--DELETE FROM ASTTG WHERE TG001+TG002 NOT IN (SELECT TE001+TE002 FROM ASTTE )

--DELETE FROM ASTTH WHERE TH001+TH002 NOT IN (SELECT TE001+TE002 FROM ASTTE )


-----------------------资产外送-----------------------------

SELECT TG001+TG002 FROM ASTTG 
LEFT JOIN ASTTE ON TG001=TE001 AND TG002=TE002 
WHERE TE003<='20161231' AND  TG011<>'N' 
 
DELETE FROM ASTTG WHERE TG001+TG002 IN 
(SELECT TG001+TG002 FROM ASTTG 
LEFT JOIN ASTTE ON TG001=TE001 AND TG002=TE002 
WHERE TE003<='20161231' AND  TG011<>'N' )        -----删除已经结束的外送单

DELETE FROM ASTTE WHERE TE001+TE002 NOT IN (SELECT TG001+TG002 FROM ASTTG)

-----------------------资产转移-----------------------------

SELECT TF001+TF002 FROM ASTTF 
LEFT JOIN ASTTE ON TF001=TE001 AND TF002=TE002 
WHERE TE003<='20161231'  AND TF010<>'N' 

DELETE FROM ASTTF WHERE TF001+TF002 IN 
(SELECT TF001+TF002 FROM ASTTF 
LEFT JOIN ASTTE ON TF001=TE001 AND TF002=TE002 
WHERE TE003<='20161231'  AND TF010<>'N'  )       --------删除已经结束的转移单

DELETE FROM ASTTE WHERE TE001+TE002 NOT IN (SELECT TF001+TF002 FROM ASTTF)

------------------------资产收回------------------------------

SELECT TH001+TH002 FROM ASTTH 
LEFT JOIN ASTTE ON TH001=TE001 AND TH002=TE002 
WHERE TE003<='20161231'  AND TH008='0'

DELETE FROM ASTTH WHERE TH001+TH002 IN 
(SELECT TH001+TH002 FROM ASTTH 
LEFT JOIN ASTTE ON TH001=TE001 AND TH002=TE002 
WHERE TE003<='20161231'  AND TH008='0')           -------- 删除未收回量=0

DELETE FROM ASTTE WHERE TE001+TE002 NOT IN (SELECT TH001+TH002 FROM ASTTH)
----------------------------------------------------------------------------


--资产请购

--SELECT * FROM ASTTI 

--DELETE FROM ASTTI WHERE TI003<='20161231'

--DELETE FROM ASTTJ WHERE TJ001+TJ002 NOT IN (SELECT TI001+TI002 FROM ASTTI )

SELECT TJ001+TJ002 FROM ASTTJ
LEFT JOIN ASTTI ON TJ001=TI001 AND TJ002=TI002
WHERE TI003<='20161231' AND TJ021='N'

DELETE FROM ASTTJ WHERE TJ001+TJ002 IN 
(SELECT TJ001+TJ002 FROM ASTTJ
LEFT JOIN ASTTI ON TJ001=TI001 AND TJ002=TI002
WHERE TI003<='20161231' AND TJ021<>'N')          ----删除已经结束的资产请购单

DELETE FROM ASTTI WHERE TI001+TI002 NOT IN (SELECT TJ001+TJ002 FROM ASTTJ)

---资产询价单

SELECT * FROM ASTTL WHERE TL001+TL002+TL004 NOT IN (SELECT TJ001+TJ002+TJ003 FROM ASTTJ)

DELETE FROM ASTTL WHERE TL001+TL002+TL004 NOT IN (SELECT TJ001+TJ002+TJ003 FROM ASTTJ)

DELETE FROM ASTTK WHERE TK001+TK002+TK003 NOT IN (SELECT TL001+TL002+TL003 FROM ASTTL)


--资产采购

SELECT TN001+TN002 FROM ASTTN
LEFT JOIN ASTTM ON TN001=TM001 AND TN002=TM002
WHERE TM003<='20161231' AND TN021<>'N'

DELETE FROM ASTTN WHERE TN001+TN002 IN 
(SELECT TN001+TN002 FROM ASTTN
LEFT JOIN ASTTM ON TN001=TM001 AND TN002=TM002
WHERE TM003<='20161231' AND TN021<>'N')          ----保留未结束的资产采购单

DELETE FROM ASTTM WHERE TM001+TM002 NOT IN (SELECT TN001+TN002 FROM ASTTN)



--资产进货

SELECT * FROM ASTTO 

DELETE FROM ASTTO WHERE TO003<='20141231'

DELETE FROM ASTTP WHERE TP001+TP002 NOT IN (SELECT TO001+TO002 FROM ASTTO )

SELECT TP001+TP002 FROM ASTTP
LEFT JOIN ASTTO ON TP001=TO001 AND TP002=TO002
WHERE TO003<='20161231' AND TP026='Y'

DELETE FROM ASTTN WHERE TN001+TN002 IN 
(SELECT TP001+TP002 FROM ASTTP
LEFT JOIN ASTTO ON TP001=TO001 AND TP002=TO002
WHERE TO003<='20161231' AND TP026='Y')          ----保留未开票的资产进货单

DELETE FROM ASTTO WHERE TO001+TO002 NOT IN (SELECT TP001+TP002 FROM ASTTP)



--资产工作量

--SELECT * FROM ASTTQ 

--DELETE FROM ASTTQ WHERE TQ001<='201412'

--DELETE FROM ASTTR WHERE TR001+TR002 NOT IN (SELECT TQ001+TQ002 FROM ASTTQ )










