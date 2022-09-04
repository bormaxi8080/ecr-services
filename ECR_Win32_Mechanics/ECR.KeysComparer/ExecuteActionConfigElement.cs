using System;
using System.Configuration;

namespace ECR.KeysComparer
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
        [ConfigurationProperty("sourceMask", DefaultValue = "*.*", IsKey = false, IsRequired = true)]
        public string SourceMask
        {
            get
            {
                return ((string)(base["sourceMask"]));
            }
            set
            {
                base["sourceMask"] = value;
            }
        }

        ///<summary>
        ///</summary>
        [ConfigurationProperty("archive", DefaultValue = "", IsKey = false, IsRequired = false)]
        public string Archive
        {
            get
            {
                return ((string)(base["archive"]));
            }
            set
            {
                base["archive"] = value;
            }
        }

        ///<summary>
        ///</summary>
        [ConfigurationProperty("conflicts", DefaultValue = "", IsKey = false, IsRequired = false)]
        public string Conflicts
        {
            get
            {
                return ((string)(base["conflicts"]));
            }
            set
            {
                base["conflicts"] = value;
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
        [ConfigurationProperty("compareMask", DefaultValue = "*.*", IsKey = false, IsRequired = true)]
        public string CompareMask
        {
            get
            {
                return ((string)(base["compareMask"]));
            }
            set
            {
                base["compareMask"] = value;
            }
        }

        ///<summary>
        ///</summary>
        [ConfigurationProperty("dataBinding", DefaultValue = "", IsKey = false, IsRequired = true)]
        public string DataBinding
        {
            get
            {
                return ((string)(base["dataBinding"]));
            }
            set
            {
                base["dataBinding"] = value;
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
