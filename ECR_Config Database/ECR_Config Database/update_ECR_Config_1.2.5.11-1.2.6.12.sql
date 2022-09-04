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
print N'Выполение в базе [' + db_name() + N'] на сервере ' + cast(serverproperty('ServerName') as nvarchar(128)) + N' ' + convert(nvarchar, getdate(), 104) + N' в ' + convert(nvarchar, getdate(), 108) + N'.';
set nocount on;
declare
    @OldVersion nvarchar(50)
    , @NewVersion nvarchar(50)
    , @ErrMsg nvarchar(2047)
    , @Description nvarchar(255)
select
    @OldVersion = N'1.2.5.11'
    , @NewVersion = N'1.2.6.12'
    , @Description = left(N'Обновление хранимых процедур и таблиц для работы с входящими пакетами', 255);
print N'Выполняется обновление с версии ' + @OldVersion + N' на версию ' + @NewVersion + N' ...'
if not exists
        (
        select
            *
        from dbo.VersionHistory
        where [Version] = @OldVersion
        )
    begin
        set @ErrMsg = N'Не установлено предыдущее обновление! Изменения отменены.';
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
        set @ErrMsg = N'Данное обновление уже применено ранее! Изменения отменены.';
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
        set @ErrMsg = N'Текущая версия не соответствует заменяемой! Изменения отменены.';
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
/****** Object:  Table [ecr].[ProcessedMessages]    Script Date: 05/28/2009 10:53:14 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[ProcessedMessages]') AND type in (N'U'))
DROP TABLE [ecr].[ProcessedMessages]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(1) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[AddProcessedMessage]    Script Date: 05/28/2009 10:55:53 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[AddProcessedMessage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[AddProcessedMessage]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(2) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetProcessedMessages]    Script Date: 05/28/2009 10:56:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetProcessedMessages]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetProcessedMessages]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(3) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[MarkProcessedMessage]    Script Date: 05/28/2009 10:56:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[MarkProcessedMessage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[MarkProcessedMessage]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(4) BEGIN TRANSACTION END
GO

/****** Object:  Table [ecr].[ProcessedMessages]    Script Date: 05/28/2009 10:55:34 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(5) BEGIN TRANSACTION END
GO
SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(6) BEGIN TRANSACTION END
GO
CREATE TABLE [ecr].[ProcessedMessages](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MessageID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ProcessedPackages_PackageID]  DEFAULT (newid()),
	[MessageNo] [int] NOT NULL,
	[MessagePackageNumber] [int] NOT NULL DEFAULT (1),
	[MessagePackageCount] [int] NOT NULL DEFAULT (1),
	[MessageOwnerID] [nvarchar](50) NOT NULL,
	[MessageOwnerType] [nvarchar](50) NOT NULL,
	[MessageCreationTime] [datetime] NOT NULL CONSTRAINT [DF_ProcessedPackages_DateCreate]  DEFAULT (getdate()),
	[MessageProcessedTime] [datetime] NULL,
 CONSTRAINT [PK_ProcessedPackages] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(7) BEGIN TRANSACTION END
GO

/****** Object:  Table [ecr].[ProcessedObjects]    Script Date: 05/28/2009 13:09:03 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(8) BEGIN TRANSACTION END
GO
SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(9) BEGIN TRANSACTION END
GO
CREATE TABLE [ecr].[ProcessedObjects](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[MessageID] [uniqueidentifier] NOT NULL,
	[MessagePackageNumber] [int] NOT NULL,
	[ObjectGUID] [uniqueidentifier] NOT NULL,
	[ObjectType] [nvarchar](50) NOT NULL,
	[ObjectSubType] [nvarchar](50) NOT NULL,
	[Identity] [nvarchar](50) NOT NULL,
	[KeyType] [nvarchar](50) NOT NULL,
	[ItemKey] [nvarchar](50) NOT NULL,
	[ItemNumber] [int] NULL,
	[ArhiveFileName] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_ProcessedObjects] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(10) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[AddProcessedMessage]    Script Date: 05/28/2009 10:56:45 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(11) BEGIN TRANSACTION END
GO
SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(12) BEGIN TRANSACTION END
GO
-- =============================================
-- Author:		MMX
-- Create date: 26.05.2009
-- Description:	Процедура добавляет запись в таблицу ecr.ProxcessedMessages
-- =============================================
CREATE PROCEDURE [ecr].[AddProcessedMessage] 
	-- Add the parameters for the stored procedure here
	@MessageID uniqueidentifier,
	@MessageNo int,
	@MessageCreationTime datetime,
	@MessagePackageNumber int = 1,
	@MessagePackageCount int = 1
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
		MessageOwnerID,
		MessageOwnerType,
		MessageCreationTime,
		MessageProcessedTime
		)
	values
		(
		@MessageID,
		@MessageNo,
		'otBinaryContent.Processed',
		'ECR',
		@MessageCreationTime,
		null
		) 

END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(13) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[AddProcessedObject]    Script Date: 05/28/2009 13:28:32 ******/
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
	@Identity nvarchar(50),
	@KeyType nvarchar(50),
	@ItemKey nvarchar(50),
	@ItemNumber int = null,
	@ArchiveFileName nvarchar(255)
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
		[Identity],
		KeyType,
		ItemKey,
		ItemNumber,
		ArhiveFileName
		)
	values
		(
		@MessageID,
		@MessagePackageNumber,
		@ObjectGUID,
		@ObjectType,
		@ObjectSubType,
		@Identity,
		@KeyType,
		@ItemKey,
		@ItemNumber,
		@ArchiveFileName
		)
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(16) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetProcessedMessages]    Script Date: 05/28/2009 10:57:08 ******/
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
-- Create date: 26.05.2009
-- Description:	Процедура возвращает заданное число необработанных записей из таблицы ecr.ProcessedMessages
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
			MessageProcessedTime
	from [ecr].ProcessedMessages
	where MessageProcessedTime is null
	order by MessageNo asc

END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(19) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[MarkProcessedMessage]    Script Date: 05/28/2009 10:57:21 ******/
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
-- Description:	Процедура ставит временную метку DateProcessed для заданной записи из таблицы ecr.ProcessedMessages
-- =============================================
CREATE PROCEDURE [ecr].[MarkProcessedMessage] 
	-- Add the parameters for the stored procedure here
	@MessageID uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	update [ecr].ProcessedMessages
	set MessageProcessedTime = getdate()
	where MessageID = @MessageID

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