
-- 名称：领料单审核成功时，检查单身中工单是否完成领料，若是，则把工单发送至文员账号
-- ==========================使能触发器==========================
DISABLE TRIGGER [dbo].[T_MOCTC2Y] ON [dbo].[MOCTC]

-- ==========================触发器部分==========================
ALTER TRIGGER T_MOCTC2Y
ON MOCTC
WITH EXECUTE AS CALLER
AFTER UPDATE
AS
--=====================================
-- Author:		Harvey Z
-- Create date: 2019/8/8 14:00:00
-- Description: 当审核码变更为Y时，执行存储过程
--=====================================
IF UPDATE(TC009)
BEGIN
	DECLARE @TC001C VARCHAR(20), @TC002C VARCHAR(20), @TC009 VARCHAR(10)  
	SELECT @TC001C = RTRIM(TC001), @TC002C = RTRIM(TC002), @TC009 = RTRIM(TC009) FROM INSERTED
	IF(@TC009='Y' AND @TC001C LIKE '54%')
	BEGIN
		IF EXISTS (SELECT * FROM sysobjects WHERE name = 'P_MOCTC2Y2MSG' ) -- 判断存储过程是否存在，避免不存在报错
		BEGIN 
			EXEC P_MOCTC2Y2MSG @TC001=@TC001C, @TC002=@TC002C
		END
	END
END


-- ==========================存储过程部分==========================
USE [COMFORT]
GO
/****** Object:  StoredProcedure [dbo].[P_MOCTC2Y2MSG]    Script Date: 2019/8/8 13:50:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Harvey Z
-- Create date: 2019/8/8 14:00:00
-- Description:	传入参数：领料单别，领料单号
-- 								处理事项：领料单审核后，判断该领料单内是否有工单已经完全领料，若存在，通过ERP邮件发送至生产文员
-- =============================================
ALTER PROCEDURE [dbo].[P_MOCTC2Y2MSG]
-- CREATE PROCEDURE [dbo].[P_MOCTC2Y2MSG] 
-- 创建领料单别单号变量
@TC001 VARCHAR(30) = NULL, @TC002 VARCHAR(30) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
		--====================================================
	-- 整体逻辑架构：
	-- 	1.根据传入领料单单号，单号，获取单身中已完成领料的工单单别单号
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
	DECLARE @TA001 VARCHAR(4), @TA002 VARCHAR(20), @DDNO VARCHAR(20), @GDSL VARCHAR(20), @CPNO VARCHAR(20), @CPNAME VARCHAR(50), @CPGG VARCHAR(20)
	DECLARE @TITLE VARCHAR(100), @MSG_INF VARCHAR(3000)

	-- 创建收件人信息变量
	DECLARE @ERPID_ROW INT
	DECLARE @ERPID VARCHAR(20), @ERPNAME VARCHAR(50)
	DECLARE @ERPID_INF VARCHAR(200)

	-- 初始化收件人XML信息
	SET @ERPID_ROW = 0  -- 收件人序号，XML内容中需要
	SET @ERPID_INF = '' -- 收件人XML内容
	
	-- 初始化邮件内容信息
	SET @MSG_INF = ''

	-- ==========================以下为正式逻辑==========================
	IF EXISTS (SELECT * FROM CONFIG.dbo.sysobjects WHERE NAME = 'ERPMSG') -- 判断额外建的接收人表存在与否，避免不存在报错
	BEGIN 
		
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
			
			-- 获取领料单的部门信息
			SELECT @LLDPT=RTRIM(ME002) FROM COMFORT.dbo.MOCTC
			LEFT JOIN COMFORT.dbo.CMSME ON ME001 = TC021 
			WHERE TC001 = @TC001 AND TC002 = @TC002
			
			-- 获取收件人信息-游标获取
			IF EXISTS(SELECT * FROM CONFIG.dbo.ERPMSG WHERE ERPDPT = @LLDPT)
			BEGIN
			
				DECLARE CUR_ERPID CURSOR FOR( SELECT [ERPID] FROM CONFIG.dbo.ERPMSG WHERE ERPDPT = @LLDPT)
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
					SELECT @GDSL = CONVERT(VARCHAR(20), CONVERT(FLOAT, TA015)), @CPNO = RTRIM(TA006), @CPNAME = RTRIM(TA034), @DDNO = RTRIM(TA027), @CPGG = RTRIM(TA035) 
					FROM COMFORT.dbo.MOCTA LEFT JOIN COMFORT.dbo.CMSMD ON MD001 = TA021 WHERE TA001 = @TA001 AND TA002 = @TA002
					
					SET @MSG_INF = @MSG_INF + '
					<P>&nbsp;</P>
					<A href="dcms://YiFei/COMFORT/MOCMI02/query/MOCTA.TA001 = ''' + @TA001 + ''' and MOCTA.TA002 = ''' + @TA002 + '''">
					<P>品号 : ' + @CPNO + '  品名 : ' + @CPNAME + '  规格 : ' + @CPGG + '</P>
					<P>生产单号 : ' + @DDNO + '  生产数量 : ' + @GDSL + '</P>
					<P>工单单别 : ' + @TA001 + '</P>
					<P>工单单号 : ' + @TA002 + '</P>
					<P>生产部门 : ' + @LLDPT + '</P>
					</A>'
					
					FETCH NEXT FROM CUR_MOCTA INTO @TA001, @TA002
				END
				
				CLOSE CUR_MOCTA
				DEALLOCATE CUR_MOCTA
				
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
				SET @TITLE = '工单完成领料通知'

				INSERT INTO DSCSYS.dbo.ADMTC ([COMPANY], [CREATOR], [USR_GROUP], [CREATE_DATE], [MODIFIER], [MODI_DATE], [FLAG], [TC001], [TC002], [TC003], [TC004], [TC005], [TC006], [TC007], 
				[TC008], [TC009], [TC010], [TC011], [TC012], [TC013], [TC014], [TC015], [TC016], [TC017], [UDF01], [UDF02], [UDF03], [UDF04], [UDF05], [UDF06], [UDF51], [UDF52], 
				[UDF53], [UDF54], [UDF55], [UDF56], [UDF07], [UDF08], [UDF09], [UDF10], [UDF11], [UDF12], [UDF57], [UDF58], [UDF59], [UDF60], [UDF61], [UDF62]) 
				VALUES ('COMFORT', 'DS', '', REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(varchar(100), GETDATE(), 25), '-', ''), ' ', ''), ':', ''), '.', ''), NULL, NULL, 0, 
				@MSGID, 'DS', '<?xml version="1.0" encoding="GB2312"?><Root>' + @ERPID_INF + '</Root>', 
				REPLACE(REPLACE(REPLACE(REPLACE(CONVERT(varchar(100), GETDATE(), 25), '-', ''), ' ', ''), ':', ''), '.', ''), 'N', @TITLE, @CPNAME + ' ' + @CPNO, 
				'<FONT size=2>' + @MSG_INF + '</FONT>', 
				'0', '', '', NULL, 0.000000, 0.000000, 0.000000, 
				'<?xml version="1.0" encoding="GB2312"?><Root><Dispatching Enable="False"/></Root>', '<?xml version="1.0" encoding="GB2312"?><Attachments/>', 
				NULL, NULL, NULL, NULL, NULL, NULL, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, NULL, NULL, NULL, NULL, NULL, NULL, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000)
					
			END
		END 
	END
END