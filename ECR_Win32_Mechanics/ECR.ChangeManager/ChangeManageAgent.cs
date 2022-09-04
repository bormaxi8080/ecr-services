using System;
using log4net;

namespace ECR.ChangeManager
{

    /// <summary>
    /// Класс предоставляет интерфейс для управления заданиями формирования файлов xml и файлов нативных форматов из таблиц сборщика изменений системы ECR;
    /// </summary>
    class ChangeManageAgent
    {

        #region Logging objects and variables

        private readonly static ILog _log = LogManager.GetLogger(typeof(ChangeManageAgent));

        #endregion

        private readonly string _connectionString = string.Empty;
        private readonly int _commandTimeout = 600;
        private readonly ExecuteActionsConfigSection _section;
        
        #region ChangeManageAgent class constructors

        /// <summary>
        /// Конструктор класса ChangeManageAgent
        /// </summary>
        /// <param name="ConnectionString">Строка соединения с конфигурационной базой данных ECR_Config</param>
        /// <param name="CommandTimeout">Величина CommandTimeout для выборки данных из хранилищ ECR_Storage</param>
        public ChangeManageAgent(string ConnectionString, int CommandTimeout)
        {
            DebugMode = false;
            _connectionString = ConnectionString;
            _commandTimeout = CommandTimeout;
            ConfigureLoggingSubsystem();
			_section = (ExecuteActionsConfigSection)ChangeManager._configuration.GetSection("execute");
        }

        /// <summary>
        /// Конструктор класса ChangeManageAgent
        /// </summary>
        /// <param name="ConnectionString">Строка соединения с конфигурационной базой данных ECR_Config</param>
        /// <param name="CommandTimeout">Величина CommandTimeout для выборки данных из хранилищ ECR_Storage</param>
        /// <param name="DebugMode">Определяет включение/выключение режима debug в классе. DebugMode = true включает режим debug</param>
        public ChangeManageAgent(string ConnectionString, int CommandTimeout, bool DebugMode)
        {
            this.DebugMode = DebugMode;
            _connectionString = ConnectionString;
            _commandTimeout = CommandTimeout;
            ConfigureLoggingSubsystem();
			_section = (ExecuteActionsConfigSection)ChangeManager._configuration.GetSection("execute");
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
        /// <param name="message">Сообщение для Debug</param>
        /// <param name="e">Exception для debug</param>
        private void Debug(string message, Exception e)
        {
            if (DebugMode)
                _log.Debug(message, e);
        }

        #endregion

        /// <summary>
        /// Свойство возвращает строку соединения с базой данных ECR_Config
        /// </summary>
        public string ConnectionString
        {
            get { return _connectionString; }
        }
        
        /// <summary>
        /// Свойство возвращает величину CommandTimeout для выборки данных из хранилищ ECR_Storage
        /// </summary>
        public int CommandTimeout
        {
            get { return _commandTimeout; }
        }

        /// <summary>
        /// Свойство определяет включение/выключение режима debug в классе
        /// </summary>
        public bool DebugMode { get; set; }

        /// <summary>
        /// Метод запускает задание с номером index на выполнение
        /// </summary>
        /// <param name="index">Индекс задания</param>
        public void Execute(int index)
        {
            try
            {
            	var _action = new ChangeManageAction(_section.ActionItems[index].Key, DebugMode)
            	              	{
            	              		Enabled = Convert.ToBoolean(_section.ActionItems[index].Enabled),
            	              		StorageName = _section.ActionItems[index].StorageName,
            	              		ChangeType = _section.ActionItems[index].ChangeType,
            	              		SnapshotType = _section.ActionItems[index].SnapshotType,
            	              		Destination = _section.ActionItems[index].Destination,
            	              		DestinationSj = _section.ActionItems[index].DestinationSJ,
            	              		PackageSize = _section.ActionItems[index].PackageSize,
            	              		ConnectionString = ConnectionString,
            	              		CommandTimeout = CommandTimeout
            	              	};
                _action.Execute();
            }
            catch (Exception e)
            {
                _log.Error(string.Format("Ошибка выполнения задания: {0}", index), e);
            }
        }

        /// <summary>
        ///  Метод запускает все доступные задания на выполнение
        /// </summary>
        public void Execute()
        {
            // Запуск списка заданий
            if (_section.ActionItems.Count > 0)
            {
                for (var i = 0; i < _section.ActionItems.Count; i++)
                    Execute(i);
            }
            else
                _log.Warn("Не заданы задания запуска приложения");
        }

        /// <summary>
        /// Свойство возвращает количество заданий
        /// </summary>
        public int Count
        {
            get
            {
                return _section.ActionItems.Count;
            }
        }

    }

}
