using System.Collections.Generic;

namespace Chat.Class
{
    public static class CommonConst
    {
        public static string S_User = "Session_User";

        public static string A_Chat = "App_Chat";
        public static string A_Users = "App_Users";
        public static string A_Drawing = "App_Drawing";
        public static string A_DrawingUsers = "App_DrawingUsers";
        public static string A_DrawingControl = "App_DrawingControl";
        public static string A_DrawingChat = "App_DrawingChat";
        public static string A_PredefinedUsers = "App_PredefinedUsers";

        public static User GetUserByIP(string ipAddress, object dic)
        {
            var user = new User {IPAddress = ipAddress};

            var list = (Dictionary<string, string>) dic;
            if (list.ContainsKey(user.IPAddress))
                user.FullName = list[user.IPAddress];
            else
                user.FullName = user.IPAddress;
            return user;
        }
    }
}