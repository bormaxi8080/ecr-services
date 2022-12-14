--06EC11F4-EBEA-4449-B2A3-6E9ACD969B95--
IF OBJECT_ID('tempdb..#t06EC11F4EBEA4449B2A36E9ACD969B95') IS NOT NULL DROP TABLE #t06EC11F4EBEA4449B2A36E9ACD969B95
GO
CREATE TABLE #t06EC11F4EBEA4449B2A36E9ACD969B95(Err int)
GO
SET XACT_ABORT ON
GO
BEGIN TRANSACTION
GO
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE
GO
print N'????????? ? ???? [' + db_name() + N'] ?? ??????? ' + cast(serverproperty('ServerName') as nvarchar(128)) + N' ' + convert(nvarchar, getdate(), 104) + N' ? ' + convert(nvarchar, getdate(), 108) + N'.';
set nocount on;
declare
    @OldVersion nvarchar(50)
    , @NewVersion nvarchar(50)
    , @ErrMsg nvarchar(2047)
    , @Description nvarchar(255)
select
    @OldVersion = N'1.2.6.12'
    , @NewVersion = N'1.2.7.13'
    , @Description = left(N'????????? ???????? ??? ???????? ??????', 255);
print N'??????????? ?????????? ? ?????? ' + @OldVersion + N' ?? ?????? ' + @NewVersion + N' ...'
if not exists
        (
        select
            *
        from dbo.VersionHistory
        where [Version] = @OldVersion
        )
    begin
        set @ErrMsg = N'?? ??????????? ?????????? ??????????! ????????? ????????.';
        goto EndMsg;
    end
if exists
        (
        select
            *
        from dbo.VersionHistory
        where [Version] = @NewVersion
        )
    begin
        set @ErrMsg = N'?????? ?????????? ??? ????????? ?????! ????????? ????????.';
        goto EndMsg;
    end
if exists
        (
        select
            *
        from dbo.VersionHistory
        where [Version] = @OldVersion
        )
and exists
        (
        select
            *
        from dbo.VersionHistory
        where [ID] >
                    (
                    select
                        [ID]
                    from dbo.VersionHistory
                    where [Version] = @OldVersion
                    )
        )
        set @ErrMsg = N'??????? ?????? ?? ????????????? ??????????! ????????? ????????.';
EndMsg:
if @ErrMsg is not null
    raiserror(@ErrMsg, 16, 1) with log;
else
insert
    dbo.VersionHistory
        (
        [Version]
        , VersionDate
        , [Description]
        )
    values
        (
        @NewVersion
        , getdate()
        , @Description
        );
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(0) BEGIN TRANSACTION END
GO
/****** Object:  Table [ecr].[ProcessedObjects]    Script Date: 06/02/2009 18:00:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[ProcessedObjects]') AND type in (N'U'))
DROP TABLE [ecr].[ProcessedObjects]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(1) BEGIN TRANSACTION END
GO

/****** Object:  Table [ecr].[ProcessedMessages]    Script Date: 06/02/2009 18:00:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[ProcessedMessages]') AND type in (N'U'))
DROP TABLE [ecr].[ProcessedMessages]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(2) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[AddProcessedMessage]    Script Date: 06/02/2009 18:01:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[AddProcessedMessage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[AddProcessedMessage]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(3) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[AddProcessedObject]    Script Date: 06/02/2009 18:01:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[AddProcessedObject]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[AddProcessedObject]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(4) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetProcessedMessages]    Script Date: 06/02/2009 18:01:36 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetProcessedMessages]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetProcessedMessages]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(5) BEGIN TRANSACTION END
GO

/****** Object:  Table [ecr].[ProcessedMessages]    Script Date: 06/02/2009 18:02:45 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(6) BEGIN TRANSACTION END
GO
SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(7) BEGIN TRANSACTION END
GO
CREATE TABLE [ecr].[ProcessedMessages](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MessageID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ProcessedPackages_PackageID]  DEFAULT (newid()),
	[MessageNo] [int] NOT NULL,
	[MessagePackageNumber] [int] NOT NULL CONSTRAINT [DF__Processed__Messa__041093DD]  DEFAULT ((1)),
	[MessagePackageCount] [int] NOT NULL CONSTRAINT [DF__Processed__Messa__0504B816]  DEFAULT ((1)),
	[MessageOwnerID] [nvarchar](50) NOT NULL,
	[MessageOwnerType] [nvarchar](50) NOT NULL,
	[MessageCreationTime] [datetime] NOT NULL CONSTRAINT [DF_ProcessedPackages_DateCreate]  DEFAULT (getdate()),
	[MessageProcessedTime] [datetime] NULL,
	[OriginFileName] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_ProcessedPackages] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(8) BEGIN TRANSACTION END
GO

/****** Object:  Table [ecr].[ProcessedObjects]    Script Date: 06/02/2009 18:02:56 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(9) BEGIN TRANSACTION END
GO
SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(10) BEGIN TRANSACTION END
GO
SET ANSI_PADDING ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(11) BEGIN TRANSACTION END
GO
CREATE TABLE [ecr].[ProcessedObjects](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MessageID] [uniqueidentifier] NOT NULL,
	[MessagePackageNumber] [int] NOT NULL,
	[ObjectGUID] [uniqueidentifier] NOT NULL,
	[ObjectType] [nvarchar](50) NOT NULL,
	[ObjectSubType] [nvarchar](50) NOT NULL,
	[ItemType] [nvarchar](50) NOT NULL,
	[KeyType] [nvarchar](50) NOT NULL,
	[ItemKey] [nvarchar](50) NOT NULL,
	[ItemNumber] [int] NULL,
	[ItemBody] [varbinary](max) NULL,
	[Encoding] [nvarchar](20) NOT NULL CONSTRAINT [DF_ProcessedObjects_Encoding]  DEFAULT (N'base64'),
	[OriginFileName] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_ProcessedObjects] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(12) BEGIN TRANSACTION END
GO
SET ANSI_PADDING OFF
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(13) BEGIN TRANSACTION END
GO
/****** Object:  StoredProcedure [ecr].[AddProcessedMessage]    Script Date: 06/02/2009 18:02:09 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(14) BEGIN TRANSACTION END
GO
SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(15) BEGIN TRANSACTION END
GO
-- =============================================
-- Author:		MMX
-- Create date: 26.05.2009
-- Description:	????????? ????????? ?????? ? ??????? ecr.ProxcessedMessages
-- =============================================
CREATE PROCEDURE [ecr].[AddProcessedMessage] 
	-- Add the parameters for the stored procedure here
	@MessageID uniqueidentifier,
	@MessageNo int,
	@MessagePackageNumber int = 1,
	@MessagePackageCount int = 1,
	@MessageOwnerID nvarchar(50) = 'otBinaryContent.Processed',
	@MessageOwnerType nvarchar(50) = 'ECR',
	@MessageCreationTime datetime,
	@OriginFileName nvarchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into [ecr].ProcessedMessages
		(
		MessageID,
		MessageNo,
		MessagePackageNumber,
		MessagePackageCount,
		MessageOwnerID,
		MessageOwnerType,
		MessageCreationTime,
		OriginFileName
		)
	values
		(
		@MessageID,
		@MessageNo,
		@MessagePackageNumber,
		@MessagePackageCount,
		@MessageOwnerID,
		@MessageOwnerType,
		@MessageCreationTime,
		@OriginFileName
		)
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(16) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[AddProcessedObject]    Script Date: 06/02/2009 18:02:22 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(17) BEGIN TRANSACTION END
GO
SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(18) BEGIN TRANSACTION END
GO
-- =============================================
-- Author:		MMX
-- Create date: 28.05.2009
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[AddProcessedObject]
	-- Add the parameters for the stored procedure here
	@MessageID uniqueidentifier,
	@MessagePackageNumber int,
	@ObjectGUID uniqueidentifier,
	@ObjectType nvarchar(50),
	@ObjectSubType nvarchar(50),
	@ItemType nvarchar(50),
	@KeyType nvarchar(50),
	@ItemKey nvarchar(50),
	@ItemNumber int = null,
	@ItemBody Image = null,
	@Encoding nvarchar(20) = 'base64',
	@OriginFileName nvarchar(255)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into ecr.ProcessedObjects
		(
		MessageID,
		MessagePackageNumber,
		ObjectGUID,
		ObjectType,
		ObjectSubType,
		ItemType,
		KeyType,
		ItemKey,
		ItemNumber,
		ItemBody,
		Encoding,
		OriginFileName
		)
	values
		(
		@MessageID,
		@MessagePackageNumber,
		@ObjectGUID,
		@ObjectType,
		@ObjectSubType,
		@ItemType,
		@KeyType,
		@ItemKey,
		@ItemNumber,
		@ItemBody,
		@Encoding,
		@OriginFileName
		)
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(19) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetProcessedMessages]    Script Date: 06/02/2009 18:01:47 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(20) BEGIN TRANSACTION END
GO
SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(21) BEGIN TRANSACTION END
GO
-- =============================================
-- Author:		MMX
-- Create date: 26.05.2009
-- Description:	????????? ?????????? ???????? ????? ?????????????? ??????? ?? ??????? ecr.ProcessedMessages
-- =============================================
CREATE PROCEDURE [ecr].[GetProcessedMessages] 
	-- Add the parameters for the stored procedure here
	@Count int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select top (@Count)
			ID,
			MessageID,
			MessageNo,
			MessagePackageNumber,
			MessagePackageCount,
			MessageOwnerID,
			MessageOwnerType,
			MessageCreationTime,
			MessageProcessedTime,
			OriginFileName
	from [ecr].ProcessedMessages
	where MessageProcessedTime is null
	order by MessageNo asc

END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(22) BEGIN TRANSACTION END
GO


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(23) BEGIN TRANSACTION END
GO
IF EXISTS(SELECT * FROM #t06EC11F4EBEA4449B2A36E9ACD969B95) BEGIN select * from #t06EC11F4EBEA4449B2A36E9ACD969B95 ROLLBACK TRANSACTION END
GO
IF @@TRANCOUNT>0 BEGIN
PRINT 'The database update succeeded!'
COMMIT TRANSACTION
END
ELSE PRINT 'The database update failed!'
GO
DROP TABLE #t06EC11F4EBEA4449B2A36E9ACD969B95
GO