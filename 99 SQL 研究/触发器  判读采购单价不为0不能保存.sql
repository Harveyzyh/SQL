USE [DEMO_LSBE]
GO
/****** Object:  Trigger [dbo].[MOCTI001]    Script Date: 10/24/2016 15:30:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*实现采购单价不为0的提醒  仅仅适用于建档作业录入会提示，批次作业仅RollBack*/
CREATE TRIGGER [dbo].[PURTD001] ON [dbo].[PURTD]
FOR INSERT,UPDATE
AS 
BEGIN 
SET NOCOUNT ON 
  IF EXISTS(SELECT * from inserted as a
WHERE TD010 = '0') 
     BEGIN 
       RAISERROR('采购单价为0,保存失败',16,1)
       ROLLBACK TRAN
     END
	 SET NOCOUNT OFF
END
