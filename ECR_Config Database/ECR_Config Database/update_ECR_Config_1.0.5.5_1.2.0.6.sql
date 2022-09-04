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
USE [ECR_Config]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(1) BEGIN TRANSACTION END
GO

set nocount on
declare @Version nvarchar(50), @SQL varchar(1000)
set @Version = '1.2.0.6'
if not exists(select * from dbo.VersionHistory where [Version] = @Version) begin
	insert into dbo.VersionHistory ([Version], VersionDate, [Description])
	select @Version, getdate(), N'Добавление таблицы ecr.SourceCatalogs, хранимых процедур работы с объектами SourceCatalogs.'
end else begin
	set @SQL = 'Обновление ' + @Version + ' уже ранее применено...' 
	raiserror(@SQL, 25, 1) with log
end
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(2) BEGIN TRANSACTION END
GO

/****** Object:  Table [ecr].[SourceCatalogs]    Script Date: 03/12/2009 14:33:33 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(3) BEGIN TRANSACTION END
GO
SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(4) BEGIN TRANSACTION END
GO
CREATE TABLE [ecr].[SourceCatalogs](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[CatalogID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ecr_SourceCatalogs_CatalogID]  DEFAULT (newid()),
	[SystemName] [nvarchar](50) NOT NULL,
	[InstanceName] [nvarchar](50) NULL,
	[BindingType] [nvarchar](50) NOT NULL,
	[Description] [nvarchar](255) NULL,
	[Disabled] [bit] NOT NULL CONSTRAINT [DF_ecr_SourceCatalogs_Disabled]  DEFAULT ((1)),
	[Priority] [int] NOT NULL CONSTRAINT [DF_ecr_SourceCatalogs_Priority]  DEFAULT ((0)),
	[RemoteServerName] [nvarchar](50) NULL,
	[ConnectionString] [nvarchar](1024) NOT NULL,
 CONSTRAINT [PK_ecr_SourceCatalogs] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(5) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[DeleteSourceCatalog]    Script Date: 03/12/2009 14:35:19 ******/
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
-- =============================================
-- Author:		MX
-- Create date: 07.02.2008
-- Description:	удаление записи об объекте типа SourceCatalog из таблицы ecr.SourceCatalogs
-- =============================================
CREATE PROCEDURE [ecr].[DeleteSourceCatalog] 
	-- Add the parameters for the stored procedure here
	@SystemName nvarchar(50),
	@InstanceName nvarchar(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	if(@InstanceName IS NULL) begin
		DELETE FROM [ecr].[SourceCatalogs] WHERE SystemName = @SystemName
	end
	else begin
		DELETE FROM [ecr].[SourceCatalogs] WHERE SystemName = @SystemName AND InstanceName = @InstanceName
	end

END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(8) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetSourceCatalog]    Script Date: 03/12/2009 14:35:20 ******/
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
-- =============================================
-- Author:		MX
-- Create date: 07.02.2008
-- Description:	получение записи об объекте SourceCatalog из таблицы ecr.SourceCatalogs
-- =============================================
CREATE PROCEDURE [ecr].[GetSourceCatalog] 
	-- Add the parameters for the stored procedure here
	@SystemName nvarchar(50),
	@InstanceName nvarchar(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	declare @ErrMsg nvarchar(4000)
	declare @_count int

	if(@InstanceName IS NULL) begin
		SELECT * FROM [ecr].[SourceCatalogs] WHERE SystemName = @SystemName	
	end
	else begin
		SELECT * FROM [ecr].[SourceCatalogs] WHERE SystemName = @SystemName AND InstanceName = @InstanceName
	end

	SET @_count = @@rowcount

	if (@_count=0) begin
		set @ErrMsg = N'The specified catalog instance does not exists in databese reference';
		raiserror(@ErrMsg, 16, 1);
		return;
	end
	else if (@_count>1) begin
		set @ErrMsg = N'The specified catalog instance duplicated or data corrupted ';
		raiserror(@ErrMsg, 16, 1);
		return;
	end

END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(11) BEGIN TRANSACTION END
GO

insert into [ecr].[SourceCatalogs] (CatalogID, SystemName, InstanceName, BindingType, Description, Disabled, Priority, RemoteServerName, ConnectionString)
	values ('2dc9a0a2-0c6c-44a3-9e88-af294ee7070c', 'Web.Catalog1', 'Catalog1', 'catalog.web.1',	'Каталог web - экземпляр 1', 0,	0, NULL, 'Data Source=WEB\SQL2000;Initial Catalog=Catalog;Integrated Security=True;Connection Timeout=19200')
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(12) BEGIN TRANSACTION END
GO


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(13) BEGIN TRANSACTION END
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