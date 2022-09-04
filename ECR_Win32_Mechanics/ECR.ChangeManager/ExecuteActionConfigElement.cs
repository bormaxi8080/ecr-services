using System;
using System.Configuration;

namespace ECR.ChangeManager
{

    /// <summary>
    /// The class that holds onto each element returned by the configuration manager.
    /// </summary>
    public class ExecuteActionConfigElement : ConfigurationElement
    {

        ///<summary>
        ///</summary>
        [ConfigurationProperty("key", DefaultValue = "", IsKey = true, IsRequired = true)]
        public string Key
        {
            get
            {
                return ((string)(base["key"]));
            }
            set
            {
                base["key"] = value;
            }
        }

        ///<summary>
        ///</summary>
        [ConfigurationProperty("enabled", DefaultValue = true, IsKey = false, IsRequired = false)]
        public bool Enabled
        {
            get
            {
                return Convert.ToBoolean(base["enabled"]);
            }
            set
            {
                base["enabled"] = value;
            }
        }

        ///<summary>
        ///</summary>
        [ConfigurationProperty("storage", DefaultValue = "", IsKey = false, IsRequired = true)]
        public string StorageName
        {
            get
            {
                return ((string)(base["storage"]));
            }
            set
            {
                base["storage"] = value;
            }
        }

        ///<summary>
        ///</summary>
        [ConfigurationProperty("type", DefaultValue = "otContentView", IsKey = false, IsRequired = true)]
        public string ChangeType
        {
            get
            {
                return ((string)(base["type"]));
            }
            set
            {
                base["type"] = value;
            }
        }

        ///<summary>
        ///</summary>
        [ConfigurationProperty("snapshot", DefaultValue = "changes", IsKey = false, IsRequired = true)]
        public string SnapshotType
        {
            get
            {
                return ((string)(base["snapshot"]));
            }
            set
            {
                base["snapshot"] = value;
            }
        }

        ///<summary>
        ///</summary>
        [ConfigurationProperty("destination", DefaultValue = "", IsKey = false, IsRequired = true)]
        public string Destination
        {
            get
            {
                return ((string)(base["destination"]));
            }
            set
            {
                base["destination"] = value;
            }
        }

		///<summary>
		///</summary>
		[ConfigurationProperty("destination_sj", DefaultValue = "", IsKey = false, IsRequired = false)]
		public string DestinationSJ
		{
		    get
			{
			    return ((string)(base["destination_sj"]));
			}
			set
			{
			    base["destination_sj"] = value;
		    }
		}

        ///<summary>
        ///</summary>
        [ConfigurationProperty("packageSize", DefaultValue = 100, IsKey = false, IsRequired = true)]
        public int PackageSize
        {
            get
            {
                return ((int)(base["packageSize"]));
            }
            set
            {
                base["packageSize"] = value;
            }
        }

        ///<summary>
        ///</summary>
        [ConfigurationProperty("description", DefaultValue = "", IsKey = false, IsRequired = false)]
        public string Description
        {
            get
            {
                return ((string)(base["description"]));
            }
            set
            {
                base["description"] = value;
            }
        }

    }

}
