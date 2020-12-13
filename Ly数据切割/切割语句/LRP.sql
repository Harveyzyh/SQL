---LRP批次需求计划---


---生产计划

SELECT * FROM LRPTA WHERE LEFT(CREATE_DATE,8)<='20161231' AND TA051<>'N'

DELETE FROM LRPTA WHERE LEFT(CREATE_DATE,8)<='20161231' AND TA051<>'N'

---相关需求

DELETE FROM LRPTB WHERE LEFT(CREATE_DATE,8)<='20161231' AND TB001+TB002+TB003+TB004 
NOT IN (SELECT TA001+TA002+TA003+TA004 FROM LRPTA)

---采购计划

DELETE FROM LRPTC WHERE LEFT(CREATE_DATE,8)<='20161231'  AND TC047<>'N'

---生产计划每日产量档

DELETE FROM LRPTE WHERE LEFT(CREATE_DATE,8)<='20161231'  AND TE001+TE002+TE003+TE004
NOT IN (SELECT TA001+TA002+TA003+TA004 FROM LRPTA)


---计划来源

DELETE FROM LRPLA WHERE LA001 NOT IN (SELECT TA001 FROM LRPTA) AND LA001 NOT IN (SELECT TB001 FROM LRPTB)
AND LEFT(CREATE_DATE,8)<='20161231'

DELETE FROM LRPLB WHERE LB001 NOT IN (SELECT LA001 FROM LRPLA)

---工作号

SELECT * FROM LRPLC WHERE LEFT(CREATE_DATE,8)<='20161231'

DELETE FROM LRPLC WHERE LEFT(CREATE_DATE,8)<='20161231'






