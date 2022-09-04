using System;
using System.Configuration;
using log4net;

namespace ECR.KeysComparer
{

    /// <summary>
    ///  ����� ������������� ��������� ��� ���������� ��������� ������������� ������ �� ������ � ����������� ������������
    /// </summary>
    public class CompareAgent
    {

        private readonly ExecuteActionsConfigSection _section;

        #region Logging objects and variables

        private readonly static ILog _log = LogManager.GetLogger(typeof(CompareAgent));

        #endregion

        #region CompareAgent class constructors

        /// <summary>
        /// ����������� ������ CompareAgent
        /// </summary>
        public CompareAgent()
        {
            DebugMode = false;
            ConfigureLoggingSubsystem();
            _section = (ExecuteActionsConfigSection)ConfigurationManager.GetSection("execute");
        }

        /// <summary>
        /// ����������� ������ CompareAgent
        /// </summary>
        /// <param name="DebugMode">���������� ���������/���������� ������ debug � ������. DebugMode = true �������� ����� debug</param>
        public CompareAgent(bool DebugMode)
        {
            this.DebugMode = DebugMode;
            ConfigureLoggingSubsystem();
            _section = (ExecuteActionsConfigSection)ConfigurationManager.GetSection("execute");
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
// ReSharper disable UnusedPrivateMember
        private void Debug(string message, Exception e)
// ReSharper restore UnusedPrivateMember
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
