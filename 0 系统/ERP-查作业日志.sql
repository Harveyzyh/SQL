-- 查作业日志

/* TB001 作业类型 1.建档 2.审核 3.counter
 * TB002 操作类型 0.修改 1.新增 2.删除 A.审核 B.取消审核 3.执行SQL
 * TB003 作业代号
 * TB004 登陆者编号
 * TB006 操作时间
 * TB007 数据主键
 */

-- USE COMFORT

SELECT TOP 2000 
(CASE TB001 WHEN '1' THEN '建档' WHEN'2' THEN '审核' WHEN '3' THEN 'counter' END) 作业类型, 
(CASE TB002 WHEN '0' THEN '修改' WHEN '1' THEN '新增' WHEN '2' THEN '删除' WHEN 'A' THEN '审核' WHEN 'B' THEN '取消审核' WHEN '3' THEN '执行SQL' END) 操作类型, 
RTRIM(TB003) 作业程序, RTRIM(ADMMB.MB002) 程序名称, RTRIM(TB004) 作业人, RTRIM(DSCMA.MA002) 姓名, TB006 作业时间, RTRIM(TB007) 数据主键, TB005 变更 FROM ADMTB
INNER JOIN DSCSYS..ADMMB AS ADMMB ON ADMMB.MB001 = TB003
INNER JOIN DSCSYS..DSCMA AS DSCMA ON DSCMA.MA001 = TB004
-- INNER JOIN INVMB ON MB001 = TB007
WHERE 1=1
-- AND CONVERT(varchar(10),TB006, 211) BETWEEN '20190114' AND '20190114'
-- AND CONVERT(varchar(10),TB006, 112) >= '20191022'


----查品号修改记录
-- AND TB002 = '0'
-- AND TB003 = 'MOCMI03'--领料
-- AND TB003 = 'INVMI02'--品号（全部）
-- AND ADMMB.MB002 LIKE '录入品号信息%'
-- AND TB003 LIKE 'INVI1%' --品号（基本）
-- AND TB007 IN ('10870201', '10170105', '10450507', '10810179', '22000286', '22000452', '22001917')
-- AND TB007 IN ('3040211002')
-- AND TB005 LIKE '%MB001=[3070207016]%'
-- AND TB004 = '001167'
-- AND SUBSTRING(TB007, 1, 1) IN ('1', '2')
-- AND MB025 = 'M'


---- 查配置方案修改记录
-- AND TB002 = '0'
-- AND TB003 = 'COPMI14'
-- AND TB007 = '601030872'
-- AND TB005 LIKE '%[10680101]%'
-- AND TB007 LIKE '10680101-TEST-ZYH%'
-- AND TB007 NOT LIKE '10460406-保友 TW黑A黑 LY340塑胶脚.%'
-- AND TB007 LIKE '10630103-保友 BM粉红  标配%'


---- 工单修改记录
-- AND TB003 = 'MOCMI02
-- AND TB005 LIKE '%5101-19092649%'
-- AND TB007 = '%19092649%'


---- LRP计划
-- AND TB003 LIKE  'LRP%'
-- AND TB007 LIKE '%9000400%'


---- 订单
-- AND TB003 = 'COPMI06'
-- AND TB007 LIKE '2201-015868%'

---- 订单变更
-- AND TB003 = 'COPMI07'


---- 录入BOM
-- AND TB003 = 'BOMI17'
-- AND TB007 LIKE '%00000001180%'

---- BOM变更
-- AND TB003 = 'BOMMI04'
-- AND TB007 LIKE '%19090024%'


---- 领料单
-- AND TB003 = 'MOCMI03'
-- AND TB007 LIKE '5406-2019070378%'


---- 商品条码
-- AND TB003 = 'INVI13'

---- 生产入库
AND TB003 = 'MOCMI05'
AND TB007 LIKE '%5803-20191200545%'


ORDER BY TB006
