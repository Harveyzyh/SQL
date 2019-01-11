/*
 Navicat Premium Data Transfer

 Source Server         : 1.061
 Source Server Type    : SQL Server
 Source Server Version : 11002100
 Source Host           : 192.168.1.61:1433
 Source Catalog        : COMFORT
 Source Schema         : dbo

 Target Server Type    : SQL Server
 Target Server Version : 11002100
 File Encoding         : 65001

 Date: 10/01/2019 12:43:37
*/


-- ----------------------------
-- Table structure for Doc2VN
-- ----------------------------
IF EXISTS (SELECT * FROM sys.all_objects WHERE object_id = OBJECT_ID(N'[dbo].[Doc2VN]') AND type IN ('U'))
	DROP TABLE [dbo].[Doc2VN]
GO

CREATE TABLE [dbo].[Doc2VN] (
  [MID] varchar(255) COLLATE Chinese_PRC_BIN  NULL,
  [MDATE] varchar(255) COLLATE Chinese_PRC_BIN  NULL,
  [IP] varchar(255) COLLATE Chinese_PRC_BIN  NULL,
  [NAME] varchar(255) COLLATE Chinese_PRC_BIN  NULL,
  [FLAG] varchar(255) COLLATE Chinese_PRC_BIN  NULL,
  [A001] varchar(255) COLLATE Chinese_PRC_BIN  NULL,
  [A002] varchar(255) COLLATE Chinese_PRC_BIN  NULL,
  [A003] varchar(255) COLLATE Chinese_PRC_BIN  NULL,
  [A004] varchar(255) COLLATE Chinese_PRC_BIN  NULL,
  [A005] varchar(255) COLLATE Chinese_PRC_BIN  NULL,
  [A006] varchar(255) COLLATE Chinese_PRC_BIN  NULL,
  [A007] varchar(255) COLLATE Chinese_PRC_BIN  NULL,
  [A008] varchar(255) COLLATE Chinese_PRC_BIN  NULL,
  [A009] varchar(255) COLLATE Chinese_PRC_BIN  NULL,
  [A010] varchar(255) COLLATE Chinese_PRC_BIN  NULL
)
GO

ALTER TABLE [dbo].[Doc2VN] SET (LOCK_ESCALATION = TABLE)
GO

