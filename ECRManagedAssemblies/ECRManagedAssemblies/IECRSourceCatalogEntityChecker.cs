using System;

namespace ECRManagedAssemblies
{
    
    /// <summary>
    /// Интерфейс IECRSourceCatalogEntityChecker
    /// </summary>
    public interface IECRSourceCatalogEntityChecker
    {
        
        /// <summary>
        /// Функция производит проверку наличия позиции с заданными параметрами в каталоге сущностей
        /// </summary>
        /// <param name="KeyType">Тип ключа позиции для поиска</param>
        /// <param name="KeyValue">Значение ключа</param>
        /// <param name="EntityType">Тип сущности</param>
        /// <returns>true если позиция с заданными параметрами найдена в каталоге сущностей, false в противном случае</returns>
        bool CheckItemExists(string KeyType, string KeyValue, string EntityType);
        
        /// <summary>
        /// Функция сопоставляет значения ключа исходного типа для позиции с заданными параметрами с искомым и выдает значение ключа искомого типа
        /// </summary>
        /// <param name="KeyType">Идентификатор исходного типа ключа</param>
        /// <param name="KeyValue">Значение ключа</param>
        /// <param name="EntityType">Тип сущности</param>
        /// <param name="LookKeyType">Идентификатор искомого типа ключа</param>
        /// <returns>Значение ключа искомого типа</returns>
        string CompareKeys(string KeyType, string KeyValue, string EntityType, string LookKeyType);

    }

}
