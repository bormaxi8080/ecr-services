using System;
using System.Data;
using System.Data.SqlClient;

namespace ECRManagedAssemblies
{

    /// <summary>
    /// ECRManagedDataWriter class provides access to write ECR storage data in .net client applications
    /// </summary>
    public class ECRManagedDataWriter
    {

#pragma warning disable 219
// ReSharper disable InconsistentNaming
// ReSharper disable UnaccessedField.Local
        private readonly bool _DEBUG;
// ReSharper restore UnaccessedField.Local
// ReSharper restore InconsistentNaming
#pragma warning restore 219

// ReSharper disable InconsistentNaming
        private const string TEMPLATE_CONNECTION_STRING = "Integrated Security=SSPI;Persist Security Info=False;Initial Catalog=ECR_Config;Data Source=<%DataSource%>;Connection Timeout=<%ConnectionTimeout%>";
        private const int DEFAULT_COMMAND_TIMEOUT = 600;

        private string _baseServerName;
        private string _connectionString;
        private int _connectionTimeout;
        private int _commandTimeout;
// ReSharper restore InconsistentNaming

        #region ECRManagedDataWriter class constructors

        ///<summary>
        /// ECRManagedDataWriter class constructor
        ///</summary>
        /// <param name="BaseServerName">Имя сервера размещения базы данных ECR_Config</param>
        /// <param name="ConnectionTimeout">SQL connection timeout, ms</param>
        /// <param name="CommandTimeout">SQL command timeout, ms</param>
        public ECRManagedDataWriter(string BaseServerName, int ConnectionTimeout, int CommandTimeout)
        {
            _DEBUG = false;
            Initialize(BaseServerName, ConnectionTimeout, CommandTimeout);
        }

        /// <summary>
        /// ECRManagedDataWriter class constructor
        /// </summary>
        /// <param name="BaseServerName">Имя сервера размещения базы данных ECR_Config</param>
        /// <param name="DebugMode">Параметр определяет состояние режима DEBUG в классе</param>
        /// <param name="ConnectionTimeout">SQL connection timeout, ms</param>
        /// <param name="CommandTimeout">SQL command timeout, ms</param>
        public ECRManagedDataWriter(string BaseServerName, int ConnectionTimeout, int CommandTimeout, bool DebugMode)
        {
            _DEBUG = DebugMode;
            Initialize(BaseServerName, ConnectionTimeout, CommandTimeout);
        }

        #endregion

        #region ECRManagedDataWriter initialization procedures

        /// <summary>
        /// ECRManagedDataWriter class constructor initialization procedure
        /// </summary>
        /// <param name="BaseServerName"></param>
        /// <param name="ConnectionTimeout"></param>
        /// <param name="CommandTimeout"></param>
        private void Initialize(string BaseServerName, int ConnectionTimeout, int CommandTimeout)
        {
            // Define BaseServerName value
            _baseServerName = BaseServerName;
            // Define ConnectionTimeout value
            _connectionTimeout = ConnectionTimeout;
            // Define CommandTimeout value
            _commandTimeout = CommandTimeout;
            // Define ConnectionString value
            _connectionString = TEMPLATE_CONNECTION_STRING.Replace("<%DataSource%>", BaseServerName).Replace("<%ConnectionTimeout%>", _connectionTimeout.ToString());
        }

        #endregion

        #region ECRManagedDataWriter class properties



        #endregion

        /// <summary>
        /// Обновление сводной таблицы ecr.ItemsSummary базы данных ECR_Config 
        /// </summary>
        /// <param name="ItemKey">Товарный ключ позиции</param>
        /// <param name="ItemNumber">Номер позиции</param>
        /// <param name="EntityName">Идентификатор типа контента</param>
        /// <param name="OperationType">Тип операции (I/U/D/C)</param>
        public void UpdateItemSummary(string ItemKey, int? ItemNumber, string EntityName, string OperationType)
        {
            var reader = new ECRManagedDataReader(_baseServerName, _connectionTimeout, _commandTimeout);
            using (var conn = new SqlConnection { ConnectionString = _connectionString })
            {
                conn.Open();
                try
                {
                    var cmd = new SqlCommand
                                  {
                                      CommandType = CommandType.StoredProcedure,
                                      CommandTimeout = Convert.ToInt32(_commandTimeout),
                                      CommandText = "[ecr].[UpdateItemSummary]",
                                      Connection = conn
                                  };
                    cmd.Parameters.AddWithValue("@DisplayAlias", reader.GetEntityAliasByName(EntityName));
                    cmd.Parameters.AddWithValue("@ItemKey", ItemKey);
                    if (ItemNumber != null)
                    {
                        if (ItemNumber > 0)
                            cmd.Parameters.AddWithValue("@ItemNumber", ItemNumber);
                        else
                            cmd.Parameters.AddWithValue("@ItemNumber", DBNull.Value);
                    }
                    else
                        cmd.Parameters.AddWithValue("@ItemNumber", DBNull.Value);
                    cmd.Parameters.AddWithValue("@OperationType", OperationType);
                    cmd.CommandTimeout = DEFAULT_COMMAND_TIMEOUT;
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                }
            }

        }

        /// <summary>
        /// Загрузка файла оригинала контента в хранилище системы ECR
        /// </summary>
        /// <param name="ItemKey">Товарный ключ позиции</param>
        /// <param name="ItemNumber">Номер позиции</param>
        /// <param name="ItemBody">Тело файла</param>
        /// <param name="EntityName">Идентификатор типа контента</param>
        public void TransferEntity(string ItemKey, int? ItemNumber, byte[] ItemBody, string EntityName)
        {
            var reader = new ECRManagedDataReader(_baseServerName, _connectionTimeout, _commandTimeout);
            using (var conn = new SqlConnection((reader.GetStorageForEntity(EntityName)).Tables[0].Rows[0]["ConnectionString"].ToString()))
            {
                conn.Open();
                try
                {
                    var cmd = new SqlCommand("[ecr].[UpdateEntityItem]", conn)
                    {
                        CommandType = CommandType.StoredProcedure,
                        CommandTimeout = DEFAULT_COMMAND_TIMEOUT
                    };
                    cmd.Parameters.AddWithValue("@DisplayAlias", reader.GetEntityAliasByName(EntityName));
                    cmd.Parameters.AddWithValue("@ItemKey", ItemKey);
                    if(ItemNumber != null)
                    {
                        if (ItemNumber > 0)
                            cmd.Parameters.AddWithValue("@ItemNumber", ItemNumber);
                        else
                            cmd.Parameters.AddWithValue("@ItemNumber", DBNull.Value);
                    }
                    else
                        cmd.Parameters.AddWithValue("@ItemNumber", DBNull.Value);
                    if(ItemBody != null)
                    {
                        // Важно: передача массива нулевой длины приравнивается к передаче значения null (~ удалению даных)
                        if (ItemBody.Length > 0)
                            cmd.Parameters.AddWithValue("@ItemBody", ItemBody);
                        else
                        {
                            cmd.Parameters.Add("@ItemBody", SqlDbType.VarBinary);
                            cmd.Parameters["@ItemBody"].Value = DBNull.Value;
                        }
                    }
                    else
                    {
                        cmd.Parameters.Add("@ItemBody", SqlDbType.VarBinary);
                        cmd.Parameters["@ItemBody"].Value = DBNull.Value;
                    }
                    cmd.CommandTimeout = DEFAULT_COMMAND_TIMEOUT;
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                }
            }
        }

        /// <summary>
        /// Загрузка файла представления контента в хранилище системы ECR
        /// </summary>
        /// <param name="ItemKey">Товарный ключ позиции</param>
        /// <param name="ItemNumber">Номер позиции</param>
        /// <param name="ItemBody">Тело файла</param>
        /// <param name="ViewName">Идентификатор представления контента</param>
        public void TransferView(string ItemKey, int? ItemNumber, byte[] ItemBody, string ViewName)
        {
            var reader = new ECRManagedDataReader(_baseServerName, _connectionTimeout, _commandTimeout);
            using (var conn = new SqlConnection((reader.GetStorageForView(ViewName)).Tables[0].Rows[0]["ConnectionString"].ToString()))
            {
                conn.Open();
                try
                {
                    var cmd = new SqlCommand("[ecr].[UpdateViewItem]", conn)
                    {
                        CommandType = CommandType.StoredProcedure,
                        CommandTimeout = DEFAULT_COMMAND_TIMEOUT
                    };
                    cmd.Parameters.AddWithValue("@DisplayAlias", reader.GetViewAliasByName(ViewName));
                    cmd.Parameters.AddWithValue("@ItemKey", ItemKey);
                    if (ItemNumber != null)
                    {
                        if (ItemNumber > 0)
                            cmd.Parameters.AddWithValue("@ItemNumber", ItemNumber);
                        else
                            cmd.Parameters.AddWithValue("@ItemNumber", DBNull.Value);
                    }
                    else
                        cmd.Parameters.AddWithValue("@ItemNumber", DBNull.Value);
                    if (ItemBody != null)
                    {
                        // Важно: передача массива нулевой длины приравнивается к передаче значения null (~ удалению даных)
                        if (ItemBody.Length > 0)
                            cmd.Parameters.AddWithValue("@ItemBody", ItemBody);
                        else
                        {
                            cmd.Parameters.Add("@ItemBody", SqlDbType.VarBinary);
                            cmd.Parameters["@ItemBody"].Value = DBNull.Value;
                        }
                    }
                    else
                    {
                        cmd.Parameters.Add("@ItemBody", SqlDbType.VarBinary);
                        cmd.Parameters["@ItemBody"].Value = DBNull.Value;
                    }
                    cmd.CommandTimeout = DEFAULT_COMMAND_TIMEOUT;
                    cmd.ExecuteNonQuery();
                }
                finally
                {
                    conn.Close();
                }
            }
        }

    }

}
