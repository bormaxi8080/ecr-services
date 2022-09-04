using System.Configuration;

namespace ECR.FilesExtractor
{

    /// <summary>
    /// The collection class that will store the list of each element/item that is returned back from the configuration manager
    /// </summary>
    [ConfigurationCollection(typeof(ExecuteActionConfigElement))]
    public class ExecuteActionsConfigCollection : ConfigurationElementCollection
    {

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        protected override ConfigurationElement CreateNewElement()
        {
            return new ExecuteActionConfigElement();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="element"></param>
        /// <returns></returns>
        protected override object GetElementKey(ConfigurationElement element)
        {
            return ((ExecuteActionConfigElement)(element)).Key;
        }

        ///<summary>
        ///</summary>
        ///<param name="idx"></param>
        public ExecuteActionConfigElement this[int idx]
        {
            get
            {
                return (ExecuteActionConfigElement)BaseGet(idx);
            }
        }

    }

}
