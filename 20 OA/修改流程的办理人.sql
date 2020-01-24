Select * from flow_type -- 流程类别小类
where flow_id = 3010
order by FLOW_ID


-- 修改流程的办理人
-- create table flow_process_tmp -- 创建备份表
select * from flow_process -- 流程步骤设计表
-- update flow_process set prcs_dept = CONCAT(prcs_dept,'65,')
where 1=1
-- and FLOW_ID = 3140 -- 流程编号，可以再flow_type表里获得
and PRCS_ID = 2  -- 步骤序号
and prcs_dept like '%26%' and prcs_dept not like '%65%'


select * from flow_process_tmp


-- 部门信息表
select * 
from department
where 1=1
and DEPT_PARENT = 22
