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
    @OldVersion = N'1.2.22.28'
    , @NewVersion = N'1.2.23.29'
    , @Description = left(N'Протяжка дополнительных хранимых процедур схемыcfm из базы данных CFMGate', 255);
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

/****** Object:  StoredProcedure [cfm].[AddSourceCatalog]    Script Date: 12/01/2009 15:50:27 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(1) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(2) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		tpg
-- Create date: 09.09.2008
-- Description:	Процедура загрузки очереди закачки из переданного XML-документа.
-- =============================================
CREATE PROCEDURE [cfm].[AddSourceCatalog]
	@XmlStr xml
AS
SET NOCOUNT ON;

declare @d int
declare @t table
			(
			MessageNo int
			, ObjectGUID uniqueidentifier
			, CreationTime datetime
			, KeyType nvarchar(20)
			, [Identity] nvarchar(128)
			, ParentIdentity nvarchar(128)
			, ItemKey nvarchar(50)
			, ItemNumber int
			, ItemBody varbinary(max)
			, Encoding nvarchar(20)
			, Extension nvarchar(255)
			)

declare @ErrMsg nvarchar(4000)

begin try
	-- Парсим входной документ
	exec sp_xml_preparedocument @d out, @XmlStr;
	-- Вставляем содержимое документа в промежуточную таблицу
	insert
		@t
	select
		*
	from openxml (@d, 'Message/Object', 2)
				with
				(
				MessageNo int '../@MessageNo'
				, ObjectGUID uniqueidentifier '@ObjectGUID'
				, CreationTime datetime '@CreationTime'
				, KeyType nvarchar(20) '@KeyType'
				, [Identity] nvarchar(128) '@Identity'
				, ParentIdentity nvarchar(128) '@ParentIdentity'
				, ItemKey nvarchar(50) '@ItemKey'
				, ItemNumber int '@ItemNumber'
				, ItemBody varbinary(max) '@ItemBody'
				, Encoding nvarchar(20) '@Encoding'
				, Extension nvarchar(255) '@Extension'
				);
	-- и уничтожаем документ в памяти
	exec sp_xml_removedocument @d;
	-- Если в документе были переданы объекты, уже загруженные ранее в базу
	if exists
			(
			select
				*
			from @t t
			inner join cfm.ItemsQueue q on t.ObjectGUID = q.ObjectGUID
			)
		-- поднимаем сообщение об ошибке с последующим завершением процедуры
		raiserror(N'Был принят документ с ранее уже обработанным объектом!', 16, 1);
	-- Если всё нормально, загружаем данные из промежуточной таблицы в целевую
	insert
		cfm.ItemsQueue
			(
			MessageNo
			, ObjectGUID
			, CreationTime
			, KeyType
			, [Identity]
			, ParentIdentity
			, ItemKey
			, ItemNumber
			, ItemBody
			, Encoding
			, Extension
			)
		select
			*
		from @t;
			

end try
	-- Обработчик ошибок:
begin catch

	-- Если транзакция открыта, то откатываем транзакцию;
	if @@trancount <> 0 rollback tran;
	-- Если дискриптор документа существует, уничтожаем XML-документ
	if @d > 0 exec sp_xml_removedocument @d;
	
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
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(3) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [cfm].[DeleteSourceCatalog]    Script Date: 12/01/2009 15:50:27 ******/
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
-- Author:		MX
-- Create date: 07.02.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [cfm].[DeleteSourceCatalog] 
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
		DELETE FROM [cfm].[SourceCatalogs] WHERE SystemName = @SystemName
	end
	else begin
		DELETE FROM [cfm].[SourceCatalogs] WHERE SystemName = @SystemName AND InstanceName = @InstanceName
	end

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(6) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [cfm].[GetSourceCatalog]    Script Date: 12/01/2009 15:50:27 ******/
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
-- Author:		MX
-- Create date: 07.02.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [cfm].[GetSourceCatalog] 
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
		SELECT * FROM [cfm].[SourceCatalogs] WHERE SystemName = @SystemName	
	end
	else begin
		SELECT * FROM [cfm].[SourceCatalogs] WHERE SystemName = @SystemName AND InstanceName = @InstanceName
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
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(9) BEGIN TRANSACTION END
GO




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(10) BEGIN TRANSACTION END
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
