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
	'{82e364c1-5dc2-427b-a790-c706190f8129}',
	N'Series',
	N'Серии',
	7,
	N'Серии',
	N'Логотипы серий',
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
	'{0cc18acb-6dbd-486b-b41c-beb1e2736203}',
	N'Series.JPEG.200',
	N'Серии, основное представление, 200 пикселей по ширине',
	9,
	NULL,
	N'Логотипы серий, изображения в формате JPEG, 200 px по ширине',
	N'Масштабирование изображения по ширине',
	7,
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
	'{d0a22fe8-31c1-4b75-a052-35b8801ce95c}',
	N'Series.GIF.60',
	N'Серии, представление для предварительного просмотра',
	10,
	NULL,
	N'Логотипы серий, изображения в формате GIF, 60 px по ширине',
	N'Масштабирование изображения по ширине',
	7,
	1,
	N'gif'
);
GO
