SELECT o.type 类型, o.name OBJ名, OBJECT_NAME(o.parent_obj) 表名, c.text 内容, ~trr.is_disabled 启用, o.crdate
FROM sysobjects o 
INNER JOIN syscomments c ON o.id = c.id AND o.type in ('TR','P', 'V') and OBJECTPROPERTY(o.id,N'IsMSShipped') = 0
INNER JOIN sys.triggers AS trr ON trr.object_id = o.id
where 1=1
and convert(varchar(20), o.crdate, 112) >= '20150101'
