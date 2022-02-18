using System.Collections.Concurrent;

namespace iFunNet.WebApi
{
    public class GameHost
    {
        private readonly ConcurrentDictionary<string, User> _users = new ConcurrentDictionary<string, User>();

        internal void AddUser(string connectionId, string guid)
        {
            var user = new User { ConnectionId=connectionId,Uuid=guid };
            _users.TryAdd(user.ConnectionId, user);
        }

        internal User GetUser(string connectionId)
        {
            _users.TryGetValue(connectionId, out User user);
            return user;
        }
    }

    public class User
    {
        public string ConnectionId { get; set; }
        public string Uuid { get; set; }
        public string Name { get; set; }
    }
}
