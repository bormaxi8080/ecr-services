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
    @OldVersion = N'1.2.7.13'
    , @NewVersion = N'1.2.8.14'
    , @Description = left(N'Обновление объектов для работы с входящими пакетами, объектов для генерации отчетов в ЕБК', 255);
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
PRINT N'Dropping stored procedure [ecr].[AddProcessedObject]'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(1) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[AddProcessedObject]    Script Date: 06/04/2009 14:22:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[AddProcessedObject]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[AddProcessedObject]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(2) BEGIN TRANSACTION END
GO

PRINT N'Dropping table [ecr].[ProcessedObjects]'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(3) BEGIN TRANSACTION END
GO

/****** Object:  Table [ecr].[ProcessedObjects]    Script Date: 06/04/2009 14:22:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[ProcessedObjects]') AND type in (N'U'))
DROP TABLE [ecr].[ProcessedObjects]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(4) BEGIN TRANSACTION END
GO

PRINT N'Updating table [ecr].[ProcessedMessages]'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(5) BEGIN TRANSACTION END
GO

/****** Object:  Table [ecr].[ProcessedMessages]    Script Date: 06/04/2009 14:29:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[ProcessedMessages]') AND type in (N'U'))
DROP TABLE [ecr].[ProcessedMessages]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(6) BEGIN TRANSACTION END
GO

/****** Object:  Table [ecr].[ProcessedMessages]    Script Date: 06/04/2009 14:32:52 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(7) BEGIN TRANSACTION END
GO
SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(8) BEGIN TRANSACTION END
GO
SET ANSI_PADDING ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(9) BEGIN TRANSACTION END
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
	[MessageBody] [varbinary](max) NULL,
	[OriginFileName] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_ProcessedPackages] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(10) BEGIN TRANSACTION END
GO
SET ANSI_PADDING OFF
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(11) BEGIN TRANSACTION END
GO

PRINT N'Updating stored procedure [ecr].[GetProcessedMessages]'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(12) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetProcessedMessages]    Script Date: 06/04/2009 14:24:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetProcessedMessages]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetProcessedMessages]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(13) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetProcessedMessages]    Script Date: 06/04/2009 14:38:16 ******/
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
-- Description:	Процедура возвращает заданное число необработанных записей из таблицы ecr.ProcessedMessages
-- =============================================
CREATE PROCEDURE [ecr].[GetProcessedMessages] 
	-- Add the parameters for the stored procedure here
	@Count int = 5
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
			MessageBody,
			OriginFileName
	from [ecr].ProcessedMessages
	where MessageProcessedTime is null
	order by MessageNo asc

END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(16) BEGIN TRANSACTION END
GO

PRINT N'Updating stored procedure [ecr].[AddProcessedMessage]'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(17) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[AddProcessedMessage]    Script Date: 06/04/2009 14:25:48 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[AddProcessedMessage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[AddProcessedMessage]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(18) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[AddProcessedMessage]    Script Date: 06/04/2009 14:36:22 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(19) BEGIN TRANSACTION END
GO
SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(20) BEGIN TRANSACTION END
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
	@MessagePackageNumber int = 1,
	@MessagePackageCount int = 1,
	@MessageOwnerID nvarchar(50) = 'otBinaryContent.Processed',
	@MessageOwnerType nvarchar(50) = 'ECR',
	@MessageCreationTime datetime,
	@MessageBody image,
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
		MessageBody,
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
		@MessageBody,
		@OriginFileName
		)
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(21) BEGIN TRANSACTION END
GO

PRINT N'Updating stored procedure [ecr].[MarkProcessedMessage]'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(22) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[MarkProcessedMessage]    Script Date: 06/04/2009 14:39:35 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[MarkProcessedMessage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[MarkProcessedMessage]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(23) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[MarkProcessedMessage]    Script Date: 06/04/2009 14:39:59 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(24) BEGIN TRANSACTION END
GO
SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(25) BEGIN TRANSACTION END
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
	set
		MessageProcessedTime = getdate(),
		MessageBody = null
	where MessageID = @MessageID

END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(26) BEGIN TRANSACTION END
GO

---------------------------------------------------------------------------------------------------

PRINT N'Creating [ecr].[FileContentReportByRegion_Goods]'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(27) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		Горбачев А.В.
-- Create date: 04.06.2009
-- Description:	Возвращает отчет по файловому контенту
--				по коду региона и временному периоду
-- =============================================
CREATE PROCEDURE [ecr].[FileContentReportByRegion_Goods]
	 @RegionCode varchar(10) -- код региона
	,@StartDate datetime -- начальная дата
	,@EndDate datetime -- конечная дата
AS
BEGIN
	if object_id('ecr.FileContentReportBuffTable_Goods') is not NULL
		drop table ecr.FileContentReportBuffTable_Goods
	
	select 
	   cl.Date
	  ,gg.WareKey
	  ,st.StatusName
	  ,ru.Name FileContentResponsibilityUserName
	  ,convert(int, 0) as BooksCoversFace
	  ,convert(int, 0) as BooksAnnots
	  ,convert(int, 0) as BooksContents
	  ,gg.CardStatusId
	into
	  ecr.FileContentReportBuffTable_Goods
	from 
	  BKKM.Goods.Goods gg 
	  left join BKKM.Rights.Users ru
		on gg.FileContentResponsibility = ru.ID
	  join BKKM.Refers.WareCardStatuses st 
		on st.Id = gg.CardStatusId and 
		   st.StatusName='DONE'
	  left join BKKM.Goods.ChangesLog cl
		on gg.ID = cl.GoodID and 
		   cl.FieldID = BKKM.Metadata.GetFieldID('Goods', 'CardStatus') and
		   cl.NewValue = 'DONE'
	  left join BKKM.Rights.Departments rd
				on ru.DepartmentID = rd.ID
	where 
	  (rd.Code = @RegionCode)and
	  (cl.Date <= @StartDate)and
	  (cl.Date > @EndDate)


	exec ecr.UpdateContentCountByType
		 @contentType = 'Books.Covers.Face'
		,@fieldName = 'BooksCoversFace'
		,@buffTableName = 'ecr.FileContentReportBuffTable_Goods'
	 
	exec ecr.UpdateContentCountByType
		 @contentType = 'Books.Annots'
		,@fieldName = 'BooksAnnots'
		,@buffTableName = 'ecr.FileContentReportBuffTable_Goods'

	exec ecr.UpdateContentCountByType
		 @contentType = 'Books.Contents'
		,@fieldName = 'BooksContents'
		,@buffTableName = 'ecr.FileContentReportBuffTable_Goods'

END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(28) BEGIN TRANSACTION END
GO

PRINT N'Altering [ecr].[UpdateContentCountByType]'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(29) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		Горбачев Александр
-- Create date: 22 мая 2009
-- Description:	Процедура обновляет указанное поле 
--		временной таблицы #warekeys, проставляя 
-- 		количество загруженных файлов в соответствии
--		с указынным типом контента
--   @contentType nvarchar(100) - тип контента
--	 @buffTableName nvarchar(100) - имя буфферной таблицы
--	 @fieldName nvarchar(100) - имя поля в буфферной таблице
-- =============================================
ALTER PROCEDURE [ecr].[UpdateContentCountByType]
     @contentType nvarchar(100)
	,@fieldName nvarchar(100)
	,@buffTableName nvarchar(100)
AS
BEGIN
	set nocount on

	declare
	   @DataBase nvarchar(100)
	  ,@ServerName nvarchar(100)
	  ,@index int
	  ,@str nvarchar(max)
	  ,@DisplayAlias int
	  ,@redCode nvarchar(max)
	  ,@Result int

	select 
	   @str = stg.ConnectionString
	  ,@DisplayAlias = ent.DisplayAlias
	from
	  ECR_Config.ecr.Entities ent join ECR_Config.ecr.Storages stg
		on ent.StorageID = stg.ID
	where
	  ent.SystemName = @contentType

	set @index = charindex('Initial Catalog=', @str)
	set @DataBase = stuff(@str, 1, @index + 15, '')
	set @index = charindex(';', @DataBase)
	set @DataBase = left(@DataBase, @index - 1)

	set @index = charindex('Data Source=', @str)
	set @ServerName = stuff(@str, 1, @index + 11, '')
	set @index = charindex(';', @ServerName)
	set @ServerName = left(@ServerName, @index - 1)
	--set @ServerName = ''

	set @redCode = N'
	select
		 WareKey = estg.ItemKey 
		,<warekeys_fieldName> = count(distinct IsNull(estg.ItemNumber, -1))
	into
		#buff
	from 
		<ECR_Storage_DATABASENAME>.ecr.ViewsStorage/*EntitiesStorage*/ estg join <warekeys_buffTableName> w 
			on (estg.ItemKey = w.WareKey collate Cyrillic_General_CI_AS)
			and(estg.DisplayAlias = @DisplayAlias)
	group by
		estg.ItemKey

	update
		w
	set
		w.<warekeys_fieldName> = b.<warekeys_fieldName>
	from 
		#buff b	join <warekeys_buffTableName> w 
			on b.WareKey = w.WareKey collate Cyrillic_General_CI_AS
	'

	set @redCode = replace(@redCode, N'<ECR_Storage_DATABASENAME>', @DataBase)
	set @redCode = replace(@redCode, N'<ECR_Storage_SERVERNAME>.', @ServerName)
	set @redCode = replace(@redCode, N'<warekeys_fieldName>', @fieldName)
	set @redCode = replace(@redCode, N'<warekeys_buffTableName>', @buffTableName)
	
	exec sp_executesql 
	  @redCode ,
	  N'@DisplayAlias int', 
	  @DisplayAlias = @DisplayAlias
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(30) BEGIN TRANSACTION END
GO


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(31) BEGIN TRANSACTION END
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