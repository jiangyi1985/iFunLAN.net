using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Chat.Class;

namespace Chat.Web
{
    public class MyPage : System.Web.UI.Page
    {
        public User User { get; set; }

        protected override void OnPreInit(EventArgs e)
        {
            base.OnPreInit(e);

            if (Session[CommonConst.S_User] == null)
            {
                Session[CommonConst.S_User] = CommonConst.GetUserByIP(Request.UserHostAddress, HttpContext.Current.Application[CommonConst.A_PredefinedUsers]);
            }

            User = (User)Session[CommonConst.S_User];
        }
    }
}