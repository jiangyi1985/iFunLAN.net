//using System;
//using System.Web;
//using Chat.Class;
//using System.Collections.Generic;
//using System.Linq;
//using System.Web.SessionState;

//namespace Chat.Web
//{
//    public class MyModule : IHttpModule, IRequiresSessionState
//    {
//        /// <summary>
//        /// Web を使用するには、Web の web.config ファイルでこの
//        /// モジュールを設定し、IIS に登録する必要があります。詳細については、
//        /// 次のリンクを参照してください: http://go.microsoft.com/?linkid=8101007
//        /// </summary>
//        #region IHttpModule Members

//        public void Dispose()
//        {
//            //後処理用コードはここに追加します。
//        }

//        public void Init(HttpApplication context)
//        {
//            //// LogRequest イベントの処理方法とそれに対するカスタム ログの
//            ////実装方法の例を以下に示します。 
//            //context.LogRequest += new EventHandler(OnLogRequest);

//            try
//            {


//                //update online user list
//                User user = (User)context.Session[CommonConst.S_User];
//                var users = context.Application[CommonConst.A_Users] as IList<User>;

//                if (users.Count(o => o.IPAddress == user.IPAddress) == 0)
//                {
//                    users.Add(user);
//                    context.Application[CommonConst.A_Users] = users;
//                }

//            }
//            catch (HttpException e)
//            {
//            }
//        }

//        #endregion

//        public void OnLogRequest(Object source, EventArgs e)
//        {
//            //カスタム ログのロジックはここに挿入します。
//        }
//    }
//}
