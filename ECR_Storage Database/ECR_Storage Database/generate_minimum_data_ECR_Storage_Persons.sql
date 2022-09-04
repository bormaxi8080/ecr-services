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
	N'�������',
	5,
	N'�������',
	N'���������� ������',
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
	N'�������, �������� �������������, 200 �������� �� ������',
	7,
	NULL,
	N'���������� ������, ����������� � ������� JPEG, 200 px �� ������',
	N'��������������� ����������� �� ������',
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
	N'�������, ������������� ��� ���������������� ���������',
	8,
	NULL,
	N'���������� ������, ����������� � ������� GIF, 60 px �� ������',
	N'��������������� ����������� �� ������',
	5,
	1,
	N'gif'
);
GO