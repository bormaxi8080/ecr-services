insert into ecr.Entities
(
	EntityID, SystemName, DisplayName, DisplayAlias, Description, Comments, HistoryLifeTime, IsMultiplied, Extensions
)
values
(
	'a2fe684c-57ec-4117-8ac3-38f004283938',
	N'Books.Covers.Face',
	N'������� ���� - ������� �����',
	1,
	N'������� ���� - ������� ����� (�������������� ���������)',
	N'��������� ����������� � ������� JPEG (��������������� ��������)',
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
	N'������� ���� - ������� �����, �������� �������������',
	1,
	N'ctImage',
	N'������� ���� - ������� �����, ����������� � ������� JPEG, 200 px �� ������',
	N'��������������� ����������� �� ������',
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
	N'������� ���� - ������� �����, ������������� ��� ���������������� ���������',
	2,
	NULL,
	N'������� ���� - ������� �����, ����������� � ������� GIF, 60 px �� ������',
	N'��������������� ����������� �� ������',
	1,
	1,
	N'gif'
);
GO