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
    @OldVersion = N'1.3.2.31'
    , @NewVersion = N'1.3.3.32'
    , @Description = left(N'Сведение хранимых процедур', 255);
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
/****** Object:  StoredProcedure [cfm].[AddSourceCatalog]    Script Date: 02/10/2010 20:26:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cfm].[AddSourceCatalog]') AND type in (N'P', N'PC'))
DROP PROCEDURE [cfm].[AddSourceCatalog]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(1) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [cfm].[DeleteSourceCatalog]    Script Date: 02/10/2010 20:26:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cfm].[DeleteSourceCatalog]') AND type in (N'P', N'PC'))
DROP PROCEDURE [cfm].[DeleteSourceCatalog]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(2) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [cfm].[GetSourceCatalog]    Script Date: 02/10/2010 20:26:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[cfm].[GetSourceCatalog]') AND type in (N'P', N'PC'))
DROP PROCEDURE [cfm].[GetSourceCatalog]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(3) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [dbo].[adm_DefragmentationIndexes]    Script Date: 02/10/2010 20:26:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[adm_DefragmentationIndexes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[adm_DefragmentationIndexes]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(4) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [dbo].[GetCurrentVersion]    Script Date: 02/10/2010 20:26:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetCurrentVersion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetCurrentVersion]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(5) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [dbo].[GetVersionHistory]    Script Date: 02/10/2010 20:26:57 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[GetVersionHistory]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[GetVersionHistory]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(6) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CheckBindingExists]    Script Date: 02/10/2010 20:26:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[CheckBindingExists]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[CheckBindingExists]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(7) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CheckBindingExistsA]    Script Date: 02/10/2010 20:26:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[CheckBindingExistsA]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[CheckBindingExistsA]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(8) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CheckEntityExists]    Script Date: 02/10/2010 20:26:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[CheckEntityExists]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[CheckEntityExists]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(9) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CheckEntityExistsA]    Script Date: 02/10/2010 20:26:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[CheckEntityExistsA]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[CheckEntityExistsA]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(10) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CheckStorageExists]    Script Date: 02/10/2010 20:26:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[CheckStorageExists]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[CheckStorageExists]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(11) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CheckStorageExistsA]    Script Date: 02/10/2010 20:26:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[CheckStorageExistsA]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[CheckStorageExistsA]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(12) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CheckViewExists]    Script Date: 02/10/2010 20:26:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[CheckViewExists]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[CheckViewExists]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(13) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CheckViewExistsA]    Script Date: 02/10/2010 20:26:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[CheckViewExistsA]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[CheckViewExistsA]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(14) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[DeleteSourceCatalog]    Script Date: 02/10/2010 20:26:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[DeleteSourceCatalog]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[DeleteSourceCatalog]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(15) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[FileContentReportByRegion_Goods]    Script Date: 02/10/2010 20:26:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[FileContentReportByRegion_Goods]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[FileContentReportByRegion_Goods]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(16) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[FileContentReportByRegion_Goods_Everyday]    Script Date: 02/10/2010 20:26:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[FileContentReportByRegion_Goods_Everyday]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[FileContentReportByRegion_Goods_Everyday]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(17) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetBinaryResource]    Script Date: 02/10/2010 20:26:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetBinaryResource]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetBinaryResource]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(18) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetBindingAliasByName]    Script Date: 02/10/2010 20:26:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetBindingAliasByName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetBindingAliasByName]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(19) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetBindingByAlias]    Script Date: 02/10/2010 20:26:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetBindingByAlias]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetBindingByAlias]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(20) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetBindingByID]    Script Date: 02/10/2010 20:26:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetBindingByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetBindingByID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(21) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetBindingByName]    Script Date: 02/10/2010 20:26:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetBindingByName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetBindingByName]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(22) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetBindingByUID]    Script Date: 02/10/2010 20:26:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetBindingByUID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetBindingByUID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(23) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetBindingChilds]    Script Date: 02/10/2010 20:26:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetBindingChilds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetBindingChilds]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(24) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetBindingNameByAlias]    Script Date: 02/10/2010 20:26:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetBindingNameByAlias]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetBindingNameByAlias]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(25) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetBindingNameByID]    Script Date: 02/10/2010 20:26:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetBindingNameByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetBindingNameByID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(26) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetBindingNameByUID]    Script Date: 02/10/2010 20:26:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetBindingNameByUID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetBindingNameByUID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(27) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetBindingsList]    Script Date: 02/10/2010 20:26:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetBindingsList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetBindingsList]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(28) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetContentCountByTypeAndTime]    Script Date: 02/10/2010 20:26:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetContentCountByTypeAndTime]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetContentCountByTypeAndTime]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(29) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityAliasByName]    Script Date: 02/10/2010 20:26:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetEntityAliasByName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetEntityAliasByName]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(30) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityByAlias]    Script Date: 02/10/2010 20:26:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetEntityByAlias]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetEntityByAlias]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(31) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityByID]    Script Date: 02/10/2010 20:26:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetEntityByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetEntityByID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(32) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityByName]    Script Date: 02/10/2010 20:26:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetEntityByName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetEntityByName]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(33) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityByUID]    Script Date: 02/10/2010 20:26:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetEntityByUID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetEntityByUID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(34) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityChilds]    Script Date: 02/10/2010 20:26:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetEntityChilds]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetEntityChilds]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(35) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityList]    Script Date: 02/10/2010 20:26:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetEntityList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetEntityList]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(36) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityNameByAlias]    Script Date: 02/10/2010 20:26:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetEntityNameByAlias]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetEntityNameByAlias]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(37) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityNameByID]    Script Date: 02/10/2010 20:26:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetEntityNameByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetEntityNameByID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(38) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityNameByUID]    Script Date: 02/10/2010 20:26:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetEntityNameByUID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetEntityNameByUID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(39) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetLastProcessedMessageNo]    Script Date: 02/10/2010 20:26:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetLastProcessedMessageNo]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetLastProcessedMessageNo]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(40) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetSourceCatalog]    Script Date: 02/10/2010 20:26:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetSourceCatalog]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetSourceCatalog]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(41) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetStorageAliasByName]    Script Date: 02/10/2010 20:26:59 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetStorageAliasByName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetStorageAliasByName]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(42) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetStorageByAlias]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetStorageByAlias]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetStorageByAlias]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(43) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetStorageByID]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetStorageByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetStorageByID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(44) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetStorageByName]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetStorageByName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetStorageByName]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(45) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetStorageByUID]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetStorageByUID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetStorageByUID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(46) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetStorageForEntity]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetStorageForEntity]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetStorageForEntity]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(47) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetStorageForView]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetStorageForView]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetStorageForView]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(48) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetStorageList]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetStorageList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetStorageList]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(49) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetStorageNameByAlias]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetStorageNameByAlias]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetStorageNameByAlias]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(50) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetStorageNameByID]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetStorageNameByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetStorageNameByID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(51) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetStorageNameByUID]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetStorageNameByUID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetStorageNameByUID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(52) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewAliasByName]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetViewAliasByName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetViewAliasByName]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(53) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewByAlias]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetViewByAlias]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetViewByAlias]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(54) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewByID]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetViewByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetViewByID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(55) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewByName]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetViewByName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetViewByName]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(56) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewByUID]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetViewByUID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetViewByUID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(57) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewDataByKeys]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetViewDataByKeys]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetViewDataByKeys]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(58) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewList]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetViewList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetViewList]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(59) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewListByBinding]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetViewListByBinding]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetViewListByBinding]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(60) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewNameByAlias]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetViewNameByAlias]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetViewNameByAlias]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(61) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewNameByID]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetViewNameByID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetViewNameByID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(62) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewNameByUID]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetViewNameByUID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetViewNameByUID]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(63) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[IsEntityMultiplied]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[IsEntityMultiplied]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[IsEntityMultiplied]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(64) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[IsStorageEnabled]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[IsStorageEnabled]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[IsStorageEnabled]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(65) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[IsViewEnabled]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[IsViewEnabled]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[IsViewEnabled]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(66) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[IsViewMultiplied]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[IsViewMultiplied]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[IsViewMultiplied]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(67) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[UpdateContentCountByType]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[UpdateContentCountByType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[UpdateContentCountByType]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(68) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[UpdateItemSummary]    Script Date: 02/10/2010 20:27:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[UpdateItemSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[UpdateItemSummary]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(69) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [cfm].[AddSourceCatalog]    Script Date: 02/10/2010 20:27:30 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(70) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(71) BEGIN TRANSACTION END
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
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(72) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [cfm].[DeleteSourceCatalog]    Script Date: 02/10/2010 20:27:30 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(73) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(74) BEGIN TRANSACTION END
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
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(75) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [cfm].[GetSourceCatalog]    Script Date: 02/10/2010 20:27:30 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(76) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(77) BEGIN TRANSACTION END
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
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(78) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [dbo].[adm_DefragmentationIndexes]    Script Date: 02/10/2010 20:27:30 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(79) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(80) BEGIN TRANSACTION END
GO

-- =============================================
-- Authors:		Microsoft Corp., tpg
-- Create date: 01.04.2009
-- Description:	Процедура дефрагментации всех индексов
--				Запускать стоит во время наименьшей нагрузки на сервер
-- =============================================
CREATE procedure [dbo].[adm_DefragmentationIndexes]
as
-- Ensure a USE <databasename> statement has been executed first.
set nocount on;
declare @objectid int;
declare @indexid int;
declare @partitioncount bigint;
declare @schemaname nvarchar(130);
declare @objectname nvarchar(130);
declare @indexname nvarchar(130);
declare @partitionnum bigint;
declare @partitions bigint;
declare @frag float;
declare @command nvarchar(4000);

declare @Retry int;
declare @error_message varchar(8000);
declare @error_severity int;
declare @error_state int;

-- Conditionally select tables and indexes from the sys.dm_db_index_physical_stats function 
-- and convert object and index IDs to names.
select
    object_id as objectid,
    index_id as indexid,
    partition_number as partitionnum,
    avg_fragmentation_in_percent as frag
into #work_to_do
from sys.dm_db_index_physical_stats (db_id(), null, null , null, 'limited')
where avg_fragmentation_in_percent > 10.0
and index_id > 0
and page_count > 8;

-- Declare the cursor for the list of partitions to be processed.
declare partitions cursor for select * from #work_to_do;

-- Open the cursor.
open partitions;

-- Loop through the partitions.
while (1=1)
    begin;
        fetch next
           from partitions
           into @objectid, @indexid, @partitionnum, @frag;
        if @@fetch_status < 0 break;
        select @objectname = quotename(o.name), @schemaname = quotename(s.name)
        from sys.objects as o
        join sys.schemas as s on s.schema_id = o.schema_id
        where o.object_id = @objectid;
        select @indexname = quotename(name)
        from sys.indexes
        where  object_id = @objectid and index_id = @indexid;
        select @partitioncount = count (*)
        from sys.partitions
        where object_id = @objectid and index_id = @indexid;
print @schemaname + '.' + @objectname + '.' + @indexname + ' ==> Partitioncount = ' + cast(@partitioncount as varchar) + ', Frag = ' + cast(@frag as varchar) + '%';

-- 30 is an arbitrary decision point at which to switch between reorganizing and rebuilding.
        if @frag < 20.0	--30.0
            set @command = N'alter index ' + @indexname + N' on ' + @schemaname + N'.' + @objectname + N' reorganize';
        if @frag >= 20.0	--30.0
            set @command = N'alter index ' + @indexname + N' on ' + @schemaname + N'.' + @objectname + N' rebuild with (online = on)';
        if @partitioncount > 1
            set @command = @command + N' partition = ' + cast(@partitionnum as nvarchar(10)) + N';';
		else
			set @command = @command + N';';

		set @Retry = 5;
		while @Retry > 0
		begin
			begin try

				exec sp_executesql @command;
				print N'executed: ' + @command;
				set @Retry = 0;
			end try
			begin catch 
				-- Проверяем номер ошибки.
				-- Если ошибка "жертвы deadlock-а",
				-- понижаем счетчик попыток.
				-- Если ошибка другая,
				-- выходим принудительно из цикла.
				if error_number() = 1205
				and @Retry > 0
					begin
						set @Retry = @Retry - 1;
						waitfor delay '00:00:7';
					end
				else
					begin
						if error_number() = 2725
						and @Retry > 0
							begin
								set @Retry = @Retry - 1;
								set @command = replace(@command, N'with (online = on)', N' ')
								waitfor delay '00:00:7';
							end
						else
							begin
								set @Retry = -1;
								if xact_state() <> 0 rollback tran;
								-- Печатаем информацию об ошибке.
								print
							'Error ' + cast(error_number() as varchar) + ': ' + error_message() + '
, ' + error_severity() + ', ' + error_state ();
								end
					end
			end catch;
		end
    end;
-- Close and deallocate the cursor.
close partitions;
deallocate partitions;

-- Drop the temporary table.
drop table #work_to_do;



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(81) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [dbo].[GetCurrentVersion]    Script Date: 02/10/2010 20:27:30 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(82) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(83) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 27.08.2008
-- Description:	Хранимая процедура возвращает текущую версию базы данных ECR_Config
-- =============================================
CREATE PROCEDURE [dbo].[GetCurrentVersion] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select top 1 [Version] from [dbo].[VersionHistory] order by VersionDate desc, ID desc
	
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(84) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [dbo].[GetVersionHistory]    Script Date: 02/10/2010 20:27:30 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(85) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(86) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 27.08.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[GetVersionHistory] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select ID,
		[Version],
		VersionDate,
		[Description]
	from [dbo].[VersionHistory]
	order by VersionDate desc,
		ID desc

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(87) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CheckBindingExists]    Script Date: 02/10/2010 20:27:30 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(88) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(89) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	Процедура проверяет наличие привязки с заданным системным именем;
-- =============================================
CREATE PROCEDURE [ecr].[CheckBindingExists] 
	-- Add the parameters for the stored procedure here
	@SystemName nvarchar(128)
	, @Exists int = 0 output
AS
	SET NOCOUNT ON;

-- Можно переписать так
if exists
		(
		select
			*
		from ecr.Bindings
		where SystemName = @SystemName
		)
	set @Exists = 1;
else
	set @Exists = 0;


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(90) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CheckBindingExistsA]    Script Date: 02/10/2010 20:27:30 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(91) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(92) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		tpg
-- Create date: 27.08.2008
-- Description:	Процедура проверяет наличие привязки с заданным системным алиасом;
-- =============================================
CREATE PROCEDURE [ecr].[CheckBindingExistsA] 
	@DisplayAlias int
	, @Exists int = 0 output
AS
	SET NOCOUNT ON;

-- Можно переписать так
if exists
		(
		select
			*
		from ecr.Bindings
		where DisplayAlias = @DisplayAlias
		)
	set @Exists = 1;
else
	set @Exists = 0;


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(93) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CheckEntityExists]    Script Date: 02/10/2010 20:27:30 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(94) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(95) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 26.02.2008
-- Description:	Процедура проверяет наличие сущности (типа контента) с заданным системным именем;
-- =============================================
CREATE PROCEDURE [ecr].[CheckEntityExists] 
	-- Add the parameters for the stored procedure here
	@SystemName nvarchar(128)
	, @Exists int = 0 output
AS
	SET NOCOUNT ON;

    -- Insert statements for procedure here

if exists
		(
		select
			*
		from ecr.Entities
		where SystemName = @SystemName
		)
	set @Exists = 1;
else
	set @Exists = 0;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(96) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CheckEntityExistsA]    Script Date: 02/10/2010 20:27:30 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(97) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(98) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		tpg
-- Create date: 27.08.2008
-- Description:	Процедура проверяет наличие привязки с заданным системным алиасом;
-- =============================================
CREATE PROCEDURE [ecr].[CheckEntityExistsA] 
	@DisplayAlias int
	, @Exists int = 0 output
AS
	SET NOCOUNT ON;

-- Можно переписать так
if exists
		(
		select
			*
		from ecr.Entities
		where DisplayAlias = @DisplayAlias
		)
	set @Exists = 1;
else
	set @Exists = 0;


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(99) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CheckStorageExists]    Script Date: 02/10/2010 20:27:30 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(100) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(101) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 26.02.2008
-- Description:	Процедура проверяет наличие хранилища контента с заданным системным именем;
-- =============================================
CREATE PROCEDURE [ecr].[CheckStorageExists] 
	-- Add the parameters for the stored procedure here
	@SystemName nvarchar(128)
	, @Exists int = 0 output
AS
	SET NOCOUNT ON;

-- Можно переписать так
if exists
		(
		select
			*
		from ecr.Storages
		where SystemName = @SystemName
		)
	set @Exists = 1;
else
	set @Exists = 0;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(102) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CheckStorageExistsA]    Script Date: 02/10/2010 20:27:30 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(103) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(104) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		tpg
-- Create date: 27.08.2008
-- Description:	Процедура проверяет наличие привязки с заданным системным алиасом;
-- =============================================
CREATE PROCEDURE [ecr].[CheckStorageExistsA] 
	@DisplayAlias int
	, @Exists int = 0 output
AS
	SET NOCOUNT ON;

-- Можно переписать так
if exists
		(
		select
			*
		from ecr.Storages
		where DisplayAlias = @DisplayAlias
		)
	set @Exists = 1;
else
	set @Exists = 0;


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(105) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CheckViewExists]    Script Date: 02/10/2010 20:27:30 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(106) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(107) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 26.02.2008
-- Description:	Процедура проверяет наличие представления контента с заданным системным именем;
-- =============================================
CREATE PROCEDURE [ecr].[CheckViewExists] 
	-- Add the parameters for the stored procedure here
	@SystemName nvarchar(128)
	, @Exists int = 0 output
AS
set nocount on;
if exists
		(
		select
			*
		from ecr.Views
		where SystemName = @SystemName
		)
	set @Exists = 1;
else
	set @Exists = 0;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(108) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CheckViewExistsA]    Script Date: 02/10/2010 20:27:30 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(109) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(110) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		tpg
-- Create date: 27.08.2008
-- Description:	Процедура проверяет наличие привязки с заданным системным алиасом;
-- =============================================
CREATE PROCEDURE [ecr].[CheckViewExistsA] 
	@DisplayAlias int
	, @Exists int = 0 output
AS
	SET NOCOUNT ON;

-- Можно переписать так
if exists
		(
		select
			*
		from ecr.Views
		where DisplayAlias = @DisplayAlias
		)
	set @Exists = 1;
else
	set @Exists = 0;


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(111) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[DeleteSourceCatalog]    Script Date: 02/10/2010 20:27:30 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(112) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(113) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 07.02.2008
-- Description:	удаление записи об объекте типа SourceCatalog из таблицы ecr.SourceCatalogs
-- =============================================
CREATE PROCEDURE [ecr].[DeleteSourceCatalog] 
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
		DELETE FROM [ecr].[SourceCatalogs] WHERE SystemName = @SystemName
	end
	else begin
		DELETE FROM [ecr].[SourceCatalogs] WHERE SystemName = @SystemName AND InstanceName = @InstanceName
	end

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(114) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[FileContentReportByRegion_Goods]    Script Date: 02/10/2010 20:27:31 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(115) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(116) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:    Горбачев А.В.
-- Create date: 04.06.2009
-- Description: Возвращает отчет по файловому контенту
--        по коду региона и временному периоду
-- =============================================
CREATE PROCEDURE [ecr].[FileContentReportByRegion_Goods]
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
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(117) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[FileContentReportByRegion_Goods_Everyday]    Script Date: 02/10/2010 20:27:31 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(118) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(119) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:    Горбачев А.В.
-- Create date: 04.06.2009
-- Description: Возвращает отчет по файловому контенту
--        по коду региона и временному периоду
-- =============================================
CREATE PROCEDURE [ecr].[FileContentReportByRegion_Goods_Everyday]
   @RegionCode varchar(10) -- код региона
  ,@StartDate datetime -- начальная дата
  ,@EndDate datetime -- конечная дата
  ,@SesID int output -- ид сессии
AS
BEGIN
  set nocount on

  if object_id('ecr.FileContentReportBuffTable_Goods_Everyday') is null
  begin
    create table ecr.FileContentReportBuffTable_Goods_Everyday
    (
       Date datetime
      ,WareKey nvarchar(255)
      ,FileContentResponsibilityUserName nvarchar(255)
      ,Session smallint
    )
  end
  
  delete from ecr.FileContentReportBuffTable_Goods_Everyday where Session = @@spid

  insert into ecr.FileContentReportBuffTable_Goods_Everyday(
     Date
    ,WareKey
    ,FileContentResponsibilityUserName
    ,Session)
  select 
     cl.Date
    ,gg.WareKey
    ,ru.Name FileContentResponsibilityUserName
    ,@@spid as Session
  from BKKM.Goods.ChangesLog as cl
      left join BKKM.Rights.Users            as ru on cl.userid = ru.id
      left join BKKM.goods.goods             as gg on cl.GoodID = gg.ID
      left join BKKM.Rights.Departments    as rd on cl.departmentid = rd.ID
  where 
      cl.fieldid = BKKM.Metadata.GetFieldID('Goods', 'FileContentResponsibilityUserName')
      and cl.newvalue is not null
      and rd.Code = @RegionCode
      and cl.Date < @EndDate
      and cl.Date >= @StartDate

  set @SesID = @@spid

  set nocount off
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(120) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetBinaryResource]    Script Date: 02/10/2010 20:27:31 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(121) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(122) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	Процедура возврщает значение поля ResourceValue из таблицы BinaryResources по заданным параметрам;
--		Таблица BinaryResources применяется для хранения дополнительных бинарных полей объектов таблиц - иконок отображений, картинок и др.
-- =============================================
CREATE PROCEDURE [ecr].[GetBinaryResource] 
	-- Add the parameters for the stored procedure here
	@ResourceName nvarchar(128),
	@ResourceType nvarchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		ResourceValue
	from
		ecr.BinaryResources
	where
		ResourceName = @ResourceName
			and
		ResourceType = @ResourceType

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(123) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetBindingAliasByName]    Script Date: 02/10/2010 20:27:31 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(124) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(125) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		tpg
-- Create date: 27.08.2008
-- Description:	Процедура возвращает целочисленный псевдоним по ее системному имя привязки;
-- =============================================
CREATE PROCEDURE [ecr].[GetBindingAliasByName] 
	@SystemName nvarchar(128)
AS
	SET NOCOUNT ON;

	select
		DisplayAlias
	from ecr.Bindings
	where SystemName = @SystemName;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(126) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetBindingByAlias]    Script Date: 02/10/2010 20:27:31 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(127) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(128) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	Процедура возвращает данные о привязке по заданному целочисленному псевдониму;
-- =============================================
CREATE PROCEDURE [ecr].[GetBindingByAlias] 
	-- Add the parameters for the stored procedure here
	@DisplayAlias int
AS
	SET NOCOUNT ON;

	select
		ID
		, BindingID
		, SystemName
		, DisplayName
		, DisplayAlias
		, RelativeNames
		, KeyType
		, [Description]
		, Comments
	from ecr.Bindings
	where DisplayAlias = @DisplayAlias

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(129) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetBindingByID]    Script Date: 02/10/2010 20:27:31 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(130) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(131) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 01.07.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetBindingByID]
	-- Add the parameters for the stored procedure here
	@BindingID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		ID
		, BindingID
		, SystemName
		, DisplayName
		, DisplayAlias
		, RelativeNames
		, KeyType
		, [Description]
		, Comments
	from
		ecr.Bindings
	where
		ID = @BindingID	

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(132) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetBindingByName]    Script Date: 02/10/2010 20:27:31 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(133) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(134) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:		Процедура возвращает данные о привязке по заданному имени;
-- =============================================
CREATE PROCEDURE [ecr].[GetBindingByName] 
	@SystemName nvarchar(50)
AS
	SET NOCOUNT ON;

	select
		ID
		, BindingID
		, SystemName
		, DisplayName
		, DisplayAlias
		, RelativeNames
		, KeyType
		, [Description]
		, Comments
	from ecr.Bindings
	where SystemName = @SystemName;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(135) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetBindingByUID]    Script Date: 02/10/2010 20:27:31 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(136) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(137) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetBindingByUID] 
	-- Add the parameters for the stored procedure here
	@BindingID uniqueidentifier
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		ID
		, BindingID
		, SystemName
		, DisplayName
		, DisplayAlias
		, RelativeNames
		, KeyType
		, [Description]
		, Comments
	from
		ecr.Bindings
	where
		BindingID = @BindingID	

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(138) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetBindingChilds]    Script Date: 02/10/2010 20:27:31 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(139) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(140) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	Процедура возвращает данные о представлениях с заданной привязкой;
-- =============================================
CREATE PROCEDURE [ecr].[GetBindingChilds] 
--	@BindingID uniqueidentifier
	@SystemName nvarchar(128)
AS
	SET NOCOUNT ON;

	select
		e.ID
		, e.EntityID
		, e.SystemName
		, e.DisplayName
		, e.DisplayAlias
		, e.[Description]
		, e.Comments
		, e.StorageID
		, e.HistoryLifeTime
		, e.IsMultiplied
		, e.Extensions
	from ecr.Entities e
	inner join ecr.EntityBindings eb on e.ID = eb.EntityID
	inner join ecr.Bindings b on eb.BindingID = b.ID
		and b.SystemName = @SystemName;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(141) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetBindingNameByAlias]    Script Date: 02/10/2010 20:27:31 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(142) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(143) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	Процедура возвращает системное имя привязки по ее целочисленному псевдониму;
-- =============================================
CREATE PROCEDURE [ecr].[GetBindingNameByAlias] 
	@DisplayAlias int
AS
	SET NOCOUNT ON;

	select
		SystemName
	from ecr.Bindings
	where DisplayAlias = @DisplayAlias;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(144) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetBindingNameByID]    Script Date: 02/10/2010 20:27:31 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(145) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(146) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 01.07.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetBindingNameByID]
	-- Add the parameters for the stored procedure here
	@BindingID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		SystemName
	from ecr.Bindings
	where ID = @BindingID;

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(147) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetBindingNameByUID]    Script Date: 02/10/2010 20:27:31 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(148) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(149) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	Процедура возвращает сиетемное имя привязки по ее идентификатору;
-- =============================================
CREATE PROCEDURE [ecr].[GetBindingNameByUID] 
	@BindingID uniqueidentifier
AS
	SET NOCOUNT ON;

	select
		SystemName
	from ecr.Bindings
	where BindingID = @BindingID;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(150) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetBindingsList]    Script Date: 02/10/2010 20:27:31 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(151) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(152) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	Процедура возвращает данные по выбранным привязкам;
-- =============================================
CREATE PROCEDURE [ecr].[GetBindingsList] 
AS
	SET NOCOUNT ON;

	select
		ID
		, BindingID
		, SystemName
		, DisplayName
		, DisplayAlias
		, RelativeNames
		, KeyType
		, [Description]
		, Comments
	from ecr.Bindings;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(153) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetContentCountByTypeAndTime]    Script Date: 02/10/2010 20:27:31 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(154) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(155) BEGIN TRANSACTION END
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
    ,@EntityID int

  select 
     @str = stg.ConnectionString
    --,@DisplayAlias = ent.DisplayAlias
    ,@Enabled = stg.Enabled
    ,@EntityID = ent.id
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
    select
         log.ItemKey 
        ,log.ItemNumber
    into
        #log
    from 
        <ECR_Storage_DATABASENAME>.ecr.LogViewsStorage log 
        join ECR_Config.ecr.[Views] vw on (log.DisplayAlias = vw.DisplayAlias) and (vw.EntityParent = <@EntityID>)
        join <warekeys_buffTableName> w on (log.ItemKey = w.WareKey collate Cyrillic_General_CI_AS)
    where
        log.OperationDate > ''<@StartDate>'' and
        log.OperationDate <= ''<@EndDate>''

    select distinct 
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
    set @redCode = replace(@redCode, N'<@EntityID>', convert(nvarchar(10), @EntityID))
    set @redCode = replace(@redCode, N'<@StartDate>', convert(nvarchar(100), @StartDate, 120))
    set @redCode = replace(@redCode, N'<@EndDate>', convert(nvarchar(100), @EndDate, 120))
    
    exec sp_executesql @redCode
  end   
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(156) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityAliasByName]    Script Date: 02/10/2010 20:27:31 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(157) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(158) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		tpg
-- Create date: 27.08.2008
-- Description:	Процедура возвращает целочисленный псевдоним по системному имени сущности (типу контента);
-- =============================================
CREATE PROCEDURE [ecr].[GetEntityAliasByName] 
	@SystemName nvarchar(128)
AS
	SET NOCOUNT ON;

	select
		DisplayAlias
	from ecr.Entities
	where SystemName = @SystemName;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(159) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityByAlias]    Script Date: 02/10/2010 20:27:31 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(160) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(161) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 31.01.2008
-- Description:	Процедура возвращает данные о сущности (типе контента) по заданному целочисленному псевдониму;
-- =============================================
CREATE PROCEDURE [ecr].[GetEntityByAlias] 
	@DisplayAlias int
AS
	SET NOCOUNT ON;

	select
		ID
		, EntityID
		, SystemName
		, DisplayName
		, DisplayAlias
		, [Description]
		, Comments
		, StorageID
		, HistoryLifeTime
		, IsMultiplied
		, Extensions
		, Params
	from ecr.Entities
	where DisplayAlias = @DisplayAlias;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(162) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityByID]    Script Date: 02/10/2010 20:27:32 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(163) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(164) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 01.07.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetEntityByID]
	-- Add the parameters for the stored procedure here
	@EntityID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		ID
		, EntityID
		, SystemName
		, DisplayName
		, DisplayAlias
		, [Description]
		, Comments
		, StorageID
		, HistoryLifeTime
		, IsMultiplied
		, Extensions
		, Params
	from ecr.Entities
	where ID = @EntityID;	

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(165) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityByName]    Script Date: 02/10/2010 20:27:32 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(166) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(167) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 30.01.2008
-- Description:	Процедура возвращает данные о сущности (типе контента) по заданному имени;
-- =============================================
CREATE PROCEDURE [ecr].[GetEntityByName] 
	@SystemName nvarchar(50)
AS
	SET NOCOUNT ON;
	
	select
		ID
		, EntityID
		, SystemName
		, DisplayName
		, DisplayAlias
		, [Description]
		, Comments
		, StorageID
		, HistoryLifeTime
		, IsMultiplied
		, Extensions
		, Params
	from ecr.Entities
	where SystemName = @SystemName;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(168) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityByUID]    Script Date: 02/10/2010 20:27:32 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(169) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(170) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 30.01.2008
-- Description:	Процедура возвращает данные о сущности (типе контента) по заданному идентификатору;
-- =============================================
CREATE PROCEDURE [ecr].[GetEntityByUID] 
	@EntityID uniqueidentifier
AS
	SET NOCOUNT ON;
	
	select
		ID
		, EntityID
		, SystemName
		, DisplayName
		, DisplayAlias
		, [Description]
		, Comments
		, StorageID
		, HistoryLifeTime
		, IsMultiplied
		, Extensions
		, Params
	from ecr.Entities
	where EntityID = @EntityID;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(171) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityChilds]    Script Date: 02/10/2010 20:27:32 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(172) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(173) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 31.01.2008
-- Description:	Процедура возвращает данные о представлениях, наследуемых от заданной сущности (типа контента);
-- =============================================
CREATE PROCEDURE [ecr].[GetEntityChilds] 
	@EntityID int
AS
	SET NOCOUNT ON;

	select
		ID
		, ViewID
		, SystemName
		, DisplayName
		, DisplayAlias
		, RelativeNames
		, [Description]
		, Comments
		, EntityParent
		, [Enabled]
		, Extensions
		, Params
	from ecr.Views
	where EntityParent = @EntityID;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(174) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityList]    Script Date: 02/10/2010 20:27:32 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(175) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(176) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		tpg
-- Create date: 27.08.2008
-- Description:	Процедура возвращает данные по выбранному имени сущностям (типам контента);
--				@Binding указывает на привязку имя привязки SystemName;
-- =============================================
CREATE PROCEDURE [ecr].[GetEntityList] 
	@BindingName nvarchar(128) = NULL
AS
	SET NOCOUNT ON;
	
	if(@BindingName IS NULL)
		select
			ID
			, EntityID
			, SystemName
			, DisplayName
			, DisplayAlias
			, [Description]
			, Comments
			, StorageID
			, HistoryLifeTime
			, IsMultiplied
			, Extensions
			, Params
		from ecr.Entities
	else
		select
			e.ID
			, e.EntityID
			, e.SystemName
			, e.DisplayName
			, e.DisplayAlias
			, e.[Description]
			, e.Comments
			, e.StorageID
			, e.HistoryLifeTime
			, e.IsMultiplied
			, e.Extensions
		from ecr.Entities e
		inner join ecr.EntityBindings eb on e.ID = eb.EntityID
		inner join ecr.Bindings b on eb.BindingID = b.ID
			and b.SystemName = @BindingName;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(177) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityNameByAlias]    Script Date: 02/10/2010 20:27:32 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(178) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(179) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 26.02.2008
-- Description:	Процедура возвращает системное имя сущности (типа контента) по ее целочисленному псевдониму;
-- =============================================
CREATE PROCEDURE [ecr].[GetEntityNameByAlias] 
	@DisplayAlias int
AS
	SET NOCOUNT ON;
	
	select
		SystemName
	from ecr.Entities
	where DisplayAlias = @DisplayAlias;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(180) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityNameByID]    Script Date: 02/10/2010 20:27:32 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(181) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(182) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 01.07.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetEntityNameByID]
	-- Add the parameters for the stored procedure here
	@EntityID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		SystemName
	from ecr.Entities
	where ID = @EntityID;	

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(183) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityNameByUID]    Script Date: 02/10/2010 20:27:32 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(184) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(185) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 26.02.2008
-- Description:	Процедура возвращает сиетемное имя сущности (типа контента) по ее идентификатору;
-- =============================================
CREATE PROCEDURE [ecr].[GetEntityNameByUID] 
	@EntityID uniqueidentifier
AS
	SET NOCOUNT ON;
	
	select
		SystemName
	from ecr.Entities
	where EntityID = @EntityID;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(186) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetLastProcessedMessageNo]    Script Date: 02/10/2010 20:27:32 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(187) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(188) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MMX
-- Create date: 27.05.2009
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetLastProcessedMessageNo]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select max(MessageNo) from [ecr].[ProcessedMessages]

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(189) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetSourceCatalog]    Script Date: 02/10/2010 20:27:32 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(190) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(191) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 07.02.2008
-- Description:	получение записи об объекте SourceCatalog из таблицы ecr.SourceCatalogs
-- =============================================
CREATE PROCEDURE [ecr].[GetSourceCatalog] 
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
		SELECT * FROM [ecr].[SourceCatalogs] WHERE SystemName = @SystemName	
	end
	else begin
		SELECT * FROM [ecr].[SourceCatalogs] WHERE SystemName = @SystemName AND InstanceName = @InstanceName
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
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(192) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetStorageAliasByName]    Script Date: 02/10/2010 20:27:32 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(193) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(194) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		tpg
-- Create date: 27.08.2008
-- Description:	Процедура возвращает целочисленный псевдоним по имени хранилища контента;
-- =============================================
CREATE PROCEDURE [ecr].[GetStorageAliasByName] 
	@SystemName nvarchar(128)
AS
	SET NOCOUNT ON;

	select
		DisplayAlias
	from ecr.Storages
	where SystemName = @SystemName;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(195) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetStorageByAlias]    Script Date: 02/10/2010 20:27:32 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(196) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(197) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 31.01.2008
-- Description:	Процедура возвращает данные о хранилище контента по заданному целочисленному псевдониму;
-- =============================================
CREATE PROCEDURE [ecr].[GetStorageByAlias] 
	@DisplayAlias int
AS
	SET NOCOUNT ON;

	select
		ID
		, StorageID
		, SystemName
		, DisplayName
		, DisplayAlias
		, [Description]
		, Comments
		, [Enabled]
		, RemoteServerName
		, ConnectionString
	from ecr.Storages
	where DisplayAlias = @DisplayAlias;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(198) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetStorageByID]    Script Date: 02/10/2010 20:27:32 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(199) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(200) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 01.07.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetStorageByID]
	-- Add the parameters for the stored procedure here
	@StorageID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		ID
		, StorageID
		, SystemName
		, DisplayName
		, DisplayAlias
		, [Description]
		, Comments
		, [Enabled]
		, RemoteServerName
		, ConnectionString
	from ecr.Storages
	where ID = @StorageID;
	
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(201) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetStorageByName]    Script Date: 02/10/2010 20:27:32 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(202) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(203) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 30.01.2008
-- Description:	Процедура возвращает данные о хранилище контента по заданному имени;
-- =============================================
CREATE PROCEDURE [ecr].[GetStorageByName] 
	@SystemName nvarchar(50)
AS
	SET NOCOUNT ON;

	select
		ID
		, StorageID
		, SystemName
		, DisplayName
		, DisplayAlias
		, [Description]
		, Comments
		, [Enabled]
		, RemoteServerName
		, ConnectionString
	from ecr.Storages
	where SystemName = @SystemName;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(204) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetStorageByUID]    Script Date: 02/10/2010 20:27:32 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(205) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(206) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 30.01.2008
-- Description:	Процедура возвращает данные о хранилище контента по заданному идентификатору;
-- =============================================
CREATE PROCEDURE [ecr].[GetStorageByUID] 
	@StorageID uniqueidentifier
AS
	SET NOCOUNT ON;

	select
		ID
		, StorageID
		, SystemName
		, DisplayName
		, DisplayAlias
		, [Description]
		, Comments
		, [Enabled]
		, RemoteServerName
		, ConnectionString
	from ecr.Storages
	where StorageID = @StorageID;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(207) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetStorageForEntity]    Script Date: 02/10/2010 20:27:32 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(208) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(209) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		tpg
-- Create date: 27.08.2008
-- Description:	Максим, напиши пояснения
-- =============================================
CREATE PROCEDURE [ecr].[GetStorageForEntity]
	@EntityName nvarchar(128)
AS
SET NOCOUNT ON;

	select
		s.ID
		, s.StorageID
		, s.SystemName
		, s.DisplayName
		, s.DisplayAlias
		, s.[Description]
		, s.Comments
		, s.[Enabled]
		, s.RemoteServerName
		, s.ConnectionString
	from ecr.Storages s
	inner join ecr.Entities e on s.ID = e.StorageID
		and e.SystemName = @EntityName;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(210) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetStorageForView]    Script Date: 02/10/2010 20:27:32 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(211) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(212) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		tpg
-- Create date: 27.08.2008
-- Description:	Максим, напиши пояснения
-- =============================================
CREATE PROCEDURE [ecr].[GetStorageForView]
	@ViewName nvarchar(128)
AS
SET NOCOUNT ON;

	select
		s.ID
		, s.StorageID
		, s.SystemName
		, s.DisplayName
		, s.DisplayAlias
		, s.[Description]
		, s.Comments
		, s.[Enabled]
		, s.RemoteServerName
		, s.ConnectionString
	from ecr.Storages s
	inner join ecr.Entities e on s.ID = e.StorageID
	inner join ecr.Views v on e.ID = v.EntityParent
		and v.SystemName = @ViewName;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(213) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetStorageList]    Script Date: 02/10/2010 20:27:33 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(214) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(215) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 26.02.2008
-- Description:	Процедура возвращает список параметров хранилищ контента;
-- =============================================
CREATE PROCEDURE [ecr].[GetStorageList] 
	@Enabled bit = NULL
AS
	SET NOCOUNT ON;

	if (@Enabled IS NULL)
		select
			ID
			, StorageID
			, SystemName
			, DisplayName
			, DisplayAlias
			, [Description]
			, Comments
			, [Enabled]
			, RemoteServerName
			, ConnectionString
		from ecr.Storages
		order by ID;
	else
		select
			ID
			, StorageID
			, SystemName
			, DisplayName
			, DisplayAlias
			, [Description]
			, Comments
			, [Enabled]
			, RemoteServerName
			, ConnectionString
		from ecr.Storages
		where [Enabled] = @Enabled
		order by ID;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(216) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetStorageNameByAlias]    Script Date: 02/10/2010 20:27:33 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(217) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(218) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 26.02.2008
-- Description:	Процедура возвращает системное имя хранилища контента по его целочисленному псевдониму;
-- =============================================
CREATE PROCEDURE [ecr].[GetStorageNameByAlias] 
	@DisplayAlias int
AS
	SET NOCOUNT ON;
	
	select
		SystemName
	from ecr.Storages
	where DisplayAlias = @DisplayAlias;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(219) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetStorageNameByID]    Script Date: 02/10/2010 20:27:33 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(220) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(221) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 01.07.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetStorageNameByID]
	-- Add the parameters for the stored procedure here
	@StorageID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		SystemName
	from ecr.Storages
	where ID = @StorageID;	

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(222) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetStorageNameByUID]    Script Date: 02/10/2010 20:27:33 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(223) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(224) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 26.02.2008
-- Description:	Процедура возвращает системное имя хранилища контента по его идентификатору;
-- =============================================
CREATE PROCEDURE [ecr].[GetStorageNameByUID] 
	@StorageID uniqueidentifier
AS
	SET NOCOUNT ON;
	
	select
		SystemName
	from ecr.Storages
	where StorageID = @StorageID;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(225) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewAliasByName]    Script Date: 02/10/2010 20:27:33 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(226) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(227) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		tpg
-- Create date: 27.08.2008
-- Description:	Процедура возвращает целочисленный псевдоним по системному имени представления контента;
-- =============================================
CREATE PROCEDURE [ecr].[GetViewAliasByName] 
	@SystemName nvarchar(128)
AS
	SET NOCOUNT ON;

	select
		DisplayAlias
	from ecr.Views
	where SystemName = @SystemName;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(228) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewByAlias]    Script Date: 02/10/2010 20:27:33 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(229) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(230) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 21.01.2008
-- Description:	Процедура возвращает данные о представлении контента по заданному целочисленному псевдониму;
-- =============================================
CREATE PROCEDURE [ecr].[GetViewByAlias] 
	@DisplayAlias int
AS
	SET NOCOUNT ON;
	
	select
		ID
		, ViewID
		, SystemName
		, DisplayName
		, DisplayAlias
		, RelativeNames
		, [Description]
		, Comments
		, EntityParent
		, [Enabled]
		, Extensions
		, Params
	from ecr.Views
	where DisplayAlias = @DisplayAlias;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(231) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewByID]    Script Date: 02/10/2010 20:27:33 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(232) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(233) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 01.07.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetViewByID]
	-- Add the parameters for the stored procedure here
	@ViewID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		ID
		, ViewID
		, SystemName
		, DisplayName
		, DisplayAlias
		, RelativeNames
		, [Description]
		, Comments
		, EntityParent
		, [Enabled]
		, Extensions
		, Params
	from ecr.Views
	where ID = @ViewID;	

END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(234) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewByName]    Script Date: 02/10/2010 20:27:33 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(235) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(236) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 31.01.2008
-- Description:	Процедура возвращает данные о представлении контента по заданному имени;
-- =============================================
CREATE PROCEDURE [ecr].[GetViewByName] 
	@SystemName nvarchar(50)
AS
	SET NOCOUNT ON;
	
	select
		ID
		, ViewID
		, SystemName
		, DisplayName
		, DisplayAlias
		, RelativeNames
		, [Description]
		, Comments
		, EntityParent
		, [Enabled]
		, Extensions
		, Params
	from ecr.Views
	where SystemName = @SystemName;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(237) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewByUID]    Script Date: 02/10/2010 20:27:33 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(238) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(239) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 31.01.2008
-- Description:	Процедура возвращает данные о представлении контента по заданному идентификатору;
-- =============================================
CREATE PROCEDURE [ecr].[GetViewByUID] 
	@ViewID uniqueidentifier
AS
	SET NOCOUNT ON;
	
	select
		ID
		, ViewID
		, SystemName
		, DisplayName
		, DisplayAlias
		, RelativeNames
		, [Description]
		, Comments
		, EntityParent
		, [Enabled]
		, Extensions
		, Params
	from ecr.Views
	where ViewID = @ViewID;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(240) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewDataByKeys]    Script Date: 02/10/2010 20:27:33 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(241) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(242) BEGIN TRANSACTION END
GO

-- Процедура возвращает данные указанного представления файлового контента по списку ключей
create procedure [ecr].[GetViewDataByKeys] 
	(
	@KeysList nvarchar(max),
	@SystemName nvarchar(128)
	)
as
declare
     @DataBase nvarchar(100)
    ,@RedCode nvarchar(max)
    ,@Enabled bit
    
select  
     @DataBase = stg.DatabaseName
    ,@Enabled = stg.Enabled
from
	ECR_Config.ecr.Entities ent 
		join ECR_Config.ecr.Storages stg on ent.StorageID = stg.ID
where
	ent.SystemName = @SystemName

if @Enabled = 1 
begin
	if (isnull(@KeysList,'') = '')
		set @KeysList = '0'
	set @Redcode = N'
select cast(evs.ItemKey as nvarchar) ItemKey
		, evs.ItemNumber
		, evs.ItemBody 
from <ECR_Storage_DATABASENAME>.ecr.ViewsStorage evs
where ItemKey in (<KeysList>)'

	set @RedCode = replace(@RedCode, N'<ECR_Storage_DATABASENAME>', @DataBase)
	set @RedCode = replace(@RedCode, N'<KeysList>', @KeysList)

	exec sp_executesql @redCode
	
end

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(243) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewList]    Script Date: 02/10/2010 20:27:33 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(244) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(245) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 31.01.2008
-- Description:	Процедура возвращает данные о представлениях контента;
--				@EntityParent указывает на родительскую сущность;
-- =============================================
CREATE PROCEDURE [ecr].[GetViewList] 
--	@EntityParent int = NULL
	@EntityParent nvarchar(128) = NULL
	, @Enabled bit = NULL
AS
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	if @EntityParent is null begin
		if @Enabled is null
			select
				ID
				, ViewID
				, SystemName
				, DisplayName
				, DisplayAlias
				, RelativeNames
				, [Description]
				, [Comments]
				, EntityParent
				, [Enabled]
				, Extensions
				, Params
			from ecr.Views;
		else
			select
				ID
				, ViewID
				, SystemName
				, DisplayName
				, DisplayAlias
				, RelativeNames
				, [Description]
				, [Comments]
				, EntityParent
				, [Enabled]
				, Extensions
				, Params
			from ecr.Views
			where [Enabled] = @Enabled;
	end
	else begin
		if @Enabled is null
			select
				v.ID
				, v.ViewID
				, v.SystemName
				, v.DisplayName
				, v.DisplayAlias
				, v.RelativeNames
				, v.[Description]
				, v.[Comments]
				, v.EntityParent
				, v.[Enabled]
				, v.Extensions
				, v.Params
			from ecr.Views v
			inner join ecr.Entities e on v.EntityParent = e.ID
				and e.SystemName = @EntityParent;
		else
			select
				v.ID
				, v.ViewID
				, v.SystemName
				, v.DisplayName
				, v.DisplayAlias
				, v.RelativeNames
				, v.[Description]
				, v.[Comments]
				, v.EntityParent
				, v.[Enabled]
				, v.Extensions
				, v.Params
			from ecr.Views v
			inner join ecr.Entities e on v.EntityParent = e.ID
				and e.SystemName = @EntityParent
				and v.[Enabled] = @Enabled;
	end

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(246) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewListByBinding]    Script Date: 02/10/2010 20:27:33 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(247) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(248) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		tpg
-- Create date: 14.08.2008
-- Description:	Максим, допиши пояснения сам!
-- =============================================
CREATE PROCEDURE [ecr].[GetViewListByBinding]
--	@BindingID uniqueidentifier
	@BindingName nvarchar(128)
	, @Enabled bit = NULL	-- если NULL, то выбирать ВСЕ строки без фильтрации
AS
SET NOCOUNT ON;

declare @ErrMsg nvarchar(4000)

	if @Enabled is not null
		select
			v.ID
			, v.ViewID
			, v.SystemName
			, v.DisplayName
			, v.DisplayAlias
			, v.RelativeNames
			, v.[Description]
			, v.Comments
			, v.EntityParent
			, v.[Enabled]
			, v.Extensions
			, v.Params
		from ecr.Views v
		where exists
				(
				select
					*
				from ecr.EntityBindings eb
				inner join ecr.Bindings b on b.SystemName = @BindingName
						and eb.BindingID = b.ID
				inner join ecr.Entities e on eb.EntityID = e.ID
						and e.ID = v.EntityParent
				)
		and v.[Enabled] = @Enabled;
	else
		select
			v.ID
			, v.ViewID
			, v.SystemName
			, v.DisplayName
			, v.DisplayAlias
			, v.RelativeNames
			, v.[Description]
			, v.Comments
			, v.EntityParent
			, v.[Enabled]
			, v.Extensions
			, v.Params
		from ecr.Views v
		where exists
				(
				select
					*
				from ecr.EntityBindings eb
				inner join ecr.Bindings b on b.SystemName = @BindingName
						and eb.BindingID = b.ID
				inner join ecr.Entities e on eb.EntityID = e.ID
						and e.ID = v.EntityParent
				);

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(249) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewNameByAlias]    Script Date: 02/10/2010 20:27:33 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(250) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(251) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 26.02.2008
-- Description:	Процедура возвращает системное имя представления контента по его целочисленному псевдониму;
-- =============================================
CREATE PROCEDURE [ecr].[GetViewNameByAlias] 
	@DisplayAlias int
AS
	SET NOCOUNT ON;

	select
		SystemName
	from ecr.Views
	where DisplayAlias = @DisplayAlias;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(252) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewNameByID]    Script Date: 02/10/2010 20:27:33 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(253) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(254) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 01.07.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetViewNameByID]
	-- Add the parameters for the stored procedure here
	@ViewID int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select
		SystemName
	from ecr.Views
	where ID = @ViewID;
	
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(255) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewNameByUID]    Script Date: 02/10/2010 20:27:33 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(256) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(257) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 26.02.2008
-- Description:	Процедура возвращает системное имя представления контента по его идентификатору;
-- =============================================
CREATE PROCEDURE [ecr].[GetViewNameByUID] 
	@ViewID uniqueidentifier
AS
	SET NOCOUNT ON;
	
	select
		SystemName
	from ecr.Views
	where ViewID = @ViewID;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(258) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[IsEntityMultiplied]    Script Date: 02/10/2010 20:27:33 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(259) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(260) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	Процедура возвращает признак множественности для сущности;
-- =============================================
CREATE PROCEDURE [ecr].[IsEntityMultiplied] 
--	@EntityID uniqueidentifier
	@SystemName nvarchar(128)
AS
	SET NOCOUNT ON;

/*	select
		IsMultiplied
	from ecr.Entities
	where EntityID = @EntityID;
*/
	select
		IsMultiplied
	from ecr.Entities
	where SystemName = @SystemName;
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(261) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[IsStorageEnabled]    Script Date: 02/10/2010 20:27:34 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(262) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(263) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	Процедура возвращает признак доступности хранилища контента с заданным идентификатором;
-- =============================================
CREATE PROCEDURE [ecr].[IsStorageEnabled] 
--	@StorageID uniqueidentifier
	@SystemName nvarchar(128)
AS
	SET NOCOUNT ON;

	select
		[Enabled]
	from ecr.Storages
	where SystemName = @SystemName;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(264) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[IsViewEnabled]    Script Date: 02/10/2010 20:27:34 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(265) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(266) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	Процедура возвращает признак доступности представления контента с заданным именем;
--				Важно: свойство Enabled определено только для объектов таблиц ecr_Storages, ecr_Views;
--				Для элементов и сущностей свойство Enabled не определено;
-- =============================================
CREATE PROCEDURE [ecr].[IsViewEnabled] 
--	@ViewID uniqueidentifier
	@SystemName nvarchar(128)
AS
	SET NOCOUNT ON;

	select
		[Enabled]
	from ecr.Views
	where SystemName = @SystemName;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(267) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[IsViewMultiplied]    Script Date: 02/10/2010 20:27:34 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(268) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(269) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 18.04.2008
-- Description:	Процедура возвращает признак множественности для представления контента, наследуемый от родительской сущности;
-- =============================================
CREATE PROCEDURE [ecr].[IsViewMultiplied] 
--	@ViewID uniqueidentifier
	@SystemName nvarchar(128)
AS
	SET NOCOUNT ON;

	select
		IsMultiplied
	from ecr.Entities e
	inner join ecr.Views v on e.ID = v.EntityParent
		and v.SystemName = @SystemName;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(270) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[UpdateContentCountByType]    Script Date: 02/10/2010 20:27:34 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(271) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(272) BEGIN TRANSACTION END
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
CREATE PROCEDURE [ecr].[UpdateContentCountByType]
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
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(273) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[UpdateItemSummary]    Script Date: 02/10/2010 20:27:34 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(274) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(275) BEGIN TRANSACTION END
GO


-- =============================================
-- Author:		MMX
-- Create date: 15.01.2010
-- Description:	Процедура обновления сводных данных в таблицу ecr.ItemsSummary
-- =============================================
CREATE PROCEDURE [ecr].[UpdateItemSummary] 
	-- Add the parameters for the stored procedure here
	@DisplayAlias int
	, @ItemKey nvarchar(50)
	, @ItemNumber int = NULL
	, @OperationType char(1)
AS
BEGIN
	SET NOCOUNT ON;

    declare @ErrMsg nvarchar(4000)

begin try

	-- Проверка параметра @OperationType
	if @OperationType not in ('I','U','D','C') begin
		raiserror(@ErrMsg, 16, 1);
		return 1;
	end
	
	-- Открываем транзакцию;
	begin tran
	
		insert
				ecr.ItemsSummary
					(
					DisplayAlias
					, ItemKey
					, ItemNumber
					, OperationType
					)
				select
					@DisplayAlias
					, @ItemKey
					, @ItemNumber
					, @OperationType
	
	commit

end try
	-- Обработчик ошибок:
begin catch

	-- Если транзакция открыта, то откатываем транзакцию;
	if @@trancount > 0 rollback tran;
	
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
	
END


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(276) BEGIN TRANSACTION END
GO



GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(277) BEGIN TRANSACTION END
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
