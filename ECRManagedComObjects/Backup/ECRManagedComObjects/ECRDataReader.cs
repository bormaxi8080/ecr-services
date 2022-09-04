using System;
using System.Diagnostics;
using System.Security;
using System.EnterpriseServices;
using System.Runtime.InteropServices;
using Microsoft.Win32;

using ECRManagedAssemblies;

[assembly: ApplicationName("ECRManagedComObjects")]
[assembly: Description("ECR data access .NET serviced components.")]

[assembly: ApplicationActivation(ActivationOption.Server)]
[assembly: ApplicationAccessControl(
           false,                                                                // Authentication is OFF
           AccessChecksLevel = AccessChecksLevelOption.ApplicationComponent,
           Authentication = AuthenticationOption.Packet,
           ImpersonationLevel = ImpersonationLevelOption.Impersonate)]

/*
#if DEBUG
[assembly: SecurityRole("DataReader")]
#else
[assembly: SecurityRole("DataReader", SetEveryoneAccess = false)]
#endif
 */

namespace ECRManagedComObjects
{

    /// <summary>
    /// ECRDataReader class provides data access to read (not write) data from ECR storages
    /// </summary>
    [JustInTimeActivation]
    [ComponentAccessControl(true)]
    //[SecurityRole("DataReader", SetEveryoneAccess = true)]
    //[SecurityRole("DataWriter", SetEveryoneAccess = false)]
    //[SecurityRole("Administrator", SetEveryoneAccess = false)]
    [ObjectPooling(Enabled = true, MinPoolSize = 0, MaxPoolSize = 100, CreationTimeout = 60000)]
    [Transaction(TransactionOption.Required)]
    [Guid("7238222D-5047-33F3-AAF7-1BF917EB69F4")]
    public class ECRDataReader : ServicedComponent, IECRDataReader
    {
        
        private const string REG_BASE_KEY = @"Software\TopBook\ECR\ECRManagedComObjects";
        private const string REG_ECR_DATAREADER_KEY = @"\ECRDataReader";
        private const string REG_PARAMETER_SERVER_ECR_CONFIG = "Server";
        private const string REG_PARAMETER_CONNECTION_TIMEOUT_ECR_CONFIG = "ConnectionTimeout";
        private const string REG_PARAMETER_COMMAND_TIMEOUT_ECR_CONFIG = "CommandTimeout";
        private const string REG_PARAMETER_DEBUG_FLAG = "Debug";

        private const string DEFAULT_DATA_SOURCE = "local";
        private const int DEFAULT_CONNECTION_TIMEOUT = 600;
        private const int DEFAULT_COMMAND_TIMEOUT = 600;

        private readonly bool _DEBUG;
        private readonly Guid _INSTANCE_ID;

        private readonly string _dataSourceServerName;
        private readonly int _connectionTimeout;
        private readonly int _commandTimeout;
        
        /// <summary>
        /// ECRDataReader class constructor
        /// </summary>
        public ECRDataReader()
        {

            // Define _INSTANCE_ID class service variable
            _INSTANCE_ID = new Guid();
            
            // Define _DEBUG global class service variable
            // HKLM\Software\TopBook\ECR\ECRManagedComObjects\ECRDataReader
            var _key = Registry.LocalMachine.OpenSubKey(REG_BASE_KEY + REG_ECR_DATAREADER_KEY, false);
            if (_key != null) _DEBUG = Convert.ToBoolean(_key.GetValue(REG_PARAMETER_DEBUG_FLAG, "false"));
            Debug("COM+ application DEBUG mode is enabled");

            // Define ConnectionTimeout value
            _connectionTimeout = GetConnectionTimeout();
            Debug(string.Format("ConnectionTimeout parameter value defined as: {0}", _connectionTimeout));

            // Define CommandTimeout value
            _commandTimeout = GetCommandTimeout();
            Debug(string.Format("CommandTimeout parameter value defined as: {0}", _commandTimeout));

            _dataSourceServerName = GetDataSourceServerName();
            Debug(string.Format("DataSourceServerName parameter value defined as: {0}", _dataSourceServerName));

        }

        /// <summary>
        /// This method gets ConnectionTimeout value from system registry
        /// </summary>
        /// <returns></returns>
        // ReSharper disable MemberCanBeMadeStatic
        private int GetConnectionTimeout()
        // ReSharper restore MemberCanBeMadeStatic
        {
            // HKLM\Software\TopBook\ECR\ECRManagedComObjects\ECRDataReader
            var _result = DEFAULT_CONNECTION_TIMEOUT;
            var _key = Registry.LocalMachine.OpenSubKey(REG_BASE_KEY + REG_ECR_DATAREADER_KEY, false);
            if (_key != null) _result = Convert.ToInt32(_key.GetValue(REG_PARAMETER_CONNECTION_TIMEOUT_ECR_CONFIG, DEFAULT_CONNECTION_TIMEOUT));
            return _result;
        }

        /// <summary>
        /// This method gets CommandTimeout value from system registry
        /// </summary>
        /// <returns></returns>
        // ReSharper disable MemberCanBeMadeStatic
        private int GetCommandTimeout()
        // ReSharper restore MemberCanBeMadeStatic
        {
            // HKLM\Software\TopBook\ECR\ECRManagedComObjects\ECRDataReader
            var _result = DEFAULT_COMMAND_TIMEOUT;
            var _key = Registry.LocalMachine.OpenSubKey(REG_BASE_KEY + REG_ECR_DATAREADER_KEY, false);
            if (_key != null) _result = Convert.ToInt32(_key.GetValue(REG_PARAMETER_COMMAND_TIMEOUT_ECR_CONFIG, DEFAULT_COMMAND_TIMEOUT));
            return _result;
        }

        /// <summary>
        /// This method gets DataSource server name value to connect to ECR_Config database from system registry
        /// </summary>
        /// <returns></returns>
        // ReSharper disable MemberCanBeMadeStatic
        private string GetDataSourceServerName()
        // ReSharper restore MemberCanBeMadeStatic
        {
            // HKLM\Software\TopBook\ECR\ECRManagedComObjects\ECRDataReader
            var _result = DEFAULT_DATA_SOURCE;
            var _key = Registry.LocalMachine.OpenSubKey(REG_BASE_KEY + REG_ECR_DATAREADER_KEY, false);
            if (_key != null) _result = (string)_key.GetValue(REG_PARAMETER_SERVER_ECR_CONFIG, DEFAULT_DATA_SOURCE);
            return _result;
        }

        /// <summary>
        /// ��������� ���������� ������ ADODB.Recordset, ��������������� ���������� � ������ ���� �������� Binding, ��������� � ������� ECR;
        /// </summary>
        /// <returns>ADODB.Recordset. ����� ������ �������� Binding</returns>
        public ADODB.Recordset GetBindingsList()
        {
            try
            {
                // Define ECRManagedDataReader class instance from external ECRManagedAssemblies class library
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                // This construct using DataSetConverter class from external DataSetConverter class library
                return DataSetConverter.DataSetConverter.ConvertToADODBRecordset(_reader.GetBindingsList());
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetBindingsList() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return null;
        }

        /// <summary>
        /// ��������� ���������� ������ ADODB.Recordset, ��������������� ���������� �� ������� Binding � �������� ������;
        /// </summary>
        /// <param name="SystemName">��������� ��� ������� Binding</param>
        /// <returns>ADODB.Recordset. ����� ������ ������� Binding</returns>
        public ADODB.Recordset GetBinding(string SystemName)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return DataSetConverter.DataSetConverter.ConvertToADODBRecordset(_reader.GetBinding(SystemName));
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetBinding() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return null;
        }

        /// <summary>
        /// ��������� ���������� ��� ������� Binding �� ��� �������������� ����������;
        /// </summary>
        /// <param name="DisplayAlias">������������� ��������� ��� ������� Binding</param>
        /// <returns>String. ��������� ��� ������� Binding</returns>
        public string GetBindingNameByAlias(int DisplayAlias)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return _reader.GetBindingNameByAlias(DisplayAlias);
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetBindingNameByAlias() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return string.Empty;
        }

        /// <summary>
        /// ��������� ���������� ������������� ��������� ������� Binding �� ��� ���������� �����
        /// </summary>
        /// <param name="SystemName">��������� ��� ��� ������� Binding</param>
        /// <returns>Integer. ������������� ��������� ������� Binding</returns>
        public int GetBindingAliasByName(string SystemName)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return _reader.GetBindingAliasByName(SystemName);
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetBindingAliasByName() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return 0;
        }

        /// <summary>
        /// �������� ���������� ������� ������������� ������� Binding � �������� ������ � ���������������� ��������� ������� ECR;
        /// </summary>
        /// <param name="SystemName">��������� ��� ��� ������� Binding</param>
        /// <returns>Bool. ������� ������������� ������� Binding</returns>
        public bool CheckBindingExists(string SystemName)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return _reader.CheckBindingExists(SystemName);
            }
            catch (Exception e)
            {
                LogEvent(string.Format("CheckBindingExists() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return false;
        }

        /// <summary>
        /// ��������� ���������� ������ ADODB.Recordset, ��������������� ���������� � ������ ���� �������� Entity, ��������� � ������� ECR;
        /// </summary>
        /// <returns>ADODB.Recordset. ����� ������ �������� Entitiy</returns>
        public ADODB.Recordset GetEntityList()
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return DataSetConverter.DataSetConverter.ConvertToADODBRecordset(_reader.GetEntityList());
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetEntityList() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return null;
        }

        /// <summary>
        /// ��������� ���������� ������ ADODB.Recordset, ��������������� ���������� � ������ ���� �������� Entity, ��������� � ������� ECR � ������� �������� � ������� Binding � �������� ������;
        /// </summary>
        /// <param name="BindingName">��������� ��� ������� Binding, ��� �������� ������ ������� Entity</param>
        /// <returns>ADODB.Recordset. ����� ������ �������� Entitiy</returns>
        public ADODB.Recordset GetEntityListByBinding(string BindingName)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return DataSetConverter.DataSetConverter.ConvertToADODBRecordset(_reader.GetEntityListByBinding(BindingName));
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetEntityListByBinding() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return null;
        }
        
        /// <summary>
        /// ��������� ���������� ������ ADODB.Recordset, ��������������� ���������� �� ������� Entity � �������� ������;
        /// </summary>
        /// <param name="SystemName">��������� ��� ��� ������� Entity</param>
        /// <returns>ADODB.Recordset. ����� ������ ������� Entity</returns>
        public ADODB.Recordset GetEntity(string SystemName)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return DataSetConverter.DataSetConverter.ConvertToADODBRecordset(_reader.GetEntity(SystemName));
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetEntity() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return null;
        }

        /// <summary>
        /// �������� ���������� ������� ������������� ������� Entity � �������� ������ � ���������������� ��������� ������� ECR;
        /// </summary>
        /// <param name="SystemName">��������� ��� ��� ������ Entity</param>
        /// <returns>Bool. ������� ������������� ������� Entity</returns>
        public bool CheckEntityExists(string SystemName)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return _reader.CheckEntityExists(SystemName);
            }
            catch (Exception e)
            {
                LogEvent(string.Format("CheckEntityExists() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return false;
        }

        /// <summary>
        /// ��������� ���������� ������� ��������������� ��� ������� Entity � �������� ��������� ������;
        /// </summary>
        /// <param name="SystemName">��������� ��� ��� ������� Entity</param>
        /// <returns>Bool. ������� ��������������� ������ Entity � �������� ��������� ������</returns>
        public bool IsEntityMultiplied(string SystemName)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return _reader.IsEntityMultiplied(SystemName);
            }
            catch (Exception e)
            {
                LogEvent(string.Format("IsEntityMultiplied() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return false;
        }

        /// <summary>
        /// ��������� ���������� ��������� ��� ��� ������� Entity � �������� �������������� �����������;
        /// </summary>
        /// <param name="DisplayAlias">������������� ��������� ��� ������� Entity</param>
        /// <returns>String. ��������� ��� ������� Entity</returns>
        public string GetEntityNameByAlias(int DisplayAlias)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return _reader.GetEntityNameByAlias(DisplayAlias);
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetEntityNameByAlias() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return string.Empty;
        }

        /// <summary>
        /// ��������� ���������� ������������� ��������� ��� ������� Entity � �������� ��������� ������;
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns>Integer. ������������� ��������� ��� ������� Entity</returns>
        public int GetEntityAliasByName(string SystemName)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return _reader.GetEntityAliasByName(SystemName);
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetEntityAliasByName() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return 0;
        }
        
        /// <summary>
        /// ��������� ���������� ������ ADODB.Recordset, ��������������� ���������� �� �������� View, ��������� � ���������������� ��������� ������� ECR;
        /// </summary>
        /// <param name="Enabled">������� ����������� �������� View (true/false)</param>
        /// <returns>ADODB.Recordset. ����� ������ ������� View</returns>
        public ADODB.Recordset GetViewList(bool Enabled)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return DataSetConverter.DataSetConverter.ConvertToADODBRecordset(_reader.GetViewList(Enabled));
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetViewList() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return null;
        }

        /// <summary>
        /// ��������� ���������� ������ ADODB.Recordset, ��������������� ���������� �� �������� View, ��������� � ���������������� ��������� ������� ECR
        ///     � ������� �������� � ������� Binding ����� ������������ ������ Entity;
        /// </summary>
        /// <param name="BindingName">��������� ��� ������� Binding, � �������� ����� ������� ������� View</param>
        /// <param name="Enabled">������� ����������� �������� View (true/false)</param>
        /// <returns>ADODB.Recordset. ����� ������ �������� View</returns>
        public ADODB.Recordset GetViewListByBinding(string BindingName, bool Enabled)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return DataSetConverter.DataSetConverter.ConvertToADODBRecordset(_reader.GetViewListByBinding(BindingName, Enabled));
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetViewListByBinding() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return null;
        }
        
        /// <summary>
        /// ��������� ���������� ������ ADODB.Recordset, ��������������� ���������� �� �������� View, ��������� � ���������������� ��������� ������� ECR
        ///     � ���������� ������������ ������� Entity � �������� ��������� ������;
        /// </summary>
        /// <param name="EntityName">��������� ��� ������� Entity, ����������� ��������� ��� �������� View</param>
        /// <param name="Enabled">������� ����������� �������� View (true/false)</param>
        /// <returns>ADODB.Recordset. ����� ������ �������� View</returns>
        public ADODB.Recordset GetViewListByEntity(string EntityName, bool Enabled)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return DataSetConverter.DataSetConverter.ConvertToADODBRecordset(_reader.GetViewListByEntity(EntityName, Enabled));
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetViewListByEntity() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return null;
        }

        /// <summary>
        /// ��������� ���������� ������ ADODB.Recordset, ��������������� ���������� �� ������� View � �������� ��������� ������;
        /// </summary>
        /// <param name="SystemName">��������� ��� ��� ������� View</param>
        /// <returns>ADODB.Recordset. ����� ������ ������� View</returns>
        public ADODB.Recordset GetView(string SystemName)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return DataSetConverter.DataSetConverter.ConvertToADODBRecordset(_reader.GetView(SystemName));
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetView() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return null;
        }

        /// <summary>
        /// ��������� ���������� ��������� ��� ��� ������� View � �������� ������������� �����������;
        /// </summary>
        /// <param name="DisplayAlias">������������� ��������� ��� ������� View</param>
        /// <returns>String. ��������� ��� ������� View</returns>
        public string GetViewNameByAlias(int DisplayAlias)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return _reader.GetViewNameByAlias(DisplayAlias);
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetViewNameByAlias() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return string.Empty;
        }

        /// <summary>
        /// ��������� ���������� ������������� ��������� ��� ������� View � �������� ���������;
        /// </summary>
        /// <param name="SystemName">��������� ��� ��� ������� View</param>
        /// <returns>Integer. ������������� ��������� ������� View</returns>
        public int GetViewAliasByName(string SystemName)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return _reader.GetViewAliasByName(SystemName);
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetViewAliasByName() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return 0;
        }

        /// <summary>
        /// �������� ���������� ������� ������������� ������� Vew � �������� ������ � ���������������� ��������� ������� ECR;
        /// </summary>
        /// <param name="SystemName">��������� ��� ��� ������� View</param>
        /// <returns>Bool. ������� ������������� ������� View � �������� ��������� ������</returns>
        public bool CheckViewExists(string SystemName)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return _reader.CheckViewExists(SystemName);
            }
            catch (Exception e)
            {
                LogEvent(string.Format("CheckViewExists() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return false;
        }

        /// <summary>
        /// ��������� ���������� ������� ����������� ������� View � �������� ��������� ������ � ���������������� ��������� ������� ECR;
        /// </summary>
        /// <param name="SystemName">��������� ��� ��� ������� View</param>
        /// <returns>Bool. ������� ����������� ������� View � �������� ��������� ������</returns>
        public bool IsViewEnabled(string SystemName)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return _reader.IsViewEnabled(SystemName);
            }
            catch (Exception e)
            {
                LogEvent(string.Format("IsViewEnabled() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return false;
        }

        /// <summary>
        /// ��������� ������������ �������� �������� ��������������� ������� View � �������� ��������� ������;
        /// </summary>
        /// <param name="SystemName">��������� ��� ��� ������� View</param>
        /// <returns>Bool. ������� ��������������� ������� View � �������� ��������� ������</returns>
        public bool IsViewMultiplied(string SystemName)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return _reader.IsViewMultiplied(SystemName);
            }
            catch (Exception e)
            {
                LogEvent(string.Format("IsViewMultiplied() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return false;
        }
        
        /// <summary>
        /// ��������� ���������� ������ ADODB.Recordset, ��������������� ���������� �� �������� Storage, ������������������ � ���������������� ��������� ������� ECR;
        /// </summary>
        /// <returns>ADODB.Recordset. ����� ������ �������� Storage</returns>
        public ADODB.Recordset GetStorageList()
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return DataSetConverter.DataSetConverter.ConvertToADODBRecordset(_reader.GetStorageList());
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetStorageList() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return null;
        }

        /// <summary>
        /// ��������� ���������� ������ ADODB.Recordset, ��������������� ���������� �� ������� Storage � �������� ��������� ������;
        /// </summary>
        /// <param name="SystemName">��������� ��� ��� ������� Storage</param>
        /// <returns>ADODB.Recordset. ����� ������ ������� Storage � �������� ��������� ������</returns>
        public ADODB.Recordset GetStorage(string SystemName)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return DataSetConverter.DataSetConverter.ConvertToADODBRecordset(_reader.GetStorage(SystemName));
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetStorage() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return null;
        }
        
        /// <summary>
        /// ��������� ���������� ������ ADODB.Recordset, ��������������� ���������� �� ������� Storage, � �������� ����� �������� ������ Entity � �������� ��������� ������;
        /// </summary>
        /// <param name="EntityName">��������� ��� ������� Entity</param>
        /// <returns>ADODB.Recordset. ����� ������ ������� Storage</returns>
        public ADODB.Recordset GetStorageForEntity(string EntityName)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return DataSetConverter.DataSetConverter.ConvertToADODBRecordset(_reader.GetStorageForEntity(EntityName));
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetStorageForEntity() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return null;
        }

        /// <summary>
        /// ��������� ���������� ������ ADODB.Recordset, ��������������� ���������� �� ������� Storage, � �������� ����� �������� ������ View � �������� ��������� ������;
        /// </summary>
        /// <param name="ViewName">��������� ��� ������� View</param>
        /// <returns>ADODB.Recordset. ����� ������ ������� Storage</returns>
        public ADODB.Recordset GetStorageForView(string ViewName)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return DataSetConverter.DataSetConverter.ConvertToADODBRecordset(_reader.GetStorageForView(ViewName));
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetStorageForView() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return null;
        }

        /// <summary>
        /// ��������� ���������� ������� ������������� ������� Storage � �������� ��������� ������;
        /// </summary>
        /// <param name="SystemName">��������� ��� ������� Storage</param>
        /// <returns>Bool. ������� ������������� ������� Storage � �������� ��������� ������</returns>
        public bool CheckStorageExists(string SystemName)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return _reader.CheckStorageExists(SystemName);
            }
            catch (Exception e)
            {
                LogEvent(string.Format("CheckStorageExists() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return false;
        }

        /// <summary>
        /// ��������� ���������� ��������� ��� ������� Storage �� ��� �������������� ����������;
        /// </summary>
        /// <param name="DisplayAlias">������������� ��������� ������� Storage</param>
        /// <returns>String. ��������� ��� ������� Storage</returns>
        public string GetStorageNameByAlias(int DisplayAlias)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return _reader.GetStorageNameByAlias(DisplayAlias);
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetStorageNameByAlias() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return null;
        }

        /// <summary>
        /// ��������� ���������� ������������� ��������� ������� Storage �� ��� ���������� �����;
        /// </summary>
        /// <param name="SystemName">��������� ��� ������� Storage</param>
        /// <returns>������������� ��������� ������� Storage</returns>
        public int GetStorageAliasByName(string SystemName)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return _reader.GetStorageAliasByName(SystemName);
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetStorageAliasByName() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return 0;
        }

        /// <summary>
        /// ��������� ���������� ������ ADODB.Recordset, ��������������� ������ �� �������� ��������� �������� (��������), ���������������� �������� ����������;
        /// </summary>
        /// <param name="EntityName">��������� ��� ������� Entity (��� ��������� ��������, ���������)</param>
        /// <param name="ItemKey">���� ��������. �������� �������� �������������</param>
        /// <param name="ItemNumber">����� ��������. �������� "0" ������������ null ��� ��������������� ����� ��������� ��������</param>
        /// <returns>ADODB.Recordset. ����� ������ ��������� �������� (���������, ������ EntityData), ��������������� ��������� ��������</returns>
        public ADODB.Recordset GetEntityItem(string EntityName, string ItemKey, int ItemNumber)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return DataSetConverter.DataSetConverter.ConvertToADODBRecordset(_reader.GetEntityItem(EntityName, ItemKey, ItemNumber));
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetEntityItem() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return null;
        }

        /// <summary>
        /// ��������� ���������� ������ ADODB.Recordset, ��������������� ������ �� �������� ��������� �������� (��������), ������� ����������� ��������, ���������������� �������� ����������;
        /// </summary>
        /// <param name="EntityName">��������� ��� ������� Entity (��� ��������� ��������, ���������)</param>
        /// <param name="ItemKey">���� ��������. �������� �������� �������������</param>
        /// <param name="ItemNumber">����� ��������. �������� "0" ������������ null ��� ��������������� ����� ��������� ��������</param>
        /// <returns>ADODB.Recordset. ����� ������ ��������� �������� (���������, ������ EntityData), ������� ������������ ��������, ��������������� ��������� ��������</returns>
        public ADODB.Recordset GetEntityItems(string EntityName, string ItemKey, int ItemNumber)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return DataSetConverter.DataSetConverter.ConvertToADODBRecordset(_reader.GetEntityItems(EntityName, ItemKey, ItemNumber));
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetEntityItems() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return null;
        }

        /// <summary>
        /// ��������� ���������� ������ ADODB.Recordset, ��������������� ������ �� �������� ��������� �������� (�������������), ���������������� �������� ����������;
        /// ������������ ������ �� �������������� ��������� �������� � ���������� ������� ECR �� ��������;
        /// </summary>
        /// <param name="ViewName">��������� ��� ������� View (��� ��������� ��������, �������������)</param>
        /// <param name="ItemKey">���� ��������. �������� �������� �������������</param>
        /// <param name="ItemNumber">����� ��������. �������� "0" ������������ null ��� ��������������� ����� ��������� ��������</param>
        /// <returns>ADODB.Recordset. ����� ������ ��������� �������� (��������������, ������ ViewData), ��������������� ��������� ��������</returns>
        public ADODB.Recordset GetViewItem(string ViewName, string ItemKey, int ItemNumber)
        {
            try
            {
                var _reader = new ECRManagedDataReader(_dataSourceServerName, _connectionTimeout, _commandTimeout, _DEBUG);
                return DataSetConverter.DataSetConverter.ConvertToADODBRecordset(_reader.GetViewItem(ViewName, ItemKey, ItemNumber));
            }
            catch (Exception e)
            {
                LogEvent(string.Format("GetViewItem() call procedure error. Instance ID: '{0}', exception: '{1}'", _INSTANCE_ID, e.Message), "ERROR");
            }
            return null;
        }

        #region ECRManagedComObjects class service procedures

        /// <summary>
        /// ������ ����������� ��������� message � System Event Log.
        /// ��������� ������������ ������ ��� ������� ������������� ����� _DEBUG � ��������� true.
        /// </summary>
        /// <param name="message">������ ����������� ���������</param>
        private void Debug(string message)
        {
            if (_DEBUG)
                LogEvent(string.Format("{0}, INSTANCE ID: {1}", message, _INSTANCE_ID), "INFO");
        }

        /// <summary>
        /// ������������ ��������� message � System Event Log
        /// </summary>
        /// <param name="message">������ ��������� ��� ������������</param>
        /// <param name="type">��� ���������: INFO, WARNING, ERROR</param>
// ReSharper disable MemberCanBeMadeStatic
        private void LogEvent(string message, string type)
// ReSharper restore MemberCanBeMadeStatic
        {        
            try
            {
                switch (type.ToUpper())
                {
                    case "INFO":
                        EventLog.WriteEntry(ToString(), message, EventLogEntryType.Information);
                        break;
                    case "WARNING":
                        EventLog.WriteEntry(ToString(), message, EventLogEntryType.Warning);
                        break;
                    case "ERROR":
                        EventLog.WriteEntry(ToString(), message, EventLogEntryType.Error);
                        break;
                    default:
                        EventLog.WriteEntry(ToString(), message, EventLogEntryType.Information);
                        break;
                }                
            }
            catch (SecurityException secex)
            {
                throw new SecurityException(
                      "Event source does not exist", secex);
            }
        }

        #endregion

    }

}
