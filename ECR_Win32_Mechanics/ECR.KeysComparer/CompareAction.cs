using System;
using System.Configuration;
using System.Text.RegularExpressions;
using System.IO;

using log4net;
using ECRManagedAssemblies;

namespace ECR.KeysComparer
{

    /// <summary>
    /// ����� ������������� ��������� ��� ���������� �������� ������������� ���� ������ �� ������ �� �������� �����
    /// </summary>
    public class CompareAction
    {

        #region Token definitions
        
        private const string _token1 = "[tk.key]";
        private const string _token2 = "[tk.number]";
        private const string _token3 = "[jd.item]";

        // ������ � ������� ����� ����� ��� �������
        private readonly string[] __key_tokens  = { _token1, _token3 };
        private const string __number_token = _token2;

        #endregion

        #region Logging objects and variables

        private readonly static ILog _log = LogManager.GetLogger(typeof(CompareAction));

        #endregion
        
        private Guid _key;
        private bool _enabled = true;

        private string _source  = string.Empty;
        private string _sourceMask  = string.Empty;
        private string _destination = string.Empty;
        private string _compareMask = string.Empty;
        private string _archive = string.Empty;
        private string _conflicts = string.Empty;

        #region CompareAction class constructors

        /// <summary>
        /// ����������� ������ CompareAction
        /// </summary>
        /// <param name="key">���� ������� �������������. ���������� ������������� guid</param>
        public CompareAction(string key)
        {
            DebugMode = false;
            ConfigureLoggingSubsystem();
            _key = new Guid(key);
            DataBinding = string.Empty;
        }

        /// <summary>
        /// ����������� ������ CompareAction
        /// </summary>
        /// <param name="key">���� ������� �������������. ���������� ������������� guid</param>
        /// <param name="DebugMode">���������� ���������/���������� ������ Debug � ������. DebugMode = true �������� ����� debug</param>
        public CompareAction(string key, bool DebugMode)
        {
            this.DebugMode = DebugMode;
            ConfigureLoggingSubsystem();
            _key = new Guid(key);
            DataBinding = string.Empty;
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
// ReSharper disable UnusedMember.Local
        private void Debug(string message, Exception e)
// ReSharper restore UnusedMember.Local
        {
            if (DebugMode)
                _log.Debug(message, e);
        }

        #endregion

        /// <summary>
        /// �������� ���������� ���� ������� ������������� (���������� ������������� guid)
        /// </summary>
        public string Key
        {
            get
            {
                return _key.ToString();
            }
        }

        /// <summary>
        /// �������� ��������� ��������� ����������� ������� �������������
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
        /// ����� ��������� ��������� ������� ������������� � "��������"
        /// </summary>
        public void Enable()
        {
            _enabled = true;
        }

        /// <summary>
        /// ����� ��������� ��������� ������� ������������� � "����������"
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
        /// �������� ���������� ���� � �������� ����� � ������� ��� �������������;
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
                    throw new Exception(string.Format("������ ������� � �����:: '{0}'", value));
                _source = value;
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
        /// �������� ���������� ���� � ��������� ����� � ������� ��� �������������;
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
                    throw new Exception(string.Format("������ ������� � �����:: '{0}'", value));
                _destination = value;
            }
        }

        /// <summary>
        /// �������� ���������� ����� ����� ����� � ��������� �����
        /// </summary>
        public string CompareMask
        {
            get
            {
                return _compareMask;
            }
            set
            {
                _compareMask = value;
            }
        }

        /// <summary>
        /// �������� ���������� ���� � ����� ������ ��������������� ������;
        /// � ������ ���������� ����� ���� ������� � ��� ������������ exception;
        /// ��������� �������� string.Empty: � ���� ������ ��������������� ����� � ����� �� �������;
        /// </summary>
        public string ArchivePath
        {
            get
            {
                return _archive;
            }
            set
            {
                if (value.Length > 0)
                {
                    if (!Directory.Exists(value))
                        throw new Exception(string.Format("������ ������� � �����:: '{0}'", value));
                }
                _archive = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public string ConflictsPath
        {
            get
            {
                return _conflicts;
            }
            set
            {
                if (value.Length > 0)
                {
                    if (!Directory.Exists(value))
                        throw new Exception(string.Format("������ ������� � �����:: '{0}'", value));
                }
                _conflicts = value;
            }
        }

        /// <summary>
        /// �������� ���������� �������� � �������� ������, �� �������� ������������ ����� �������;
        /// �������� � �������� �������������� ����������� ������� ������ ����������� ������ DataConnectionProvider
        /// </summary>
        public string DataBinding { get; set; }

        /// <summary>
        /// �������� ����������, ����� �� �������� ��� ������������ ����� � ��������� (�������) �����
        /// </summary>
        public bool Overwrite { get; set; }
        
        /// <summary>
        /// ����� ��������� ������� ������������� ���� ������ �� ������ �� �������� ����� �� �������� ��������
        /// </summary>
        public void Execute()
        {
            
            _log.Info(string.Format("������ �������... Key:  {0}, Source: '{1}', SourceMask: '{2}', Destination: '{3}', CompareMask: {4}', Archive: {5}', DataBinding: '{6}', Overwrite: {7}", Key, Source, SourceMask, Destination, CompareMask, ArchivePath, DataBinding, Overwrite));

            // �������� �� ����������� �������
            if (Enabled)
            {

                #region ������������� ���������

                int _processed = 0;
                int _success = 0;
                int _errors = 0;
                int _warnings = 0;

                #endregion

                // �������� ������� ��� ��������� ������ �� �������� ��������
                Debug("���������������� ������� SourceCatalogEntityChecker...");
                var _checker = new SourceCatalogEntityChecker(ConfigurationManager.AppSettings.Get("ECR_Config.Database.Connection.ConnectionString"), DataBinding);

                #region ������������ ����� ��� ������� ������ �� �����

                Debug("����������� ����� ��� �������...");

                var _mask = _sourceMask.Replace("[ext]", "*");
                for (var i = 0; i < __key_tokens.Length; i++)
                    _mask = _mask.Replace(__key_tokens[i], "*");
                _mask = _mask.Replace(__number_token, "*");

                #endregion

                // input

                #region ������������ ������ ��� ������ ������� �� �����

                Debug("������������ ������ ��� ������ �������...");

                var _input_key_token = string.Empty;
                for (var i = 0; i < __key_tokens.Length; i++)
                {
                    if (SourceMask.IndexOf(__key_tokens[i]) <= -1) continue;
                    _input_key_token = __key_tokens[i];
                    break;
                }

                // ���������������� ������� ���� ������ ����, ���� �� ����� ��� �� ��� - ���������� ����������
                if (_input_key_token.Length == 0)
                    throw new Exception("�������� ����� �� ��������� ��� ��������� �����������");

                // number

                // ���������������� ����� ������ ����, ���������� �� ����� ��������� �����
                var _number_token = string.Empty;
                if (SourceMask.IndexOf(__number_token) > -1)
                    _number_token = __number_token;

                #endregion

                // output

                #region ������������ ������ ����� ��� ����������� � output

                Debug("������������ ������ ����� ��� ����������� � output...");

                var _output_key_token = string.Empty;
                for (var i = 0; i < __key_tokens.Length; i++)
                {
                    if (CompareMask.IndexOf(__key_tokens[i]) > -1)
                    {
                        _output_key_token = __key_tokens[i];
                        break;
                    }
                }
                if (_output_key_token.Length == 0)
                    throw new Exception("��������� ����� �� ��������� ��� ��������� �����������");

                #endregion

                // ��������� ������ ������, ����������� � �������� �����
                Debug("��������� ������ �������� ������...");
                var _files = Directory.GetFiles(Source, _mask);

                if (_files.Length > 0)
                {

                    Debug("�������� ���� ������...");
                    for (var i = 0; i < _files.Length; i++)
                    {

                        try
                        {

                            Debug(string.Format("�������������� ����: '{0}'...", _files[i]));
                            _processed++;

                            // ������ [ext] � ���������� ����� � ������� �������� ��������� �����
                            var _pattern = SourceMask.Replace("[ext]", Path.GetExtension(_files[i]).Replace(".", ""));
                            _pattern = _pattern.Replace(Path.GetExtension(_files[i]), "");

                            Debug(string.Format("'{0}': �������� ������ ���������������", _files[i]));

                            // ��������� �������� �������� ������� ��� key � number
                            
                            var _number = string.Empty;
                            if (_number_token.Length > 0)
                                _number = GetKeyTokenValue(Path.GetFileName(_files[i]), _pattern, _number_token, _input_key_token);

                            var _input_key = GetKeyTokenValue(Path.GetFileName(_files[i]).Replace("_" + _number, string.Empty).Replace("__", "_"), _pattern, _input_key_token, "_" + _number_token);
                            Debug(string.Format("'{0}': �������� ���� ���������������", _files[i]));

                            if (_number.Length > 0)
                            {
                                while (_number.Substring(0, 1) == "0")
                                    _number = _number.Substring(1, _number.Length - 1);
                            }
                            Debug(string.Format("'{0}': input number configured", _files[i]));


                            // ��������� ������������� �������� ������� � ��������
                            Debug(string.Format("�������� ������������� ��������... Key type: '{0}', key value: '{1}'", _input_key_token, _input_key));
                            if (!_checker.CheckItemExists(_input_key_token.Replace("[", "").Replace("]", ""), _input_key))
                            {

                                _log.Warn(string.Format("������� �� ����� � �������� ��������. Key type: '{0}', key value: '{1}', source file: '{2}'", _input_key_token, _input_key, _files[i]));
                                _warnings++;

                                // ���� ����� ���� ��� ���������� ���������� - ���������� ���� �� ��������� ���� (overwrite = true)
                                if(ConflictsPath.Length >0)
                                {
                                    Debug(string.Format("����������� ����� � ����� ����������: '{0}'", _files[i]));
                                    File.Copy(_files[i], ConflictsPath + Path.GetFileName(_files[i]), true);
                                    Debug(string.Format("'{0}': ���� ���������� � ����� ����������", _files[i]));
                                    Debug(string.Format("�������� �����: '{0}'", _files[i]));
                                    File.Delete(_files[i]);
                                    Debug(string.Format("'{0}': ���� ������� ������", _files[i]));
                                }

                            }
                            else
                            {

                                // �������� �������� ����� �� ���������;
                                var _output_key = _checker.CompareKeys(_input_key_token.Replace("[", "").Replace("]", ""),
                                                     _input_key,
                                                     _output_key_token.Replace("[", "").Replace("]", ""));

                                Debug(string.Format("'{0}': ��������� ���� ���������������", _files[i]));

                                // ���������� ����� ��� ����� � ������������ � �������� ������
                                var _output_file_name = CompareMask.Replace("[ext]", Path.GetExtension(_files[i]).Replace(".", ""));
                                _output_file_name = _output_file_name.Replace(_output_key_token, _output_key);

                                if ((_number_token.Length > 0) & (CompareMask.IndexOf(_number_token) > -1))
                                    _output_file_name = _output_file_name.Replace(_number_token, _number);

                                Debug(string.Format("'{0}': ��������� ��� ����� ����������", _files[i]));

                                // ���� �������� Archive �����, �� �������� ���� � �����;
                                // �������� OverwriteFiles ����������, ����� �� �������� ����, ���� �� ��� ����������;
                                // � ������, ���� ���� �� �����-���� �������� �� ������������, ������������ ����������� Exception;
                                // � ������, ���� ���� ���������� � Overwrite = false ������������ ����������� Exception;
                                if (ArchivePath.Length > 0)
                                {
                                    Debug(string.Format("����������� ����� � ����� ������: '{0}'", _files[i]));
                                    var _path_archive = ArchivePath + _output_file_name;
                                    File.Copy(_files[i], @_path_archive, Overwrite);
                                    Debug(string.Format("'{0}': ���� ���������� � ����� ������", _files[i]));
                                }

                                // �������� ���� � ����� ������ � ������� �����;
                                Debug(string.Format("����������� ����� � ��������� �����: '{0}'", _files[i]));
                                var _path_dest = Destination + _output_file_name;
                                File.Copy(_files[i], @_path_dest, Overwrite);
                                Debug(string.Format("'{0}': ���� ���������� � ��������� �����", _files[i]));

                                // ������� ���� �� �������� �����
                                Debug(string.Format("�������� �����: '{0}'", _files[i]));
                                File.Delete(_files[i]);
                                Debug(string.Format("'{0}': ���� ������", _files[i]));

                                _log.Info(string.Format("���� ������� ������������: '{0}', ��������� ��� �����: '{1}'", _files[i], _path_dest));
                                _success++;

                            }

                        }
                        catch (Exception e)
                        {
                            _log.Error(string.Format("������ �������������� �����. ����: '{0}'", _files[i]), e);
                            _errors++;
                        }

                    }
                }

                _log.Info(string.Format("������� ��������� �������: {0}. ����������: {1}, �������: {2}, � ��������: {3}, ��������������: {4}.", Key, _processed, _success, _errors, _warnings));

            }
            else
                // ���� ������ ����������, �� ����� � ��� � �������
                _log.Warn(string.Format("�������: {0} �������������. ������� ��������� ���� ������ ��������", Key));

        }

        /// <summary>
        /// ������� ������������ �������������� ����� ����� �� �������� ��������
        /// </summary>
        /// <param name="input">��� ����� ��� ��������������</param>
        /// <param name="pattern">������ ����������� ��������� ��� ��������������</param>
        /// <param name="key_token">����� ��� ����������� �����</param>
        /// <param name="empty_token">����� ��� ����������� ������ ������</param>
        /// <returns>��������������� �� �������� �������� ��� �����</returns>
        private static string GetKeyTokenValue(string input, string pattern, string key_token, string empty_token)
        {
            // ������������ ����������� ���������
            var s = pattern.Replace(key_token, "([0-9]+)");
            if(empty_token.Length > 0)              // ������� empty_token
                s = s.Replace(empty_token, "");
            s = s.Replace("__", "_");               // �������: ������� ��������� �������� ������� "_"
            // ���������� ��������������� ����������� ��������� � ����������� ������� - ��������� ��������� key_token
            var r = new Regex(s, RegexOptions.Compiled);
            var m = r.Match(input);
            // ������� ���������� �������� ������� ������ (���������������� key_token), ���������� �� Match;
            // m.Groups[0] ������ ���� ��� �������� ���������� ���������;
            return m.Groups[1].ToString();                  // mmx, 18.01.2008: ����������� ���� � ��������� �������� �������
        }

    }

}
