INSERT [ecr].[Entities]
(
	[EntityID],
	[SystemName],
	[DisplayName],
	[DisplayAlias],
	[Description],
	[Comments],
	[HistoryLifeTime],
	[IsMultiplied],
	[Extensions]
)
VALUES
(
	'{41c0383b-0e50-44c0-9467-5ea099e5ce01}',
	N'Persons',
	N'Персоны',
	5,
	N'Персоны',
	N'Фотографии персон',
	0,
	0,
	N'jpg'
);
GO

INSERT [ecr].[Views]
(
	[ViewID],
	[SystemName],
	[DisplayName],
	[DisplayAlias],
	[RelativeNames],
	[Description],
	[Comments],
	[EntityParent],
	[Enabled],
	[Extensions]
)
VALUES
(
	'{1b425de0-59c1-497d-b868-229701beae9d}',
	N'Persons.JPEG.200',
	N'Персоны, основное представление, 200 пикселей по ширине',
	7,
	NULL,
	N'Фотографии персон, изображения в формате JPEG, 200 px по ширине',
	N'Масштабирование изображения по ширине',
	5,
	1,
	N'jpg'
);
GO

INSERT [ecr].[Views]
(
	[ViewID],
	[SystemName],
	[DisplayName],
	[DisplayAlias],
	[RelativeNames],
	[Description],
	[Comments],
	[EntityParent],
	[Enabled],
	[Extensions]
)
VALUES
(
	'{29f614c3-c855-4f2d-b455-e7bf487a870d}',
	N'Persons.GIF.60',
	N'Персоны, представление для предварительного просмотра',
	8,
	NULL,
	N'Фотографии персон, изображения в формате GIF, 60 px по ширине',
	N'Масштабирование изображения по ширине',
	5,
	1,
	N'gif'
);
GO