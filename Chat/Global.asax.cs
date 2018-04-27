using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.SessionState;
using Chat.Class;
using System.Xml;
using System.Web.Hosting;
using System.IO;

namespace Chat
{
    public class Global : System.Web.HttpApplication
    {

        protected void Application_Start(object sender, EventArgs e)
        {
            Application[CommonConst.A_Chat] = new List<Message>();
            Application[CommonConst.A_Users] = new List<User>();
            Application[CommonConst.A_DrawingUsers] = new List<User>();
            Application[CommonConst.A_DrawingChat] = new List<Message>();

            //Application[CommonConst.A_Users] = new List<User> { new User { FullName = "test1", Username = "ip1" },
            //    new User { FullName = "test2", Username = "ip2" }, 
            //    new User { FullName = "test3", Username = "ip3" } };

            XmlDocument doc = new XmlDocument();
            doc.Load(Path.Combine(HostingEnvironment.ApplicationPhysicalPath , "Users.xml"));
            XmlNodeList nodes = doc.SelectNodes("//user");

            var userList = new Dictionary<string, string>();
            foreach (XmlNode n in nodes)
            {
                userList.Add(n.Attributes["ip"].Value, n.Attributes["name"].Value);
            }
            Application[CommonConst.A_PredefinedUsers] = userList;
        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}