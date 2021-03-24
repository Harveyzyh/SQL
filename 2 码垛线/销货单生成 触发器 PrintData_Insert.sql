
ALTER TRIGGER [dbo].[PrintData_Insert] 
ON [dbo].[PrintData] 
WITH EXECUTE AS CALLER 
AFTER INSERT 
AS 
SET NOCOUNT ON 
BEGIN 
	DECLARE @PrintId int, @MD_No int, @Num int 
	DECLARE @sqlstr varchar(MAX) 
	DECLARE @STATUSS INT, @TG001 VARCHAR(4), @TG004 VARCHAR(4), @ERR VARCHAR(255) 
	
	SELECT @PrintId = PrintId, @MD_No = MD_No, @Num = Num from inserted 
	
	-- 根据对应板的数目、板号，按插入时间排序，更新对应数目的PdData数据
	SET @sqlstr = ' UPDATE dbo.PdData SET PrintId = ' + CONVERT(VARCHAR(100), @PrintId) + '  
		FROM dbo.PdData AS PD1 
		inner join ( 
			SELECT TOP ' + CONVERT(VARCHAR(20), @Num) + ' PD3.Pd_date, PD3.SC001 FROM dbo.PdData AS PD3
			WHERE PD3.PrintId IS NULL AND PD3.Pd_Sta = ''OK'' AND PD3.MD_No = ' + CONVERT(VARCHAR(20), @MD_No) + ' 
			ORDER BY PD3.Pd_date 
		) AS PD2 ON PD2.Pd_date = PD1.Pd_date AND PD2.SC001 = PD1.SC001 ' 
	EXECUTE(@sqlstr) 
	
	-- 按PrintId，对PdData中的数据进行检测，如：PdData中没有数据、关联99.COPTC没找到供应商、或有多个供应商等，若有需要，请对存储过程作修改
	EXEC ROBOT_TEST.dbo.COPTG_CREATE_CHECK_ZYH @PrintId, @STATUSS OUTPUT, @TG001 OUTPUT, @TG004 OUTPUT, @ERR OUTPUT 
	
	-- 对存储过程中返回的数据进行判断处理
	IF(@STATUSS != 0) 
	BEGIN 
		UPDATE [dbo].[PrintData] SET Remark = @ERR, OutFlag = 1, OutDate = getdate(), PrintFlag = 1, PrintDate = getdate(), STATUSS = @STATUSS, TG004 = @TG004, TG001 = @TG001  
		WHERE PrintId = @PrintId 
	END 
	ELSE 
	BEGIN 
		UPDATE [dbo].[PrintData] SET OutFlag = 0, OutDate = NULL, PrintFlag = 0, PrintDate = NULL, STATUSS = @STATUSS, TG004 = @TG004, TG001 = @TG001  
		WHERE PrintId = @PrintId
	END 
END
SET NOCOUNT OFF


