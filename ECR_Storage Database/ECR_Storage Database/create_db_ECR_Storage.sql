/****** Object:  Schema [ecr]    Script Date: 12/24/2008 20:06:19 ******/
CREATE SCHEMA [ecr] AUTHORIZATION [dbo]
GO
/****** Object:  Table [ecr].[XmlPackages]    Script Date: 12/24/2008 20:07:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ecr].[XmlPackages](
	[ID] [int] NOT NULL,
	[PackageID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_XmlPackages_PackageID]  DEFAULT (newid()),
	[DateCreate] [datetime] NULL,
 CONSTRAINT [PK_XmlPackages_Entity] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_PackageID] UNIQUE NONCLUSTERED 
(
	[PackageID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ecr].[LastPackageNumber]    Script Date: 12/24/2008 20:06:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ecr].[LastPackageNumber](
	[PackageType] [int] NOT NULL CONSTRAINT [DF_LastPackageNumber_PackageType]  DEFAULT ((0)),
	[PackageNumber] [int] NOT NULL,
 CONSTRAINT [PK_LastPackageNumber] PRIMARY KEY CLUSTERED 
(
	[PackageType] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [ecr].[GetHistoryLifeTime]    Script Date: 12/24/2008 20:06:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 22.04.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetHistoryLifeTime] 
	@SystemName nvarchar(128)
AS
	SET NOCOUNT ON;

	if not exists
			(
			select
				*
			from ecr.Entities
			where SystemName = @SystemName
			)
		raiserror(N'Ошибка: нет данных о сущности в целевом хранилище', 10, 1);
	else
		select
			ID
			, EntityID
			, SystemName
			, DisplayName
			, DisplayAlias
			, Description
			, Comments
			, StorageID
			, HistoryLifeTime
			, IsMultiplied
			, Extensions
		from ecr.Entities
		where SystemName = @SystemName;
GO
/****** Object:  StoredProcedure [ecr].[CheckEntityExists]    Script Date: 12/24/2008 20:06:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 26.02.2008
-- Description:	Процедура проверяет наличие сущности (типа контента) с заданным системным именем;
-- =============================================
CREATE PROCEDURE [ecr].[CheckEntityExists] 
	@SystemName nvarchar(128)
	, @Exists int  = 0 output
AS
	SET NOCOUNT ON;

	if exists
			(
			select
				*
			from ecr.Entities
			where SystemName = @SystemName
			)	
		set @Exists = 1;
	else
		set @Exists = 0;
GO
/****** Object:  StoredProcedure [ecr].[CheckViewExists]    Script Date: 12/24/2008 20:06:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 26.02.2008
-- Description:	Процедура проверяет наличие представления контента с заданным системным именем;
-- =============================================
CREATE PROCEDURE [ecr].[CheckViewExists] 
	@SystemName nvarchar(128)
	, @Exists int = 0 output
AS
	SET NOCOUNT ON;

	if exists
			(
			select
				*
			from ecr.Views
			where SystemName = @SystemName
			)
			set @Exists = 1;
	else
			set @Exists = 0;
GO
/****** Object:  Table [ecr].[LogEntitiesStorage]    Script Date: 12/24/2008 20:07:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [ecr].[LogEntitiesStorage](
	[RowId] [int] IDENTITY(1,1) NOT NULL,
	[ID] [int] NOT NULL,
	[DisplayAlias] [int] NOT NULL,
	[ItemKey] [nvarchar](50) NOT NULL,
	[ItemNumber] [int] NULL,
	[ItemBody] [varbinary](max) NULL,
	[HistoryIndex] [int] NOT NULL,
	[DateLastModified] [datetime] NOT NULL,
	[OperationType] [char](1) NOT NULL CONSTRAINT [DF_LogOpEntitiesStorage_OpType]  DEFAULT ('D'),
	[OperationDate] [datetime] NOT NULL CONSTRAINT [DF_LogDelEntitiesStorage_OpDateTime]  DEFAULT (getdate()),
	[PackageID_Xml] [int] NULL,
	[DateOut_Native] [datetime] NULL,
 CONSTRAINT [PK_LogEntitiesStorage] PRIMARY KEY NONCLUSTERED 
(
	[RowId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Тип операции: D - удаление, I - вставка, U - изменение (при изменении пишется "новое" значение)' , @level0type=N'SCHEMA',@level0name=N'ecr', @level1type=N'TABLE',@level1name=N'LogEntitiesStorage', @level2type=N'COLUMN',@level2name=N'OperationType'
GO
/****** Object:  Table [ecr].[LogViewsStorage]    Script Date: 12/24/2008 20:07:11 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [ecr].[LogViewsStorage](
	[RowId] [int] IDENTITY(1,1) NOT NULL,
	[ID] [int] NOT NULL,
	[DisplayAlias] [int] NOT NULL,
	[ItemKey] [nvarchar](50) NOT NULL,
	[ItemNumber] [int] NULL,
	[ItemBody] [varbinary](max) NULL,
	[OperationType] [char](1) NOT NULL CONSTRAINT [DF_LogOpViewsStorage_OpType]  DEFAULT ('D'),
	[OperationDate] [datetime] NOT NULL CONSTRAINT [DF_LogDelViewsStorage_OpDateTime]  DEFAULT (getdate()),
	[PackageID_Xml] [int] NULL,
	[DateOut_Native] [datetime] NULL,
 CONSTRAINT [PK_LogViewsStorage] PRIMARY KEY NONCLUSTERED 
(
	[RowId] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Тип операции: D - удаление, I - вставка, U - изменение (при изменении пишется "новое" значение)' , @level0type=N'SCHEMA',@level0name=N'ecr', @level1type=N'TABLE',@level1name=N'LogViewsStorage', @level2type=N'COLUMN',@level2name=N'OperationType'
GO
/****** Object:  Table [dbo].[VersionHistory]    Script Date: 12/24/2008 20:06:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[VersionHistory](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[Version] [nvarchar](50) NOT NULL,
	[VersionDate] [datetime] NOT NULL CONSTRAINT [DF_VersionHistory_VersionDate]  DEFAULT (getdate()),
	[Description] [nvarchar](255) NULL,
 CONSTRAINT [PK_VersionHistory] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ecr].[EntitiesStorage]    Script Date: 12/24/2008 20:06:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [ecr].[EntitiesStorage](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DisplayAlias] [int] NOT NULL,
	[ItemKey] [nvarchar](50) NOT NULL,
	[ItemNumber] [int] NULL,
	[ItemBody] [varbinary](max) NULL,
	[HistoryIndex] [int] NOT NULL CONSTRAINT [DF_ecr_ContentStorage_HistoryIndex]  DEFAULT ((1)),
	[DateLastModified] [datetime] NOT NULL CONSTRAINT [DF_ecr_ContentStorage_DateLastModified]  DEFAULT (getdate()),
 CONSTRAINT [PK_ecr_ContentStorage] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_DisplayAlias_ItemKey_ItemNumber_HistoryIndex] UNIQUE NONCLUSTERED 
(
	[DisplayAlias] ASC,
	[ItemKey] ASC,
	[ItemNumber] ASC,
	[HistoryIndex] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [ecr].[ViewsStorage]    Script Date: 12/24/2008 20:07:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [ecr].[ViewsStorage](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DisplayAlias] [int] NOT NULL,
	[ItemKey] [nvarchar](50) NOT NULL,
	[ItemNumber] [int] NULL,
	[ItemBody] [varbinary](max) NULL,
 CONSTRAINT [PK_ecr_ContentViewStorage] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_DisplayAlias_ItemKey_ItemNumber] UNIQUE NONCLUSTERED 
(
	[DisplayAlias] ASC,
	[ItemKey] ASC,
	[ItemNumber] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [ecr].[Entities]    Script Date: 12/24/2008 20:06:45 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ecr].[Entities](
	[ID] [int] NOT NULL,
	[EntityID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ecr_Entities_EntityID]  DEFAULT (newid()),
	[SystemName] [nvarchar](128) NOT NULL,
	[DisplayName] [nvarchar](128) NOT NULL,
	[DisplayAlias] [int] NOT NULL,
	[Description] [nvarchar](255) NULL,
	[Comments] [nvarchar](255) NULL,
	[HistoryLifeTime] [int] NOT NULL CONSTRAINT [DF_ecr_Entities_HistoryLifeTime]  DEFAULT ((0)),
	[IsMultiplied] [bit] NOT NULL CONSTRAINT [DF_ecr_Entities_IsMultiplied]  DEFAULT ((0)),
	[Extensions] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_ecr_Entities] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_ecr_Entities] UNIQUE NONCLUSTERED 
(
	[EntityID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_ecr_Entities_1] UNIQUE NONCLUSTERED 
(
	[SystemName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_ecr_Entities_2] UNIQUE NONCLUSTERED 
(
	[DisplayAlias] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ecr].[Views]    Script Date: 12/24/2008 20:07:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ecr].[Views](
	[ID] [int] NOT NULL,
	[ViewID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ecr_Views_ViewID]  DEFAULT (newid()),
	[SystemName] [nvarchar](128) NOT NULL,
	[DisplayName] [nvarchar](128) NOT NULL,
	[DisplayAlias] [int] NOT NULL,
	[RelativeNames] [nvarchar](128) NULL,
	[Description] [nvarchar](255) NULL,
	[Comments] [nvarchar](255) NULL,
	[EntityParent] [int] NOT NULL,
	[Enabled] [bit] NOT NULL CONSTRAINT [DF_ecr_Views_Enabled]  DEFAULT ((1)),
	[Extensions] [nvarchar](255) NOT NULL,
 CONSTRAINT [PK_ecr_Views] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_ecr_Views] UNIQUE NONCLUSTERED 
(
	[ViewID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_ecr_Views_1] UNIQUE NONCLUSTERED 
(
	[SystemName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_ecr_Views_2] UNIQUE NONCLUSTERED 
(
	[DisplayAlias] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [ecr].[NextPackageID_Get]    Script Date: 12/24/2008 20:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		tpg
-- Create date: 03.09.2008
-- Description:	Процедура возвращает "следующий" номер пакета.
-- =============================================
CREATE PROCEDURE [ecr].[NextPackageID_Get]
	@PackageType int = 0
	, @PackageID int = 1 output
AS
SET NOCOUNT ON;

declare @ErrMsg nvarchar(4000)
declare @RC int

begin try

begin tran
	-- получаем следующий номер
	update
		ecr.LastPackageNumber with(updlock)
	set @PackageID = PackageNumber = PackageNumber + 1
	/*where PackageType = @PackageType*/
	;
	-- для проверки
	set @RC = @@rowcount;
	-- если номер не получен
	if @RC = 0
		begin
			-- создаем его
			insert
				ecr.LastPackageNumber
			values
				(
				@PackageType
				, 1
				);
			--  и присваеваем ему 1
			set @PackageID = 1;
		end
	-- если в таблице более 1 строки, поднимаем ошибку
	if @RC > 1
		raiserror(N'Логическая ошибка: в таблице последнего номера пакета строк более 1!', 16, 1);

commit tran

end try
	-- Обработчик ошибок:
begin catch

	-- Если транзакция открыта, то откатываем транзакцию;
	if @@trancount <> 0 rollback tran;
	
	set @ErrMsg = N'Ошибка: '
								+ char(13) + char(10)
								+ N'ErrorNumber = ' + cast(ERROR_NUMBER() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorSeverity = ' + cast(ERROR_SEVERITY() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorState = ' + cast(ERROR_STATE() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorProcedure = ' + ERROR_PROCEDURE()
								+ char(13) + char(10)
								+ N'ErrorLine = ' + cast(ERROR_LINE() as nvarchar)
								+ char(13) + char(10);
	set @ErrMsg = @ErrMsg + left(N'ErrorMessage = ' + ERROR_MESSAGE(), 4000 - len(@ErrMsg));
	
	raiserror(@ErrMsg, 16, 1);
	return 1;
end catch;
GO
/****** Object:  StoredProcedure [ecr].[CollectViewChanges_Native]    Script Date: 12/24/2008 20:06:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		tpg
-- Create date: 04.09.2008
/* Description:
*/
-- =============================================
CREATE PROCEDURE [ecr].[CollectViewChanges_Native]
	@ViewName nvarchar(128)	-- системное имя сущности, перевязка по полю DisplayAlias
								-- на таблицу ecr.Views
	, @Count int = 100			-- количество выбираемых записей, параметр регулирует размер пакета
AS
SET NOCOUNT ON;

	select top (@Count)
		le.RowId
		, le.ID
		, le.DisplayAlias
		, le.ItemKey
		, le.ItemNumber
		, le.ItemBody
		, le.HistoryIndex
		, le.DateLastModified
		, le.OperationType
		, le.OperationDate
		, le.PackageID_Xml
		, le.DateOut_Native
	from ecr.LogEntitiesStorage le
	inner join ecr.Views e on e.SystemName = @ViewName
		and le.DisplayAlias = e.DisplayAlias;
GO
/****** Object:  StoredProcedure [ecr].[UpdateLogEntities_Native]    Script Date: 12/24/2008 20:06:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		tpg
-- Create date: 04.09.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[UpdateLogEntities_Native]
	@ID int
AS
SET NOCOUNT ON;

declare @ErrMsg nvarchar(4000)

begin try

	update
		ecr.LogEntitiesStorage
	set DateOut_Native = getdate()
	where ID = @ID;

end try
	-- Обработчик ошибок:
begin catch

	-- Если транзакция открыта, то откатываем транзакцию;
	if @@trancount <> 0 rollback tran;
	
	set @ErrMsg = N'Ошибка: '
								+ char(13) + char(10)
								+ N'ErrorNumber = ' + cast(ERROR_NUMBER() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorSeverity = ' + cast(ERROR_SEVERITY() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorState = ' + cast(ERROR_STATE() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorProcedure = ' + ERROR_PROCEDURE()
								+ char(13) + char(10)
								+ N'ErrorLine = ' + cast(ERROR_LINE() as nvarchar)
								+ char(13) + char(10);
	set @ErrMsg = @ErrMsg + left(N'ErrorMessage = ' + ERROR_MESSAGE(), 4000 - len(@ErrMsg));
	
	raiserror(@ErrMsg, 16, 1);
	return 1;
end catch;
GO
/****** Object:  StoredProcedure [ecr].[CollectEntityChanges_Native]    Script Date: 12/24/2008 20:06:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		tpg
-- Create date: 04.09.2008
/* Description:
*/
-- =============================================
CREATE PROCEDURE [ecr].[CollectEntityChanges_Native]
	@EntityName nvarchar(128)	-- системное имя сущности, перевязка по полю DisplayAlias
								-- на таблицу ecr.Entities
	, @Count int = 100			-- количество выбираемых записей, параметр регулирует размер пакета
AS
SET NOCOUNT ON;

	select top (@Count)
		le.RowId
		, le.ID
		, le.DisplayAlias
		, le.ItemKey
		, le.ItemNumber
		, le.ItemBody
		, le.HistoryIndex
		, le.DateLastModified
		, le.OperationType
		, le.OperationDate
		, le.PackageID_Xml
		, le.DateOut_Native
	from ecr.LogEntitiesStorage le
	inner join ecr.Entities e on e.SystemName = @EntityName
		and le.DisplayAlias = e.DisplayAlias;
GO
/****** Object:  StoredProcedure [ecr].[UpdateLogViews_Native]    Script Date: 12/24/2008 20:06:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		tpg
-- Create date: 04.09.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[UpdateLogViews_Native]
	@ID int
AS
SET NOCOUNT ON;

declare @ErrMsg nvarchar(4000)

begin try

	update
		ecr.LogViewsStorage
	set DateOut_Native = getdate()
	where ID = @ID;

end try
	-- Обработчик ошибок:
begin catch

	-- Если транзакция открыта, то откатываем транзакцию;
	if @@trancount <> 0 rollback tran;
	
	set @ErrMsg = N'Ошибка: '
								+ char(13) + char(10)
								+ N'ErrorNumber = ' + cast(ERROR_NUMBER() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorSeverity = ' + cast(ERROR_SEVERITY() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorState = ' + cast(ERROR_STATE() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorProcedure = ' + ERROR_PROCEDURE()
								+ char(13) + char(10)
								+ N'ErrorLine = ' + cast(ERROR_LINE() as nvarchar)
								+ char(13) + char(10);
	set @ErrMsg = @ErrMsg + left(N'ErrorMessage = ' + ERROR_MESSAGE(), 4000 - len(@ErrMsg));
	
	raiserror(@ErrMsg, 16, 1);
	return 1;
end catch;
GO
/****** Object:  StoredProcedure [ecr].[DeleteItem]    Script Date: 12/24/2008 20:06:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 05.02.2008
-- Description:	Процедура удаляет элемент и все его представления из таблиц ecr.EntitiesStorage,
-- ecr.ViewsStorage;
--		В случае, когда HistoryLifeTime > 0 удаляет данные об элементе из таблицы ecr.ViewsStorage
--		и добавляет для элемента в таблице ecr.EntitiesStorage значение, равное NULL
--		с соответствующим индексом истории хранения элемента;
-- =============================================
CREATE PROCEDURE [ecr].[DeleteItem] 
	@DisplayAlias int
	, @ItemKey nvarchar(50)
	, @ItemNumber int = null
AS
	SET NOCOUNT ON;

	declare @_lifetime int
	declare @_hCount int
	declare @ErrMsg nvarchar(4000)

begin try

	if not exists
			(
			select
				*
			from ecr.Entities
			where DisplayAlias = @DisplayAlias
			)
		raiserror (N'Ошибка: нет данных о сущности в целевом хранилище', 10, 1);	


	-- Открываем транзакцию;
	begin tran
			
/* Удаление представлений происходит в любом случае - независимо от того, храним историю или нет */
	if @ItemNumber is null
		delete
			vs
		from ecr.ViewsStorage vs
		inner join ecr.Views v on vs.DisplayAlias = v.DisplayAlias
			and vs.ItemNumber is null
		inner join ecr.Entities e on v.EntityParent = e.ID
			and e.DisplayAlias = @DisplayAlias;
	else
		delete
			vs
		from ecr.ViewsStorage vs
		inner join ecr.Views v on vs.DisplayAlias = v.DisplayAlias
			and vs.ItemNumber = @ItemNumber
		inner join ecr.Entities e on v.EntityParent = e.ID
			and e.DisplayAlias = @DisplayAlias;
		
/* Удаление непосредственно сущности */

	select
		@_lifetime = HistoryLifeTime
	from ecr.Entities
	where DisplayAlias = @DisplayAlias;

	if @_lifetime > 0 begin
				
		if @ItemNumber is null
			select
				@_hCount = count(*)
			from ecr.EntitiesStorage
			where DisplayAlias = @DisplayAlias
			and ItemKey = @ItemKey
			and ItemNumber is null;
		else
			select
				@_hCount = count(*)
			from ecr.EntitiesStorage
			where DisplayAlias = @DisplayAlias
			and ItemKey = @ItemKey;

		if @_hCount = @_lifetime begin
					
			if @ItemNumber is null
				delete
					ecr.EntitiesStorage
				where DisplayAlias = @DisplayAlias
				and ItemKey = @ItemKey
				and ItemNumber is null;
			else
				delete
					ecr.EntitiesStorage
				where DisplayAlias = @DisplayAlias
				and ItemKey = @ItemKey;


			/* Формирование запроса на обновление данных сущности */
			insert
				ecr.EntitiesStorage
					(
					DisplayAlias
					, ItemKey
					, ItemBody
					, HistoryIndex
					)
				select
					@DisplayAlias
					, @ItemKey
					, null
					, max(HistoryIndex) + 1
				from ecr.EntitiesStorage
				where DisplayAlias = @DisplayAlias
				and ItemKey = @ItemKey;
		end
		else begin
			/* Формирование запроса на удаление данных о сущности */
			if @ItemNumber is null
				delete
					ecr.EntitiesStorage
				where DisplayAlias = @DisplayAlias
				and ItemNumber is null;
			else
				delete
					ecr.EntitiesStorage
				where DisplayAlias = @DisplayAlias
				and ItemNumber = @ItemNumber;
		end
	end		
	commit
	
end try
	-- Обработчик ошибок:
begin catch

	-- Если транзакция открыта, то откатываем транзакцию;
	if @@trancount <> 0 rollback tran;
	
	set @ErrMsg = N'Ошибка: '
								+ char(13) + char(10)
								+ N'ErrorNumber = ' + cast(ERROR_NUMBER() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorSeverity = ' + cast(ERROR_SEVERITY() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorState = ' + cast(ERROR_STATE() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorProcedure = ' + ERROR_PROCEDURE()
								+ char(13) + char(10)
								+ N'ErrorLine = ' + cast(ERROR_LINE() as nvarchar)
								+ char(13) + char(10);
	set @ErrMsg = @ErrMsg + left(N'ErrorMessage = ' + ERROR_MESSAGE(), 4000 - len(@ErrMsg));
	
	raiserror(@ErrMsg, 16, 1);
	return 1

end catch;
GO
/****** Object:  StoredProcedure [ecr].[GetViewItem]    Script Date: 12/24/2008 20:06:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 05.02.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetViewItem] 
	@DisplayAlias int
	, @ItemKey nvarchar(50)
	, @ItemNumber int = null
AS
	SET NOCOUNT ON;

begin try
	if not exists
			(
			select
				*
			from ecr.Views	--dbo.ecr_ContentViews
			where DisplayAlias = @DisplayAlias
			)
		raiserror(N'Ошибка: нет данных о представлении контента в целевом хранилище', 10, 1);

	if @ItemNumber is null
		select
			ID
			, DisplayAlias
			, ItemKey
			, ItemNumber
			, ItemBody
		from ecr.ViewsStorage
		where ItemKey = @ItemKey and
			ItemNumber is null;

		else begin
			if @ItemNumber = 0
				select
					ID
					, DisplayAlias
					, ItemKey
					, ItemNumber
					, ItemBody
				from ecr.ViewsStorage
				where ItemKey = @ItemKey
				order by ItemNumber;
			else
				select
					ID
					, DisplayAlias
					, ItemKey
					, ItemNumber
					, ItemBody
				from ecr.ViewsStorage
				where ItemKey = @ItemKey and
					ItemNumber = @ItemNumber;
		end

end try

-- Обработчик ошибок:
begin catch
	return 1;
end catch;
GO
/****** Object:  StoredProcedure [ecr].[UpdateViewItem]    Script Date: 12/24/2008 20:06:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		tpg
-- Create date: 01.07.2008
-- Description:	GGGGGGGGGGGG
-- =============================================
CREATE PROCEDURE [ecr].[UpdateViewItem] 
	@DisplayAlias int
	, @ItemKey nvarchar(50)
	, @ItemNumber int = NULL
	, @ItemBody varbinary(max) = NULL
AS
	SET NOCOUNT ON;

	declare @ErrMsg nvarchar(4000)

begin try

	-- Открываем транзакцию;
	begin tran

		if @ItemNumber is not null begin

			update
				ecr.ViewsStorage with(updlock)	-- хинт для снижения вероятности возникновения
											-- взаимоблокировки из параллельного процесса
											-- (читающие процессы читать смогут, а вот пишущий - нет)
			set
				ItemKey = @ItemKey
				, ItemNumber = @ItemNumber
				, ItemBody = @ItemBody
			where DisplayAlias = @DisplayAlias
				and ItemKey = @ItemKey
				and ItemNumber = @ItemNumber;
		
			-- Если ничего не изменилось, добавляем строку
			if @@rowcount = 0
				insert
				ecr.ViewsStorage
					(
					DisplayAlias
					, ItemKey
					, ItemNumber
					, ItemBody
					)
				select
					@DisplayAlias
					, @ItemKey
					, @ItemNumber
					, @ItemBody
				where not exists
						(
						select
							*
						from ecr.ViewsStorage
						where DisplayAlias = @DisplayAlias
							and ItemKey = @ItemKey
							and ItemNumber = @ItemNumber	
						);

		end
		else begin

			update
				ecr.ViewsStorage with(updlock)	-- хинт для снижения вероятности возникновения
											-- взаимоблокировки из параллельного процесса
											-- (читающие процессы читать смогут, а вот пишущий - нет)
			set
				ItemKey = @ItemKey
				, ItemNumber = null
				, ItemBody = @ItemBody
			where DisplayAlias = @DisplayAlias
				and ItemKey = @ItemKey
				and ItemNumber is null;

			-- Если ничего не изменилось, добавляем строку
			if @@rowcount = 0
				insert
				ecr.ViewsStorage
					(
					DisplayAlias
					, ItemKey
					, ItemNumber
					, ItemBody
					)
				select
					@DisplayAlias
					, @ItemKey
					, @ItemNumber
					, @ItemBody
				where not exists
						(
						select
							*
						from ecr.ViewsStorage
						where DisplayAlias = @DisplayAlias
							and ItemKey = @ItemKey
							and ItemNumber is null	
						);
		end

	commit

end try
	-- Обработчик ошибок:
begin catch

	-- Если транзакция открыта, то откатываем транзакцию;
	if @@trancount <> 0 rollback tran;
	
	set @ErrMsg = N'Ошибка: '
								+ char(13) + char(10)
								+ N'ErrorNumber = ' + cast(ERROR_NUMBER() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorSeverity = ' + cast(ERROR_SEVERITY() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorState = ' + cast(ERROR_STATE() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorProcedure = ' + ERROR_PROCEDURE()
								+ char(13) + char(10)
								+ N'ErrorLine = ' + cast(ERROR_LINE() as nvarchar)
								+ char(13) + char(10);
	set @ErrMsg = @ErrMsg + left(N'ErrorMessage = ' + ERROR_MESSAGE(), 4000 - len(@ErrMsg));
	
	raiserror(@ErrMsg, 16, 1);
	return 1;
end catch;
GO
/****** Object:  StoredProcedure [ecr].[GetEntityItem]    Script Date: 12/24/2008 20:06:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 31.01.2008
-- Description:
--   Процедура возвращает записи в таблице ecr_StorageBase, соответствующую заданному типу контента (@ContentTypeAlias),
--		товарному ключу (@ItemKey), индексу контента (@ItemNumber) и индексу истории хранения (@HistoryIndex),
--		либо пустой набор данных; 
--   Параметры @ItemNumber и @HistoryIndex по умолчанию равны NULL и могут быть не заданы;
--   Параметр @ItemNumber == NULL означает, что индекс контента для данного типа контента не задан
--		(каждому товарному ключу соответствует только один элемент заданного типа контента), берутся записи с ItemNumber == NULL;
--	 В случае, если параметр @HistroyIndex не задан, берутся все позиции, удовлетворяющие заданному условию, включая исторические;
--   Параметры управления историей хранения позиций находятся в таблице ecr_ContentTypes
--		(база ECR_Config, либо реплицированная таблица);
--   В случае, если @HistoryIndex задан и возвращается несколько записей, генерируется ошибка;	
-- =============================================
CREATE PROCEDURE [ecr].[GetEntityItem]
	-- Add the parameters for the stored procedure here
	@DisplayAlias int
	, @ItemKey nvarchar(50)
	, @ItemNumber int = null
	, @HistoryIndex int = null
with execute as owner
AS
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	declare @rows int
	declare @strSQL nvarchar(4000)
	
	if not exists
			(
			select
				*
			from ecr.Entities
			where DisplayAlias = @DisplayAlias
			) begin
		raiserror (N'Ошибка: нет данных о типе контента в целевом хранилище', 10, 1);	
		return 1;
	end

	/* ContentTypeAlias, ItemKey */
	set @strSQL = N'select
	*
from ecr.EntitiesStorage
where DisplayAlias = ' + CAST(@DisplayAlias as nvarchar(20)) + '
and ItemKey = ''' + @ItemKey + ''''
	
	/* ItemNumber */
	if @ItemNumber is null
		set @strSQL = @strSQL + N'
and ItemNumber is null'
	else begin
		/* @ItemNumber = 0 обозначает выборку всех элементов по заданному ключу */
		if (@ItemNumber != 0) begin
			set @strSQL = @strSQL + N'
and ItemNumber = ' + CAST(@ItemNumber AS nvarchar(20))
		end
	end

	/* HistoryIndex */
	if @HistoryIndex is not null
		and @HistoryIndex > 0
		set @strSQL = @strSQL + N'
and HistoryIndex = ' + CAST(@HistoryIndex AS nvarchar(20)) + N'
order by HistoryIndex desc'
	else begin
		if @HistoryIndex = 0
			set @strSQL = N'select
	*
from
	(
	' + @strSQL + N'
	) a
where a.HistoryIndex = (select max(HistoryIndex) from
		(
' + @strSQL + N') b
		) order by HistoryIndex desc'
	end
	if @HistoryIndex is null
		set @strSQL = @strSQL + N'
order by HistoryIndex desc'

	/* Дополнительная группирвка по ItemNumber */
	if @ItemNumber is not null
		set @strSQL = @strSQL + N'
, ItemNumber asc'
	
	exec(@strSQL)
	
	set @rows = @@rowcount
	if @HistoryIndex is not null
		and @rows > 1 begin		/* Ошибка: количество выбранных записей больше 1 */
		RAISERROR (N'Ошибка: количество выбранных записей не соответствует формату данных', 10, 1);	
		return @rows;
	end
GO
/****** Object:  StoredProcedure [ecr].[CollectEntityChanges_Xml]    Script Date: 12/24/2008 20:06:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		tpg
-- Create date: 03.09.2008
/* Description:
Процедура создает запись о пакете в таблице ecr.XmlPackages
и возвращает номер пакета @PackageID, выбирает TOP @Count записей из таблицы 
ecr.LogEntitiesStorage с сортировкой ASC по полю RowId.
Затем формирует строчку xml @XmlStr.
Затем обновляет для выбранных записей в таблице ecr.LogEntitiesStorage значение столбца
PackageID_Xml значением @PackageID.
*/
-- =============================================
CREATE PROCEDURE [ecr].[CollectEntityChanges_Xml]
--	@EntityName nvarchar(128)	-- системное имя сущности, перевязка по полю DisplayAlias
								-- на таблицу ecr.Entities
	@Count int = 100			-- количество выбираемых записей, параметр регулирует размер пакета
    , @PackageID int out
	, @OutXml xml out
AS
SET NOCOUNT ON;

declare @ErrMsg nvarchar(4000)
--declare @t table
--				(
--				DisplayAlias int
--				)
declare @x table
				(
				ItemKey nvarchar(50)
				, ItemNumber int
				, ItemBody varbinary(max)
				, OperationType char(1)
				)

begin try
begin tran

	exec [ecr].[NextPackageID_Get]
					0	-- для Entity
					, @PackageID out;

	insert
			ecr.XmlPackages
			(
			ID
			, PackageID
--			, DisplayAlias
			, DateCreate
			)
--		output inserted.DisplayAlias into @t
		select
			@PackageID
			, newid()
--			, DisplayAlias
			, getdate();
--		from ecr.Entities
		--where SystemName = @EntityName;

	update
		l
	set
		PackageID_Xml = @PackageID
	output
		inserted.ItemKey
		, inserted.ItemNumber
		, inserted.ItemBody
		, inserted.OperationType
	into @x
	from ecr.LogEntitiesStorage l
	inner join
			(
			select top (@Count)
				le.RowId
			from ecr.LogEntitiesStorage le
--			inner join @t t on le.DisplayAlias = t.DisplayAlias
			where le.PackageID_Xml is null
			order by le.RowId
			) n on l.RowId = n.RowId;
	if @@rowcount = 0
		raiserror(N'Error 19600304: Строки для передачи в XML документ отсутствуют!', 16, 1)

	set @OutXml = 
			(
			select
				*
			from
				(
				select
					MessageNo = x.ID
					, MessageId = x.PackageID
					, MessageCreationTime = x.DateCreate
					, MessageOwnerType = N'ECR'
					, MessageOwnerId = N''
					, MessagePackageCount = N'1'
					, MessagePackageNumber = N'1'
					/*, PreviousMessageID =
										(
										select top 1
											PackageID
										from ecr.XmlPackages_Entity
										where DisplayAlias = x.DisplayAlias
										and ID < @PackageID
										order by ID desc
										)
					*/
				from ecr.XmlPackages x
				where x.ID = @PackageID
				) [Message]
			cross join
				(
				select
					ObjectType = N'otBinaryContent'
					, CreationTime = xpe.DateCreate
					/*, ContentType = N'otContentEntity'*/
					, KeyType = N'tk.key'
					/*,  [Identity] = e.SystemName	--@EntityName*/
					,  ItemType = e.SystemName	--@EntityName
					, x.ItemKey
					, x.ItemNumber
					, ItemBody = case x.OperationType
									when 'D' then null
									else x.ItemBody
									end
					, Encoding = N'base64'
					, Extension = e.Extensions
					, ObjectGUID = newid()
				from @x x, ecr.Entities e, ecr.XmlPackages xpe
				where xpe.ID = @PackageID
--				and e.DisplayAlias = xpe.DisplayAlias
				) [Object] for xml auto, binary base64
			);

commit tran
end try
	-- Обработчик ошибок:
begin catch

	-- Если транзакция открыта, то откатываем транзакцию;
	if @@trancount <> 0 rollback tran;
	
	set @ErrMsg = N'Ошибка: '
								+ char(13) + char(10)
								+ N'ErrorNumber = ' + cast(ERROR_NUMBER() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorSeverity = ' + cast(ERROR_SEVERITY() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorState = ' + cast(ERROR_STATE() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorProcedure = ' + ERROR_PROCEDURE()
								+ char(13) + char(10)
								+ N'ErrorLine = ' + cast(ERROR_LINE() as nvarchar)
								+ char(13) + char(10);
	set @ErrMsg = @ErrMsg + left(N'ErrorMessage = ' + ERROR_MESSAGE(), 4000 - len(@ErrMsg));
	
	raiserror(@ErrMsg, 16, 1);
	return 1;
end catch;
GO
/****** Object:  StoredProcedure [ecr].[CollectViewChanges_Xml]    Script Date: 12/24/2008 20:06:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		tpg
-- Create date: 03.09.2008
/* Description:
Процедура создает запись о пакете в таблице ecr.XmlPackage
и возвращает номер пакета @PackageID, выбирает TOP @Count записей из таблицы 
ecr.LogViewesStorage с сортировкой ASC по полю RowId.
Затем формирует строчку xml @XmlStr.
Затем обновляет для выбранных записей в таблице ecr.LogViewesStorage значение столбца
PackageID_Xml значением @PackageID.
*/
-- =============================================
CREATE PROCEDURE [ecr].[CollectViewChanges_Xml]
--	@ViewName nvarchar(128)	-- системное имя сущности, перевязка по полю DisplayAlias
								-- на таблицу ecr.Views
	@Count int = 100			-- количество выбираемых записей, параметр регулирует размер пакета
    , @PackageID int out
	, @OutXml xml out
AS
SET NOCOUNT ON;

declare @ErrMsg nvarchar(4000)
--declare @t table
--				(
--				DisplayAlias int
--				)
declare @x table
				(
				ItemKey nvarchar(50)
				, ItemNumber int
				, ItemBody varbinary(max)
				, OperationType char(1)
				)

begin try
begin tran

	exec [ecr].[NextPackageID_Get]
					1	-- для View
					, @PackageID out;

	insert
			ecr.XmlPackages
			(
			ID
			, PackageID
--			, DisplayAlias
			, DateCreate
			)
--		output inserted.DisplayAlias into @t
		select
			@PackageID
			, newid()
--			, DisplayAlias
			, getdate();
--		from ecr.Views
--		where SystemName = @ViewName ;

	update
		l
	set
		PackageID_Xml = @PackageID
	output
		inserted.ItemKey
		, inserted.ItemNumber
		, inserted.ItemBody
		, inserted.OperationType
	into @x
	from ecr.LogViewsStorage l
	inner join
			(
			select top (@Count)
				le.RowId
			from ecr.LogViewsStorage le
--			inner join @t t on le.DisplayAlias = t.DisplayAlias
			where le.PackageID_Xml is null
			order by le.RowId
			) n on l.RowId = n.RowId;
	if @@rowcount = 0
		raiserror(N'Error 19600304: Строки для передачи в XML документ отсутствуют!', 16, 1)

	set @OutXml = 
			(
			select
				*
			from
				(
				select
					MessageNo = x.ID
					, MessageId = x.PackageID
					, MessageCreationTime = x.DateCreate
					, MessageOwnerType = N'ECR'
					, MessageOwnerId = N''
					, MessagePackageCount = N'1'
					, MessagePackageNumber = N'1'
					/*, PreviousMessageID =
										(
										select top 1
											PackageID
										from ecr.XmlPackages_View
										where DisplayAlias = x.DisplayAlias
										and ID < @PackageID
										order by ID desc
										)
					*/
				from ecr.XmlPackages x
				where x.ID = @PackageID
				) [Message]
			cross join
				(
				select
					ObjectType = N'otBinaryContent'
					, CreationTime = xpe.DateCreate
					/*, ContentType = N'otContentView'*/
					, KeyType = N'tk.key'
					/*,  [Identity] = v.SystemName
					, ParentIdentity = e.SystemName*/
					,  ItemType = v.SystemName
					, ParentItemType = e.SystemName
					, x.ItemKey
					, x.ItemNumber
					, ItemBody = case x.OperationType
									when 'D' then null
									else x.ItemBody
									end
					, Encoding = N'base64'
					, Extension = v.Extensions
					, ObjectGUID = newid()
				from @x x, ecr.Views v
				inner join ecr.XmlPackages xpe on xpe.ID = @PackageID
--					and v.DisplayAlias = xpe.DisplayAlias
				left outer join ecr.Entities e on v.EntityParent = e.ID
				) [Object] for xml auto, binary base64
			);

commit tran
end try
	-- Обработчик ошибок:
begin catch

	-- Если транзакция открыта, то откатываем транзакцию;
	if @@trancount <> 0 rollback tran;
	
	set @ErrMsg = N'Ошибка: '
								+ char(13) + char(10)
								+ N'ErrorNumber = ' + cast(ERROR_NUMBER() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorSeverity = ' + cast(ERROR_SEVERITY() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorState = ' + cast(ERROR_STATE() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorProcedure = ' + ERROR_PROCEDURE()
								+ char(13) + char(10)
								+ N'ErrorLine = ' + cast(ERROR_LINE() as nvarchar)
								+ char(13) + char(10);
	set @ErrMsg = @ErrMsg + left(N'ErrorMessage = ' + ERROR_MESSAGE(), 4000 - len(@ErrMsg));
	
	raiserror(@ErrMsg, 16, 1);
	return 1;
end catch;
GO
/****** Object:  StoredProcedure [ecr].[UpdateEntityItem]    Script Date: 12/24/2008 20:06:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 05.02.2008
-- Description:	Процедура добавляет/обновляет элемент в таблице ecr.EntitiesStorage (оригиналы);
-- Insert происходит тогда, когда:
--		1. В ecr.EntitiesStorage нет элемента с указанным параметрами;
--		2. В ecr.EntitiesStorage есть элемент(ы) с указанными параметрами, но их количество K не превышает
--	HistoryLifeTime для заданной сущности из таблицы ecr.Entities (перевязка осуществляется по параметру DisplayAlias);
--  В случае, когда K >= HistoryLifeTime позиция в ecr.EntitiesStorage,
--	 имеющая самый старый индекс истории хранения HistoryIndex, УДАЛЯЕТСЯ,
--   затем в ecr.EntitiesStorage генерируется новая запись с новым HistoryIndex наибольшей размерности;
--  Т.о. в ecr.EntitiesStorage всегда находится число элементов с заданными параметрами,
--   равное числу HistoryLifeTime для соответствующей сущности из таблицы ecr.Entities, либо меньшее количество;
-- Update происходит тогда, когда элемент с заданными параметрами есть в таблице ecr.EntitiesStorage
-- и значение HistoryIndex равно 0 (история позиций для заданной сущности из таблицы Entities НЕ хранится);
-- Параметры:
--	@DisplayAlias: целочисленное представление сущности (перевязка на таблицу ecr.Entities);
--  @ItemKey: ключ позиции;
--  @ItemNumber: номер позиции, для позиций с ecr.Entity.IsMultiplied = 0 всегда == NULL,
--   в противном случае нужно сгенерировать exception;
--  @ItemBody: тело документа (файла);
--		Подстановка значения NULL эквивалентна вызову процедуры ecr.DeleteItem с соответствующими параметрами;
--
-- =============================================
CREATE PROCEDURE [ecr].[UpdateEntityItem] 
	@DisplayAlias int,
	@ItemKey nvarchar(50),
	@ItemNumber int = NULL,
	@ItemBody Image = NULL
AS
SET NOCOUNT ON;

declare @ErrMsg nvarchar(4000)
declare @HistoryLifeTime int
declare @Del table
				(
				ID int
				)

begin try

	-- Проверяем на NULL @ItemNumber ecr.Entity.IsMultiplied = 0
	if @ItemNumber is not null
		and
		exists
			(
			select
				*
			from ecr.Entities
			where DisplayAlias = @DisplayAlias
			and IsMultiplied = 0
			)
		raiserror(N'Для НЕМНОЖЕСТВЕННОЙ СУЩНОСТИ был получен номер позиции!', 16, 1);

	-- Если номер для множественной сущности < 1, поднимаем исключение
	if isnull(@ItemNumber, 0) = 0
		and
		exists
			(
			select
				*
			from ecr.Entities
			where DisplayAlias = @DisplayAlias
			and IsMultiplied = 1
			)
		raiserror(N'Для МНОЖЕСТВЕННОЙ СУЩНОСТИ был получен номер позиции меньше 1!', 16, 1);

	-- Если тело документа отсутствует, удаляем позицию
	if @ItemBody is null
		begin
			exec ecr.[DeleteItem] 
				@DisplayAlias
				, @ItemKey
				, @ItemNumber;
			return;
		end

-- Начинаем транзакцию
begin tran
	-- Определяем допустимое число пунктов хранения истории для данной сущности
	select
		@HistoryLifeTime = HistoryLifeTime
	from ecr.Entities
	where DisplayAlias = @DisplayAlias;

	-- Если число допустимых хранений превышает 0
	if @HistoryLifeTime > 0
		begin
			-- добавляем сущность в хранилище
			insert
				ecr.EntitiesStorage
					(
					DisplayAlias
					, ItemKey
					, ItemNumber
					, ItemBody
					, HistoryIndex
					, DateLastModified
					)
				select
					@DisplayAlias
					, @ItemKey
					, @ItemNumber
					, @ItemBody
					, isnull(max(HistoryIndex), 0) + 1
					, getdate()
				from ecr.EntitiesStorage with(updlock)
				where DisplayAlias = @DisplayAlias;
			-- Если число хранений превысило допустимое
			if @HistoryLifeTime < 
									(
									select
										count(*)
									from ecr.EntitiesStorage
									where DisplayAlias = @DisplayAlias
									)
				-- , то удаляем самую стару версию
				delete
					es
				output deleted.ID into @Del
				from ecr.EntitiesStorage es
				inner join
						(
						select
							min(HistoryIndex) as min_HistoryIndex
						from ecr.EntitiesStorage
						where DisplayAlias = @DisplayAlias
						) a on es.DisplayAlias = @DisplayAlias
							and es.HistoryIndex = a.min_HistoryIndex;
				-- Очищаем лог от удаленной строки
				delete
					les
				from ecr.LogEntitiesStorage les
				inner join @Del d on les.ID = d.ID
					and DisplayAlias = @DisplayAlias;

		end
	-- Если по сущности история не ведется
	else
		begin
			-- обновляем сущность в хронилеще
			update
				ecr.EntitiesStorage with(updlock)
			set
				ItemKey = @ItemKey
				, ItemBody = @ItemBody
				, HistoryIndex = 0
			where DisplayAlias = @DisplayAlias;

			-- Если сущности ещё небыло
			if @@rowcount = 0
				-- , то добавляем сущность
				insert
					ecr.EntitiesStorage
						(
						DisplayAlias
						, ItemKey
						, ItemNumber
						, ItemBody
						, HistoryIndex
						, DateLastModified
						)
					select
						@DisplayAlias
						, @ItemKey
						, @ItemNumber
						, @ItemBody
						, 0
						, getdate()
					where not exists
								(
								select
									*
								from ecr.EntitiesStorage
								where DisplayAlias = @DisplayAlias
								)
		end
commit

end try
	-- Обработчик ошибок:
begin catch

	-- Если транзакция открыта, то откатываем транзакцию;
	if @@trancount <> 0 rollback tran;
	
	set @ErrMsg = N'Ошибка: '
								+ char(13) + char(10)
								+ N'ErrorNumber = ' + cast(ERROR_NUMBER() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorSeverity = ' + cast(ERROR_SEVERITY() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorState = ' + cast(ERROR_STATE() as nvarchar)
								+ char(13) + char(10)
								+ N'ErrorProcedure = ' + ERROR_PROCEDURE()
								+ char(13) + char(10)
								+ N'ErrorLine = ' + cast(ERROR_LINE() as nvarchar)
								+ char(13) + char(10);
	set @ErrMsg = @ErrMsg + left(N'ErrorMessage = ' + ERROR_MESSAGE(), 4000 - len(@ErrMsg));
	
	raiserror(@ErrMsg, 16, 1);
	return 1;
end catch;
GO
/****** Object:  Check [CK_HistoryLifeTime]    Script Date: 12/24/2008 20:06:46 ******/
ALTER TABLE [ecr].[Entities]  WITH CHECK ADD  CONSTRAINT [CK_HistoryLifeTime] CHECK  (([HistoryLifeTime]>=(0)))
GO
ALTER TABLE [ecr].[Entities] CHECK CONSTRAINT [CK_HistoryLifeTime]
GO
/****** Object:  Check [CK_LastPackageNumber]    Script Date: 12/24/2008 20:06:56 ******/
ALTER TABLE [ecr].[LastPackageNumber]  WITH CHECK ADD  CONSTRAINT [CK_LastPackageNumber] CHECK  (([PackageType]=(1) OR [PackageType]=(0)))
GO
ALTER TABLE [ecr].[LastPackageNumber] CHECK CONSTRAINT [CK_LastPackageNumber]
GO
/****** Object:  ForeignKey [FK_Views_Entities]    Script Date: 12/24/2008 20:07:19 ******/
ALTER TABLE [ecr].[Views]  WITH CHECK ADD  CONSTRAINT [FK_Views_Entities] FOREIGN KEY([EntityParent])
REFERENCES [ecr].[Entities] ([ID])
GO
ALTER TABLE [ecr].[Views] CHECK CONSTRAINT [FK_Views_Entities]
GO

insert into dbo.VersionHistory (Version, VersionDate, Description) values ('1.0.1.1', convert(datetime, '23.09.2008 10:48:37', 104), 'Подготовленная база для продуктивной среды')
GO