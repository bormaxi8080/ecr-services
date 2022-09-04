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
    @OldVersion = N'1.1.6.14'
    , @NewVersion = N'1.1.7.15'
    , @Description = left(N'Исправления в хранимых процедурах', 255);
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
/****** Object:  StoredProcedure [ecr].[GetEntityItemBody]    Script Date: 06/10/2010 14:12:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetEntityItemBody]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetEntityItemBody]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(1) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetItem]    Script Date: 06/10/2010 14:12:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetItem]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(2) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetItemBody]    Script Date: 06/10/2010 14:12:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetItemBody]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetItemBody]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(3) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityItemBody]    Script Date: 06/10/2010 14:12:26 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(4) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(5) BEGIN TRANSACTION END
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(6) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetItem]    Script Date: 06/10/2010 14:12:26 ******/
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
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(9) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetItemBody]    Script Date: 06/10/2010 14:12:26 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(10) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(11) BEGIN TRANSACTION END
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