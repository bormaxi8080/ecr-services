using System;
using log4net;

namespace ECR.FilesExtractor
{
	/// <summary>
	///  ����� ������������� ��������� ��� ���������� �������� �� xml (������ base64) � �������� ���
	/// </summary>
	class FilesExtractorAgent
	{

		private readonly ExecuteActionsConfigSection _section;

		#region Logging objects and variables

		private readonly static ILog _log = LogManager.GetLogger(typeof(FilesExtractorAgent));

		#endregion

		#region FilesExtractorAgent class constructors

		/// <summary>
		/// ����������� ������ FilesExtractorAgent
		/// </summary>
		public FilesExtractorAgent()
		{
			DebugMode = false;
			ConfigureLoggingSubsystem();
			_section = (ExecuteActionsConfigSection)FilesExtractorManager._configuration.GetSection("execute");
		}

		/// <summary>
		/// ����������� ������ FilesExtractorAgent
		/// </summary>
		/// <param name="DebugMode">���������� ���������/���������� ������ debug � ������. DebugMode = true �������� ����� debug</param>
		public FilesExtractorAgent(bool DebugMode)
		{
			this.DebugMode = DebugMode;
			ConfigureLoggingSubsystem();
			_section = (ExecuteActionsConfigSection)FilesExtractorManager._configuration.GetSection("execute");
		}

		#endregion

		#region Logging subsystem functions

		/// <summary>
		/// ���������������� ���������� ������������
		/// </summary>
		private static void ConfigureLoggingSubsystem()
		{
			//DOMConfigurator.Configure();            
		}

		/// <summary>
		/// ������ ������ ������ � Log.Debug() � ��������� ������ �������
		/// </summary>
		/// <param name="message">��������� ��� debug</param>
// ReSharper disable UnusedMember.Local
		private void Debug(string message)
// ReSharper restore UnusedMember.Local
		{
			if (DebugMode)
				_log.Debug(message);
		}

		/// <summary>
		/// ������ ������ � ������ Log.Debug() � ��������� ������ ������� � ��������� Exception
		/// </summary>
		/// <param name="message">��������� ��� Debug</param>
		/// <param name="e">Exception ��� debug</param>
// ReSharper disable UnusedMember.Local
		private void Debug(string message, Exception e)
// ReSharper restore UnusedMember.Local
		{
			if (DebugMode)
				_log.Debug(message, e);
		}

		#endregion

		/// <summary>
		/// �������� ���������� ���������/���������� ������ debug � ������
		/// </summary>
		public bool DebugMode { get; set; }

		/// <summary>
		/// ����� ��������� ������� � ������� index �� ����������
		/// </summary>
		/// <param name="index">������ �������</param>
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
				_log.Error(string.Format("������ ���������� �������: {0}", index), e);
			}
		}

		/// <summary>
		///  ����� ��������� ��� ��������� ������� �� ����������
		/// </summary>
		public void Execute()
		{
			// ������ ������ �������
			if (_section.ActionItems.Count > 0)
			{
				for (var i = 0; i < _section.ActionItems.Count; i++)
					Execute(i);
			}
			else
                _log.Warn("�� ������ ������� ������� ����������");
		}

		/// <summary>
		/// �������� ���������� ���������� �������
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
