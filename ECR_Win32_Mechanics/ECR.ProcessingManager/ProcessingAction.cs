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
    /// ����� ������������� ��������� ��� ���������� �������� �������������� � �������� ������ � ��������� ������� ECR
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
        /// ����������� ������ ProcessingAction
        /// </summary>
        /// <param name="key">���� ������� ��������� � �������� ������ � ECR. ���������� ������������� guid</param>
        public ProcessingAction(string key)
        {
            DebugMode = false;
            ConfigureLoggingSubsystem();
            _key = new Guid(key);
        }

        /// <summary>
        /// ����������� ������ ProcessingAction
        /// </summary>
        /// <param name="key">���� ������� ��������� � �������� ������ � ECR. ���������� ������������� guid</param>
        /// <param name="DebugMode">���������� ���������/���������� ������ Debug � ������. DebugMode = true �������� ����� debug</param>
        public ProcessingAction(string key, bool DebugMode)
        {
            this.DebugMode = DebugMode;
            ConfigureLoggingSubsystem();
            _key = new Guid(key);
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
        /// <param name="message">��������� ��� debug</param>
        /// <param name="e">Exception ��� debug</param>
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
        /// �������� ���������� ����� debug � ������
        /// </summary>
        public bool DebugMode { get; set; }

        /// <summary>
        /// �������� ���������� ���� ������� ������������ ����� xml (���������� ������������� guid)
        /// </summary>
        public string Key
        {
            get
            {
                return _key.ToString();
            }
        }

        /// <summary>
        /// �������� ��������� ��������� ����������� ������� ������������ ����� xml
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
        /// �������� ��������� ������� ���������� ��� ������������ ��������� � ��������� ECR
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
        /// ����� ��������� ��������� ������� ������������ ����� xml � "��������"
        /// </summary>
        public void Enable()
        {
            _enabled = true;
        }

        /// <summary>
        /// ����� ��������� ��������� ������� ������������ ����� xml � "����������"
        /// </summary>
        public void Disable()
        {
            _enabled = false;
        }

        /// <summary>
        /// �������� ���������� ��������� ��� �������� ��� ��������
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
        /// ��� ���������� ��� ����������� ��������������
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
                throw new Exception(string.Format("����������� ����������� ���� ��������: '{0}'", value));
            }
        }

        /// <summary>
        /// ������������� ���������� ��������������
        /// </summary>
        public int ContainerId { get; set; }

        /// <summary>
        /// �������� ���������� ���� � �������� ����� � ������� ��� �������������� � �������� � ������� ECR;
        /// � ������ ���������� ����� ���� ������� � ��� ������������ exception;
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
                    throw new Exception(string.Format("������ ������� � �����: '{0}'", value));
                _source = value;
            }
        }

        /// <summary>
        /// �������� ���������� ����� ����� ����� �� �������� �����
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
        /// �������� ���������� ���� � ��������� ����� � ������� ��� ������������ ����� xml;
        /// � ������ ���������� ����� ���� ������� � ��� ������������ exception;
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
                        throw new Exception(string.Format("������ ������� � �����: '{0}'", value));
                }
                _backupTo = value;
            }
        }

        /// <summary>
        /// �������� ���������� ����� �� ��������� ��������������, �������� �� ���������, � �������� ecr.Entity ��� ��������� ����������
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
        /// �������� ���������� ����� �� ��������� ��������� ������ (ecr.Entity) � ��������� ECR
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
        /// ������� ���������� ����� �� ����������� �������� ������� ��������� ������� ��� ���������/�������� � ECR
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
		/// ����� ��������� ������� ��������� � �������� ������ � ��������� ECR
		/// </summary>
        public void Execute()
        {

            _log.Info(string.Format("������ �������... Key: '{0}', ItemType: '{1}', , Source: '{2}', Mask: '{3}', Save Originals: {4}", Key, ItemType, Source, Mask, SaveOriginals));

			// �������� �� ����������� �������
            if (!Enabled)
            {
                // ���� ������ ����������, �� ����� � ��� � �������
                _log.Warn(string.Format("�������: {0} �������������. ������� ��������� ���� ������ ��������", Key));
                return;
            }

            Debug("����������� ����� ��� ������ ������ � ��������...");
            var _pathErrors = ConfigurationManager.AppSettings.Get("ECR.ProcessingManager.PathErrors");
            if (_pathErrors.Length > 0)
            {
                if (!Directory.Exists(_pathErrors))
                {
                    _log.Error(string.Format("������ ������� � �����: ' {0}'", _pathErrors));
                    return;
                }
            }

            #region ������������� ���������
            var _processed = 0;
            var _success = 0;
            var _errors = 0;
            var _warnings = 0;
            #endregion

            Debug("��������� ������ ������...");

            // ����������� ����� ��� ��������� �������������� �� <file_name>.ecr$
            var di = new DirectoryInfo(Source);

            // ��������� ���� �� ����������������� �� �� ����������� �����
            var _files = di.GetFiles("*.ecr$");

            // ���� ������ ���, �������� �����
            if (_files.Length == 0)
            {
                Debug("��������� ������ ����� ������...");
                // ��������� ����� ����� � ���� *[_*].*
                var _inputMask = Mask.Replace("[ext]", "*");
                _inputMask = _inputMask.Replace(_keyTokens[0], "*");
                _inputMask = _inputMask.Replace(_keyTokens[1], "*");
                _inputMask = _inputMask.Replace(_numberToken, "*");
                // ����������� �����
                foreach (var fileInfo in di.GetFiles(_inputMask))
                    fileInfo.MoveTo(fileInfo.FullName + ".ecr$");
                // �������� ����������������� �����
                _files = di.GetFiles("*.ecr$");
            }

            // ���������� ������������ ���������� ��������� ������� �������� � ��������� ������
            IECRProcessor _processor;
            // ��� ���������� ���������� ����� ��� ������� �������������� ��������� � ������������ ����������
            switch (ContainerType)
            {
                case _ctGraphical:
                    _processor = new GraphicsProcessor(ContainerId);
                    break;
                case _ctTextDefault:
                    _processor = new TextProcessor(ContainerId);
                    break;
                default:
                    _log.Error(string.Format("����������� ��� ���������� ������: '{0}'", ContainerType));
                    return;
            }

            // ���������� ������ ECRManagedDataReader
            Debug("����������� ������� ECRManagedDataReader...");
            var _ecrDataReader = new ECRManagedDataReader(ConfigurationManager.AppSettings.Get("ECR_Config.BaseServerName"),
                    Convert.ToInt32(ConfigurationManager.AppSettings.Get("ECR_Config.ConnectionTimeout")),
                    Convert.ToInt32(ConfigurationManager.AppSettings.Get("ECR_Config.CommandTimeout")),
                    DebugMode);
            var _ecrDataWriter = new ECRManagedDataWriter(ConfigurationManager.AppSettings.Get("ECR_Config.BaseServerName"),
                    Convert.ToInt32(ConfigurationManager.AppSettings.Get("ECR_Config.ConnectionTimeout")),
                    Convert.ToInt32(ConfigurationManager.AppSettings.Get("ECR_Config.CommandTimeout")),
                    DebugMode);

            // ���������� �������� �� ���������������� ���� ECR
            Debug("����������� ������� �������������� ��������...");
            var _dsEntity = _ecrDataReader.GetEntity(ItemType);

            // ���������� ������ ��������� �������������-����������� ��� �������� � ��������� ������ ItemType
            Debug("����������� ������ �������� ��������...");
            var _dsChildViews = _ecrDataReader.GetViewListByEntity(ItemType, true);

            Debug("��������� ������...");
            foreach (var _file in _files)
            {
                try
                {

                    Debug(string.Format("�������������� ����: '{0}'...", _file.FullName));
                    _processed++;

                    // ����������� ItemKey, ItemNumber
                    Debug("����������� ���������� ������...");

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
                            // �� �������� ������������ ������ ���� ������� �������������, �� ������ ����� �������� ��� "_*"!
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
                                string.Format("������������ ��� ����� ��� ��������������� ��������. ����: '{0}', ��������: '{1}'", _file.FullName, ItemType));
                    }

                    // ������� ���������� ������� �� itemKey
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

                    Debug(string.Format("�������� ������, ItemKey: '{0}', ItemNumber: {1}", itemKey, itemNumber));

                    // � ����������� �� ���� ���������� �������������� �������� ������ � Unicode ��� � Base64 � ��������� ��������������
                    Debug(string.Format("������ ������ �� �����: '{0}'", _file.FullName));

                    object _buffer = null;

                    #region ������������ ������ �� �����

                    // ��� ���������� ���������� ��� ��������� ������ �� �����
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

                    // �������� ������ � �������� �������������� ������.

                    Debug(string.Format("�������� ������ � ��������� ECR. ����: '{0}'", _file.FullName));
                    
                    var _error = string.Empty;
                    string _check_params;
                    
                    if (_dsEntity.Tables["EntityData"].Rows[0]["Params"] == DBNull.Value)
                        _check_params = null;
                    else
                        _check_params = (string)_dsEntity.Tables["EntityData"].Rows[0]["Params"];
                    
                    //    �������� ������������ ���������� ���������������� ������ (������� ����� � �� ����), ��������� � ����������.
                    //    �������� ������������ ����� �������� ������ �� ������������ ����������, �������� � ����������.
                    if(!_processor.LoadObject(_buffer, _checkProperties, _defaultProcessing, _check_params, ref _error))
                    {
                        // ������� ����� � ����� ��������� ������
                        // TODO: ������� �������� �� ���������� ����!
                        // TODO: ������� ��������� ����������� ����� log4net (SMTPAppender)
                        _log.Warn(string.Format("�������� ������� �� ��������! �������� ������: '{0}'. ����: '{1}'", _error, _file.FullName));
                        if (_pathErrors.Length > 0)
                        {
                            Debug(string.Format("����������� ����� � ����� ��������� ������: '{0}'", _file.Name));
                            // ��� �������� ����� �������� ���������� ".ecr$"
                            _file.CopyTo(_pathErrors + ItemType + "\\" + (_file.Name).Replace(".ecr$", string.Empty), true);
                            Debug(string.Format("���� ���������� � ����� ��������� ������: '{0}'", _file.Name));
                        }
                        _warnings++;
                    }
                    else
                    {

                        // TODO: ����� ������� ���� ������ ����������� ����� ���������� �������� ������� �������� � ��������� ECR � �������������� ItemsSummary
                        // TODO: ����������� �� �������� ��������� overwrite ������������ �������� � � ������ overwite=false � �������� ��� ���������� ���������� ���� � ����� global 
                        if(!Overwrite)
                        {
                        }

                        // �������� ������� ������ � ���������� ��� ��������
                        byte[] _base = _processor.GetBase();
                        var _operation = _base.Length > 0 ? "I" : "D";

                        // ������ ���������� � ������� ������� ECR_Config.ecr.ItemsSummary ��� ����� ����������
                        // TODO: ����� ������� �� �������� "I" (insert) ������� ������ � ������� ItemsSummary
                        // TODO: ������������ ����� �������� ��������� ECR_Config.ecr.CheckItemExists
                        // TODO: � ��������� ��� ������ �� �� ������������� ��������, � ����� ��������� �������� �� null (~ �������� ������� - "C")
                        _ecrDataWriter.UpdateItemSummary(itemKey, itemNumber, ItemType, _operation);

                        // �������� �������� ������������� (���������) � ���� ECR_Storage.
                        // ���� SaveOriginals �� �������� ������������ � �� ���������� � ���������� ��������� � ���� ECR_Config.
                        // ��� "����� ����������������" ����, ��������� ��� �������� ������������� ������� ������.
                        if (SaveOriginals)
                        {
                            Debug("�������� ������ ��������� � ��������� ECR. ����: '" + _file.FullName + "'");
                            _ecrDataWriter.TransferEntity(itemKey, itemNumber, _base, ItemType);
                            Debug(string.Format("������ ��������� �������� � ��������� ECR. ����: '{0}'", _file.FullName));
                        }

                        // �������� ������� ������� � ��������� ��������
                        Debug(string.Format("�������� ������ ������������� � ��������� ECR. ����: '{0}'", _file.FullName));
                        if (_dsChildViews.Tables["ViewList"].Rows.Count > 0)
                        {
                            // �������� � �������� � ���� ECR_Storage �������������-�������� � ����� �� �������� ������ �� ECR_Config
                            var _etr = _dsChildViews.Tables["ViewList"].Rows.GetEnumerator();
                            while (_etr.MoveNext())
                            {
                                var _row = (DataRow) _etr.Current;
                                Debug(string.Format("�������� ������ � ��������� ECR. �������������: '{0}'. ����: '{1}'", _row["SystemName"], _file.FullName));
                                _ecrDataWriter.TransferView(
                                    itemKey,
                                    itemNumber,
                                    _operation == "D" ? _base : _processor.CreateView(_row["SystemName"].ToString(), _row["Params"].ToString()),
                                    _row["SystemName"].ToString()
                                    );
                                Debug(string.Format("������ ������������� �������� � ��������� ECR. �������������: '{0}'. ����: '{1}'", _row["SystemName"], _file.FullName));
                            }
                        }

                        _log.Info(string.Format("���� ������� ���������: '{0}'", _file.FullName));

                        // ���� ����� ���� ��� ��������������� �����������, �� ������� �������� ����.
                        // ������ ���������� ������� ��������������.
                        if (BackupTo.Length > 0)
                        {
                            Debug(string.Format("����������� ����� '{0}' � �����: '{1}'...", _file.Name.Replace("ecr$", string.Empty), BackupTo + ItemType + "\\"));
                            _file.CopyTo(BackupTo + ItemType + "\\" + _file.Name.Replace("ecr$", string.Empty), true);
                            Debug(string.Format("���� '{0}' ���������� � �����: '{1}'", _file.Name.Replace("ecr$", string.Empty), BackupTo + ItemType + "\\"));
                        }

                        _success++;
                    
                    }
                    
                }
                catch (Exception e)
                {
                    _log.Error(string.Format("������ ��� ��������� �����: '{0}'", _file.FullName), e);
                    if (_pathErrors.Length > 0)
                    {
                        Debug(string.Format("����������� ����� � ����� ��������� ������: '{0}'", _file.Name));
                        // ��� �������� ����� �������� ���������� ".ecr$"
                        _file.CopyTo(_pathErrors + ItemType + "\\" + (_file.Name).Replace(".ecr$", string.Empty), true);
                        Debug(string.Format("���� ���������� � ����� ��������� ������: '{0}'", _file.Name));
                    }
                    _errors++;
                }
                finally
                {
                    // ������� ������������ ����
                    Debug(string.Format("�������� �����: '{0}'", _file.FullName));
                    _file.Delete();
                    Debug(string.Format("���� ������: '{0}'", _file.FullName));
                }

            }   // foreach

            _log.Info(string.Format("���������� {0} ������, {1} - �������, {2} - � ��������, {3} - � ����������������.", _processed, _success, _errors, _warnings));

        }

        /// <summary>
        /// ��������� ����������� ������ Unicode � ������ base64
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