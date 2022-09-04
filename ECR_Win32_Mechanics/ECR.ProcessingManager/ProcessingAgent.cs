using System;
using log4net;

namespace ECR.ProcessingManager
{
    /// <summary>
    ///  ����� ������������� ��������� ��� ���������� ��������� ������������ ������ xml �� �������� ������ �������� �������� ��������
    /// </summary>
    public class ProcessingAgent
    {

        private readonly ExecuteActionsConfigSection _section;

        #region Logging objects and variables

        private readonly static ILog _log = LogManager.GetLogger(typeof(ProcessingAgent));

        #endregion

        #region ProcessingAgent class constructors

        /// <summary>
        /// ����������� ������ ProcessingAgent
        /// </summary>
        public ProcessingAgent()
        {
            DebugMode = false;
            ConfigureLoggingSubsystem();
            _section = (ExecuteActionsConfigSection)ProcessingManager._configuration.GetSection("execute");
        }

        /// <summary>
        /// ����������� ������ ProcessingAgent
        /// </summary>
        /// <param name="DebugMode">���������� ���������/���������� ������ debug � ������. DebugMode = true �������� ����� debug</param>
        public ProcessingAgent(bool DebugMode)
        {
            this.DebugMode = DebugMode;
            ConfigureLoggingSubsystem();
            _section = (ExecuteActionsConfigSection)ProcessingManager._configuration.GetSection("execute");
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
                var _action = new ProcessingAction(_section.ActionItems[index].Key, DebugMode)
                {
                    Enabled = Convert.ToBoolean(_section.ActionItems[index].Enabled),
                    ItemType = _section.ActionItems[index].ItemType,
                    ContainerId = _section.ActionItems[index].ContainerId,
                    ContainerType = _section.ActionItems[index].ContainerType,
                    Source = _section.ActionItems[index].Source,
                    Mask = _section.ActionItems[index].Mask,
                    BackupTo = _section.ActionItems[index].BackupTo,
                    DefaultProcessing = Convert.ToBoolean(_section.ActionItems[index].DefaultProcessing),
                    SaveOriginals = Convert.ToBoolean(_section.ActionItems[index].SaveOriginals),
                    CheckProperties = Convert.ToBoolean(_section.ActionItems[index].CheckProperties)
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
