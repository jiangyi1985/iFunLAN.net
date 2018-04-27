using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Chat.Class
{
    public class Drawing
    {
        public string HostUserIPAddress { get; set; }
        public string Keyword { get; set; }
        //public string TipLength { get; set; }
        public string TipStep { get; set; }
        //public string TipEndReason { get; set; }
        public int Step { get; set; }
        public DateTime BeginTime { get; set; }
        public DateTime EndTime { get; set; }
        public IList<string> CorrectUsers { get; set; }
        public int idx { get; set; }
    }
}