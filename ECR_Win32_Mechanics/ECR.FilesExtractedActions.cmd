:rem ����������� ������ ��� ������������� �� STK, ���, ����������� ���������.

:rem �������� ������ � XmlOutput
del \\web-fileserver\Resource.Shared.ECR\FilesExtraction\Input\otContentView_*_ecr.storage3.xml
rem �������� ������ � XmlOutput
del \\web-fileserver\Resource.Shared.ECR\FilesExtraction\Input\otContentView_*_ecr.storage4.xml
rem �������� ������ � XmlOutput
del \\web-fileserver\Resource.Shared.ECR\FilesExtraction\Input\otContentView_*_ecr.storage5.xml

:rem ����������� � ����� Filtered\
move \\web-fileserver\Resource.Shared.ECR\FilesExtraction\Input\otContentView_*_ecr.storage1.xml \\web-fileserver\Resource.Shared.ECR\FilesExtraction\Input\Filtered\
move \\web-fileserver\Resource.Shared.ECR\FilesExtraction\Input\otContentView_*_ecr.storage2.xml \\web-fileserver\Resource.Shared.ECR\FilesExtraction\Input\Filtered\

:rem �������� ������ *.gif
del \\web-fileserver\Resource.Shared.ECR\FilesExtraction\Output\*.gif