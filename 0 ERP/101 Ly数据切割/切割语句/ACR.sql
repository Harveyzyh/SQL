--10.应收系统单据清除

---应收帐款分期异动明细档

SELECT * FROM ACRIB

DELETE FROM ACRIB WHERE IB004<='20161231' AND IB026='3'

---核销分期记录档

SELECT * FROM ACRIC

DELETE FROM ACRIC WHERE IC012<='20161231' 

---销售发票

SELECT * FROM ACRTA WHERE TA003<='20161231' AND TA100='3'

DELETE FROM ACRTA WHERE TA003<='20161231' AND TA100='3'

DELETE FROM ACRTB WHERE TB001+TB002 NOT IN (SELECT TA001+TA002 FROM ACRTA)


---收款单/YU收款单

SELECT * FROM ACRTK WHERE TK003<='20161231' AND TK030='3'

DELETE FROM ACRTK WHERE TK003<='20161231'  AND TK030='3'

DELETE FROM ACRTL WHERE TL001+TL002 NOT IN (SELECT TK001+TK002 FROM ACRTK)

--(分期)收款单子单身

SELECT * FROM ACRIA WHERE IA001+IA002+IA003 NOT IN (SELECT TL001+TL002+TL003 FROM ACRTL)

DELETE FROM ACRIA WHERE IA001+IA002+IA003 NOT IN (SELECT TL001+TL002+TL003 FROM ACRTL)

---发票信息档

SELECT * FROM ACRTQ

DELETE FROM ACRTQ WHERE TQ002+TQ003 NOT IN (SELECT TA001+TA002 FROM ACRTA)--不存在的销售发票的发票号码清除
DELETE FROM ACRTQ WHERE TQ002+TQ003 NOT IN (SELECT TA001+TA002 FROM ACPTA)--不存在的采购发票的发票号码清除

--其他应收单

SELECT * FROM ACRTI WHERE TI003<='20161231' AND TI029='3'

DELETE FROM ACRTI WHERE TI003<='20161231' AND TI029='3'

DELETE FROM ACRTJ WHERE TJ001+TJ002 NOT IN (SELECT TI001+TI002 FROM ACRTI)


--坏账准备单

SELECT * FROM ACRTM WHERE TM003<='20161231' AND TM012='Y'

DELETE FROM ACRTM WHERE TM003<='20161231' AND TM012='Y'--删除生成分录的坏账准备单

--坏账处理单

SELECT * FROM ACRTN WHERE TN003<='20161231' AND TN020='Y'

DELETE FROM ACRTN WHERE TN003<='20161231' AND TN020='Y'--删除生成分录的坏账处理单


---客户帐款统计月档

-------报表有问题还原此档

SELECT * FROM ACRTE
DELETE FROM ACRTE WHERE TE002<='201612'

---客户帐款统计分类月档

-------报表有问题还原此档

SELECT * FROM ACRTF
DELETE FROM ACRTF WHERE TF002<='201612'

---应收帐款异动明细档

SELECT * FROM ACRLB WHERE LB004<='20161231' AND LB021='3'

DELETE FROM ACRLB WHERE LB004<='20161231' AND LB021='3'


---核销记录档

SELECT * FROM ACRLC WHERE LC007<='20161231' AND LC028='3'

DELETE FROM ACRLC WHERE LC007<='20161231' AND LC028='3'

---应收调汇


DELETE FROM ACRLD WHERE LD003<='20161231'

DELETE FROM ACRLE WHERE LE001+LE002 NOT IN (SELECT LD001+LD002 FROM ACRLD)

---调汇单子单身

SELECT * FROM ACRIE WHERE IE001+IE002+IE003 NOT IN (SELECT LE001+LE002+LE003 FROM ACRLE)

