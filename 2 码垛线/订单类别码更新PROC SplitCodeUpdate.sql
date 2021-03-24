-- ALTER PROCEDURE dbo.SplitCodeUpdate AS 

BEGIN
	UPDATE ROBOT_TEST.dbo.SCHEDULE SET SC037 = SplitTypeCode1.TypeCode
	FROM ROBOT_TEST.dbo.SCHEDULE 
	INNER JOIN ROBOT_TEST.dbo.SplitTypeCode_copy AS SplitTypeCode1 ON SUBSTRING(SC001, 1, 4) = SplitTypeCode1.InType
	INNER JOIN 
	(
		SELECT InType FROM ROBOT_TEST.dbo.SplitTypeCode_copy GROUP BY InType HAVING COUNT(InType) = 1
	) AS SplitTypeCode2 ON SplitTypeCode1.InType = SplitTypeCode2.InType
	WHERE 1=1
	
	UPDATE ROBOT_TEST.dbo.SCHEDULE SET SC037 = SplitTypeCode1.TypeCode
	FROM ROBOT_TEST.dbo.SCHEDULE 
	INNER JOIN ROBOT_TEST.dbo.SplitTypeCode_copy AS SplitTypeCode1 ON SUBSTRING(SC001, 1, 4) = SplitTypeCode1.InType AND Spec = 'POP条码'
	INNER JOIN 
	(
		SELECT InType FROM ROBOT_TEST.dbo.SplitTypeCode_copy GROUP BY InType HAVING COUNT(InType) > 1
	) AS SplitTypeCode2 ON SplitTypeCode1.InType = SplitTypeCode2.InType
	WHERE 1=1
	AND SC017 LIKE '%' + Spec + '%'
	
	UPDATE ROBOT_TEST.dbo.SCHEDULE SET SC037 = SplitTypeCode1.TypeCode
	FROM ROBOT_TEST.dbo.SCHEDULE  
	INNER JOIN ROBOT_TEST.dbo.SplitTypeCode_copy AS SplitTypeCode1 ON SUBSTRING(SC001, 1, 4) = SplitTypeCode1.InType AND Spec = '京东条码'
	INNER JOIN 
	(
		SELECT InType FROM ROBOT_TEST.dbo.SplitTypeCode_copy GROUP BY InType HAVING COUNT(InType) > 1
	) AS SplitTypeCode2 ON SplitTypeCode1.InType = SplitTypeCode2.InType
	WHERE 1=1
	AND SC017 LIKE '%' + Spec + '%'

	UPDATE ROBOT_TEST.dbo.SCHEDULE SET SC037 = SplitTypeCode1.TypeCode
	FROM ROBOT_TEST.dbo.SCHEDULE 
	INNER JOIN ROBOT_TEST.dbo.SplitTypeCode_copy AS SplitTypeCode1 ON SUBSTRING(SC001, 1, 4) = SplitTypeCode1.InType AND Spec IS NULL
	INNER JOIN 
	(
		SELECT InType FROM ROBOT_TEST.dbo.SplitTypeCode_copy GROUP BY InType HAVING COUNT(InType) > 1
	) AS SplitTypeCode2 ON SplitTypeCode1.InType = SplitTypeCode2.InType
	WHERE 1=1
	AND SC017 NOT LIKE '%京东条码%' AND SC017 NOT LIKE '%POP条码%'

	UPDATE dbo.SCHEDULE SET SC037 = 'y' WHERE SC037 = 'n'
END
