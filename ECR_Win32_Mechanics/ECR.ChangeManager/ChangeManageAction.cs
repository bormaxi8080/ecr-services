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
    /// ����� ������� ������� ������������ ����� ������ �� ���������� � ���� xml
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
        /// ����������� ������ ChangeManageAction
        /// </summary>
        /// <param name="key">���� �������. ���������� ������������� guid</param>
        public ChangeManageAction(string key)
        {
            DebugMode = false;
            ConfigureLoggingSubsystem();
            _key = new Guid(key);
            Enabled = true;
        }

        /// <summary>
        /// ����������� ������ ChangeManageAction
        /// </summary>
        /// <param name="key">���� �������. ���������� ������������� guid</param>
        /// <param name="DebugMode">���������� ���������/���������� ������ Debug � ������. DebugMode = true �������� ����� debug</param>
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
        /// ���������������� ���������� ������������
        /// </summary>
        private static void ConfigureLoggingSubsystem()
        {
            //DOMConfigurator.Configure();
        }

        /// <summary>
        /// ������ ������ ������ � Log.Debug() � ��������� ������ �������
        /// </summary>
        /// <param name="Message">��������� ��� debug</param>
        private void Debug(string Message)
        {
            if (DebugMode)
                _log.Debug(Message);
        }

        /// <summary>
        /// ������ ������ � ������ Log.Debug() � ��������� ������ ������� � ��������� Exception
        /// </summary>
        /// <param name="Message">��������� ��� debug</param>
        /// <param name="e">Exception ��� debug</param>
// ReSharper disable UnusedMember.Local
        private void Debug(string Message, Exception e)
// ReSharper restore UnusedMember.Local
        {
            if (DebugMode)
                _log.Debug(Message, e);
        }

        #endregion

        /// <summary>
        /// �������� ���������� ���� ������� (���������� ������������� guid)
        /// </summary>
        public string Key
        {
            get
            {
                return _key.ToString();
            }
        }

        /// <summary>
        /// �������� ��������� ��������� ����������� �������
        /// </summary>
        public bool Enabled { get; set; }

        /// <summary>
        /// ����� ��������� ��������� ������� � "��������"
        /// </summary>
        public void Enable()
        {
            Enabled = true;
        }

        /// <summary>
        /// ����� ��������� ��������� ������� � "����������"
        /// </summary>
        public void Disable()
        {
            Enabled = false;
        }

        /// <summary>
        /// �������� ���������� ����� debug � ������
        /// </summary>
        public bool DebugMode { get; set; }

        /// <summary>
        /// �������� ���������� ������ ���������� � ���������������� ����� ������ ECR_Config
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
        /// �������� ���������� ��������� ��� ��������� ��������� �������� ��� ��������
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
        /// �������� ���������� ��� �������� (Entity/View)
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
                        throw new Exception(string.Format("������������ �������� ��������� 'ChangeType': '{0}'", value));
                }
            }
        }

        /// <summary>
        /// �������� ���������� ��� �������� ������ (all - ������ ������� ������, changes - ������ ���������)
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
                        throw new Exception(string.Format("������������ �������� ��������� 'SnapshotType': '{0}'", value));
                }
            }
        }

        /// <summary>
        /// �������� ���������� ���� � ��������� ����� ��� ���������� ������;
        /// � ������ ���������� ����� ���� ������� � ��� ������������ exception;
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
                    throw new Exception(string.Format("������ ������� � �����: '{0}'", value));
                _destination = value;
            }
        }

		/// <summary>
		/// �������� ���������� ���� � ��������� ����� ��� ���������� ������ ������� ��������;
		/// � ������ ���������� ����� ���� ������� � ��� ������������ exception;
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
                        throw new Exception(string.Format("������ ������� � �����: '{0}'", value));
                }
			    _destinationSj = value;
			}
		}

        /// <summary>
        /// �������� ���������� �������� CommandTimeout ��� ������� �� �������� ECR_Storage
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
                    throw new Exception(string.Format("����������� �������� ��������� 'CommandTimeout': {0}", value));
                _commandTimeout = value;
            }
        }

        /// <summary>
        /// �������� ���������� ���������� ������� � ������ ��� ������������� �������� � ������� Xml
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
                    throw new Exception(string.Format("������������ �������� ��������� PackageSize: {0}", value));
                _packageSize = value;  
            }
        }

        /// <summary>
        /// ����� ��������� ������� �������� ����������� �������� � ��������� �����
        /// </summary>
		public void Execute()
        {

        	_log.Info(
        		string.Format(
                    "������ �������... Key:  {0}, Storage: '{1}', SnapshotType: '{2}', Change Type: '{3}', Destination: '{4}', Package Size: {5}",
        			Key, StorageName, SnapshotType, ChangeType, Destination, PackageSize));

        	// �������� �� ����������� �������
        	if (Enabled)
        	{

        		try
        		{

                    // ����������� TempPath
                    var _tempPath = ConfigurationManager.AppSettings.Get("ECR.ChangeManager.TempPath");
                    if (_tempPath.Length == 0)
                        _tempPath = Path.GetTempPath();

                    // ����������� �������� ����������-����� �������� �������� ��������
                    var _writeSJ = Convert.ToBoolean(ConfigurationManager.AppSettings.Get("ECR.ChangeManager.WriteSJ"));

                    Debug("����������� � ������� �����...");

                    // �������� ������� ������ <file_name>.ecrchg$ � temp
                    var di = new DirectoryInfo(_tempPath);
                    
                    // ... �������� ����� ������
                    var _files = di.GetFiles(ChangeType + "_*_" + StorageName + ".xml.ecrchg$");
                    if (_files.Length > 0)
                    {
                        for (var i = 0; i < _files.Length; i++)
                        {
                            File.Copy(_tempPath + _files[i].Name, Destination + _files[i].Name.Replace(".ecrchg$", string.Empty), true);
                            Debug(string.Format("���� '{0}' ���������� � ����� '{1}'", _files[i].Name.Replace(".ecrchg$", string.Empty), Destination));
                            File.Delete(_tempPath + _files[i].Name);
                            Debug(string.Format("���� '{0}' ������", _files[i].Name.Replace(".ecrchg$", string.Empty)));
                        }
                    }
                    
                    // ... ������� ��������
                    if (_writeSJ)
                    {
                        // "otSendingJournal_ECR_{0}_{1}.xml.ecrchg$"
                        _files = di.GetFiles("otSendingJournal_ECR_*_" + StorageName + ".xml.ecrchg$");
                        if (_files.Length > 0)
                        {
                            for (var i = 0; i < _files.Length; i++)
                            {
                                File.Copy(_tempPath + _files[i].Name, DestinationSj + _files[i].Name.Replace(".ecrchg$", string.Empty), true);
                                Debug(string.Format("���� '{0}' ���������� � ����� '{1}'", _files[i].Name.Replace(".ecrchg$", string.Empty), Destination));
                                File.Delete(_tempPath + _files[i].Name);
                                Debug(string.Format("���� '{0}' ������", _files[i].Name.Replace(".ecrchg$", string.Empty)));
                            }
                        }
                    }

        		    // ���������� ������ ���������� � ����� ������ ECR_Storage<i> �� ����� ��������� StorageName
        			Debug("����������� ������ ���������� � ����� ������ ECR_Storage...");
        			var _storageCnnStr = GetConnectionString(StorageName);

        			Debug("�������� ������ xml...");

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

                                        Debug("����������� ���������� �������� ������...");

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

                                        // ��� ��������� �����
                                        var _xmlFilename = string.Format("{0}_{1}_{2}.xml.ecrchg$", ChangeType, _packageId.Value, StorageName);
                                        // ��� ����� ��� ������� ������
                                        var _xmlSjFilename = string.Format("otSendingJournal_ECR_{0}_{1}.xml.ecrchg$", _packageId.Value, StorageName);

                                        Debug("������ �������� ��������� �������� ������...");
                                        _cmd.ExecuteNonQuery();

                                        Debug("������ ������ ������ � ���� xml...");
                                        // ������������ ��������� �����
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
                                        Debug("�������� ��������� ����� ������ xml ��������� �������");

                                        #region Writing Sending Journals

                                        // ����� ���� ������� ��������
                                        if (_writeSJ)
                                        {

                                            Debug("�������� ����� ������� ��������...");

                                            // ��������� xslt-�������������� ��� ��������� ����� ������� ��������
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
                                                    // ����� �������������
#pragma warning disable 618,612
                                                    var _xslt = new XslTransform();
#pragma warning restore 618,612
                                                    _xslt.Load(new XPathDocument(new StringReader(xsltScript)));

                                                    // �������� ����
                                                    var _xmlSj = new XmlDocument();
                                                    _xmlSj.LoadXml(_outXml.Value.ToString());

                                                    // �������� ������� �����������
                                                    var _argList = new XsltArgumentList();
                                                    _argList.AddParam("mID", "", Guid.NewGuid());
                                                    _argList.AddParam("origFN", "", _xmlSjFilename);

                                                    // ��������� �������������
                                                    _xslt.Transform(_xmlSj, _argList, _writer);

                                                    _writer.Formatting = Formatting.None;
                                                    _writer.Flush();
                                                }
                                                finally
                                                {
                                                    _writer.Close();
                                                }
                                            }
                                            Debug("�������� ����� ������� �������� ��������� �������");

                                        }

                                        #endregion

                                        _log.Info(
                                            string.Format(
                                                "�������� ����� ������ xml ��������� �������. ����: '{0}', PackageId: {1}",
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
                            throw new Exception(string.Format("������������ �������� ��������� 'SnapshotType': '{0}'", SnapshotType));

                    }

        			_log.Info(string.Format("������� ��������� �������, key: '{0}'", Key));

        		}
        		catch (SqlException e)
        		{
        			if(e.Number == 50000)
                        _log.Info(string.Format("�������������� ��� ���������� �������, key: '{0}'", Key), e);
                    else
                        _log.Error(string.Format("������ ���������� �������, key: '{0}'", Key), e);
                    return;
        		}
                catch (Exception e)
                {
                    _log.Error(string.Format("������ ���������� �������, key: '{0}'", Key), e);
                }

        	}
        	else
        		// ���� ������ ����������, �� ����� � ��� � �������
                _log.Warn(string.Format("�������: {0} �������������. ������� ��������� ���� ������ ��������", Key));

        }

    	/// <summary>
        /// ��������� ���������� ������ ���������� � ����� ������ ECR_Storage �� ��������� ����� ECRStorageName
        /// </summary>
        /// <param name="ECRStorageName">��������� ��� ��������</param>
        /// <returns>������ ���������� � ����� ������</returns>
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
