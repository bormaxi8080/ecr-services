USE [master]
GO
/****** Object:  Database [ECR_Config]    Script Date: 12/24/2008 20:04:58 ******/
CREATE DATABASE [ECR_Config] ON  PRIMARY 
( NAME = N'ECR_Config', FILENAME = N'D:\exec\MSSQL\Data\ECR_Config.mdf' , SIZE = 5120KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'ECR_Config_log', FILENAME = N'D:\exec\MSSQL\Data\ECR_Config_1.ldf' , SIZE = 63424KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
EXEC dbo.sp_dbcmptlevel @dbname=N'ECR_Config', @new_cmptlevel=90
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ECR_Config].[dbo].[sp_fulltext_database] @action = 'disable'
end
GO
ALTER DATABASE [ECR_Config] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ECR_Config] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ECR_Config] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ECR_Config] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ECR_Config] SET ARITHABORT OFF 
GO
ALTER DATABASE [ECR_Config] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ECR_Config] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [ECR_Config] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ECR_Config] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ECR_Config] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ECR_Config] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ECR_Config] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ECR_Config] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ECR_Config] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ECR_Config] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ECR_Config] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ECR_Config] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ECR_Config] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ECR_Config] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ECR_Config] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ECR_Config] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ECR_Config] SET PARTNER TIMEOUT 10 
GO
ALTER DATABASE [ECR_Config] SET  READ_WRITE 
GO
ALTER DATABASE [ECR_Config] SET RECOVERY FULL 
GO
ALTER DATABASE [ECR_Config] SET  MULTI_USER 
GO
ALTER DATABASE [ECR_Config] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ECR_Config] SET DB_CHAINING OFF 

------------------------------------------------------------------------------------

USE [ECR_Config]
GO
/****** Object:  Schema [ecr]    Script Date: 12/24/2008 20:03:00 ******/
CREATE SCHEMA [ecr] AUTHORIZATION [dbo]
GO
/****** Object:  Table [ecr].[Bindings]    Script Date: 12/24/2008 20:03:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ecr].[Bindings](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[BindingID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ecr_Elements_ElementID]  DEFAULT (newid()),
	[SystemName] [nvarchar](128) NOT NULL,
	[DisplayName] [nvarchar](128) NOT NULL,
	[DisplayAlias] [int] NOT NULL,
	[RelativeNames] [nvarchar](50) NULL,
	[KeyType] [nvarchar](50) NULL,
	[Description] [nvarchar](255) NULL,
	[Comments] [nvarchar](255) NULL,
 CONSTRAINT [PK_ecr_Elements] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_ecr_Elements] UNIQUE NONCLUSTERED 
(
	[BindingID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_ecr_Elements_1] UNIQUE NONCLUSTERED 
(
	[SystemName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_ecr_Elements_2] UNIQUE NONCLUSTERED 
(
	[DisplayAlias] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ecr].[Storages]    Script Date: 12/24/2008 20:04:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ecr].[Storages](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[StorageID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ecr_Storages_StorageID]  DEFAULT (newid()),
	[SystemName] [nvarchar](128) NOT NULL,
	[DisplayName] [nvarchar](128) NOT NULL,
	[DisplayAlias] [int] NOT NULL,
	[Description] [nvarchar](255) NULL,
	[Comments] [nvarchar](255) NULL,
	[Enabled] [bit] NOT NULL CONSTRAINT [DF_ecr_Storages_Enabled]  DEFAULT ((1)),
	[RemoteServerName] [nvarchar](50) NULL,
	[ConnectionString] [nvarchar](1024) NOT NULL,
 CONSTRAINT [PK_ecr_Storages_1] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_ecr_Storages] UNIQUE NONCLUSTERED 
(
	[StorageID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_ecr_Storages_1] UNIQUE NONCLUSTERED 
(
	[SystemName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_ecr_Storages_2] UNIQUE NONCLUSTERED 
(
	[DisplayAlias] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ecr].[BinaryResources]    Script Date: 12/24/2008 20:03:47 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ecr].[BinaryResources](
	[ResourceName] [nvarchar](128) NOT NULL,
	[ResourceType] [nvarchar](50) NOT NULL,
	[ResourceValue] [image] NULL,
 CONSTRAINT [IX_BinaryResources] UNIQUE NONCLUSTERED 
(
	[ResourceName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[VersionHistory]    Script Date: 12/24/2008 20:03:43 ******/
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
/****** Object:  StoredProcedure [ecr].[GetEntityChilds]    Script Date: 12/24/2008 20:03:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 31.01.2008
-- Description:	Процедура возвращает данные о представлениях, наследуемых от заданной сущности (типа контента);
-- =============================================
CREATE PROCEDURE [ecr].[GetEntityChilds] 
	@EntityID int
AS
	SET NOCOUNT ON;

	select
		ID
		, ViewID
		, SystemName
		, DisplayName
		, DisplayAlias
		, RelativeNames
		, [Description]
		, Comments
		, EntityParent
		, [Enabled]
		, Extensions
	from dbo.ecr_Views
	where EntityParent = @EntityID;
GO
/****** Object:  Table [ecr].[EntityBindings]    Script Date: 12/24/2008 20:04:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ecr].[EntityBindings](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EntityID] [int] NOT NULL,
	[BindingID] [int] NOT NULL,
 CONSTRAINT [PK_ecr_EntityBindings] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [ecr].[Views]    Script Date: 12/24/2008 20:04:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ecr].[Views](
	[ID] [int] IDENTITY(1,1) NOT NULL,
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
/****** Object:  Table [ecr].[Entities]    Script Date: 12/24/2008 20:04:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [ecr].[Entities](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EntityID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_ecr_Entities_EntityID]  DEFAULT (newid()),
	[SystemName] [nvarchar](128) NOT NULL,
	[DisplayName] [nvarchar](128) NOT NULL,
	[DisplayAlias] [int] NOT NULL,
	[Description] [nvarchar](255) NULL,
	[Comments] [nvarchar](255) NULL,
	[StorageID] [int] NOT NULL,
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
/****** Object:  StoredProcedure [ecr].[GetBindingByID]    Script Date: 12/24/2008 20:03:09 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 01.07.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetBindingByID]
	-- Add the parameters for the stored procedure here
	@BindingID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		ID
		, BindingID
		, SystemName
		, DisplayName
		, DisplayAlias
		, RelativeNames
		, KeyType
		, [Description]
		, Comments
	from
		ecr.Bindings
	where
		ID = @BindingID	

END
GO
/****** Object:  StoredProcedure [ecr].[GetBindingNameByID]    Script Date: 12/24/2008 20:03:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 01.07.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetBindingNameByID]
	-- Add the parameters for the stored procedure here
	@BindingID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		SystemName
	from ecr.Bindings
	where ID = @BindingID;

END
GO
/****** Object:  StoredProcedure [ecr].[GetViewListByBinding]    Script Date: 12/24/2008 20:03:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		tpg
-- Create date: 14.08.2008
-- Description:	Максим, допиши пояснения сам!
-- =============================================
CREATE PROCEDURE [ecr].[GetViewListByBinding]
--	@BindingID uniqueidentifier
	@BindingName nvarchar(128)
	, @Enabled bit = NULL	-- если NULL, то выбирать ВСЕ строки без фильтрации
AS
SET NOCOUNT ON;

declare @ErrMsg nvarchar(4000)

	if @Enabled is not null
		select
			v.ID
			, v.ViewID
			, v.SystemName
			, v.DisplayName
			, v.DisplayAlias
			, v.RelativeNames
			, v.[Description]
			, v.Comments
			, v.EntityParent
			, v.[Enabled]
			, v.Extensions
		from ecr.Views v
		where exists
				(
				select
					*
				from ecr.EntityBindings eb
				inner join ecr.Bindings b on b.SystemName = @BindingName
						and eb.BindingID = b.ID
				inner join ecr.Entities e on eb.EntityID = e.ID
						and e.ID = v.EntityParent
				)
		and v.[Enabled] = @Enabled;
	else
		select
			v.ID
			, v.ViewID
			, v.SystemName
			, v.DisplayName
			, v.DisplayAlias
			, v.RelativeNames
			, v.[Description]
			, v.Comments
			, v.EntityParent
			, v.[Enabled]
			, v.Extensions
		from ecr.Views v
		where exists
				(
				select
					*
				from ecr.EntityBindings eb
				inner join ecr.Bindings b on b.SystemName = @BindingName
						and eb.BindingID = b.ID
				inner join ecr.Entities e on eb.EntityID = e.ID
						and e.ID = v.EntityParent
				);
GO
/****** Object:  StoredProcedure [ecr].[GetBindingAliasByName]    Script Date: 12/24/2008 20:03:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		tpg
-- Create date: 27.08.2008
-- Description:	Процедура возвращает целочисленный псевдоним по ее системному имя привязки;
-- =============================================
CREATE PROCEDURE [ecr].[GetBindingAliasByName] 
	@SystemName nvarchar(128)
AS
	SET NOCOUNT ON;

	select
		DisplayAlias
	from ecr.Bindings
	where SystemName = @SystemName;
GO
/****** Object:  StoredProcedure [ecr].[GetEntityList]    Script Date: 12/24/2008 20:03:22 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		tpg
-- Create date: 27.08.2008
-- Description:	Процедура возвращает данные по выбранному имени сущностям (типам контента);
--				@Binding указывает на привязку имя привязки SystemName;
-- =============================================
CREATE PROCEDURE [ecr].[GetEntityList] 
	@BindingName nvarchar(128) = NULL
AS
	SET NOCOUNT ON;
	
	if(@BindingName IS NULL)
		select
			ID
			, EntityID
			, SystemName
			, DisplayName
			, DisplayAlias
			, [Description]
			, Comments
			, StorageID
			, HistoryLifeTime
			, IsMultiplied
			, Extensions
		from ecr.Entities
	else
		select
			e.ID
			, e.EntityID
			, e.SystemName
			, e.DisplayName
			, e.DisplayAlias
			, e.[Description]
			, e.Comments
			, e.StorageID
			, e.HistoryLifeTime
			, e.IsMultiplied
			, e.Extensions
		from ecr.Entities e
		inner join ecr.EntityBindings eb on e.ID = eb.EntityID
		inner join ecr.Bindings b on eb.BindingID = b.ID
			and b.SystemName = @BindingName;
GO
/****** Object:  StoredProcedure [ecr].[GetBindingsList]    Script Date: 12/24/2008 20:03:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	Процедура возвращает данные по выбранным привязкам;
-- =============================================
CREATE PROCEDURE [ecr].[GetBindingsList] 
AS
	SET NOCOUNT ON;

	select
		ID
		, BindingID
		, SystemName
		, DisplayName
		, DisplayAlias
		, RelativeNames
		, KeyType
		, [Description]
		, Comments
	from ecr.Bindings;
GO
/****** Object:  StoredProcedure [ecr].[CheckBindingExistsA]    Script Date: 12/24/2008 20:03:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		tpg
-- Create date: 27.08.2008
-- Description:	Процедура проверяет наличие привязки с заданным системным алиасом;
-- =============================================
CREATE PROCEDURE [ecr].[CheckBindingExistsA] 
	@DisplayAlias int
	, @Exists int = 0 output
AS
	SET NOCOUNT ON;

-- Можно переписать так
if exists
		(
		select
			*
		from ecr.Bindings
		where DisplayAlias = @DisplayAlias
		)
	set @Exists = 1;
else
	set @Exists = 0;
GO
/****** Object:  StoredProcedure [ecr].[CheckBindingExists]    Script Date: 12/24/2008 20:03:02 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	Процедура проверяет наличие привязки с заданным системным именем;
-- =============================================
CREATE PROCEDURE [ecr].[CheckBindingExists] 
	-- Add the parameters for the stored procedure here
	@SystemName nvarchar(128)
	, @Exists int = 0 output
AS
	SET NOCOUNT ON;

-- Можно переписать так
if exists
		(
		select
			*
		from ecr.Bindings
		where SystemName = @SystemName
		)
	set @Exists = 1;
else
	set @Exists = 0;
GO
/****** Object:  StoredProcedure [ecr].[GetBindingByAlias]    Script Date: 12/24/2008 20:03:08 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	Процедура возвращает данные о привязке по заданному целочисленному псевдониму;
-- =============================================
CREATE PROCEDURE [ecr].[GetBindingByAlias] 
	-- Add the parameters for the stored procedure here
	@DisplayAlias int
AS
	SET NOCOUNT ON;

	select
		ID
		, BindingID
		, SystemName
		, DisplayName
		, DisplayAlias
		, RelativeNames
		, KeyType
		, [Description]
		, Comments
	from ecr.Bindings
	where DisplayAlias = @DisplayAlias
GO
/****** Object:  StoredProcedure [ecr].[GetBindingByUID]    Script Date: 12/24/2008 20:03:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetBindingByUID] 
	-- Add the parameters for the stored procedure here
	@BindingID uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		ID
		, BindingID
		, SystemName
		, DisplayName
		, DisplayAlias
		, RelativeNames
		, KeyType
		, [Description]
		, Comments
	from
		ecr.Bindings
	where
		BindingID = @BindingID	

END
GO
/****** Object:  StoredProcedure [ecr].[GetBindingByName]    Script Date: 12/24/2008 20:03:14 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:		Процедура возвращает данные о привязке по заданному имени;
-- =============================================
CREATE PROCEDURE [ecr].[GetBindingByName] 
	@SystemName nvarchar(50)
AS
	SET NOCOUNT ON;

	select
		ID
		, BindingID
		, SystemName
		, DisplayName
		, DisplayAlias
		, RelativeNames
		, KeyType
		, [Description]
		, Comments
	from ecr.Bindings
	where SystemName = @SystemName;
GO
/****** Object:  StoredProcedure [ecr].[GetBindingNameByAlias]    Script Date: 12/24/2008 20:03:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	Процедура возвращает системное имя привязки по ее целочисленному псевдониму;
-- =============================================
CREATE PROCEDURE [ecr].[GetBindingNameByAlias] 
	@DisplayAlias int
AS
	SET NOCOUNT ON;

	select
		SystemName
	from ecr.Bindings
	where DisplayAlias = @DisplayAlias;
GO
/****** Object:  StoredProcedure [ecr].[GetBindingNameByUID]    Script Date: 12/24/2008 20:03:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	Процедура возвращает сиетемное имя привязки по ее идентификатору;
-- =============================================
CREATE PROCEDURE [ecr].[GetBindingNameByUID] 
	@BindingID uniqueidentifier
AS
	SET NOCOUNT ON;

	select
		SystemName
	from ecr.Bindings
	where BindingID = @BindingID;
GO
/****** Object:  StoredProcedure [ecr].[GetBindingChilds]    Script Date: 12/24/2008 20:03:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	Процедура возвращает данные о представлениях с заданной привязкой;
-- =============================================
CREATE PROCEDURE [ecr].[GetBindingChilds] 
--	@BindingID uniqueidentifier
	@SystemName nvarchar(128)
AS
	SET NOCOUNT ON;

	select
		e.ID
		, e.EntityID
		, e.SystemName
		, e.DisplayName
		, e.DisplayAlias
		, e.[Description]
		, e.Comments
		, e.StorageID
		, e.HistoryLifeTime
		, e.IsMultiplied
		, e.Extensions
	from ecr.Entities e
	inner join ecr.EntityBindings eb on e.ID = eb.EntityID
	inner join ecr.Bindings b on eb.BindingID = b.ID
		and b.SystemName = @SystemName;
GO
/****** Object:  StoredProcedure [ecr].[CheckViewExistsA]    Script Date: 12/24/2008 20:03:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		tpg
-- Create date: 27.08.2008
-- Description:	Процедура проверяет наличие привязки с заданным системным алиасом;
-- =============================================
CREATE PROCEDURE [ecr].[CheckViewExistsA] 
	@DisplayAlias int
	, @Exists int = 0 output
AS
	SET NOCOUNT ON;

-- Можно переписать так
if exists
		(
		select
			*
		from ecr.Views
		where DisplayAlias = @DisplayAlias
		)
	set @Exists = 1;
else
	set @Exists = 0;
GO
/****** Object:  StoredProcedure [ecr].[IsViewEnabled]    Script Date: 12/24/2008 20:03:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	Процедура возвращает признак доступности представления контента с заданным именем;
--				Важно: свойство Enabled определено только для объектов таблиц ecr_Storages, ecr_Views;
--				Для элементов и сущностей свойство Enabled не определено;
-- =============================================
CREATE PROCEDURE [ecr].[IsViewEnabled] 
--	@ViewID uniqueidentifier
	@SystemName nvarchar(128)
AS
	SET NOCOUNT ON;

	select
		[Enabled]
	from ecr.Views
	where SystemName = @SystemName;
GO
/****** Object:  StoredProcedure [ecr].[GetViewByAlias]    Script Date: 12/24/2008 20:03:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 21.01.2008
-- Description:	Процедура возвращает данные о представлении контента по заданному целочисленному псевдониму;
-- =============================================
CREATE PROCEDURE [ecr].[GetViewByAlias] 
	@DisplayAlias int
AS
	SET NOCOUNT ON;
	
	select
		ID
		, ViewID
		, SystemName
		, DisplayName
		, DisplayAlias
		, RelativeNames
		, [Description]
		, Comments
		, EntityParent
		, [Enabled]
		, Extensions
	from ecr.Views
	where DisplayAlias = @DisplayAlias;
GO
/****** Object:  StoredProcedure [ecr].[GetViewByUID]    Script Date: 12/24/2008 20:03:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 31.01.2008
-- Description:	Процедура возвращает данные о представлении контента по заданному идентификатору;
-- =============================================
CREATE PROCEDURE [ecr].[GetViewByUID] 
	@ViewID uniqueidentifier
AS
	SET NOCOUNT ON;
	
	select
		ID
		, ViewID
		, SystemName
		, DisplayName
		, DisplayAlias
		, RelativeNames
		, [Description]
		, Comments
		, EntityParent
		, [Enabled]
		, Extensions
	from ecr.Views
	where ViewID = @ViewID;
GO
/****** Object:  StoredProcedure [ecr].[GetViewByName]    Script Date: 12/24/2008 20:03:34 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 31.01.2008
-- Description:	Процедура возвращает данные о представлении контента по заданному имени;
-- =============================================
CREATE PROCEDURE [ecr].[GetViewByName] 
	@SystemName nvarchar(50)
AS
	SET NOCOUNT ON;
	
	select
		ID
		, ViewID
		, SystemName
		, DisplayName
		, DisplayAlias
		, RelativeNames
		, [Description]
		, Comments
		, EntityParent
		, [Enabled]
		, Extensions
	from ecr.Views
	where SystemName = @SystemName;
GO
/****** Object:  StoredProcedure [ecr].[GetViewList]    Script Date: 12/24/2008 20:03:36 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 31.01.2008
-- Description:	Процедура возвращает данные о представлениях контента;
--				@EntityParent указывает на родительскую сущность;
-- =============================================
CREATE PROCEDURE [ecr].[GetViewList] 
--	@EntityParent int = NULL
	@EntityParent nvarchar(128) = NULL
	, @Enabled bit = NULL
AS
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	if @EntityParent is null begin
		if @Enabled is null
			select
				ID
				, ViewID
				, SystemName
				, DisplayName
				, DisplayAlias
				, RelativeNames
				, [Description]
				, [Comments]
				, EntityParent
				, [Enabled]
				, Extensions
			from ecr.Views;
		else
			select
				ID
				, ViewID
				, SystemName
				, DisplayName
				, DisplayAlias
				, RelativeNames
				, [Description]
				, [Comments]
				, EntityParent
				, [Enabled]
				, Extensions
			from ecr.Views
			where [Enabled] = @Enabled;
	end
	else begin
		if @Enabled is null
			select
				v.ID
				, v.ViewID
				, v.SystemName
				, v.DisplayName
				, v.DisplayAlias
				, v.RelativeNames
				, v.[Description]
				, v.[Comments]
				, v.EntityParent
				, v.[Enabled]
				, v.Extensions
			from ecr.Views v
			inner join ecr.Entities e on v.EntityParent = e.ID
				and e.SystemName = @EntityParent;
		else
			select
				v.ID
				, v.ViewID
				, v.SystemName
				, v.DisplayName
				, v.DisplayAlias
				, v.RelativeNames
				, v.[Description]
				, v.[Comments]
				, v.EntityParent
				, v.[Enabled]
				, v.Extensions
			from ecr.Views v
			inner join ecr.Entities e on v.EntityParent = e.ID
				and e.SystemName = @EntityParent
				and v.[Enabled] = @Enabled;
	end
GO
/****** Object:  StoredProcedure [ecr].[GetViewNameByID]    Script Date: 12/24/2008 20:03:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 01.07.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetViewNameByID]
	-- Add the parameters for the stored procedure here
	@ViewID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		SystemName
	from ecr.Views
	where ID = @ViewID;
	
END
GO
/****** Object:  StoredProcedure [ecr].[GetStorageForView]    Script Date: 12/24/2008 20:03:29 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		tpg
-- Create date: 27.08.2008
-- Description:	Максим, напиши пояснения
-- =============================================
CREATE PROCEDURE [ecr].[GetStorageForView]
	@ViewName nvarchar(128)
AS
SET NOCOUNT ON;

	select
		s.ID
		, s.StorageID
		, s.SystemName
		, s.DisplayName
		, s.DisplayAlias
		, s.[Description]
		, s.Comments
		, s.[Enabled]
		, s.RemoteServerName
		, s.ConnectionString
	from ecr.Storages s
	inner join ecr.Entities e on s.ID = e.StorageID
	inner join ecr.Views v on e.ID = v.EntityParent
		and v.SystemName = @ViewName;
GO
/****** Object:  StoredProcedure [ecr].[GetViewAliasByName]    Script Date: 12/24/2008 20:03:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		tpg
-- Create date: 27.08.2008
-- Description:	Процедура возвращает целочисленный псевдоним по системному имени представления контента;
-- =============================================
CREATE PROCEDURE [ecr].[GetViewAliasByName] 
	@SystemName nvarchar(128)
AS
	SET NOCOUNT ON;

	select
		DisplayAlias
	from ecr.Views
	where SystemName = @SystemName;
GO
/****** Object:  StoredProcedure [ecr].[IsViewMultiplied]    Script Date: 12/24/2008 20:03:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	Процедура возвращает признак множественности для представления контента, наследуемый от родительской сущности;
-- =============================================
CREATE PROCEDURE [ecr].[IsViewMultiplied] 
--	@ViewID uniqueidentifier
	@SystemName nvarchar(128)
AS
	SET NOCOUNT ON;

	select
		IsMultiplied
	from ecr.Entities e
	inner join ecr.Views v on e.ID = v.EntityParent
		and v.SystemName = @SystemName;
GO
/****** Object:  StoredProcedure [ecr].[GetViewByID]    Script Date: 12/24/2008 20:03:33 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 01.07.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetViewByID]
	-- Add the parameters for the stored procedure here
	@ViewID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		ID
		, ViewID
		, SystemName
		, DisplayName
		, DisplayAlias
		, RelativeNames
		, [Description]
		, Comments
		, EntityParent
		, [Enabled]
		, Extensions
	from ecr.Views
	where ID = @ViewID;	

END
GO
/****** Object:  StoredProcedure [ecr].[GetViewNameByUID]    Script Date: 12/24/2008 20:03:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 26.02.2008
-- Description:	Процедура возвращает системное имя представления контента по его идентификатору;
-- =============================================
CREATE PROCEDURE [ecr].[GetViewNameByUID] 
	@ViewID uniqueidentifier
AS
	SET NOCOUNT ON;
	
	select
		SystemName
	from ecr.Views
	where ViewID = @ViewID;
GO
/****** Object:  StoredProcedure [ecr].[GetViewNameByAlias]    Script Date: 12/24/2008 20:03:37 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 26.02.2008
-- Description:	Процедура возвращает системное имя представления контента по его целочисленному псевдониму;
-- =============================================
CREATE PROCEDURE [ecr].[GetViewNameByAlias] 
	@DisplayAlias int
AS
	SET NOCOUNT ON;

	select
		SystemName
	from ecr.Views
	where DisplayAlias = @DisplayAlias;
GO
/****** Object:  StoredProcedure [ecr].[CheckViewExists]    Script Date: 12/24/2008 20:03:06 ******/
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
	-- Add the parameters for the stored procedure here
	@SystemName nvarchar(128)
	, @Exists int = 0 output
AS
set nocount on;
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
/****** Object:  StoredProcedure [ecr].[CheckEntityExists]    Script Date: 12/24/2008 20:03:03 ******/
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
	-- Add the parameters for the stored procedure here
	@SystemName nvarchar(128)
	, @Exists int = 0 output
AS
	SET NOCOUNT ON;

    -- Insert statements for procedure here

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
/****** Object:  StoredProcedure [ecr].[GetEntityByID]    Script Date: 12/24/2008 20:03:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 01.07.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetEntityByID]
	-- Add the parameters for the stored procedure here
	@EntityID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		ID
		, EntityID
		, SystemName
		, DisplayName
		, DisplayAlias
		, [Description]
		, Comments
		, StorageID
		, HistoryLifeTime
		, IsMultiplied
		, Extensions
	from ecr.Entities
	where ID = @EntityID;	

END
GO
/****** Object:  StoredProcedure [ecr].[GetEntityNameByID]    Script Date: 12/24/2008 20:03:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 01.07.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetEntityNameByID]
	-- Add the parameters for the stored procedure here
	@EntityID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		SystemName
	from ecr.Entities
	where ID = @EntityID;	

END
GO
/****** Object:  StoredProcedure [ecr].[GetEntityAliasByName]    Script Date: 12/24/2008 20:03:18 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		tpg
-- Create date: 27.08.2008
-- Description:	Процедура возвращает целочисленный псевдоним по системному имени сущности (типу контента);
-- =============================================
CREATE PROCEDURE [ecr].[GetEntityAliasByName] 
	@SystemName nvarchar(128)
AS
	SET NOCOUNT ON;

	select
		DisplayAlias
	from ecr.Entities
	where SystemName = @SystemName;
GO
/****** Object:  StoredProcedure [ecr].[IsEntityMultiplied]    Script Date: 12/24/2008 20:03:38 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	Процедура возвращает признак множественности для сущности;
-- =============================================
CREATE PROCEDURE [ecr].[IsEntityMultiplied] 
--	@EntityID uniqueidentifier
	@SystemName nvarchar(128)
AS
	SET NOCOUNT ON;

/*	select
		IsMultiplied
	from ecr.Entities
	where EntityID = @EntityID;
*/
	select
		IsMultiplied
	from ecr.Entities
	where SystemName = @SystemName;
GO
/****** Object:  StoredProcedure [ecr].[GetEntityByUID]    Script Date: 12/24/2008 20:03:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 30.01.2008
-- Description:	Процедура возвращает данные о сущности (типе контента) по заданному идентификатору;
-- =============================================
CREATE PROCEDURE [ecr].[GetEntityByUID] 
	@EntityID uniqueidentifier
AS
	SET NOCOUNT ON;
	
	select
		ID
		, EntityID
		, SystemName
		, DisplayName
		, DisplayAlias
		, [Description]
		, Comments
		, StorageID
		, HistoryLifeTime
		, IsMultiplied
		, Extensions
	from ecr.Entities
	where EntityID = @EntityID;
GO
/****** Object:  StoredProcedure [ecr].[GetStorageForEntity]    Script Date: 12/24/2008 20:03:28 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		tpg
-- Create date: 27.08.2008
-- Description:	Максим, напиши пояснения
-- =============================================
CREATE PROCEDURE [ecr].[GetStorageForEntity]
	@EntityName nvarchar(128)
AS
SET NOCOUNT ON;

	select
		s.ID
		, s.StorageID
		, s.SystemName
		, s.DisplayName
		, s.DisplayAlias
		, s.[Description]
		, s.Comments
		, s.[Enabled]
		, s.RemoteServerName
		, s.ConnectionString
	from ecr.Storages s
	inner join ecr.Entities e on s.ID = e.StorageID
		and e.SystemName = @EntityName;
GO
/****** Object:  StoredProcedure [ecr].[GetEntityByName]    Script Date: 12/24/2008 20:03:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 30.01.2008
-- Description:	Процедура возвращает данные о сущности (типе контента) по заданному имени;
-- =============================================
CREATE PROCEDURE [ecr].[GetEntityByName] 
	@SystemName nvarchar(50)
AS
	SET NOCOUNT ON;
	
	select
		ID
		, EntityID
		, SystemName
		, DisplayName
		, DisplayAlias
		, [Description]
		, Comments
		, StorageID
		, HistoryLifeTime
		, IsMultiplied
		, Extensions
	from ecr.Entities
	where SystemName = @SystemName;
GO
/****** Object:  StoredProcedure [ecr].[GetEntityByAlias]    Script Date: 12/24/2008 20:03:19 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 31.01.2008
-- Description:	Процедура возвращает данные о сущности (типе контента) по заданному целочисленному псевдониму;
-- =============================================
CREATE PROCEDURE [ecr].[GetEntityByAlias] 
	@DisplayAlias int
AS
	SET NOCOUNT ON;

	select
		ID
		, EntityID
		, SystemName
		, DisplayName
		, DisplayAlias
		, [Description]
		, Comments
		, StorageID
		, HistoryLifeTime
		, IsMultiplied
		, Extensions
	from ecr.Entities
	where DisplayAlias = @DisplayAlias;
GO
/****** Object:  StoredProcedure [ecr].[GetEntityNameByUID]    Script Date: 12/24/2008 20:03:24 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 26.02.2008
-- Description:	Процедура возвращает сиетемное имя сущности (типа контента) по ее идентификатору;
-- =============================================
CREATE PROCEDURE [ecr].[GetEntityNameByUID] 
	@EntityID uniqueidentifier
AS
	SET NOCOUNT ON;
	
	select
		SystemName
	from ecr.Entities
	where EntityID = @EntityID;
GO
/****** Object:  StoredProcedure [ecr].[GetEntityNameByAlias]    Script Date: 12/24/2008 20:03:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 26.02.2008
-- Description:	Процедура возвращает системное имя сущности (типа контента) по ее целочисленному псевдониму;
-- =============================================
CREATE PROCEDURE [ecr].[GetEntityNameByAlias] 
	@DisplayAlias int
AS
	SET NOCOUNT ON;
	
	select
		SystemName
	from ecr.Entities
	where DisplayAlias = @DisplayAlias;
GO
/****** Object:  StoredProcedure [ecr].[CheckEntityExistsA]    Script Date: 12/24/2008 20:03:03 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		tpg
-- Create date: 27.08.2008
-- Description:	Процедура проверяет наличие привязки с заданным системным алиасом;
-- =============================================
CREATE PROCEDURE [ecr].[CheckEntityExistsA] 
	@DisplayAlias int
	, @Exists int = 0 output
AS
	SET NOCOUNT ON;

-- Можно переписать так
if exists
		(
		select
			*
		from ecr.Entities
		where DisplayAlias = @DisplayAlias
		)
	set @Exists = 1;
else
	set @Exists = 0;
GO
/****** Object:  StoredProcedure [ecr].[CheckStorageExistsA]    Script Date: 12/24/2008 20:03:05 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		tpg
-- Create date: 27.08.2008
-- Description:	Процедура проверяет наличие привязки с заданным системным алиасом;
-- =============================================
CREATE PROCEDURE [ecr].[CheckStorageExistsA] 
	@DisplayAlias int
	, @Exists int = 0 output
AS
	SET NOCOUNT ON;

-- Можно переписать так
if exists
		(
		select
			*
		from ecr.Storages
		where DisplayAlias = @DisplayAlias
		)
	set @Exists = 1;
else
	set @Exists = 0;
GO
/****** Object:  StoredProcedure [ecr].[CheckStorageExists]    Script Date: 12/24/2008 20:03:04 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 26.02.2008
-- Description:	Процедура проверяет наличие хранилища контента с заданным системным именем;
-- =============================================
CREATE PROCEDURE [ecr].[CheckStorageExists] 
	-- Add the parameters for the stored procedure here
	@SystemName nvarchar(128)
	, @Exists int = 0 output
AS
	SET NOCOUNT ON;

-- Можно переписать так
if exists
		(
		select
			*
		from ecr.Storages
		where SystemName = @SystemName
		)
	set @Exists = 1;
else
	set @Exists = 0;
GO
/****** Object:  StoredProcedure [ecr].[GetStorageNameByUID]    Script Date: 12/24/2008 20:03:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 26.02.2008
-- Description:	Процедура возвращает системное имя хранилища контента по его идентификатору;
-- =============================================
CREATE PROCEDURE [ecr].[GetStorageNameByUID] 
	@StorageID uniqueidentifier
AS
	SET NOCOUNT ON;
	
	select
		SystemName
	from ecr.Storages
	where StorageID = @StorageID;
GO
/****** Object:  StoredProcedure [ecr].[GetStorageNameByAlias]    Script Date: 12/24/2008 20:03:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 26.02.2008
-- Description:	Процедура возвращает системное имя хранилища контента по его целочисленному псевдониму;
-- =============================================
CREATE PROCEDURE [ecr].[GetStorageNameByAlias] 
	@DisplayAlias int
AS
	SET NOCOUNT ON;
	
	select
		SystemName
	from ecr.Storages
	where DisplayAlias = @DisplayAlias;
GO
/****** Object:  StoredProcedure [ecr].[GetStorageByAlias]    Script Date: 12/24/2008 20:03:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 31.01.2008
-- Description:	Процедура возвращает данные о хранилище контента по заданному целочисленному псевдониму;
-- =============================================
CREATE PROCEDURE [ecr].[GetStorageByAlias] 
	@DisplayAlias int
AS
	SET NOCOUNT ON;

	select
		ID
		, StorageID
		, SystemName
		, DisplayName
		, DisplayAlias
		, [Description]
		, Comments
		, [Enabled]
		, RemoteServerName
		, ConnectionString
	from ecr.Storages
	where DisplayAlias = @DisplayAlias;
GO
/****** Object:  StoredProcedure [ecr].[GetStorageAliasByName]    Script Date: 12/24/2008 20:03:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		tpg
-- Create date: 27.08.2008
-- Description:	Процедура возвращает целочисленный псевдоним по имени хранилища контента;
-- =============================================
CREATE PROCEDURE [ecr].[GetStorageAliasByName] 
	@SystemName nvarchar(128)
AS
	SET NOCOUNT ON;

	select
		DisplayAlias
	from ecr.Storages
	where SystemName = @SystemName;
GO
/****** Object:  StoredProcedure [ecr].[IsStorageEnabled]    Script Date: 12/24/2008 20:03:39 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	Процедура возвращает признак доступности хранилища контента с заданным идентификатором;
-- =============================================
CREATE PROCEDURE [ecr].[IsStorageEnabled] 
--	@StorageID uniqueidentifier
	@SystemName nvarchar(128)
AS
	SET NOCOUNT ON;

	select
		[Enabled]
	from ecr.Storages
	where SystemName = @SystemName;
GO
/****** Object:  StoredProcedure [ecr].[GetStorageByID]    Script Date: 12/24/2008 20:03:25 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 01.07.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetStorageByID]
	-- Add the parameters for the stored procedure here
	@StorageID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		ID
		, StorageID
		, SystemName
		, DisplayName
		, DisplayAlias
		, [Description]
		, Comments
		, [Enabled]
		, RemoteServerName
		, ConnectionString
	from ecr.Storages
	where ID = @StorageID;
	
END
GO
/****** Object:  StoredProcedure [ecr].[GetStorageList]    Script Date: 12/24/2008 20:03:30 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 26.02.2008
-- Description:	Процедура возвращает список параметров хранилищ контента;
-- =============================================
CREATE PROCEDURE [ecr].[GetStorageList] 
	@Enabled bit = NULL
AS
	SET NOCOUNT ON;

	if (@Enabled IS NULL)
		select
			ID
			, StorageID
			, SystemName
			, DisplayName
			, DisplayAlias
			, [Description]
			, Comments
			, [Enabled]
			, RemoteServerName
			, ConnectionString
		from ecr.Storages
		order by ID;
	else
		select
			ID
			, StorageID
			, SystemName
			, DisplayName
			, DisplayAlias
			, [Description]
			, Comments
			, [Enabled]
			, RemoteServerName
			, ConnectionString
		from ecr.Storages
		where [Enabled] = @Enabled
		order by ID;
GO
/****** Object:  StoredProcedure [ecr].[GetStorageNameByID]    Script Date: 12/24/2008 20:03:31 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 01.07.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetStorageNameByID]
	-- Add the parameters for the stored procedure here
	@StorageID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		SystemName
	from ecr.Storages
	where ID = @StorageID;	

END
GO
/****** Object:  StoredProcedure [ecr].[GetStorageByUID]    Script Date: 12/24/2008 20:03:27 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 30.01.2008
-- Description:	Процедура возвращает данные о хранилище контента по заданному идентификатору;
-- =============================================
CREATE PROCEDURE [ecr].[GetStorageByUID] 
	@StorageID uniqueidentifier
AS
	SET NOCOUNT ON;

	select
		ID
		, StorageID
		, SystemName
		, DisplayName
		, DisplayAlias
		, [Description]
		, Comments
		, [Enabled]
		, RemoteServerName
		, ConnectionString
	from ecr.Storages
	where StorageID = @StorageID;
GO
/****** Object:  StoredProcedure [ecr].[GetStorageByName]    Script Date: 12/24/2008 20:03:26 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 30.01.2008
-- Description:	Процедура возвращает данные о хранилище контента по заданному имени;
-- =============================================
CREATE PROCEDURE [ecr].[GetStorageByName] 
	@SystemName nvarchar(50)
AS
	SET NOCOUNT ON;

	select
		ID
		, StorageID
		, SystemName
		, DisplayName
		, DisplayAlias
		, [Description]
		, Comments
		, [Enabled]
		, RemoteServerName
		, ConnectionString
	from ecr.Storages
	where SystemName = @SystemName;
GO
/****** Object:  StoredProcedure [ecr].[GetBinaryResource]    Script Date: 12/24/2008 20:03:07 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	Процедура возврщает значение поля ResourceValue из таблицы BinaryResources по заданным параметрам;
--		Таблица BinaryResources применяется для хранения дополнительных бинарных полей объектов таблиц - иконок отображений, картинок и др.
-- =============================================
CREATE PROCEDURE [ecr].[GetBinaryResource] 
	-- Add the parameters for the stored procedure here
	@ResourceName nvarchar(128),
	@ResourceType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		ResourceValue
	from
		ecr.BinaryResources
	where
		ResourceName = @ResourceName
			and
		ResourceType = @ResourceType

END
GO
/****** Object:  StoredProcedure [dbo].[GetCurrentVersion]    Script Date: 12/24/2008 20:03:00 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 27.08.2008
-- Description:	Хранимая процедура возвращает текущую версию базы данных ECR_Config
-- =============================================
CREATE PROCEDURE [dbo].[GetCurrentVersion] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select top 1 [Version] from [dbo].[VersionHistory] order by VersionDate desc, ID desc
	
END
GO
/****** Object:  StoredProcedure [dbo].[GetVersionHistory]    Script Date: 12/24/2008 20:03:01 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		MX
-- Create date: 27.08.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GetVersionHistory] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select ID,
		[Version],
		VersionDate,
		[Description]
	from [dbo].[VersionHistory]
	order by VersionDate desc,
		ID desc

END
GO
/****** Object:  ForeignKey [FK_Entities_Storages]    Script Date: 12/24/2008 20:04:05 ******/
ALTER TABLE [ecr].[Entities]  WITH CHECK ADD  CONSTRAINT [FK_Entities_Storages] FOREIGN KEY([StorageID])
REFERENCES [ecr].[Storages] ([ID])
GO
ALTER TABLE [ecr].[Entities] CHECK CONSTRAINT [FK_Entities_Storages]
GO
/****** Object:  ForeignKey [FK_EntityBindings_Bindings]    Script Date: 12/24/2008 20:04:09 ******/
ALTER TABLE [ecr].[EntityBindings]  WITH CHECK ADD  CONSTRAINT [FK_EntityBindings_Bindings] FOREIGN KEY([BindingID])
REFERENCES [ecr].[Bindings] ([ID])
GO
ALTER TABLE [ecr].[EntityBindings] CHECK CONSTRAINT [FK_EntityBindings_Bindings]
GO
/****** Object:  ForeignKey [FK_EntityBindings_Entities]    Script Date: 12/24/2008 20:04:09 ******/
ALTER TABLE [ecr].[EntityBindings]  WITH CHECK ADD  CONSTRAINT [FK_EntityBindings_Entities] FOREIGN KEY([EntityID])
REFERENCES [ecr].[Entities] ([ID])
GO
ALTER TABLE [ecr].[EntityBindings] CHECK CONSTRAINT [FK_EntityBindings_Entities]
GO
/****** Object:  ForeignKey [FK_Views_Entities]    Script Date: 12/24/2008 20:04:27 ******/
ALTER TABLE [ecr].[Views]  WITH CHECK ADD  CONSTRAINT [FK_Views_Entities] FOREIGN KEY([EntityParent])
REFERENCES [ecr].[Entities] ([ID])
GO
ALTER TABLE [ecr].[Views] CHECK CONSTRAINT [FK_Views_Entities]
GO

insert into dbo.VersionHistory (Version, VersionDate, Description) values ('1.1.3.3', convert(datetime, '18.04.2008 12:53:07', 104), 'Изменения в структуре таблиц и хранимых процедур в связи с согласованиями форматов с ИМ и ЕБК. Исправления недочетов и ошибок.')
GO

insert into dbo.VersionHistory (Version, VersionDate, Description) values ('1.1.4.4', convert(datetime, '27.08.2008 12:00:01', 104), 'Изменения в структуре хранимых процедур доступа к сущностям справочников хранения файлового контента')
GO

insert into dbo.VersionHistory (Version, VersionDate, Description) values ('1.1.5.5', convert(datetime, '22.09.2008 12:00:00', 104), 'Подготовленная база для продуктивной среды')
GO