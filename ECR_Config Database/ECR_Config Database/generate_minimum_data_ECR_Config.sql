SET NOCOUNT ON
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Storages]') AND name = N'IX_ecr_Storages')
ALTER TABLE [ecr].[Storages] DROP CONSTRAINT [IX_ecr_Storages]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Storages]') AND name = N'IX_ecr_Storages_1')
ALTER TABLE [ecr].[Storages] DROP CONSTRAINT [IX_ecr_Storages_1]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Storages]') AND name = N'IX_ecr_Storages_2')
ALTER TABLE [ecr].[Storages] DROP CONSTRAINT [IX_ecr_Storages_2]
GO

SET IDENTITY_INSERT [ecr].[Storages] ON
GO

INSERT [ecr].[Storages]([StorageID],[SystemName],[DisplayName],[DisplayAlias],[Description],[Comments],[Enabled],[RemoteServerName],[ConnectionString]) VALUES ('{f6095569-0571-49e0-8ef6-7c816f484f20}',N'ecr.storage1',N'Хранилище 1',1,N'База данных распределенного хранилища файлового контента - обложки книг',N'EBK-SQL\ECR_Storage1',1,NULL,N'Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=ECR_Storage1;Data Source=EBK-SQL;Connection Timeout=30000')
GO
INSERT [ecr].[Storages]([StorageID],[SystemName],[DisplayName],[DisplayAlias],[Description],[Comments],[Enabled],[RemoteServerName],[ConnectionString]) VALUES ('{0500f86a-8200-41ca-a2b7-f80ba94a363b}',N'ecr.storage2',N'Хранилище 2',2,N'База данных распределенного хранилища файлового контента - аннотации книг',N'EBK-SQL\ECR_Storage2',1,NULL,N'Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=ECR_Storage2;Data Source=EBK-SQL;Connection Timeout=30000')
GO
INSERT [ecr].[Storages]([StorageID],[SystemName],[DisplayName],[DisplayAlias],[Description],[Comments],[Enabled],[RemoteServerName],[ConnectionString]) VALUES ('{55f8a326-6cda-4623-a4ac-04f16e1147fa}',N'ecr.storage3',N'Хранилище 3',3,N'База данных распределенного хранилища файлового контента - персоны',N'EBK-SQL\ECR_Storage_Persons',1,NULL,N'Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=ECR_Storage_Persons;Data Source=EBK-SQL;Connection Timeout=30000')
GO
INSERT [ecr].[Storages]([StorageID],[SystemName],[DisplayName],[DisplayAlias],[Description],[Comments],[Enabled],[RemoteServerName],[ConnectionString]) VALUES ('{bf5fe705-4915-48C7-ad74-089f28aa66de}',N'ecr.storage4',N'Хранилище 4',4,N'База данных распределенного хранилища файлового контента - организации',N'EBK-SQL\ECR_Storage_Organizations',1,NULL,N'Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=ECR_Storage_Organizations;Data Source=EBK-SQL;Connection Timeout=30000')
GO
INSERT [ecr].[Storages]([StorageID],[SystemName],[DisplayName],[DisplayAlias],[Description],[Comments],[Enabled],[RemoteServerName],[ConnectionString]) VALUES ('{5cc12ffc-2124-4241-a8e3-20576f4677c1}',N'ecr.storage5',N'Хранилище 5',5,N'База данных распределенного хранилища файлового контента - серии',N'EBK-SQL\ECR_Storage_Series',1,NULL,N'Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=ECR_Storage_Series;Data Source=EBK-SQL;Connection Timeout=30000')
GO

SET IDENTITY_INSERT [ecr].[Storages] OFF
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Storages]') AND name = N'IX_ecr_Storages')
ALTER TABLE [ecr].[Storages] ADD  CONSTRAINT [IX_ecr_Storages] UNIQUE NONCLUSTERED 
(
	[StorageID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Storages]') AND name = N'IX_ecr_Storages_1')
ALTER TABLE [ecr].[Storages] ADD  CONSTRAINT [IX_ecr_Storages_1] UNIQUE NONCLUSTERED 
(
	[SystemName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Storages]') AND name = N'IX_ecr_Storages_2')
ALTER TABLE [ecr].[Storages] ADD  CONSTRAINT [IX_ecr_Storages_2] UNIQUE NONCLUSTERED 
(
	[DisplayAlias] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

SET NOCOUNT ON
GO

ALTER TABLE [ecr].[Entities] NOCHECK CONSTRAINT [FK_Entities_Storages]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Entities]') AND name = N'IX_ecr_Entities')
ALTER TABLE [ecr].[Entities] DROP CONSTRAINT [IX_ecr_Entities]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Entities]') AND name = N'IX_ecr_Entities_1')
ALTER TABLE [ecr].[Entities] DROP CONSTRAINT [IX_ecr_Entities_1]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Entities]') AND name = N'IX_ecr_Entities_2')
ALTER TABLE [ecr].[Entities] DROP CONSTRAINT [IX_ecr_Entities_2]
GO

SET IDENTITY_INSERT [ecr].[Entities] ON
GO

INSERT [ecr].[Entities]([EntityID],[SystemName],[DisplayName],[DisplayAlias],[Description],[Comments],[StorageID],[HistoryLifeTime],[IsMultiplied],[Extensions]) VALUES ('{a2fe684c-57ec-4117-8ac3-38f004283938}',N'Books.Covers.Face',N'Обложки книг - лицевая часть',1,'Обложки книг - лицевая часть (необработанные оригиналы)','Оригиналы изображений в формате JPEG (полиграфическое качество)',1,5,0,N'jpg')
GO
INSERT [ecr].[Entities]([EntityID],[SystemName],[DisplayName],[DisplayAlias],[Description],[Comments],[StorageID],[HistoryLifeTime],[IsMultiplied],[Extensions]) VALUES ('{c0977a79-9501-42c9-9c1a-26349dbe9d76}',N'Books.Annots',N'Аннотации книг',2,N'Аннотации книг - неразмеченный текст',N'Текст аннотации в формате TXT без какой-либо разметки',2,5,0,N'txt')
GO
INSERT [ecr].[Entities]([EntityID],[SystemName],[DisplayName],[DisplayAlias],[Description],[Comments],[StorageID],[HistoryLifeTime],[IsMultiplied],[Extensions]) VALUES ('{74ce895c-ebb8-4c3d-aadc-580180d8753f}',N'PCards.Face',N'Изображения открыток - лицевая часть',3,N'Изображения открыток - лицевая часть (необработанные оригиналы)',N'Оригиналы изображений в формате JPEG (полиграфическое качество)',1,0,0,N'jpg')
GO
INSERT [ecr].[Entities]([EntityID],[SystemName],[DisplayName],[DisplayAlias],[Description],[Comments],[StorageID],[HistoryLifeTime],[IsMultiplied],[Extensions]) VALUES ('{99806ae0-24b9-41af-a2fd-b5706c679c80}',N'Books.Contents',N'Оглавления книг',4,N'Оглавления книг',N'Исходники оглавлений книг',1,0,0,N'txt')
GO
INSERT [ecr].[Entities]([EntityID],[SystemName],[DisplayName],[DisplayAlias],[Description],[Comments],[StorageID],[HistoryLifeTime],[IsMultiplied],[Extensions]) VALUES ('{41C0383b-0e50-44c0-9467-5ea099e5ce01}',N'Persons',N'Персоны',5,N'Персоны',N'Фотографии персон',6,0,0,N'jpg')
GO
INSERT [ecr].[Entities]([EntityID],[SystemName],[DisplayName],[DisplayAlias],[Description],[Comments],[StorageID],[HistoryLifeTime],[IsMultiplied],[Extensions]) VALUES ('{89b9cc78-a92e-4b4f-82bb-66b900b823b7}',N'Organizations',N'Организации',6,N'Организации',N'Логотипы организаций',7,0,0,N'jpg')
GO
INSERT [ecr].[Entities]([EntityID],[SystemName],[DisplayName],[DisplayAlias],[Description],[Comments],[StorageID],[HistoryLifeTime],[IsMultiplied],[Extensions]) VALUES ('{82e364c1-5dc2-427b-a790-c706190f8129}',N'Series',N'Серии',7,N'Серии',N'Логотипы серий',8,0,0,N'jpg')
GO

SET IDENTITY_INSERT [ecr].[Entities] OFF
GO

ALTER TABLE [ecr].[Entities] CHECK CONSTRAINT [FK_Entities_Storages]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Entities]') AND name = N'IX_ecr_Entities')
ALTER TABLE [ecr].[Entities] ADD  CONSTRAINT [IX_ecr_Entities] UNIQUE NONCLUSTERED 
(
	[EntityID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Entities]') AND name = N'IX_ecr_Entities_1')
ALTER TABLE [ecr].[Entities] ADD  CONSTRAINT [IX_ecr_Entities_1] UNIQUE NONCLUSTERED 
(
	[SystemName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Entities]') AND name = N'IX_ecr_Entities_2')
ALTER TABLE [ecr].[Entities] ADD  CONSTRAINT [IX_ecr_Entities_2] UNIQUE NONCLUSTERED 
(
	[DisplayAlias] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

SET NOCOUNT ON
GO

ALTER TABLE [ecr].[Views] NOCHECK CONSTRAINT [FK_Views_Entities]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Views]') AND name = N'IX_ecr_Views')
ALTER TABLE [ecr].[Views] DROP CONSTRAINT [IX_ecr_Views]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Views]') AND name = N'IX_ecr_Views_1')
ALTER TABLE [ecr].[Views] DROP CONSTRAINT [IX_ecr_Views_1]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Views]') AND name = N'IX_ecr_Views_2')
ALTER TABLE [ecr].[Views] DROP CONSTRAINT [IX_ecr_Views_2]
GO

SET IDENTITY_INSERT [ecr].[Views] ON
GO

INSERT [ecr].[Views]([ViewID],[SystemName],[DisplayName],[DisplayAlias],[RelativeNames],[Description],[Comments],[EntityParent],[Enabled],[Extensions]) VALUES ('{8c802e31-a046-4a73-92ba-cec513ce94a8}',N'Books.Covers.Face.JPEG.200',N'Обложки книг - лицевая часть, основное представление, 200 пикселей по ширине',1,N'ctImage',N'Обложки книг - лицевая часть, изображения в формате JPEG, 200 px по ширине',N'Масштабирование изображения по ширине',1,1,N'jpg')
GO
INSERT [ecr].[Views]([ViewID],[SystemName],[DisplayName],[DisplayAlias],[RelativeNames],[Description],[Comments],[EntityParent],[Enabled],[Extensions]) VALUES ('{d89d2b21-eff1-42ca-9ad0-24952089bedc}',N'Books.Covers.Face.GIF.60',N'Обложки книг - лицевая часть, представление для предварительного просмотра',2,NULL,N'Обложки книг - лицевая часть, изображения в формате GIF, 60 px по ширине',N'Масштабирование изображения по ширине',1,1,N'gif')
GO
INSERT [ecr].[Views]([ViewID],[SystemName],[DisplayName],[DisplayAlias],[RelativeNames],[Description],[Comments],[EntityParent],[Enabled],[Extensions]) VALUES ('{25369032-bb90-4ece-a737-4c99dff964e4}',N'PCards.Face.JPEG.150',N'Изображения открыток - лицевая часть, основное представление',3,NULL,N'Изображения открыток - лицевая часть в формате JPEG, 150 px по ширине',N'Масштабирование изображения по ширине',3,1,N'jpg')
GO
INSERT [ecr].[Views]([ViewID],[SystemName],[DisplayName],[DisplayAlias],[RelativeNames],[Description],[Comments],[EntityParent],[Enabled],[Extensions]) VALUES ('{ddaf1be2-93f0-407e-b9ed-8f7411acbf60}',N'PCards.Face.GIF.65',N'Изображения открыток - лицевая часть, представление для предварительного просмотра',4,NULL,N'Изображения открыток - лицевая часть в формате GIF, 65 px по ширине',N'Масштабирование изображения по ширине',3,1,N'gif')
GO
INSERT [ecr].[Views]([ViewID],[SystemName],[DisplayName],[DisplayAlias],[RelativeNames],[Description],[Comments],[EntityParent],[Enabled],[Extensions]) VALUES ('{6580b0d8-a1e6-4239-adac-77b84aeef542}',N'Books.Annots.HtmlText',N'Аннотации книг (text/html)',5,N'ctAnnot|ctAnnotation',N'Аннотации книг - форматированный элементами HTML текст',N'Простейшее форматирование HTML: расстановка тэгов <br>, <p>',2,1,N'txt')
GO
INSERT [ecr].[Views]([ViewID],[SystemName],[DisplayName],[DisplayAlias],[RelativeNames],[Description],[Comments],[EntityParent],[Enabled],[Extensions]) VALUES ('{3e825575-7ad9-4469-b488-34032359fa9d}',N'Books.Contents.HtmlText',N'Оглавления книг (text/html)',6,N'ctContents',N'Оглавления книг - форматированный элементами HTML текст',N'Простейшее форматирование HTML: расстановка тэгов <br>, <p>',4,1,N'txt')
GO
INSERT [ecr].[Views]([ViewID],[SystemName],[DisplayName],[DisplayAlias],[RelativeNames],[Description],[Comments],[EntityParent],[Enabled],[Extensions]) VALUES ('{1b425de0-59c1-497d-b868-229701beae9d}',N'Persons.JPEG.200',N'Персоны, основное представление, 200 пикселей по ширине',7,NULL,N'Фотографии персон, изображения в формате JPEG, 200 px по ширине',N'Масштабирование изображения по ширине',5,1,N'jpg')
GO
INSERT [ecr].[Views]([ViewID],[SystemName],[DisplayName],[DisplayAlias],[RelativeNames],[Description],[Comments],[EntityParent],[Enabled],[Extensions]) VALUES ('{29f614C3-c855-4f2d-b455-e7bf487a870d}',N'Persons.GIF.60',N'Персоны, представление для предварительного просмотра',8,NULL,N'Фотографии персон, изображения в формате GIF, 60 px по ширине',N'Масштабирование изображения по ширине',5,1,N'gif')
GO
INSERT [ecr].[Views]([ViewID],[SystemName],[DisplayName],[DisplayAlias],[RelativeNames],[Description],[Comments],[EntityParent],[Enabled],[Extensions]) VALUES ('{0cc18acb-6dbd-486b-b41c-beb1e2736203}',N'Series.JPEG.200',N'Серии, основное представление, 200 пикселей по ширине',9,NULL,N'Логотипы серий, изображения в формате JPEG, 200 px по ширине',N'Масштабирование изображения по ширине',7,1,N'jpg')
GO
INSERT [ecr].[Views]([ViewID],[SystemName],[DisplayName],[DisplayAlias],[RelativeNames],[Description],[Comments],[EntityParent],[Enabled],[Extensions]) VALUES ('{d0a22fe8-31c1-4b75-a052-35b8801ce95c}',N'Series.GIF.60',N'Серии, представление для предварительного просмотра',10,NULL,N'Логотипы серий, изображения в формате GIF, 60 px по ширине',N'Масштабирование изображения по ширине',7,1,N'gif')
GO
INSERT [ecr].[Views]([ViewID],[SystemName],[DisplayName],[DisplayAlias],[RelativeNames],[Description],[Comments],[EntityParent],[Enabled],[Extensions]) VALUES ('{087ad51c-1be1-46d1-ae17-8f9bc74d3e17}',N'Organizations.JPEG.200',N'Организации - лицевая часть, основное представление, 200 пикселей по ширине',11,NULL,N'Логотипы организаций, изображения в формате JPEG, 200 px по ширине',N'Масштабирование изображения по ширине',6,1,N'jpg')
GO
INSERT [ecr].[Views]([ViewID],[SystemName],[DisplayName],[DisplayAlias],[RelativeNames],[Description],[Comments],[EntityParent],[Enabled],[Extensions]) VALUES ('{b2c00f2b-f6da-45f4-affc-48414f703954}',N'Organizations.GIF.60',N'Организации, представление для предварительного просмотра',12,NULL,N'Логотипы организаций, изображения в формате GIF, 60 px по ширине',N'Масштабирование изображения по ширине',6,1,N'gif')
GO

SET IDENTITY_INSERT [ecr].[Views] OFF
GO

ALTER TABLE [ecr].[Views] CHECK CONSTRAINT [FK_Views_Entities]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Views]') AND name = N'IX_ecr_Views')
ALTER TABLE [ecr].[Views] ADD  CONSTRAINT [IX_ecr_Views] UNIQUE NONCLUSTERED 
(
	[ViewID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Views]') AND name = N'IX_ecr_Views_1')
ALTER TABLE [ecr].[Views] ADD  CONSTRAINT [IX_ecr_Views_1] UNIQUE NONCLUSTERED 
(
	[SystemName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Views]') AND name = N'IX_ecr_Views_2')
ALTER TABLE [ecr].[Views] ADD  CONSTRAINT [IX_ecr_Views_2] UNIQUE NONCLUSTERED 
(
	[DisplayAlias] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

SET NOCOUNT ON
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Bindings]') AND name = N'IX_ecr_Elements')
ALTER TABLE [ecr].[Bindings] DROP CONSTRAINT [IX_ecr_Elements]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Bindings]') AND name = N'IX_ecr_Elements_1')
ALTER TABLE [ecr].[Bindings] DROP CONSTRAINT [IX_ecr_Elements_1]
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Bindings]') AND name = N'IX_ecr_Elements_2')
ALTER TABLE [ecr].[Bindings] DROP CONSTRAINT [IX_ecr_Elements_2]
GO

SET IDENTITY_INSERT [ecr].[Bindings] ON
GO

INSERT [ecr].[Bindings]([BindingID],[SystemName],[DisplayName],[DisplayAlias],[RelativeNames],[KeyType],[Description],[Comments]) VALUES ('{41e38c3a-b73a-471b-a1aa-b54fd3727cf1}','Books','Продукты - Книги',1,'wtBook','tk.googskey','Представляет файловый контент, идентифицированный с товарами из книжных прайс-листов',NULL)
GO
INSERT [ecr].[Bindings]([BindingID],[SystemName],[DisplayName],[DisplayAlias],[RelativeNames],[KeyType],[Description],[Comments]) VALUES ('{e0c00c1d-06ac-47c2-983a-e7ff9557755a}','PostCards','Продукты - Открытки',2,'wtPostCard','tk.goodskey','Представляет файловый контент, идентифицированный с товарами из прайс-листов продукта "Открытки"',NULL)
GO
INSERT [ecr].[Bindings]([BindingID],[SystemName],[DisplayName],[DisplayAlias],[RelativeNames],[KeyType],[Description],[Comments]) VALUES ('{b08f0455-8159-454d-a4f8-a4caea558875}','Authors','Персоналии - Авторы',3,'bptAuthor',NULL,'Представляет файловый контент, идентифицированный с информацией об авторах','Для книжного контента')
GO
INSERT [ecr].[Bindings]([BindingID],[SystemName],[DisplayName],[DisplayAlias],[RelativeNames],[KeyType],[Description],[Comments]) VALUES ('{246b9b2c-284e-4ea9-b4f8-0a089bb1fb89}','Publishers','Издатели',4,'bptPublisher',NULL,'Представляет файловый контент, иедентифицированный с информацией об издателях','Для книжного контента')
GO
INSERT [ecr].[Bindings]([BindingID],[SystemName],[DisplayName],[DisplayAlias],[RelativeNames],[KeyType],[Description],[Comments]) VALUES ('{7e796b02-0854-435a-884a-f5e1c259afe5}','Producer','Производители',5,'bptProducer',NULL,'Представляет файловый контент, иедентифицированный с информацией о производителях','Для контента медиа')
GO
INSERT [ecr].[Bindings]([BindingID],[SystemName],[DisplayName],[DisplayAlias],[RelativeNames],[KeyType],[Description],[Comments]) VALUES ('{c6c61c0e-49e5-42c4-b1c1-85eca6a65ccd}','Actors','Актеры',6,'bptActor',NULL,'Представляет файловый контент, иедентифицированный с информацией об актерах','Для контента  медиа (видео)')
GO
INSERT [ecr].[Bindings]([BindingID],[SystemName],[DisplayName],[DisplayAlias],[RelativeNames],[KeyType],[Description],[Comments]) VALUES ('{4c27b023-e14d-46fc-8e7f-42d76a5ecf14}','Directors','Режиссеры',7,'bptDirector',NULL,'Представляет файловый контент, иедентифицированный с информацией о режиссерах','Для контента медиа (видео)')
GO
INSERT [ecr].[Bindings]([BindingID],[SystemName],[DisplayName],[DisplayAlias],[RelativeNames],[KeyType],[Description],[Comments]) VALUES ('{a8916335-fcf5-4bc3-990e-ad2ff9bcc744}','Singers','Исполнители',8,'bptSinger',NULL,'Представляет файловый контент, иедентифицированный с информацией об исполнителях','Для контента медиа (аудио)')
GO
INSERT [ecr].[Bindings]([BindingID],[SystemName],[DisplayName],[DisplayAlias],[RelativeNames],[KeyType],[Description],[Comments]) VALUES ('{b6c17fce-5595-4e28-a69e-ed0d1a9eec89}','Translators','Переводчики',9,'bptTranslator',NULL,'Представляет файловый контент, иедентифицированный с информацией о переводчиках','Для книжного контента')
GO
INSERT [ecr].[Bindings]([BindingID],[SystemName],[DisplayName],[DisplayAlias],[RelativeNames],[KeyType],[Description],[Comments]) VALUES ('{282cdaed-8c94-4d50-99cb-edf3edbff1f3}','Reviwers','Рецензенты',10,'bptReviewer',NULL,'Представляет файловый контент, иедентифицированный с информацией о рецензентах',NULL)
GO

SET IDENTITY_INSERT [ecr].[Bindings] OFF
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Bindings]') AND name = N'IX_ecr_Elements')
ALTER TABLE [ecr].[Bindings] ADD  CONSTRAINT [IX_ecr_Elements] UNIQUE NONCLUSTERED 
(
	[BindingID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Bindings]') AND name = N'IX_ecr_Elements_1')
ALTER TABLE [ecr].[Bindings] ADD  CONSTRAINT [IX_ecr_Elements_1] UNIQUE NONCLUSTERED 
(
	[SystemName] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[ecr].[Bindings]') AND name = N'IX_ecr_Elements_2')
ALTER TABLE [ecr].[Bindings] ADD  CONSTRAINT [IX_ecr_Elements_2] UNIQUE NONCLUSTERED 
(
	[DisplayAlias] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
GO

SET NOCOUNT ON
GO

ALTER TABLE [ecr].[EntityBindings] NOCHECK CONSTRAINT [FK_EntityBindings_Bindings]
GO

ALTER TABLE [ecr].[EntityBindings] NOCHECK CONSTRAINT [FK_EntityBindings_Entities]
GO

SET IDENTITY_INSERT [ecr].[EntityBindings] ON
GO

INSERT [ecr].[EntityBindings]([EntityID],[BindingID]) VALUES (1,1)
GO
INSERT [ecr].[EntityBindings]([EntityID],[BindingID]) VALUES (2,1)
GO
INSERT [ecr].[EntityBindings]([EntityID],[BindingID]) VALUES (3,2)
GO
INSERT [ecr].[EntityBindings]([EntityID],[BindingID]) VALUES (4,1)
GO
INSERT [ecr].[EntityBindings]([EntityID],[BindingID]) VALUES (5,3)
GO
INSERT [ecr].[EntityBindings]([EntityID],[BindingID]) VALUES (5,6)
GO
INSERT [ecr].[EntityBindings]([EntityID],[BindingID]) VALUES (5,7)
GO
INSERT [ecr].[EntityBindings]([EntityID],[BindingID]) VALUES (5,8)
GO
INSERT [ecr].[EntityBindings]([EntityID],[BindingID]) VALUES (5,9)
GO
INSERT [ecr].[EntityBindings]([EntityID],[BindingID]) VALUES (5,10)
GO
INSERT [ecr].[EntityBindings]([EntityID],[BindingID]) VALUES (6,4)
GO
INSERT [ecr].[EntityBindings]([EntityID],[BindingID]) VALUES (6,5)
GO

SET IDENTITY_INSERT [ecr].[EntityBindings] OFF
GO

ALTER TABLE [ecr].[EntityBindings] CHECK CONSTRAINT [FK_EntityBindings_Bindings]
GO

ALTER TABLE [ecr].[EntityBindings] CHECK CONSTRAINT [FK_EntityBindings_Entities]
GO