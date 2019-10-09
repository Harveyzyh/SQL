/*
 Navicat Premium Data Transfer

 Source Server         : 0.197
 Source Server Type    : SQL Server
 Source Server Version : 11002100
 Source Host           : 192.168.0.197:1433
 Source Catalog        : ATEST
 Source Schema         : dbo

 Target Server Type    : SQL Server
 Target Server Version : 11002100
 File Encoding         : 65001

 Date: 08/08/2019 16:46:55
*/


-- ----------------------------
-- Table structure for ERPMSG
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[ERPMSG]') AND type IN ('U'))
	DROP TABLE [dbo].[ERPMSG]
GO

CREATE TABLE [dbo].[ERPMSG] (
  [ERPDPT] varchar(255) COLLATE Chinese_PRC_BIN  NOT NULL,
  [ERPID] varchar(255) COLLATE Chinese_PRC_BIN  NOT NULL,
  [ERPNAME] varchar(255) COLLATE Chinese_PRC_BIN  NULL
)
GO

ALTER TABLE [dbo].[ERPMSG] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Records of ERPMSG
-- ----------------------------
BEGIN TRANSACTION
GO

INSERT INTO [dbo].[ERPMSG]  VALUES (N'生产二部', N'001114', N'钟耀辉')
GO

INSERT INTO [dbo].[ERPMSG]  VALUES (N'生产三部', N'001114', N'钟耀辉')
GO

INSERT INTO [dbo].[ERPMSG]  VALUES (N'生产四部', N'001114', N'钟耀辉')
GO

INSERT INTO [dbo].[ERPMSG]  VALUES (N'生产五部', N'001114', N'钟耀辉')
GO

INSERT INTO [dbo].[ERPMSG]  VALUES (N'生产一部', N'001114', N'钟耀辉')
GO

COMMIT
GO


-- ----------------------------
-- Primary Key structure for table ERPMSG
-- ----------------------------
ALTER TABLE [dbo].[ERPMSG] ADD CONSTRAINT [PK__ERPMSG__99992C9C8DB5DFD9] PRIMARY KEY CLUSTERED ([ERPDPT], [ERPID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO

