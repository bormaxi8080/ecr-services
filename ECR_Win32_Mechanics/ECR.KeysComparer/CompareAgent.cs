using System;
using System.Configuration;
using log4net;

namespace ECR.KeysComparer
{

    /// <summary>
    ///  Класс предоставляет интерфейс для управления заданиями сопоставления файлов по ключам в загруженной конфигурации
    /// </summary>
    public class CompareAgent
    {

        private readonly ExecuteActionsConfigSection _section;

        #region Logging objects and variables

        private readonly static ILog _log = LogManager.GetLogger(typeof(CompareAgent));

        #endregion

        #region CompareAgent class constructors

        /// <summary>
        /// Конструктор класса CompareAgent
        /// </summary>
        public CompareAgent()
        {
            DebugMode = false;
            ConfigureLoggingSubsystem();
            _section = (ExecuteActionsConfigSection)ConfigurationManager.GetSection("execute");
        }

        /// <summary>
        /// Конструктор класса CompareAgent
        /// </summary>
        /// <param name="DebugMode">Определяет включение/выключение режима debug в классе. DebugMode = true включает режим debug</param>
        public CompareAgent(bool DebugMode)
        {
            this.DebugMode = DebugMode;
            ConfigureLoggingSubsystem();
            _section = (ExecuteActionsConfigSection)ConfigurationManager.GetSection("execute");
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
// ReSharper disable UnusedPrivateMember
        private void Debug(string message, Exception e)
// ReSharper restore UnusedPrivateMember
        {
            if (DebugMode)
                _log.Debug(message, e);
        }

        #endregion

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
                var _action = new CompareAction(_section.ActionItems[index].Key, DebugMode)
                {
                    Enabled = Convert.ToBoolean(_section.ActionItems[index].Enabled),
                    Source = _section.ActionItems[index].Source,
                    SourceMask = _section.ActionItems[index].SourceMask,
                    Destination = _section.ActionItems[index].Destination,
                    ArchivePath = _section.ActionItems[index].Archive,
                    ConflictsPath = _section.ActionItems[index].Conflicts,
                    CompareMask = _section.ActionItems[index].CompareMask,
                    DataBinding = _section.ActionItems[index].DataBinding,
                    Overwrite = _section.ActionItems[index].Overwrite,
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
