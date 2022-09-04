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
    @OldVersion = N'1.1.4.12'
    , @NewVersion = N'1.1.5.13'
    , @Description = left(N'Добавление процедуры ecr.GetViewItemBody, исправление ошибок', 255);
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
/****** Object:  StoredProcedure [ecr].[GetViewItem]    Script Date: 04/06/2010 19:36:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetViewItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetViewItem]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(1) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewItemBody]    Script Date: 04/06/2010 19:53:24 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(2) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(3) BEGIN TRANSACTION END
GO

create procedure [ecr].[GetViewItemBody] 
    @DisplayAlias int
    , @ItemKey nvarchar(50)
    , @ItemNumber int = null
as 
begin

	if not exists
			(
			select
				*
			from ecr.Views	--dbo.ecr_ContentViews
			where DisplayAlias = @DisplayAlias
			)
		raiserror(N'Ошибка: нет данных о представлении контента в целевом хранилище', 10, 1);
		
	if @ItemNumber is null
		select ItemBody from ecr.ViewsStorage 
        where DisplayAlias = @DisplayAlias
			and ItemKey = @ItemKey 
			and ItemNumber is null;
	else begin
		select ItemBody from ecr.ViewsStorage 
        where DisplayAlias = @DisplayAlias
			and ItemKey = @ItemKey 
			and ItemNumber = @DisplayAlias;
	end;
   
end

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(4) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewItem]    Script Date: 04/06/2010 19:41:35 ******/
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

-- =============================================
-- Author:		MX
-- Create date: 05.02.2008
-- Description:	Процедура получения данных об элементе представления файлового контента по заданным параметрам.
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
		where DisplayAlias = @DisplayAlias and 
			ItemKey = @ItemKey and
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
					and DisplayAlias = @DisplayAlias
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
					DisplayAlias = @DisplayAlias and
					ItemNumber = @ItemNumber;
		end

end try

-- Обработчик ошибок:
begin catch
	return 1;
end catch;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(7) BEGIN TRANSACTION END
GO


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(8) BEGIN TRANSACTION END
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
