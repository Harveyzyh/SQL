-- 更新采购发票的会计科目【月底成本计价前检查】

-- TB003  : 1 进货, 2 退货, 3 委外进货, 4 委外退货

SELECT *
-- UPDATE ACPTB SET TB013='1408'
FROM ACPTB
INNER JOIN ACPTA ON TB001=TA001 AND TB002=TA002
WHERE SUBSTRING(TA003,1,6)='202011' AND (TB004='3' OR TB004='4') 
AND EXISTS (SELECT 1 FROM ACMMJ WHERE TB037=MJ002 AND MJ003='3001' AND MJ004='Y' )
AND TB013 = '1407'







--------------------------------------------------------------------------
-- UPDATE ACPTB SET TB013='1408'
FROM ACPTB
INNER JOIN ACPTA ON TB001=TA001 AND TB002=TA002
WHERE SUBSTRING(TA003,1,6)='202001' AND (TB004='3' OR TB004='4')
AND EXISTS (SELECT 1 FROM ACMMJ WHERE TB037=MJ002 AND MJ003='3001' AND MJ004='Y' )
AND TB013 = '1407'
