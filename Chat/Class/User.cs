using System;
namespace Chat.Class
{
    public class User
    {
        public string IPAddress { get; set; }
        public string FullName { get; set; }
        public DateTime LastOnlineTime { get; set; }
        public DateTime LastOnlineTimeDrawing { get; set; }
    }
}
