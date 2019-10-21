


SELECT  * FROM EMP 
WHERE ROWNUM <= 10
ORDER BY EMPNO 


DECLARE 
	QQ VARCHAR(8); 
	WW VARCHAR(20); 
BEGIN
	SELECT EMPNO, ENAME INTO QQ, WW FROM EMP
	WHERE ROWNUM <= 1
	ORDER BY EMPNO ;
	dbms_output.put_line(QQ||' '||WW);
END;

-- 游标while循环
DECLARE 
	QQ VARCHAR(8); 
	WW VARCHAR(20); 
	cursor cur_tmp
	is SELECT EMPNO, ENAME INTO QQ, WW FROM EMP
		WHERE ROWNUM <= 5
		ORDER BY EMPNO ; 
BEGIN
	open cur_tmp;
	fetch cur_tmp into QQ, WW;
	while cur_tmp%found loop
		dbms_output.put_line(QQ||' '||WW);
		fetch cur_tmp into QQ, WW;
	end loop;
	close cur_tmp;
END;

-- 游标for循环
DECLARE 
	QQ VARCHAR(8); 
	WW VARCHAR(20); 
BEGIN
	for for_tmp in (SELECT EMPNO, ENAME FROM EMP WHERE ROWNUM <= 5 ORDER BY EMPNO)
	loop
		dbms_output.put_line(for_tmp.EMPNO||' '||for_tmp.ENAME);
	end loop;
END;