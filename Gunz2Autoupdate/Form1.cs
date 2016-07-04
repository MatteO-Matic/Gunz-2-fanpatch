using System;
using System.ComponentModel;
using System.Windows.Forms;
using System.Net;
using System.Diagnostics;
using System.Reflection;
using System.IO;
using System.Collections.Generic;
using System.Text.RegularExpressions;

namespace Gunz2AutoUpdate
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }
        //config file string
        string sourceCfg = System.Environment.CurrentDirectory + "\\TTConfig.cfg";
        //local file version
        readonly string mLocalVersionString = "\\IVersion.xml";
        //patcher location
        string str = System.Environment.CurrentDirectory;
        //current installed version
        VersionHolder mInstallVersion = new VersionHolder();
        //True if a newer update exists
        bool isUpdate = false;

        string crosshairColor = "FFFFFF";

        VersionHolder mMostCurrentVersion = new VersionHolder();

        public bool IsUpdate
        {
            get { return isUpdate; }

            set
            {
                isUpdate = value;

                if (isUpdate)
                {
                    mButtonStart.Text = "Update";
                }
                else
                {
                    mButtonStart.Text = "Start game";
                }
                mButtonStart.Enabled = true;
            }
        }

        private void FillFormFromXml(VersionHolder vh)
        {
            if (vh != null && vh.Version != null && vh.ChangeLog != null)
            {
                mLabelTitleMessage.Text = vh.Title + " - " + vh.Version;
                if (vh.ChangeLog != String.Empty)
                {
                    mWebBrowser.Url = new Uri(vh.ChangeLog);
                }
            }
        }

        private void CheckForUpdate()
        {
            Console.WriteLine("Checking for updates..");
            //Download versionfile
            using (var client = new WebClient())
            {
                client.DownloadFileAsync(new Uri("http://pastebin.com/raw.php?i=p2QuX8ct"), str+"\\Version.xml");
                client.DownloadFileCompleted += Client_DownloadFileCompleted1;
            }
        }

        static private void HandleWebClientException(Exception e)
        {
            Console.WriteLine(e.Message);
        }

        private void Client_DownloadFileCompleted1(object sender, AsyncCompletedEventArgs e)
        {
            if (e.Error == null)
            {
                Console.WriteLine("Version file downloaded..");
                mMostCurrentVersion = MatXml.ReadXml<VersionHolder>(str + "\\Version.xml");
                Console.WriteLine("Most current version: " + mMostCurrentVersion.Version);
                if (mInstallVersion.Version == null || mInstallVersion.Version < mMostCurrentVersion.Version)
                {
                    IsUpdate = true;
                }
                else
                {
                    IsUpdate = false;
                    Console.WriteLine("Already up to date");
                }
                Console.WriteLine("");
            }
            else
            {
                HandleWebClientException(e.Error);
            }
        }

        static bool OnlyHexInString(string test)
        {
            // For C-style hex notation (0xFF) you can use @"\A\b(0[xX])?[0-9a-fA-F]+\b\Z"
            return System.Text.RegularExpressions.Regex.IsMatch(test, @"\A\b[0-9a-fA-F]+\b\Z");
        }

        private void mButtonStart_Click(object sender, EventArgs e)
        {
            if (!IsUpdate)
            {
                //fix ttconfig then start game
                if (File.Exists(sourceCfg))
                {
                    string[] text = File.ReadAllLines(sourceCfg);
                    for (int i = 0; i < text.Length; i++)
                    {
                        string tmp = text[i].Trim();
                        //write if patch should be run config
                        if (tmp.Split('=')[0] == "runpatch")
                        {
                            text[i] = mCheckboxRunPatched.Checked ? "runpatch=true" : "runpatch=false";
                        }
                        //Write crosshair color config
                        if (tmp.Split('=')[0] == "crosshaircolor")
                        {
                            if (mTextBoxCrosshaircolor.Text.Length == 6)
                            {
                                if (OnlyHexInString(mTextBoxCrosshaircolor.Text))
                                {
                                    text[i] = "crosshaircolor=";
                                    text[i] += mTextBoxCrosshaircolor.Text;
                                }
                            }
                        }
                    }
                    File.WriteAllLines(sourceCfg, text);
                }

                StartGame();
                Application.Exit();

            }
            else
            {
                Console.WriteLine("\"Closing\" Gunz2");
                try
                {
                    foreach (Process proc in Process.GetProcessesByName("Gunz2_Steam"))
                    {
                        proc.Kill();
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex.Message);
                }

                UpdateGame();
                mButtonStart.Enabled = false;
            }
        }

        private void UpdateGame()
        {
            Console.WriteLine("Downloding patch..");

            if (mMostCurrentVersion.Url == null)
            {
                Console.WriteLine("Empty download URL..");
            }
            else
            {
                using (WebClient client = new WebClient()) //Download patch
                {
                    if (mMostCurrentVersion.Url != String.Empty)
                    {
                        Uri uri = new Uri(mMostCurrentVersion.Url);
                        client.DownloadFileAsync(uri, str+"\\patch.exe");
                        client.DownloadProgressChanged += Client_DownloadProgressChanged;
                        client.DownloadFileCompleted += Client_DownloadFileCompleted;
                    }
                }
            }
        }

        private void Client_DownloadProgressChanged(object sender, DownloadProgressChangedEventArgs e)
        {
            MethodInvoker mi = delegate
            {
                mProgressbarDownloading.Value = e.ProgressPercentage;
            };
            mProgressbarDownloading.Invoke(mi);

        }

        private void Client_DownloadFileCompleted(object sender, AsyncCompletedEventArgs e)
        {
            if (e.Error == null)
            {
                Process.Start(str + "\\patch.exe");
                //File.Copy(str + "\\Version.xml", str + "\\IVersion.xml", true);
                Console.WriteLine("done");
                IsUpdate = false;
                FillFormFromXml(mMostCurrentVersion);
            }
            else
            {
                HandleWebClientException(e.Error);
            }

        }

        private void StartGame()
        {
            //Check if gunz is already running
            Process[] pname = Process.GetProcessesByName("Gunz2_Steam");
            if (pname.Length == 0) //Gunz2 isn't active, run it
            {
                try
                {
                    Process.Start(str + "\\Gunz2_Steam.exe");
                }
                catch (Win32Exception ex)
                {
                    Console.WriteLine("Win32 exception: " + ex.NativeErrorCode.ToString());
                    Console.WriteLine(ex.Message);
                }
                catch (Exception ex)
                {
                    MessageBox.Show("exception: " + ex.Message);
                }
            }
        }

        private void CreateStorageFiles()
        {
            try
            {
                if (!File.Exists(str + "\\debug.txt"))
                {
                    File.Create(str + "\\debug.txt");
                }
                if (!File.Exists(str + "\\debug2.txt"))
                {
                    File.Create(str + "\\debug2.txt");
                }

                if (!File.Exists(sourceCfg))
                {
                    using (StreamWriter sw = File.CreateText(sourceCfg))
                    {
                        sw.WriteLine("crosshaircolor=FFFFFF");
                        sw.WriteLine("runpatch=true");
                    }
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }

        private void Form1_Shown(object sender, EventArgs e)
        {
            Console.SetOut(new DebugWriter(mTextBoxDebug));
            mWebBrowser.ScriptErrorsSuppressed = true;

            CreateStorageFiles();
            //set url
            //Check for local version file
            if (File.Exists(str + mLocalVersionString))
            {
                mInstallVersion = MatXml.ReadXml<VersionHolder>(str + mLocalVersionString);
                Console.WriteLine("Installed version: " + mInstallVersion.Version);
                if (File.Exists(sourceCfg))
                {
                    using (StreamReader reader = new StreamReader(sourceCfg))
                    {
                        while (!reader.EndOfStream)
                        {
                            string line = reader.ReadLine();
                            line = line.Trim();
                            string key = line.Split('=')[0];
                            string value = line.Split('=')[1];

                            //Set the checkbox if we should run the patch or not
                            if (key == "runpatch" && value == "true")
                            {
                                mCheckboxRunPatched.Checked = true;
                            }
                            else
                            {
                                mCheckboxRunPatched.Checked = false;
                            }

                            if (key == "crosshaircolor")
                            {
                                crosshairColor = value;
                                mTextBoxCrosshaircolor.Text = crosshairColor;
                            }
                        }
                    }
                }
                else
                {
                    Console.WriteLine("File not found: " + sourceCfg);
                    mCheckboxRunPatched.Checked = false;
                    mCheckboxRunPatched.Enabled = false;
                }
            }
            else
            {
                Console.WriteLine("No local versionfile");
                Console.WriteLine(str + mLocalVersionString);
                Console.WriteLine("Installed version: -");
            }

            CheckForUpdate();
            FillFormFromXml(mInstallVersion);
        }

        private void Form1_Load(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            System.IO.DirectoryInfo textureDir = new DirectoryInfo(str + "\\Data\\Texture");
            List<string> textures = WalkDirectoryTree(textureDir);

            foreach (var item in textures)
            {
                mListBoxTextures.Items.Add(item);
            }

            System.IO.DirectoryInfo texturesDirMod = new DirectoryInfo(str + "\\Data\\TextureOfficial");
            List<string> texturesMod = WalkDirectoryTree(texturesDirMod);

            foreach (var item in texturesMod)
            {
                mListBoxTexturesMod.Items.Add(item);
            }
        }

        List<string> WalkDirectoryTree(System.IO.DirectoryInfo root)
        {
            List<string> returnFiles = new List<string>();
            System.IO.FileInfo[] files = null;
            System.IO.DirectoryInfo[] subDirs = null;

            // First, process all the files directly under this folder
            try
            {
                files = root.GetFiles("*.*");
            }
            catch (UnauthorizedAccessException e)
            {
                Console.WriteLine(e.Message);
            }
            catch (System.IO.DirectoryNotFoundException e)
            {
                Console.WriteLine(e.Message);
            }

            if (files != null)
            {
                foreach (System.IO.FileInfo fi in files)
                {
                    returnFiles.Add(fi.FullName);
                }

                // Now find all the subdirectories under this directory.
                subDirs = root.GetDirectories();

                foreach (System.IO.DirectoryInfo dirInfo in subDirs)
                {
                    returnFiles.AddRange(WalkDirectoryTree(dirInfo));
                }
            }
            return returnFiles;
        }

        private void mListBoxTexturesMod_MouseDoubleClick(object sender, MouseEventArgs e)
        {
            string selected = mListBoxTexturesMod.Items[mListBoxTexturesMod.SelectedIndex].ToString();

            string pattern = @"\\Texture\\";
            Match m = Regex.Match(selected, pattern);

            while (m.Success)
            {

                Console.WriteLine(selected.Substring(m.Index));
                //  Directory.CreateDirectory(str + "\\Data\\" + selected.Substring(m.Index));
                //   File.Copy(selected, str + "\\Data\\" + selected.Substring(m.Index));

                m.NextMatch();
            }
        }
    }
}
