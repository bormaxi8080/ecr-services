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
    @OldVersion = N'1.2.17.23'
    , @NewVersion = N'1.2.18.24'
    , @Description = left(N'Добавление в отчет по ФК остальных полей', 255);
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
PRINT N'Altering table ecr.FileContentReportBuffTable_Goods'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(1) BEGIN TRANSACTION END
GO
if object_id('ecr.FileContentReportBuffTable_Goods') is not null
begin
  if COLUMNPROPERTY(OBJECT_ID(N'ecr.FileContentReportBuffTable_Goods'), N'BooksCoversStuff', 'AllowsNull') is NULL
  begin
    ALTER TABLE ecr.FileContentReportBuffTable_Goods ADD BooksCoversStuff int NULL 
  end
  if COLUMNPROPERTY(OBJECT_ID(N'ecr.FileContentReportBuffTable_Goods'), N'BooksRoots', 'AllowsNull') is NULL
  begin
    ALTER TABLE ecr.FileContentReportBuffTable_Goods ADD BooksRoots int NULL 
  end
  if COLUMNPROPERTY(OBJECT_ID(N'ecr.FileContentReportBuffTable_Goods'), N'BooksContentsJPEG', 'AllowsNull') is NULL
  begin
    ALTER TABLE ecr.FileContentReportBuffTable_Goods ADD BooksContentsJPEG int NULL 
  end
  if COLUMNPROPERTY(OBJECT_ID(N'ecr.FileContentReportBuffTable_Goods'), N'BooksCenterfolds', 'AllowsNull') is NULL
  begin
    ALTER TABLE ecr.FileContentReportBuffTable_Goods ADD BooksCenterfolds int NULL 
  end
  if COLUMNPROPERTY(OBJECT_ID(N'ecr.FileContentReportBuffTable_Goods'), N'BooksIllustrations', 'AllowsNull') is NULL
  begin
    ALTER TABLE ecr.FileContentReportBuffTable_Goods ADD BooksIllustrations int NULL 
  end
end
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(2) BEGIN TRANSACTION END
GO

PRINT N'Altering [ecr].[FileContentReportByRegion_Goods]'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(3) BEGIN TRANSACTION END
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
      
      ,BooksCoversStuff   int --Обложки книг - задняя часть
      ,BooksRoots     int --Корешки книг
      ,BooksContentsJPEG  int --Оглавления книг (формат JPEG)(содержание)
      ,BooksCenterfolds   int --Развороты (тексты из книг)(внутренние страницы)
      ,BooksIllustrations int --Иллюстрации из книг
      
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
    
    ,BooksCoversStuff
    ,BooksRoots   
    ,BooksContentsJPEG
    ,BooksCenterfolds
    ,BooksIllustrations
    
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
    
    ,convert(int, 0) as BooksCoversStuff
    ,convert(int, 0) as BooksRoots    
    ,convert(int, 0) as BooksContentsJPEG
    ,convert(int, 0) as BooksCenterfolds
    ,convert(int, 0) as BooksIllustrations
    
    ,gg.CardStatusId
    ,@@spid as Session
  from BKKM.Goods.ChangesLog as cl
      left join BKKM.Rights.Users            as ru on cl.userid = ru.id
      left join BKKM.goods.goods             as gg on cl.GoodID = gg.ID
      left join BKKM.Rights.Departments    as rd on cl.departmentid = rd.ID
      left join BKKM.Refers.WareCardStatuses as st on st.Id = gg.CardStatusId
  where cl.fieldid = BKKM.Metadata.GetFieldID('Goods', 'FileContentResponsibilityUserName')
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

  exec ecr.[GetContentCountByTypeAndTime]
     @contentType = 'Books.Covers.Stuff'
    ,@fieldName = 'BooksCoversStuff'
    ,@buffTableName = 'ecr.FileContentReportBuffTable_Goods'
    ,@StartDate = @StartDate
    ,@EndDate = @EndDate
    
  exec ecr.[GetContentCountByTypeAndTime]
     @contentType = 'Books.Roots'
    ,@fieldName = 'BooksRoots'
    ,@buffTableName = 'ecr.FileContentReportBuffTable_Goods'
    ,@StartDate = @StartDate
    ,@EndDate = @EndDate
    
  exec ecr.[GetContentCountByTypeAndTime]
     @contentType = 'Books.Contents.JPEG'
    ,@fieldName = 'BooksContentsJPEG'
    ,@buffTableName = 'ecr.FileContentReportBuffTable_Goods'
    ,@StartDate = @StartDate
    ,@EndDate = @EndDate
    
  exec ecr.[GetContentCountByTypeAndTime]
     @contentType = 'Books.Centerfolds'
    ,@fieldName = 'BooksCenterfolds'
    ,@buffTableName = 'ecr.FileContentReportBuffTable_Goods'
    ,@StartDate = @StartDate
    ,@EndDate = @EndDate
    
  exec ecr.[GetContentCountByTypeAndTime]
     @contentType = 'Books.Illustrations'
    ,@fieldName = 'BooksIllustrations'
    ,@buffTableName = 'ecr.FileContentReportBuffTable_Goods'
    ,@StartDate = @StartDate
    ,@EndDate = @EndDate
    
  set @SesID = @@spid

  set nocount off
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
