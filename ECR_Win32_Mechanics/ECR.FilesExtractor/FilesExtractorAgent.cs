using System;
using log4net;

namespace ECR.FilesExtractor
{
	/// <summary>
	///  Класс предоставляет интерфейс для извлечения картинок из xml (формат base64) в бинарный вид
	/// </summary>
	class FilesExtractorAgent
	{

		private readonly ExecuteActionsConfigSection _section;

		#region Logging objects and variables

		private readonly static ILog _log = LogManager.GetLogger(typeof(FilesExtractorAgent));

		#endregion

		#region FilesExtractorAgent class constructors

		/// <summary>
		/// Конструктор класса FilesExtractorAgent
		/// </summary>
		public FilesExtractorAgent()
		{
			DebugMode = false;
			ConfigureLoggingSubsystem();
			_section = (ExecuteActionsConfigSection)FilesExtractorManager._configuration.GetSection("execute");
		}

		/// <summary>
		/// Конструктор класса FilesExtractorAgent
		/// </summary>
		/// <param name="DebugMode">Определяет включение/выключение режима debug в классе. DebugMode = true включает режим debug</param>
		public FilesExtractorAgent(bool DebugMode)
		{
			this.DebugMode = DebugMode;
			ConfigureLoggingSubsystem();
			_section = (ExecuteActionsConfigSection)FilesExtractorManager._configuration.GetSection("execute");
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
// ReSharper disable UnusedMember.Local
		private void Debug(string message)
// ReSharper restore UnusedMember.Local
		{
			if (DebugMode)
				_log.Debug(message);
		}

		/// <summary>
		/// Запись данных в режиме Log.Debug() с проверкой режима отладки и описанием Exception
		/// </summary>
		/// <param name="message">Сообщение для Debug</param>
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
				var _action = new FilesExtractorAction(_section.ActionItems[index].Key, DebugMode)
				{
					Enabled = Convert.ToBoolean(_section.ActionItems[index].Enabled),
					Source = _section.ActionItems[index].Source,
					Destination = _section.ActionItems[index].Destination,
					SourceMask = _section.ActionItems[index].SourceMask,
                    DestinationMask = _section.ActionItems[index].DestinationMask
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
