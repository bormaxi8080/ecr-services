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
    @OldVersion = N'1.2.11.17'
    , @NewVersion = N'1.2.12.18'
    , @Description = left(N'Добавление хранимой процедуры dbo.adm_DefragmentationIndexes', 255);
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
/****** Object:  StoredProcedure [dbo].[adm_DefragmentationIndexes]    Script Date: 06/25/2009 11:34:38 ******/
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
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(3) BEGIN TRANSACTION END
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
