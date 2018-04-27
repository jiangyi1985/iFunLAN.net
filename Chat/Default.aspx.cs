using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using Chat.Class;
using Chat.Web;
using System.IO;
using System.Web.UI.HtmlControls;
using System.Xml;

namespace Chat
{
    public partial class Default : MyPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ddlTo.Items.Add(new ListItem("全員", ""));

            var dicIpName = (Dictionary<string, string>)HttpContext.Current.Application[CommonConst.A_PredefinedUsers];
            foreach (var ip_name in dicIpName)
            {
                if (ddlTo.Items.FindByValue(ip_name.Value) == null && ip_name.Value != User.FullName)
                    ddlTo.Items.Add(new ListItem(ip_name.Value, ip_name.Value));
            }


            var list = Directory.GetFiles(Path.Combine(Request.PhysicalApplicationPath, "Image", "MissingBear"));//gif jpg
            //list = list.OrderBy(o => Path.GetExtension(o)).ToArray();
            foreach (var path in list)
                divEmoji.Controls.Add(new Image() { ImageUrl = "Image/MissingBear/" + HttpUtility.UrlEncode(Path.GetFileName(path)) });
        }
    }
}