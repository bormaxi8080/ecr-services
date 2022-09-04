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
    @OldVersion = N'1.0.3.6'
    , @NewVersion = N'1.0.4.7'
    , @Description = left(N'Исправление ошибки с переносом триггеров на таблицы ecr.EntitiesStorage, ecr.ViewsStorage', 255);
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
/****** Object:  Trigger [DelEntitiesStorage]    Script Date: 07/03/2009 12:57:28 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[ecr].[DelEntitiesStorage]'))
DROP TRIGGER [ecr].[DelEntitiesStorage]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(1) BEGIN TRANSACTION END
GO
/****** Object:  Trigger [InsEntitiesStorage]    Script Date: 07/03/2009 12:57:28 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[ecr].[InsEntitiesStorage]'))
DROP TRIGGER [ecr].[InsEntitiesStorage]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(2) BEGIN TRANSACTION END
GO
/****** Object:  Trigger [UpdEntitiesStorage]    Script Date: 07/03/2009 12:57:28 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[ecr].[UpdEntitiesStorage]'))
DROP TRIGGER [ecr].[UpdEntitiesStorage]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(3) BEGIN TRANSACTION END
GO

/****** Object:  Trigger [DelViewsStorage]    Script Date: 07/03/2009 12:58:06 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[ecr].[DelViewsStorage]'))
DROP TRIGGER [ecr].[DelViewsStorage]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(4) BEGIN TRANSACTION END
GO
/****** Object:  Trigger [InsViewsStorage]    Script Date: 07/03/2009 12:58:06 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[ecr].[InsViewsStorage]'))
DROP TRIGGER [ecr].[InsViewsStorage]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(5) BEGIN TRANSACTION END
GO
/****** Object:  Trigger [UpdViewsStorage]    Script Date: 07/03/2009 12:58:06 ******/
IF  EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[ecr].[UpdViewsStorage]'))
DROP TRIGGER [ecr].[UpdViewsStorage]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(6) BEGIN TRANSACTION END
GO

/****** Object:  Trigger [ecr].[DelEntitiesStorage]    Script Date: 07/03/2009 12:57:12 ******/
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
-- Author:		tpg
-- Create date: 10.06.2008
-- Description:	Логирование удалений из таблицы ecr.EntitiesStorage
-- =============================================
CREATE TRIGGER [ecr].[DelEntitiesStorage] 
   ON  [ecr].[EntitiesStorage] 
   AFTER DELETE
AS 
	SET NOCOUNT ON;
insert
	ecr.LogEntitiesStorage
		(
		ID
		, DisplayAlias
		, ItemKey
		, ItemNumber
		, ItemBody
		, HistoryIndex
		, DateLastModified
		, OperationType
		)
	select
		ID
		, DisplayAlias
		, ItemKey
		, ItemNumber
		, ItemBody
		, HistoryIndex
		, DateLastModified
		, 'D'
	from deleted;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(9) BEGIN TRANSACTION END
GO
/****** Object:  Trigger [ecr].[InsEntitiesStorage]    Script Date: 07/03/2009 12:57:12 ******/
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
-- Author:		tpg
-- Create date: 01.07.2008
-- Description:	Логирование вставки в таблицу ecr.EntitiesStorage
-- =============================================
CREATE TRIGGER [ecr].[InsEntitiesStorage] 
   ON  [ecr].[EntitiesStorage] 
   AFTER INSERT
AS 
	SET NOCOUNT ON;
insert
	ecr.LogEntitiesStorage
		(
		ID
		, DisplayAlias
		, ItemKey
		, ItemNumber
		, ItemBody
		, HistoryIndex
		, DateLastModified
		, OperationType
		)
	select
		ID
		, DisplayAlias
		, ItemKey
		, ItemNumber
		, ItemBody
		, HistoryIndex
		, DateLastModified
		, 'I'
	from inserted;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(12) BEGIN TRANSACTION END
GO
/****** Object:  Trigger [ecr].[UpdEntitiesStorage]    Script Date: 07/03/2009 12:57:12 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(13) BEGIN TRANSACTION END
GO
SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(14) BEGIN TRANSACTION END
GO
-- =============================================
-- Author:		tpg
-- Create date: 01.07.2008
-- Description:	Логирование обновления таблицы ecr.EntitiesStorage
-- =============================================
CREATE TRIGGER [ecr].[UpdEntitiesStorage] 
   ON  [ecr].[EntitiesStorage] 
   AFTER UPDATE
AS 
	SET NOCOUNT ON;
insert
	ecr.LogEntitiesStorage
		(
		ID
		, DisplayAlias
		, ItemKey
		, ItemNumber
		, ItemBody
		, HistoryIndex
		, DateLastModified
		, OperationType
		)
	select
		ID
		, DisplayAlias
		, ItemKey
		, ItemNumber
		, ItemBody
		, HistoryIndex
		, DateLastModified
		, 'U'
	from inserted;
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(15) BEGIN TRANSACTION END
GO

/****** Object:  Trigger [ecr].[DelViewsStorage]    Script Date: 07/03/2009 12:58:30 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(16) BEGIN TRANSACTION END
GO
SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(17) BEGIN TRANSACTION END
GO
-- =============================================
-- Author:		tpg
-- Create date: 10.06.2008
-- Description:	Логирование удаления строк из таблицы ecr.ViewsStorage
-- =============================================
CREATE TRIGGER [ecr].[DelViewsStorage] ON  [ecr].[ViewsStorage] 
   AFTER DELETE
AS 
	SET NOCOUNT ON;

insert
	ecr.LogViewsStorage
		(
		ID
		, DisplayAlias
		, ItemKey
		, ItemNumber
		, ItemBody
		, OperationType
		)
	select
		ID
		, DisplayAlias
		, ItemKey
		, ItemNumber
		, ItemBody
		, 'D'
	from deleted;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(18) BEGIN TRANSACTION END
GO
/****** Object:  Trigger [ecr].[InsViewsStorage]    Script Date: 07/03/2009 12:58:30 ******/
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
-- Author:		tpg
-- Create date: 01.07.2008
-- Description:	
-- =============================================
CREATE TRIGGER [ecr].[InsViewsStorage] 
   ON  [ecr].[ViewsStorage] 
   AFTER INSERT
AS 
SET NOCOUNT ON;

insert
	ecr.LogViewsStorage
		(
		ID
		, DisplayAlias
		, ItemKey
		, ItemNumber
		, ItemBody
		, OperationType
		)
	select
		ID
		, DisplayAlias
		, ItemKey
		, ItemNumber
		, ItemBody
		, 'I'
	from inserted;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(21) BEGIN TRANSACTION END
GO
/****** Object:  Trigger [ecr].[UpdViewsStorage]    Script Date: 07/03/2009 12:58:30 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(22) BEGIN TRANSACTION END
GO
SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(23) BEGIN TRANSACTION END
GO
-- =============================================
-- Author:		tpg
-- Create date: 01.07.2008
-- Description:	
-- =============================================
CREATE TRIGGER [ecr].[UpdViewsStorage] 
   ON  [ecr].[ViewsStorage] 
   AFTER UPDATE
AS 
SET NOCOUNT ON;

insert
	ecr.LogViewsStorage
		(
		ID
		, DisplayAlias
		, ItemKey
		, ItemNumber
		, ItemBody
		, OperationType
		)
	select
		ID
		, DisplayAlias
		, ItemKey
		, ItemNumber
		, ItemBody
		, 'U'
	from inserted;
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(24) BEGIN TRANSACTION END
GO


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(25) BEGIN TRANSACTION END
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
