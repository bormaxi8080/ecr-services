namespace ECRManagedComObjects
{
    partial class SetupOptions
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

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

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(SetupOptions));
            this.panel1 = new System.Windows.Forms.Panel();
            this.pictureBox2 = new System.Windows.Forms.PictureBox();
            this.label4 = new System.Windows.Forms.Label();
            this.panel2 = new System.Windows.Forms.Panel();
            this.txtCommandTimeout = new System.Windows.Forms.TextBox();
            this.txtConnectionTimeout = new System.Windows.Forms.TextBox();
            this.txtServerLocation = new System.Windows.Forms.TextBox();
            this.btnCancel = new System.Windows.Forms.Button();
            this.chkDebugMode = new System.Windows.Forms.CheckBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.btnNext = new System.Windows.Forms.Button();
            this.panel1.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox2)).BeginInit();
            this.panel2.SuspendLayout();
            this.SuspendLayout();
            // 
            // panel1
            // 
            this.panel1.BackColor = System.Drawing.Color.White;
            this.panel1.Controls.Add(this.pictureBox2);
            this.panel1.Controls.Add(this.label4);
            this.panel1.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel1.Location = new System.Drawing.Point(0, 0);
            this.panel1.Name = "panel1";
            this.panel1.Size = new System.Drawing.Size(464, 69);
            this.panel1.TabIndex = 0;
            // 
            // pictureBox2
            // 
            this.pictureBox2.Image = ((System.Drawing.Image)(resources.GetObject("pictureBox2.Image")));
            this.pictureBox2.Location = new System.Drawing.Point(16, 13);
            this.pictureBox2.Name = "pictureBox2";
            this.pictureBox2.Size = new System.Drawing.Size(32, 32);
            this.pictureBox2.SizeMode = System.Windows.Forms.PictureBoxSizeMode.AutoSize;
            this.pictureBox2.TabIndex = 3;
            this.pictureBox2.TabStop = false;
            // 
            // label4
            // 
            this.label4.BackColor = System.Drawing.Color.White;
            this.label4.Location = new System.Drawing.Point(54, 13);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(396, 42);
            this.label4.TabIndex = 1;
            this.label4.Text = "Setup will automatically configure ECRManagedComObjects registry paramenters.\r\nIf" +
                " the selected fields would not be changed, it will be configured by default para" +
                "meter values.";
            this.label4.TextAlign = System.Drawing.ContentAlignment.MiddleLeft;
            // 
            // panel2
            // 
            this.panel2.BackColor = System.Drawing.SystemColors.Control;
            this.panel2.Controls.Add(this.btnNext);
            this.panel2.Controls.Add(this.txtCommandTimeout);
            this.panel2.Controls.Add(this.txtConnectionTimeout);
            this.panel2.Controls.Add(this.txtServerLocation);
            this.panel2.Controls.Add(this.btnCancel);
            this.panel2.Controls.Add(this.chkDebugMode);
            this.panel2.Controls.Add(this.label3);
            this.panel2.Controls.Add(this.label2);
            this.panel2.Controls.Add(this.label1);
            this.panel2.Dock = System.Windows.Forms.DockStyle.Top;
            this.panel2.Location = new System.Drawing.Point(0, 69);
            this.panel2.Name = "panel2";
            this.panel2.Size = new System.Drawing.Size(464, 168);
            this.panel2.TabIndex = 1;
            // 
            // txtCommandTimeout
            // 
            this.txtCommandTimeout.Location = new System.Drawing.Point(215, 80);
            this.txtCommandTimeout.Name = "txtCommandTimeout";
            this.txtCommandTimeout.Size = new System.Drawing.Size(63, 20);
            this.txtCommandTimeout.TabIndex = 3;
            this.txtCommandTimeout.Text = "600";
            this.txtCommandTimeout.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.txtCommandTimeout_KeyPress);
            // 
            // txtConnectionTimeout
            // 
            this.txtConnectionTimeout.Location = new System.Drawing.Point(215, 51);
            this.txtConnectionTimeout.Name = "txtConnectionTimeout";
            this.txtConnectionTimeout.Size = new System.Drawing.Size(63, 20);
            this.txtConnectionTimeout.TabIndex = 2;
            this.txtConnectionTimeout.Text = "600";
            this.txtConnectionTimeout.KeyPress += new System.Windows.Forms.KeyPressEventHandler(this.txtConnectionTimeout_KeyPress);
            // 
            // txtServerLocation
            // 
            this.txtServerLocation.Location = new System.Drawing.Point(215, 20);
            this.txtServerLocation.Name = "txtServerLocation";
            this.txtServerLocation.Size = new System.Drawing.Size(208, 20);
            this.txtServerLocation.TabIndex = 1;
            this.txtServerLocation.Text = "local";
            // 
            // btnCancel
            // 
            this.btnCancel.Location = new System.Drawing.Point(294, 132);
            this.btnCancel.Name = "btnCancel";
            this.btnCancel.Size = new System.Drawing.Size(75, 23);
            this.btnCancel.TabIndex = 5;
            this.btnCancel.Text = "Cancel";
            this.btnCancel.UseVisualStyleBackColor = true;
            this.btnCancel.Click += new System.EventHandler(this.btnCancel_Click);
            // 
            // chkDebugMode
            // 
            this.chkDebugMode.AutoSize = true;
            this.chkDebugMode.Location = new System.Drawing.Point(16, 107);
            this.chkDebugMode.Name = "chkDebugMode";
            this.chkDebugMode.Size = new System.Drawing.Size(134, 17);
            this.chkDebugMode.TabIndex = 4;
            this.chkDebugMode.Text = "DEBUG mode enabled";
            this.chkDebugMode.UseVisualStyleBackColor = true;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(13, 80);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(94, 13);
            this.label3.TabIndex = 2;
            this.label3.Text = "Command timeout:";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(13, 51);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(101, 13);
            this.label2.TabIndex = 1;
            this.label2.Text = "Connection timeout:";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(13, 20);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(187, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "ECR_Config database server location:";
            // 
            // btnNext
            // 
            this.btnNext.Location = new System.Drawing.Point(376, 132);
            this.btnNext.Name = "btnNext";
            this.btnNext.Size = new System.Drawing.Size(75, 23);
            this.btnNext.TabIndex = 0;
            this.btnNext.Text = "Next >";
            this.btnNext.UseVisualStyleBackColor = true;
            this.btnNext.Click += new System.EventHandler(this.btnNext_Click);
            // 
            // SetupOptions
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(464, 238);
            this.Controls.Add(this.panel2);
            this.Controls.Add(this.panel1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedDialog;
            this.Name = "SetupOptions";
            this.RightToLeftLayout = true;
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Setup Options";
            this.Deactivate += new System.EventHandler(this.SetupOptions_Deactivate);
            this.panel1.ResumeLayout(false);
            this.panel1.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)(this.pictureBox2)).EndInit();
            this.panel2.ResumeLayout(false);
            this.panel2.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.Panel panel1;
        private System.Windows.Forms.Panel panel2;
        private System.Windows.Forms.CheckBox chkDebugMode;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.TextBox txtCommandTimeout;
        private System.Windows.Forms.TextBox txtConnectionTimeout;
        private System.Windows.Forms.Button btnCancel;
        private System.Windows.Forms.Label label4;
        internal System.Windows.Forms.PictureBox pictureBox2;
        private System.Windows.Forms.TextBox txtServerLocation;
        private System.Windows.Forms.Button btnNext;

    }
}