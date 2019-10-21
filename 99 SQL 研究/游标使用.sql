begin
    declare @a int,@error int    
    declare @temp varchar(50)
    set @a=1
    set @error=0
    --申明游标为Uid
    declare order_cursor cursor 
    for (select [Uid] from Student)
    --打开游标--
    open order_cursor
    --开始循环游标变量--
    fetch next from order_cursor into @temp
    while @@FETCH_STATUS = 0    --返回被 FETCH语句执行的最后游标的状态--
        begin            
            update Student set Age=15+@a,demo=@a where Uid=@temp
            set @a=@a+1
            set @error= @error + @@ERROR   --记录每次运行sql后是否正确，0正确
            fetch next from order_cursor into @temp   --转到下一个游标，没有会死循环
        end    
    close order_cursor  --关闭游标
    deallocate order_cursor   --释放游标
end
go








-- <R1 ID="DS" Name="Sys Admin" Type="1" Msg="YNN"/><R2 ID="001114" Name="钟耀辉" Type="1" Msg="YNN"/>

DECLARE @ROW INT
DECLARE @ERPID VARCHAR(20), @ERPNAME VARCHAR(50), @ERPDPT VARCHAR(20)
DECLARE @INF VARCHAR(200)

SET @ROW = 0
SET @INF = ''

DECLARE ORDER_CURSOR CURSOR
FOR( SELECT ERPID, ERPDPT FROM ATEST.dbo.ERPMSG )
OPEN ORDER_CURSOR
FETCH NEXT FROM ORDER_CURSOR INTO @ERPID, @ERPDPT
WHILE @@FETCH_STATUS = 0
BEGIN 
	SET @ROW += 1
	SELECT @ERPNAME = RTRIM(MA002) FROM DSCSYS.dbo.DSCMA WHERE MA001 = @ERPID
	SET @INF += '<R' + CONVERT(VARCHAR(20), @ROW) + ' ID="' + @ERPID + '" Name="' + @ERPNAME + '" Type="1" Msg="YNN"/>' + @ERPDPT
	FETCH NEXT FROM ORDER_CURSOR INTO @ERPID, @ERPDPT
END
CLOSE ORDER_CURSOR
DEALLOCATE ORDER_CURSOR

SELECT @INF AS A

