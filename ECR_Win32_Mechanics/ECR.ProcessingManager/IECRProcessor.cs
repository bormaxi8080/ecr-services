namespace ECR.ProcessingManager
{

    /// <summary>
    /// 
    /// </summary>
    public interface IECRProcessor
    {

        ///<summary>
        ///</summary>
        int ContainerId { get; set; }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ContainerId"></param>
        void LoadContainerProperties(int ContainerId);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="o"></param>
        /// <param name="CheckProperties"></param>
        /// <param name="ProcessingDefault"></param>
        /// <param name="err"></param>
        /// <returns></returns>
        bool LoadObject(object o, bool CheckProperties, bool ProcessingDefault, ref string err);
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="o"></param>
        /// <param name="CheckProperties"></param>
        /// <param name="ProcessingDefault"></param>
        /// <param name="Params"></param>
        /// <param name="err"></param>
        /// <returns></returns>
        bool LoadObject(object o, bool CheckProperties, bool ProcessingDefault, string Params, ref string err);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="o"></param>
        /// <param name="CheckProperties"></param>
        /// <param name="ProcessingDefault"></param>
        /// <param name="Params"></param>
        /// <param name="err"></param>
        /// <returns></returns>
        bool LoadObject(object o, bool CheckProperties, bool ProcessingDefault, string[] Params, ref string err);

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        byte[] GetBase();

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ItemType"></param>
        /// <param name="Params"></param>
        /// <returns></returns>
        byte[] CreateView(string ItemType, string Params);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ItemType"></param>
        /// <param name="Params"></param>
        /// <returns></returns>
        byte[] CreateView(string ItemType, string[] Params);

    }

}
