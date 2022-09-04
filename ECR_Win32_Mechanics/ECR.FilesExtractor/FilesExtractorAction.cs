using System;
using System.Configuration;
using System.IO;
using System.Xml;
using System.Xml.XPath;
using log4net;

namespace ECR.FilesExtractor
{

	/// <summary>
	/// ����� ������������� ��������� ��� ���������� �������� ...
	/// </summary>
	class FilesExtractorAction
	{

#pragma warning disable 169
		private const string DEFAULT_ENCODING = "base64";
#pragma warning restore 169

		#region Token definitions

		private const string _token1 = "[tk.key]";
		private const string _token2 = "[tk.number]";
		private const string _token3 = "[jd.item]";

		// ������ � ������� ����� ����� ��� �������
		private readonly string[] _keyTokens = { _token1, _token3 };
#pragma warning disable 169
// ReSharper disable InconsistentNaming
		private const string _numberToken = _token2;
// ReSharper restore InconsistentNaming
#pragma warning restore 169

		#endregion

		#region Logging objects and variables

		private readonly static ILog _log = LogManager.GetLogger(typeof(FilesExtractorAction));

		#endregion

        // ���� � temp-����� ��� ������ � ��������� ���������
        private string _temppath = Path.GetTempPath();

		private Guid _key;
		private bool _enabled = true;
		private string _source = string.Empty;
		private string _destination = string.Empty;
		private string _sourceMask = string.Empty;
	    private string _destinationMask = string.Empty;

		#region FilesExtractorAction class constructors

		/// <summary>
		/// ����������� ������ FilesExtractorAction
		/// </summary>
		/// <param name="key">���� ������� ������������ ����� xml. ���������� ������������� guid</param>
		public FilesExtractorAction(string key)
		{
			DebugMode = false;
			ConfigureLoggingSubsystem();
			_key = new Guid(key);
		    SetTempPath();
		}

		/// <summary>
		/// ����������� ������ FilesExtractorAction
		/// </summary>
		/// <param name="key">���� ������� ������������ ����� xml. ���������� ������������� guid</param>
		/// <param name="DebugMode">���������� ���������/���������� ������ Debug � ������. DebugMode = true �������� ����� debug</param>
		public FilesExtractorAction(string key, bool DebugMode)
		{
			this.DebugMode = DebugMode;
			ConfigureLoggingSubsystem();
			_key = new Guid(key);
		    SetTempPath();
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
        /// 
        /// </summary>
        private void SetTempPath()
        {
            var _path = ConfigurationManager.AppSettings.Get("TempPath");
            if (_path.Length > 0)
                if (Directory.Exists(_path))
                    _temppath = _path;
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
		/// �������� ���������� ����� debug � ������
		/// </summary>
		public bool DebugMode { get; set; }

		/// <summary>
		/// �������� ���������� ���� � �������� ����� � ������� ��� ������������ ����� xml;
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
		/// �������� ���������� ���� � ��������� ����� � ������� ��� ������������ ����� xml;
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
		/// �������� ���������� ����� ���� ������ �� �������� �����
		/// </summary>
		public string DestinationMask
		{
			get
			{
				return _destinationMask;
			}
			set
			{
				_destinationMask = value;
			}
		}

        /// <summary>
        /// �������� ���������� ����� ����� ����� �� �������� �����
        /// </summary>
        public string SourceMask
        {
            get
            {
                return _sourceMask;
            }
            set
            {
                _sourceMask = value;
            }
        }

		/// <summary>
		/// ����� ��������� ������� ������������ ����� xml �� ������ ��������� ������� �� �������� �����
		/// </summary>
		public void Execute()
		{

			_log.Info(string.Format("������ �������... Key: '{0}', Source: '{1}', , Destination: '{2}', Source mask: '{3}'", Key, Source, Destination, SourceMask));

			// �������� �� ����������� �������
			if (Enabled)
			{
				
                #region ������������� ���������
				var _processed = 0;
				var _success = 0;
				var _errors = 0;
// ReSharper disable ConvertToConstant.Local
				var _warnings = 0;
// ReSharper restore ConvertToConstant.Local
				#endregion

				Debug("��������� ������ ������...");

				// ����������� ����� ��� ���������, �������������� �� <file_name>.ecr$
				var di = new DirectoryInfo(Source);

				// ��������� ���� �� ����������������� �� �� ����������� �����
				var _files = di.GetFiles("*.ecr$");

				// ���� ������ ���, �������� �����
				if (_files.Length == 0)
				{
                    // ����������� ����� xml ��������� �������.
                    // �����: ����� ����� ����� ����������, �������� �������� ������ � �������� �� xml, �� ������ ��������������� ��������� �������!
					foreach (var fileInfo in di.GetFiles(SourceMask))
					{
						fileInfo.MoveTo(fileInfo.FullName + ".ecr$");
					}
					// �������� �����������������
					_files = di.GetFiles("*.ecr$");
				}

                // �������� ���� ��������� �������� ������
				foreach(var _file in _files)
				{
					try
					{
						
                        Debug(string.Format("�������������� ����: '{0}'...", _file.FullName));
						_processed++;

						// ��������� ������ xml � DOM
						_log.Info(string.Format("����������� xml: '{0}'...", _file.FullName));

						var _xml = new XmlDocument();
						_xml.Load(_file.FullName);

						// ������� ��������� �� ������� xml
						XPathNavigator _xpn = _xml.CreateNavigator();
						if (_xpn != null)
						{
							_xpn.MoveToRoot();
							XPathNodeIterator _ni = _xpn.Select("//Message/Object");

							while (_ni.MoveNext())
							{
								// �������� ���� ����� � base64
								var _item_body = _ni.Current.GetAttribute("ItemBody", "");
								// ��������� ������������ �� ���� ����� � xml � ������������
                                // ���������� �������� ItemBody ������������ �������� �������� ����� (� �������� ��������� �� ��������������)
							    if (_item_body == string.Empty) continue;
							    var _binaryData = Convert.FromBase64String(_item_body);

                                // �������� ������� ��������� � xml
                                var _ext = _ni.Current.GetAttribute("Extension", "");
                                if (_ext.Length == 0)
                                    throw new Exception(string.Format("���������� ���������� ����� �� ���������� � xml: {0}", _file.FullName));
                                var _outputKey = _ni.Current.GetAttribute("ItemKey", "");
                                if (_outputKey.Length == 0)
                                    throw new Exception(string.Format("���� ���������� ����� �� ��������� � xml: {0}", _file.FullName));
							    var _itemNumber = _ni.Current.GetAttribute("ItemNumber", "");
                                
                                // ����������� ����� ����� �� ��������� �����
							    var _outputFileName = DestinationMask.Replace("[ext]", _ext);
							    _outputFileName = _outputFileName.Replace(_keyTokens[0], _outputKey);       // [tk.key]
                                _outputFileName = _outputFileName.Replace(_keyTokens[1], _outputKey);       // [jd.item]
                                if(DestinationMask.IndexOf(_numberToken, 0) >-1)   // � ��������� ����� ������������ ����� �������
                                {
                                    if (_itemNumber.Length > 0)
                                        _outputFileName = _outputFileName.Replace(_numberToken, _itemNumber);
                                    else
                                        throw new Exception(string.Format("�������� 'ItemNumber' �� ������, �� ��������� � ��������� �����. ����: '{0}'", _file.FullName));
                                }
                                else                                               // � ��������� ����� ��� ������ �������
                                {
                                    if (_itemNumber.Length > 0)
                                        throw new Exception(string.Format("�������� 'ItemNumber' �� ����� � ��������� �����, �� ��������� � xml. ����: '{0}'", _file.FullName));
                                }
							    Debug(string.Format("'{0}': ��� ���������� ����� ���������� ���: '{1}'", _file.FullName, _outputFileName));

							    // ���������� ���� � temp
							    var _outFile = new FileStream(_temppath + _outputFileName, FileMode.Create, FileAccess.Write);
							    _outFile.Write(_binaryData, 0, _binaryData.Length);
							    _outFile.Close();

							    // ���� ���� ����������� ���������, �������� ���������� ���� �� ����� temp � ����� Destination
							    File.Copy(_temppath + _outputFileName, Destination + _outputFileName, true);
							    Debug(string.Format("���� '{0}' ���������� � ��������� �����", _outputFileName));

                                // ������� ���� �� temp
                                File.Delete(_temppath + _outputFileName);
							    Debug(string.Format("���� '{0}' ������ �� ����� temp", _outputFileName));

							    Debug(string.Format("���� ������� ��������: '{0}''", Destination + _outputFileName));

							}

						}

                        // ������� ����������� ����
                        _file.Delete();
                        _success++;

					}
					catch (Exception e)
					{
						_log.Error(string.Format("������ �������� �������� ������. ����: '{0}'", _file.FullName), e);
                        // ����������� ����� � ����� Errors
                        var _path = ConfigurationManager.AppSettings.Get("ErrorsPath");
                        if (_path.Length > 0)
                            if (Directory.Exists(_path))
                                _file.CopyTo(_path + _file.Name, true);
						_errors++;
					}
				}
				_log.Info(string.Format("����������: {0}, �������: {1}, � ��������: {2}, ��������������: {3}.", _processed, _success, _errors, _warnings));

			}
			else
				// ���� ������ ����������, �� ����� � ��� � �������
                _log.Warn(string.Format("�������: {0} �������������. ������� ��������� ���� ������ ��������", Key));
		}
	}

}
