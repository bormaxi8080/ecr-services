insert into ecr.Entities
(
	ID, EntityID, SystemName, DisplayName, DisplayAlias, Description, Comments, HistoryLifeTime, IsMultiplied, Extensions
)
values
(
	1,
	'c0977a79-9501-42c9-9c1a-26349dbe9d76',
	N'Books.Annots',
	N'Аннотации книг',
	2,
	N'Аннотации книг - неразмеченный текст',
	N'Текст аннотации в формате TXT без какой-либо разметки',
	5,
	0,
	N'txt'	
);
GO

insert into ecr.Views
(
	ID, ViewID, SystemName, DisplayName, DisplayAlias, RelativeNames, Description, Comments, EntityParent, Enabled, Extensions
)
values
(
	2,
	'6580b0d8-a1e6-4239-adac-77b84aeef542',
	N'Books.Annots.HtmlText	Аннотации книг (text/html)',
	5,
	N'ctAnnot|ctAnnotation',
	N'Аннотации книг - форматированный элементами HTML текст',
	N'Простейшее форматирование HTML: расстановка тэгов <br>, <p>',
	1,
	1,
	N'txt'		
);
GO