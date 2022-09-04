using System;

namespace ECRManagedAssemblies
{

    /// <summary>
    /// 
    /// </summary>
    internal class ECRManagedAssembliesDllConfig : IDisposable
    {

// ReSharper disable InconsistentNaming
        private const string DEFAULT_DLL_CONFIG = "ECRManagedAssemblies.dll.config";
        private readonly string _oldConfig;
// ReSharper restore InconsistentNaming

        /// <summary>
        /// 
        /// </summary>
        internal ECRManagedAssembliesDllConfig()
        {
            _oldConfig = AppDomain.CurrentDomain.GetData("APP_CONFIG_FILE").ToString();
            Switch(DEFAULT_DLL_CONFIG);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="config"></param>
        internal ECRManagedAssembliesDllConfig(string config)
        {
            _oldConfig = AppDomain.CurrentDomain.GetData("APP_CONFIG_FILE").ToString();
            Switch(config);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="config"></param>
        protected static void Switch(string config)
        {
            AppDomain.CurrentDomain.SetData("APP_CONFIG_FILE", config);
        }

        /// <summary>
        /// 
        /// </summary>
        public void Dispose()
        {
            Switch(_oldConfig);
        }

    }

}
