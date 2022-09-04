using System;
using System.Configuration;
using System.Text.RegularExpressions;
using System.IO;

using log4net;
using ECRManagedAssemblies;

namespace ECR.KeysComparer
{

    /// <summary>
    /// Класс предоставляет интерфейс для управления заданием сопоставления имен файлов по ключам во входящей папке
    /// </summary>
    public class CompareAction
    {

        #region Token definitions
        
        private const string _token1 = "[tk.key]";
        private const string _token2 = "[tk.number]";
        private const string _token3 = "[jd.item]";

        // Строки и массивы строк масок для токенов
        private readonly string[] __key_tokens  = { _token1, _token3 };
        private const string __number_token = _token2;

        #endregion

        #region Logging objects and variables

        private readonly static ILog _log = LogManager.GetLogger(typeof(CompareAction));

        #endregion
        
        private Guid _key;
        private bool _enabled = true;

        private string _source  = string.Empty;
        private string _sourceMask  = string.Empty;
        private string _destination = string.Empty;
        private string _compareMask = string.Empty;
        private string _archive = string.Empty;
        private string _conflicts = string.Empty;

        #region CompareAction class constructors

        /// <summary>
        /// Конструктор класса CompareAction
        /// </summary>
        /// <param name="key">Ключ задания сопоставления. Уникальный идентификатор guid</param>
        public CompareAction(string key)
        {
            DebugMode = false;
            ConfigureLoggingSubsystem();
            _key = new Guid(key);
            DataBinding = string.Empty;
        }

        /// <summary>
        /// Конструктор класса CompareAction
        /// </summary>
        /// <param name="key">Ключ задания сопоставления. Уникальный идентификатор guid</param>
        /// <param name="DebugMode">Определяет включение/выключение режима Debug в классе. DebugMode = true включает режим debug</param>
        public CompareAction(string key, bool DebugMode)
        {
            this.DebugMode = DebugMode;
            ConfigureLoggingSubsystem();
            _key = new Guid(key);
            DataBinding = string.Empty;
        }

        #endregion

        #region Logging subsystem functions

        /// <summary>
        /// Конфигурирование подсистемы логгирования
        /// </summary>
        private static void ConfigureLoggingSubsystem()
        {
            //DOMConfigurator.Configure();
        }

        /// <summary>
        /// Запись данных режиме в Log.Debug() с проверкой режима отладки
        /// </summary>
        /// <param name="message">Сообщение для debug</param>
        private void Debug(string message)
        {
            if (DebugMode)
                _log.Debug(message);
        }

        /// <summary>
        /// Запись данных в режиме Log.Debug() с проверкой режима отладки и описанием Exception
        /// </summary>
        /// <param name="message">Сообщение для debug</param>
        /// <param name="e">Exception для debug</param>
// ReSharper disable UnusedMember.Local
        private void Debug(string message, Exception e)
// ReSharper restore UnusedMember.Local
        {
            if (DebugMode)
                _log.Debug(message, e);
        }

        #endregion

        /// <summary>
        /// Свойство возвращает ключ задания сопоставления (уникальный идентификатор guid)
        /// </summary>
        public string Key
        {
            get
            {
                return _key.ToString();
            }
        }

        /// <summary>
        /// Свойство возвращет состояние доступности задания сопоставления
        /// </summary>
        public bool Enabled
        {
            get
            {
                return _enabled;
            }
            set
            {
                _enabled = value;
            }
        }

        /// <summary>
        /// Метод переводит состояние задания сопоставления в "доступно"
        /// </summary>
        public void Enable()
        {
            _enabled = true;
        }

        /// <summary>
        /// Метод переводит состояние задания сопоставления в "недоступно"
        /// </summary>
        public void Disable()
        {
            _enabled = false;
        }

        /// <summary>
        /// Свойство определяет режим debug в классе
        /// </summary>
        public bool DebugMode { get; set; }

        /// <summary>
        /// Свойство определяет путь к входящей папке с файлами для сопоставления;
        /// В случае отсутствия папки либо доступа к ней генерируется exception;
        /// </summary>
        public string Source
        {
            get
            {
                return _source;
            }
            set
            {
                if (!Directory.Exists(value))
                    throw new Exception(string.Format("Ошибка доступа к папке:: '{0}'", value));
                _source = value;
            }
        }

        /// <summary>
        /// Свойство определяет маску имени файла во входящей папке
        /// </summary>
        public string SourceMask
        {
            get
            {
                return _sourceMask;
            }
            set
            {
                _sourceMask = value;
            }
        }

        /// <summary>
        /// Свойство определяет путь к исходящей папке с файлами для сопоставления;
        /// В случае отсутствия папки либо доступа к ней генерируется exception;
        /// </summary>
        public string Destination
        {
            get
            {
                return _destination;
            }
            set
            {
                if (!Directory.Exists(value))
                    throw new Exception(string.Format("Ошибка доступа к папке:: '{0}'", value));
                _destination = value;
            }
        }

        /// <summary>
        /// Свойство определяет маску имени файла в исходящей папке
        /// </summary>
        public string CompareMask
        {
            get
            {
                return _compareMask;
            }
            set
            {
                _compareMask = value;
            }
        }

        /// <summary>
        /// Свойство определяет путь к папке архива переименованных файлов;
        /// В случае отсутствия папки либо доступа к ней генерируется exception;
        /// Допустимо значение string.Empty: в этом случае переименованные файлы в архив не пишутся;
        /// </summary>
        public string ArchivePath
        {
            get
            {
                return _archive;
            }
            set
            {
                if (value.Length > 0)
                {
                    if (!Directory.Exists(value))
                        throw new Exception(string.Format("Ошибка доступа к папке:: '{0}'", value));
                }
                _archive = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public string ConflictsPath
        {
            get
            {
                return _conflicts;
            }
            set
            {
                if (value.Length > 0)
                {
                    if (!Directory.Exists(value))
                        throw new Exception(string.Format("Ошибка доступа к папке:: '{0}'", value));
                }
                _conflicts = value;
            }
        }

        /// <summary>
        /// Свойство определяет привязку к каталогу данных, по которому производится поиск позиций;
        /// Привязка к каталогу осуществляется посредством выборки данных экземпляром класса DataConnectionProvider
        /// </summary>
        public string DataBinding { get; set; }

        /// <summary>
        /// Свойство определяет, нужно ли заменять уже существующие файлы в исходящей (целевой) папке
        /// </summary>
        public bool Overwrite { get; set; }
        
        /// <summary>
        /// Метод запускает задание сопоставления имен файлов по ключам во входящей папке по заданным правилам
        /// </summary>
        public void Execute()
        {
            
            _log.Info(string.Format("Запуск задания... Key:  {0}, Source: '{1}', SourceMask: '{2}', Destination: '{3}', CompareMask: {4}', Archive: {5}', DataBinding: '{6}', Overwrite: {7}", Key, Source, SourceMask, Destination, CompareMask, ArchivePath, DataBinding, Overwrite));

            // Проверка на доступность объекта
            if (Enabled)
            {

                #region Инициализация счетчиков

                int _processed = 0;
                int _success = 0;
                int _errors = 0;
                int _warnings = 0;

                #endregion

                // Создание объекта для получения данных из каталога ресурсов
                Debug("Конфигурирование объекта SourceCatalogEntityChecker...");
                var _checker = new SourceCatalogEntityChecker(ConfigurationManager.AppSettings.Get("ECR_Config.Database.Connection.ConnectionString"), DataBinding);

                #region Формирование маски для выборки файлов из папки

                Debug("Определение маски для выборки...");

                var _mask = _sourceMask.Replace("[ext]", "*");
                for (var i = 0; i < __key_tokens.Length; i++)
                    _mask = _mask.Replace(__key_tokens[i], "*");
                _mask = _mask.Replace(__number_token, "*");

                #endregion

                // input

                #region Формирование токена для поиска позиции по ключу

                Debug("Формирование токена для поиска позиции...");

                var _input_key_token = string.Empty;
                for (var i = 0; i < __key_tokens.Length; i++)
                {
                    if (SourceMask.IndexOf(__key_tokens[i]) <= -1) continue;
                    _input_key_token = __key_tokens[i];
                    break;
                }

                // Идентифицирующий позицию ключ всегда один, если по факту это не так - генерируем исключение
                if (_input_key_token.Length == 0)
                    throw new Exception("Входящий токен не определен или определен некорректно");

                // number

                // Идентифицирующий номер всегда один, определяем из маски исходного файла
                var _number_token = string.Empty;
                if (SourceMask.IndexOf(__number_token) > -1)
                    _number_token = __number_token;

                #endregion

                // output

                #region Формирование токена ключа для подстановки в output

                Debug("Формирование токена ключа для подстановки в output...");

                var _output_key_token = string.Empty;
                for (var i = 0; i < __key_tokens.Length; i++)
                {
                    if (CompareMask.IndexOf(__key_tokens[i]) > -1)
                    {
                        _output_key_token = __key_tokens[i];
                        break;
                    }
                }
                if (_output_key_token.Length == 0)
                    throw new Exception("Исходящий токен не определен или определен некорректно");

                #endregion

                // Получение списка файлов, находящихся в исходной папке
                Debug("Получение списка исходных файлов...");
                var _files = Directory.GetFiles(Source, _mask);

                if (_files.Length > 0)
                {

                    Debug("Проверка имен файлов...");
                    for (var i = 0; i < _files.Length; i++)
                    {

                        try
                        {

                            Debug(string.Format("Обрабатывается файл: '{0}'...", _files[i]));
                            _processed++;

                            // Замена [ext] и расширения файла в шаблоне названия исходного файла
                            var _pattern = SourceMask.Replace("[ext]", Path.GetExtension(_files[i]).Replace(".", ""));
                            _pattern = _pattern.Replace(Path.GetExtension(_files[i]), "");

                            Debug(string.Format("'{0}': входящий шаблон сконфигурирован", _files[i]));

                            // Получение значений входящих токенов для key и number
                            
                            var _number = string.Empty;
                            if (_number_token.Length > 0)
                                _number = GetKeyTokenValue(Path.GetFileName(_files[i]), _pattern, _number_token, _input_key_token);

                            var _input_key = GetKeyTokenValue(Path.GetFileName(_files[i]).Replace("_" + _number, string.Empty).Replace("__", "_"), _pattern, _input_key_token, "_" + _number_token);
                            Debug(string.Format("'{0}': входящий ключ сконфигурирован", _files[i]));

                            if (_number.Length > 0)
                            {
                                while (_number.Substring(0, 1) == "0")
                                    _number = _number.Substring(1, _number.Length - 1);
                            }
                            Debug(string.Format("'{0}': input number configured", _files[i]));


                            // Проверяем существование товарной позиции в каталоге
                            Debug(string.Format("Проверка существования элемента... Key type: '{0}', key value: '{1}'", _input_key_token, _input_key));
                            if (!_checker.CheckItemExists(_input_key_token.Replace("[", "").Replace("]", ""), _input_key))
                            {

                                _log.Warn(string.Format("Элемент не задан в исходном каталоге. Key type: '{0}', key value: '{1}', source file: '{2}'", _input_key_token, _input_key, _files[i]));
                                _warnings++;

                                // Если задан путь для разрешения конфликтов - перемещаем файл по заданному пути (overwrite = true)
                                if(ConflictsPath.Length >0)
                                {
                                    Debug(string.Format("Копирование файла в папку конфликтов: '{0}'", _files[i]));
                                    File.Copy(_files[i], ConflictsPath + Path.GetFileName(_files[i]), true);
                                    Debug(string.Format("'{0}': файл скопирован в папку конфликтов", _files[i]));
                                    Debug(string.Format("Удаление файла: '{0}'", _files[i]));
                                    File.Delete(_files[i]);
                                    Debug(string.Format("'{0}': файл успешно удален", _files[i]));
                                }

                            }
                            else
                            {

                                // Получаем значение ключа по исходному;
                                var _output_key = _checker.CompareKeys(_input_key_token.Replace("[", "").Replace("]", ""),
                                                     _input_key,
                                                     _output_key_token.Replace("[", "").Replace("]", ""));

                                Debug(string.Format("'{0}': исходящий ключ сконфигурирован", _files[i]));

                                // Определяем новое имя файла в соответствии с заданной маской
                                var _output_file_name = CompareMask.Replace("[ext]", Path.GetExtension(_files[i]).Replace(".", ""));
                                _output_file_name = _output_file_name.Replace(_output_key_token, _output_key);

                                if ((_number_token.Length > 0) & (CompareMask.IndexOf(_number_token) > -1))
                                    _output_file_name = _output_file_name.Replace(_number_token, _number);

                                Debug(string.Format("'{0}': исходящее имя файла определено", _files[i]));

                                // Если параметр Archive задан, то копируем файл в архив;
                                // Параметр OverwriteFiles определяет, нужно ли заменять файл, если он уже существует;
                                // В случае, если файл по каким-либо причинам не скопировался, генерируется наследуемый Exception;
                                // В случае, если файл существует и Overwrite = false генерируется наследуемый Exception;
                                if (ArchivePath.Length > 0)
                                {
                                    Debug(string.Format("КОпирование файла в папку архива: '{0}'", _files[i]));
                                    var _path_archive = ArchivePath + _output_file_name;
                                    File.Copy(_files[i], @_path_archive, Overwrite);
                                    Debug(string.Format("'{0}': файл скопирован в папку архива", _files[i]));
                                }

                                // Копируем файл с новым именем в целевую папку;
                                Debug(string.Format("Копирование файла в исходящую папку: '{0}'", _files[i]));
                                var _path_dest = Destination + _output_file_name;
                                File.Copy(_files[i], @_path_dest, Overwrite);
                                Debug(string.Format("'{0}': файл скопирован в исходящую папку", _files[i]));

                                // Удаляем файл из исходной папки
                                Debug(string.Format("Удаление файла: '{0}'", _files[i]));
                                File.Delete(_files[i]);
                                Debug(string.Format("'{0}': файл удален", _files[i]));

                                _log.Info(string.Format("Файл успешно переименован: '{0}', исходящее имя файла: '{1}'", _files[i], _path_dest));
                                _success++;

                            }

                        }
                        catch (Exception e)
                        {
                            _log.Error(string.Format("Ошибка переименования файла. Файл: '{0}'", _files[i]), e);
                            _errors++;
                        }

                    }
                }

                _log.Info(string.Format("Задание выполнено успешно: {0}. Обработано: {1}, успешно: {2}, с ошибками: {3}, предупреждений: {4}.", Key, _processed, _success, _errors, _warnings));

            }
            else
                // Если объект недоступен, то пишем в лог и выходим
                _log.Warn(string.Format("Задание: {0} заблокировано. Задание неактивно либо доступ запрещен", Key));

        }

        /// <summary>
        /// Функция осуществляет преобразования имени файла по заданным правилам
        /// </summary>
        /// <param name="input">Имя файла для преобразования</param>
        /// <param name="pattern">Шаблон регулярного выражения для преобразования</param>
        /// <param name="key_token">Токен для определения ключа</param>
        /// <param name="empty_token">Токен для подстановки пустой строки</param>
        /// <returns>Преобразованное по заданным правилам имя файла</returns>
        private static string GetKeyTokenValue(string input, string pattern, string key_token, string empty_token)
        {
            // Формирование регулярного выражения
            var s = pattern.Replace(key_token, "([0-9]+)");
            if(empty_token.Length > 0)              // удаляем empty_token
                s = s.Replace(empty_token, "");
            s = s.Replace("__", "_");               // затычка: убираем вхождения двойного символа "_"
            // Выполнение сформированного регулярного выражения с единственым токеном - получение выражения key_token
            var r = new Regex(s, RegexOptions.Compiled);
            var m = r.Match(input);
            // Функция возвращает значение первого токена (соответствующего key_token), полученное от Match;
            // m.Groups[0] всегда есть ВСЕ исходное регулярное выражение;
            return m.Groups[1].ToString();                  // mmx, 18.01.2008: исправление бага с возвратом значения функции
        }

    }

}
