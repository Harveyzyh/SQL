USE [DEMO_LSBE]
GO
/****** Object:  Trigger [dbo].[MOCTI001]    Script Date: 10/24/2016 15:30:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*ʵ�ֲɹ����۲�Ϊ0������  ���������ڽ�����ҵ¼�����ʾ��������ҵ��RollBack*/
CREATE TRIGGER [dbo].[PURTD001] ON [dbo].[PURTD]
FOR INSERT,UPDATE
AS 
BEGIN 
SET NOCOUNT ON 
  IF EXISTS(SELECT * from inserted as a
WHERE TD010 = '0') 
     BEGIN 
       RAISERROR('�ɹ�����Ϊ0,����ʧ��',16,1)
       ROLLBACK TRAN
     END
	 SET NOCOUNT OFF
END
