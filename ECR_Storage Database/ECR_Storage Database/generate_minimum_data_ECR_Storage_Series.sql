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
	N'�����',
	7,
	N'�����',
	N'�������� �����',
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
	N'�����, �������� �������������, 200 �������� �� ������',
	9,
	NULL,
	N'�������� �����, ����������� � ������� JPEG, 200 px �� ������',
	N'��������������� ����������� �� ������',
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
	N'�����, ������������� ��� ���������������� ���������',
	10,
	NULL,
	N'�������� �����, ����������� � ������� GIF, 60 px �� ������',
	N'��������������� ����������� �� ������',
	7,
	1,
	N'gif'
);
GO
