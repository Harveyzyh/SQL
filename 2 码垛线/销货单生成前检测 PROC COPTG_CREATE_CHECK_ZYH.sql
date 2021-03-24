ALTER PROCEDURE dbo.COPTG_CREATE_CHECK_ZYH @PrintId INT, @STATUSS INT OUTPUT, @TG001 VARCHAR(4) OUTPUT, @TG004 VARCHAR(4) OUTPUT, @ERR VARCHAR(255) OUTPUT AS 
-- 0.此存储过程用于在99.COPTG生成前检查单据生成过程中是否会有异常用，参数PrintId，回传状态码@STATUSS，错误内容@ERR，客户编号@TG004 
-- 1.根据传入PrintId，关联198.PdData，查询是否有对应资料
-- 2.根据传入PrintId，关联198.PdData、99.COPTD，检查关联的客户订单是否有多个客户、不存在客户。若是，则修改并回传错误信息@ERR；否则修改并回传客户编号@TG004

BEGIN
	DECLARE @TG004COUNT INT, @SC037COUNT INT
	SET @STATUSS = 0
	SET @ERR = '0'
	IF NOT EXISTS(SELECT * FROM ROBOT_TEST.dbo.PdData WHERE PrintId = @PrintId)
	BEGIN 
		SET @STATUSS = 1
		SET @ERR = 'PdData 中没有对应数据'
	END
	
	-- 检测是否存在多个供应商
	IF (@STATUSS = 0)
	BEGIN 
		SELECT @TG004COUNT = ISNULL(COUNT(TC004), 0) FROM 
		(
			SELECT DISTINCT TC004 FROM [ROBOT_TEST].[dbo].[PdData] 
			LEFT JOIN [192.168.0.99].COMFORT.dbo.COPTC ON RTRIM(TC001) + '-' + RTRIM(TC002) = SUBSTRING(SC001, 1, LEN(SC001) - 5) collate chinese_prc_ci_as
			WHERE 1=1 AND PrintId = @PrintId 
		) AS A0
		
		IF (@TG004COUNT = 0)
		BEGIN 
			SET @STATUSS = 1
			SET @ERR = '没有找到供应商，供应商数量为0'
		END
		
		IF (@TG004COUNT > 1)
		BEGIN 
			SET @STATUSS = 1
			SET @ERR = '存在多个供应商，供应商数量为' + CONVERT(VARCHAR(20), @TG004COUNT)
		END
		
		-- 检测是否存在多个订单分类码
		IF (@STATUSS = 0)
		BEGIN
			SELECT @SC037COUNT = ISNULL(COUNT(SC037), 0) FROM 
			(
				SELECT DISTINCT SC037 FROM PdData 
				INNER JOIN SCHEDULE ON SCHEDULE.SC001 = PdData.SC001
				WHERE PdData.PrintId = @PrintId
			) AS A2
			
			IF (@SC037COUNT = 0)
			BEGIN
				SET @STATUSS = 1
				SET @ERR = '没有找到订单类别码，订单类别码数量为0'
			END
			
			IF (@SC037COUNT > 1)
			BEGIN
				SET @STATUSS = 1
				SET @ERR = '存在多个订单类别码，类别码数量为' + CONVERT(VARCHAR(20), @SC037COUNT)
			END
		END
		
		-- 当没有检测到异常
		IF (@STATUSS = 0)
		BEGIN 
			-- 获取供应商编号
			SELECT @TG004 = TC004 FROM 
			(
				SELECT DISTINCT RTRIM(TC004) AS TC004 FROM [ROBOT_TEST].[dbo].[PdData] 
				LEFT JOIN [192.168.0.99].COMFORT.dbo.COPTC ON RTRIM(TC001) + '-' + RTRIM(TC002) = SUBSTRING(SC001, 1, LEN(SC001) - 5) collate chinese_prc_ci_as
				WHERE 1=1 AND PrintId = @PrintId 
			) AS A0 
			
			-- 获取销货单别
			SELECT @TG001 = OutType FROM 
			(
				SELECT DISTINCT OutType FROM PdData 
				INNER JOIN SCHEDULE ON SCHEDULE.SC001 = PdData.SC001
				INNER JOIN SplitTypeCode ON SC037 = TypeCode
				WHERE PdData.PrintId = @PrintId
			)  AS A1
			
			IF (@TG001 IS NULL)
			BEGIN
				SET @STATUSS = 1
				SET @ERR = '对应订单类别码没有维护销货单别'
			END
		END
	END
END

