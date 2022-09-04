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
        /// Процедура возвращает объект ADODB.Recordset, предоставляющий информацию о наборе всех объектов Binding, доступных в системе ECR;
        /// </summary>
        /// <returns>ADODB.Recordset. Набор данных объектов Binding</returns>
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
        /// Процедура возвращает объект ADODB.Recordset, предоставляющий информацию об объекте Binding с заданным именем;
        /// </summary>
        /// <param name="SystemName">Системное имя объекта Binding</param>
        /// <returns>ADODB.Recordset. Набор данных объекта Binding</returns>
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
        /// Процедура возвращает имя объекта Binding по его целочисленному псевдониму;
        /// </summary>
        /// <param name="DisplayAlias">Целочисленный псевдоним для объекта Binding</param>
        /// <returns>String. Системное имя объекта Binding</returns>
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
        /// Процедура возвращает целочисленный псевдоним объекта Binding по его системному имени
        /// </summary>
        /// <param name="SystemName">Системное имя для объекта Binding</param>
        /// <returns>Integer. Целочисленный псевдоним объекта Binding</returns>
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
        /// Процедра возвращает признак существования объекта Binding с заданным именем в конфигурационном хранилище системы ECR;
        /// </summary>
        /// <param name="SystemName">Системное имя для объекта Binding</param>
        /// <returns>Bool. Признак существования объекта Binding</returns>
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
        /// Процедура возвращает объект ADODB.Recordset, предоставляющий информацию о наборе всех объектов Entity, доступных в системе ECR;
        /// </summary>
        /// <returns>ADODB.Recordset. Набор данных объектов Entitiy</returns>
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
        /// Процедура возвращает объект ADODB.Recordset, предоставляющий информацию о наборе всех объектов Entity, доступных в системе ECR и имеющих привязку к объекту Binding с заданным именем;
        /// </summary>
        /// <param name="BindingName">Системное имя объекта Binding, для которого заданы объекты Entity</param>
        /// <returns>ADODB.Recordset. Набор данных объектов Entitiy</returns>
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
        /// Процедура возвращает объект ADODB.Recordset, предоставляющий информацию об объекте Entity с заданным именем;
        /// </summary>
        /// <param name="SystemName">Системное имя для объекта Entity</param>
        /// <returns>ADODB.Recordset. Набор данных объекта Entity</returns>
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
        /// Процедра возвращает признак существования объекта Entity с заданным именем в конфигурационном хранилище системы ECR;
        /// </summary>
        /// <param name="SystemName">Системное имя для обекта Entity</param>
        /// <returns>Bool. Признак существования объекта Entity</returns>
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
        /// Процедура возвращает признак множественности для объекта Entity с заданным системным именем;
        /// </summary>
        /// <param name="SystemName">Системное имя для объекта Entity</param>
        /// <returns>Bool. Признак множественности бъекта Entity с заданным системным именем</returns>
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
        /// Процедура возвращает системное имя для объекта Entity с заданным сцелочисленным псевдонимом;
        /// </summary>
        /// <param name="DisplayAlias">Целочисленный псевдоним для объекта Entity</param>
        /// <returns>String. Системное имя объекта Entity</returns>
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
        /// Процедура возвращает целочисленный псевдоним для объекта Entity с заданным системным именем;
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns>Integer. Целочисленный псевдоним для объекта Entity</returns>
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
        /// Процедура возвращает объект ADODB.Recordset, предоставляющий информацию об объектах View, доступных в конфигурационном хранилище системы ECR;
        /// </summary>
        /// <param name="Enabled">Признак доступности объектов View (true/false)</param>
        /// <returns>ADODB.Recordset. Набор данных бъектов View</returns>
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
        /// Процедура возвращает объект ADODB.Recordset, предоставляющий информацию об объектах View, доступных в конфигурационном хранилище системы ECR
        ///     и имеющих привязку к объекту Binding через родительский объект Entity;
        /// </summary>
        /// <param name="BindingName">Системное имя объекта Binding, к которому имеют приязку объекты View</param>
        /// <param name="Enabled">Признак доступности объектов View (true/false)</param>
        /// <returns>ADODB.Recordset. Набор данных объектов View</returns>
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
        /// Процедура возвращает объект ADODB.Recordset, предоставляющий информацию об объектах View, доступных в конфигурационном хранилище системы ECR
        ///     и являющихся наследниками объекта Entity с заданным системным именем;
        /// </summary>
        /// <param name="EntityName">Системное имя объекта Entity, являющегося родителем для объектов View</param>
        /// <param name="Enabled">Признак доступности объектов View (true/false)</param>
        /// <returns>ADODB.Recordset. Набор данных объектов View</returns>
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
        /// Процедура возвращает объект ADODB.Recordset, предоставляющий информацию об оьъекте View с заданным системным именем;
        /// </summary>
        /// <param name="SystemName">Системное имя для объекта View</param>
        /// <returns>ADODB.Recordset. Набор данных объекта View</returns>
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
        /// Процедура возвращает системное имя для объекта View с заданным целочисленным псевдонимом;
        /// </summary>
        /// <param name="DisplayAlias">Целочисленный псевдоним для объекта View</param>
        /// <returns>String. Системное имя объекта View</returns>
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
        /// Процедура возвращает целочисленный псевдоним для объекта View с заданным системным;
        /// </summary>
        /// <param name="SystemName">Системное имя для объекта View</param>
        /// <returns>Integer. Целочисленный псевдоним объекта View</returns>
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
        /// Процедра возвращает признак существования объекта Vew с заданным именем в конфигурационном хранилище системы ECR;
        /// </summary>
        /// <param name="SystemName">Системное имя для объекта View</param>
        /// <returns>Bool. Признак существования объекта View с заданным системным именем</returns>
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
        /// Процедура возвращает признак доступности объекта View с заданным системным именем в конфигурационном хранилище системы ECR;
        /// </summary>
        /// <param name="SystemName">Системное имя для объекта View</param>
        /// <returns>Bool. Признак доступности объекта View с заданным системным именем</returns>
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
        /// Процедура осуществляет проверку признака множественности объекта View с заданным системным именем;
        /// </summary>
        /// <param name="SystemName">Системное имя для объекта View</param>
        /// <returns>Bool. Признак множественности объекта View с заданным системным именем</returns>
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
        /// Процедура возвращает объект ADODB.Recordset, предоставляющий информацию об объектах Storage, зарегистрированных в конфигурационном хранилище системы ECR;
        /// </summary>
        /// <returns>ADODB.Recordset. Набор данных объектов Storage</returns>
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
        /// Процедура возвращает объект ADODB.Recordset, предоставляющий информацию об объекте Storage с заданным системным именем;
        /// </summary>
        /// <param name="SystemName">Системное имя доя объекта Storage</param>
        /// <returns>ADODB.Recordset. Набор данных объекта Storage с заданным системным именем</returns>
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
        /// Процедура возвращает объект ADODB.Recordset, предоставляющий информацию об объекте Storage, к которому имеет привязку объект Entity с заданным системным именем;
        /// </summary>
        /// <param name="EntityName">Системное имя объекта Entity</param>
        /// <returns>ADODB.Recordset. Набор данных объекта Storage</returns>
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
        /// Процедура возвращает объект ADODB.Recordset, предоставляющий информацию об объекте Storage, к которому имеет привязку объект View с заданным системным именем;
        /// </summary>
        /// <param name="ViewName">Системное имя объекта View</param>
        /// <returns>ADODB.Recordset. Набор данных объекта Storage</returns>
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
        /// Процедура возвращает признак существования объекта Storage с заданным системным именем;
        /// </summary>
        /// <param name="SystemName">Системное имя объекта Storage</param>
        /// <returns>Bool. Признак существования объекта Storage с заданным системным именем</returns>
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
        /// Процедура возвращает системное имя объекта Storage по его целочисленному псевдониму;
        /// </summary>
        /// <param name="DisplayAlias">Целочисленный псевдоним объекта Storage</param>
        /// <returns>String. Системное имя объекта Storage</returns>
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
        /// Процедура возвращает целочисленный псевдоним объекта Storage по его системному имени;
        /// </summary>
        /// <param name="SystemName">Системное имя объекта Storage</param>
        /// <returns>Целочисленный псевдоним объекта Storage</returns>
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
        /// Процедура возвращает объект ADODB.Recordset, предоставляющий данные об элементе файлового контента (оригинал), соответствующему заданным параметрам;
        /// </summary>
        /// <param name="EntityName">Системное имя объекта Entity (тип файлового контента, оригиналы)</param>
        /// <param name="ItemKey">Ключ элемента. Основной параметр идентификации</param>
        /// <param name="ItemNumber">Номер элемента. Значение "0" эквивалентно null для немножественных типов файлового контента</param>
        /// <returns>ADODB.Recordset. Набор данных файлового контента (оригиналы, объект EntityData), соответствующий заданному элементу</returns>
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
        /// Процедура возвращает объект ADODB.Recordset, предоставляющий данные об элементе файлового контента (оригинал), включая истоические элементы, соответствующему заданным параметрам;
        /// </summary>
        /// <param name="EntityName">Системное имя объекта Entity (тип файлового контента, оригиналы)</param>
        /// <param name="ItemKey">Ключ элемента. Основной параметр идентификации</param>
        /// <param name="ItemNumber">Номер элемента. Значение "0" эквивалентно null для немножественных типов файлового контента</param>
        /// <returns>ADODB.Recordset. Набор данных файлового контента (оригиналы, объект EntityData), включая исторические элементы, соответствующий заданному элементу</returns>
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
        /// Процедура возвращает объект ADODB.Recordset, предоставляющий данные об элементе файлового контента (представление), соответствующему заданным параметрам;
        /// Исторические данные по представлениям файлового контента в хранилищах системы ECR не хранятся;
        /// </summary>
        /// <param name="ViewName">Системное имя объекта View (тип файлового контента, представления)</param>
        /// <param name="ItemKey">Ключ элемента. Основной параметр идентификации</param>
        /// <param name="ItemNumber">Номер элемента. Значение "0" эквивалентно null для немножественных типов файлового контента</param>
        /// <returns>ADODB.Recordset. Набор данных файлового контента (представляения, объект ViewData), соответствующий заданному элементу</returns>
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
        /// Запись отладочного сообщения message в System Event Log.
        /// Процедура отрабатывает только при наличии выставленного флага _DEBUG в состояние true.
        /// </summary>
        /// <param name="message">Строка отладочного сообщения</param>
        private void Debug(string message)
        {
            if (_DEBUG)
                LogEvent(string.Format("{0}, INSTANCE ID: {1}", message, _INSTANCE_ID), "INFO");
        }

        /// <summary>
        /// Логгирование сообщения message в System Event Log
        /// </summary>
        /// <param name="message">Строка сообщения для логгирования</param>
        /// <param name="type">Тип сообщения: INFO, WARNING, ERROR</param>
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
