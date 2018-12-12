--查作业日志

/* TB001 作业类型 1.建档 2.审核 3.counter
 * TB002 操作类型 0.修改 1.新增 2.删除 A.审核 B.取消审核 3.执行SQL
 * TB003 作业代号
 * TB024 登陆者编号
 * TB006 操作时间
 * TB007 数据主键
 */

USE COMFORT

SELECT TOP 100 * FROM ADMTB
WHERE 1=1
--AND CONVERT(varchar(10),TB006, 23) BETWEEN '2017-11-05' AND '2018-10-18'
--AND TB002 = '0'
--AND TB003 = 'MOCMI03'--领料
AND TB003 = 'INVMI02'--品号（全部）
--AND TB003 = 'INVI05' --品号（基本）
AND TB007 = '3030311003'
--AND TB005 LIKE '%MB001=[3080107294]%'


