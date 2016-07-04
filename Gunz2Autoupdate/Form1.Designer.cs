namespace Gunz2AutoUpdate
{
    partial class Form1
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
            this.mTextBoxDebug = new System.Windows.Forms.TextBox();
            this.mButtonStart = new System.Windows.Forms.Button();
            this.mLabelTitleMessage = new System.Windows.Forms.Label();
            this.mProgressbarDownloading = new System.Windows.Forms.ProgressBar();
            this.mCheckboxRunPatched = new System.Windows.Forms.CheckBox();
            this.mGroupOptions = new System.Windows.Forms.GroupBox();
            this.mLabelCrosshaircolor = new System.Windows.Forms.Label();
            this.mTextBoxCrosshaircolor = new System.Windows.Forms.TextBox();
            this.mWebBrowser = new System.Windows.Forms.WebBrowser();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.tabPage2 = new System.Windows.Forms.TabPage();
            this.mListBoxTexturesMod = new System.Windows.Forms.ListBox();
            this.mListBoxTextures = new System.Windows.Forms.ListBox();
            this.button1 = new System.Windows.Forms.Button();
            this.mGroupOptions.SuspendLayout();
            this.tabControl1.SuspendLayout();
            this.tabPage1.SuspendLayout();
            this.tabPage2.SuspendLayout();
            this.SuspendLayout();
            // 
            // mTextBoxDebug
            // 
            this.mTextBoxDebug.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.mTextBoxDebug.Location = new System.Drawing.Point(8, 488);
            this.mTextBoxDebug.Multiline = true;
            this.mTextBoxDebug.Name = "mTextBoxDebug";
            this.mTextBoxDebug.ReadOnly = true;
            this.mTextBoxDebug.ScrollBars = System.Windows.Forms.ScrollBars.Vertical;
            this.mTextBoxDebug.Size = new System.Drawing.Size(741, 106);
            this.mTextBoxDebug.TabIndex = 0;
            // 
            // mButtonStart
            // 
            this.mButtonStart.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Right)));
            this.mButtonStart.Enabled = false;
            this.mButtonStart.Location = new System.Drawing.Point(884, 577);
            this.mButtonStart.Name = "mButtonStart";
            this.mButtonStart.Size = new System.Drawing.Size(128, 48);
            this.mButtonStart.TabIndex = 1;
            this.mButtonStart.Text = "...";
            this.mButtonStart.UseVisualStyleBackColor = true;
            this.mButtonStart.Click += new System.EventHandler(this.mButtonStart_Click);
            // 
            // mLabelTitleMessage
            // 
            this.mLabelTitleMessage.AutoSize = true;
            this.mLabelTitleMessage.Font = new System.Drawing.Font("Microsoft Sans Serif", 17F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.mLabelTitleMessage.Location = new System.Drawing.Point(6, 4);
            this.mLabelTitleMessage.Name = "mLabelTitleMessage";
            this.mLabelTitleMessage.Size = new System.Drawing.Size(31, 29);
            this.mLabelTitleMessage.TabIndex = 3;
            this.mLabelTitleMessage.Text = "...";
            // 
            // mProgressbarDownloading
            // 
            this.mProgressbarDownloading.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Bottom | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.mProgressbarDownloading.Location = new System.Drawing.Point(8, 600);
            this.mProgressbarDownloading.Name = "mProgressbarDownloading";
            this.mProgressbarDownloading.Size = new System.Drawing.Size(862, 25);
            this.mProgressbarDownloading.TabIndex = 5;
            // 
            // mCheckboxRunPatched
            // 
            this.mCheckboxRunPatched.AutoSize = true;
            this.mCheckboxRunPatched.Location = new System.Drawing.Point(6, 19);
            this.mCheckboxRunPatched.Name = "mCheckboxRunPatched";
            this.mCheckboxRunPatched.Size = new System.Drawing.Size(125, 17);
            this.mCheckboxRunPatched.TabIndex = 6;
            this.mCheckboxRunPatched.Text = "Run patched version";
            this.mCheckboxRunPatched.UseVisualStyleBackColor = true;
            // 
            // mGroupOptions
            // 
            this.mGroupOptions.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.mGroupOptions.Controls.Add(this.mLabelCrosshaircolor);
            this.mGroupOptions.Controls.Add(this.mTextBoxCrosshaircolor);
            this.mGroupOptions.Controls.Add(this.mCheckboxRunPatched);
            this.mGroupOptions.Location = new System.Drawing.Point(755, 36);
            this.mGroupOptions.Name = "mGroupOptions";
            this.mGroupOptions.Size = new System.Drawing.Size(244, 408);
            this.mGroupOptions.TabIndex = 7;
            this.mGroupOptions.TabStop = false;
            this.mGroupOptions.Text = "Options";
            // 
            // mLabelCrosshaircolor
            // 
            this.mLabelCrosshaircolor.AutoSize = true;
            this.mLabelCrosshaircolor.Location = new System.Drawing.Point(3, 43);
            this.mLabelCrosshaircolor.Name = "mLabelCrosshaircolor";
            this.mLabelCrosshaircolor.Size = new System.Drawing.Size(76, 13);
            this.mLabelCrosshaircolor.TabIndex = 8;
            this.mLabelCrosshaircolor.Text = "Crosshair color";
            // 
            // mTextBoxCrosshaircolor
            // 
            this.mTextBoxCrosshaircolor.Location = new System.Drawing.Point(6, 59);
            this.mTextBoxCrosshaircolor.Name = "mTextBoxCrosshaircolor";
            this.mTextBoxCrosshaircolor.Size = new System.Drawing.Size(100, 20);
            this.mTextBoxCrosshaircolor.TabIndex = 7;
            // 
            // mWebBrowser
            // 
            this.mWebBrowser.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.mWebBrowser.Location = new System.Drawing.Point(6, 36);
            this.mWebBrowser.MinimumSize = new System.Drawing.Size(20, 20);
            this.mWebBrowser.Name = "mWebBrowser";
            this.mWebBrowser.Size = new System.Drawing.Size(743, 446);
            this.mWebBrowser.TabIndex = 8;
            this.mWebBrowser.Url = new System.Uri("", System.UriKind.Relative);
            // 
            // tabControl1
            // 
            this.tabControl1.Anchor = ((System.Windows.Forms.AnchorStyles)((((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.tabControl1.Controls.Add(this.tabPage1);
            this.tabControl1.Controls.Add(this.tabPage2);
            this.tabControl1.Location = new System.Drawing.Point(0, 2);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(1030, 657);
            this.tabControl1.TabIndex = 9;
            // 
            // tabPage1
            // 
            this.tabPage1.Controls.Add(this.mProgressbarDownloading);
            this.tabPage1.Controls.Add(this.mButtonStart);
            this.tabPage1.Controls.Add(this.mWebBrowser);
            this.tabPage1.Controls.Add(this.mGroupOptions);
            this.tabPage1.Controls.Add(this.mLabelTitleMessage);
            this.tabPage1.Controls.Add(this.mTextBoxDebug);
            this.tabPage1.Location = new System.Drawing.Point(4, 22);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage1.Size = new System.Drawing.Size(1022, 631);
            this.tabPage1.TabIndex = 0;
            this.tabPage1.Text = "Launcher";
            this.tabPage1.UseVisualStyleBackColor = true;
            // 
            // tabPage2
            // 
            this.tabPage2.Controls.Add(this.mListBoxTexturesMod);
            this.tabPage2.Controls.Add(this.mListBoxTextures);
            this.tabPage2.Controls.Add(this.button1);
            this.tabPage2.Location = new System.Drawing.Point(4, 22);
            this.tabPage2.Name = "tabPage2";
            this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage2.Size = new System.Drawing.Size(1022, 631);
            this.tabPage2.TabIndex = 1;
            this.tabPage2.Text = "Textures";
            this.tabPage2.UseVisualStyleBackColor = true;
            // 
            // mListBoxTexturesMod
            // 
            this.mListBoxTexturesMod.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.mListBoxTexturesMod.FormattingEnabled = true;
            this.mListBoxTexturesMod.HorizontalScrollbar = true;
            this.mListBoxTexturesMod.Location = new System.Drawing.Point(3, 67);
            this.mListBoxTexturesMod.Name = "mListBoxTexturesMod";
            this.mListBoxTexturesMod.Size = new System.Drawing.Size(489, 550);
            this.mListBoxTexturesMod.TabIndex = 3;
            this.mListBoxTexturesMod.MouseDoubleClick += new System.Windows.Forms.MouseEventHandler(this.mListBoxTexturesMod_MouseDoubleClick);
            // 
            // mListBoxTextures
            // 
            this.mListBoxTextures.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Right)));
            this.mListBoxTextures.FormattingEnabled = true;
            this.mListBoxTextures.HorizontalScrollbar = true;
            this.mListBoxTextures.Location = new System.Drawing.Point(498, 67);
            this.mListBoxTextures.Name = "mListBoxTextures";
            this.mListBoxTextures.Size = new System.Drawing.Size(518, 550);
            this.mListBoxTextures.TabIndex = 2;
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(8, 25);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 23);
            this.button1.TabIndex = 1;
            this.button1.Text = "button1";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1028, 657);
            this.Controls.Add(this.tabControl1);
            this.Name = "Form1";
            this.ShowIcon = false;
            this.Text = "Gunz2 FanPatcher";
            this.Load += new System.EventHandler(this.Form1_Load);
            this.Shown += new System.EventHandler(this.Form1_Shown);
            this.mGroupOptions.ResumeLayout(false);
            this.mGroupOptions.PerformLayout();
            this.tabControl1.ResumeLayout(false);
            this.tabPage1.ResumeLayout(false);
            this.tabPage1.PerformLayout();
            this.tabPage2.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TextBox mTextBoxDebug;
        private System.Windows.Forms.Button mButtonStart;
        private System.Windows.Forms.Label mLabelTitleMessage;
        private System.Windows.Forms.ProgressBar mProgressbarDownloading;
        private System.Windows.Forms.CheckBox mCheckboxRunPatched;
        private System.Windows.Forms.GroupBox mGroupOptions;
        private System.Windows.Forms.Label mLabelCrosshaircolor;
        private System.Windows.Forms.TextBox mTextBoxCrosshaircolor;
        private System.Windows.Forms.WebBrowser mWebBrowser;
        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TabPage tabPage1;
        private System.Windows.Forms.TabPage tabPage2;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.ListBox mListBoxTextures;
        private System.Windows.Forms.ListBox mListBoxTexturesMod;
    }
}

