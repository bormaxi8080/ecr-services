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
    @OldVersion = N'1.2.8.14'
    , @NewVersion = N'1.2.9.15'
    , @Description = left(N'Обновление объектов отчетности', 255);
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

PRINT N'Creating [ecr].[FileContentReportByRegion_Goods]'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(1) BEGIN TRANSACTION END
GO
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
    ,ru.Name FileContentResponsibilityUserName
    ,convert(int, 0) as BooksCoversFace
    ,convert(int, 0) as BooksAnnots
    ,convert(int, 0) as BooksContents
    ,gg.CardStatusId
    ,@@spid as Session
  from 
    BKKM.Goods.Goods gg 
    left join BKKM.Rights.Users ru
    on gg.FileContentResponsibility = ru.ID
    join BKKM.Refers.WareCardStatuses st 
    on st.Id = gg.CardStatusId and 
       st.StatusName='DONE'
    left join BKKM.Goods.ChangesLog cl
    on gg.ID = cl.GoodID and 
       cl.FieldID = BKKM.Metadata.GetFieldID('Goods', 'CardStatus') and
       cl.NewValue = 'DONE'
    left join BKKM.Rights.Departments rd
        on ru.DepartmentID = rd.ID
  where 
    (rd.Code = @RegionCode)and
    (cl.Date <= @StartDate)and
    (cl.Date > @EndDate)


  exec ecr.UpdateContentCountByType
     @contentType = 'Books.Covers.Face'
    ,@fieldName = 'BooksCoversFace'
    ,@buffTableName = 'ecr.FileContentReportBuffTable_Goods'
   
  exec ecr.UpdateContentCountByType
     @contentType = 'Books.Annots'
    ,@fieldName = 'BooksAnnots'
    ,@buffTableName = 'ecr.FileContentReportBuffTable_Goods'

  exec ecr.UpdateContentCountByType
     @contentType = 'Books.Contents'
    ,@fieldName = 'BooksContents'
    ,@buffTableName = 'ecr.FileContentReportBuffTable_Goods'

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

  select 
     @str = stg.ConnectionString
    ,@DisplayAlias = ent.DisplayAlias
  from
    ECR_Config.ecr.Entities ent join ECR_Config.ecr.Storages stg
    on ent.StorageID = stg.ID
  where
    ent.SystemName = @contentType

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
      and(estg.DisplayAlias = @DisplayAlias)
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
  
  exec sp_executesql 
    @redCode ,
    N'@DisplayAlias int', 
    @DisplayAlias = @DisplayAlias
END
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