--消息平台研究
--消息平台数据表

--ADMTC未发送的
--ADMTD发送人的
--ADMTE接收人的
--DMS 文件消息索引  索引目录（服务器C盘doclibrary）

/*
--001 编号
--002 发送人账号
--003 收件人信息
--004 时间long
--005 'N'  阅读码 F未阅读 T已阅读
--006 主题
--007 内容（右下角小窗口显示，部分内容）
--008 内容的详细
--009 '0'
--010 ''
--011 ''
--012 NULL
--013 ''
--014 ''
--015 ''
--016 '<?xml version="1.0" encoding="GB2312"?><Root><Dispatching Enable="False"/></Root>'
--017 附件信息，位置，对应DMS表
	无附件时 '<?xml version="1.0" encoding="GB2312"?><Attachments/>'
	有附件时 ''
--
*/
-- USE DSCSYS

--待发送列表
SELECT *
--DELETE
FROM DSCSYS.dbo.ADMTC
WHERE 1=1
AND TC001 = '20190725000029'
ORDER BY CREATE_DATE


INSERT INTO DSCSYS.dbo.ADMTC (COMPANY, CREATOR, USR_GROUP, CREATE_DATE, FLAG, TC001, TC002, TC003, TC004, TC005, TC006, TC007, TC008, TC009, TC010, TC011, TC012, TC013, TC014, TC015, TC016, TC017)
VALUES('COMFORT', 'DS', 'DS', '20181229160107873', 1, '20181230000010', 'DS', '<?xml version="1.0" encoding="GB2312"?><Root><R1 ID="001114" Name="Sys Admin" Type="1" Msg="YNN"/><R2 ID="DS" Name="Sys Admin" Type="1" Msg="YNN"/></Root>', 
			'20181229160107903', 'N', '456', 'TEST', '<P>654</P><P>4567890</P>', '0', '', '', NULL, '0', '0', '0', '<?xml version="1.0" encoding="GB2312"?><Root><Dispatching Enable="False"/></Root>', '<?xml version="1.0" encoding="GB2312"?><Attachments/>')



-- 接受人列表
SELECT TE001
-- DELETE
FROM DSCSYS.dbo.ADMTE
WHERE 1=1
-- ORDER BY CREATE_DATE
-- AND TE001 = '20180901000100'
AND TE003 = '001212'
-- AND TE002 != '001114'
ORDER BY TE001

-- 发送人列表
SELECT TD001
-- DELETE
FROM DSCSYS.dbo.ADMTD
WHERE 1=1
-- AND TD001 < '20191030000005'
AND TD002 = '001212'
ORDER BY TD001
