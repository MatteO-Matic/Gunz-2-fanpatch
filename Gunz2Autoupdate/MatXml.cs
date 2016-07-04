using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Xml.Serialization;

namespace Gunz2AutoUpdate
{
    class MatXml
    {
        public static T ReadXml<T>(string xmlFilepath)
        {
            string xmlContent = File.ReadAllText(xmlFilepath);
            byte[] xmlBytes = System.Text.Encoding.UTF8.GetBytes(xmlContent);
            var stream = new MemoryStream(xmlBytes);
            XmlSerializer serializer = new XmlSerializer(typeof(T));
            T apidata = (T)serializer.Deserialize(stream);

            return apidata;
        }
    }
}
