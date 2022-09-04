/****** Object:  StoredProcedure [ecr].[CheckViewExists]    Script Date: 06/10/2010 14:17:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[CheckViewExists]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[CheckViewExists]
GO

/****** Object:  StoredProcedure [ecr].[GetContentStatistics]    Script Date: 06/10/2010 14:17:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetContentStatistics]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetContentStatistics]
GO

/****** Object:  StoredProcedure [ecr].[GetContentStorageInfo]    Script Date: 06/10/2010 14:17:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetContentStorageInfo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetContentStorageInfo]
GO

/****** Object:  StoredProcedure [ecr].[GetEntitiesStatistics]    Script Date: 06/10/2010 14:17:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetEntitiesStatistics]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetEntitiesStatistics]
GO

/****** Object:  StoredProcedure [ecr].[GetLastProcessedMessageNo]    Script Date: 06/10/2010 14:17:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetLastProcessedMessageNo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetLastProcessedMessageNo]
GO

/****** Object:  StoredProcedure [ecr].[GetStorageAliasByName]    Script Date: 06/10/2010 14:17:25 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetStorageAliasByName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetStorageAliasByName]
GO

/****** Object:  StoredProcedure [ecr].[GetStorageByAlias]    Script Date: 06/10/2010 14:17:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetStorageByAlias]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetStorageByAlias]
GO

/****** Object:  StoredProcedure [ecr].[GetStorageByID]    Script Date: 06/10/2010 14:17:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetStorageByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetStorageByID]
GO

/****** Object:  StoredProcedure [ecr].[GetStorageByName]    Script Date: 06/10/2010 14:17:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetStorageByName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetStorageByName]
GO

/****** Object:  StoredProcedure [ecr].[GetStorageByUID]    Script Date: 06/10/2010 14:17:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetStorageByUID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetStorageByUID]
GO

/****** Object:  StoredProcedure [ecr].[GetStorageForEntity]    Script Date: 06/10/2010 14:17:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetStorageForEntity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetStorageForEntity]
GO

/****** Object:  StoredProcedure [ecr].[GetStorageForView]    Script Date: 06/10/2010 14:17:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetStorageForView]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetStorageForView]
GO

/****** Object:  StoredProcedure [ecr].[GetStorageList]    Script Date: 06/10/2010 14:17:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetStorageList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetStorageList]
GO

/****** Object:  StoredProcedure [ecr].[GetStorageNameByAlias]    Script Date: 06/10/2010 14:17:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetStorageNameByAlias]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetStorageNameByAlias]
GO

/****** Object:  StoredProcedure [ecr].[GetStorageNameByID]    Script Date: 06/10/2010 14:17:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetStorageNameByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetStorageNameByID]
GO

/****** Object:  StoredProcedure [ecr].[GetStorageNameByUID]    Script Date: 06/10/2010 14:17:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetStorageNameByUID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetStorageNameByUID]
GO

/****** Object:  StoredProcedure [ecr].[GetViewsStatistics]    Script Date: 06/10/2010 14:17:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetViewsStatistics]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetViewsStatistics]
GO


--------------------------------------------


/****** Object:  StoredProcedure [ecr].[CheckViewExists]    Script Date: 06/10/2010 14:17:44 ******/
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

/****** Object:  StoredProcedure [ecr].[GetContentStatistics]    Script Date: 06/10/2010 14:17:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		MMX
-- Create date: 07.06.2010
-- Description:	Процедура выборки сводных данных наличия ФК (оригиналы + представления)
--   по сущности ecr.Binding (продукт, персона, ...)
-- Parameters:
--              BindingName - имя сущности ecr.Binding
--              ItemKey - ключ позиции
--              ItemNumber - номер позиции
--              Для немножественных сущностей всегда null независимо от подставляемого значения
--				Для множественных сущностей подставляется:
--                  null - для множественных сущностей когда надо получить ВСЕ позиции на ключ,
--					<номер> - для множественных сущностей когда надо получить позицию с заданным номером на ключ
-- =============================================
CREATE PROCEDURE [ecr].[GetContentStatistics] 
	-- Add the parameters for the stored procedure here
	@BindingName nvarchar(50), 
	@ItemKey nvarchar(50),
	@ItemNumber int = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	if(@ItemNumber is null) begin
		
		select 
			ist.ID,
			@BindingName as BindingName,
			ist.ItemKey,
			ist.ItemNumber,
			ist.DisplayAlias,
				v.SystemName as ViewName,
			ent.DisplayName,
			ent.IsMultiplied	,
			'otContentView' as ContentType
		from [ecr].[ItemsStatistic] ist
		INNER JOIN
			ecr.Entities ent ON ist.DisplayAlias = ent.DisplayAlias
		INNER JOIN
			ecr.EntityBindings eb ON eb.EntityID = ent.ID
		INNER JOIN 
			ecr.Bindings b ON b.ID = eb.BindingID AND b.SystemName = 'otWareCard'
		INNER JOIN
			ecr.[Views] v ON v.EntityParent = ent.ID 
		where ist.ItemKey = @ItemKey
		-- and ItemNumber is null  - ЭТО НЕ НАДО! - ДЛЯ НЕМНОЖЕСТВЕННЫХ СУЩНОСТЕЙ NULL ВСЕГДА,
		--                           ДЛЯ МНОЖЕСТВЕННЫХ СУЩНОСТЕЙ NULL-ЗНАЧЕНИЯ НЕ МОЖЕТ БЫТЬ => ВЫБИРАЕМ ВСЕ ПОЗИЦИИ!
		
		union
		
		select 
			ist.ID,
			@BindingName as BindingName,
			ist.ItemKey,
			ist.ItemNumber,
			ist.DisplayAlias,
			ent.SystemName as EntityName,
			ent.DisplayName,
			ent.IsMultiplied,
			'otContentEntity' as ContentType
		from [ecr].[ItemsStatistic] ist
		INNER JOIN
			ecr.Entities ent ON ist.DisplayAlias = ent.DisplayAlias
		INNER JOIN
			ecr.EntityBindings eb ON eb.EntityID = ent.ID
		INNER JOIN 
			ecr.Bindings b ON b.ID = eb.BindingID AND b.SystemName = 'otWareCard' 
		where ist.ItemKey = @ItemKey
		-- and ItemNumber is null  - ЭТО НЕ НАДО! - ДЛЯ НЕМНОЖЕСТВЕННЫХ СУЩНОСТЕЙ NULL ВСЕГДА,
		--                           ДЛЯ МНОЖЕСТВЕННЫХ СУЩНОСТЕЙ NULL-ЗНАЧЕНИЯ НЕ МОЖЕТ БЫТЬ => ВЫБИРАЕМ ВСЕ ПОЗИЦИИ!
		order by ItemNumber
	
	end
	else begin
	
		select 
			ist.ID,
			@BindingName as BindingName,
			ist.ItemKey,
			ist.ItemNumber,
			ist.DisplayAlias,
				v.SystemName as ViewName,
			ent.DisplayName,
			ent.IsMultiplied	,
			'otContentView' as ContentType
		from [ecr].[ItemsStatistic] ist
		INNER JOIN
			ecr.Entities ent ON ist.DisplayAlias = ent.DisplayAlias
		INNER JOIN
			ecr.EntityBindings eb ON eb.EntityID = ent.ID
		INNER JOIN 
			ecr.Bindings b ON b.ID = eb.BindingID AND b.SystemName = 'otWareCard'
		INNER JOIN
			ecr.[Views] v ON v.EntityParent = ent.ID 
		where ist.ItemKey = @ItemKey
		-- and ItemNumber is null  - ЭТО НЕ НАДО! - ДЛЯ НЕМНОЖЕСТВЕННЫХ СУЩНОСТЕЙ NULL ВСЕГДА,
		--                           ДЛЯ МНОЖЕСТВЕННЫХ СУЩНОСТЕЙ NULL-ЗНАЧЕНИЯ НЕ МОЖЕТ БЫТЬ => ВЫБИРАЕМ ВСЕ ПОЗИЦИИ!
		
		union
		
		select 
			ist.ID,
			@BindingName as BindingName,
			ist.ItemKey,
			ist.ItemNumber,
			ist.DisplayAlias,
			ent.SystemName as EntityName,
			ent.DisplayName,
			ent.IsMultiplied,
			'otContentEntity' as ContentType
		from [ecr].[ItemsStatistic] ist
		INNER JOIN
			ecr.Entities ent ON ist.DisplayAlias = ent.DisplayAlias
		INNER JOIN
			ecr.EntityBindings eb ON eb.EntityID = ent.ID
		INNER JOIN 
			ecr.Bindings b ON b.ID = eb.BindingID AND b.SystemName = 'otWareCard' 
		where ist.ItemKey = @ItemKey
			and ist.ItemNumber = @ItemNumber
	
	end
	
END

GO

/****** Object:  StoredProcedure [ecr].[GetContentStorageInfo]    Script Date: 06/10/2010 14:17:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		MMX
-- Create date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetContentStorageInfo] 
	-- Add the parameters for the stored procedure here
	@SystemName nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	if exists(select StorageID from ecr.Entities where SystemName = @SystemName) begin
	
	SELECT
		ecr.Storages.ID,
		ecr.Storages.StorageID As StorageID,
		ecr.Storages.SystemName As SystemName,
		ecr.Storages.DisplayName,
		ecr.Storages.DisplayAlias,
		ecr.Storages.[Description], 
		ecr.Storages.Comments,
		ecr.Storages.[Enabled],
		ecr.Storages.ConnectionString,
		ecr.Storages.RemoteServerName,
		ecr.Storages.DatabaseName,
		'otContentEntity' as ContentType
	FROM ecr.Entities INNER JOIN
         ecr.Storages ON ecr.Entities.StorageID = ecr.Storages.ID
    WHERE
		ecr.Entities.SystemName = @SystemName;
	
end
else begin

	if exists(select SystemName from ecr.Views where SystemName = @SystemName) begin

		SELECT 
			ecr.Storages.ID,
			ecr.Storages.StorageID AS StorageID,
			ecr.Storages.SystemName AS SystemName,
			ecr.Storages.DisplayName,
			ecr.Storages.DisplayAlias,
			ecr.Storages.[Description], 
			ecr.Storages.Comments,
			ecr.Storages.[Enabled],
			ecr.Storages.ConnectionString,
			ecr.Storages.RemoteServerName,
			ecr.Storages.DatabaseName,
			'otContentView' as ContentType
		FROM ecr.Entities INNER JOIN
			 ecr.Storages ON ecr.Entities.StorageID = ecr.Storages.ID INNER JOIN
			 ecr.[Views] ON ecr.Entities.ID = ecr.[Views].EntityParent
		WHERE ecr.[Views].SystemName = @SystemName;

	end
	else begin
		declare @ErrMsg nvarchar(255)
		set @ErrMsg = N'Ошибка: идентификатор ' + @SystemName + N' не найден в списке сущностей.';
		raiserror(@ErrMsg, 16, 1);
	end

end
	
	
END


GO

/****** Object:  StoredProcedure [ecr].[GetEntitiesStatistics]    Script Date: 06/10/2010 14:17:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		MMX
-- Create date: 07.06.2010
-- Description:	Процедура выборки сводных данных наличия ФК (оригиналы) по сущности ecr.Binding (продукт, персона, ...)
-- Parameters:
--              BindingName - имя сущности ecr.Binding
--              ItemKey - ключ позиции
--              ItemNumber - номер позиции
--              Для немножественных сущностей всегда null независимо от подставляемого значения
--				Для множественных сущностей подставляется:
--                  null - для множественных сущностей когда надо получить ВСЕ позиции на ключ,
--					<номер> - для множественных сущностей когда надо получить позицию с заданным номером на ключ
-- =============================================
CREATE PROCEDURE [ecr].[GetEntitiesStatistics] 
	-- Add the parameters for the stored procedure here
	@BindingName nvarchar(50), 
	@ItemKey nvarchar(50),
	@ItemNumber int = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	if(@ItemNumber is null) begin
		
		select 
			ist.ID,
			@BindingName as BindingName,
			ist.ItemKey,
			ist.ItemNumber,
			ist.DisplayAlias,
			ent.SystemName as EntityName,
			ent.DisplayName,
			ent.IsMultiplied
		from [ecr].[ItemsStatistic] ist
		INNER JOIN
			ecr.Entities ent ON ist.DisplayAlias = ent.DisplayAlias
		INNER JOIN
			ecr.EntityBindings eb ON eb.EntityID = ent.ID
		INNER JOIN 
			ecr.Bindings b ON b.ID = eb.BindingID AND b.SystemName = @BindingName 
		where ist.ItemKey = @ItemKey
		-- and ItemNumber is null  - ЭТО НЕ НАДО! - ДЛЯ НЕМНОЖЕСТВЕННЫХ СУЩНОСТЕЙ NULL ВСЕГДА,
		--                           ДЛЯ МНОЖЕСТВЕННЫХ СУЩНОСТЕЙ NULL-ЗНАЧЕНИЯ НЕ МОЖЕТ БЫТЬ => ВЫБИРАЕМ ВСЕ ПОЗИЦИИ!
		order by ItemNumber
	
	end
	else begin
	
		select 
			ist.ID,
			@BindingName as BindingName,
			ist.ItemKey,
			ist.ItemNumber,
			ist.DisplayAlias,
			ent.SystemName as EntityName,
			ent.DisplayName,
			ent.IsMultiplied
		from [ecr].[ItemsStatistic] ist
		INNER JOIN
			ecr.Entities ent ON ist.DisplayAlias = ent.DisplayAlias
		INNER JOIN
			ecr.EntityBindings eb ON eb.EntityID = ent.ID
		INNER JOIN 
			ecr.Bindings b ON b.ID = eb.BindingID AND b.SystemName = @BindingName 
		where ist.ItemKey = @ItemKey
		and ist.ItemNumber = @ItemNumber
	
	end
	
END


GO

/****** Object:  StoredProcedure [ecr].[GetLastProcessedMessageNo]    Script Date: 06/10/2010 14:17:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		MMX
-- Create date: 27.05.2009
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetLastProcessedMessageNo]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select max(MessageNo) from [ecr].[ProcessedMessages]

END


GO

/****** Object:  StoredProcedure [ecr].[GetStorageAliasByName]    Script Date: 06/10/2010 14:17:45 ******/
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

/****** Object:  StoredProcedure [ecr].[GetStorageByAlias]    Script Date: 06/10/2010 14:17:45 ******/
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
		, DatabaseName
		, ConnectionString
	from ecr.Storages
	where DisplayAlias = @DisplayAlias;


GO

/****** Object:  StoredProcedure [ecr].[GetStorageByID]    Script Date: 06/10/2010 14:17:45 ******/
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
		, DatabaseName
		, ConnectionString
	from ecr.Storages
	where ID = @StorageID;
	
END


GO

/****** Object:  StoredProcedure [ecr].[GetStorageByName]    Script Date: 06/10/2010 14:17:45 ******/
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
		, DatabaseName
		, ConnectionString
	from ecr.Storages
	where SystemName = @SystemName;


GO

/****** Object:  StoredProcedure [ecr].[GetStorageByUID]    Script Date: 06/10/2010 14:17:45 ******/
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
		, DatabaseName
		, ConnectionString
	from ecr.Storages
	where StorageID = @StorageID;


GO

/****** Object:  StoredProcedure [ecr].[GetStorageForEntity]    Script Date: 06/10/2010 14:17:45 ******/
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
		, s.DatabaseName
		, s.ConnectionString
	from ecr.Storages s
	inner join ecr.Entities e on s.ID = e.StorageID
		and e.SystemName = @EntityName;


GO

/****** Object:  StoredProcedure [ecr].[GetStorageForView]    Script Date: 06/10/2010 14:17:45 ******/
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
		, s.DatabaseName
		, s.DatabaseName
		, s.ConnectionString
	from ecr.Storages s
	inner join ecr.Entities e on s.ID = e.StorageID
	inner join ecr.Views v on e.ID = v.EntityParent
		and v.SystemName = @ViewName;


GO

/****** Object:  StoredProcedure [ecr].[GetStorageList]    Script Date: 06/10/2010 14:17:45 ******/
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
			, DatabaseName
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

/****** Object:  StoredProcedure [ecr].[GetStorageNameByAlias]    Script Date: 06/10/2010 14:17:45 ******/
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

/****** Object:  StoredProcedure [ecr].[GetStorageNameByID]    Script Date: 06/10/2010 14:17:45 ******/
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

/****** Object:  StoredProcedure [ecr].[GetStorageNameByUID]    Script Date: 06/10/2010 14:17:45 ******/
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

/****** Object:  StoredProcedure [ecr].[GetViewsStatistics]    Script Date: 06/10/2010 14:17:45 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		MMX
-- Create date: 07.06.2010
-- Description:	Процедура выборки сводных данных наличия ФК (представления) по сущности ecr.Binding (продукт, персона, ...)
-- Parameters:
--              BindingName - имя сущности ecr.Binding
--              ItemKey - ключ позиции
--              ItemNumber - номер позиции
--              Для немножественных сущностей всегда null независимо от подставляемого значения
--				Для множественных сущностей подставляется:
--                  null - для множественных сущностей когда надо получить ВСЕ позиции на ключ,
--					<номер> - для множественных сущностей когда надо получить позицию с заданным номером на ключ
-- =============================================
CREATE PROCEDURE [ecr].[GetViewsStatistics] 
	-- Add the parameters for the stored procedure here
	@BindingName nvarchar(50), 
	@ItemKey nvarchar(50),
	@ItemNumber int = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	if(@ItemNumber is null) begin
		
		select 
			ist.ID,
			@BindingName as BindingName,
			ist.ItemKey,
			ist.ItemNumber,
			ist.DisplayAlias,
			ent.SystemName as EntityName,
			ent.DisplayName,
			ent.IsMultiplied,
			v.SystemName as ViewName
		from [ecr].[ItemsStatistic] ist
		INNER JOIN
			ecr.Entities ent ON ist.DisplayAlias = ent.DisplayAlias
		INNER JOIN
			ecr.EntityBindings eb ON eb.EntityID = ent.ID
		INNER JOIN 
			ecr.Bindings b ON b.ID = eb.BindingID AND b.SystemName = @BindingName
		INNER JOIN
			ecr.[Views] v ON v.EntityParent = ent.ID 
		where ist.ItemKey = @ItemKey
		-- and ItemNumber is null  - ЭТО НЕ НАДО! - ДЛЯ НЕМНОЖЕСТВЕННЫХ СУЩНОСТЕЙ NULL ВСЕГДА,
		--                           ДЛЯ МНОЖЕСТВЕННЫХ СУЩНОСТЕЙ NULL-ЗНАЧЕНИЯ НЕ МОЖЕТ БЫТЬ => ВЫБИРАЕМ ВСЕ ПОЗИЦИИ!
		order by ItemNumber
	
	end
	else begin
	
		select 
			ist.ID,
			@BindingName as BindingName,
			ist.ItemKey,
			ist.ItemNumber,
			ist.DisplayAlias,
			ent.SystemName as EntityName,
			ent.DisplayName,
			ent.IsMultiplied,
			v.SystemName as ViewName
		from [ecr].[ItemsStatistic] ist
		INNER JOIN
			ecr.Entities ent ON ist.DisplayAlias = ent.DisplayAlias
		INNER JOIN
			ecr.EntityBindings eb ON eb.EntityID = ent.ID
		INNER JOIN 
			ecr.Bindings b ON b.ID = eb.BindingID AND b.SystemName = @BindingName
		INNER JOIN
			ecr.[Views] v ON v.EntityParent = ent.ID 
		where ist.ItemKey = @ItemKey
		and ist.ItemNumber = @ItemNumber
	
	end
	
END
GO