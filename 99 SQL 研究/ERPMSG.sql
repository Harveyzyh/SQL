/*
 Navicat Premium Data Transfer

 Source Server         : 0.099
 Source Server Type    : SQL Server
 Source Server Version : 11002100
 Source Host           : 192.168.0.99:1433
 Source Catalog        : ATEST
 Source Schema         : dbo

 Target Server Type    : SQL Server
 Target Server Version : 11002100
 File Encoding         : 65001

 Date: 05/08/2019 15:48:48
*/


-- ----------------------------
-- Table structure for ERPMSG
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[ERPMSG]') AND type IN ('U'))
	DROP TABLE [dbo].[ERPMSG]
GO

CREATE TABLE [dbo].[ERPMSG] (
  [ERPID] varchar(1) COLLATE Chinese_PRC_BIN  NOT NULL,
  [ERPDPT] varchar(20) COLLATE Chinese_PRC_BIN  NOT NULL
)
GO

ALTER TABLE [dbo].[ERPMSG] SET (LOCK_ESCALATION = TABLE)
GO


-- ----------------------------
-- Primary Key structure for table ERPMSG
-- ----------------------------
ALTER TABLE [dbo].[ERPMSG] ADD CONSTRAINT [PK__ERPMSG__CD05427AF38F2BCB] PRIMARY KEY CLUSTERED ([ERPID])
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)  
ON [PRIMARY]
GO

