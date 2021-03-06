

SELECT 
RTRIM(MB001) AS 品号, 
RTRIM(MB002) AS 品名, 
RTRIM(MB003) AS 规格,    
RTRIM(MB004) AS 单位, 
RTRIM(MB064) AS 数量, 
(CASE RTRIM(MB025) WHEN 'P' THEN '采购件' WHEN 'C' THEN '配置件' WHEN 'S' THEN '委外件' WHEN 'M' THEN '自制件' WHEN 'Y' THEN '虚设件' ELSE RTRIM(MB025) END) AS 品号属性, 
RTRIM(MB014) AS 单位净重, RTRIM(MB015) AS 重量单位, 
RTRIM(MB032) AS 供应商编码, 
RTRIM(MA002) 供应商简称,  
(CASE WHEN MB109 = 'Y' THEN '已核准' WHEN MB109 = 'y' THEN '尚未核准' WHEN MB109 = 'N' THEN '不准交易' END ) AS 核准状况

FROM INVMB
LEFT JOIN PURMA ON MA001 = MB032
ORDER BY MB109 DESC, MB025, MB001
