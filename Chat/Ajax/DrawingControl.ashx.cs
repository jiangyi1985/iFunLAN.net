using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.SessionState;
using Chat.Class;
using Newtonsoft.Json;
using System.IO;

namespace Chat.Ajax
{
    /// <summary>
    /// DrawingControl の概要の説明
    /// </summary>
    public class DrawingControl : IHttpHandler, IRequiresSessionState
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

            //Online Users
            var users = context.Application[CommonConst.A_DrawingUsers] as IList<User>;
            if (users.Count(o => o.IPAddress == user.IPAddress) == 0)
            {
                user.LastOnlineTimeDrawing = DateTime.Now;
                users.Add(user);
            }
            else
            {
                var appUser = users.Single(o => o.IPAddress == user.IPAddress);
                appUser.LastOnlineTimeDrawing = DateTime.Now;
            }
            context.Application[CommonConst.A_DrawingUsers] = users;

            var online = users.Where(o => (DateTime.Now - o.LastOnlineTimeDrawing).TotalSeconds < 5);


            //chat
            var messages = context.Application[CommonConst.A_DrawingChat] as IList<Message>;
            var lastID = Convert.ToInt32(context.Request.QueryString["LastID"]);
            //save new message
            String strChat = null;
            var msgID = 0;
            if (context.Request.QueryString["Content"] != null)
            {
                strChat = context.Request.QueryString["Content"];
                msgID = messages.Count + 1;
                messages.Add(new Message { Content = strChat, Sender = user, Time = DateTime.Now, ID = msgID });
            }
            var @where = lastID > messages.Count ? messages : messages.Where(o => o.ID > lastID);
            string timeMask = "HH:mm:ss";
            var arrChat = from m in @where
                          select new { Content = m.Content, ID = m.ID, User = m.Sender.FullName, Time = m.Time.ToString(timeMask) };


            //Drawing Controlling
            var draw = context.Application[CommonConst.A_DrawingControl] == null
                ? new Class.Drawing
                {
                    Keyword = "",
                    HostUserIPAddress = "",
                    Step = 0
                }
                : (Class.Drawing)context.Application[CommonConst.A_DrawingControl];


            switch (draw.Step)
            {
                case 0:
                    if (online.Count() > 1)
                    {
                        NewGame(online, draw);
                    }
                    else if (String.IsNullOrEmpty(draw.TipStep))
                    {
                        draw.TipStep = "等待其他玩家进入。。。";
                        //draw.TipStep += "<br/>暫くお待ちください。。。";
                    }
                    break;
                case 1:
                    if (online.Count() <= 1)
                    {
                        draw.Step = 0;
                        draw.EndTime = DateTime.Now;
                        //draw.TipEndReason = "人数不足，游戏中断。";
                        draw.TipStep = "人数不足，游戏中断。等待其他玩家进入。。。";
                        //draw.TipStep += "<br/>ゲームが中断しました。暫くお待ちください。。。";
                    }
                    else if (online.Count(o => o.IPAddress == draw.HostUserIPAddress) == 0 && online.Count() > 1)
                    {
                        draw.Step = 2;
                        draw.EndTime = DateTime.Now;
                        //draw.TipEndReason = "作画者离开了游戏。";
                        draw.TipStep = "作画者离开了游戏。10秒后开始新游戏。。。";
                        //draw.TipStep += "<br/>作画者が離れました。10秒後新しいゲームを開始。。。";
                    }
                    else if ((DateTime.Now - draw.BeginTime).TotalSeconds <= 60)
                    {
                        draw.TipStep = "游戏进行中。。。剩余时间 " + (60 - Math.Round((DateTime.Now - draw.BeginTime).TotalSeconds)) + " 秒{0}";
                        //draw.TipStep += "<br/>ゲーム進行中。。。残り時間 " + (60 - Math.Round((DateTime.Now - draw.BeginTime).TotalSeconds)) + " 秒{1}";

                        //是否回答正确
                        if (user.IPAddress != draw.HostUserIPAddress && draw.CorrectUsers.Count(o => o == user.IPAddress) == 0)
                        {
                            if (strChat == draw.Keyword)
                            {
                                draw.CorrectUsers.Add(user.IPAddress);

                                //如果超过两个人 答对问题不要显示答案
                                if (online.Count() > 2)
                                    messages.Last().Content = "**** （正解！）";
                                else
                                    messages.Last().Content = messages.Last().Content + " （正解！）";
                            }
                        }

                        //除了作画者以外的人 全部答对就结束游戏
                        if (online.Count(o => o.IPAddress != draw.HostUserIPAddress && draw.CorrectUsers.Count(p => p == o.IPAddress) == 0) == 0)
                        {
                            draw.Step = 2;
                            draw.EndTime = DateTime.Now;
                            //draw.TipEndReason = "时间到。";
                            draw.TipStep = "游戏结束。答案是 " + draw.Keyword + " 。10秒后开始新游戏。。。";
                            //draw.TipStep += "ゲーム終了。回答は " + draw.Keyword + " です。10秒後新しいゲームを開始。。。";
                        }

                        if (user.IPAddress == draw.HostUserIPAddress)
                        {
                            draw.TipStep = draw.TipStep.Replace("{0}", "   你要画的是：" + draw.Keyword);
                            //draw.TipStep = draw.TipStep.Replace("{1}", "   これを描いてください：" + draw.Keyword);
                        }
                        else
                        {

                            //二级提示
                            if ((DateTime.Now - draw.BeginTime).TotalSeconds > 45)
                            {
                                if (draw.idx == -1)
                                {
                                    var random = new Random();
                                    draw.idx = random.Next(0, draw.Keyword.Length);
                                }
                                string result = "";
                                for (var i = 0; i < draw.Keyword.Length; i++)
                                    result += "※";
                                result = result.Substring(0, draw.idx) + draw.Keyword[draw.idx] + result.Substring(draw.idx + 1);

                                draw.TipStep = draw.TipStep.Replace("{0}", "   提示：" + result);
                                //draw.TipStep = draw.TipStep.Replace("{1}", "   ヒント：" + result);
                            }
                            //一级提示
                            else if ((DateTime.Now - draw.BeginTime).TotalSeconds > 10)
                            {
                                draw.TipStep = draw.TipStep.Replace("{0}", "   提示：" + draw.Keyword.Length + "个字");
                                //draw.TipStep = draw.TipStep.Replace("{1}", "   ヒント：" + draw.Keyword.Length + "個文字");
                            }
                            else
                            {
                                draw.TipStep = draw.TipStep.Replace("{0}", "");
                                //draw.TipStep = draw.TipStep.Replace("{1}", "");
                            }
                        }
                    }
                    else
                    {
                        draw.Step = 2;
                        draw.EndTime = DateTime.Now;
                        //draw.TipEndReason = "时间到。";
                        draw.TipStep = "游戏结束。答案是 " + draw.Keyword + " 。10秒后开始新游戏。。。";
                        //draw.TipStep += "<br/>ゲーム終了。回答は " + draw.Keyword + " です。10秒後新しいゲームを開始。。。";

                        //id = messages.Count + 1;
                        //messages.Add(new Message { Content = "", Sender = new User { FullName="系统"}, Time = DateTime.Now, ID = id });
                    }
                    break;
                case 2:
                    if ((DateTime.Now - draw.EndTime).TotalSeconds < 10)
                    {
                        draw.TipStep = "游戏结束。答案是 " + draw.Keyword + " 。" + (10 - Math.Round((DateTime.Now - draw.EndTime).TotalSeconds)) + "秒后开始新游戏。。。";
                        //draw.TipStep += "<br/>ゲーム終了。回答は " + draw.Keyword + " です。" + (10 - Math.Round((DateTime.Now - draw.EndTime).TotalSeconds)) + "秒後新しいゲームを開始。。。";
                    }
                    else if (online.Count() <= 1)
                    {
                        draw.Step = 0;
                        draw.EndTime = DateTime.Now;
                        //draw.TipEndReason = "人数不足。";
                        draw.TipStep = "人数不足。等待其他玩家进入。。。";
                        //draw.TipStep += "<br/>人数不足。暫くお待ちください。。。";
                    }
                    else
                    {
                        NewGame(online, draw);
                    }
                    break;
                default:
                    break;
            }

            if (draw.HostUserIPAddress == "" || online.Count(o => o.IPAddress == draw.HostUserIPAddress) == 0)
            {

            }

            context.Application[CommonConst.A_DrawingControl] = draw;

            //output
            var arr = from m in online
                      orderby m.IPAddress ascending
                      select new
                      {
                          User = m.FullName,
                          Tip = draw.Step == 1//游戏中
                                    ? (m.IPAddress == draw.HostUserIPAddress
                                        ? "（作画中。。。）"
                                        : (draw.CorrectUsers.Count(o => o == m.IPAddress) > 0
                                            ? "（正解！）"
                                            : "（回答中。。。）"))
                                    : (draw.Step == 2//游戏结束后
                                        ? (m.IPAddress == draw.HostUserIPAddress
                                            ? "（作画者）"
                                            : (draw.CorrectUsers.Count(o => o == m.IPAddress) > 0
                                            ? "（正解！）"
                                            : "（残念。。。）"))
                                        : ""),
                          IP = m.IPAddress//+m.LastOnlineTime+m.LastOnlineTimeDrawing
                      };

            var serial = JsonConvert.SerializeObject(new
            {
                Users = arr,
                Chat = arrChat,
                isDraw = draw.HostUserIPAddress == user.IPAddress,
                isGuess = draw.HostUserIPAddress != user.IPAddress,
                Step = draw.Step,
                Tip = //draw.TipEndReason + 
                draw.TipStep,
                Keyword = draw.Keyword
            });

            //context.Response.ContentType = "text/plain";
            context.Response.Write(serial);
        }

        private static void NewGame(IEnumerable<User> online, Class.Drawing draw)
        {
            Random r = new Random();
            int ran = r.Next(1, online.Count() + 1);
            draw.HostUserIPAddress = online.ToList()[ran - 1].IPAddress;


            StreamReader sr = File.OpenText(Path.Combine(HttpContext.Current.Request.PhysicalApplicationPath, "Dictionary.txt"));
            IList<string> dictionary = new List<string>();
            while (!sr.EndOfStream)
            {
                dictionary.Add(sr.ReadLine());
            }

            ran = r.Next(1, dictionary.Count + 1);
            draw.Keyword = dictionary.Distinct().ToList()[ran];

            //draw.TipLength = draw.Keyword.Length + "个字";
            draw.Step = 1;
            draw.BeginTime = DateTime.Now;

            draw.CorrectUsers = new List<string>();
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