using System;
using System.Configuration;
using System.Text;
using System.Text.RegularExpressions;

namespace ECR.ProcessingManager
{

    /// <summary>
    /// Класс процессинга текстовых объектов ECR
    /// </summary>
    public class TextProcessor : IECRProcessor
    {

        /// <summary>
        /// Идентификатор контейнера для определения преобразований
        /// </summary>
        public int ContainerId { get; set; }

        private static readonly char[] _cbreakline = { (char)13, (char)10 };
        private static readonly string _breakline = new string(_cbreakline);

        private string _sbuffer = string.Empty;

        /// <summary>
        /// TextProcessor class constructor
        /// </summary>
        /// <param name="ContainerId">Идентификатор контейнера для определения преобразований</param>
        public TextProcessor(int ContainerId)
        {
            // Container initialization
            this.ContainerId = ContainerId;
            LoadContainerProperties(ContainerId);
        }

        #region Public class members

        /// <summary>
        /// Процедура инициализации свой контейнера для определения преобразований
        /// </summary>
        /// <param name="ContainerId">Идентификатор контейнера для определения преобразований</param>
        // ReSharper disable ParameterHidesMember
        public void LoadContainerProperties(int ContainerId)
        // ReSharper restore ParameterHidesMember
        {
            // TODO: container properties initialization here!
        }

        /// <summary>
        /// Загрузка данных в процессинговый объект
        /// </summary>
        /// <param name="o"></param>
        /// <param name="CheckProperties"></param>
        /// <param name="ProcessingDefault"></param>
        /// <param name="err"></param>
        /// <returns></returns>
        public bool LoadObject(object o, bool CheckProperties, bool ProcessingDefault, ref string err)
        {
            string[] _params = {};
            return LoadObject(o, CheckProperties, ProcessingDefault, _params, ref err);
        }

        /// <summary>
        /// Загрузка данных в процессинговый объект
        /// </summary>
        /// <param name="o"></param>
        /// <param name="CheckProperties"></param>
        /// <param name="ProcessingDefault"></param>
        /// <param name="Params"></param>
        /// <param name="err"></param>
        /// <returns></returns>
        public bool LoadObject(object o, bool CheckProperties, bool ProcessingDefault, string Params, ref string err)
        {
            if(Params != null)
                return LoadObject(o, CheckProperties, ProcessingDefault,  Params.Split((char)44), ref err);
            string[] _params = {};
            return LoadObject(o, CheckProperties, ProcessingDefault, _params, ref err);
        }

        /// <summary>
        /// Загрузка данных в процессинговый объект
        /// </summary>
        /// <param name="o"></param>
        /// <param name="CheckProperties"></param>
        /// <param name="ProcessingDefault"></param>
        /// <param name="Params"></param>
        /// <param name="err"></param>
        /// <returns></returns>
        public bool LoadObject(object o, bool CheckProperties, bool ProcessingDefault, string[] Params, ref string err)
        {
            
            err = null;
            
            // Очистка буффера
            Clear();
            // Проверка данных
            if (o == null)
            {
                err = "Не заданы данные для загрузки текста";
                return false;
            }
            
            // Загрузка базовой строки из передаваемого объекта
            var _s = new string((char[])o);
            
            // Применение преобразований "по умолчанию"
            if (ProcessingDefault)
                _s = DefaultProcessing(_s);

            // Проверка свойств объекта (строки)
            if (CheckProperties)
            {
                if (!PropertiesCheck(_s, Params, ref err))
                    return false;
            }

            // Загрузка данных в буферную переменную
            _sbuffer = _s;
            return true;
        }

        /// <summary>
        /// Преобразование оригинального представления
        /// </summary>
        /// <returns></returns>
        public byte[] GetBase()
        {
            return StrToByte(_sbuffer);
        }

        /// <summary>
        /// Процедура производит преобразования "по умолчанию"
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        private static string DefaultProcessing(string s)
        {
            // Обрезаем пробелы в начале и конце строки текста
            var _s = s.Trim();
            // ... и то же самое - для каждого абзаца в тексте
            _s = MultilineTrim(_s);

            // Замена "необычных" кавычек на #34
            _s = _s.Replace((char)145, (char)34);
            _s = _s.Replace((char)146, (char)34);
            _s = _s.Replace((char)147, (char)34);
            _s = _s.Replace((char)148, (char)34);
            _s = _s.Replace((char)171, (char)34);
            _s = _s.Replace((char)187, (char)34);

            // Замена издательского тире на обычное
            _s = _s.Replace((char)151, (char)45);
            _s = _s.Replace("—", "-");
            // Замена издательского троеточия на обычное
            _s = _s.Replace("…", "...");

            // ... для специфических разбиений на параграфы
            _s = CorrectParagraphs(_s);

            // Удаление двойных символов
            // ... двойные кавычки
            _s = ReplaceDoubleSymbol(_s, (char)34);
            // ... двойные тире
            _s = ReplaceDoubleSymbol(_s, (char)173);
            // ... двойные пробелы
            _s = ReplaceDoubleSymbol(_s, (char)32);

            // Предварительная корректировка тэгов html перед удалением
            _s = CorrectHtmlTags(_s);

            // Удаление \r\n в конце текста
            if (_s.Length > 2)
                if (_s.Substring(_s.Length - 2, 2) == "\r\n")
                    _s = _s.Substring(0, _s.Length - 2);

            // Удаление тэгов HTML (только для оригиналов!)
            return DeleteHtmlTags(_s);

        }

        /// <summary>
        /// Проверка свойств строки согласно свойствам, заданным в контейнере
        /// </summary>
        /// <param name="s">Проверяемая строка</param>
        /// <param name="Params">Строка передачи параметров</param>
        /// <param name="err">Возвращаемое описание ошибки</param>
        /// <returns>true если проверка прошла успешно, false - в противном случае</returns>
// ReSharper disable UnusedParameter.Local
        private static bool PropertiesCheck(string s, string[] Params, ref string err)
// ReSharper restore UnusedParameter.Local
        {
            err = null;
            // ... проверка начала строки
            if (!CheckStringStart(s, ref err))
                return false;
            // ... проверка конца строки
            if (!CheckStringEnd(s, ref err))
                return false;
            // ... проверка наличия недопустимых символов
            if (!CheckUnexpectedChars(s, ref err))
                return false;
            // ... проверка наличия наборов недопустимых символов
            if (!CheckUnexpectedSet(s, ref err))
                return false;
            // ... проверка наличия запрещеных трехбуквенных выражений :)
            if (!CheckLiteralUnexpectedSet(s, ref err))
                return false;
            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ItemType"></param>
        /// <param name="Params"></param>
        /// <returns></returns>
        public byte[] CreateView(string ItemType, string Params)
        {
            // Разбиваем строку параметров
            var _params = Params.Split((char) 44);
            return CreateView(ItemType, _params);   
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ItemType"></param>
        /// <param name="Params"></param>
        /// <returns></returns>
        public byte[] CreateView(string ItemType, string[] Params)
        {

            // Получаем данные буфера
            var s = _sbuffer;

            // ... если нет запрета на подстановку тэгов HTML
            if (!Convert.ToBoolean(ConfigurationManager.AppSettings.Get("ECR.TextProcessor.EscapeHtmlTags")))
            {
                // ... если нет запрета на разметку параграфами
                if (!Convert.ToBoolean(ConfigurationManager.AppSettings.Get("ECR.TextProcessor.EscapeParagraphs")))
                {
                    s = s.Replace("<P>", "<p>");
                    s = "<p>" + s;
                    s = s.Replace("<p><p>", "<p>");
                }
                else
                {
                    // Включен запрет на разметку параграфами - удаление <p>, </p>
                    s = s.Replace("<p>", string.Empty);
                    s = s.Replace("</p>", string.Empty);
                }

                // ... если нет запрета на разметку breakline
                if (!Convert.ToBoolean(ConfigurationManager.AppSettings.Get("ECR.TextProcessor.EscapeBreakLine")))
                {
                    // Заменяем <br> на #13#10
                    s = s.Replace("<br>", _breakline);
                    // Убираем двойное вхождение #13#10
                    s = s.Replace(_breakline + _breakline, _breakline);
                    // Заменяем #13#10 на <br>#13#10
                    s = s.Replace(_breakline, "<br>" + _breakline);
                }
                else
                {
                    // Включен запрет на разметку breakline - удаление <br>
                    s = s.Replace("<br>", string.Empty);
                }

            }
            else    // включен запрет на тэги HTML
            {
                // Удаление тэгов html
                s = DeleteHtmlTags(s);
            }

            return StrToByte(s);

        }

        #endregion

        /// <summary>
        /// Проверка на вхождение наборов неразрешенных символов
        /// </summary>
        /// <param name="s"></param>
        /// <param name="err"></param>
        /// <returns></returns>
        private static bool CheckUnexpectedSet(string s, ref string err)
        {
            err = null;
            // Определение списка недопустимых наборов символов
            // Важно: символ табляции (TAB) в данной конфигурационной строке недопустим!
            var _arrayset = (UnescapeXmlSymbols(ConfigurationManager.AppSettings.Get("ECR.TextProcessor.UnexpectedSet")).Replace(
                    "\r\n", string.Empty)).Split((char)32);
            for (var i = 0; i < _arrayset.Length; i++)
            {
                if (s.IndexOf(_arrayset[i]) > -1)
                {
                    err = string.Format("Недопустимый набор символов в строке: '{0}'", _arrayset[i]);
                    return false;
                }
            }
            return true;
        }

        /// <summary>
        /// Проверка на вхождение трех (и, соответственно, более) одинаковых буквенных символов (кроме явно определенных исключений)
        /// </summary>
        /// <param name="s"></param>
        /// <param name="err"></param>
        /// <returns></returns>
        private static bool CheckLiteralUnexpectedSet(string s, ref string err)
        {
            err = null;
            // Определение списков буквенных символов
            var _literalset = (ConfigurationManager.AppSettings.Get("ECR.TextProcessor.LiteralSet").Replace("\r\n", string.Empty).Replace("\t", string.Empty).Replace(" ", string.Empty)).Split((char)44);
            // Определение списка слов-исключений
            var _excludedliteralset = (UnescapeXmlSymbols(ConfigurationManager.AppSettings.Get("ECR.TextProcessor.ExcludedLiteralSet")).Replace("\r\n", string.Empty).Replace("\t", string.Empty)).Split((char)44);
            // Замена слов-исключений в исходном тексте на пустую строку
            var _s = s;
            for (var i = 0; i < _excludedliteralset.Length; i++)
            {
                _s = _s.Replace(_excludedliteralset[i], string.Empty);
            }
            // Проверка вхождения трехбуквенных слов в скорректированном тексте
            for (var i = 0; i < _literalset.Length; i++)
            {
                var _cset = new string((char)Convert.ToInt32(_literalset[i]), 3);
                if (_s.IndexOf(_cset, 0) > -1)
                {
                    err = string.Format("Недопустимый набор символов в строке: '{0}'", _cset);
                    return false;
                }
            }
            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="s"></param>
        /// <param name="err"></param>
        /// <returns></returns>
        private static bool CheckUnexpectedChars(string s, ref string err)
        {
            err = null;
            // Определение списка недопустимых символов
            var _arrayset = (ConfigurationManager.AppSettings.Get("ECR.TextProcessor.UnexpectedChars").Replace("\r\n", string.Empty).Replace("\t", string.Empty).Replace(" ", string.Empty)).Split((char)44);
            // Проверка
            for (var i = 0; i < _arrayset.Length; i++)
            {
                if (s.IndexOf((char)(Convert.ToInt32(_arrayset[i]))) > -1)
                {
                    err = string.Format("Недопустимый символ в строке, код символа: {0}", _arrayset[i]);
                    return false;
                }
            }
            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="s"></param>
        /// <param name="err"></param>
        /// <returns></returns>
        private static bool CheckStringStart(string s, ref string err)
        {
            var _s = s.Split(_cbreakline, StringSplitOptions.RemoveEmptyEntries);
            for (var i = 0; i < _s.Length; i++)
            {
                var r = new Regex(UnescapeXmlSymbols(ConfigurationManager.AppSettings.Get("ECR.TextProcessor.StartCheckDefinition")), RegexOptions.Compiled);
                var m = r.Match(_s[i]);
                // Функция возвращает значение первого токена (соответствующего key_token), полученное от Match;
                // m.Groups[0] всегда есть ВСЕ исходное регулярное выражение;
                if (m.Groups[0].Length == 0)
                {
                    err = "Недопустимое выражение в начале строки";
                    return false;
                }
            }
            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="s"></param>
        /// <param name="err"></param>
        /// <returns></returns>
        private static bool CheckStringEnd(string s, ref string err)
        {
            var _s = s.Split(_cbreakline, StringSplitOptions.RemoveEmptyEntries);
            for (var i = 0; i < _s.Length; i++)
            {
                var r = new Regex(UnescapeXmlSymbols(ConfigurationManager.AppSettings.Get("ECR.TextProcessor.EndCheckDefinition")), RegexOptions.Compiled);
                var m = r.Match(_s[i]);
                if(m.Groups[1].Length == 0)
                {
                    err = "Недопустимое выражение в конце строки";
                    return false;
                }
            }
            return true;
        }

        /// <summary>
        /// Функция Trim() для всех встречающихся абзацев в тексте
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        private static string MultilineTrim(string s)
        {
            var _result = string.Empty;
            var _s = s.Split(_cbreakline, StringSplitOptions.RemoveEmptyEntries);
            for (var i = 0; i < _s.Length; i++)
            {
                    _result = _result + _s[i].Trim() + "\r\n";
            }
            return _result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        private static string CorrectParagraphs(string s)
        {
            var _result = string.Empty;
            var _s = s.Split(_cbreakline, StringSplitOptions.RemoveEmptyEntries);
            for (var i = 0; i < _s.Length; i++)
            {
                if ((_s[i].Substring(0, 1) == "*") && (_s[i].Substring(1, 1) != " "))
                    _s[i] = "* " + _s[i].Substring(1, _s[i].Length - 1);
                if ((_s[i].Substring(0, 1) == "-") && (_s[i].Substring(1, 1) != " "))
                    _s[i] = "- " + _s[i].Substring(1, _s[i].Length - 1);
                _result = _result + _s[i] + "\r\n";
            }
            return _result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        private static string CorrectHtmlTags(string s)
        {
            // Приведение тэгов HTML в нижний регистр
            var _s = s.Replace("<P>", "<p>");
            _s = _s.Replace("</P>", "</p>");
            _s = _s.Replace("<B>", "<b>");
            _s = _s.Replace("</B>", "</b>");
            _s = _s.Replace("<BR>", "<br>");
            _s = _s.Replace("<I>", "<i>");
            _s = _s.Replace("</I>", "</i>");
            _s = _s.Replace("<U>", "u");
            _s = _s.Replace("</U>", "</u>");
            _s = _s.Replace("<A ", "<a ");
            _s = _s.Replace("HREF", "href");

            // Удаление двойных тэгов HTML
            _s = _s.Replace("<p><p>", "<p>");
            _s = _s.Replace("<br><br>", "<br>");
            // Замена \r\n\r\n на \r\n
            _s = _s.Replace("\r\n\r\n", "\r\n");

            // Удаление <br> в конце текста
            if (_s.Length > 3)
                if (_s.Substring(_s.Length - 4, 4) == "<br>")
                    _s = _s.Substring(0, _s.Length - 4);

            return _s;

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        private static string DeleteHtmlTags(string s)
        {
            var _s = s.Replace("<br>", _breakline);
            _s = _s.Replace("<p>", string.Empty);
            _s = _s.Replace("</p>", string.Empty);
            _s = _s.Replace("<b>", string.Empty);
            _s = _s.Replace("<i>", string.Empty);
            _s = _s.Replace("</i>", string.Empty);
            _s = _s.Replace("<u>", string.Empty);
            return _s.Replace("</u>", string.Empty);
        }

        /// <summary>
        /// Функция замены двойного вхождения символа symbol в строке s
        /// </summary>
        /// <param name="s"></param>
        /// <param name="symbol"></param>
        /// <returns></returns>
        private static string ReplaceDoubleSymbol(string s, char symbol)
        {
            var _result = s;
            var _s = new string(symbol, 2);
            var _symbol = new string(symbol, 1);
            while (_result.IndexOf(_s, 0) >-1)
            {
                _result = _result.Replace(_s, _symbol);
            }
            return _result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
// ReSharper disable UnusedMember.Local
        private static string EscapeXmlSymbols(string s)
// ReSharper restore UnusedMember.Local
        {
            var _result = s.Replace("&", "&amp;");
            _result = _result.Replace("<", "&lt;");
            _result = _result.Replace(">", "&gt;");
            _result = _result.Replace(" ", "&apos;");
            return _result.Replace("\"", "&quot;"); 
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        private static string UnescapeXmlSymbols(string s)
        {
            var _result = s.Replace("&amp;", "&");
            _result = _result.Replace("&lt;", "<");
            _result = _result.Replace("&gt;", ">");
            _result = _result.Replace("&apos;", " ");
            return _result.Replace("&quot;", "\"");
        }

        #region Private class members

        /// <summary>
        /// 
        /// </summary>
        /// <param name="b"></param>
        /// <returns></returns>
// ReSharper disable UnusedMember.Local
        private string ByteToStr(byte[] b)
// ReSharper restore UnusedMember.Local
        {
            var _encoding = Encoding.Default;
            return _encoding.GetString(b);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        private static byte[] StrToByte(string s)
        {
            var _encoding = Encoding.Default;
            return _encoding.GetBytes(s);
        }

        /// <summary>
        /// 
        /// </summary>
        private void Clear()
        {
            _sbuffer = string.Empty;  
        }

        #endregion

    }

}
