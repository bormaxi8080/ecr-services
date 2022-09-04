insert into ecr.Entities
(
	EntityID, SystemName, DisplayName, DisplayAlias, Description, Comments, HistoryLifeTime, IsMultiplied, Extensions
)
values
(
	'a2fe684c-57ec-4117-8ac3-38f004283938',
	N'Books.Covers.Face',
	N'Обложки книг - лицевая часть',
	1,
	N'Обложки книг - лицевая часть (необработанные оригиналы)',
	N'Оригиналы изображений в формате JPEG (полиграфическое качество)',
	5,
	0,
	N'jpg'
);
GO

insert into ecr.Views
(
	ViewID, SystemName, DisplayName, DisplayAlias, RelativeNames, Description, Comments, EntityParent, Enabled, Extensions
)
values
(
	'8c802e31-a046-4a73-92ba-cec513ce94a8',
	N'Books.Covers.Face.JPEG.200',
	N'Обложки книг - лицевая часть, основное представление',
	1,
	N'ctImage',
	N'Обложки книг - лицевая часть, изображения в формате JPEG, 200 px по ширине',
	N'Масштабирование изображения по ширине',
	1,
	1,
	N'jpg'
);
GO

insert into ecr.Views
(
	ViewID, SystemName, DisplayName, DisplayAlias, RelativeNames, Description, Comments, EntityParent, Enabled, Extensions
)
values
(
	'd89d2b21-eff1-42ca-9ad0-24952089bedc',
	N'Books.Covers.Face.GIF.60',
	N'Обложки книг - лицевая часть, представление для предварительного просмотра',
	2,
	NULL,
	N'Обложки книг - лицевая часть, изображения в формате GIF, 60 px по ширине',
	N'Масштабирование изображения по ширине',
	1,
	1,
	N'gif'
);
GO