using System.Configuration;

namespace ECR.ProcessingManager
{

    /// <summary>
    /// The Class that will have the XML config file data loaded into it via the configuration Manager.
    /// </summary>
    public class ExecuteActionsConfigSection : ConfigurationSection
    {

        /// <summary>
        /// The value of the property here "actions" needs to match that of the config file section
        /// </summary>
        [ConfigurationProperty("actions")]
        public ExecuteActionsConfigCollection ActionItems
        {
            get { return ((ExecuteActionsConfigCollection)(base["actions"])); }
        }

    }

}