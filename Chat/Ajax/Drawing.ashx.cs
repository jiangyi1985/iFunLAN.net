using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Chat.Class;
using Newtonsoft.Json;
using System.Web.SessionState;

namespace Chat.Ajax
{
    /// <summary>
    /// Drawing の概要の説明
    /// </summary>
    public class Drawing : IHttpHandler, IRequiresSessionState
    {

        public void ProcessRequest(HttpContext context)
        {
            if (context.Session[CommonConst.S_User] == null)
            {
                context.Session[CommonConst.S_User] = CommonConst.GetUserByIP(context.Request.UserHostAddress,context.Application[CommonConst.A_PredefinedUsers]);
            }

            User user = (User)context.Session[CommonConst.S_User];

            //save new message
            if (context.Request.Form.Count>0)
            {
                var imgData = context.Request.Form[0];

                context.Application[CommonConst.A_Drawing] = imgData;
            }
            else
            {
                var data = context.Application[CommonConst.A_Drawing];

                //var obj = new { Content = data };
                //var serial = JsonConvert.SerializeObject(obj);

                ////context.Response.ContentType = "text/plain";
                //context.Response.Write(serial);

                //context.Response.ContentType = "image/octet-stream";
                context.Response.Write(data);
            }
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