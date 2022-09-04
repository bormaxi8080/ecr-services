using System;
using log4net;

namespace ECR.ChangeManager
{

    /// <summary>
    /// ����� ������������� ��������� ��� ���������� ��������� ������������ ������ xml � ������ �������� �������� �� ������ �������� ��������� ������� ECR;
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
        /// ����������� ������ ChangeManageAgent
        /// </summary>
        /// <param name="ConnectionString">������ ���������� � ���������������� ����� ������ ECR_Config</param>
        /// <param name="CommandTimeout">�������� CommandTimeout ��� ������� ������ �� �������� ECR_Storage</param>
        public ChangeManageAgent(string ConnectionString, int CommandTimeout)
        {
            DebugMode = false;
            _connectionString = ConnectionString;
            _commandTimeout = CommandTimeout;
            ConfigureLoggingSubsystem();
			_section = (ExecuteActionsConfigSection)ChangeManager._configuration.GetSection("execute");
        }

        /// <summary>
        /// ����������� ������ ChangeManageAgent
        /// </summary>
        /// <param name="ConnectionString">������ ���������� � ���������������� ����� ������ ECR_Config</param>
        /// <param name="CommandTimeout">�������� CommandTimeout ��� ������� ������ �� �������� ECR_Storage</param>
        /// <param name="DebugMode">���������� ���������/���������� ������ debug � ������. DebugMode = true �������� ����� debug</param>
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
        private void Debug(string message)
        {
            if (DebugMode)
                _log.Debug(message);
        }

        /// <summary>
        /// ������ ������ � ������ Log.Debug() � ��������� ������ ������� � ��������� Exception
        /// </summary>
        /// <param name="message">��������� ��� Debug</param>
        /// <param name="e">Exception ��� debug</param>
        private void Debug(string message, Exception e)
        {
            if (DebugMode)
                _log.Debug(message, e);
        }

        #endregion

        /// <summary>
        /// �������� ���������� ������ ���������� � ����� ������ ECR_Config
        /// </summary>
        public string ConnectionString
        {
            get { return _connectionString; }
        }
        
        /// <summary>
        /// �������� ���������� �������� CommandTimeout ��� ������� ������ �� �������� ECR_Storage
        /// </summary>
        public int CommandTimeout
        {
            get { return _commandTimeout; }
        }

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
