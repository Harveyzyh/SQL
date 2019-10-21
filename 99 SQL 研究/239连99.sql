

SELECT * FROM INVMB_20190608 WHERE MB001 = '10860124'




declare @sql varchar(300)
declare @date varchar(20)
declare @remoteid varchar(50)

set @date=convert(varchar(20),getdate(),112)
set @remoteid='[192.168.0.99].[COMFORT]'
set @sql='select * from '+@remoteid+'.[dbo].[INVMB]'
	EXECUTE (@sql)
	
	
	
	select CINVMB.MB001, CINVMB.MB002, CINVMB.MB003, CINVMB.MB004, CINVMB.MB005, SINVMB.MB002, SINVMB.MB003, SINVMB.MB004, SINVMB.MB005
	from [192.168.0.99].[COMFORT].[dbo].[INVMB] AS CINVMB
	INNER JOIN INVMB AS SINVMB ON CINVMB.MB001 = SINVMB.MB001
	WHERE (CINVMB.MB002 != SINVMB.MB002 OR CINVMB.MB003 != SINVMB.MB003)