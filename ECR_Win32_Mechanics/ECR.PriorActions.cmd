:rem (0) Удаление мусора
del "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\*.db" /q
del "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\*.DB" /q
del "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Books.Covers.Original\*.db" /q
del "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Books.Covers.Original\*.DB" /q
del "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Books.Illustrations\*.db" /q
del "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Books.Illustrations\*.DB" /q
del "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Books.Centerfolds\*.db" /q
del "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Books.Centerfolds\*.DB" /q
del "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Books.Contents\*.db" /q
del "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Books.Contents\*.DB" /q
del "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Persons\*.db" /q
del "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Persons\*.DB" /q
del "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Series\*.db" /q
del "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Series\*.DB" /q
del "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Organizations\*.db" /q
del "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Organizations\*.DB" /q
del "\\web-fileserver\Resource.Shared.PCards.Face.Original\*.db" /q
del "\\web-fileserver\Resource.Shared.PCards.Face.Original\*.DB" /q

del "\\web-fileserver\Resource.Shared.Content.Errors\*.db" /q
del "\\web-fileserver\Resource.Shared.Content.Errors\*.DB" /q
del "\\web-fileserver\Resource.Shared.Content.Errors\Books.Bibliography\*.db" /q
del "\\web-fileserver\Resource.Shared.Content.Errors\Books.Bibliography\*.DB" /q
del "\\web-fileserver\Resource.Shared.Content.Errors\Books.Centerfolds\*.db" /q
del "\\web-fileserver\Resource.Shared.Content.Errors\Books.Centerfolds\*.DB" /q
del "\\web-fileserver\Resource.Shared.Content.Errors\Books.Contents\*.db" /q
del "\\web-fileserver\Resource.Shared.Content.Errors\Books.Contents\*.DB" /q
del "\\web-fileserver\Resource.Shared.Content.Errors\Books.Covers.Face\*.db" /q
del "\\web-fileserver\Resource.Shared.Content.Errors\Books.Covers.Face\*.DB" /q
del "\\web-fileserver\Resource.Shared.Content.Errors\Books.Illustrations\*.db" /q
del "\\web-fileserver\Resource.Shared.Content.Errors\Books.Illustrations\*.DB" /q
del "\\web-fileserver\Resource.Shared.Content.Errors\Organizations\*.db" /q
del "\\web-fileserver\Resource.Shared.Content.Errors\Organizations\*.DB" /q
del "\\web-fileserver\Resource.Shared.Content.Errors\Persons\*.db" /q
del "\\web-fileserver\Resource.Shared.Content.Errors\Persons\*.DB" /q
del "\\web-fileserver\Resource.Shared.Content.Errors\Series\*.db" /q
del "\\web-fileserver\Resource.Shared.Content.Errors\Series\*.DB" /q
del "\\web-fileserver\Resource.Shared.Content.Errors\PCards.Face\*.db" /q
del "\\web-fileserver\Resource.Shared.Content.Errors\PCards.Face\*.DB" /q

del "\\web-fileserver\Resource.Shared.Content.Conflicts\*.db" /q
del "\\web-fileserver\Resource.Shared.Content.Conflicts\*.DB" /q
del "\\web-fileserver\Resource.Shared.Content.Conflicts\Books.Bibliography\*.db" /q
del "\\web-fileserver\Resource.Shared.Content.Conflicts\Books.Bibliography\*.DB" /q
del "\\web-fileserver\Resource.Shared.Content.Conflicts\Books.Centerfolds\*.db" /q
del "\\web-fileserver\Resource.Shared.Content.Conflicts\Books.Centerfolds\*.DB" /q
del "\\web-fileserver\Resource.Shared.Content.Conflicts\Books.Contents\*.db" /q
del "\\web-fileserver\Resource.Shared.Content.Conflicts\Books.Contents\*.DB" /q
del "\\web-fileserver\Resource.Shared.Content.Conflicts\Books.Covers.Face\*.db" /q
del "\\web-fileserver\Resource.Shared.Content.Conflicts\Books.Covers.Face\*.DB" /q
del "\\web-fileserver\Resource.Shared.Content.Conflicts\Books.Illustrations\*.db" /q
del "\\web-fileserver\Resource.Shared.Content.Conflicts\Books.Illustrations\*.DB" /q
del "\\web-fileserver\Resource.Shared.Content.Conflicts\Organizations\*.db" /q
del "\\web-fileserver\Resource.Shared.Content.Conflicts\Organizations\*.DB" /q
del "\\web-fileserver\Resource.Shared.Content.Conflicts\Persons\*.db" /q
del "\\web-fileserver\Resource.Shared.Content.Conflicts\Persons\*.DB" /q
del "\\web-fileserver\Resource.Shared.Content.Conflicts\Series\*.db" /q
del "\\web-fileserver\Resource.Shared.Content.Conflicts\Series\*.DB" /q
del "\\web-fileserver\Resource.Shared.Content.Conflicts\PCards.Face\*.db" /q
del "\\web-fileserver\Resource.Shared.Content.Conflicts\PCards.Face\*.DB" /q

:rem (0) Снятие атрибутов с файлов во входящих папках; делается на всякий случай, во входящие папки одновременно могут падать еще файлы
attrib -r -h "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Books.Annots\*.*" /s
attrib -r -h "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Books.Bibliography\*.*" /s
attrib -r -h "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Books.Covers.Original\*.*" /s
attrib -r -h "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Books.Illustrations\*.*" /s
attrib -r -h "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Books.Centerfolds\*.*" /s
attrib -r -h "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Books.Contents\*.*" /s
attrib -r -h "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Persons\*.*" /s
attrib -r -h "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Series\*.*" /s
attrib -r -h "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Organizations\*.*" /s
attrin -r -h "\\web-fileserver\Resource.Shared.PCards.Face.Original\*.*" /s

:rem (1) Обложки книг

:rem Перемещение файлов во внутреннюю папку _1
move /y "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Books.Covers.Original\*.*" D:\Exec\Services\CFMGate\processing\Input\Books_Covers\1\
:rem Снятие атрибутов с файлов в папках _1
:rem делается на случай, если в папку _1 все-таки попал файл с неснятыми атрибутами
attrib -r -h D:\Exec\Services\CFMGate\processing\Input\Books_Covers\1\*.* /s
:rem Перемещение в \temp\cfmGate\
:rem делается потому, что JPGCLEAN.EXE не понимает сложных не DOS-путей
move /y D:\Exec\Services\CFMGate\processing\Input\Books_Covers\1\*.* D:\exec\Services\temp\CFMGate\
:rem Очистка файлов утилитой JPGCLEAN
D:\exec\Services\CFMGate\JPGCLEAN.EXE D:\exec\Services\temp\CFMGate\*.jpg -nobackup
:rem D:\exec\Services\CFMGate\JPGCLEAN.EXE D:\exec\Services\temp\CFMGate\*.jpeg -nobackup
:rem Перемещение файлов обратно
move /y D:\exec\Services\temp\CFMGate\*.* D:\Exec\Services\CFMGate\processing\Input\Books_Covers\1\

:rem (2) Книжные аннотации
move /y "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Books.Annots\*.*" D:\Exec\Services\CFMGate\processing\Input\Books_Annots\1\
attrib -r -h D:\Exec\Services\CFMGate\processing\Input\Books_Annots\1\*.* /s

:rem (3) Библиография книг
move /y "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Books.Bibliography\*.*" D:\Exec\Services\CFMGate\processing\Input\Books_Bibliography\1\
attrib -r -h D:\Exec\Services\CFMGate\processing\Input\Books_Bibliography\1\*.* /s
move /y D:\Exec\Services\CFMGate\processing\Input\Books_Bibliography\1\*.* D:\exec\Services\temp\CFMGate\
D:\exec\Services\CFMGate\JPGCLEAN.EXE D:\exec\Services\temp\CFMGate\*.jpg -nobackup
:rem D:\exec\Services\CFMGate\JPGCLEAN.EXE D:\exec\Services\temp\CFMGate\*.jpeg -nobackup
move /y D:\exec\Services\temp\CFMGate\*.* D:\Exec\Services\CFMGate\processing\Input\Books_Bibliography\1\

:rem (4) Иллюстрации к книгам
move /y "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Books.Illustrations\*.*" D:\Exec\Services\CFMGate\processing\Input\Books_Illustrations\1\
attrib -r -h D:\Exec\Services\CFMGate\processing\Input\Books_Illustrations\1\*.* /s
move /y D:\Exec\Services\CFMGate\processing\Input\Books_Illustrations\1\*.* D:\exec\Services\temp\CFMGate\
D:\exec\Services\CFMGate\JPGCLEAN.EXE D:\exec\Services\temp\CFMGate\*.jpg -nobackup
:rem D:\exec\Services\CFMGate\JPGCLEAN.EXE D:\exec\Services\temp\CFMGate\*.jpeg -nobackup
move /y D:\exec\Services\temp\CFMGate\*.* D:\Exec\Services\CFMGate\processing\Input\Books_Illustrations\1\

:rem (5) Развороты (внутренние страницы) книг
move /y "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Books.Centerfolds\*.*" D:\Exec\Services\CFMGate\processing\Input\Books_Centerfolds\1\
attrib -r -h D:\Exec\Services\CFMGate\processing\Input\Books_Centerfolds\1\*.* /s
move /y D:\Exec\Services\CFMGate\processing\Input\Books_Centerfolds\1\*.* D:\exec\Services\temp\CFMGate\
D:\exec\Services\CFMGate\JPGCLEAN.EXE D:\exec\Services\temp\CFMGate\*.jpg -nobackup
:rem D:\exec\Services\CFMGate\JPGCLEAN.EXE D:\exec\Services\temp\CFMGate\*.jpeg -nobackup
move /y D:\exec\Services\temp\CFMGate\*.* D:\Exec\Services\CFMGate\processing\Input\Books_Centerfolds\1\

:rem (6.1) Оглавления книг - графический формат
move /y "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Books.Contents\*.jpg" D:\Exec\Services\CFMGate\processing\Input\Books_Contents\1\Graphics\
move /y "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Books.Contents\*.jpeg" D:\Exec\Services\CFMGate\processing\Input\Books_Contents\1\Graphics\
attrib -r -h D:\Exec\Services\CFMGate\processing\Input\Books_Contents\1\Graphics\*.* /s
move /y D:\Exec\Services\CFMGate\processing\Input\Books_Contents\1\Graphics\*.* D:\exec\Services\temp\CFMGate\
D:\exec\Services\CFMGate\JPGCLEAN.EXE D:\exec\Services\temp\CFMGate\*.jpg -nobackup
:rem D:\exec\Services\CFMGate\JPGCLEAN.EXE D:\exec\Services\temp\CFMGate\*.jpeg -nobackup
move /y D:\exec\Services\temp\CFMGate\*.* D:\Exec\Services\CFMGate\processing\Input\Books_Contents\1\Graphics\

:rem (6.2) Оглавления книг - текстовый формат
move /y "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Books.Contents\*.txt" D:\Exec\Services\CFMGate\processing\Input\Books_Contents\1\Text\
attrib -r -h D:\Exec\Services\CFMGate\processing\Input\Books_Contents\1\Text\*.* /s

:rem (7) Фотографии персон
move /y "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Persons\*.*" D:\Exec\Services\CFMGate\processing\Input\Persons\1\
attrib -r -h D:\Exec\Services\CFMGate\processing\Input\Persons\1\*.* /s
move /y D:\Exec\Services\CFMGate\processing\Input\Persons\1\*.* D:\exec\Services\temp\CFMGate\
D:\exec\Services\CFMGate\JPGCLEAN.EXE D:\exec\Services\temp\CFMGate\*.jpg -nobackup
:rem D:\exec\Services\CFMGate\JPGCLEAN.EXE D:\exec\Services\temp\CFMGate\*.jpeg -nobackup
move /y D:\exec\Services\temp\CFMGate\*.* D:\Exec\Services\CFMGate\processing\Input\Persons\1\

:rem (8) Логотипы серий
move /y "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Series\*.*" D:\Exec\Services\CFMGate\processing\Input\Series\1\
attrib -r -h D:\Exec\Services\CFMGate\processing\Input\Series\1\*.* /s
move /y D:\Exec\Services\CFMGate\processing\Input\Series\1\*.* D:\exec\Services\temp\CFMGate\
D:\exec\Services\CFMGate\JPGCLEAN.EXE D:\exec\Services\temp\CFMGate\*.jpg -nobackup
:rem D:\exec\Services\CFMGate\JPGCLEAN.EXE D:\exec\Services\temp\CFMGate\*.jpeg -nobackup
move /y D:\exec\Services\temp\CFMGate\*.* D:\Exec\Services\CFMGate\processing\Input\Series\1\

:rem (9) Логотипы организаций
move /y "\\web-fileserver\Resourse.Shared.Content.TemporaryStorage\Organizations\*.*" D:\Exec\Services\CFMGate\processing\Input\Organizations\1\
attrib -r -h D:\Exec\Services\CFMGate\processing\Input\Organizations\1\*.* /s
move /y D:\Exec\Services\CFMGate\processing\Input\Organizations\1\*.* D:\exec\Services\temp\CFMGate\
D:\exec\Services\CFMGate\JPGCLEAN.EXE D:\exec\Services\temp\CFMGate\*.jpg -nobackup
:rem D:\exec\Services\CFMGate\JPGCLEAN.EXE D:\exec\Services\temp\CFMGate\*.jpeg -nobackup
move /y D:\exec\Services\temp\CFMGate\*.* D:\Exec\Services\CFMGate\processing\Input\Organizations\1\

:rem (10) Изображения открыток
move /y "\\web-fileserver\Resource.Shared.PCards.Face.Original\*.*" "D:\Exec\Services\CFMGate\processing\Input\PCards_Face\1\"
attrib -r -h D:\Exec\Services\CFMGate\processing\Input\PCards_Face\1\*.* /s
move /y D:\Exec\Services\CFMGate\processing\Input\PCards_Face\1\*.* D:\exec\Services\temp\CFMGate\ D:\exec\Services\CFMGate\JPGCLEAN.EXE D:\exec\Services\temp\CFMGate\*.jpg -nobackup
:rem D:\exec\Services\CFMGate\JPGCLEAN.EXE D:\exec\Services\temp\CFMGate\*.jpeg -nobackup
move /y D:\exec\Services\temp\CFMGate\*.* D:\Exec\Services\CFMGate\processing\Input\PCards_Face\1\