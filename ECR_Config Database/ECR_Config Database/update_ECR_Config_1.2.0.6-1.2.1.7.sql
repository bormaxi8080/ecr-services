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
    @OldVersion = N'1.2.0.6'
    , @NewVersion = N'1.2.1.7'
    , @Description = left(N'���������� �������������� �������� �������� ECR, �������� ��������� ��� �������� ���������� � ���', 255);
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
PRINT N'Creating ECR objects...'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(1) BEGIN TRANSACTION END
GO

/****** Object:  Table [ecr].[SourceCatalogBindings]    Script Date: 05/25/2009 11:03:54 ******/
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
SET ANSI_PADDING ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(4) BEGIN TRANSACTION END
GO
CREATE TABLE [ecr].[SourceCatalogBindings](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[EntityID] [uniqueidentifier] NOT NULL,
	[SourceCatalogID] [uniqueidentifier] NOT NULL,
	[Priority] [int] NOT NULL,
	[Enabled] [char](10) NOT NULL CONSTRAINT [DF_ecr_SourceCatalogBindings_Disabled]  DEFAULT ((1)),
 CONSTRAINT [PK_ecr_SourceCatalogBindings] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(5) BEGIN TRANSACTION END
GO
SET ANSI_PADDING OFF
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(6) BEGIN TRANSACTION END
GO

PRINT N'Creating [ecr].[UpdateContentCountByType]'
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(7) BEGIN TRANSACTION END
GO

SET ANSI_NULLS ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(8) BEGIN TRANSACTION END
GO
SET QUOTED_IDENTIFIER ON
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(9) BEGIN TRANSACTION END
GO
-- =============================================
-- Author:		�������� ���������
-- Create date: 22 ��� 2009
-- Description:	��������� ��������� ��������� ���� 
--		��������� ������� #warekeys, ���������� 
-- 		���������� ����������� ������ � ������������
--		� ��������� ����� ��������
--   @contentType nvarchar(100) - ��� ��������
--	 @fieldName nvarchar(100) - ��� ���� � #warekeys
-- =============================================
CREATE PROCEDURE [ecr].[UpdateContentCountByType]
     @contentType nvarchar(100)
	,@fieldName nvarchar(100)
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
		ECR_Storage1.ecr.EntitiesStorage estg join #warekeys w 
			on (estg.ItemKey = w.WareKey collate Cyrillic_General_CI_AS)
			and(estg.DisplayAlias = @DisplayAlias)
	group by
		estg.ItemKey

	update
		w
	set
		w.<warekeys_fieldName> = b.<warekeys_fieldName>
	from 
		#buff b	join #warekeys w 
			on b.WareKey = w.WareKey collate Cyrillic_General_CI_AS
	'

	set @redCode = replace(@redCode, N'<ECR_Storage_DATABASENAME>', @DataBase)
	set @redCode = replace(@redCode, N'<ECR_Storage_SERVERNAME>.', @ServerName)
	set @redCode = replace(@redCode, N'<warekeys_fieldName>', @fieldName)
	
	exec sp_executesql 
	  @redCode ,
	  N'@DisplayAlias int', 
	  @DisplayAlias = @DisplayAlias
END
GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(10) BEGIN TRANSACTION END
GO


GO
IF @@ERROR<>0 AND @@TRANCOUNT>0 ROLLBACK TRANSACTION
GO
IF @@TRANCOUNT=0 BEGIN INSERT INTO #t06EC11F4EBEA4449B2A36E9ACD969B95 VALUES(11) BEGIN TRANSACTION END
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