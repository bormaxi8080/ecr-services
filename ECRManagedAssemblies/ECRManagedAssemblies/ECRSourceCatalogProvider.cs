using System;
using System.Data;
using System.Data.SqlClient;

namespace ECRManagedAssemblies
{

    /// <summary>
    /// Класс предоставляет информацию о способах доступа к экземплярам товарных каталогов,
    /// представленных соответствующими объектами доступа к данным.
    /// </summary>
    public class ECRSourceCatalogProvider
    {

// ReSharper disable InconsistentNaming
        private readonly DataSet _ds = new DataSet();
// ReSharper restore InconsistentNaming

        /// <summary>
        /// Конструктор класса SourceCatalogDataConnectionProvider()
        /// </summary>
        /// <param name="ECRConfigConnectionString">Строка подключения к базе данных ECR_Config</param>
        /// <param name="CatalogName">Имя каталога ECR</param>
        /// <param name="InstanceName">Имя экземпляра каталога ECR</param>
        public ECRSourceCatalogProvider(string ECRConfigConnectionString, string CatalogName, string InstanceName)
        {
            //  _ds.Tables["Properties"].Rows.Count всегда равно 1
            //  Хранимая процедура [ecr].GetSourceCatalogs возвращает ошибку в случае,
            //  если каталог с заданными параметрами не существует или количество записей >1
            using (var conn = new SqlConnection(ECRConfigConnectionString))
            {
                try
                {
                    var cmd = new SqlCommand("[ecr].GetSourceCatalog")
                                   {
                                       CommandType = CommandType.StoredProcedure,
                                       Connection = conn
                                   };
                    cmd.Parameters.AddWithValue("@SystemName", CatalogName);
                    if (InstanceName != string.Empty)
                        cmd.Parameters.AddWithValue("@InstanceName", InstanceName);
                    else
                        cmd.Parameters.AddWithValue("@InstanceName", DBNull.Value);
                    var adapter = new SqlDataAdapter(cmd);
                    adapter.Fill(_ds, "Properties");
                }
                finally
                {
                    conn.Close();
                }
            }
        }
        
        /// <summary>
        /// Наименование ресурса, предоставляющего доступ к товарному каталогу
        /// </summary>
        public string Name
        {
            get
            {
                return _ds.Tables["Properties"].Rows[0]["SystemName"].ToString();
            }
        }

        /// <summary>
        /// Наименование экземпляра ресурса, предоставляющего доступ к товарному каталогу
        /// </summary>
        public string InstanceName
        {
            get
            {
                return _ds.Tables["Properties"].Rows[0]["InstanceName"].ToString();
            }
        }

        /// <summary>
        /// Идентификатор GUID экземпляра ресурса, предлставляющего доступ к товарному каталогу
        /// </summary>
        /// <returns></returns>
        public string CatalogId
        {
            get
            {
                return _ds.Tables["Properties"].Rows[0]["CatalogId"].ToString();   
            }
        }

        /// <summary>
        /// Свойство определяет тип связывания с экземпляром ресурса, предоставляющего доступ к данным товарного каталога.
        /// Фактически свойство определяет способ доступа к данным товарного каталога,
        ///     ссылку на внутренний класс системы ECR, через который осуществляется доступ к данным.
        /// </summary>
        public string BindingType
        {
            get
            {
                return _ds.Tables["Properties"].Rows[0]["BindingType"].ToString();
            }
        }

        /// <summary>
        /// Свойство определяет описание экземпляра ресурса, предоставляющего доступ к товарному каталогу
        /// </summary>
        public string Description
        {
            get
            {
                return _ds.Tables["Properties"].Rows[0]["Description"].ToString();
            }
        }

        /// <summary>
        /// Свойство определяет доступность ресурса, предоставляющего доступ к товарному каталогу
        /// </summary>
        public bool Enabled
        {
            get
            {
                return !(bool)_ds.Tables["Properties"].Rows[0]["Disabled"];
            }
        }
        
        /// <summary>
        /// Свойство определяет приоритет доступа к ресурсу, предоставляющему доступ к товарному каталогу.
        /// Разбивка на приоритеты используется при одновременном анализе данных по нескольким каталогам одного или нескольких типов.
        /// </summary>
        public int Priority
        {
            get
            {
                return (int)_ds.Tables["Properties"].Rows[0]["Priority"];
            }
        }

        /// <summary>
        /// Свойство определяет имя сервера для вызова удаленного объекта, предоставляющего доступ к товарному каталогу.
        /// Опционально, спользуется для объектов доступа к товарным каталогам на основе COM-объектов.
        /// </summary>
        public string RemoteServerName
        {
            get
            {
                return _ds.Tables["Properties"].Rows[0]["RemoteServerName"].ToString();
            }
        }

        /// <summary>
        /// Свойство определяет строку соединения с базой данных, соответствующую ресурсу, предоставляющему доступ к товарному каталогу.
        /// Опционально, используется для объектов доступа к товарным каталогам на основе прямого соединяния с БД.
        /// </summary>
        public string ConnectionString
        {
            get
            {
                return _ds.Tables["Properties"].Rows[0]["ConnectionString"].ToString();   
            }
        }

    }

}
