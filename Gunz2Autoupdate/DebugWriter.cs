using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Windows.Forms;

namespace Gunz2AutoUpdate
{
    class DebugWriter : TextWriter
    {
        private Control textbox;
        public DebugWriter(Control textbox)
        {
            this.textbox = textbox;
        }

        public override void Write(char value)
        {
            invokeText(value.ToString());
        }

        public override void Write(string value)
        {
            invokeText(value);
        }

        void invokeText(string text)
        {
            MethodInvoker mi = delegate
            {
                textbox.Text += text;
            };
            textbox.Invoke(mi);
        }

        public override Encoding Encoding
        {
            get { return Encoding.ASCII; }
        }
    }
}
