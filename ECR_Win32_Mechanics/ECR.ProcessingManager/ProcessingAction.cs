using System;
using System.Configuration;
using System.Data;
using System.Text;
using System.IO;
using log4net;
using ECRManagedAssemblies;

namespace ECR.ProcessingManager
{

    /// <summary>
    /// Класс предоставляет интерфейс для управления заданием преобразования и загрузки данных в хранилище системы ECR
    /// </summary>
    public class ProcessingAction
    {

#pragma warning disable 169
        private const string DEFAULT_ENCODING = "base64";
        private const string UNICODE_ENCODING = "unicode";
#pragma warning restore 169

        #region Token definitions

        private const string _token1 = "[tk.key]";
        private const string _token2 = "[tk.number]";
        private const string _token3 = "[jd.item]";

        private readonly string[] _keyTokens = { _token1, _token3 };
        private const string _numberToken = _token2;

        #endregion

        #region Container definitions

        private const string _ctGraphical = "ctGraphical";
        private const string _ctTextDefault = "ctTextDefault";

        #endregion

        #region Logging objects and variables

        private readonly static ILog _log = LogManager.GetLogger(typeof(ProcessingAction));

        #endregion

        private Guid _key;
        private bool _enabled = true;
        private bool _overwrite = true;
        private bool _defaultProcessing = true;
        private bool _saveOriginals = true;
        private bool _checkProperties = true;
        private string _itemType = string.Empty;
        private string _containerType = string.Empty;
        private string _source = string.Empty;
        private string _mask = string.Empty;
        private string _backupTo = string.Empty;
        
        #region ProcessingAction class constructors

        /// <summary>
        /// Конструктор класса ProcessingAction
        /// </summary>
        /// <param name="key">Ключ задания обработки и загрузки данных в ECR. Уникальный идентификатор guid</param>
        public ProcessingAction(string key)
        {
            DebugMode = false;
            ConfigureLoggingSubsystem();
            _key = new Guid(key);
        }

        /// <summary>
        /// Конструктор класса ProcessingAction
        /// </summary>
        /// <param name="key">Ключ задания обработки и загрузки данных в ECR. Уникальный идентификатор guid</param>
        /// <param name="DebugMode">Определяет включение/выключение режима Debug в классе. DebugMode = true включает режим debug</param>
        public ProcessingAction(string key, bool DebugMode)
        {
            this.DebugMode = DebugMode;
            ConfigureLoggingSubsystem();
            _key = new Guid(key);
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
// ReSharper disable UnusedPrivateMember
// ReSharper disable UnusedMember.Local
        private void Debug(string message, Exception e)
// ReSharper restore UnusedMember.Local
// ReSharper restore UnusedPrivateMember
        {
            if (DebugMode)
                _log.Debug(message, e);
        }

        #endregion

        /// <summary>
        /// Свойство определяет режим debug в классе
        /// </summary>
        public bool DebugMode { get; set; }

        /// <summary>
        /// Свойство возвращает ключ задания формирования файла xml (уникальный идентификатор guid)
        /// </summary>
        public string Key
        {
            get
            {
                return _key.ToString();
            }
        }

        /// <summary>
        /// Свойство возвращет состояние доступности задания формирования файла xml
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
        /// Свойство возвращет признак перезаписи уже существующих элементов в хранилище ECR
        /// </summary>
        public bool Overwrite
        {
            get
            {
                return _overwrite;
            }
            set
            {
                _overwrite = value;
            }
        }

        /// <summary>
        /// Метод переводит состояние задания формирования файла xml в "доступно"
        /// </summary>
        public void Enable()
        {
            _enabled = true;
        }

        /// <summary>
        /// Метод переводит состояние задания формирования файла xml в "недоступно"
        /// </summary>
        public void Disable()
        {
            _enabled = false;
        }

        /// <summary>
        /// Свойство определяет системное имя сущности для загрузки
        /// </summary>
        public string ItemType
        {
            get
            {
                return _itemType;
            }
            set
            {
                _itemType = value;
            }
        }

        /// <summary>
        /// Тип контейнера для определения преобразований
        /// </summary>
        public string ContainerType
        {
            get
            {
                return _containerType;
            }
            set
            {
                switch(value)
                {
                    case _ctGraphical:
                        _containerType = _ctGraphical;
                        return;
                    case _ctTextDefault:
                        _containerType = _ctTextDefault;
                        return;
                }
                throw new Exception(string.Format("Неизвестное определение типа контента: '{0}'", value));
            }
        }

        /// <summary>
        /// Идентификатор контейнера преобразований
        /// </summary>
        public int ContainerId { get; set; }

        /// <summary>
        /// Свойство определяет путь к входящей папке с файлами для преобразования и загрузки в систему ECR;
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
                    throw new Exception(string.Format("Ошибка доступа к папке: '{0}'", value));
                _source = value;
            }
        }

        /// <summary>
        /// Свойство определяет маску имени файла во входящей папке
        /// </summary>
        public string Mask
        {
            get
            {
                return _mask;
            }
            set
            {
                _mask = value;
            }
        }

        /// <summary>
        /// Свойство определяет путь к исходящей папке с файлами для формирования файла xml;
        /// В случае отсутствия папки либо доступа к ней генерируется exception;
        /// </summary>
        public string BackupTo
        {
            get
            {
                return _backupTo;
            }
            set
            {
                if (value.Length > 0)
                {
                    if (!Directory.Exists(value))
                        throw new Exception(string.Format("Ошибка доступа к папке: '{0}'", value));
                }
                _backupTo = value;
            }
        }

        /// <summary>
        /// Свойство определяет нужно ли применять преобразования, заданные по умолчанию, к сущности ecr.Entity при обработке конвейером
        /// </summary>
        public bool DefaultProcessing
        {
            get
            {
                return _defaultProcessing;
            }
            set
            {
                _defaultProcessing = value;
            }
        }

        /// <summary>
        /// Свойство определяет нужно ли сохранять оригиналы файлов (ecr.Entity) в хранилище ECR
        /// </summary>
        public bool SaveOriginals
        {
            get
            {
                return _saveOriginals;
            }
            set
            {
                _saveOriginals = value;
            }
        }

        /// <summary>
        /// Свойсто определяет нужно ли производить проверки свойств файлового объекта при обработке/загрузке в ECR
        /// </summary>
        public bool CheckProperties
        {
            get
            {
                return _checkProperties;  
            }
            set
            {
                _checkProperties = value;
            }
        }

        /// <summary>
		/// Метод запускает задание обработки и загрузки данных в хранилище ECR
		/// </summary>
        public void Execute()
        {

            _log.Info(string.Format("Запуск задания... Key: '{0}', ItemType: '{1}', , Source: '{2}', Mask: '{3}', Save Originals: {4}", Key, ItemType, Source, Mask, SaveOriginals));

			// Проверка на доступность объекта
            if (!Enabled)
            {
                // Если объект недоступен, то пишем в лог и выходим
                _log.Warn(string.Format("Задание: {0} заблокировано. Задание неактивно либо доступ запрещен", Key));
                return;
            }

            Debug("Определение папки для сброса файлов с ошибками...");
            var _pathErrors = ConfigurationManager.AppSettings.Get("ECR.ProcessingManager.PathErrors");
            if (_pathErrors.Length > 0)
            {
                if (!Directory.Exists(_pathErrors))
                {
                    _log.Error(string.Format("Ошибка доступа к папке: ' {0}'", _pathErrors));
                    return;
                }
            }

            #region Инициализация счетчиков
            var _processed = 0;
            var _success = 0;
            var _errors = 0;
            var _warnings = 0;
            #endregion

            Debug("Получение списка файлов...");

            // Резервируем файлы для обработки переименовывая их <file_name>.ecr$
            var di = new DirectoryInfo(Source);

            // Проверяем есть ли зарезервированные но не обработаные файлы
            var _files = di.GetFiles("*.ecr$");

            // Если файлов нет, забираем новые
            if (_files.Length == 0)
            {
                Debug("Получение списка новых файлов...");
                // Формируем маску файла в виде *[_*].*
                var _inputMask = Mask.Replace("[ext]", "*");
                _inputMask = _inputMask.Replace(_keyTokens[0], "*");
                _inputMask = _inputMask.Replace(_keyTokens[1], "*");
                _inputMask = _inputMask.Replace(_numberToken, "*");
                // Резервируем файлы
                foreach (var fileInfo in di.GetFiles(_inputMask))
                    fileInfo.MoveTo(fileInfo.FullName + ".ecr$");
                // Получаем зарезервированные файлы
                _files = di.GetFiles("*.ecr$");
            }

            // Объявление интерфейсной переменной основного объекта проверки и обработки данных
            IECRProcessor _processor;
            // Тип контейнера определяет какой тип объекта преобразований создавать в интерфейсной переменной
            switch (ContainerType)
            {
                case _ctGraphical:
                    _processor = new GraphicsProcessor(ContainerId);
                    break;
                case _ctTextDefault:
                    _processor = new TextProcessor(ContainerId);
                    break;
                default:
                    _log.Error(string.Format("Неизвестный тип контейнера данных: '{0}'", ContainerType));
                    return;
            }

            // Определяем объект ECRManagedDataReader
            Debug("Определение объекта ECRManagedDataReader...");
            var _ecrDataReader = new ECRManagedDataReader(ConfigurationManager.AppSettings.Get("ECR_Config.BaseServerName"),
                    Convert.ToInt32(ConfigurationManager.AppSettings.Get("ECR_Config.ConnectionTimeout")),
                    Convert.ToInt32(ConfigurationManager.AppSettings.Get("ECR_Config.CommandTimeout")),
                    DebugMode);
            var _ecrDataWriter = new ECRManagedDataWriter(ConfigurationManager.AppSettings.Get("ECR_Config.BaseServerName"),
                    Convert.ToInt32(ConfigurationManager.AppSettings.Get("ECR_Config.ConnectionTimeout")),
                    Convert.ToInt32(ConfigurationManager.AppSettings.Get("ECR_Config.CommandTimeout")),
                    DebugMode);

            // Определяем сущность из конфигурационной базы ECR
            Debug("Определение свойств обрабатываемой сущности...");
            var _dsEntity = _ecrDataReader.GetEntity(ItemType);

            // Определяем список доступных представлений-наследников для сущности с системным именем ItemType
            Debug("Определение списка потомков сущности...");
            var _dsChildViews = _ecrDataReader.GetViewListByEntity(ItemType, true);

            Debug("Обработка файлов...");
            foreach (var _file in _files)
            {
                try
                {

                    Debug(string.Format("Обрабатывается файл: '{0}'...", _file.FullName));
                    _processed++;

                    // Определение ItemKey, ItemNumber
                    Debug("Определение параметров ключей...");

                    var itemKey = _file.Name;
                    itemKey = itemKey.Replace(_file.Extension, string.Empty);
                    var _fi = new FileInfo(itemKey);
                    itemKey = itemKey.Replace(_fi.Extension, string.Empty);
  
                    var index = itemKey.IndexOf("_");
                    int? itemNumber = null;
                    if (Convert.ToBoolean(_dsEntity.Tables["EntityData"].Rows[0]["IsMultiplied"]))      // if IsMultiplied
                    {
                        if (index > -1)
                        {
                            // По правилам наименования файлов если контент множественный, то первый номер проходит без "_*"!
                            itemNumber = Convert.ToInt32(itemKey.Substring(index + 1)) + 1;
                            itemKey = itemKey.Replace(string.Format("_{0}", itemNumber - 1), string.Empty);
                        }
                        else
                            itemNumber = 1;
                    }
                    else
                    {
                        if (index > -1)
                            throw new Exception(
                                string.Format("Некорректное имя файла для немножественной сущности. Файл: '{0}', сущность: '{1}'", _file.FullName, ItemType));
                    }

                    // Убираем нечисловые символы из itemKey
                    var _itemKey = string.Empty;
                    foreach (var _c in itemKey)
                    {
                        for (var l = 0; l < 10; l++)
                        {
                            if ((int)_c == (int)((l.ToString().ToCharArray())[0]))
                            {
                                _itemKey = _itemKey + _c;
                                break;
                            }
                        }    
                    }
                    itemKey = _itemKey;

                    Debug(string.Format("Передача данных, ItemKey: '{0}', ItemNumber: {1}", itemKey, itemNumber));

                    // В зависимости от типа контейнера преобразований получаем данные в Unicode или в Base64 и применяем преобразования
                    Debug(string.Format("Чтение данных из файла: '{0}'", _file.FullName));

                    object _buffer = null;

                    #region Формирование данных из файла

                    // Тип контейнера определяет как считывать данные из файла
                    switch (ContainerType)
                    {
                        case _ctGraphical:
                            using (var _fs = new FileStream(_file.FullName, FileMode.Open, FileAccess.Read))
                            {
                                _buffer = new byte[(int) _fs.Length];
                                try
                                {
                                    _fs.Read(_buffer as byte[], 0, (int) _fs.Length);
                                }
                                finally
                                {
                                    _fs.Close();
                                }
                            }
                            break;
                        case _ctTextDefault:
                            var _sr = new StreamReader(_file.FullName, Encoding.Default);
                            _buffer = new char[(int) _sr.BaseStream.Length];
                            try
                            {
                                _sr.Read(_buffer as char[], 0, (int) _sr.BaseStream.Length);
                            }
                            finally
                            {
                                _sr.Close();
                            }
                            break;
                    }

                    #endregion

                    // Загрузка данных в основной процессинговый объект.

                    Debug(string.Format("Загрузка данных в процессор ECR. Файл: '{0}'", _file.FullName));
                    
                    var _error = string.Empty;
                    string _check_params;
                    
                    if (_dsEntity.Tables["EntityData"].Rows[0]["Params"] == DBNull.Value)
                        _check_params = null;
                    else
                        _check_params = (string)_dsEntity.Tables["EntityData"].Rows[0]["Params"];
                    
                    //    Загрузка определяется дефолтными преобразованиями данных (которых может и не быть), заданными в контейнере.
                    //    Загрузка осуществляет также проверку данных на соответствие стандартам, заданным в контейнере.
                    if(!_processor.LoadObject(_buffer, _checkProperties, _defaultProcessing, _check_params, ref _error))
                    {
                        // Возврат файла в папку обработки ошибок
                        // TODO: сделать проверку на отсутствие сети!
                        // TODO: сделать отдельную нотификацию через log4net (SMTPAppender)
                        _log.Warn(string.Format("Проверка свойств не пройдена! Описание ошибки: '{0}'. Файл: '{1}'", _error, _file.FullName));
                        if (_pathErrors.Length > 0)
                        {
                            Debug(string.Format("Копирование файла в папку обработки ошибок: '{0}'", _file.Name));
                            // При возврате файла отрезаем расширение ".ecr$"
                            _file.CopyTo(_pathErrors + ItemType + "\\" + (_file.Name).Replace(".ecr$", string.Empty), true);
                            Debug(string.Format("Файл скопирован в папку обработки ошибок: '{0}'", _file.Name));
                        }
                        _warnings++;
                    }
                    else
                    {

                        // TODO: после заливки всех данных реализовать здесь функционал проверки наличия сущности в хранилище ECR С использованием ItemsSummary
                        // TODO: опционально по значению параметра overwrite осуществлять проверку и в случае overwite=false и сущность уже существует копировать файл в папку global 
                        if(!Overwrite)
                        {
                        }

                        // Получаем базовые данные и определяем тип операции
                        byte[] _base = _processor.GetBase();
                        var _operation = _base.Length > 0 ? "I" : "D";

                        // Запись информации в сводную таблицу ECR_Config.ecr.ItemsSummary для сбора статистики
                        // TODO: здесь хардкод по операции "I" (insert) вставки данных в таблицу ItemsSummary
                        // TODO: Впоследствии нужно добавить процедуру ECR_Config.ecr.CheckItemExists
                        // TODO: и разрулить всю логику от ее возвращаемого значения, а также проверять значение на null (~ операции очистки - "C")
                        _ecrDataWriter.UpdateItemSummary(itemKey, itemNumber, ItemType, _operation);

                        // Загрузка базового представления (оригинала) в базу ECR_Storage.
                        // Флаг SaveOriginals не является интерфейсным и не фигурирует в настройках сущностей в базе ECR_Config.
                        // Это "чисто конфигурационная" вещь, созданная для удобства промежуточных заливок данных.
                        if (SaveOriginals)
                        {
                            Debug("Передача данных оригинала в хранилище ECR. Файл: '" + _file.FullName + "'");
                            _ecrDataWriter.TransferEntity(itemKey, itemNumber, _base, ItemType);
                            Debug(string.Format("Данные оригинала переданы в хранилище ECR. Файл: '{0}'", _file.FullName));
                        }

                        // Проверка наличия записей о генерации потомков
                        Debug(string.Format("Передача данных представлений в хранилище ECR. Файл: '{0}'", _file.FullName));
                        if (_dsChildViews.Tables["ViewList"].Rows.Count > 0)
                        {
                            // Создание и загрузка в базу ECR_Storage представлений-потомков в цикле по исходным данным из ECR_Config
                            var _etr = _dsChildViews.Tables["ViewList"].Rows.GetEnumerator();
                            while (_etr.MoveNext())
                            {
                                var _row = (DataRow) _etr.Current;
                                Debug(string.Format("Передача данных в хранилище ECR. Представление: '{0}'. Файл: '{1}'", _row["SystemName"], _file.FullName));
                                _ecrDataWriter.TransferView(
                                    itemKey,
                                    itemNumber,
                                    _operation == "D" ? _base : _processor.CreateView(_row["SystemName"].ToString(), _row["Params"].ToString()),
                                    _row["SystemName"].ToString()
                                    );
                                Debug(string.Format("Данные представления переданы в хранилище ECR. Представление: '{0}'. Файл: '{1}'", _row["SystemName"], _file.FullName));
                            }
                        }

                        _log.Info(string.Format("Файл успешно обработан: '{0}'", _file.FullName));

                        // Если задан путь для дополнительного копирования, то бэкапим исходный файл.
                        // Данные предыдущих бэкапов перезатираются.
                        if (BackupTo.Length > 0)
                        {
                            Debug(string.Format("Копирование файла '{0}' в папку: '{1}'...", _file.Name.Replace("ecr$", string.Empty), BackupTo + ItemType + "\\"));
                            _file.CopyTo(BackupTo + ItemType + "\\" + _file.Name.Replace("ecr$", string.Empty), true);
                            Debug(string.Format("Файл '{0}' скопирован в папку: '{1}'", _file.Name.Replace("ecr$", string.Empty), BackupTo + ItemType + "\\"));
                        }

                        _success++;
                    
                    }
                    
                }
                catch (Exception e)
                {
                    _log.Error(string.Format("Ошибка при обработке файла: '{0}'", _file.FullName), e);
                    if (_pathErrors.Length > 0)
                    {
                        Debug(string.Format("Копирование файла в папку обработки ошибок: '{0}'", _file.Name));
                        // При возврате файла отрезаем расширение ".ecr$"
                        _file.CopyTo(_pathErrors + ItemType + "\\" + (_file.Name).Replace(".ecr$", string.Empty), true);
                        Debug(string.Format("Файл скопирован в папку обработки ошибок: '{0}'", _file.Name));
                    }
                    _errors++;
                }
                finally
                {
                    // Удаляем отработанный файл
                    Debug(string.Format("Удаление файла: '{0}'", _file.FullName));
                    _file.Delete();
                    Debug(string.Format("Файл удален: '{0}'", _file.FullName));
                }

            }   // foreach

            _log.Info(string.Format("Обработано {0} файлов, {1} - успешно, {2} - с ошибками, {3} - с предупреждениями.", _processed, _success, _errors, _warnings));

        }

        /// <summary>
        /// Процедура конвертации строки Unicode в строку base64
        /// </summary>
        /// <param name="s">Unicode string</param>
        /// <returns>Base64 string</returns>
// ReSharper disable UnusedMember.Local
        private string ConvertToBase64String(string s)
// ReSharper restore UnusedMember.Local
        {
            var _encoding = Encoding.Unicode;
            var _buffer = _encoding.GetBytes(s);
            return Convert.ToBase64String(_buffer);  
        }

    }

}