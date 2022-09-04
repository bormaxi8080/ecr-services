:rem Копирование файлов для тиражирования на STK, опт, партнерскую программу.

:rem Удаление файлов в XmlOutput
del \\web-fileserver\Resource.Shared.ECR\FilesExtraction\Input\otContentView_*_ecr.storage3.xml
rem Удаление файлов в XmlOutput
del \\web-fileserver\Resource.Shared.ECR\FilesExtraction\Input\otContentView_*_ecr.storage4.xml
rem Удаление файлов в XmlOutput
del \\web-fileserver\Resource.Shared.ECR\FilesExtraction\Input\otContentView_*_ecr.storage5.xml

:rem Перемещение в папку Filtered\
move \\web-fileserver\Resource.Shared.ECR\FilesExtraction\Input\otContentView_*_ecr.storage1.xml \\web-fileserver\Resource.Shared.ECR\FilesExtraction\Input\Filtered\
move \\web-fileserver\Resource.Shared.ECR\FilesExtraction\Input\otContentView_*_ecr.storage2.xml \\web-fileserver\Resource.Shared.ECR\FilesExtraction\Input\Filtered\

:rem Удаление файлов *.gif
del \\web-fileserver\Resource.Shared.ECR\FilesExtraction\Output\*.gif