select tsys_modulelist.moduleno 模块编号, tsys_modulelist.modulename 模块名称 from tsys_modulelist where 1=1
and tsys_modulelist.modulename like '%组织%'
order by tsys_modulelist.moduleno



select tsys_modulelist.moduleno 模块编号, tsys_modulelist.modulename 模块名称, 
tsys_usermodulefield.autoid 自增序号, tsys_usermodulefield.fieldname 字段, tsys_usermodulefield.chnname 字段名
from tsys_modulelist 
inner join tsys_usermodulefield on tsys_modulelist.moduleno = tsys_usermodulefield.moduleno 
where 1=1 
-- and tsys_modulelist.moduleno like '101%' -- 组织架构 
-- and tsys_modulelist.moduleno like '102%' -- 岗位管理 
and tsys_modulelist.moduleno like '201%' -- 员工信息 




order by tsys_modulelist.moduleno, tsys_usermodulefield.autoid





