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
    @OldVersion = N'1.1.3.11'
    , @NewVersion = N'1.1.4.12'
    , @Description = left(N'Исправление ошибок в хранимой процедуре ecr.UpdateEntityItem', 255);
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
/****** Object:  StoredProcedure [ecr].[UpdateEntityItem]    Script Date: 02/10/2010 21:38:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[UpdateEntityItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[UpdateEntityItem]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(1) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[UpdateEntityItem]    Script Date: 02/10/2010 21:38:41 ******/
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
	@ItemBody varbinary(max) = NULL
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
	--if @ItemBody is null
	--	begin
	--		exec ecr.[DeleteItem] 
	--			@DisplayAlias
	--			, @ItemKey
	--			, @ItemNumber;
	--		return;
	--	end

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
			
			-- добавляем сущность в хранилисче
			if @ItemNumber is null begin
			
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
				where DisplayAlias = @DisplayAlias
					and ItemKey = @ItemKey
					and ItemNumber is null;
				
			end
			else begin
			
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
				where DisplayAlias = @DisplayAlias
					and ItemKey = @ItemKey
					and ItemNumber = @ItemNumber;
			
			end
				
			DECLARE @LT int;
			if @ItemNumber is null begin
				set @LT = (
					select count(*)
					from ecr.EntitiesStorage
					where DisplayAlias = @DisplayAlias
						and ItemKey = @ItemKey
						and ItemNumber is null
				);
			end
			else begin
				set @LT = (
					select count(*)
					from ecr.EntitiesStorage
					where DisplayAlias = @DisplayAlias
						and ItemKey = @ItemKey
						and ItemNumber = @ItemNumber
				);
			end
				
			-- Если число хранений превысило допустимое
			if @HistoryLifeTime < @LT									
				-- , то:
				
				if @ItemNumber is null begin
					
					-- удаляем самую самую старую версию файла
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
							and es.ItemKey = @ItemKey
							and es.ItemNumber is null
							and es.HistoryIndex = a.min_HistoryIndex;
					
					-- и очищаем лог от удаленной строки!!! Бля так и никак иначе!!! Сцуко...
					delete
					les
					from ecr.LogEntitiesStorage les
						inner join @Del d on les.ID = d.ID
						and DisplayAlias = @DisplayAlias
						and ItemKey = @ItemKey
						and ItemNumber is null;	
							
				end
				else begin
				
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
							and es.ItemKey = @ItemKey
							and es.ItemNumber = @ItemNumber
							and es.HistoryIndex = a.min_HistoryIndex;
							
					delete
					les
					from ecr.LogEntitiesStorage les
						inner join @Del d on les.ID = d.ID
						and DisplayAlias = @DisplayAlias
						and ItemKey = @ItemKey
						and ItemNumber =@ItemNumber;
				
				end

		end
	
	-- Если по сущности история не ведется
	else
		begin
			
			if @ItemNumber is null begin
			
				-- обновляем сущность в хронилеще
				update
					ecr.EntitiesStorage with(updlock)
				set
					ItemKey = @ItemKey
					, ItemBody = @ItemBody
					, HistoryIndex = 0
				where DisplayAlias = @DisplayAlias
					and ItemKey = @ItemKey
					and ItemNumber is null;
					
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
									and ItemKey = @ItemKey
									and ItemNumber is null
								)
			
			end
			
			else begin
			
				update
					ecr.EntitiesStorage with(updlock)
				set
					ItemKey = @ItemKey
					, ItemBody = @ItemBody
					, HistoryIndex = 0
				where DisplayAlias = @DisplayAlias
					and ItemKey = @ItemKey
					and ItemNumber = @ItemNumber;
					
				if @@rowcount = 0
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
									and ItemKey = @ItemKey
									and ItemNumber = @ItemNumber
								)
			
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
	return 1;
end catch;


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(4) BEGIN TRANSACTION END
GO







GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(5) BEGIN TRANSACTION END
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
