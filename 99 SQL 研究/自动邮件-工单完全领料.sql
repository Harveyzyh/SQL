SELECT *
-- DELETE
FROM ADMTC WHERE FLAG = 0 AND CREATOR = 'DS'


SELECT TOP 100 * FROM ADMTD WHERE 1=1
-- AND CREATOR = 'DS' 
ORDER BY TD001 DESC


/*
UPDATE DSCSYS.dbo.ADMTE SET TE005 = 'T', TE011 = 'T' WHERE TE002 = 'DS' AND (TE005 = 'F' OR TE011 = 'F')
SELECT TOP 20 * FROM DSCSYS.dbo.ADMTE ORDER BY TE001 DESC
*/


--====================================================
-- 整体逻辑架构：
-- 	1.根据穿入领料单单号，单号，获取单身中已完成领料的工单单别单号
-- 	2.如 1 不为空，获取收件人信息， 获取年月日信息
-- 	3.对 1 结果游标循环：
-- 		1.根据工单单别单号获取工单成品信息，生产数量
-- 		2.获取最新的ERP邮件流水号
-- 		3.邮件内容写入DSCSYS..ADMTC
-- 		
-- 	结果：对领料单里的每一个完成领料的工单都单独发送一份ERP邮件
-- 	
-- 	待调整：根据领料单的录单部门，对应地发送到对应部门的文员账号
--====================================================

-- 创建领料单信息
DECLARE @LLDPT VARCHAR(20)

-- 创建邮件ID号获取变量
DECLARE @MSGID VARCHAR(14), @YMD VARCHAR(8)
DECLARE @XH INT

-- 创建工单信息变量
DECLARE @TA001 VARCHAR(4), @TA002 VARCHAR(20), @DDNO VARCHAR(20), @GDSL VARCHAR(20), @GDDPT VARCHAR(20), @CPNO VARCHAR(20), @CPNAME VARCHAR(50)
DECLARE @TITLE VARCHAR(100)

-- 创建收件人信息变量
DECLARE @ERPID_ROW INT
DECLARE @ERPID VARCHAR(20), @ERPNAME VARCHAR(50)
DECLARE @ERPID_INF VARCHAR(200)

-- 创建收件人XML信息变量
SET @ERPID_ROW = 0  -- 收件人序号，XML内容中需要
SET @ERPID_INF = '' -- 收件人XML内容

-- ==========================以下为正式逻辑==========================
IF EXISTS (SELECT * FROM COMFORT.dbo.MOCTC
INNER JOIN COMFORT.dbo.MOCTE ON TC001 = TE001 AND TC002 = TE002
WHERE 1=1
AND TC001 = @TC001 AND TC002 = @TC002
AND EXISTS (
SELECT 1 FROM COMFORT.dbo.MOCTA WHERE TA001 = TE011 AND TA002 = TE012)
AND NOT EXISTS (
SELECT 1 FROM  COMFORT.dbo.MOCTB
WHERE TE011 = TB001 AND TE012 = TB002 AND TB004 > TB005)
)
BEGIN 
	-- 获取年月日信息
	SELECT @YMD = CONVERT(VARCHAR(8), GETDATE(), 112)
	
	-- 获取收件人信息-游标获取
	DECLARE CUR_ERPID CURSOR FOR( SELECT [ERPID] FROM ATEST.dbo.ERPMSG )
	OPEN CUR_ERPID
	FETCH NEXT FROM CUR_ERPID INTO @ERPID
	WHILE @@FETCH_STATUS = 0
	BEGIN 
		SET @ERPID_ROW += 1
		SELECT @ERPNAME = MA002 FROM DSCSYS.dbo.DSCMA WHERE MA001 = @ERPID
		SET @ERPID_INF += '<R' + CONVERT(VARCHAR(20), @ERPID_ROW) + ' ID="' + @ERPID + '" Name="' + @ERPNAME + '" Type="1" Msg="YNN"/>'
		FETCH NEXT FROM CUR_ERPID INTO @ERPID
	END
	CLOSE CUR_ERPID
	DEALLOCATE CUR_ERPID
	
	-- 获取各工单信息-游标获取
	DECLARE CUR_MOCTA CURSOR 
	FOR(
	SELECT DISTINCT TE011, TE012 FROM COMFORT.dbo.MOCTC
	INNER JOIN COMFORT.dbo.MOCTE ON TC001 = TE001 AND TC002 = TE002
	WHERE 1=1
	AND TC001 = @TC001 AND TC002 = @TC002
	AND EXISTS (
	SELECT 1 FROM COMFORT.dbo.MOCTA
	WHERE TA001 = TE011 AND TA002 = TE012)
	AND NOT EXISTS (
	SELECT 1 FROM  COMFORT.dbo.MOCTB
	WHERE TE011 = TB001 AND TE012 = TB002 AND TB004 > TB005)
	)
	OPEN CUR_MOCTA
	FETCH NEXT FROM CUR_MOCTA INTO @TA001, @TA002
	WHILE @@FETCH_STATUS = 0
	BEGIN
		-- 获取工单信息
		SELECT @GDSL = CONVERT(VARCHAR(20), CONVERT(FLOAT, TA015)), @CPNO = RTRIM(TA006), @CPNAME = RTRIM(TA034), @GDDPT = RTRIM(MD002), @DDNO = RTRIM(TA027) 
		FROM COMFORT.dbo.MOCTA LEFT JOIN COMFORT.dbo.CMSMD ON MD001 = TA021 WHERE TA001 = @TA001 AND TA002 = @TA002
		
		-- 获取ERP邮件流水号
		IF EXISTS( SELECT * FROM DSCSYS.dbo.ADMTD WHERE SUBSTRING(TD001, 1, 8) = @YMD)
		BEGIN
			SELECT @XH = CONVERT(INT, SUBSTRING(MAX(TD001), 9, 6)) FROM DSCSYS.dbo.ADMTD WHERE SUBSTRING(TD001, 1, 8) = @YMD
		END 
		ELSE
		BEGIN 
			SET @XH = 0
		END

		SET @MSGID = @YMD + RIGHT('000000' + CAST((@XH + 1) AS VARCHAR(6)), 6)
		
		-- 写入到待发送邮件表
		SET @TITLE = '工单完成领料通知：' + @TA001 + '-' + @TA002

		INSERT INTO DSCSYS.dbo.ADMTC ([COMPANY], [CREATOR], [USR_GROUP], [CREATE_DATE], [MODIFIER], [MODI_DATE], [FLAG], [TC001], [TC002], [TC003], [TC004], [TC005], [TC006], [TC007], 
		[TC008], [TC009], [TC010], [TC011], [TC012], [TC013], [TC014], [TC015], [TC016], [TC017], [UDF01], [UDF02], [UDF03], [UDF04], [UDF05], [UDF06], [UDF51], [UDF52], 
		[UDF53], [UDF54], [UDF55], [UDF56], [UDF07], [UDF08], [UDF09], [UDF10], [UDF11], [UDF12], [UDF57], [UDF58], [UDF59], [UDF60], [UDF61], [UDF62]) 
		VALUES ('COMFORT', 'Robot', '', REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(varchar(100), GETDATE(), 25), '-', ''), ' ', ''), ':', ''), '.', ''), NULL, NULL, 0, 
		@MSGID, 'Robot', '<?xml version="1.0" encoding="GB2312"?><Root>' + @ERPID_INF + '</Root>', 
		REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(varchar(100), GETDATE(), 25), '-', ''), ' ', ''), ':', ''), '.', ''), 'N', @TITLE, @CPNAME + ' ' + @CPNO, 
		'<FONT size=2>
		<P>&nbsp;</P>
		<A href="dcms://YiFei/COMFORT/MOCMI02/query/MOCTA.TA001 = ''' + @TA001 + ''' and MOCTA.TA002 = ''' + @TA002 + '''">
		<P>品号 : ' + @CPNO + '  品名 : ' + @CPNAME + '</P>
		<P>生产单号 : ' + @DDNO + '  生产数量 : ' + @GDSL + '</P>
		<P>工单单别 : ' + @TA001 + '</P>
		<P>工单单号 : ' + @TA002 + '</P>
		<P>工单单号 : ' + @TA002 + '</P>
		</A>
		</FONT>', 
		'0', '', '', NULL, 0.000000, 0.000000, 0.000000, 
		'<?xml version="1.0" encoding="GB2312"?><Root><Dispatching Enable="False"/></Root>', '<?xml version="1.0" encoding="GB2312"?><Attachments/>', 
		NULL, NULL, NULL, NULL, NULL, NULL, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, NULL, NULL, NULL, NULL, NULL, NULL, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000)

	END
	CLOSE CUR_MOCTA
	DEALLOCATE CUR_MOCTA
END 





-- 获取及设置ERP邮件流水号
IF EXISTS( SELECT * FROM DSCSYS.dbo.ADMTD WHERE SUBSTRING(TD001, 1, 8) = @YMD)
BEGIN
	SELECT @XH = CONVERT(INT, SUBSTRING(MAX(TD001), 9, 6)) FROM DSCSYS.dbo.ADMTD WHERE SUBSTRING(TD001, 1, 8) = @YMD
END 
ELSE
BEGIN 
	SET @XH = 0
END

SET @MSGID = @YMD + RIGHT('000000' + CAST((@XH + 1) AS VARCHAR(6)), 6)

SET @TA001 = '5101' 
SET @TA002 = '19070020'

SET @TITLE = '工单完成领料通知：' + @TA001 + '-' + @TA002

	SELECT @GDSL = CONVERT(VARCHAR(20), CONVERT(FLOAT, TA015)), @CPNO = RTRIM(TA006), @CPNAME = RTRIM(TA034), @GDDPT = RTRIM(MD002), @DDNO = RTRIM(TA027) 
	FROM COMFORT.dbo.MOCTA LEFT JOIN COMFORT.dbo.CMSMD ON MD001 = TA021 WHERE TA001 = @TA001 AND TA002 = @TA002

	INSERT INTO DSCSYS.dbo.ADMTC ([COMPANY], [CREATOR], [USR_GROUP], [CREATE_DATE], [MODIFIER], [MODI_DATE], [FLAG], [TC001], [TC002], [TC003], [TC004], [TC005], [TC006], [TC007], 
	[TC008], [TC009], [TC010], [TC011], [TC012], [TC013], [TC014], [TC015], [TC016], [TC017], [UDF01], [UDF02], [UDF03], [UDF04], [UDF05], [UDF06], [UDF51], [UDF52], 
	[UDF53], [UDF54], [UDF55], [UDF56], [UDF07], [UDF08], [UDF09], [UDF10], [UDF11], [UDF12], [UDF57], [UDF58], [UDF59], [UDF60], [UDF61], [UDF62]) 
	VALUES ('COMFORT', 'Robot', '', REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(varchar(100), GETDATE(), 25), '-', ''), ' ', ''), ':', ''), '.', ''), NULL, NULL, 0, 
	@MSGID, 'Robot', '<?xml version="1.0" encoding="GB2312"?><Root>' + @ERPID_INF + '</Root>', 
	REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(varchar(100), GETDATE(), 25), '-', ''), ' ', ''), ':', ''), '.', ''), 'N', @TITLE, @CPNAME + ' ' + @CPNO, 
	'<FONT size=2>
	<P>&nbsp;</P>
	<A href="dcms://YiFei/COMFORT/MOCMI02/query/MOCTA.TA001 = ''' + @TA001 + ''' and MOCTA.TA002 = ''' + @TA002 + '''">
	<P>品号 : ' + @CPNO + '  品名 : ' + @CPNAME + '</P>
	<P>生产单号 : ' + @DDNO + '  生产数量 : ' + @GDSL + '</P>
	<P>工单单别 : ' + @TA001 + '</P>
	<P>工单单号 : ' + @TA002 + '</P>
	<P>工单单号 : ' + @TA002 + '</P>
	</A>
	</FONT>', 
	'0', '', '', NULL, 0.000000, 0.000000, 0.000000, 
	'<?xml version="1.0" encoding="GB2312"?><Root><Dispatching Enable="False"/></Root>', '<?xml version="1.0" encoding="GB2312"?><Attachments/>', 
	NULL, NULL, NULL, NULL, NULL, NULL, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, NULL, NULL, NULL, NULL, NULL, NULL, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000)


