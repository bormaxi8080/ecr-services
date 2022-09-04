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
    @OldVersion = N'1.1.3.11'
    , @NewVersion = N'1.1.4.12'
    , @Description = left(N'����������� ������ � �������� ��������� ecr.UpdateEntityItem', 255);
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
/****** Object:  StoredProcedure [ecr].[UpdateEntityItem]    Script Date: 02/10/2010 21:38:22 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[UpdateEntityItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [ecr].[UpdateEntityItem]
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(1) BEGIN TRANSACTION END
GO

/****** Object:  StoredProcedure [ecr].[UpdateEntityItem]    Script Date: 02/10/2010 21:38:41 ******/
SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(2) BEGIN TRANSACTION END
GO

SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(3) BEGIN TRANSACTION END
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
	--if @ItemBody is null
	--	begin
	--		exec ecr.[DeleteItem] 
	--			@DisplayAlias
	--			, @ItemKey
	--			, @ItemNumber;
	--		return;
	--	end

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
					
					-- � ������� ��� �� ��������� ������!!! ��� ��� � ����� �����!!! �����...
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
			
			if @ItemNumber is null begin
			
				-- ��������� �������� � ���������
				update
					ecr.EntitiesStorage with(updlock)
				set
					ItemKey = @ItemKey
					, ItemBody = @ItemBody
					, HistoryIndex = 0
				where DisplayAlias = @DisplayAlias
					and ItemKey = @ItemKey
					and ItemNumber is null;
					
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
									and ItemKey = @ItemKey
									and ItemNumber is null
								)
			
			end
			
			else begin
			
				update
					ecr.EntitiesStorage with(updlock)
				set
					ItemKey = @ItemKey
					, ItemBody = @ItemBody
					, HistoryIndex = 0
				where DisplayAlias = @DisplayAlias
					and ItemKey = @ItemKey
					and ItemNumber = @ItemNumber;
					
				if @@rowcount = 0
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
									and ItemKey = @ItemKey
									and ItemNumber = @ItemNumber
								)
			
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
	return 1;
end catch;


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
