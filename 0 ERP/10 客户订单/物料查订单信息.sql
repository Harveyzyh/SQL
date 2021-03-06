SELECT TD004, TD053, TQ003, MV002, MAX(LEFT(COPTD.CREATE_DATE, 8))
FROM COPTC 
INNER JOIN COPTD ON TC001 = TD001 AND TC002 = TD002 
INNER JOIN COPTQ ON TQ001 = TD004 AND TQ002 = TD053
INNER JOIN MOCTA ON TA026 = TD001 AND TA027 = TD002 AND TA028 = TD003 
INNER JOIN MOCTB ON TA001 = TB001 AND TA002 = TB002
INNER JOIN CMSMV ON MV001 = COPTC.CREATOR
WHERE 1=1
AND TB003 = '3060404054'
GROUP BY TD004, TD053, TQ003, MV002