using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration.Install;


namespace ECRManagedComObjects
{
    [RunInstaller(true)]
    public partial class CustomActionsInstaller : Installer
    {
        /// <summary>
        /// 
        /// </summary>
        public CustomActionsInstaller()
        {
            InitializeComponent();
        }
    }
}
