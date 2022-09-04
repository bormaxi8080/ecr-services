using System;
using System.Windows.Forms;

namespace ECRManagedComObjects
{
    /// <summary>
    /// 
    /// </summary>
    public partial class ExportProxy : Form
    {
        /// <summary>
        /// 
        /// </summary>
        public ExportProxy()
        {
            InitializeComponent();
        }

        /// <summary>
        /// 
        /// </summary>
        public string ProxyFileName
        {
            get { return txtProxyFileName.Text;  }
            set
            {
                if (txtProxyFileName.Text != null) txtProxyFileName.Text = value;
                Refresh();
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnCancel_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("If you cancel proxy export, You should only cancel if you plan to export .MSI file manually, because you have special configuration requirements. Are you sure you want to cancel?", "Proxy Export", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
                return;
            DialogResult = DialogResult.Cancel;
            Close();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnNext_Click(object sender, EventArgs e)
        {
            if (ProxyFileName.Length == 0)
            {
                if (
                    MessageBox.Show(
                        "Proxy file name is not defined. You should only cancel if you plan to proxy export manually, because you have special configuration requirements. Are you sure you want to continue?",
                        "Proxy Export", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
                    return;
            }
            else
            {
                DialogResult = DialogResult.OK;
                Close();
            }
            
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnBrowse_Click(object sender, EventArgs e)
        {
            if (dlgProxyExport.ShowDialog() != DialogResult.OK) return;
            ProxyFileName = dlgProxyExport.FileName;
        }

    }
}
