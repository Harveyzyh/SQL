-- 部门表
select * 
from department
-- update department set DEPT_NAME = '联友分公司'
where dept_no = 7
and dept_id = 57

EXPLAIN
select* from flow_run LIMIT 100


-- 查询所有流程明细，带最后流程创建日期
set @rownum=0; -- 设定序号开始
-- EXPLAIN  -- 查看能否优化
SELECT @rownum:=@rownum+1 as 序号, -- flow_type.FLOW_ID 流程ID, 
flow_sort.TITLE 流程类别, flow_type.FLOW_NAME 流程名称, flow_form_type.FORM_NAME 流程表单, 
-- (case flow_type.IS_USING when '1' then 'Y' when '0' then 'N' end) 启用, 
flow_process_tmp.prcs_name 流程步骤, flow_run_tmp.create_time_max 流程最后创建日期

FROM `flow_type`

inner join `flow_sort` on flow_type.FLOW_SORT = flow_sort.ID
inner join `flow_form_type` on flow_type.FORM_ID = flow_form_type.FORM_ID
inner join (
	select convert(group_concat(flow_process.prcs_name order by flow_process.prcs_id separator '--'), char(2047)) as prcs_name, flow_id 
	from flow_process 
	group by flow_process.flow_id 
) as flow_process_tmp on flow_process_tmp.flow_id = flow_type.flow_id

left join (
	select flow_id, max(create_time) create_time_max from flow_run group by flow_id
) as flow_run_tmp on flow_run_tmp.flow_id = flow_type.flow_id

where 1=1
and flow_type.IS_USING = '1'
and flow_type.flow_name not like ('%（停用）%')
and flow_type.flow_name not like ('%(停用)%')

and flow_run_tmp.create_time_max is not null
and DATE_FORMAT(flow_run_tmp.create_time_max, "%Y%m%d") > '20180601'

order by flow_sort.NOORDER, flow_type.FLOW_ID

