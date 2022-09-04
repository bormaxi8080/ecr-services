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
    @OldVersion = N'1.2.15.21'
    , @NewVersion = N'1.2.16.22'
    , @Description = left(N'обновление хранимки [ecr].[GetContentCountByTypeAndTime]', 255);
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
-- ========================================================================================
-- Author:    Горбачев Александр
-- Create date: 22 мая 2009
-- Description: Процедура обновляет указанное поле 
--    временной таблицы #warekeys, проставляя 
--    количество загруженных файлов в соответствии
--    с указынным типом контента за указанный период
--   @contentType nvarchar(100)   - тип контента
--   @buffTableName nvarchar(100) - имя таблицы #warekeys
--   @fieldName nvarchar(100)   - имя поля в #warekeys
--   @StartDate datetime      - начальная дата
--   @EndDate datetime        - конечная дата
-- ========================================================================================
ALTER PROCEDURE [ecr].[GetContentCountByTypeAndTime]
    @contentType nvarchar(100)    -- тип контента
   ,@buffTableName nvarchar(100)  -- имя таблицы #warekeys
   ,@fieldName nvarchar(100)    -- имя поля в #warekeys
   ,@StartDate datetime       -- начальная дата
   ,@EndDate datetime       -- конечная дата
AS
BEGIN
  set nocount on

  declare
     @DataBase nvarchar(100)
    ,@ServerName nvarchar(100)
    ,@index int
    ,@str nvarchar(max)
    ,@DisplayAlias int
    ,@redCode nvarchar(max)
    ,@Result int
    ,@Enabled bit

  select 
     @str = stg.ConnectionString
    ,@DisplayAlias = ent.DisplayAlias
    ,@Enabled = stg.Enabled
  from
    ECR_Config.ecr.Entities ent join ECR_Config.ecr.Storages stg
    on ent.StorageID = stg.ID
  where
    ent.SystemName = @contentType

  if @Enabled = 1 
  begin
    set @index = charindex('Initial Catalog=', @str)
    set @DataBase = stuff(@str, 1, @index + 15, '')
    set @index = charindex(';', @DataBase)
    set @DataBase = left(@DataBase, @index - 1)

    set @index = charindex('Data Source=', @str)
    set @ServerName = stuff(@str, 1, @index + 11, '')
    set @index = charindex(';', @ServerName)
    set @ServerName = left(@ServerName, @index - 1)

    set @redCode = N'
    declare @count int
    
    select
     log.ItemKey 
    ,log.ItemNumber
    into
    #log
    from 
    <ECR_Storage_DATABASENAME>.ecr.LogViewsStorage log join <warekeys_buffTableName> w 
      on (log.ItemKey = w.WareKey collate Cyrillic_General_CI_AS)
    where
    log.OperationType = ''I'' and
    log.OperationDate > ''<@StartDate>'' and
    log.OperationDate <= ''<@EndDate>''

    select
     WareKey = ItemKey 
    ,<warekeys_fieldName> = count(distinct IsNull(ItemNumber, -1))
    into
     #buff
    from
    #log
    group by 
    ItemKey

    update
    w
    set
    w.<warekeys_fieldName> = b.<warekeys_fieldName>
    from 
    #buff b join <warekeys_buffTableName> w 
      on b.WareKey = w.WareKey collate Cyrillic_General_CI_AS
    where 
    w.Session = @@spid
    '

    set @redCode = replace(@redCode, N'<ECR_Storage_DATABASENAME>', @DataBase)
    set @redCode = replace(@redCode, N'<ECR_Storage_SERVERNAME>.', @ServerName)
    set @redCode = replace(@redCode, N'<warekeys_fieldName>', @fieldName)
    set @redCode = replace(@redCode, N'<warekeys_buffTableName>', @buffTableName)
    set @redCode = replace(@redCode, N'<@DisplayAlias>', convert(nvarchar(10), @DisplayAlias))
    set @redCode = replace(@redCode, N'<@StartDate>', convert(nvarchar(100), @StartDate, 120))
    set @redCode = replace(@redCode, N'<@EndDate>', convert(nvarchar(100), @EndDate, 120))
    
    exec sp_executesql 
    @redCode ,
    N'@DisplayAlias int', 
    @DisplayAlias = @DisplayAlias
  end   
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(1) BEGIN TRANSACTION END
GO


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(2) BEGIN TRANSACTION END
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
