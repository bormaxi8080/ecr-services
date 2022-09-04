using System;
using System.Configuration;

namespace ECR.ProcessingManager
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
        [ConfigurationProperty("overwrite", DefaultValue = true, IsKey = false, IsRequired = false)]
        public bool Overwrite
        {
            get
            {
                return Convert.ToBoolean(base["overwrite"]);
            }
            set
            {
                base["overwrite"] = value;
            }
        }

        ///<summary>
        ///</summary>
        [ConfigurationProperty("source", DefaultValue = "", IsKey = false, IsRequired = true)]
        public string Source
        {
            get
            {
                return ((string)(base["source"]));
            }
            set
            {
                base["source"] = value;
            }
        }

        ///<summary>
        ///</summary>
        [ConfigurationProperty("mask", DefaultValue = "[tk.key].[ext]", IsKey = false, IsRequired = true)]
        public string Mask
        {
            get
            {
                return ((string)(base["mask"]));
            }
            set
            {
                base["mask"] = value;
            }
        }

        ///<summary>
        ///</summary>
        [ConfigurationProperty("itemType", DefaultValue = "", IsKey = false, IsRequired = true)]
        public string ItemType
        {
            get
            {
                return ((string)(base["itemType"]));
            }
            set
            {
                base["itemType"] = value;
            }
        }

        ///<summary>
        ///</summary>
        [ConfigurationProperty("containerType", DefaultValue = "", IsKey = false, IsRequired = true)]
        public string ContainerType
        {
            get
            {
                return ((string)(base["containerType"]));
            }
            set
            {
                base["containerType"] = value;
            }
        }

        ///<summary>
        ///</summary>
        [ConfigurationProperty("containerId", DefaultValue = 0, IsKey = false, IsRequired = true)]
        public int ContainerId
        {
            get
            {
                return ((int)(base["containerId"]));
            }
            set
            {
                base["containerId"] = value;
            }
        }

        ///<summary>
        ///</summary>
        [ConfigurationProperty("saveOriginals", DefaultValue = true, IsKey = false, IsRequired = false)]
        public bool SaveOriginals
        {
            get
            {
                return (Convert.ToBoolean(base["saveOriginals"]));
            }
            set
            {
                base["saveOriginals"] = value;
            }
        }

        ///<summary>
        ///</summary>
        [ConfigurationProperty("defaultProcessing", DefaultValue = true, IsKey = false, IsRequired = false)]
        public bool DefaultProcessing
        {
            get
            {
                return (Convert.ToBoolean(base["defaultProcessing"]));
            }
            set
            {
                base["defaultProcessing"] = value;
            }
        }

        ///<summary>
        ///</summary>
        [ConfigurationProperty("propertiesCheck", DefaultValue = true, IsKey = false, IsRequired = false)]
        public bool CheckProperties
        {
            get
            {
                return (Convert.ToBoolean(base["propertiesCheck"]));
            }
            set
            {
                base["propertiesCheck"] = value;
            }
        }

        ///<summary>
        ///</summary>
        [ConfigurationProperty("backupTo", DefaultValue = "", IsKey = false, IsRequired = false)]
        public string BackupTo
        {
            get
            {
                return ((string)(base["backupTo"]));
            }
            set
            {
                base["backupTo"] = value;
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
