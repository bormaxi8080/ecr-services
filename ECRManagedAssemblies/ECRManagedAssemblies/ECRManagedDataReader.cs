using System;
using System.Data;
using System.Data.SqlClient;

namespace ECRManagedAssemblies
{

    /// <summary>
    /// ECRManagedDataReader class provides access to read ECR storage data in .net client applications
    /// </summary>
    public class ECRManagedDataReader
    {

#pragma warning disable 219
// ReSharper disable UnaccessedField.Local
// ReSharper disable InconsistentNaming
        private readonly bool _DEBUG;
// ReSharper restore InconsistentNaming
// ReSharper restore UnaccessedField.Local
#pragma warning restore 219

// ReSharper disable InconsistentNaming
        private const string TEMPLATE_CONNECTION_STRING = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=ECR_Config;Data Source=<%DataSource%>;Connection Timeout=<%ConnectionTimeout%>";
#pragma warning disable 169
        private const int DEFAULT_COMMAND_TIMEOUT = 600;
#pragma warning restore 169

        private string _connectionString;
        private int _connectionTimeout;
        private int _commandTimeout;
// ReSharper restore InconsistentNaming

        #region ECRManagedDataReader class constructor

        /// <summary>
        /// ECRManagedDataReader class constructor
        /// </summary>
        /// <param name="BaseServerName"></param>
        /// <param name="ConnectionTimeout"></param>
        /// <param name="CommandTimeout"></param>
        public ECRManagedDataReader(string BaseServerName, int ConnectionTimeout, int CommandTimeout)
        {
            _DEBUG = false;
            Initialize(BaseServerName, ConnectionTimeout, CommandTimeout);
        }

        /// <summary>
        /// ECRManagedDataReader class constructor
        /// </summary>
        /// <param name="BaseServerName"></param>
        /// <param name="ConnectionTimeout"></param>
        /// <param name="CommandTimeout"></param>
        /// <param name="DebugMode"></param>
        public ECRManagedDataReader(string BaseServerName, int ConnectionTimeout, int CommandTimeout, bool DebugMode)
        {
            _DEBUG = DebugMode;
            Initialize(BaseServerName, ConnectionTimeout, CommandTimeout);
        }

        #endregion

        #region ECRManagedDataReader class initialization procedures

        /// <summary>
        /// ECRManagedDataReader class constructor initialization procedure
        /// </summary>
        /// <param name="BaseServerName"></param>
        /// <param name="ConnectionTimeout"></param>
        /// <param name="CommandTimeout"></param>
        private void Initialize(string BaseServerName, int ConnectionTimeout, int CommandTimeout)
        {
            // Define ConnectionString value
            _connectionString = TEMPLATE_CONNECTION_STRING.Replace("<%DataSource%>", BaseServerName).Replace("<%ConnectionTimeout%>", _connectionTimeout.ToString());
            // Define ConnectionTimeout value
            _connectionTimeout = ConnectionTimeout;
            // Define CommandTimeout value
            _commandTimeout = CommandTimeout;
        }

        #endregion

        /// <summary>
        /// Процедура возвращает список привязок сущностей из таблицы ecr.Bindings
        /// </summary>
        /// <returns></returns>
        // ReSharper disable MemberCanBeMadeStatic
        public DataSet GetBindingsList()
        // ReSharper restore MemberCanBeMadeStatic
        {
            var ds = new DataSet();
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                try
                {
                    var cmd = new SqlCommand
                                   {
                                       CommandType = CommandType.StoredProcedure,
                                       CommandTimeout = Convert.ToInt32(_commandTimeout),
                                       CommandText = "[ecr].[GetBindingsList]",
                                       Connection = conn
                                   };
                    var adapter = new SqlDataAdapter(cmd);
                    adapter.Fill(ds, "BindingsList");
                }
                finally
                {
                    conn.Close();
                }
            }
            return ds;
        }

        /// <summary>
        /// Процедура возвращает данные о привызке к сущности по имени из таблицы ecr.Bindings
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns></returns>
        public DataSet GetBinding(string SystemName)
        {
            if (SystemName == null)
                throw new Exception("Binding name is not defined. Please check SystemName parameter value");
            if (!CheckBindingExists(SystemName))
                throw new Exception("Binding does not exists or access denied. Check database access and passed parameters");
            var ds = new DataSet();
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                try
                {
                    var cmd = new SqlCommand
                                   {
                                       CommandType = CommandType.StoredProcedure,
                                       CommandTimeout = Convert.ToInt32(_commandTimeout),
                                       CommandText = "[ecr].[GetBindingByName]",
                                       Connection = conn
                                   };
                    cmd.Parameters.AddWithValue("SystemName", SystemName);
                    var adapter = new SqlDataAdapter(cmd);
                    adapter.Fill(ds, "BindingData");
                }
                finally
                {
                    conn.Close();
                }
            }
            return ds;
        }

        /// <summary>
        /// Процедура возвращает имя объекта Binding по его целочисленному псевдониму;
        /// </summary>
        /// <param name="DisplayAlias">Целочисленный псевдоним для объекта Binding</param>
        /// <returns>String. Системное имя объекта Binding</returns>
        public string GetBindingNameByAlias(int DisplayAlias)
        {
            string result;
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                var cmd = new SqlCommand
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = Convert.ToInt32(_commandTimeout),
                    CommandText = "[ecr].[GetBindingNameByAlias]",
                    Connection = conn
                };
                cmd.Parameters.AddWithValue("DisplayAlias", DisplayAlias);
                conn.Open();
                try
                {
                    var obj = cmd.ExecuteScalar();
                    if (obj == null)
                        throw new Exception(
                            "Binding does not exists or access denied. Check database access and passed parameters");
                    result = obj.ToString();
                }
                finally
                {
                    conn.Close();
                }
            }
            return result;
        }
        
        /// <summary>
        /// Процедура возвращает целочисленный псевдоним объекта Binding по его системному имени
        /// </summary>
        /// <param name="SystemName">Системное имя для объекта Binding</param>
        /// <returns>Integer. Целочисленный псевдоним объекта Binding</returns>
        public int GetBindingAliasByName(string SystemName)
        {
            int result;
            if (SystemName == null)
                throw new Exception("Binding name is not defined. Please check SystemName parameter value");
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                var cmd = new SqlCommand
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = Convert.ToInt32(_commandTimeout),
                    CommandText = "[ecr].[GetBindingAliasByName]",
                    Connection = conn
                };
                cmd.Parameters.AddWithValue("SystemName", SystemName);
                conn.Open();
                try
                {
                    var obj = cmd.ExecuteScalar();
                    if (obj == null)
                        throw new Exception(
                            "Binding does not exists or access denied. Check database access and passes parameters");
                    result = Convert.ToInt32(obj);
                }
                finally
                {
                    conn.Close();
                }
            }
            return result;
        }
        
        /// <summary>
        /// Процедра возвращает признак существования объекта Binding с заданным именем в конфигурационном хранилище системы ECR;
        /// </summary>
        /// <param name="SystemName">Системное имя для объекта Binding</param>
        /// <returns>Bool. Признак существования объекта Binding</returns>
        public bool CheckBindingExists(string SystemName)
        {
            bool result;
            if (SystemName == null)
                throw new Exception("Binding name is not defined. Please check SystemName parameter value");
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                var cmd = new SqlCommand
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = Convert.ToInt32(_commandTimeout),
                    CommandText = "[ecr].[CheckBindingExists]",
                    Connection = conn
                };
                cmd.Parameters.AddWithValue("SystemName", SystemName);
                var output = cmd.Parameters.Add("@Exists", SqlDbType.Int);
                output.Direction = ParameterDirection.Output;
                conn.Open();
                try
                {
                    cmd.ExecuteNonQuery();
                    result = Convert.ToBoolean(output.Value);
                }
                finally
                {
                    conn.Close();
                }
            }
            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public DataSet GetEntityList()
        {
            var ds = new DataSet();
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                try
                {
                    var cmd = new SqlCommand
                                   {
                                       CommandType = CommandType.StoredProcedure,
                                       CommandTimeout = Convert.ToInt32(_commandTimeout),
                                       CommandText = "[ecr].[GetEntityList]",
                                       Connection = conn
                                   };
                    cmd.Parameters.AddWithValue("BindingID", DBNull.Value);
                    var adapter = new SqlDataAdapter(cmd);
                    adapter.Fill(ds, "EntityList");
                }
                finally
                {
                    conn.Close();
                }
            }
            return ds;
        }
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="BindingName"></param>
        /// <returns></returns>
        public DataSet GetEntityListByBinding(string BindingName)
        {
            var ds = new DataSet();
            if (BindingName == null)
                throw new Exception("Binding name is not defined. Please check SystemName parameter value");
            if (!CheckBindingExists(BindingName))
                throw new Exception("Binding does not exists or access denied. Check database access and passed parameters");
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                try
                {
                    var cmd = new SqlCommand
                                   {
                                       CommandType = CommandType.StoredProcedure,
                                       CommandTimeout = Convert.ToInt32(_commandTimeout),
                                       CommandText = "[ecr].[GetEntityList]",
                                       Connection = conn
                                   };
                    cmd.Parameters.AddWithValue("BindingName", BindingName);
                    var adapter = new SqlDataAdapter(cmd);
                    adapter.Fill(ds, "EntityList");
                }
                finally
                {
                    conn.Close();
                }
            }
            return ds;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns></returns>
        public DataSet GetEntity(string SystemName)
        {
            var ds = new DataSet();
            if (SystemName == null)
                throw new Exception("Entity name is not defined. Please check SystemName parameter value");
            if (!CheckEntityExists(SystemName))
                throw new Exception("Entity does not exists or access denied. Check database access and passed parameters");
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                try
                {
                    var cmd = new SqlCommand
                                   {
                                       CommandType = CommandType.StoredProcedure,
                                       CommandTimeout = Convert.ToInt32(_commandTimeout),
                                       CommandText = "[ecr].[GetEntityByName]",
                                       Connection = conn
                                   };
                    cmd.Parameters.AddWithValue("SystemName", SystemName);
                    var adapter = new SqlDataAdapter(cmd);
                    adapter.Fill(ds, "EntityData");
                }
                finally
                {
                    conn.Close();
                }
            }
            return ds;
        }
        
        /// <summary>
        /// Процедра возвращает признак существования объекта Entity с заданным именем в конфигурационном хранилище системы ECR;
        /// </summary>
        /// <param name="SystemName">Системное имя для обекта Entity</param>
        /// <returns>Bool. Признак существования объекта Entity</returns>
        public bool CheckEntityExists(string SystemName)
        {
            bool result;
            if (SystemName == null)
                throw new Exception("Entity name is not defined. Please check SystemName parameter value");
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                var cmd = new SqlCommand
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = Convert.ToInt32(_commandTimeout),
                    CommandText = "[ecr].[CheckEntityExists]",
                    Connection = conn
                };
                cmd.Parameters.AddWithValue("SystemName", SystemName);
                var output = cmd.Parameters.Add("@Exists", SqlDbType.Int);
                output.Direction = ParameterDirection.Output;
                conn.Open();
                try
                {
                    cmd.ExecuteNonQuery();
                    result = Convert.ToBoolean(output.Value);
                }
                finally
                {
                    conn.Close();
                }
            }
            return result;
        }

        /// <summary>
        /// Процедура возвращает признак множественности для объекта Entity с заданным системным именем;
        /// </summary>
        /// <param name="SystemName">Системное имя для объекта Entity</param>
        /// <returns>Bool. Признак множественности бъекта Entity с заданным системным именем</returns>
        public bool IsEntityMultiplied(string SystemName)
        {
            bool result;
            if (SystemName == null)
                throw new Exception("Entity name is not defined. Please check SystemName parameter value");
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                var cmd = new SqlCommand
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = Convert.ToInt32(_commandTimeout),
                    CommandText = "[ecr].[IsEntityMultiplied]",
                    Connection = conn
                };
                cmd.Parameters.AddWithValue("SystemName", SystemName);
                conn.Open();
                try
                {
                    var obj = cmd.ExecuteScalar();
                    if (obj == null)
                        throw new Exception("Entity does not exists or access denied. Check database access and passed parameters");
                    result = Convert.ToBoolean(obj);
                }
                finally
                {
                    conn.Close();
                }
            }
            return result;
        }

        /// <summary>
        /// Процедура возвращает системное имя для объекта Entity с заданным сцелочисленным псевдонимом;
        /// </summary>
        /// <param name="DisplayAlias">Целочисленный псевдоним для объекта Entity</param>
        /// <returns>String. Системное имя объекта Entity</returns>
        public string GetEntityNameByAlias(int DisplayAlias)
        {
            string result;
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                var cmd = new SqlCommand
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = Convert.ToInt32(_commandTimeout),
                    CommandText = "[ecr].[GetEntityNameByAlias]",
                    Connection = conn
                };
                cmd.Parameters.AddWithValue("DisplayAlias", DisplayAlias);
                conn.Open();
                try
                {
                    var obj = cmd.ExecuteScalar();
                    if (obj == null)
                        throw new Exception("Entity does not exists or access denied. Check database access and passed parameters");
                    result = obj.ToString();
                }
                finally
                {
                    conn.Close();
                }
            }
            return result;
        }

        /// <summary>
        /// Процедура возвращает целочисленный псевдоним для объекта Entity с заданным системным именем;
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns>Integer. Целочисленный псевдоним для объекта Entity</returns>
        public int GetEntityAliasByName(string SystemName)
        {
            int result;
            if (SystemName == null)
                throw new Exception("Entity name is not defined. Please check SystemName parameter value");
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                var cmd = new SqlCommand
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = Convert.ToInt32(_commandTimeout),
                    CommandText = "[ecr].[GetEntityAliasByName]",
                    Connection = conn
                };
                cmd.Parameters.AddWithValue("SystemName", SystemName);
                conn.Open();
                try
                {
                    var obj = cmd.ExecuteScalar();
                    if (obj == null)
                        throw new Exception("Entity does not exists or access denied. Check database access and passed parameters");
                    result = Convert.ToInt32(obj);
                }
                finally
                {
                    conn.Close();
                }
            }
            return result;
        }
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="Enabled"></param>
        /// <returns></returns>
        public DataSet GetViewList(bool Enabled)
        {
            var ds = new DataSet();
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                try
                {
                    var cmd = new SqlCommand
                                   {
                                       CommandType = CommandType.StoredProcedure,
                                       CommandTimeout = Convert.ToInt32(_commandTimeout),
                                       CommandText = "[ecr].[GetViewList]",
                                       Connection = conn
                                   };
                    cmd.Parameters.AddWithValue("EntityParent", DBNull.Value);
                    cmd.Parameters.AddWithValue("Enabled", Enabled);
                    var adapter = new SqlDataAdapter(cmd);
                    adapter.Fill(ds, "ViewList");
                }
                finally
                {
                    conn.Close();
                }
            }
            return ds;
        }
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="BindingName"></param>
        /// <param name="Enabled"></param>
        /// <returns></returns>
        public DataSet GetViewListByBinding(string BindingName, bool Enabled)
        {
            var ds = new DataSet();
            if (BindingName == null)
                throw new Exception("Binding name is not defined. Please check BindingName parameter value");
            if (!CheckBindingExists(BindingName))
                throw new Exception("Binding does not exists or access denied. Check database access and passed parameters");
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                try
                {
                    var cmd = new SqlCommand
                                   {
                                       CommandType = CommandType.StoredProcedure,
                                       CommandTimeout = Convert.ToInt32(_commandTimeout),
                                       CommandText = "[ecr].[GetViewListByBinding]",
                                       Connection = conn
                                   };
                    cmd.Parameters.AddWithValue("BindingName", BindingName);
                    cmd.Parameters.AddWithValue("Enabled", Enabled);
                    var adapter = new SqlDataAdapter(cmd);
                    adapter.Fill(ds, "ViewList");
                }
                finally
                {
                    conn.Close();
                }
            }
            return ds;
        }
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="EntityName"></param>
        /// <param name="Enabled"></param>
        /// <returns></returns>
        public DataSet GetViewListByEntity(string EntityName, bool Enabled)
        {
            var ds = new DataSet();
            if (EntityName == null)
                throw new Exception("Entity name is not defined. Please check EntityName parameter value");
            if (!CheckEntityExists(EntityName))
                throw new Exception("Entity does not exists or access denied. Check database access and passed parameters");
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                try
                {
                    var cmd = new SqlCommand
                                   {
                                       CommandType = CommandType.StoredProcedure,
                                       CommandTimeout = Convert.ToInt32(_commandTimeout),
                                       CommandText = "[ecr].[GetViewList]",
                                       Connection = conn
                                   };
                    cmd.Parameters.AddWithValue("EntityParent", EntityName);
                    cmd.Parameters.AddWithValue("Enabled", Enabled);
                    var adapter = new SqlDataAdapter(cmd);
                    adapter.Fill(ds, "ViewList");
                }
                finally
                {
                    conn.Close();
                }
            }
            return ds;
        }
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns></returns>
        public DataSet GetView(string SystemName)
        {
            var ds = new DataSet();
            if (SystemName == null)
                throw new Exception("View name is not defined. Please check SystemName parameter value");
            if (!CheckViewExists(SystemName))
                throw new Exception("View does not exists or access denied. Check database access and passed parameters");
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                try
                {
                    var cmd = new SqlCommand
                                   {
                                       CommandType = CommandType.StoredProcedure,
                                       CommandTimeout = Convert.ToInt32(_commandTimeout),
                                       CommandText = "[ecr].[GetViewByName]",
                                       Connection = conn
                                   };
                    cmd.Parameters.AddWithValue("SystemName", SystemName);
                    var adapter = new SqlDataAdapter(cmd);
                    adapter.Fill(ds, "ViewData");
                }
                finally
                {
                    conn.Close();
                }
            }
            return ds;
        }
        
        /// <summary>
        /// Процедура возвращает системное имя для объекта View с заданным целочисленным псевдонимом;
        /// </summary>
        /// <param name="DisplayAlias">Целочисленный псевдоним для объекта View</param>
        /// <returns>String. Системное имя объекта View</returns>
        public string GetViewNameByAlias(int DisplayAlias)
        {
            string result;
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                var cmd = new SqlCommand
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = Convert.ToInt32(_commandTimeout),
                    CommandText = "[ecr].[GetViewNameByAlias]",
                    Connection = conn
                };
                cmd.Parameters.AddWithValue("DisplayAlias", DisplayAlias);
                conn.Open();
                try
                {
                    var obj = cmd.ExecuteScalar();
                    if (obj == null)
                        throw new Exception("View does not exists or access denied. Check database access and passed parameters");
                    result = obj.ToString();
                }
                finally
                {
                    conn.Close();
                }
            }
            return result;
        }

        /// <summary>
        /// Процедура возвращает целочисленный псевдоним для объекта View с заданным системным;
        /// </summary>
        /// <param name="SystemName">Системное имя для объекта View</param>
        /// <returns>Integer. Целочисленный псевдоним объекта View</returns>
        public int GetViewAliasByName(string SystemName)
        {
            int result;
            if (SystemName == null)
                throw new Exception("View name is not defined. Please check SystemName parameter value");
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                var cmd = new SqlCommand
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = Convert.ToInt32(_commandTimeout),
                    CommandText = "[ecr].[GetViewAliasByName]",
                    Connection = conn
                };
                cmd.Parameters.AddWithValue("SystemName", SystemName);
                conn.Open();
                try
                {
                    var obj = cmd.ExecuteScalar();
                    if (obj == null)
                        throw new Exception("View does not exists or access denied. Check database access and passed parameters");
                    result = Convert.ToInt32(obj);
                }
                finally
                {
                    conn.Close();
                }
            }
            return result;
        }

        /// <summary>
        /// Процедра возвращает признак существования объекта Vew с заданным именем в конфигурационном хранилище системы ECR;
        /// </summary>
        /// <param name="SystemName">Системное имя для объекта View</param>
        /// <returns>Bool. Признак существования объекта View с заданным системным именем</returns>
        public bool CheckViewExists(string SystemName)
        {
            bool result;
            if (SystemName == null)
                throw new Exception("View name is not defined. Please check SystemName parameter value");
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                var cmd = new SqlCommand
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = Convert.ToInt32(_commandTimeout),
                    CommandText = "[ecr].[CheckViewExists]",
                    Connection = conn
                };
                cmd.Parameters.AddWithValue("SystemName", SystemName);
                var output = cmd.Parameters.Add("@Exists", SqlDbType.Int);
                output.Direction = ParameterDirection.Output;
                conn.Open();
                try
                {
                    cmd.ExecuteNonQuery();
                    result = Convert.ToBoolean(output.Value);
                }
                finally
                {
                    conn.Close();
                }
            }
            return result;
        }

        /// <summary>
        /// Процедура возвращает признак доступности объекта View с заданным системным именем в конфигурационном хранилище системы ECR;
        /// </summary>
        /// <param name="SystemName">Системное имя для объекта View</param>
        /// <returns>Bool. Признак доступности объекта View с заданным системным именем</returns>
        public bool IsViewEnabled(string SystemName)
        {
            bool result;
            if (SystemName == null)
                throw new Exception("View name is not defined. Please check SystemName parameter value");
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                var cmd = new SqlCommand
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = Convert.ToInt32(_commandTimeout),
                    CommandText = "[ecr].[IsViewEnabled]",
                    Connection = conn
                };
                cmd.Parameters.AddWithValue("SystemName", SystemName);
                conn.Open();
                try
                {
                    var obj = cmd.ExecuteScalar();
                    if (obj == null)
                        throw new Exception("View does not exists or access denied. Check database access and passed parameters");
                    result = Convert.ToBoolean(obj);
                }
                finally
                {
                    conn.Close();
                }
            }
            return result;
        }

        /// <summary>
        /// Процедура осуществляет проверку признака множественности объекта View с заданным системным именем;
        /// </summary>
        /// <param name="SystemName">Системное имя для объекта View</param>
        /// <returns>Bool. Признак множественности объекта View с заданным системным именем</returns>
        public bool IsViewMultiplied(string SystemName)
        {
            bool result;
            if (SystemName == null)
                throw new Exception("View name is not defined. Please check SystemName parameter value");
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                var cmd = new SqlCommand
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = Convert.ToInt32(_commandTimeout),
                    CommandText = "[ecr].[IsViewMultiplied]",
                    Connection = conn
                };
                cmd.Parameters.AddWithValue("SystemName", SystemName);
                conn.Open();
                try
                {
                    var obj = cmd.ExecuteScalar();
                    if (obj == null)
                        throw new Exception("View does not exists or access denied. Check database access and passed parameters");
                    result = Convert.ToBoolean(obj);
                }
                finally
                {
                    conn.Close();
                }
            }
            return result;
        }

        /// <summary>
        /// Процедура возвращает список баз данных хранилищ файлового контента
        /// </summary>
        /// <returns>DataSet. Список баз данных хранилищ файлового контента</returns>
        public DataSet GetStorageList()
        {
            var ds = new DataSet();
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                try
                {
                    var cmd = new SqlCommand
                                   {
                                       CommandType = CommandType.StoredProcedure,
                                       CommandTimeout = Convert.ToInt32(_commandTimeout),
                                       CommandText = "[ecr].[GetStorageList]",
                                       Connection = conn
                                   };
                    var adapter = new SqlDataAdapter(cmd);
                    adapter.Fill(ds, "StorageList");
                }
                finally
                {
                    conn.Close();
                }
            }
            return ds;
        }
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns></returns>
        public DataSet GetStorage(string SystemName)
        {
            var ds = new DataSet();
            if (SystemName == null)
                throw new Exception("Storage name is not defined. Please check SystemName parameter value");
            if (!CheckStorageExists(SystemName))
                throw new Exception("Storage does not exists or access denied. Check database access and passed parameters");
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                try
                {
                    var cmd = new SqlCommand
                                   {
                                       CommandType = CommandType.StoredProcedure,
                                       CommandTimeout = Convert.ToInt32(_commandTimeout),
                                       CommandText = "[ecr].[GetStorageByName]",
                                       Connection = conn
                                   };
                    cmd.Parameters.AddWithValue("SystemName", SystemName);
                    var adapter = new SqlDataAdapter(cmd);
                    adapter.Fill(ds, "StorageData");
                }
                finally
                {
                    conn.Close();
                }
            }
            return ds;
        }

        /// <summary>
        /// Процедура возвращает данные о хранилище файлового контента для заданного типа контента
        /// </summary>
        /// <param name="EntityName">Системное имя представления контента</param>
        /// <returns>DataSet. Даные о хранилище файлового контента</returns>
        public DataSet GetStorageForEntity(string EntityName)
        {
            var ds = new DataSet();
            if (EntityName == null)
                throw new Exception("Entity name is not defined. Please check EntityName parameter value");
            if (!CheckEntityExists(EntityName))
                throw new Exception("Entity does not exists or access denied. Check database access and passed parameters");
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                try
                {
                    var cmd = new SqlCommand
                                   {
                                       CommandType = CommandType.StoredProcedure,
                                       CommandTimeout = Convert.ToInt32(_commandTimeout),
                                       CommandText = "[ecr].[GetStorageForEntity]",
                                       Connection = conn
                                   };
                    cmd.Parameters.AddWithValue("EntityName", EntityName);
                    var adapter = new SqlDataAdapter(cmd);
                    adapter.Fill(ds, "StorageData");
                }
                finally
                {
                    conn.Close();
                }
            }
            return ds;
        }

        /// <summary>
        /// Процедура возвращает данные о хранилище файлового контента для заданного представления контента
        /// </summary>
        /// <param name="ViewName">Системное имя представления контента</param>
        /// <returns>DataSet. Даные о хранилище файлового контента</returns>
        public DataSet GetStorageForView(string ViewName)
        {
            var ds = new DataSet();
            if (ViewName == null)
                throw new Exception("View name is not defined. Please check ViewName parameter value");
            if (!CheckViewExists(ViewName))
                throw new Exception("View does not exists or access denied. Check database access and passed parameters");
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                try
                {
                    var cmd = new SqlCommand
                                   {
                                       CommandType = CommandType.StoredProcedure,
                                       CommandTimeout = Convert.ToInt32(_commandTimeout),
                                       CommandText = "[ecr].[GetStorageForView]",
                                       Connection = conn
                                   };
                    cmd.Parameters.AddWithValue("ViewName", ViewName);
                    var adapter = new SqlDataAdapter(cmd);
                    adapter.Fill(ds, "StorageData");
                }
                finally
                {
                    conn.Close();
                }
            }
            return ds;
        }
        
        /// <summary>
        /// Процедура возвращает признак существования объекта Storage с заданным системным именем;
        /// </summary>
        /// <param name="SystemName">Системное имя объекта Storage</param>
        /// <returns>Bool. Признак существования объекта Storage с заданным системным именем</returns>
        public bool CheckStorageExists(string SystemName)
        {
            bool result;
            if (SystemName == null)
                throw new Exception("Storage name is not defined.  Please check SystemName parameter value");
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                var cmd = new SqlCommand
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = Convert.ToInt32(_commandTimeout),
                    CommandText = "[ecr].[CheckStorageExists]",
                    Connection = conn
                };
                cmd.Parameters.AddWithValue("SystemName", SystemName);
                var output = cmd.Parameters.Add("@Exists", SqlDbType.Int);
                output.Direction = ParameterDirection.Output;
                conn.Open();
                try
                {
                    cmd.ExecuteNonQuery();
                    result = Convert.ToBoolean(output.Value);
                }
                finally
                {
                    conn.Close();
                }
            }
            return result;
        }

        /// <summary>
        /// Процедура возвращает системное имя объекта Storage по его целочисленному псевдониму;
        /// </summary>
        /// <param name="DisplayAlias">Целочисленный псевдоним объекта Storage</param>
        /// <returns>String. Системное имя объекта Storage</returns>
        public string GetStorageNameByAlias(int DisplayAlias)
        {
            string result;
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                var cmd = new SqlCommand
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = Convert.ToInt32(_commandTimeout),
                    CommandText = "[ecr].[GetStorageNameByAlias]",
                    Connection = conn
                };
                cmd.Parameters.AddWithValue("DisplayAlias", DisplayAlias);
                conn.Open();
                try
                {
                    var obj = cmd.ExecuteScalar();
                    if (obj == null)
                        throw new Exception("Storage does not exists or access denied. Check database access and passed parameters");
                    result = obj.ToString();
                }
                finally
                {
                    conn.Close();
                }
            }
            return result;
        }

        /// <summary>
        /// Процедура возвращает целочисленный псевдоним объекта Storage по его системному имени;
        /// </summary>
        /// <param name="SystemName">Системное имя объекта Storage</param>
        /// <returns>Целочисленный псевдоним объекта Storage</returns>
        public int GetStorageAliasByName(string SystemName)
        {
            int result;
            if (SystemName == null)
                throw new Exception("Storage name is not defined.  Please check SystemName parameter value");
            using(var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                var cmd = new SqlCommand
                {
                    CommandType = CommandType.StoredProcedure,
                    CommandTimeout = Convert.ToInt32(_commandTimeout),
                    CommandText = "[ecr].[GetStorageAliasByName]",
                    Connection = conn
                };
                cmd.Parameters.AddWithValue("SystemName", SystemName);
                conn.Open();
                try
                {
                    var obj = cmd.ExecuteScalar();
                    if (obj == null)
                        throw new Exception("Storage does not exists or access denied. Check database access and passed parameters");
                    result = Convert.ToInt32(obj);
                }
                finally
                {
                    conn.Close();
                }
            }
            return result;
        }

        /// <summary>
        /// Процедура возвращает данные об оригинале файлового контента, соответствующего заданной позиции
        /// </summary>
        /// <param name="EntityName">Системное имя сущности для файлового контента</param>
        /// <param name="ItemKey">Ключ позиции</param>
        /// <param name="ItemNumber">Номер позиции (опционально)</param>
        /// <returns>DataSet. Данные об оригинале файлового контента</returns>
        public DataSet GetEntityItem(string EntityName, string ItemKey, int? ItemNumber)
        {
            var ds = new DataSet();
            
            if (EntityName == null)
                throw new Exception("Entity name is not defined.  Please check EntityName parameter value");
            if (ItemKey == null)
                throw new Exception("ItemKey parameter value is not defined.  Please check ItemKey parameter value");
            if (!CheckEntityExists(EntityName))
                throw new Exception("Entity does not exists or access denied. Check database access and passed parameters");

            var dsStorage = GetStorageForEntity(EntityName);
            if (dsStorage.Tables["StorageData"].Rows.Count != 1)
                throw new Exception("Storage does not exists for this entity, storage definition error or access denied");

            using(var conn = new SqlConnection())
            {
                try
                {
                    var etr = dsStorage.Tables[0].Rows.GetEnumerator();
                    // TODO: этот код можно упростить!
                    while (etr.MoveNext())
                    {
                        var row = (DataRow) etr.Current;
                        conn.ConnectionString = row["ConnectionString"].ToString();
                    }
                    var cmd = new SqlCommand
                                   {
                                       CommandType = CommandType.StoredProcedure,
                                       CommandTimeout = Convert.ToInt32(_commandTimeout),
                                       CommandText = "[ecr].[GetEntityItem]",
                                       Connection = conn
                                   };
                    cmd.Parameters.AddWithValue("DisplayAlias", GetEntityAliasByName(EntityName));
                    cmd.Parameters.AddWithValue("ItemKey", ItemKey);
                    if (ItemNumber != null)
                    {
                        if (ItemNumber > 0)
                            cmd.Parameters.AddWithValue("ItemNumber", ItemNumber);
                        else
                            cmd.Parameters.AddWithValue("ItemNumber", DBNull.Value);
                    }
                    else
                        cmd.Parameters.AddWithValue("ItemNumber", DBNull.Value);
                    cmd.Parameters.AddWithValue("HistoryIndex", 0);                 // SELECT MAX(HistoryIndex)
                    var adapter = new SqlDataAdapter(cmd);
                    adapter.Fill(ds, "ItemData");
                }
                finally
                {
                    conn.Close();
                }
            }
            
            return ds;
        }

        /// <summary>
        /// Процедура возвращает данные об оригиналах файлового контента, соответствующих заданной позиции
        /// </summary>
        /// <param name="EntityName">Системное имя сущности для файлового контента</param>
        /// <param name="ItemKey">Ключ позиции</param>
        /// <param name="ItemNumber">Номер позиции (опционально)</param>
        /// <returns>DataSet. Данные об оригиналах файлового контента</returns>
        public DataSet GetEntityItems(string EntityName, string ItemKey, int? ItemNumber)
        {
            var ds = new DataSet();
           
            if (EntityName == null)
                throw new Exception("Entity name is not defined.  Please check EntityName parameter value");
            if (ItemKey == null)
                throw new Exception("ItemKey parameter value is not defined.  Please check ItemKey parameter value");
            if (!CheckEntityExists(EntityName))
                throw new Exception("Entity does not exists or access denied. Check database access and passed parameters");

            var dsStorage = GetStorageForEntity(EntityName);
            if (dsStorage.Tables["StorageData"].Rows.Count != 1)
                throw new Exception("Storage does not exists for this entity, storage definition error or access denied");

            using(var conn = new SqlConnection())
            {
                try
                {
                    var etr = dsStorage.Tables[0].Rows.GetEnumerator();
                    // TODO: этот код можно упростить!
                    while (etr.MoveNext())
                    {
                        var row = (DataRow) etr.Current;
                        conn.ConnectionString = row["ConnectionString"].ToString();
                    }
                    var cmd = new SqlCommand
                                   {
                                       CommandType = CommandType.StoredProcedure,
                                       CommandTimeout = Convert.ToInt32(_commandTimeout),
                                       CommandText = "[ecr].[GetEntityItem]",
                                       Connection = conn
                                   };
                    cmd.Parameters.AddWithValue("DisplayAlias", GetEntityAliasByName(EntityName));
                    cmd.Parameters.AddWithValue("ItemKey", ItemKey);
                    if (ItemNumber != null)
                    {
                        if (ItemNumber > 0)
                            cmd.Parameters.AddWithValue("ItemNumber", ItemNumber);
                        else
                            cmd.Parameters.AddWithValue("ItemNumber", DBNull.Value);
                    }
                    else
                        cmd.Parameters.AddWithValue("ItemNumber", DBNull.Value);
                    cmd.Parameters.AddWithValue("HistoryIndex", DBNull.Value);          // SELECT *
                    var adapter = new SqlDataAdapter(cmd);
                    adapter.Fill(ds, "ItemData");
                }
                finally
                {
                    conn.Close();
                }
            }
            
            return ds;
        }

        /// <summary>
        /// Процедура возвращает данные о представлении файлового контента, соответствующего заданной позиции
        /// </summary>
        /// <param name="ViewName">Системное имя сущности для файлового контента</param>
        /// <param name="ItemKey">Ключ позиции</param>
        /// <param name="ItemNumber">Номер позиции (опционально)</param>
        /// <returns>DataSet. Данные о представлении файлового контента</returns>
        public DataSet GetViewItem(string ViewName, string ItemKey, int? ItemNumber)
        {
            var ds = new DataSet();
            
            if (ViewName == null)
                throw new Exception("View name is not defined.  Please check ViewName parameter value");
            if (ItemKey == null)
                throw new Exception("ItemKey parameter value is not defined.  Please check ItemKey parameter value");
            if (!CheckViewExists(ViewName))
                throw new Exception("View does not exists or access denied. Check database access and passed parameters");

            var dsStorage = GetStorageForView(ViewName);
            if (dsStorage.Tables["StorageData"].Rows.Count != 1)
                throw new Exception("Storage does not exists for this view, storage definition error or access denied");

            using(var conn = new SqlConnection())
            {
                try
                {
                    var etr = dsStorage.Tables[0].Rows.GetEnumerator();
                    // TODO: этот код можно упростить!
                    while (etr.MoveNext())
                    {
                        var row = (DataRow) etr.Current;
                        conn.ConnectionString = row["ConnectionString"].ToString();
                    }
                    var cmd = new SqlCommand
                                   {
                                       CommandType = CommandType.StoredProcedure,
                                       CommandTimeout = Convert.ToInt32(_commandTimeout),
                                       CommandText = "[ecr].[GetViewItem]",
                                       Connection = conn
                                   };
                    cmd.Parameters.AddWithValue("DisplayAlias", GetViewAliasByName(ViewName));
                    cmd.Parameters.AddWithValue("ItemKey", ItemKey);
                    if (ItemNumber != null)
                    {
                        if (ItemNumber > 0)
                            cmd.Parameters.AddWithValue("ItemNumber", ItemNumber);
                        else
                            cmd.Parameters.AddWithValue("ItemNumber", DBNull.Value);
                    }
                    else
                        cmd.Parameters.AddWithValue("ItemNumber", DBNull.Value);
                    var adapter = new SqlDataAdapter(cmd);
                    adapter.Fill(ds, "ItemData");
                }
                finally
                {
                    conn.Close();
                }
            }
            
            return ds;
        }

    }

}
