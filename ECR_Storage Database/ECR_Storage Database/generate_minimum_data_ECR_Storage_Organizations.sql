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
	'{89b9cc78-a92e-4b4f-82bb-66b900b823b7}',
	N'Organizations',
	N'Организации',
	6,
	N'Организации',
	N'Логотипы организаций',
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
	'{087ad51c-1be1-46d1-ae17-8f9bc74d3e17}',
	N'Organizations.JPEG.200',
	N'Организации, основное представление, 200 пикселей по ширине',
	11,
	NULL,
	N'Логотипы организаций, изображения в формате JPEG, 200 px по ширине',
	N'Масштабирование изображения по ширине',
	6,
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
	'{b2c00f2b-f6da-45f4-affc-48414f703954}',
	N'Organizations.GIF.60',
	N'Организации, представление для предварительного просмотра',
	12,
	NULL,
	N'Логотипы организаций, изображения в формате GIF, 60 px по ширине',
	N'Масштабирование изображения по ширине',
	6,
	1,
	N'gif'
);
GO