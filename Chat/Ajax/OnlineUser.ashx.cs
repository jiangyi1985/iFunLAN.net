using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using Chat.Class;
using System.Web.SessionState;

namespace Chat.Ajax
{
    /// <summary>
    /// OnlineUser の概要の説明
    /// </summary>
    public class OnlineUser : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            //context.Response.ContentType = "text/plain";
            //context.Response.Write("Hello World");

            if (context.Session[CommonConst.S_User] == null)
            {
                context.Session[CommonConst.S_User] = CommonConst.GetUserByIP(context.Request.UserHostAddress, context.Application[CommonConst.A_PredefinedUsers]);
            }

            User user = (User)context.Session[CommonConst.S_User];

            var users = context.Application[CommonConst.A_Users] as IList<User>;

            ////update user online status
            //if (users.Count(o => o.Username == user.Username) == 0)
            //{
            //    users.Add(user);
            //    context.Application[CommonConst.A_Users] = users;
            //}

            //var @where = users.Where(o => o.Username != user.Username);
            var online = users.Where(o => (DateTime.Now - o.LastOnlineTime).TotalSeconds < 5);

            ////set offline time
            //var offline = users.Where(o => online.Count(p => p.IPAddress == o.IPAddress) == 0);
            //foreach (var u in offline)
            //{
            //    u.LastOfflineTime = DateTime.Now;
            //}

            //response
            var arr = from m in online//users//online//@where
                      orderby m.IPAddress ascending
                      //select new { User = m.FullName //+ " " + m.IPAddress
                      //    +" "//+ " lastOnline:"
                      //    + m.LastOnlineTime.ToLongTimeString()
                      //+ " " + DateTime.Now.ToLongTimeString()
                      //};
                      select new { User = m.FullName };

            var serial = JsonConvert.SerializeObject(arr);

            //context.Response.ContentType = "text/plain";
            context.Response.Write(serial);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}