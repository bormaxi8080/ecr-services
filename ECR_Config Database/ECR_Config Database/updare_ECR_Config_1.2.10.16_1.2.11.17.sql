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
    @OldVersion = N'1.2.10.16'
    , @NewVersion = N'1.2.11.17'
    , @Description = left(N'Учитывается Enabled свойство у Storage, переделаны хранимки с учетом новых требований.', 255);
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

PRINT N'Altering [ecr].[FileContentReportByRegion_Goods]'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(1) BEGIN TRANSACTION END
GO
-- =============================================
-- Author:    Горбачев А.В.
-- Create date: 04.06.2009
-- Description: Возвращает отчет по файловому контенту
--        по коду региона и временному периоду
-- =============================================
ALTER PROCEDURE [ecr].[FileContentReportByRegion_Goods]
   @RegionCode varchar(10) -- код региона
  ,@StartDate datetime -- начальная дата
  ,@EndDate datetime -- конечная дата
  ,@SesID int output -- ид сессии
AS
BEGIN
  set nocount on

  if object_id('ecr.FileContentReportBuffTable_Goods') is null
  begin
    create table ecr.FileContentReportBuffTable_Goods
    (
       Date datetime
      ,WareKey nvarchar(255)
      ,StatusName nvarchar(255)
      ,FileContentResponsibilityUserName nvarchar(255)
      ,BooksCoversFace int
      ,BooksAnnots int
      ,BooksContents int 
      ,CardStatusId int
      ,Session smallint
    )
  end
  
  delete from ecr.FileContentReportBuffTable_Goods where Session = @@spid

  insert into ecr.FileContentReportBuffTable_Goods(
     Date
    ,WareKey
    ,StatusName
    ,FileContentResponsibilityUserName
    ,BooksCoversFace
    ,BooksAnnots
    ,BooksContents
    ,CardStatusId
    ,Session)
  select 
     cl.Date
    ,gg.WareKey
    ,st.StatusName
    ,rd.Name + '(' + ru.Name + ')' FileContentResponsibilityUserName
    ,convert(int, 0) as BooksCoversFace
    ,convert(int, 0) as BooksAnnots
    ,convert(int, 0) as BooksContents
    ,gg.CardStatusId
    ,@@spid as Session
  from BKKM.Goods.ChangesLog as cl
      left join BKKM.Rights.Users            as ru on cl.userid = ru.id
      left join BKKM.goods.goods             as gg on cl.GoodID = gg.ID
      left join BKKM.Rights.Departments    as rd on cl.departmentid = rd.ID
      left join BKKM.Refers.WareCardStatuses as st on st.Id = gg.CardStatusId
  where cl.fieldid = BKKM.Metadata.GetFieldID('Goods', 'FileContentResponsibilityUserName')
      and cl.oldvalue is null
      and cl.newvalue is not null
      and rd.Code = @RegionCode
      and cl.Date < @EndDate
      and cl.Date >= @StartDate


  --exec ecr.UpdateContentCountByType
  exec ecr.[GetContentCountByTypeAndTime]
     @contentType = 'Books.Covers.Face'
    ,@fieldName = 'BooksCoversFace'
    ,@buffTableName = 'ecr.FileContentReportBuffTable_Goods'
    ,@StartDate = @StartDate
    ,@EndDate = @EndDate
   
  --exec ecr.UpdateContentCountByType
  exec ecr.[GetContentCountByTypeAndTime]
     @contentType = 'Books.Annots'
    ,@fieldName = 'BooksAnnots'
    ,@buffTableName = 'ecr.FileContentReportBuffTable_Goods'
    ,@StartDate = @StartDate
    ,@EndDate = @EndDate

  --exec ecr.UpdateContentCountByType
  exec ecr.[GetContentCountByTypeAndTime]
     @contentType = 'Books.Contents'
    ,@fieldName = 'BooksContents'
    ,@buffTableName = 'ecr.FileContentReportBuffTable_Goods'
    ,@StartDate = @StartDate
    ,@EndDate = @EndDate

  set @SesID = @@spid

  set nocount off
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(2) BEGIN TRANSACTION END
GO


PRINT N'Altering [ecr].[UpdateContentCountByType]'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(3) BEGIN TRANSACTION END
GO
-- =============================================
-- Author:    Горбачев Александр
-- Create date: 22 мая 2009
-- Description: Процедура обновляет указанное поле 
--    временной таблицы #warekeys, проставляя 
--    количество загруженных файлов в соответствии
--    с указынным типом контента
--   @contentType nvarchar(100) - тип контента
--   @fieldName nvarchar(100) - имя поля в #warekeys
-- =============================================
ALTER PROCEDURE [ecr].[UpdateContentCountByType]
     @contentType nvarchar(100)
  ,@fieldName nvarchar(100)
  ,@buffTableName nvarchar(100)
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
    --set @ServerName = ''

    set @redCode = N'
    select
     WareKey = estg.ItemKey 
    ,<warekeys_fieldName> = count(distinct IsNull(estg.ItemNumber, -1))
    into
    #buff
    from 
    <ECR_Storage_DATABASENAME>.ecr.ViewsStorage/*EntitiesStorage*/ estg join <warekeys_buffTableName> w 
      on (estg.ItemKey = w.WareKey collate Cyrillic_General_CI_AS)
      and(estg.DisplayAlias = <@DisplayAlias>)
    group by
    estg.ItemKey

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
    
    exec sp_executesql 
    @redCode ,
    N'@DisplayAlias int', 
    @DisplayAlias = @DisplayAlias
  end   
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(4) BEGIN TRANSACTION END
GO


PRINT N'Creating [ecr].[GetContentCountByTypeAndTime]'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(5) BEGIN TRANSACTION END
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
CREATE PROCEDURE [ecr].[GetContentCountByTypeAndTime]
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
    --set @ServerName = ''

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
      and(log.DisplayAlias = <@DisplayAlias>)
    where
    log.OperationType = ''I'' and
    log.OperationDate > ''<@StartDate>'' and
    log.OperationDate <= ''<@EndDate>''

    select @count = count(*) from #log
    print ''log: '' + convert(nvarchar(10), @count)

    select
     WareKey = ItemKey 
    ,<warekeys_fieldName> = count(distinct IsNull(ItemNumber, -1))
    into
     #buff
    from
    #log
    group by 
    ItemKey

    select @count = count(*) from #buff
    print ''buff: '' + convert(nvarchar(10), @count)
    
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
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(6) BEGIN TRANSACTION END
GO


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(7) BEGIN TRANSACTION END
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
