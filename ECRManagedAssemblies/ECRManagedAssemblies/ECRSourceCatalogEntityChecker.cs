using System;
using System.Data;
using System.Data.SqlClient;

namespace ECRManagedAssemblies
{

    /// <summary>
    /// Класс предоставляет доступ к методам проверки товарных позиций в каталогах ECR
    /// </summary>
    public class ECRSourceCatalogEntityChecker : IECRSourceCatalogEntityChecker
    {

// ReSharper disable InconsistentNaming
        /// <summary>
        /// ECRSourceCatalogEntityChecker() class source sql connection
        /// </summary>
        protected SqlConnection _conn = new SqlConnection();
        /// <summary>
        /// WebCatalogEntityChecker() class source sql command
        /// </summary>
        protected SqlCommand _cmd = new SqlCommand();
// ReSharper restore InconsistentNaming

        /// <summary>
        /// Конструктор класса WebCatalogEntityChecker()
        /// </summary>
        /// <param name="ConnectionString">Строка соединения с базой данных</param>
        public ECRSourceCatalogEntityChecker(string ConnectionString)
        {
            _conn.ConnectionString = ConnectionString;
            _cmd.CommandType = CommandType.StoredProcedure;
            _cmd.Connection = _conn;
        }

        /// <summary>
        /// Функция производит проверку наличия позиции с заданными параметрами в каталоге сущностей
        /// </summary>
        /// <param name="KeyType">Тип ключа позиции для поиска</param>
        /// <param name="KeyValue">Значение ключа</param>
        /// <param name="EntityType">Тип сущности</param>
        /// <returns>true если позиция с заданными параметрами найдена в каталоге сущностей, false в противном случае</returns>
        public bool CheckItemExists(string KeyType, string KeyValue, string EntityType)
        {

            bool result;
            _cmd.Parameters.Clear();

            // Хранимая процедура [ecr].CheckSourceCatalogWareItemExists возвращает количество позиций,
            //      соответствующих заданным критериям выбора (KeyType, KeyValue, EntityType);
            // В случае, если KeyType не поддерживается или неизвестен, генерируется ошибка;
            _cmd.CommandText = "[ecr].CheckSourceCatalogEntityItemExists";

            _cmd.Parameters.AddWithValue("KeyType", KeyType);
            _cmd.Parameters.AddWithValue("KeyValue", KeyValue);

            // Тип товара подставляется только в том случае, если задано, в какой категории товаров искать товарную позицию;
            if (EntityType != string.Empty)
                _cmd.Parameters.AddWithValue("EntityType", EntityType);
            else
                _cmd.Parameters.AddWithValue("EntityType", DBNull.Value);

            // Хранимая процедура возвращает значение типа bit:
            //      1 (true) : запись о позиции найдена в каталоге сущностей;
            //      0 (false): запись о позиии не найдена;
            // В случае, если количество записей больше 1, хранимая процедура генерирует ошибку;
            _conn.Open();
            try
            {
                //_result = (bool)_cmd.ExecuteScalar();
                result = Convert.ToBoolean(_cmd.ExecuteScalar());
            }
            finally
            {
                _conn.Close();
            }

             return result;

        }

        /// <summary>
        /// Функция сопоставляет значения ключа исходного типа для позиции с заданными параметрами с искомым и выдает значение ключа искомого типа
        /// </summary>
        /// <param name="KeyType">Идентификатор исходного типа ключа</param>
        /// <param name="KeyValue">Значение ключа</param>
        /// <param name="EntityType">Тип сущности</param>
        /// <param name="LookKeyType">Идентификатор искомого типа ключа</param>
        /// <returns>Значение ключа искомого типа</returns>
        public string CompareKeys(string KeyType, string KeyValue, string EntityType, string LookKeyType)
        {

            string result;
            _cmd.Parameters.Clear();

            // Хранимая процедура [ecr].SourceCatalogEntityItemCompareKeys возвращает значение ключа указанного типа LookKeyType,
            //      соответснтвующего заданным критериям выбора товарной позиции (KeyType, KeyValue, EntityType);
            // В случае, если тип ключа (KeyType, LookKeyType) не поддерживается или неизвестен, генерируется exception;
            _cmd.CommandText = "[ecr].SourceCatalogEntityItemCompareKeys";

            _cmd.Parameters.AddWithValue("KeyType", KeyType);
            _cmd.Parameters.AddWithValue("KeyValue", KeyValue);

            // Параметр LookForKey задает тип искомого ключа, однозначно идентифицируемого некоторой записью в исходном каталоге;
            _cmd.Parameters.AddWithValue("LookKeyType", LookKeyType);

            // Значение типа товара подставляется только в том случае, если задано, в какой категории товаров искать ключи;
            if (EntityType != string.Empty)
                _cmd.Parameters.AddWithValue("EntityType", EntityType);
            else
                _cmd.Parameters.AddWithValue("EntityType", DBNull.Value);

            // Хранимая процедура возвращает значение указанного ключа - тип данных: nvarchar(255);
            // В случае, если такой товарной позиции нет или количество позций больше 1, генерируется exception;
            _conn.Open();
            try
            {
                result = (string)_cmd.ExecuteScalar();
            }
            finally
            {
                _conn.Close();
            }

            return result;
            
        }

    }

}
