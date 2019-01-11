
SELECT * 
--DELETE 
FROM Doc2VN
WHERE 1=1
--AND IP = '192.168.1.60'
ORDER BY MDATE

--====================================================================================================================================
ALTER TRIGGER T_MOCTC2VN
ON MOCTC
FOR UPDATE
AS
--=====================================
--Author: 钟耀辉
--Date: 2019-01-10
--Description: 记录领料单单头审核码更改为V的信息
--=====================================
IF UPDATE(TC009)
BEGIN
	DECLARE @IP VARCHAR(255), 
					@TC001 VARCHAR(255), @TC002 VARCHAR(255), @TC009 VARCHAR(255), @MODIFIER VARCHAR(255), @MODI_DATE VARCHAR(255);
					
	SELECT @IP = client_net_address  
	FROM sys.dm_exec_connections  
	WHERE Session_id = @@SPID;
		 
	SELECT @TC001=TC001, @TC002=RTRIM(TC002), @TC009=TC009, @MODIFIER=RTRIM(MODIFIER), @MODI_DATE=MODI_DATE FROM INSERTED
	
	IF(@TC009='V')
	BEGIN
		IF(@MODIFIER='')
		BEGIN
			SELECT @MODIFIER=MODIFIER FROM MOCTC WHERE TC001=@TC001 AND TC002=@TC002
		END
		INSERT INTO Doc2VN (MID, MDATE, NAME, FLAG, A001, A002, IP) VALUES(@MODIFIER, @MODI_DATE, 'MOCTC', @TC009, @TC001, @TC002, @IP)
	END
END

--====================================================================================================================================
ALTER TRIGGER [dbo].[T_COPTQ2VN]
ON [dbo].[COPTQ]
WITH EXECUTE AS CALLER
AFTER UPDATE
AS
--=====================================
--Author: 钟耀辉
--Date: 2019-01-10
--Description: 记录配置方案单头审核码更改为V与N的信息
--=====================================
IF UPDATE(TQ006)
BEGIN
	DECLARE @IP VARCHAR(255), 
					@TQ001 VARCHAR(255), @TQ002 VARCHAR(255), @TQ006 VARCHAR(255), @MODIFIER VARCHAR(255), @MODI_DATE VARCHAR(255);
					
	SELECT @IP = client_net_address  
	FROM sys.dm_exec_connections  
	WHERE Session_id = @@SPID;
		 
	SELECT @TQ001=TQ001, @TQ002=RTRIM(TQ002), @TQ006=TQ006, @MODIFIER=RTRIM(MODIFIER), @MODI_DATE=MODI_DATE FROM INSERTED
	IF(@TQ006='V' OR @TQ006='N')
	BEGIN
		IF(@MODIFIER='' OR @MODIFIER IS NULL)
		BEGIN
			SELECT @MODIFIER=MODIFIER FROM COPTQ WHERE TQ001=@TQ001 AND TQ002=@TQ002
		END
		INSERT INTO Doc2VN (MID, MDATE, NAME, FLAG, A001, A002, IP) VALUES(@MODIFIER, @MODI_DATE, 'COPTQ', @TQ006, @TQ001, @TQ002, @IP)
	END
END

--====================================================================================================================================
ALTER TRIGGER [dbo].[T_MOCTBIsNull]
ON [dbo].[MOCTA]
WITH EXECUTE AS CALLER
AFTER UPDATE
AS
-- =============================================
-- Author:		钟耀辉
-- Create date: 2019-01-03
-- Description:	针对工单有单头无单身时，处理为无法通过审核
-- =============================================
IF UPDATE(TA013)
BEGIN
	DECLARE @TA001 VARCHAR(10), @TA002 VARCHAR(20), @TA013 CHAR(1), @IP VARCHAR(50);
	
	SELECT @IP = client_net_address FROM sys.dm_exec_connections WHERE Session_id = @@SPID;
	
	SELECT @TA001=TA001, @TA002=TA002,@TA013=TA013 FROM INSERTED
	
	IF(@TA013='Y')
	BEGIN
		IF (NOT EXISTS(SELECT TB002 FROM MOCTB WHERE TB001 = @TA001 AND TB002 = @TA002))
		BEGIN
			
			INSERT INTO MOCTBIsNull (CREATE_DATE, IP, TA001, TA002)
			VALUES((CONVERT(VARCHAR(20), GETDATE(), 112) + REPLACE(CONVERT(VARCHAR(20), GETDATE(), 24), ':', '')), @IP, @TA001, @TA002)
			
		END
	END
			
	IF((@TA013='Y')OR(@TA013='U'))
	BEGIN
	
		IF (NOT EXISTS(SELECT TB002 FROM MOCTB WHERE TB001 = @TA001 AND TB002 = @TA002))
		BEGIN
		
			ROLLBACK TRANSACTION 
			
		END
	END
END

--====================================================================================================================================
ALTER TRIGGER [dbo].[T_MOCTBIsNullLog]
ON [dbo].[MOCTA]
WITH EXECUTE AS CALLER
AFTER UPDATE
AS
-- =============================================
-- Author:		钟耀辉
-- Create date: 2019-01-03
-- Description:	针对工单有单头无单身时，把工单单头记录到表MOCTBIsNullLog
-- =============================================
IF UPDATE(TA013)
BEGIN
	DECLARE @TA001 VARCHAR(10), @TA002 VARCHAR(20), @TA013 CHAR(1), @IP VARCHAR(50);
	
	SELECT @IP = client_net_address FROM sys.dm_exec_connections WHERE Session_id = @@SPID;
	
	SELECT @TA001=TA001, @TA002=TA002,@TA013=TA013 FROM INSERTED
	
	IF(@TA013='Y')
	BEGIN
		IF (NOT EXISTS(SELECT TB002 FROM MOCTB WHERE TB001 = @TA001 AND TB002 = @TA002))
		BEGIN
			
			INSERT INTO MOCTBIsNullLog (CREATE_DATE, IP, TA001, TA002)
			VALUES((CONVERT(VARCHAR(20), GETDATE(), 112) + REPLACE(CONVERT(VARCHAR(20), GETDATE(), 24), ':', '')), @IP, @TA001, @TA002)
			
		END
	END
END




--====================================================================================================================================
--DELETE FROM MOCTENoTwice WHERE TE001='5407'
SELECT * FROM MOCTENoTwice
WHERE SUBSTRING(CREATE_DATE, 1, 8) <= '20190105'

SELECT TW.CREATE_DATE, TE.TE001, TE.TE002, TE.TE003, TE.TE004, TE.TE009, TE.TE011, TE.TE012, TB004-TB005, TC001, TC002 FROM MOCTENoTwice AS TW
INNER JOIN MOCTE AS TE ON TE.TE001 = TW.TE001 AND TE.TE002 = TW.TE002 AND TE.TE003 = TW.TE003 AND TE.TE004 = TW.TE004 AND TE.TE009 = TW.TE009
INNER JOIN MOCTB ON TE.TE011 = TB001 AND TE.TE012 = TB002 AND TE.TE004 = TB003 AND TE.TE009 = TB006
LEFT JOIN MOCTC ON TE.TE001 = TC019 AND TE.TE002 = TC020
WHERE 1=1
AND SUBSTRING(TE.TE001, 1, 2) = '54'
AND TB004 > TB005
AND TE019 = 'Y'
AND TC002 IS NULL



