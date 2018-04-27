using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Chat.Class;
using Newtonsoft.Json;
using System.Web.SessionState;
using System.Diagnostics;

namespace Chat.Ajax
{
    /// <summary>
    /// Chat の概要の説明
    /// </summary>
    public class Chat : IHttpHandler, IRequiresSessionState
    {
        public void ProcessRequest(HttpContext context)
        {

            if (context.Session[CommonConst.S_User] == null)
            {
                context.Session[CommonConst.S_User] = CommonConst.GetUserByIP(context.Request.UserHostAddress, context.Application[CommonConst.A_PredefinedUsers]);
            }

            User user = (User)context.Session[CommonConst.S_User];

            //update user online status
            var users = context.Application[CommonConst.A_Users] as IList<User>;
            if (users.Count(o => o.IPAddress == user.IPAddress) == 0)
            {
                user.LastOnlineTime = DateTime.Now;
                users.Add(user);
            }
            else
            {
                var appUser = users.Single(o => o.IPAddress == user.IPAddress);
                appUser.LastOnlineTime = DateTime.Now;
            }
            context.Application[CommonConst.A_Users] = users;


            var messages = context.Application[CommonConst.A_Chat] as IList<Message>;

            var lastID = Convert.ToInt32(context.Request.QueryString["LastID"]);

            //Debug.WriteLine("QueryString:"+context.Request.QueryString["LastID"].ToString()+" "+ user.FullName);

            //save new message
            //if (context.Request.QueryString["Content"] != null)
            bool isPostingForm = false;
            try
            {
                if (context.Request.Form.Count > 0)
                {
                    isPostingForm = true;
                }
            }
            catch (HttpRequestValidationException e)
            {
                isPostingForm = true;
            }

            if (isPostingForm)
            {
                //var str = context.Request.QueryString["Content"];
                var str = context.Request.Form[0];

                var id = messages.Count + 1;
                //var id = (messages.Count == 0 ? 0 : messages.Max(o => o.ID)) + 1;
                //var id = DateTime.Now.Ticks;

                messages.Add(new Message
                {
                    Content = str,
                    Sender = user,
                    Time = DateTime.Now,
                    ID = id,
                    IsPic = context.Request.QueryString["isPic"] != null,
                    From = user.FullName,
                    To = context.Request.QueryString["to"]
                });
            }

            //Debug.WriteLine("save new :" + id);

            //if (lastID > messages.Count()) //服务器重启
            //{
            //}

            //if(messages.Count()>0)
            //    Debug.WriteLine(lastID + " " + messages.Last().ID );


            //response
            //var @where = messages.Where(o => o.ID > lastID);
            var @where = messages.Where(o => o.To == "" || o.From == user.FullName || o.To == user.FullName);//过滤不是自己消息
            @where = lastID > messages.Count ? @where : @where.Where(o => o.ID > lastID);//过滤已经收到过的消息

            //string timeMask = "MM/dd HH:mm:ss";
            string timeMask = "HH:mm:ss";

            var arr = from m in @where
                      select new { Content = m.Content, ID = m.ID, User = m.Sender.FullName, Time = m.Time.ToString(timeMask), IsPic = m.IsPic, To=m.To, From=m.From };
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