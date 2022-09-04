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
    @OldVersion = N'1.2.23.29'
    , @NewVersion = N'1.3.1.30'
    , @Description = left(N'Добавление таблицы ecr.ItemsSummary, удаление промежуточных объектов, исправления', 255);
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
/****** Object:  Table [ecr].[ItemsSummary]    Script Date: 01/26/2010 10:01:39 ******/
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

SET ANSI_PADDING ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(3) BEGIN TRANSACTION END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ProcessedPackages_PackageID]') AND type = 'D')
BEGIN
ALTER TABLE [ecr].[ProcessedMessages] DROP CONSTRAINT [DF_ProcessedPackages_PackageID]
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(4) BEGIN TRANSACTION END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Processed__Messa__041093DD]') AND type = 'D')
BEGIN
ALTER TABLE [ecr].[ProcessedMessages] DROP CONSTRAINT [DF__Processed__Messa__041093DD]
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(5) BEGIN TRANSACTION END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF__Processed__Messa__0504B816]') AND type = 'D')
BEGIN
ALTER TABLE [ecr].[ProcessedMessages] DROP CONSTRAINT [DF__Processed__Messa__0504B816]
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(6) BEGIN TRANSACTION END
GO

IF  EXISTS (SELECT * FROM dbo.sysobjects WHERE id = OBJECT_ID(N'[DF_ProcessedPackages_DateCreate]') AND type = 'D')
BEGIN
ALTER TABLE [ecr].[ProcessedMessages] DROP CONSTRAINT [DF_ProcessedPackages_DateCreate]
END

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(7) BEGIN TRANSACTION END
GO

/****** Object:  Table [ecr].[ProcessedMessages]    Script Date: 02/04/2010 14:31:34 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[ProcessedMessages]') AND type in (N'U'))
DROP TABLE [ecr].[ProcessedMessages]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(8) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[MarkProcessedMessage]    Script Date: 02/04/2010 14:33:41 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[MarkProcessedMessage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[MarkProcessedMessage]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(9) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetProcessedMessages]    Script Date: 02/04/2010 14:34:10 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetProcessedMessages]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetProcessedMessages]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(10) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[AddProcessedMessage]    Script Date: 02/04/2010 14:35:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[AddProcessedMessage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[AddProcessedMessage]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(11) BEGIN TRANSACTION END
GO

-- ecr.ItemsSummary table

CREATE TABLE [ecr].[ItemsSummary](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DisplayAlias] [int] NOT NULL,
	[ItemKey] [nvarchar](50) NOT NULL,
	[ItemNumber] [int] NULL,
	[OperationType] [char](1) NOT NULL,
	[OperationDate] [datetime] NOT NULL
) ON [PRIMARY]

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(12) BEGIN TRANSACTION END
GO

SET ANSI_PADDING OFF
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(13) BEGIN TRANSACTION END
GO

ALTER TABLE [ecr].[ItemsSummary] ADD  CONSTRAINT [DF_Summary_OperationDate]  DEFAULT (getdate()) FOR [OperationDate]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(14) BEGIN TRANSACTION END
GO


-- ecr.UpdateItemSummary stored procedure


/****** Object:  StoredProcedure [ecr].[UpdateItemSummary]    Script Date: 01/26/2010 10:02:12 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(15) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(16) BEGIN TRANSACTION END
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
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(17) BEGIN TRANSACTION END
GO





GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(18) BEGIN TRANSACTION END
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
