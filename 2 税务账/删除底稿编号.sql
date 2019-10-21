
-- 修改采购发票的 生成分录码
SELECT *FROM ACPTA
-- update ACPTA  set TA031='N' 
where TA001='7101' and TA002 >= '19090001'
AND TA031 = 'Y'



-- 删除对应的底稿编号数据
select * 
-- delete  
from AJSTA  where TA001='7101190901'

select * 
-- delete  
from AJSTB  where TB001='7101190901'

select * 
-- delete  
from AJSLA  where LA001='7101190901'

select * 
-- delete  
from AJSLB  where LB001='7101190901'
