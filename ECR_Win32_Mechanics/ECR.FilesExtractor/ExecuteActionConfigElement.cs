using System;
using System.Configuration;

namespace ECR.FilesExtractor
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
		[ConfigurationProperty("sourceMask", DefaultValue = "", IsKey = false, IsRequired = true)]
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
        [ConfigurationProperty("destinationMask", DefaultValue = "[tk.key].[ext]", IsKey = false, IsRequired = true)]
        public string DestinationMask
        {
            get
            {
                return ((string)(base["destinationMask"]));
            }
            set
            {
                base["destinationMask"] = value;
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
