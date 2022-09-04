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
	N'�����������',
	6,
	N'�����������',
	N'�������� �����������',
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
	N'�����������, �������� �������������, 200 �������� �� ������',
	11,
	NULL,
	N'�������� �����������, ����������� � ������� JPEG, 200 px �� ������',
	N'��������������� ����������� �� ������',
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
	N'�����������, ������������� ��� ���������������� ���������',
	12,
	NULL,
	N'�������� �����������, ����������� � ������� GIF, 60 px �� ������',
	N'��������������� ����������� �� ������',
	6,
	1,
	N'gif'
);
GO