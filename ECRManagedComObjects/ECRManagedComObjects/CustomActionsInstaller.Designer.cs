using System;
using System.Diagnostics;
using System.EnterpriseServices;
using System.Reflection;
using System.Windows.Forms;
using Microsoft.Win32;

namespace ECRManagedComObjects
{

    /// <summary>
    /// 
    /// </summary>
    partial class CustomActionsInstaller
    {

        /// <summary>
        /// Required designer variable.
        /// </summary>
// ReSharper disable ConvertToConstant
// ReSharper disable RedundantDefaultFieldInitializer
        private System.ComponentModel.IContainer components = null;
// ReSharper restore RedundantDefaultFieldInitializer
// ReSharper restore ConvertToConstant

        private const string REG_BASE_KEY = @"Software\TopBook\ECR\ECRManagedComObjects";
        private const string REG_ECR_DATAREADER_KEY = @"\ECRDataReader";
        private const string REG_PARAMETER_SERVER_ECR_CONFIG = "Server";
        private const string REG_PARAMETER_CONNECTION_TIMEOUT_ECR_CONFIG = "ConnectionTimeout";
        private const string REG_PARAMETER_COMMAND_TIMEOUT_ECR_CONFIG = "CommandTimeout";
        private const string REG_PARAMETER_DEBUG_FLAG = "Debug";

        /// <summary> 
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Component Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {

        }

        #endregion

        /// <summary>
        /// 
        /// </summary>
        /// <param name="stateSaver"></param>
        public override void Install(System.Collections.IDictionary stateSaver)
        {
            try
            {
#if DEBUG
                Debug.WriteLine("Begin component installation process...");
                EventLog.WriteEntry(ToString(), "Begin component installation process...", EventLogEntryType.Information);
#endif
                string appID = null;
                string typeLib = null;
                // Get the location of the current assembly
                var assembly = GetType().Assembly.Location;
                // Install the application
                var regHelper = new RegistrationHelper();
                regHelper.InstallAssembly(assembly, ref appID, ref typeLib, InstallationFlags.FindOrCreateTargetApplication);
                // Save the state - you will need this for the uninstall
                stateSaver.Add("AppID", appID);
                stateSaver.Add("Assembly", assembly);
#if DEBUG
                Debug.WriteLine("Installation successfull");
                EventLog.WriteEntry(ToString(), "Installation successfull", EventLogEntryType.Information);
#endif

                #region Setup Options form call

                var frmOptions = new SetupOptions();
                if (frmOptions.ShowDialog() == DialogResult.OK)
                {

#if DEBUG
                    Debug.WriteLine("Configure component options...");
                    EventLog.WriteEntry(ToString(), "Configure component options...", EventLogEntryType.Information);
#endif
                    
                    // HKLM\Software\TopBook\ECR\ECRManagedComObjects\ECRDataReader
                    var _key = Registry.LocalMachine.OpenSubKey(REG_BASE_KEY + REG_ECR_DATAREADER_KEY, true);
                    if (_key == null)
                    {
                        Registry.LocalMachine.CreateSubKey(REG_BASE_KEY + REG_ECR_DATAREADER_KEY, RegistryKeyPermissionCheck.ReadWriteSubTree);
                        Registry.LocalMachine.Flush();
                        _key = Registry.LocalMachine.OpenSubKey(REG_BASE_KEY + REG_ECR_DATAREADER_KEY, true);
                    }
                    if (_key != null)
                    {
                        _key.SetValue(REG_PARAMETER_SERVER_ECR_CONFIG, frmOptions.ServerLocation);
                        Registry.LocalMachine.Flush();
                        _key.SetValue(REG_PARAMETER_CONNECTION_TIMEOUT_ECR_CONFIG, frmOptions.ConnectionTimeout.ToString());
                        Registry.LocalMachine.Flush();
                        _key.SetValue(REG_PARAMETER_COMMAND_TIMEOUT_ECR_CONFIG, frmOptions.CommandTimeout.ToString());
                        Registry.LocalMachine.Flush();
                        _key.SetValue(REG_PARAMETER_DEBUG_FLAG, frmOptions.DebugMode.ToString());
                        Registry.LocalMachine.Flush();
                    }
#if DEBUG
                    Debug.WriteLine("Component options configured successfully");
                    EventLog.WriteEntry(ToString(), "Component options configured successfully", EventLogEntryType.Information);
#endif

                }

                #endregion

                #region Identity Options form call

                var frmIdentityOptions = new IdentityOptions();
                if (frmIdentityOptions.ShowDialog() == DialogResult.OK)
                {

                    if (frmIdentityOptions.UserName.Length > 0)
                    {

#if DEBUG
                        Debug.WriteLine("Configure component identity...");
                        EventLog.WriteEntry(ToString(), "Configure component identity...", EventLogEntryType.Information);
#endif

                        var _catalog = new COMAdmin.COMAdminCatalog();
                        var _coll = (COMAdmin.COMAdminCatalogCollection) _catalog.GetCollection("Applications");
                        _coll.Populate();

                        foreach (COMAdmin.COMAdminCatalogObject _app in _coll)
                        {
                            if (_app.Name.ToString() != Assembly.GetExecutingAssembly().GetName().Name) continue;
                            _app.set_Value("Identity", frmIdentityOptions.UserName);
                            _app.set_Value("Password", frmIdentityOptions.Password);
                            _coll.SaveChanges();
#if DEBUG
                            Debug.WriteLine("Identity configured successfully");
                            EventLog.WriteEntry(ToString(), "Identity configured successfully", EventLogEntryType.Information);
#endif
                            break;
                        }

                    }

                }

                #endregion

                #region Export Proxy form call

                var frmExportProxy = new ExportProxy();
                if (frmExportProxy.ShowDialog() == DialogResult.OK)
                {

                    if (frmExportProxy.ProxyFileName.Length > 0)
                    {

#if DEBUG
                        Debug.WriteLine("Export Proxy .MSI file...");
                        EventLog.WriteEntry(ToString(), "Export Proxy .MSI file...", EventLogEntryType.Information);
#endif

                        var _catalog = new COMAdmin.COMAdminCatalog();
                        _catalog.ExportApplication(Assembly.GetExecutingAssembly().GetName().Name, frmExportProxy.ProxyFileName, 2);


#if DEBUG
                        Debug.WriteLine("Proxy .MSI file exported successfully");
                        EventLog.WriteEntry(ToString(), "Proxy .MSI file exported successfully", EventLogEntryType.Information);
#endif

                    }

                }

                #endregion


            }
            catch (Exception ex)
            {
#if DEBUG
                Debug.WriteLine(string.Format("Installion error: {0}", ex));
#endif
                EventLog.WriteEntry(ToString(), string.Format("Installation error: '{0}'", ex.Message), EventLogEntryType.Error);
                // If the installer catches the exception it will display 
                // an error message.  Show a friendly error message
                throw new ApplicationException ("Installion error", ex);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="savedState"></param>
        public override void Uninstall(System.Collections.IDictionary savedState)
        {
            try
            {
#if DEBUG
                Debug.WriteLine("Begin component uninstall process...");
                EventLog.WriteEntry(ToString(), "Begin component uninstall process...", EventLogEntryType.Information);
#endif
                // Get the state created when the app was installed
                var appID = (string)savedState["AppID"];
                var assembly = (string)savedState["Assembly"];
                // Uninstall the application
                var regHelper = new RegistrationHelper();
                regHelper.UninstallAssembly(assembly, appID);
#if DEBUG
                Debug.WriteLine("Component removal successfull");
                EventLog.WriteEntry(ToString(), "Component removal successfull", EventLogEntryType.Information);
#endif
            }
            catch (Exception ex)
            {
                // Don't allow unhandled exceptions during uninstall
#if DEBUG
                Debug.WriteLine(string.Format("Uninstall error: {0}", ex));
#endif
                EventLog.WriteEntry(ToString(), string.Format("Uninstall error: '{0}'", ex.Message), EventLogEntryType.Error);
                // If the installer catches the exception it will display 
                // an error message.  Show a friendly error message
                throw new ApplicationException("Uninstall error", ex);
            }
        }

    }

}