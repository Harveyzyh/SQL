SELECT RTRIM(PURMA.MA002) MA002, RTRIM(PURTC.TC003) TC003, 
RTRIM(PURTD.TD001) TD001, RTRIM(PURTD.TD002) TD002, RTRIM(PURTD.TD003) TD003, 
RTRIM(PURTD.TD004) MB001, RTRIM(INVMB.MB002) MB002, RTRIM(INVMB.MB003) MB003, CAST(PURTD.TD008 AS FLOAT)
FROM PURTD
INNER JOIN PURTC ON PURTC.TC001 = PURTD.TD001 AND PURTC.TC002 = PURTD.TD002
INNER JOIN PURMA ON PURMA.MA001 = PURTC.TC004
INNER JOIN INVMB ON INVMB.MB001 = PURTD.TD004
WHERE 1=1
AND PURTC.TC014 = 'Y'
AND PURTD.TD016 = 'N'


AND PURMA.MA001 = 'A0263'

ORDER BY RTRIM(PURMA.MA002), RTRIM(PURTC.TC003), 
RTRIM(PURTD.TD001), RTRIM(PURTD.TD002), RTRIM(PURTD.TD003)