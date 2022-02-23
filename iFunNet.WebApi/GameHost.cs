using System.Collections.Concurrent;
using System.Reactive.Subjects;

namespace iFunNet.WebApi
{
    public class GameHost
    {
        private readonly ConcurrentDictionary<string, User> _users = new ConcurrentDictionary<string, User>();
        private readonly Timer _timer;
        private readonly TimeSpan _updateInterval = TimeSpan.FromMilliseconds(50);
        private readonly Subject<User> _subject = new Subject<User>();

        public GameHost() {
            _timer = new Timer(UpdateUsers, null, _updateInterval, _updateInterval);
        }

        private void UpdateUsers(object? state)
        {
            foreach (var user in _users.Values)
                _subject.OnNext(user);
        }

        internal void AddUser(string connectionId, string guid)
        {
            var user = new User { 
                Uuid=guid,            
            };
            _users.TryAdd(connectionId, user);

            //_subject.OnNext(user);
        }

        internal User GetUser(string connectionId)
        {
            _users.TryGetValue(connectionId, out var user);
            return user;
        }

        internal IObservable<User> StreamUsers()
        {
            return _subject;
        }

        internal void Notify(User user)
        {
            _subject.OnNext(user);
        }
    }

    public class User
    {
        //public string ConnectionId { get; set; }
        public string Uuid { get; set; }
        public string Name { get; set; }
        public float X { get;  set; }
        public float Y { get;  set; }
        //public string text { get; set; }
    }
}
