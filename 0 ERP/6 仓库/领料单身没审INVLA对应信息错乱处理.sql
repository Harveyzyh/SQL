USE COMFORT

--领料单单身没审核存在INVLA，但是对象序号等信息错乱查询
SELECT DISTINCT LA006,LA007,LA008 
--DELETE INVLA
FROM INVLA 
LEFT JOIN MOCTE ON TE001=LA006 AND TE002=LA007
WHERE 1=1
AND RTRIM(TE011) + '-' + RTRIM(TE012) <> RTRIM(LA024)

AND RTRIM(LA006) + '-' + RTRIM(LA007) = '5406-2018091904'

--撤审错乱领料单，二次的需要删除，重新生成二次