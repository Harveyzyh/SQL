/*

注：每计算完一次生产成本后，就执行以下语句，然后再计算生产成本，这样反复操作几次。
每个月执行时，只需将下面的月份，如计算7月份时为201307，8月份时则为201308。

*/



--239
USE Comfortseating

/*

DECLARE @NIANYUE VARCHAR(6)
SET @NIANYUE='201902'

DELETE FROM CSTMB WHERE SUBSTRING(MB002,1,6)=@NIANYUE
INSERT INTO 
CSTMB(COMPANY,CREATOR,USR_GROUP,CREATE_DATE,MODIFIER,MODI_DATE,FLAG,
MB001,MB002,MB003,MB004,MB005,MB006,MB007,MB008,MB009,MB010,MB011,MB012,MB013,
UDF01,UDF02,UDF03,UDF04,UDF05,UDF06,UDF07,UDF08,UDF09,UDF10,UDF11,UDF12,UDF51,UDF52,
UDF53,UDF54,UDF55,UDF56,UDF57,UDF58,UDF59,UDF60,UDF61,UDF62 )

select 'comfortwx','DS','','','','',1,
MOCTA.TA021,CSTTA.TA002+'01',CSTTA.TA003,CSTTA.TA004,CSTTA.TA015,0,MOCTA.TA006,'','','',0,0,0,
'','','','','','','','','','','','',
0,0,0,0,0,0,0,0,0,0,0,0 
from CSTTA CSTTA 
INNER JOIN MOCTA MOCTA ON CSTTA.TA003=MOCTA.TA001 AND CSTTA.TA004=MOCTA.TA002 
WHERE CSTTA.TA002=@NIANYUE 
 
*/



