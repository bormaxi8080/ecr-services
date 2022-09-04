using System;
using System.Configuration;
using System.Text;
using System.IO;
using System.Xml;
using System.Data;
using System.Data.SqlClient;
using System.Xml.XPath;
using System.Xml.Xsl;
using log4net;

namespace ECR.ChangeManager
{
    /// <summary>
    /// Класс запуска задания формирования сбора данных по изменениям в файл xml
    /// </summary>
    class ChangeManageAction
    {

        #region Logging objects and variables

        private readonly static ILog _log = LogManager.GetLogger(typeof(ChangeManageAction));

        #endregion

        private Guid _key;

        private string _connectionString = string.Empty;
        private string _storageName = string.Empty;
        private string _changeType = "otContentView";
        private string _snapshotType = "changes";
        private string _destination = string.Empty;
		private string _destinationSj = string.Empty;
        private int _commandTimeout = 600;
        private int _packageSize = 100;

        #region ChangeManageAction class constructors

        /// <summary>
        /// Конструктор класса ChangeManageAction
        /// </summary>
        /// <param name="key">Ключ задания. Уникальный идентификатор guid</param>
        public ChangeManageAction(string key)
        {
            DebugMode = false;
            ConfigureLoggingSubsystem();
            _key = new Guid(key);
            Enabled = true;
        }

        /// <summary>
        /// Конструктор класса ChangeManageAction
        /// </summary>
        /// <param name="key">Ключ задания. Уникальный идентификатор guid</param>
        /// <param name="DebugMode">Определяет включение/выключение режима Debug в классе. DebugMode = true включает режим debug</param>
        public ChangeManageAction(string key, bool DebugMode)
        {
            this.DebugMode = DebugMode;
            ConfigureLoggingSubsystem();
            _key = new Guid(key);
            Enabled = true;
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
        /// <param name="Message">Сообщение для debug</param>
        private void Debug(string Message)
        {
            if (DebugMode)
                _log.Debug(Message);
        }

        /// <summary>
        /// Запись данных в режиме Log.Debug() с проверкой режима отладки и описанием Exception
        /// </summary>
        /// <param name="Message">Сообщение для debug</param>
        /// <param name="e">Exception для debug</param>
// ReSharper disable UnusedMember.Local
        private void Debug(string Message, Exception e)
// ReSharper restore UnusedMember.Local
        {
            if (DebugMode)
                _log.Debug(Message, e);
        }

        #endregion

        /// <summary>
        /// Свойство возвращает ключ задания (уникальный идентификатор guid)
        /// </summary>
        public string Key
        {
            get
            {
                return _key.ToString();
            }
        }

        /// <summary>
        /// Свойство возвращет состояние доступности задания
        /// </summary>
        public bool Enabled { get; set; }

        /// <summary>
        /// Метод переводит состояние задания в "доступно"
        /// </summary>
        public void Enable()
        {
            Enabled = true;
        }

        /// <summary>
        /// Метод переводит состояние задания в "недоступно"
        /// </summary>
        public void Disable()
        {
            Enabled = false;
        }

        /// <summary>
        /// Свойство определяет режим debug в классе
        /// </summary>
        public bool DebugMode { get; set; }

        /// <summary>
        /// Свойство определяет строку соединения с конфигурационной базой данных ECR_Config
        /// </summary>
        public string ConnectionString
        {
            get
            {
                return _connectionString;
            }
            set
            {
                _connectionString = value;
            }
        }

        /// <summary>
        /// Свойство определяет системное имя хранилища файлового контента для выгрузки
        /// </summary>
        public string StorageName
        {
            get
            {
                return _storageName;    
            }
            set
            {
                _storageName = value;    
            }
        }

        /// <summary>
        /// Свойство определяет тип выгрузки (Entity/View)
        /// </summary>
        public string ChangeType
        {
            get
            {
                return _changeType;    
            }
            set
            {
                switch(value)
                {
                    case "otContentEntity":
						_changeType = value;
						break;
                    case "otContentView":
                        _changeType = value;
                        break;
                    default:
                        throw new Exception(string.Format("Некорректное значение параметра 'ChangeType': '{0}'", value));
                }
            }
        }

        /// <summary>
        /// Свойство определяет тип выгрузки данных (all - полный снапшот данных, changes - только изменения)
        /// </summary>
        public string SnapshotType
        {
            get { return _snapshotType; }
            set
            {
                switch(value)
                {
                    case "all":
                        _snapshotType = value;
                        break;
                    case "changes":
                        _snapshotType = value;
                        break;
                    default:
                        throw new Exception(string.Format("Некорректное значение параметра 'SnapshotType': '{0}'", value));
                }
            }
        }

        /// <summary>
        /// Свойство определяет путь к исходящей папке для сохранения файлов;
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
		/// Свойство определяет путь к исходящей папке для сохранения файлов журнала отправки;
		/// В случае отсутствия папки либо доступа к ней генерируется exception;
		/// </summary>
		public string DestinationSj
		{
		    get
			{
			    return _destinationSj;
		    }
			set
			{
                if (value.Length > 0)
                {
                    if (!Directory.Exists(value))
                        throw new Exception(string.Format("Ошибка доступа к папке: '{0}'", value));
                }
			    _destinationSj = value;
			}
		}

        /// <summary>
        /// Свойство определяет величину CommandTimeout при выборке из хралилищ ECR_Storage
        /// </summary>
        public int CommandTimeout
        {
            get
            {
                return _commandTimeout;
            }
            set
            {
                if (value < 1)
                    throw new Exception(string.Format("Некоректное значение параметра 'CommandTimeout': {0}", value));
                _commandTimeout = value;
            }
        }

        /// <summary>
        /// Свойство определяет количество записей в пакете при осуществлении выгрузки в формате Xml
        /// </summary>
        public int PackageSize
        {
            get
            {
                return _packageSize; 
            }
            set
            {
                if(value < 1)
                    throw new Exception(string.Format("Некорректное значение параметра PackageSize: {0}", value));
                _packageSize = value;  
            }
        }

        /// <summary>
        /// Метод запускает задание выгрузки файловового контента в исходящую папку
        /// </summary>
		public void Execute()
        {

        	_log.Info(
        		string.Format(
                    "Запуск задания... Key:  {0}, Storage: '{1}', SnapshotType: '{2}', Change Type: '{3}', Destination: '{4}', Package Size: {5}",
        			Key, StorageName, SnapshotType, ChangeType, Destination, PackageSize));

        	// Проверка на доступность объекта
        	if (Enabled)
        	{

        		try
        		{

                    // Определение TempPath
                    var _tempPath = ConfigurationManager.AppSettings.Get("ECR.ChangeManager.TempPath");
                    if (_tempPath.Length == 0)
                        _tempPath = Path.GetTempPath();

                    // Определение значения переменной-флага создания журналов отправки
                    var _writeSJ = Convert.ToBoolean(ConfigurationManager.AppSettings.Get("ECR.ChangeManager.WriteSJ"));

                    Debug("Копирование в целевую папку...");

                    // Проверка наличия файлов <file_name>.ecrchg$ в temp
                    var di = new DirectoryInfo(_tempPath);
                    
                    // ... основной поток данных
                    var _files = di.GetFiles(ChangeType + "_*_" + StorageName + ".xml.ecrchg$");
                    if (_files.Length > 0)
                    {
                        for (var i = 0; i < _files.Length; i++)
                        {
                            File.Copy(_tempPath + _files[i].Name, Destination + _files[i].Name.Replace(".ecrchg$", string.Empty), true);
                            Debug(string.Format("Файл '{0}' скопирован в папку '{1}'", _files[i].Name.Replace(".ecrchg$", string.Empty), Destination));
                            File.Delete(_tempPath + _files[i].Name);
                            Debug(string.Format("Файл '{0}' удален", _files[i].Name.Replace(".ecrchg$", string.Empty)));
                        }
                    }
                    
                    // ... журналы отправок
                    if (_writeSJ)
                    {
                        // "otSendingJournal_ECR_{0}_{1}.xml.ecrchg$"
                        _files = di.GetFiles("otSendingJournal_ECR_*_" + StorageName + ".xml.ecrchg$");
                        if (_files.Length > 0)
                        {
                            for (var i = 0; i < _files.Length; i++)
                            {
                                File.Copy(_tempPath + _files[i].Name, DestinationSj + _files[i].Name.Replace(".ecrchg$", string.Empty), true);
                                Debug(string.Format("Файл '{0}' скопирован в папку '{1}'", _files[i].Name.Replace(".ecrchg$", string.Empty), Destination));
                                File.Delete(_tempPath + _files[i].Name);
                                Debug(string.Format("Файл '{0}' удален", _files[i].Name.Replace(".ecrchg$", string.Empty)));
                            }
                        }
                    }

        		    // Определяем строку соединения с базой данных ECR_Storage<i> по имени хранилища StorageName
        			Debug("Определение строки соединения с базой данных ECR_Storage...");
        			var _storageCnnStr = GetConnectionString(StorageName);

        			Debug("Создание пакета xml...");

                    // Snapshot type
                    switch (SnapshotType)
                    { 

                        // changeset
                        case "changes":

                            using (var _conn = new SqlConnection(_storageCnnStr))
                            {
                                using (var _cmd = new SqlCommand())
                                {

                                    _conn.Open();
                                    try
                                    {

                                        Debug("Определение параметров создания пакета...");

                                        _cmd.Connection = _conn;
                                        _cmd.CommandTimeout = CommandTimeout;
                                        _cmd.CommandType = CommandType.StoredProcedure;

                                        switch (ChangeType)
                                        {
                                            case "otContentEntity":
                                                _cmd.CommandText = "[ecr].[CollectEntityChanges_Xml]";
                                                break;
                                            case "otContentView":
                                                _cmd.CommandText = "[ecr].[CollectViewChanges_Xml]";
                                                break;
                                        }

                                        _cmd.Parameters.AddWithValue("Count", PackageSize);
                                        var _packageId = _cmd.Parameters.Add("@PackageID", SqlDbType.Int);
                                        _packageId.Direction = ParameterDirection.Output;
                                        var _outXml = _cmd.Parameters.Add("@OutXml", SqlDbType.Xml);
                                        _outXml.Direction = ParameterDirection.Output;
                                        _outXml.Size = Convert.ToInt32(ConfigurationManager.AppSettings.Get("ECR.ChangeManager.MaxOutputFileSize"));

                                        // Имя основного файла
                                        var _xmlFilename = string.Format("{0}_{1}_{2}.xml.ecrchg$", ChangeType, _packageId.Value, StorageName);
                                        // Имя файла для журнала отчета
                                        var _xmlSjFilename = string.Format("otSendingJournal_ECR_{0}_{1}.xml.ecrchg$", _packageId.Value, StorageName);

                                        Debug("Запуск хранимой процедуры создания пакета...");
                                        _cmd.ExecuteNonQuery();

                                        Debug("Запись данных пакета в файл xml...");
                                        // Формирование основного файла
                                        using (var _writer = new XmlTextWriter(_tempPath + _xmlFilename, Encoding.Default))
                                        {
                                            try
                                            {
                                                _writer.Formatting = Formatting.None;
                                                _writer.WriteRaw(_outXml.Value.ToString());
                                                _writer.Flush();
                                            }
                                            finally
                                            {
                                                _writer.Close();
                                            }
                                        }
                                        Debug("Создание основного файла пакета xml завершено успешно");

                                        #region Writing Sending Journals

                                        // Пишем файл журнала отправок
                                        if (_writeSJ)
                                        {

                                            Debug("Создание файла журнала отправок...");

                                            // Константа xslt-преобразования для получения файла журнала отправок
                                            const string xsltScript = @"<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform'>"
                                                                                       + "	<xsl:output method='xml' version='1.0' encoding='UTF-8' indent='yes'/>"
                                                                                       + " <xsl:param name='mID'></xsl:param>"
                                                                                       + " <xsl:param name='origFN'></xsl:param>"
                                                                                       + "	<xsl:template match='/'>"
                                                                                       + "		<!--Describe message's root element-->"
                                                                                       + "		<xsl:element name='Message'>"
                                                                                       + "			<xsl:attribute name='MessageId'><xsl:value-of select='$mID'></xsl:value-of></xsl:attribute>"
                                                                                       + "			<xsl:attribute name='MessageCreationTime'><xsl:value-of select='//Message/@MessageCreationTime'/></xsl:attribute>"
                                                                                       + "			<xsl:attribute name='ObjectOwner'><xsl:text>ECR</xsl:text></xsl:attribute>"
                                                                                       + "			<xsl:attribute name='ObjectType'><xsl:text>otSendingJournal</xsl:text></xsl:attribute>"
                                                                                       + "			<xsl:attribute name='OriginFileName'><xsl:value-of select='$origFN'></xsl:value-of></xsl:attribute>"
                                                                                       + "			<!--Describe object's header element-->"
                                                                                       + "			<xsl:element name='Object'>"
                                                                                       + "				<xsl:attribute name='MessageId'><xsl:value-of select='//Message/@MessageId'/></xsl:attribute>"
                                                                                       + "				<xsl:attribute name='MessagePackageCount'><xsl:value-of select='//Message/@MessagePackageCount'/></xsl:attribute>"
                                                                                       + "				<xsl:attribute name='MessagePackageNumber'><xsl:value-of select='//Message/@MessagePackageNumber'/></xsl:attribute>"
                                                                                       + "				<xsl:attribute name='MessageCreationTime'><xsl:value-of select='//Message/@MessageCreationTime'/></xsl:attribute>"
                                                                                       + "			</xsl:element>"
                                                                                       + "		</xsl:element>"
                                                                                       + "	</xsl:template>"
                                                                                       + "</xsl:stylesheet>";

                                            using (var _writer = new XmlTextWriter(_tempPath + _xmlSjFilename, Encoding.Default))
                                            {
                                                try
                                                {
                                                    // Схема трансформации
#pragma warning disable 618,612
                                                    var _xslt = new XslTransform();
#pragma warning restore 618,612
                                                    _xslt.Load(new XPathDocument(new StringReader(xsltScript)));

                                                    // Основной файл
                                                    var _xmlSj = new XmlDocument();
                                                    _xmlSj.LoadXml(_outXml.Value.ToString());

                                                    // Добиваем нужными параметрами
                                                    var _argList = new XsltArgumentList();
                                                    _argList.AddParam("mID", "", Guid.NewGuid());
                                                    _argList.AddParam("origFN", "", _xmlSjFilename);

                                                    // Выполняем трансформацию
                                                    _xslt.Transform(_xmlSj, _argList, _writer);

                                                    _writer.Formatting = Formatting.None;
                                                    _writer.Flush();
                                                }
                                                finally
                                                {
                                                    _writer.Close();
                                                }
                                            }
                                            Debug("Создание файла журнала отправок завершено успешно");

                                        }

                                        #endregion

                                        _log.Info(
                                            string.Format(
                                                "Создание файла пакета xml выполнено успешно. Файл: '{0}', PackageId: {1}",
                                                _xmlFilename, _packageId.Value));

                                        break;



                                    }
                                    finally
                                    {
                                        if (_conn.State != ConnectionState.Closed)
                                            _conn.Close();
                                    }

                                }
                            }   

                        // full snapshot - standart
                        case "all":
                            break;

                        default:
                            throw new Exception(string.Format("Некорректное значение параметра 'SnapshotType': '{0}'", SnapshotType));

                    }

        			_log.Info(string.Format("Задание выполнено успешно, key: '{0}'", Key));

        		}
        		catch (SqlException e)
        		{
        			if(e.Number == 50000)
                        _log.Info(string.Format("Предупреждение при выполнении задания, key: '{0}'", Key), e);
                    else
                        _log.Error(string.Format("Ошибка выполнения задания, key: '{0}'", Key), e);
                    return;
        		}
                catch (Exception e)
                {
                    _log.Error(string.Format("Ошибка выполнения задания, key: '{0}'", Key), e);
                }

        	}
        	else
        		// Если объект недоступен, то пишем в лог и выходим
                _log.Warn(string.Format("Задание: {0} заблокировано. Задание неактивно либо доступ запрещен", Key));

        }

    	/// <summary>
        /// Процедура возвращает строку соединения с базой данных ECR_Storage по заданному имени ECRStorageName
        /// </summary>
        /// <param name="ECRStorageName">Системное имя хранилща</param>
        /// <returns>Строка соединения с базой данных</returns>
        private string GetConnectionString(string ECRStorageName)
        {

            var _conn = new SqlConnection();
            try
            {
                var _cmd = new SqlCommand();
                
                _conn.ConnectionString = ConnectionString;
                _cmd.CommandType = CommandType.StoredProcedure;
                _cmd.Connection = _conn;
                _cmd.CommandText = "[ecr].[GetStorageByName]";
                _cmd.Parameters.AddWithValue("SystemName", ECRStorageName);

                var _adapter = new SqlDataAdapter(_cmd);
                var _ds = new DataSet();
                _adapter.Fill(_ds, "StorageData");

                return _ds.Tables["StorageData"].Rows[0]["ConnectionString"].ToString();
            }
            finally
            {
                if (_conn.State != ConnectionState.Closed)
                    _conn.Close();
            }

        }

    }

}
