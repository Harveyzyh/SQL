-- 获取码垛线完成信息
SELECT top 1 ID, MD_No from PrintData
where OutFlag = 0 order by Create_Date

-- 更新log中的id
select * 
-- update PdData set ID = ID
from PdData
where MD_No = MD_No
and ID is null
and Pd_Sta = 'OK'

-- 获取该板该ID的单号与汇总数量
select SC001, count(SC001) from PdData
where MD_No = MD_No
and ID = ID
group by SC001

-- 更新导出时间与TG001, TG002
-- update PrintData set OutFlag = 1, OutDate = GETDATE(), TG001 = TG001, TG002 = TG002

-- 更新打印时间
-- update PrintData set PrintFlag = 1, PrintDate = GETDATE()


select GETDATE()
