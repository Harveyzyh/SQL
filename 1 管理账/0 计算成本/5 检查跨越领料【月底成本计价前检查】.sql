
DECLARE @NY VARCHAR(20), @NYR VARCHAR(20)

DECLARE @NY1 VARCHAR(20), @NY2 VARCHAR(20)

SET @NY = '202011'  -- 输入当前检查的年月

SELECT @NYR = @NY + '01'

SELECT @NY1 = SUBSTRING(CONVERT(VARCHAR(20), DATEADD(mm, -1, CONVERT(DATE, @NYR, 112)), 112), 1, 6) -- 上一个月

SELECT @NY2 = SUBSTRING(CONVERT(VARCHAR(20), DATEADD(mm, 1, CONVERT(DATE, @NYR, 112)), 112), 1, 6)  -- 下一个月


SELECT DISTINCT '下月' AS A, TA001,TA002,TE001,TE002,TC003, TC009
FROM MOCTE
INNER JOIN MOCTC ON TE001=TC001 AND TE002=TC002
INNER JOIN MOCTA ON TE011=TA001 AND TE012=TA002
WHERE SUBSTRING(TA014,1,6) = @NY AND TC003 >= @NY2 + '01'  AND TC009<>'V'
AND TA011 IN ('Y', 'y')

UNION

--检查上月完工的工单，在当月还有领料或者退料的资料
SELECT DISTINCT '上月' AS A, TA001,TA002,TE001,TE002,TC003, TC009
FROM MOCTE
INNER JOIN MOCTC ON TE001=TC001 AND TE002=TC002
INNER JOIN MOCTA ON TE011=TA001 AND TE012=TA002
WHERE SUBSTRING(TA014,1,6)= @NY1 AND TC003 >= @NY + '01'  AND TC009<>'V'
AND TA011 IN ('Y', 'y')
