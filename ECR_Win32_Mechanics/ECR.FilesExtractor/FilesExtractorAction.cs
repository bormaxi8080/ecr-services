using System;
using System.Configuration;
using System.IO;
using System.Xml;
using System.Xml.XPath;
using log4net;

namespace ECR.FilesExtractor
{

	/// <summary>
	/// Класс предоставляет интерфейс для управления заданием ...
	/// </summary>
	class FilesExtractorAction
	{

#pragma warning disable 169
		private const string DEFAULT_ENCODING = "base64";
#pragma warning restore 169

		#region Token definitions

		private const string _token1 = "[tk.key]";
		private const string _token2 = "[tk.number]";
		private const string _token3 = "[jd.item]";

		// Строки и массивы строк масок для токенов
		private readonly string[] _keyTokens = { _token1, _token3 };
#pragma warning disable 169
// ReSharper disable InconsistentNaming
		private const string _numberToken = _token2;
// ReSharper restore InconsistentNaming
#pragma warning restore 169

		#endregion

		#region Logging objects and variables

		private readonly static ILog _log = LogManager.GetLogger(typeof(FilesExtractorAction));

		#endregion

        // Путь к temp-папке для работы с файловыми объектами
        private string _temppath = Path.GetTempPath();

		private Guid _key;
		private bool _enabled = true;
		private string _source = string.Empty;
		private string _destination = string.Empty;
		private string _sourceMask = string.Empty;
	    private string _destinationMask = string.Empty;

		#region FilesExtractorAction class constructors

		/// <summary>
		/// Конструктор класса FilesExtractorAction
		/// </summary>
		/// <param name="key">Ключ задания формирования файла xml. Уникальный идентификатор guid</param>
		public FilesExtractorAction(string key)
		{
			DebugMode = false;
			ConfigureLoggingSubsystem();
			_key = new Guid(key);
		    SetTempPath();
		}

		/// <summary>
		/// Конструктор класса FilesExtractorAction
		/// </summary>
		/// <param name="key">Ключ задания формирования файла xml. Уникальный идентификатор guid</param>
		/// <param name="DebugMode">Определяет включение/выключение режима Debug в классе. DebugMode = true включает режим debug</param>
		public FilesExtractorAction(string key, bool DebugMode)
		{
			this.DebugMode = DebugMode;
			ConfigureLoggingSubsystem();
			_key = new Guid(key);
		    SetTempPath();
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
        /// 
        /// </summary>
        private void SetTempPath()
        {
            var _path = ConfigurationManager.AppSettings.Get("TempPath");
            if (_path.Length > 0)
                if (Directory.Exists(_path))
                    _temppath = _path;
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
		/// Свойство определяет режим debug в классе
		/// </summary>
		public bool DebugMode { get; set; }

		/// <summary>
		/// Свойство определяет путь к входящей папке с файлами для формирования файла xml;
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
		/// Свойство определяет путь к исходящей папке с файлами для формирования файла xml;
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
                    throw new Exception(string.Format("Ошибка доступа к папке: '{0}'", value));
				_destination = value;
			}
		}

		/// <summary>
		/// Свойство определяет маску имен файлов во входящей папке
		/// </summary>
		public string DestinationMask
		{
			get
			{
				return _destinationMask;
			}
			set
			{
				_destinationMask = value;
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
		/// Метод запускает задание формирования файла xml из файлов нативного формата во входящей папке
		/// </summary>
		public void Execute()
		{

			_log.Info(string.Format("Запуск задания... Key: '{0}', Source: '{1}', , Destination: '{2}', Source mask: '{3}'", Key, Source, Destination, SourceMask));

			// Проверка на доступность объекта
			if (Enabled)
			{
				
                #region Инициализация счетчиков
				var _processed = 0;
				var _success = 0;
				var _errors = 0;
// ReSharper disable ConvertToConstant.Local
				var _warnings = 0;
// ReSharper restore ConvertToConstant.Local
				#endregion

				Debug("Получение списка файлов...");

				// Резервируем файлы для обработки, переименовывая их <file_name>.ecr$
				var di = new DirectoryInfo(Source);

				// Проверяем есть ли зарезервированные но не обработаные файлы
				var _files = di.GetFiles("*.ecr$");

				// Если файлов нет, забираем новые
				if (_files.Length == 0)
				{
                    // Резервируем файлы xml заданного формата.
                    // ВАЖНО: файлы могут иметь расширение, заданное входящей маской и отличное от xml, но должны соответствовать заданному формату!
					foreach (var fileInfo in di.GetFiles(SourceMask))
					{
						fileInfo.MoveTo(fileInfo.FullName + ".ecr$");
					}
					// Получаем зарезервированные
					_files = di.GetFiles("*.ecr$");
				}

                // Основной цикл обработки входящих файлов
				foreach(var _file in _files)
				{
					try
					{
						
                        Debug(string.Format("Обрабатывается файл: '{0}'...", _file.FullName));
						_processed++;

						// Загружаем объект xml в DOM
						_log.Info(string.Format("Загружается xml: '{0}'...", _file.FullName));

						var _xml = new XmlDocument();
						_xml.Load(_file.FullName);

						// Создаем навигацию по объекту xml
						XPathNavigator _xpn = _xml.CreateNavigator();
						if (_xpn != null)
						{
							_xpn.MoveToRoot();
							XPathNodeIterator _ni = _xpn.Select("//Message/Object");

							while (_ni.MoveNext())
							{
								// Получаем тело файла в base64
								var _item_body = _ni.Current.GetAttribute("ItemBody", "");
								// Проверяем присутствует ли тело файла в xml и перекодируем
                                // Отсутствие атрибута ItemBody эквивалентно операции удаления файла (в нативных выгрузках не обрабатывается)
							    if (_item_body == string.Empty) continue;
							    var _binaryData = Convert.FromBase64String(_item_body);

                                // Проверка наличия атрибутов в xml
                                var _ext = _ni.Current.GetAttribute("Extension", "");
                                if (_ext.Length == 0)
                                    throw new Exception(string.Format("Расширение исходящего файла не определено в xml: {0}", _file.FullName));
                                var _outputKey = _ni.Current.GetAttribute("ItemKey", "");
                                if (_outputKey.Length == 0)
                                    throw new Exception(string.Format("Ключ исходящего файла не определен в xml: {0}", _file.FullName));
							    var _itemNumber = _ni.Current.GetAttribute("ItemNumber", "");
                                
                                // Определение имени файла по исходящей маске
							    var _outputFileName = DestinationMask.Replace("[ext]", _ext);
							    _outputFileName = _outputFileName.Replace(_keyTokens[0], _outputKey);       // [tk.key]
                                _outputFileName = _outputFileName.Replace(_keyTokens[1], _outputKey);       // [jd.item]
                                if(DestinationMask.IndexOf(_numberToken, 0) >-1)   // в исходящей маске присутствует номер позиции
                                {
                                    if (_itemNumber.Length > 0)
                                        _outputFileName = _outputFileName.Replace(_numberToken, _itemNumber);
                                    else
                                        throw new Exception(string.Format("Параметр 'ItemNumber' не найден, но определен в исходящей маске. Файл: '{0}'", _file.FullName));
                                }
                                else                                               // в исходящей маске нет номера позиции
                                {
                                    if (_itemNumber.Length > 0)
                                        throw new Exception(string.Format("Параметр 'ItemNumber' не задан в исходящей маске, но определен в xml. Файл: '{0}'", _file.FullName));
                                }
							    Debug(string.Format("'{0}': имя исходящего файла определено как: '{1}'", _file.FullName, _outputFileName));

							    // Записываем файл в temp
							    var _outFile = new FileStream(_temppath + _outputFileName, FileMode.Create, FileAccess.Write);
							    _outFile.Write(_binaryData, 0, _binaryData.Length);
							    _outFile.Close();

							    // Если файл сформирован корректно, копируем полученный файл из папки temp в папку Destination
							    File.Copy(_temppath + _outputFileName, Destination + _outputFileName, true);
							    Debug(string.Format("Файл '{0}' скопирован в исходящую папку", _outputFileName));

                                // Удаляем файл из temp
                                File.Delete(_temppath + _outputFileName);
							    Debug(string.Format("Файл '{0}' удален из папки temp", _outputFileName));

							    Debug(string.Format("Файл успешно выгружен: '{0}''", Destination + _outputFileName));

							}

						}

                        // Удаляем отработаный файл
                        _file.Delete();
                        _success++;

					}
					catch (Exception e)
					{
						_log.Error(string.Format("Ошибка операции выгрузки файлов. Файл: '{0}'", _file.FullName), e);
                        // Копирование файла в папку Errors
                        var _path = ConfigurationManager.AppSettings.Get("ErrorsPath");
                        if (_path.Length > 0)
                            if (Directory.Exists(_path))
                                _file.CopyTo(_path + _file.Name, true);
						_errors++;
					}
				}
				_log.Info(string.Format("Обработано: {0}, успешно: {1}, с ошибками: {2}, предупреждений: {3}.", _processed, _success, _errors, _warnings));

			}
			else
				// Если объект недоступен, то пишем в лог и выходим
                _log.Warn(string.Format("Задание: {0} заблокировано. Задание неактивно либо доступ запрещен", Key));
		}
	}

}
