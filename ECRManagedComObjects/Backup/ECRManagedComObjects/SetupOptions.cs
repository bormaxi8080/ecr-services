using System;
using System.Globalization;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace ECRManagedComObjects
{
    ///<summary>
    ///</summary>
    public partial class SetupOptions : Form
    {

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.I4)]
        private static extern Int32 FlashWindow([MarshalAs(UnmanagedType.I4)]Int32 hWnd, [MarshalAs(UnmanagedType.I4)]Int32 bInvert);

        private const string DEFAULT_SERVER_LOCATION = "local";
        private const int    DEFAULT_CONNECTION_TIMEOUT = 600;
        private const int    DEFAULT_COMMAND_TIMEOUT = 600;
        private const bool   DEFAULT_DEBUG_MODE = false;

        ///<summary>
        ///</summary>
        public SetupOptions()
        {
            InitializeComponent();
            ServerLocation = DEFAULT_SERVER_LOCATION;
            ConnectionTimeout = DEFAULT_CONNECTION_TIMEOUT;
            CommandTimeout = DEFAULT_COMMAND_TIMEOUT;
            DebugMode = DEFAULT_DEBUG_MODE;
        }

        /// <summary>
        /// ServerLocation property
        /// </summary>
        public string ServerLocation
        {
            get
            {
                return txtServerLocation.Text;
            }
            set
            {
                if (txtServerLocation != null) txtServerLocation.Text = value;
                Refresh();
            }
        }

        /// <summary>
        /// ConnectionTimeout property
        /// </summary>
        public int ConnectionTimeout
        {
            get
            {
                return Convert.ToInt32(txtConnectionTimeout.Text);   
            }
            set
            {
                txtConnectionTimeout.Text = value.ToString();
                Refresh();
            }
        }

        /// <summary>
        /// CommandTimeout property
        /// </summary>
        public int CommandTimeout
        {
            get
            {
                return Convert.ToInt32(txtCommandTimeout.Text);
            }
            set
            {

                txtCommandTimeout.Text = value.ToString();
                Refresh();
            }
        }

        /// <summary>
        /// DEBUG MODE property
        /// </summary>
        public bool DebugMode
        {
            get
            {
                return chkDebugMode.Checked;
            }
            set
            {
                chkDebugMode.Checked = value;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void SetupOptions_Deactivate(object sender, EventArgs e)
        {
            FlashWindow(Handle.ToInt32(), -1);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void txtConnectionTimeout_KeyPress(object sender, KeyPressEventArgs e)
        {

            base.OnKeyPress(e);

            var numberFormatInfo = CultureInfo.CurrentCulture.NumberFormat;
            var decimalSeparator = numberFormatInfo.NumberDecimalSeparator;
            var groupSeparator = numberFormatInfo.NumberGroupSeparator;
            var negativeSign = numberFormatInfo.NegativeSign;

            var keyInput = e.KeyChar.ToString();

            if (Char.IsDigit(e.KeyChar))
            {
                // Digits are OK
            }
            else if (keyInput.Equals(decimalSeparator) || keyInput.Equals(groupSeparator) ||
             keyInput.Equals(negativeSign))
            {
                // Decimal separator is OK
            }
            else if (e.KeyChar == '\b')
            {
                // Backspace key is OK
            }
            //    else if ((ModifierKeys & (Keys.Control | Keys.Alt)) != 0)
            //    {
            //     // Let the edit control handle control and alt key combinations
            //    }
            else
            {
                // Consume this invalid key and beep
                e.Handled = true;
            }

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        private void txtCommandTimeout_KeyPress(object sender, KeyPressEventArgs e)
        {

            base.OnKeyPress(e);

            var numberFormatInfo = CultureInfo.CurrentCulture.NumberFormat;
            var decimalSeparator = numberFormatInfo.NumberDecimalSeparator;
            var groupSeparator = numberFormatInfo.NumberGroupSeparator;
            var negativeSign = numberFormatInfo.NegativeSign;

            var keyInput = e.KeyChar.ToString();

            if (Char.IsDigit(e.KeyChar))
            {
                // Digits are OK
            }
            else if (keyInput.Equals(decimalSeparator) || keyInput.Equals(groupSeparator) ||
             keyInput.Equals(negativeSign))
            {
                // Decimal separator is OK
            }
            else if (e.KeyChar == '\b')
            {
                // Backspace key is OK
            }
            //    else if ((ModifierKeys & (Keys.Control | Keys.Alt)) != 0)
            //    {
            //     // Let the edit control handle control and alt key combinations
            //    }
            else
            {
                // Consume this invalid key and beep
                e.Handled = true;
            }

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
            if (txtServerLocation.Text.Length == 0)
                if (MessageBox.Show("'ServerLocation' property is not defined. You should only cancel if you plan to configure manually, because you have special configuration requirements. Are you sure you want to setup?", "Setup Opetions", MessageBoxButtons.YesNo, MessageBoxIcon.Question) == DialogResult.No)
                    return;
            DialogResult = DialogResult.OK;
            Close();
        }
        
    }
}
