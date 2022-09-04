using ADODB;

namespace ECRManagedComObjects
{

    /// <summary>
    /// 
    /// </summary>
    public interface IECRDataReader
    {

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        Recordset GetBindingsList();

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns></returns>
        Recordset GetBinding(string SystemName);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="DisplayAlias"></param>
        /// <returns></returns>
        string GetBindingNameByAlias(int DisplayAlias);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns></returns>
        int GetBindingAliasByName(string SystemName);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns></returns>
        bool CheckBindingExists(string SystemName);

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        Recordset GetEntityList();

        /// <summary>
        /// 
        /// </summary>
        /// <param name="BindingName"></param>
        /// <returns></returns>
        Recordset GetEntityListByBinding(string BindingName);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns></returns>
        Recordset GetEntity(string SystemName);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns></returns>
        bool CheckEntityExists(string SystemName);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns></returns>
        bool IsEntityMultiplied(string SystemName);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="DisplayAlias"></param>
        /// <returns></returns>
        string GetEntityNameByAlias(int DisplayAlias);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns></returns>
        int GetEntityAliasByName(string SystemName);
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="Enabled"></param>
        /// <returns></returns>
        Recordset GetViewList(bool Enabled);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="BindingName"></param>
        /// <param name="Enabled"></param>
        /// <returns></returns>
        Recordset GetViewListByBinding(string BindingName, bool Enabled);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="EntityName"></param>
        /// <param name="Enabled"></param>
        /// <returns></returns>
        Recordset GetViewListByEntity(string EntityName, bool Enabled);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns></returns>
        Recordset GetView(string SystemName);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="DisplayAlias"></param>
        /// <returns></returns>
        string GetViewNameByAlias(int DisplayAlias);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns></returns>
        int GetViewAliasByName(string SystemName);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns></returns>
        bool CheckViewExists(string SystemName);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns></returns>
        bool IsViewEnabled(string SystemName);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns></returns>
        bool IsViewMultiplied(string SystemName);

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        Recordset GetStorageList();

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns></returns>
        Recordset GetStorage(string SystemName);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="EntityName"></param>
        /// <returns></returns>
        Recordset GetStorageForEntity(string EntityName);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ViewName"></param>
        /// <returns></returns>
        Recordset GetStorageForView(string ViewName);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns></returns>
        bool CheckStorageExists(string SystemName);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="DisplayAlias"></param>
        /// <returns></returns>
        string GetStorageNameByAlias(int DisplayAlias);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns></returns>
        int GetStorageAliasByName(string SystemName);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="EntityName"></param>
        /// <param name="Key"></param>
        /// <param name="Number"></param>
        /// <returns></returns>
        Recordset GetEntityItem(string EntityName, string Key, int Number);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="EntityName"></param>
        /// <param name="Key"></param>
        /// <param name="Number"></param>
        /// <returns></returns>
        Recordset GetEntityItems(string EntityName, string Key, int Number);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ViewName"></param>
        /// <param name="Key"></param>
        /// <param name="Number"></param>
        /// <returns></returns>
        Recordset GetViewItem(string ViewName, string Key, int Number);

    }

}
