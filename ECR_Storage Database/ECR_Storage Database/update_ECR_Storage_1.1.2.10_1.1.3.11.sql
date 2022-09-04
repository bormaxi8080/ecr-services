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
print N'��������� � ���� [' + db_name() + N'] �� ������� ' + cast(serverproperty('ServerName') as nvarchar(128)) + N' ' + convert(nvarchar, getdate(), 104) + N' � ' + convert(nvarchar, getdate(), 108) + N'.';
set nocount on;
declare
    @OldVersion nvarchar(50)
    , @NewVersion nvarchar(50)
    , @ErrMsg nvarchar(2047)
    , @Description nvarchar(255)
select
    @OldVersion = N'1.1.2.10'
    , @NewVersion = N'1.1.3.11'
    , @Description = left(N'�������� �������� ��������', 255);
print N'����������� ���������� � ������ ' + @OldVersion + N' �� ������ ' + @NewVersion + N' ...'
if not exists
        (
        select
            *
        from dbo.VersionHistory
        where [Version] = @OldVersion
        )
    begin
        set @ErrMsg = N'�� ����������� ���������� ����������! ��������� ��������.';
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
        set @ErrMsg = N'������ ���������� ��� ��������� �����! ��������� ��������.';
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
        set @ErrMsg = N'������� ������ �� ������������� ����������! ��������� ��������.';
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
/****** Object:  StoredProcedure [dbo].[adm_DefragmentationIndexes]    Script Date: 02/10/2010 20:29:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[adm_DefragmentationIndexes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[adm_DefragmentationIndexes]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(1) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CheckEntityExists]    Script Date: 02/10/2010 20:29:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[CheckEntityExists]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[CheckEntityExists]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(2) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CheckViewExists]    Script Date: 02/10/2010 20:29:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[CheckViewExists]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[CheckViewExists]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(3) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CollectEntityChanges_Xml]    Script Date: 02/10/2010 20:29:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[CollectEntityChanges_Xml]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[CollectEntityChanges_Xml]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(4) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CollectViewChanges_Xml]    Script Date: 02/10/2010 20:29:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[CollectViewChanges_Xml]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[CollectViewChanges_Xml]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(5) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[DeleteItem]    Script Date: 02/10/2010 20:29:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[DeleteItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[DeleteItem]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(6) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityItem]    Script Date: 02/10/2010 20:29:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetEntityItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetEntityItem]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(7) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetHistoryLifeTime]    Script Date: 02/10/2010 20:29:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetHistoryLifeTime]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetHistoryLifeTime]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(8) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewItem]    Script Date: 02/10/2010 20:29:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[GetViewItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[GetViewItem]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(9) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[NextPackageID_Get]    Script Date: 02/10/2010 20:29:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[NextPackageID_Get]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[NextPackageID_Get]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(10) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[UpdateEntityItem]    Script Date: 02/10/2010 20:29:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[UpdateEntityItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[UpdateEntityItem]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(11) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[UpdateViewItem]    Script Date: 02/10/2010 20:29:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[UpdateViewItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[UpdateViewItem]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(12) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [dbo].[adm_DefragmentationIndexes]    Script Date: 02/10/2010 20:29:37 ******/
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
-- Authors:		Microsoft Corp., tpg
-- Create date: 01.04.2009
-- Description:	��������� �������������� ���� ��������
--				��������� ����� �� ����� ���������� �������� �� ������
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
				-- ��������� ����� ������.
				-- ���� ������ "������ deadlock-�",
				-- �������� ������� �������.
				-- ���� ������ ������,
				-- ������� ������������� �� �����.
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
								-- �������� ���������� �� ������.
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
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(15) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CheckEntityExists]    Script Date: 02/10/2010 20:29:37 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(16) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(17) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 26.02.2008
-- Description:	��������� ��������� ������� �������� (���� ��������) � �������� ��������� ������;
-- =============================================
CREATE PROCEDURE [ecr].[CheckEntityExists] 
	@SystemName nvarchar(128)
	, @Exists int  = 0 output
AS
	SET NOCOUNT ON;

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
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(18) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CheckViewExists]    Script Date: 02/10/2010 20:29:37 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(19) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(20) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 26.02.2008
-- Description:	��������� ��������� ������� ������������� �������� � �������� ��������� ������;
-- =============================================
CREATE PROCEDURE [ecr].[CheckViewExists] 
	@SystemName nvarchar(128)
	, @Exists int = 0 output
AS
	SET NOCOUNT ON;

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
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(21) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CollectEntityChanges_Xml]    Script Date: 02/10/2010 20:29:37 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(22) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(23) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		tpg
-- Create date: 03.09.2008
/* Description:
��������� ������� ������ � ������ � ������� ecr.XmlPackages
� ���������� ����� ������ @PackageID, �������� TOP @Count ������� �� ������� 
ecr.LogEntitiesStorage � ����������� ASC �� ���� RowId.
����� ��������� ������� xml @XmlStr.
����� ��������� ��� ��������� ������� � ������� ecr.LogEntitiesStorage �������� �������
PackageID_Xml ��������� @PackageID.
*/
-- =============================================
CREATE PROCEDURE [ecr].[CollectEntityChanges_Xml]
	@Count int = 100			-- ���������� ���������� �������, �������� ���������� ������ ������
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
					0	-- ��� Entity
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
		raiserror(N'Error 19600304: ������ ��� �������� � XML �������� �����������!', 16, 1)

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
	-- ���������� ������:
begin catch

	-- ���� ���������� �������, �� ���������� ����������;
	if @@trancount <> 0 rollback tran;
	
	set @ErrMsg = N'������: '
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
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(24) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[CollectViewChanges_Xml]    Script Date: 02/10/2010 20:29:37 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(25) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(26) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		tpg
-- Create date: 03.09.2008
/* Description:
��������� ������� ������ � ������ � ������� ecr.XmlPackage
� ���������� ����� ������ @PackageID, �������� TOP @Count ������� �� ������� 
ecr.LogViewesStorage � ����������� ASC �� ���� RowId.
����� ��������� ������� xml @XmlStr.
����� ��������� ��� ��������� ������� � ������� ecr.LogViewesStorage �������� �������
PackageID_Xml ��������� @PackageID.
*/
-- =============================================
CREATE PROCEDURE [ecr].[CollectViewChanges_Xml]
--	@ViewName nvarchar(128)	-- ��������� ��� ��������, ��������� �� ���� DisplayAlias
								-- �� ������� ecr.Views
	@Count int = 100			-- ���������� ���������� �������, �������� ���������� ������ ������
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
					1	-- ��� View
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
		raiserror(N'Error 19600304: ������ ��� �������� � XML �������� �����������!', 16, 1)

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
	-- ���������� ������:
begin catch

	-- ���� ���������� �������, �� ���������� ����������;
	if @@trancount <> 0 rollback tran;
	
	set @ErrMsg = N'������: '
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
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(27) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[DeleteItem]    Script Date: 02/10/2010 20:29:37 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(28) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(29) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 05.02.2008
-- Description:	��������� ������� ������� � ��� ��� ������������� �� ������ ecr.EntitiesStorage,
-- ecr.ViewsStorage;
--		� ������, ����� HistoryLifeTime > 0 ������� ������ �� �������� �� ������� ecr.ViewsStorage
--		� ��������� ��� �������� � ������� ecr.EntitiesStorage ��������, ������ NULL
--		� ��������������� �������� ������� �������� ��������;
-- =============================================
CREATE PROCEDURE [ecr].[DeleteItem] 
	@DisplayAlias int
	, @ItemKey nvarchar(50)
	, @ItemNumber int = null
AS
	SET NOCOUNT ON;

	declare @_lifetime int
	declare @_hCount int
	declare @ErrMsg nvarchar(4000)

begin try

	if not exists
			(
			select
				*
			from ecr.Entities
			where DisplayAlias = @DisplayAlias
			)
		raiserror (N'������: ��� ������ � �������� � ������� ���������', 10, 1);	


	-- ��������� ����������;
	begin tran
			
/* �������� ������������� ���������� � ����� ������ - ���������� �� ����, ������ ������� ��� ��� */
	if @ItemNumber is null
		delete
			vs
		from ecr.ViewsStorage vs
		inner join ecr.Views v on vs.DisplayAlias = v.DisplayAlias
			and vs.ItemNumber is null
		inner join ecr.Entities e on v.EntityParent = e.ID
			and e.DisplayAlias = @DisplayAlias;
	else
		delete
			vs
		from ecr.ViewsStorage vs
		inner join ecr.Views v on vs.DisplayAlias = v.DisplayAlias
			and vs.ItemNumber = @ItemNumber
		inner join ecr.Entities e on v.EntityParent = e.ID
			and e.DisplayAlias = @DisplayAlias;
		
/* �������� ��������������� �������� */

	select
		@_lifetime = HistoryLifeTime
	from ecr.Entities
	where DisplayAlias = @DisplayAlias;

	if @_lifetime > 0 begin
				
		if @ItemNumber is null
			select
				@_hCount = count(*)
			from ecr.EntitiesStorage
			where DisplayAlias = @DisplayAlias
			and ItemKey = @ItemKey
			and ItemNumber is null;
		else
			select
				@_hCount = count(*)
			from ecr.EntitiesStorage
			where DisplayAlias = @DisplayAlias
			and ItemKey = @ItemKey;

		if @_hCount = @_lifetime begin
					
			if @ItemNumber is null
				delete
					ecr.EntitiesStorage
				where DisplayAlias = @DisplayAlias
				and ItemKey = @ItemKey
				and ItemNumber is null;
			else
				delete
					ecr.EntitiesStorage
				where DisplayAlias = @DisplayAlias
				and ItemKey = @ItemKey;


			/* ������������ ������� �� ���������� ������ �������� */
			insert
				ecr.EntitiesStorage
					(
					DisplayAlias
					, ItemKey
					, ItemBody
					, HistoryIndex
					)
				select
					@DisplayAlias
					, @ItemKey
					, null
					, max(HistoryIndex) + 1
				from ecr.EntitiesStorage
				where DisplayAlias = @DisplayAlias
				and ItemKey = @ItemKey;
		end
		else begin
			/* ������������ ������� �� �������� ������ � �������� */
			if @ItemNumber is null
				delete
					ecr.EntitiesStorage
				where DisplayAlias = @DisplayAlias
				and ItemNumber is null;
			else
				delete
					ecr.EntitiesStorage
				where DisplayAlias = @DisplayAlias
				and ItemNumber = @ItemNumber;
		end
	end		
	commit
	
end try
	-- ���������� ������:
begin catch

	-- ���� ���������� �������, �� ���������� ����������;
	if @@trancount <> 0 rollback tran;
	
	set @ErrMsg = N'������: '
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
	return 1

end catch;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(30) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetEntityItem]    Script Date: 02/10/2010 20:29:37 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(31) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(32) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 31.01.2008
-- Description:
--   ��������� ���������� ������ � ������� ecr_StorageBase, ��������������� ��������� ���� �������� (@ContentTypeAlias),
--		��������� ����� (@ItemKey), ������� �������� (@ItemNumber) � ������� ������� �������� (@HistoryIndex),
--		���� ������ ����� ������; 
--   ��������� @ItemNumber � @HistoryIndex �� ��������� ����� NULL � ����� ���� �� ������;
--   �������� @ItemNumber == NULL ��������, ��� ������ �������� ��� ������� ���� �������� �� �����
--		(������� ��������� ����� ������������� ������ ���� ������� ��������� ���� ��������), ������� ������ � ItemNumber == NULL;
--	 � ������, ���� �������� @HistroyIndex �� �����, ������� ��� �������, ��������������� ��������� �������, ������� ������������;
--   ��������� ���������� �������� �������� ������� ��������� � ������� ecr_ContentTypes
--		(���� ECR_Config, ���� ��������������� �������);
--   � ������, ���� @HistoryIndex ����� � ������������ ��������� �������, ������������ ������;	
-- =============================================
CREATE PROCEDURE [ecr].[GetEntityItem]
	-- Add the parameters for the stored procedure here
	@DisplayAlias int
	, @ItemKey nvarchar(50)
	, @ItemNumber int = null
	, @HistoryIndex int = null
with execute as owner
AS
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	
	declare @rows int
	declare @strSQL nvarchar(4000)
	
	if not exists
			(
			select
				*
			from ecr.Entities
			where DisplayAlias = @DisplayAlias
			) begin
		raiserror (N'������: ��� ������ � ���� �������� � ������� ���������', 10, 1);	
		return 1;
	end

	/* ContentTypeAlias, ItemKey */
	set @strSQL = N'select
	*
from ecr.EntitiesStorage
where DisplayAlias = ' + CAST(@DisplayAlias as nvarchar(20)) + '
and ItemKey = ''' + @ItemKey + ''''
	
	/* ItemNumber */
	if @ItemNumber is null
		set @strSQL = @strSQL + N'
and ItemNumber is null'
	else begin
		/* @ItemNumber = 0 ���������� ������� ���� ��������� �� ��������� ����� */
		if (@ItemNumber != 0) begin
			set @strSQL = @strSQL + N'
and ItemNumber = ' + CAST(@ItemNumber AS nvarchar(20))
		end
	end

	/* HistoryIndex */
	if @HistoryIndex is not null
		and @HistoryIndex > 0
		set @strSQL = @strSQL + N'
and HistoryIndex = ' + CAST(@HistoryIndex AS nvarchar(20)) + N'
order by HistoryIndex desc'
	else begin
		if @HistoryIndex = 0
			set @strSQL = N'select
	*
from
	(
	' + @strSQL + N'
	) a
where a.HistoryIndex = (select max(HistoryIndex) from
		(
' + @strSQL + N') b
		) order by HistoryIndex desc'
	end
	if @HistoryIndex is null
		set @strSQL = @strSQL + N'
order by HistoryIndex desc'

	/* �������������� ���������� �� ItemNumber */
	if @ItemNumber is not null
		set @strSQL = @strSQL + N'
, ItemNumber asc'
	
	exec(@strSQL)
	
	set @rows = @@rowcount
	if @HistoryIndex is not null
		and @rows > 1 begin		/* ������: ���������� ��������� ������� ������ 1 */
		RAISERROR (N'������: ���������� ��������� ������� �� ������������� ������� ������', 10, 1);	
		return @rows;
	end

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(33) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetHistoryLifeTime]    Script Date: 02/10/2010 20:29:37 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(34) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(35) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 22.04.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetHistoryLifeTime] 
	@SystemName nvarchar(128)
AS
	SET NOCOUNT ON;

	if not exists
			(
			select
				*
			from ecr.Entities
			where SystemName = @SystemName
			)
		raiserror(N'������: ��� ������ � �������� � ������� ���������', 10, 1);
	else
		select
			ID
			, EntityID
			, SystemName
			, DisplayName
			, DisplayAlias
			, Description
			, Comments
			, HistoryLifeTime
			, IsMultiplied
			, Extensions
		from ecr.Entities
		where SystemName = @SystemName;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(36) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[GetViewItem]    Script Date: 02/10/2010 20:29:37 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(37) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(38) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		MX
-- Create date: 05.02.2008
-- Description:	
-- =============================================
CREATE PROCEDURE [ecr].[GetViewItem] 
	@DisplayAlias int
	, @ItemKey nvarchar(50)
	, @ItemNumber int = null
AS
	SET NOCOUNT ON;

begin try
	if not exists
			(
			select
				*
			from ecr.Views	--dbo.ecr_ContentViews
			where DisplayAlias = @DisplayAlias
			)
		raiserror(N'������: ��� ������ � ������������� �������� � ������� ���������', 10, 1);

	if @ItemNumber is null
		select
			ID
			, DisplayAlias
			, ItemKey
			, ItemNumber
			, ItemBody
		from ecr.ViewsStorage
		where ItemKey = @ItemKey and
			ItemNumber is null;

		else begin
			if @ItemNumber = 0
				select
					ID
					, DisplayAlias
					, ItemKey
					, ItemNumber
					, ItemBody
				from ecr.ViewsStorage
				where ItemKey = @ItemKey
				order by ItemNumber;
			else
				select
					ID
					, DisplayAlias
					, ItemKey
					, ItemNumber
					, ItemBody
				from ecr.ViewsStorage
				where ItemKey = @ItemKey and
					ItemNumber = @ItemNumber;
		end

end try

-- ���������� ������:
begin catch
	return 1;
end catch;

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(39) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[NextPackageID_Get]    Script Date: 02/10/2010 20:29:37 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(40) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(41) BEGIN TRANSACTION END
GO

-- =============================================
-- Author:		tpg
-- Create date: 03.09.2008
-- Description:	��������� ���������� "���������" ����� ������.
-- =============================================
CREATE PROCEDURE [ecr].[NextPackageID_Get]
	@PackageType int = 0
	, @PackageID int = 1 output
AS
SET NOCOUNT ON;

declare @ErrMsg nvarchar(4000)
declare @RC int

begin try

begin tran
	-- �������� ��������� �����
	update
		ecr.LastPackageNumber with(updlock)
	set @PackageID = PackageNumber = PackageNumber + 1
	where PackageType = @PackageType;
	-- ��� ��������
	set @RC = @@rowcount;
	-- ���� ����� �� �������
	if @RC = 0
		begin
			-- ������� ���
			insert
				ecr.LastPackageNumber
			values
				(
				@PackageType
				, 1
				);
			--  � ����������� ��� 1
			set @PackageID = 1;
		end
	-- ���� � ������� ����� 1 ������, ��������� ������
	if @RC > 1
		raiserror(N'���������� ������: � ������� ���������� ������ ������ ����� ����� 1!', 16, 1);

commit tran

end try
	-- ���������� ������:
begin catch

	-- ���� ���������� �������, �� ���������� ����������;
	if @@trancount <> 0 rollback tran;
	
	set @ErrMsg = N'������: '
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
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(42) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[UpdateEntityItem]    Script Date: 02/10/2010 20:29:37 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(43) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(44) BEGIN TRANSACTION END
GO


-- =============================================
-- Author:		MX
-- Create date: 05.02.2008
-- Description:	��������� ���������/��������� ������� � ������� ecr.EntitiesStorage (���������);
-- Insert ���������� �����, �����:
--		1. � ecr.EntitiesStorage ��� �������� � ��������� �����������;
--		2. � ecr.EntitiesStorage ���� �������(�) � ���������� �����������, �� �� ���������� K �� ���������
--	HistoryLifeTime ��� �������� �������� �� ������� ecr.Entities (��������� �������������� �� ��������� DisplayAlias);
--  � ������, ����� K >= HistoryLifeTime ������� � ecr.EntitiesStorage,
--	 ������� ����� ������ ������ ������� �������� HistoryIndex, ���������,
--   ����� � ecr.EntitiesStorage ������������ ����� ������ � ����� HistoryIndex ���������� �����������;
--  �.�. � ecr.EntitiesStorage ������ ��������� ����� ��������� � ��������� �����������,
--   ������ ����� HistoryLifeTime ��� ��������������� �������� �� ������� ecr.Entities, ���� ������� ����������;
-- Update ���������� �����, ����� ������� � ��������� ����������� ���� � ������� ecr.EntitiesStorage
-- � �������� HistoryIndex ����� 0 (������� ������� ��� �������� �������� �� ������� Entities �� ��������);
-- ���������:
--	@DisplayAlias: ������������� ������������� �������� (��������� �� ������� ecr.Entities);
--  @ItemKey: ���� �������;
--  @ItemNumber: ����� �������, ��� ������� � ecr.Entity.IsMultiplied = 0 ������ == NULL,
--   � ��������� ������ ����� ������������� exception;
--  @ItemBody: ���� ��������� (�����);
--		����������� �������� NULL ������������ ������ ��������� ecr.DeleteItem � ���������������� �����������;
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

	-- ��������� �� NULL @ItemNumber ecr.Entity.IsMultiplied = 0
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
		raiserror(N'��� ��������������� �������� ��� ������� ����� �������!', 16, 1);

	-- ���� ����� ��� ������������� �������� < 1, ��������� ����������
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
		raiserror(N'��� ������������� �������� ��� ������� ����� ������� ������ 1!', 16, 1);

	-- ���� ���� ��������� �����������, ������� �������
	if @ItemBody is null
		begin
			exec ecr.[DeleteItem] 
				@DisplayAlias
				, @ItemKey
				, @ItemNumber;
			return;
		end

-- �������� ����������
begin tran
	-- ���������� ���������� ����� ������� �������� ������� ��� ������ ��������
	select
		@HistoryLifeTime = HistoryLifeTime
	from ecr.Entities
	where DisplayAlias = @DisplayAlias;

	-- ���� ����� ���������� �������� ��������� 0
	if @HistoryLifeTime > 0
		begin
			
			-- ��������� �������� � ����������
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
				
			-- ���� ����� �������� ��������� ����������
			if @HistoryLifeTime < @LT									
				-- , ��:
				
				if @ItemNumber is null begin
					
					-- ������� ����� ����� ������ ������ �����
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
					
					-- � ������� ��� �� ��������� ������
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
	-- ���� �� �������� ������� �� �������
	else
		begin
			-- ��������� �������� � ���������
			update
				ecr.EntitiesStorage with(updlock)
			set
				ItemKey = @ItemKey
				, ItemBody = @ItemBody
				, HistoryIndex = 0
			where DisplayAlias = @DisplayAlias;

			-- ���� �������� ��� ������
			if @@rowcount = 0
				-- , �� ��������� ��������
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
								)
		end
commit

end try
	-- ���������� ������:
begin catch

	-- ���� ���������� �������, �� ���������� ����������;
	if @@trancount <> 0 rollback tran;
	
	set @ErrMsg = N'������: '
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
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(45) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[UpdateViewItem]    Script Date: 02/10/2010 20:29:37 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(46) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(47) BEGIN TRANSACTION END
GO


-- =============================================
-- Author:		tpg
-- Create date: 01.07.2008
-- Description:	��������� ���������/��������� ������� � ������� ecr.ViewsStorage (�������������);
-- =============================================
CREATE PROCEDURE [ecr].[UpdateViewItem] 
	@DisplayAlias int
	, @ItemKey nvarchar(50)
	, @ItemNumber int = NULL
	, @ItemBody varbinary(max) = NULL
AS
	SET NOCOUNT ON;

	declare @ErrMsg nvarchar(4000)

begin try

	-- ��������� ����������;
	begin tran

		if @ItemNumber is not null begin

			update
				ecr.ViewsStorage with(updlock)	-- ���� ��� �������� ����������� �������������
											-- ���������������� �� ������������� ��������
											-- (�������� �������� ������ ������, � ��� ������� - ���)
			set
				ItemKey = @ItemKey
				, ItemNumber = @ItemNumber
				, ItemBody = @ItemBody
			where DisplayAlias = @DisplayAlias
				and ItemKey = @ItemKey
				and ItemNumber = @ItemNumber;
		
			-- ���� ������ �� ����������, ��������� ������
			if @@rowcount = 0
				insert
				ecr.ViewsStorage
					(
					DisplayAlias
					, ItemKey
					, ItemNumber
					, ItemBody
					)
				select
					@DisplayAlias
					, @ItemKey
					, @ItemNumber
					, @ItemBody
				where not exists
						(
						select
							*
						from ecr.ViewsStorage
						where DisplayAlias = @DisplayAlias
							and ItemKey = @ItemKey
							and ItemNumber = @ItemNumber	
						);

		end
		else begin

			update
				ecr.ViewsStorage with(updlock)	-- ���� ��� �������� ����������� �������������
											-- ���������������� �� ������������� ��������
											-- (�������� �������� ������ ������, � ��� ������� - ���)
			set
				ItemKey = @ItemKey
				, ItemNumber = null
				, ItemBody = @ItemBody
			where DisplayAlias = @DisplayAlias
				and ItemKey = @ItemKey
				and ItemNumber is null;

			-- ���� ������ �� ����������, ��������� ������
			if @@rowcount = 0
				insert
				ecr.ViewsStorage
					(
					DisplayAlias
					, ItemKey
					, ItemNumber
					, ItemBody
					)
				select
					@DisplayAlias
					, @ItemKey
					, @ItemNumber
					, @ItemBody
				where not exists
						(
						select
							*
						from ecr.ViewsStorage
						where DisplayAlias = @DisplayAlias
							and ItemKey = @ItemKey
							and ItemNumber is null	
						);
		end

	commit

end try
	-- ���������� ������:
begin catch

	-- ���� ���������� �������, �� ���������� ����������;
	if @@trancount <> 0 rollback tran;
	
	set @ErrMsg = N'������: '
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
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(48) BEGIN TRANSACTION END
GO




GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(49) BEGIN TRANSACTION END
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
