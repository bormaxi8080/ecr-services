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
set @Version = '1.0.1.3'
if not exists(select * from dbo.VersionHistory where [Version] = @Version) begin
	insert into dbo.VersionHistory ([Version], VersionDate, [Description])
	select @Version, getdate(), N'Переход на разделенную генерацию пакетов изменений по оригиналам и представлениям: исправления в таблице ecr.XmlPackages, хранимых процедурах ecr.CollectEntityChanges, ecr.CollectViewChanges, ecr.NextPackageID_Get'
end else begin
	set @SQL = 'Обновление ' + @Version + ' уже ранее применено...' 
	raiserror(@SQL, 25, 1) with log
end
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(1) BEGIN TRANSACTION END
GO


delete from [ecr].[LogViewsStorage]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(2) BEGIN TRANSACTION END
GO

delete from [ecr].[LogEntitiesStorage]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(3) BEGIN TRANSACTION END
GO

delete from [ecr].[XmlPackages]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(4) BEGIN TRANSACTION END
GO

delete from [ecr].[LastPackageNumber]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(5) BEGIN TRANSACTION END
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[XmlPackages]') AND type in (N'U'))
DROP TABLE [ecr].[XmlPackages]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(6) BEGIN TRANSACTION END
GO


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
CREATE TABLE [ecr].[XmlPackages](
	[ID] [int] NOT NULL,
	[PackageID] [uniqueidentifier] NOT NULL CONSTRAINT [DF_XmlPackages_PackageID]  DEFAULT (newid()),
	[PackageType] [int] NOT NULL CONSTRAINT [DF_XmlPackages_PackageType]  DEFAULT ((0)),
	[DateCreate] [datetime] NULL,
 CONSTRAINT [PK_XmlPackages_Entity] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY],
 CONSTRAINT [IX_PackageID] UNIQUE NONCLUSTERED 
(
	[PackageID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]



SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(9) BEGIN TRANSACTION END
GO
SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(10) BEGIN TRANSACTION END
GO
-- =============================================
-- Author:		tpg
-- Create date: 03.09.2008
-- Description:	Процедура возвращает "следующий" номер пакета.
-- =============================================
ALTER PROCEDURE [ecr].[NextPackageID_Get]
	@PackageType int = 0
	, @PackageID int = 1 output
AS
SET NOCOUNT ON;

declare @ErrMsg nvarchar(4000)
declare @RC int

begin try

begin tran
	-- получаем следующий номер
	update
		ecr.LastPackageNumber with(updlock)
	set @PackageID = PackageNumber = PackageNumber + 1
	where PackageType = @PackageType;
	-- для проверки
	set @RC = @@rowcount;
	-- если номер не получен
	if @RC = 0
		begin
			-- создаем его
			insert
				ecr.LastPackageNumber
			values
				(
				@PackageType
				, 1
				);
			--  и присваеваем ему 1
			set @PackageID = 1;
		end
	-- если в таблице более 1 строки, поднимаем ошибку
	if @RC > 1
		raiserror(N'Логическая ошибка: в таблице последнего номера пакета строк более 1!', 16, 1);

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
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(11) BEGIN TRANSACTION END
GO
SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(12) BEGIN TRANSACTION END
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
ALTER PROCEDURE [ecr].[CollectEntityChanges_Xml]
--	@EntityName nvarchar(128)	-- системное имя сущности, перевязка по полю DisplayAlias
								-- на таблицу ecr.Entities
	@Count int = 100			-- количество выбираемых записей, параметр регулирует размер пакета
    , @PackageID int out
	, @OutXml xml out
AS
SET NOCOUNT ON;

declare @ErrMsg nvarchar(4000)
--declare @t table
--				(
--				DisplayAlias int
--				)
declare @x table
				(
				ItemKey nvarchar(50)
				, ItemNumber int
				, ItemBody varbinary(max)
				, OperationType char(1)
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
--			, DisplayAlias
			, DateCreate
			)
--		output inserted.DisplayAlias into @t
		select
			@PackageID
			, newid()
			, 0
--			, DisplayAlias
			, getdate();
--		from ecr.Entities
		--where SystemName = @EntityName;

	update
		l
	set
		PackageID_Xml = @PackageID
	output
		inserted.ItemKey
		, inserted.ItemNumber
		, inserted.ItemBody
		, inserted.OperationType
	into @x
	from ecr.LogEntitiesStorage l
	inner join
			(
			select top (@Count)
				le.RowId
			from ecr.LogEntitiesStorage le
--			inner join @t t on le.DisplayAlias = t.DisplayAlias
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
				from @x x, ecr.Entities e, ecr.XmlPackages xpe
				where xpe.ID = @PackageID
--				and e.DisplayAlias = xpe.DisplayAlias
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
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(13) BEGIN TRANSACTION END
GO
SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(14) BEGIN TRANSACTION END
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
ALTER PROCEDURE [ecr].[CollectViewChanges_Xml]
--	@ViewName nvarchar(128)	-- системное имя сущности, перевязка по полю DisplayAlias
								-- на таблицу ecr.Views
	@Count int = 100			-- количество выбираемых записей, параметр регулирует размер пакета
    , @PackageID int out
	, @OutXml xml out
AS
SET NOCOUNT ON;

declare @ErrMsg nvarchar(4000)
--declare @t table
--				(
--				DisplayAlias int
--				)
declare @x table
				(
				ItemKey nvarchar(50)
				, ItemNumber int
				, ItemBody varbinary(max)
				, OperationType char(1)
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
--			, DisplayAlias
			, DateCreate
			)
--		output inserted.DisplayAlias into @t
		select
			@PackageID
			, newid()
			, 1
--			, DisplayAlias
			, getdate();
--		from ecr.Views
--		where SystemName = @ViewName ;

	update
		l
	set
		PackageID_Xml = @PackageID
	output
		inserted.ItemKey
		, inserted.ItemNumber
		, inserted.ItemBody
		, inserted.OperationType
	into @x
	from ecr.LogViewsStorage l
	inner join
			(
			select top (@Count)
				le.RowId
			from ecr.LogViewsStorage le
--			inner join @t t on le.DisplayAlias = t.DisplayAlias
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
				from @x x, ecr.Views v
				inner join ecr.XmlPackages xpe on xpe.ID = @PackageID
--					and v.DisplayAlias = xpe.DisplayAlias
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
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(15) BEGIN TRANSACTION END
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