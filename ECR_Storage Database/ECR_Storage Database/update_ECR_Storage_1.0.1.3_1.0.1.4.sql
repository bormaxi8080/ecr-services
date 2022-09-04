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

set nocount on
declare @Version nvarchar(50), @SQL varchar(1000)
set @Version = '1.0.1.4'
if not exists(select * from dbo.VersionHistory where [Version] = @Version) begin
	insert into dbo.VersionHistory ([Version], VersionDate, [Description])
	select @Version, getdate(), N'Исправления ошибок в хранимых процедурах ecr.CollectEntityChanges_Xml, ecr.CollectViewChanges_Xml'
end else begin
	set @SQL = 'Обновление ' + @Version + ' уже ранее применено...' 
	raiserror(@SQL, 25, 1) with log
end
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(1) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CollectEntityChanges_Xml]    Script Date: 02/09/2009 13:55:03 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[CollectEntityChanges_Xml]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[CollectEntityChanges_Xml]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(2) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CollectEntityChanges_Xml]    Script Date: 02/09/2009 13:55:36 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(3) BEGIN TRANSACTION END
GO
SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(4) BEGIN TRANSACTION END
GO
-- =============================================
-- Author:		tpg
-- Create date: 03.09.2008
/* Description:
Процедура создает запись о пакете в таблице ecr.XmlPackages
и возвращает номер пакета @PackageID, выбирает TOP @Count записей из таблицы 
ecr.LogEntitiesStorage с сортировкой ASC по полю RowId.
Затем формирует строчку xml @XmlStr.
Затем обновляет для выбранных записей в таблице ecr.LogEntitiesStorage значение столбца
PackageID_Xml значением @PackageID.
*/
-- =============================================
CREATE PROCEDURE [ecr].[CollectEntityChanges_Xml]
	@Count int = 100			-- количество выбираемых записей, параметр регулирует размер пакета
    , @PackageID int out
	, @OutXml xml out
AS
SET NOCOUNT ON;

declare @ErrMsg nvarchar(4000)
declare @x table
				(
				ItemKey nvarchar(50)
				, ItemNumber int
				, ItemBody varbinary(max)
				, OperationType char(1)
				, DisplayAlias int
				)

begin try
begin tran

	exec [ecr].[NextPackageID_Get]
					0	-- для Entity
					, @PackageID out;

	insert
			ecr.XmlPackages
			(
			ID
			, PackageID
			, PackageType
			, DateCreate
			)
		select
			@PackageID
			, newid()
			, 0
			, getdate();

	update
		l
	set
		PackageID_Xml = @PackageID
	output
		inserted.ItemKey
		, inserted.ItemNumber
		, inserted.ItemBody
		, inserted.OperationType
		, inserted.DisplayAlias
	into @x
	from ecr.LogEntitiesStorage l
	inner join
			(
			select top (@Count)
				le.RowId
			from ecr.LogEntitiesStorage le
			where le.PackageID_Xml is null
			order by le.RowId
			) n on l.RowId = n.RowId;
	if @@rowcount = 0
		raiserror(N'Error 19600304: Строки для передачи в XML документ отсутствуют!', 16, 1)

	set @OutXml = 
			(
			select
				*
			from
				(
				select
					MessageNo = x.ID
					, MessageId = x.PackageID
					, MessageCreationTime = x.DateCreate
					, MessageOwnerType = N'ECR'
					, MessageOwnerId = N''
					, MessagePackageCount = N'1'
					, MessagePackageNumber = N'1'
					, PreviousMessageID =
										(
										select top 1
											PackageID
										from ecr.XmlPackages
										where PackageType = 0
											and ID < @PackageID
										order by ID desc
										)
				from ecr.XmlPackages x
				where x.ID = @PackageID
				) [Message]
			cross join
				(
				select
					ObjectType = N'otBinaryContent'
					, CreationTime = xpe.DateCreate
					/*, ContentType = N'otContentEntity'*/
					, KeyType = N'tk.key'
					,  ItemType = e.SystemName	--@EntityName
					, x.ItemKey
					, x.ItemNumber
					, ItemBody = case x.OperationType
									when 'D' then null
									else x.ItemBody
									end
					, Encoding = N'base64'
					, Extension = e.Extensions
					, ObjectGUID = newid()
				from @x x
				inner join ecr.Entities e on x.DisplayAlias = e.DisplayAlias
				inner join ecr.XmlPackages xpe on xpe.ID = @PackageID
				) [Object] for xml auto, binary base64
			);

commit tran
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

SET ANSI_NULLS ON

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(5) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CollectViewChanges_Xml]    Script Date: 02/09/2009 13:55:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[CollectViewChanges_Xml]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[CollectViewChanges_Xml]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(6) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CollectViewChanges_Xml]    Script Date: 02/09/2009 13:56:11 ******/
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
-- Create date: 03.09.2008
/* Description:
Процедура создает запись о пакете в таблице ecr.XmlPackage
и возвращает номер пакета @PackageID, выбирает TOP @Count записей из таблицы 
ecr.LogViewesStorage с сортировкой ASC по полю RowId.
Затем формирует строчку xml @XmlStr.
Затем обновляет для выбранных записей в таблице ecr.LogViewesStorage значение столбца
PackageID_Xml значением @PackageID.
*/
-- =============================================
CREATE PROCEDURE [ecr].[CollectViewChanges_Xml]
--	@ViewName nvarchar(128)	-- системное имя сущности, перевязка по полю DisplayAlias
								-- на таблицу ecr.Views
	@Count int = 100			-- количество выбираемых записей, параметр регулирует размер пакета
    , @PackageID int out
	, @OutXml xml out
AS
SET NOCOUNT ON;

declare @ErrMsg nvarchar(4000)
declare @x table
				(
				ItemKey nvarchar(50)
				, ItemNumber int
				, ItemBody varbinary(max)
				, OperationType char(1)
				, DisplayAlias int
				)

begin try
begin tran

	exec [ecr].[NextPackageID_Get]
					1	-- для View
					, @PackageID out;

	insert
			ecr.XmlPackages
			(
			ID
			, PackageID
			, packageType
			, DateCreate
			)
		select
			@PackageID
			, newid()
			, 1
			, getdate();

	update
		l
	set
		PackageID_Xml = @PackageID
	output
		inserted.ItemKey
		, inserted.ItemNumber
		, inserted.ItemBody
		, inserted.OperationType
		, inserted.DisplayAlias
	into @x
	from ecr.LogViewsStorage l
	inner join
			(
			select top (@Count)
				le.RowId
			from ecr.LogViewsStorage le
			where le.PackageID_Xml is null
			order by le.RowId
			) n on l.RowId = n.RowId;
	if @@rowcount = 0
		raiserror(N'Error 19600304: Строки для передачи в XML документ отсутствуют!', 16, 1)

	set @OutXml = 
			(
			select
				*
			from
				(
				select
					MessageNo = x.ID
					, MessageId = x.PackageID
					, MessageCreationTime = x.DateCreate
					, MessageOwnerType = N'ECR'
					, MessageOwnerId = N''
					, MessagePackageCount = N'1'
					, MessagePackageNumber = N'1'
					, PreviousMessageID =
										(
										select top 1
											PackageID
										from ecr.XmlPackages
										where PackageType = 1
											and ID < @PackageID
										order by ID desc
										)
				from ecr.XmlPackages x
				where x.ID = @PackageID
				) [Message]
			cross join
				(
				select
					ObjectType = N'otBinaryContent'
					, CreationTime = xpe.DateCreate
					/*, ContentType = N'otContentView'*/
					, KeyType = N'tk.key'
					,  ItemType = v.SystemName
					, ParentItemType = e.SystemName
					, x.ItemKey
					, x.ItemNumber
					, ItemBody = case x.OperationType
									when 'D' then null
									else x.ItemBody
									end
					, Encoding = N'base64'
					, Extension = v.Extensions
					, ObjectGUID = newid()
				from @x x
				inner join ecr.Views v on x.DisplayAlias = v.DisplayAlias
				inner join ecr.XmlPackages xpe on xpe.ID = @PackageID
				left outer join ecr.Entities e on v.EntityParent = e.ID
				) [Object] for xml auto, binary base64
			);

commit tran
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