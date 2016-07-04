using System;
using System.Collections.Generic;
using System.Text;
using System.Xml.Serialization;

namespace Gunz2AutoUpdate
{
    [Serializable()]
    [XmlRoot(ElementName = "item")]
    public class VersionHolder
    {
        [XmlElement("title")]
        public string Title { get; set; }

        Version _version = new Version();

        public Version Version
        {
            get
            {
                return _version;
            }
        }

        [XmlElement("version")]
        public string VersionString
        {
            get
            {
                return _version.ToString();
            }
            set
            {
                _version = new Version(value);
            }
        }

        [XmlElement("url")]
        public string Url { get; set; }

        [XmlElement("changelog")]
        public string ChangeLog { get; set; }
    }
}
