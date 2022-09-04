using System;

namespace ECRManagedAssemblies
{

    /// <summary>
    /// Предоставляет доступ к классам проверки данных позиций по известным типам каталогов сущностей;
    /// </summary>
    public class SourceCatalogEntityChecker
    {

        private readonly ECRSourceCatalogProvider _provider;
        private IECRSourceCatalogEntityChecker _checker;

        /// <summary>
        /// Процедура определяет тип привязки к каталогу сущностей
        /// </summary>
        private void DefineEntityChecker()
        {
            switch (_provider.BindingType)
            {
                // catalog.1 - Catalog.1 (старый каталог web)
                case "catalog.1":
                    _checker = new ECRSourceCatalogEntityChecker(_provider.ConnectionString);
                    break;
                // catalog.bk - EBK catalog (каталог ЕБК)
                case "bkkm.catalog":
                    _checker = new ECRSourceCatalogEntityChecker(_provider.ConnectionString);
                    break;
                default:
                    throw new Exception(string.Format("Unsupported resource binding type: '{0}'", _provider.BindingType));
            }
        }

        /// <summary>
        /// Конструктор класса ProcesingChainEntityChecker()
        /// </summary>
        /// <param name="ECRConfigConnectionString">Строка подключения к базе данных ECR_Config</param>
        /// <param name="CatalogName">Идентификатор каталога сущностей</param>
        /// <param name="InstanceName">Идентификатор экземпляра каталога сущностей</param>
        public SourceCatalogEntityChecker(string ECRConfigConnectionString, string CatalogName, string InstanceName)
        {
            _provider = new ECRSourceCatalogProvider(ECRConfigConnectionString, CatalogName, InstanceName);
            DefineEntityChecker();
        }

        /// <summary>
        /// Конструктор класса ProcessingChainEntityChecker()
        /// </summary>
        /// <param name="ECRConfigConnectionString">Строка подключения к базе данных ECR_Config</param>
        /// <param name="CatalogName">Идентификатор каталога сущностей</param>
        public SourceCatalogEntityChecker(string ECRConfigConnectionString, string CatalogName)
        {
            _provider = new ECRSourceCatalogProvider(ECRConfigConnectionString, CatalogName, string.Empty);
            DefineEntityChecker();
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
            return _checker.CheckItemExists(KeyType, KeyValue, EntityType);
        }

        /// <summary>
        /// Функция производит проверку наличия позиции с заданными параметрами в каталоге сущностей
        /// </summary>
        /// <param name="KeyType">Тип ключа позиции для поиска</param>
        /// <param name="KeyValue">Значение ключа</param>
        /// <returns>true если позиция с заданными параметрами найдена в каталоге сущностей, false в противном случае</returns>
        public bool CheckItemExists(string KeyType, string KeyValue)
        {
            return CheckItemExists(KeyType, KeyValue, string.Empty);
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
            return _checker.CompareKeys(KeyType, KeyValue, EntityType, LookKeyType);
        }

        /// <summary>
        /// Функция производит проверку наличия позиции с заданными параметрами в каталоге сущностей
        /// </summary>
        /// <param name="KeyType">Идентификатор исходного типа ключа</param>
        /// <param name="KeyValue">Значение ключа</param>
        /// <param name="LookKeyType">Идентификатор искомого типа ключа</param>
        /// <returns>Значение ключа искомого типа</returns>
        public string CompareKeys(string KeyType, string KeyValue, string LookKeyType)
        {
            return CompareKeys(KeyType, KeyValue, string.Empty, LookKeyType);
        }

    }

}
