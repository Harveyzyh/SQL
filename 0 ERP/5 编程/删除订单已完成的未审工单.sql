SELECT TD001, TD002, TD003, TD004, TD053, TD008, TD009, TD016, TA001, TA002, TA006, TA013, TA011
FROM COPTC 
INNER JOIN COPTD ON TC001 = TD001 AND TC002 = TD002
LEFT JOIN MOCTA ON TA026 = TD001 AND TA027 = TD002 AND TA028 = TD003 
WHERE 1=1
AND TA013 IN ('N')
AND COPTC.TC027 = 'Y' 
AND COPTD.UDF04 != 0
AND COPTD.TD016 IN ('Y', 'y')


DECLARE @WORKFLAG INT, @TA001 VARCHAR(4), @TA002 VARCHAR(20) 
SET @WORKFLAG = 1
PRINT('WORK START')
WHILE(@WORKFLAG = 1)
BEGIN 
	SET @TA001 = '' 
	SET @TA002 = ''
	IF EXISTS(SELECT 1 FROM COPTC 
						INNER JOIN COPTD ON TC001 = TD001 AND TC002 = TD002
						LEFT JOIN MOCTA ON TA026 = TD001 AND TA027 = TD002 AND TA028 = TD003 
						WHERE 1=1
						AND TA013 IN ('N')
						AND COPTC.TC027 = 'Y' 
						AND COPTD.UDF04 != 0
						AND COPTD.TD016 IN ('Y', 'y'))
	BEGIN
		SELECT TOP 1 @TA001 = TA001, @TA002 = TA002 FROM COPTC 
		INNER JOIN COPTD ON TC001 = TD001 AND TC002 = TD002
		LEFT JOIN MOCTA ON TA026 = TD001 AND TA027 = TD002 AND TA028 = TD003 
		WHERE 1=1
		AND TA013 IN ('N')
		AND COPTC.TC027 = 'Y' 
		AND COPTD.UDF04 != 0
		AND COPTD.TD016 IN ('Y', 'y') 
		
		PRINT('DELETE ' + @TA001 +'-' + @TA002)
		
		DELETE FROM MOCTB WHERE TB001 = @TA001 AND TB002 = @TA002 
		DELETE FROM MOCTA WHERE TA001 = @TA001 AND TA002 = @TA002
	END
	ELSE 
	BEGIN 
		SET @WORKFLAG = 0
	END 
END
PRINT('WORK FINISHED')
		
	

