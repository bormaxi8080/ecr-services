using ADODB;

namespace ECRManagedComObjects
{

    /// <summary>
    /// 
    /// </summary>
    public interface IECRServiceInfo
    {

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        string GetVersion();

        /// <summary>
        /// 
        /// </summary>
        string GetECRConfigDatabaseVersion();

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        Recordset GetECRConfigDatabaseVersionHistory();

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns></returns>
        string GetStorageDatabaseVersion(string SystemName);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="SystemName"></param>
        /// <returns></returns>
        Recordset GetStorageDatabaseVersionHistory(string SystemName);

    }

}
