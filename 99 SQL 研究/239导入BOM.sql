USE [Comfortseating]
GO
/****** Object:  StoredProcedure [dbo].[P_IMPBOMFROM99COMFORT_AUTO]    Script Date: 2019/7/19 14:08:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[P_IMPBOMFROM99COMFORT_AUTO]
--功能：将99数据库的导入到系统中
--
AS
BEGIN
declare @sql varchar(300);
declare @date varchar(20)
declare @remoteid varchar(50)
declare @error varchar(300)

set @date=convert(varchar(20),getdate(),112)
set @remoteid='[192.168.0.99].[COMFORT]';

Declare @intErrorCode int
Select @intErrorCode=@@Error

Begin transaction

begin try 
--step1 备份数据表
	IF EXISTS(SELECT * FROM  sys.objects WHERE name ='INVMB_'+@date+'')
	begin
	   set @sql='drop table INVMB_'+@date
	   EXECUTE (@sql)
	   insert into IMP_LOG VALUES(getdate(),@sql)
	end
	IF EXISTS(SELECT * FROM  sys.objects WHERE name ='BOMCA_'+@date+'')
	begin
	   set @sql='drop table BOMCA_'+@date
	   EXECUTE (@sql)
	   insert into IMP_LOG VALUES(getdate(),@sql)
	end

	IF EXISTS(SELECT * FROM  sys.objects WHERE name ='BOMCB_'+@date+'')
	begin
	   set @sql='drop table BOMCB_'+@date
	   EXECUTE (@sql)
	   insert into IMP_LOG VALUES(getdate(),@sql)
	end

	IF EXISTS(SELECT * FROM  sys.objects WHERE name ='BOMMC_'+@date+'')
	begin
	   set @sql='drop table BOMMC_'+@date
	   EXECUTE (@sql)
	   insert into IMP_LOG VALUES(getdate(),@sql)
	end

	IF EXISTS(SELECT * FROM  sys.objects WHERE name ='BOMMD_'+@date+'')
	begin
	   set @sql='drop table  BOMMD_'+@date
	   EXECUTE (@sql)
	   insert into IMP_LOG VALUES(getdate(),@sql)
	end

	IF EXISTS(SELECT * FROM  sys.objects WHERE name ='INVMB_TMP'+@date+'')
	begin
	   set @sql='drop table  INVMB_TMP'+@date
	   EXECUTE (@sql)
	   insert into IMP_LOG VALUES(getdate(),@sql)
	end



	set @sql='select * INTO INVMB_'+@date+' from INVMB'
	EXECUTE (@sql)
	insert into IMP_LOG VALUES(getdate(),@sql)

	set @sql='select * INTO BOMCA_'+@date+' from BOMCA'
	EXECUTE (@sql)
	insert into IMP_LOG VALUES(getdate(),@sql)


	set @sql='select * INTO BOMCB_'+@date+' from BOMCB'
	EXECUTE (@sql)
	insert into IMP_LOG VALUES(getdate(),@sql)


	set @sql='select * INTO BOMMC_'+@date+' from BOMMC'
	EXECUTE (@sql)
	insert into IMP_LOG VALUES(getdate(),@sql)


	set @sql='select * INTO  BOMMD_'+@date+' from  BOMMD'
	EXECUTE (@sql)
	insert into IMP_LOG VALUES(getdate(),@sql)


	--step 2删除原来BOM表的数据
	set @sql='delete from BOMCA'
	EXECUTE (@sql)
	insert into IMP_LOG VALUES(getdate(),@sql)

	set @sql='delete from BOMCB'
	EXECUTE (@sql)
	insert into IMP_LOG VALUES(getdate(),@sql)

	set @sql='delete from BOMMC'
	EXECUTE (@sql)
	insert into IMP_LOG VALUES(getdate(),@sql)

	set @sql='delete from BOMMD'
	EXECUTE (@sql)
	insert into IMP_LOG VALUES(getdate(),@sql)




	--step 3把99数据库的数据导入到239中
	set @sql='select * into INVMB_TMP'+@date+' from '+@remoteid+'.[dbo].[INVMB]'
	EXECUTE (@sql)
	insert into IMP_LOG VALUES(getdate(),@sql)

	set @sql='alter table INVMB_TMP'+@date+' drop column MB200'
	EXECUTE (@sql)
	insert into IMP_LOG VALUES(getdate(),@sql)

	set @sql='insert into INVMB select * from INVMB_TMP'+@date+' A where not exists(select 1 from INVMB B where B.MB001=A.MB001)'
	EXECUTE (@sql)
	insert into IMP_LOG VALUES(getdate(),@sql)


	set @sql='insert into BOMCA select * from '+@remoteid+'.[dbo].[BOMCA]'
	EXECUTE (@sql)
	insert into IMP_LOG VALUES(getdate(),@sql)

	set @sql='insert into BOMCB select * from '+@remoteid+'.[dbo].[BOMCB]'
	EXECUTE (@sql)
	insert into IMP_LOG VALUES(getdate(),@sql)

	set @sql='insert into BOMMC select * from '+@remoteid+'.[dbo].[BOMMC]'
	EXECUTE (@sql)
	insert into IMP_LOG VALUES(getdate(),@sql)

	set @sql='insert into BOMMD select * from '+@remoteid+'.[dbo].[BOMMD]'
	EXECUTE (@sql)
	insert into IMP_LOG VALUES(getdate(),@sql)


	--step 4,把合同类型的数据导入到239中
	set @sql='insert into BOMCA select * from BOMCA_'+@date+' where CA003 LIKE ''6%'' or CA003 LIKE ''%a%''  or CA003 LIKE ''%c%'' '
	EXECUTE (@sql)
	insert into IMP_LOG VALUES(getdate(),@sql)

	set @sql='insert into BOMCB select * from BOMCB_'+@date+'  WHERE CB001 LIKE ''6%'' or CB001 LIKE ''%a%''  or CB001 LIKE ''%c%'' '
	EXECUTE (@sql)
	insert into IMP_LOG VALUES(getdate(),@sql)

	set @sql='insert into BOMMC select * from BOMMC_'+@date+'  WHERE MC001 LIKE ''6%'' or MC001 LIKE ''%a%''  or MC001 LIKE ''%c%'' '
	EXECUTE (@sql)
	insert into IMP_LOG VALUES(getdate(),@sql)

	set @sql='insert into BOMMD select * from  BOMMD_'+@date+'  where MD001 LIKE ''6%'' or MD001 LIKE ''%a%''  or MD001 LIKE ''%c%'' '
	EXECUTE (@sql)
	insert into IMP_LOG VALUES(getdate(),@sql)


	set @sql='UPDATE INVMB SET MB442=''5'',MB064=''0'',MB065=''0'',MB089=''0'',MB022=''T'',MB017=''LY050'',MB034=''L'',MB042=''1'' FROM INVMB WHERE MB442=''4'' '
	EXECUTE (@sql)
	insert into IMP_LOG VALUES(getdate(),@sql)

end try

begin catch
   set @error=cast(@@ERROR as varchar)+SUBSTRING(ERROR_MESSAGE(),0,250)
    insert into IMP_LOG VALUES(getdate(),@error)

	set @intErrorCode=@intErrorCode+1
--辅助信息 
--select ERROR_LINE() as Line, 
-- ERROR_MESSAGE() as message1, 
-- ERROR_NUMBER() as number, 
-- ERROR_PROCEDURE() as proc1, 
-- ERROR_SEVERITY() as severity, 
-- ERROR_STATE() as state1 
end catch


if @intErrorCode=0 
   commit transaction
else
   rollback transaction

END
