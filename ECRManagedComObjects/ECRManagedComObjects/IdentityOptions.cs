using System;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace ECRManagedComObjects
{
    /// <summary>
    /// 
    /// </summary>
    public partial class IdentityOptions : Form
    {

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.I4)]
        private static extern Int32 FlashWindow([MarshalAs(UnmanagedType.I4)]Int32 hWnd, [MarshalAs(UnmanagedType.I4)]Int32 bInvert);

        /// <summary>
        /// 
        /// </summary>
        public IdentityOptions()
        {
            InitializeComponent();
        }

        /// <summary>
        /// 
        /// </summary>
        public string UserName
        {
            get
            {
                return txtUserName.Text;
            }
            set
            {
                txtUserName.Text = value;
                Refresh();
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public string Password
        {
            get
            {
                return txtPassword.Text;
            }
            set
            {
                txtPassword.Text = value;
                Refresh();
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public string PasswordConfirm
        {
            get
            {
                return txtPasswordConfirm.Text;
            }
            set
            {
                txtPasswordConfirm.Text = value;
                Refresh();
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void IdentityOptions_Deactivate(object sender, EventArgs e)
        {
            FlashWindow(Handle.ToInt32(), -1);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void btnCancel_Click(object sender, EventArgs e)
        {
            if (MessageBox.Show("If you cancel automatic configuration, the application may not function correctly. You should only cancel if you plan to configure manually, because you have special configuration requirements. Are you sure you want to cancel?", "Setup Opetions", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
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
            if (txtUserName.Text.Length == 0)
                if (MessageBox.Show("'UserName' property is not defined. You should only cancel if you plan to configure manually, because you have special configuration requirements. Are you sure you want to setup?", "Identity Opetions", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
                    return;
            if (txtPassword.Text.Length == 0)
                if (MessageBox.Show("'Password' property is not defined. You should only cancel if you plan to configure manually, because you have special configuration requirements. Are you sure you want to setup?", "Identity Opetions", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
                    return;
            if (txtPasswordConfirm.Text.Length == 0)
                if (MessageBox.Show("'Confirm Passwrod' property is not defined. You should only cancel if you plan to configure manually, because you have special configuration requirements. Are you sure you want to setup?", "Identity Opetions", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
                    return;
            if (txtPasswordConfirm.Text != txtPassword.Text)
            {
                if (txtPasswordConfirm.Text.Length > 0)
                {
                    MessageBox.Show(
                        "'Password' and 'Confirm Password' property values is not identical. Please retype values",
                        "Identity Options");
                    return;
                }
            }
            DialogResult = DialogResult.OK;
            Close();
        }
        
    }
}
