select 
-- * 
em.EmployDate , em.Employee_ID 工号, em.Name 姓名, dpt.DepartName 部门, em.GetInDate 入职日期, em.Birthday 出生日期, DetailName 学历

from  hr_EmployeeBase as em
left join hr_depart as dpt on dpt.Depart_ID = em.Depart_ID
left join pb_RsDetail on Res_ID = EduLevel_ID
where 1=1
and em.Gender = 0
-- and dpt.DepartName in('电商部', '项目部')
-- and dpt.Depart_ID = 113

order by GetInDate desc
