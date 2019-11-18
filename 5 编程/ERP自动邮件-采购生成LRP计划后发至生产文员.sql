
-- ==========================存储过程部分==========================
USE [COMFORT]
GO
/****** Object:  StoredProcedure [dbo].[P_LRPTA2MSG]    Script Date: 2019/8/8 13:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Harvey Z
-- Create date: 2019/8/8 14:00:00
-- Description:	穿入参数：领料单别，领料单号
-- 								处理事项：领料单审核后，判断该领料单内是否有工单已经完全领料，若存在，通过ERP邮件发送至生产文员
-- =============================================
ALTER PROCEDURE [dbo].[P_LRPTA2MSG]
-- CREATE PROCEDURE [dbo].[P_LRPTA2MSG] 
-- 创建领料单别单号变量
@TC001 VARCHAR(30) = NULL, @TC002 VARCHAR(30) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	--====================================================
	-- 整体逻辑架构：不想写了，自己猜吧
	--====================================================

	-- LRPTA创建人所在组
	DECLARE @USR_GROUP VARCHAR(20)

	-- 创建邮件ID号获取变量
	DECLARE @MSGID VARCHAR(14), @YMD VARCHAR(8)
	DECLARE @XH INT

	-- 创建订单信息变量
	DECLARE @TA047 VARCHAR(20), @TA048 VARCHAR(20), @TA049 VARCHAR(20), @TA037 VARCHAR(20), @MB002 VARCHAR(50), @MB003 VARCHAR(100), @TA044 VARCHAR(90)
	
	-- 创建邮件内容信息变量
	DECLARE @TITLE VARCHAR(100), @MSG_INF VARCHAR(8000)

	-- 创建收件人信息变量
	DECLARE @ERPID_ROW INT
	DECLARE @ERPID VARCHAR(20), @ERPNAME VARCHAR(50)
	DECLARE @ERPID_INF VARCHAR(200)

	-- 初始化收件人XML信息
	SET @ERPID_ROW = 0  -- 收件人序号，XML内容中需要
	SET @ERPID_INF = '' -- 收件人XML内容
	
	-- 初始化邮件内容信息
	SET @MSG_INF = ''
	
	-- 初始化采购部的组别
	SET @USR_GROUP = '061'

	-- ==========================以下为正式逻辑==========================
	IF EXISTS (SELECT * FROM CONFIG.dbo.sysobjects WHERE NAME = 'ERPMSG') -- 判断额外建的接收人表存在与否，避免不存在报错
	BEGIN 
		
		IF EXISTS (SELECT * FROM LRPTA WHERE UDF07 = 'N' AND  UDF07 IS NOT NULL AND USR_GROUP = @USR_GROUP)
		BEGIN 
			
			-- 获取年月日信息
			SELECT @YMD = CONVERT(VARCHAR(8), GETDATE(), 112)
			
			-- 获取收件人信息-游标获取
			IF EXISTS(SELECT * FROM CONFIG.dbo.ERPMSG)
			BEGIN
			
				DECLARE CUR_ERPID CURSOR FOR( SELECT DISTINCT ERPID FROM CONFIG.dbo.ERPMSG)
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
				
				-- 修改UDF07作为FLAG变为临时状态y
				UPDATE LRPTA SET UDF07 = 'y' WHERE UDF07 = 'N' AND UDF07 IS NOT NULL AND USR_GROUP = @USR_GROUP
				
				-- 获取各工单信息-游标获取
				DECLARE CUR_LRPTA CURSOR 
				FOR(
					SELECT RTRIM(TA047), RTRIM(TA048), RTRIM(TA049), RTRIM(TA037), RTRIM(MB002), RTRIM(MB003), RTRIM(TA044) FROM LRPTA 
					INNER JOIN INVMB ON MB001 = TA037
					WHERE LRPTA.UDF07 = 'y' AND LRPTA.UDF07 IS NOT NULL AND LRPTA.USR_GROUP = @USR_GROUP
				)
				
				OPEN CUR_LRPTA
				FETCH NEXT FROM CUR_LRPTA INTO @TA047, @TA048, @TA049, @TA037, @MB002, @MB003, @TA044
				WHILE @@FETCH_STATUS = 0
				BEGIN
				
					SET @MSG_INF = @MSG_INF + '
					<A href="dcms://YiFei/COMFORT/COPMI06/query/COPTC.TC001 = ''' + @TA047 + ''' and COPTC.TC002 = ''' + @TA048 + '''">
					<P>订单 : ' + @TA047 + '-' + @TA048 + '-' + @TA049 + '  品名 : ' + @MB002 + '  规格 : ' + @MB003 + '</P>
					</A>'
					
					FETCH NEXT FROM CUR_LRPTA INTO @TA047, @TA048, @TA049, @TA037, @MB002, @MB003, @TA044
				END
				
				CLOSE CUR_LRPTA
				DEALLOCATE CUR_LRPTA
				
				-- 获取ERP邮件流水号
				IF EXISTS( 
					SELECT TD001 AS T001 FROM DSCSYS.dbo.ADMTD WHERE SUBSTRING(TD001, 1, 8) = @YMD 
					UNION 
					SELECT TC001 AS T001 FROM DSCSYS.dbo.ADMTC WHERE SUBSTRING(TC001, 1, 8) = @YMD
					)
				BEGIN
					SELECT @XH = MAX(A.XH) FROM (
					SELECT CONVERT(INT, SUBSTRING(MAX(TD001), 9, 6)) AS XH FROM DSCSYS.dbo.ADMTD WHERE SUBSTRING(TD001, 1, 8) = @YMD
					UNION 
					SELECT CONVERT(INT, SUBSTRING(MAX(TC001), 9, 6)) AS XH FROM DSCSYS.dbo.ADMTC WHERE SUBSTRING(TC001, 1, 8) = @YMD
					)AS A
				END 
				ELSE
				BEGIN 
					SET @XH = 0
				END

				SET @MSGID = @YMD + RIGHT('000000' + CAST((@XH + 2) AS VARCHAR(6)), 6)
				
				-- 写入到待发送邮件表
				SET @TITLE = '采购生成采购计划通知'

				INSERT INTO DSCSYS.dbo.ADMTC ([COMPANY], [CREATOR], [USR_GROUP], [CREATE_DATE], [MODIFIER], [MODI_DATE], [FLAG], [TC001], [TC002], [TC003], [TC004], [TC005], [TC006], [TC007], 
				[TC008], [TC009], [TC010], [TC011], [TC012], [TC013], [TC014], [TC015], [TC016], [TC017], [UDF01], [UDF02], [UDF03], [UDF04], [UDF05], [UDF06], [UDF51], [UDF52], 
				[UDF53], [UDF54], [UDF55], [UDF56], [UDF07], [UDF08], [UDF09], [UDF10], [UDF11], [UDF12], [UDF57], [UDF58], [UDF59], [UDF60], [UDF61], [UDF62]) 
				VALUES ('COMFORT', 'DS', '', REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(varchar(100), GETDATE(), 25), '-', ''), ' ', ''), ':', ''), '.', ''), NULL, NULL, 0, 
				@MSGID, 'DS', '<?xml version="1.0" encoding="GB2312"?><Root>' + @ERPID_INF + '</Root>', 
				REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(varchar(100), GETDATE(), 25), '-', ''), ' ', ''), ':', ''), '.', ''), 'N', @TITLE, @TITLE, 
				'<FONT size=2>' + @MSG_INF + '</FONT>', 
				'0', '', '', NULL, 0.000000, 0.000000, 0.000000, 
				'<?xml version="1.0" encoding="GB2312"?><Root><Dispatching Enable="False"/></Root>', '<?xml version="1.0" encoding="GB2312"?><Attachments/>', 
				NULL, NULL, NULL, NULL, NULL, NULL, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, NULL, NULL, NULL, NULL, NULL, NULL, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000)
					
				-- 修改FLAG为Y
				UPDATE LRPTA SET UDF07 = 'Y' WHERE UDF07 = 'y' AND UDF07 IS NOT NULL AND USR_GROUP = @USR_GROUP
			END
		END 
	END
END