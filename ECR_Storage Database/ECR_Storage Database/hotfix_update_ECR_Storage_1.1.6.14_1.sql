/****** Object:  StoredProcedure [ecr].[GetEntityItemBody]    Script Date: 06/10/2010 14:12:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetEntityItemBody]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetEntityItemBody]
GO

/****** Object:  StoredProcedure [ecr].[GetItem]    Script Date: 06/10/2010 14:12:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetItem]
GO

/****** Object:  StoredProcedure [ecr].[GetItemBody]    Script Date: 06/10/2010 14:12:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetItemBody]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetItemBody]
GO

/****** Object:  StoredProcedure [ecr].[GetEntityItemBody]    Script Date: 06/10/2010 14:12:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================

CREATE PROCEDURE [ecr].[GetEntityItemBody]
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
ItemBody
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
ItemBody
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

/****** Object:  StoredProcedure [ecr].[GetItem]    Script Date: 06/10/2010 14:12:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		MMX
-- Create date: 10.06.2010
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetItem] 
	-- Add the parameters for the stored procedure here
	@SystemName nvarchar(50),
	@ItemKey nvarchar(50),
	@ItemNumber int = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @DisplayAlias int;

    -- Insert statements for procedure here
	
	if exists(select SystemName from ecr.Entities where SystemName = @SystemName) begin
	
		set @DisplayAlias = (select DisplayAlias from ecr.Entities where SystemName = @SystemName);	
		exec [ecr].[GetEntityItem] @DisplayAlias, @ItemKey, @ItemNumber, null
	
	end
	else begin
	
		if exists(select SystemName from ecr.Views where SystemName = @SystemName) begin
			set @DisplayAlias = (select DisplayAlias from ecr.Views where SystemName = @SystemName);
			exec [ecr].[GetViewItem] @DisplayAlias, @ItemKey, @ItemNumber
		end 
		else begin
			declare @ErrMsg nvarchar(255)
			set @ErrMsg = N'Ошибка: идентификатор ' + @SystemName + N' не найден в списке сущностей.';
			raiserror(@ErrMsg, 16, 1);
		end
	
	end
	
END


GO

/****** Object:  StoredProcedure [ecr].[GetItemBody]    Script Date: 06/10/2010 14:12:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		MMX
-- Create date: 10.06.2010
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetItemBody] 
	-- Add the parameters for the stored procedure here
	@SystemName nvarchar(50),
	@ItemKey nvarchar(50),
	@ItemNumber int = null
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @DisplayAlias int;

    -- Insert statements for procedure here
	
	if exists(select SystemName from ecr.Entities where SystemName = @SystemName) begin

		set @DisplayAlias = (select DisplayAlias from ecr.Entities where SystemName = @SystemName);	
		exec [ecr].[GetEntityItemBody] @DisplayAlias, @ItemKey, @ItemNumber, null
	
	end
	else begin
	
		if exists(select SystemName from ecr.Views where SystemName = @SystemName) begin
			set @DisplayAlias = (select DisplayAlias from ecr.Views where SystemName = @SystemName);
			exec [ecr].[GetViewItemBody] @DisplayAlias, @ItemKey, @ItemNumber
		end 
		else begin
			declare @ErrMsg nvarchar(255)
			set @ErrMsg = N'Ошибка: идентификатор ' + @SystemName + N' не найден в списке сущностей.';
			raiserror(@ErrMsg, 16, 1);
		end
	
	end
	
END


GO