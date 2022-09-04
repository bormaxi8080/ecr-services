set nocount on
declare @Version nvarchar(50), @SQL varchar(1000)
set @Version = '1.0.1.2'
if not exists(select * from dbo.VersionHistory where [Version] = @Version) begin
	insert into dbo.VersionHistory ([Version], VersionDate, [Description])
	select @Version, getdate(), 'Удаление native колонок из лог-таблиц; удаление хранимых процедур нативных выгрузок данных из ECR'
end else begin
	set @SQL = 'Обновление ' + @Version + ' уже ранее применено...' 
	raiserror(@SQL, 25, 1) with log
end
GO

/****** Object:  StoredProcedure [ecr].[CollectEntityChanges_Native]    Script Date: 12/23/2008 19:21:54 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[CollectEntityChanges_Native]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [ecr].[CollectEntityChanges_Native]
GO

/****** Object:  StoredProcedure [ecr].[CollectViewChanges_Native]    Script Date: 12/23/2008 19:22:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[CollectViewChanges_Native]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [ecr].[CollectViewChanges_Native]
GO

/****** Object:  StoredProcedure [ecr].[UpdateLogEntities_Native]    Script Date: 12/23/2008 19:23:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[UpdateLogEntities_Native]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [ecr].[UpdateLogEntities_Native]
GO

/****** Object:  StoredProcedure [ecr].[UpdateLogViews_Native]    Script Date: 12/23/2008 19:23:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ecr].[UpdateLogViews_Native]') AND type in (N'P', N'PC'))
	DROP PROCEDURE [ecr].[UpdateLogViews_Native]
GO

ALTER TABLE ecr.LogEntitiesStorage
	DROP COLUMN DateOut_Native
GO

ALTER TABLE ecr.LogViewsStorage
	DROP COLUMN DateOut_Native
GO