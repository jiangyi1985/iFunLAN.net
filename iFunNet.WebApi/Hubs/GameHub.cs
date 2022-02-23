using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.SignalR;
using System.Threading.Channels;

namespace iFunNet.WebApi.Hubs
{
    public class GameHub : Hub
    {
        private readonly GameHost _gameHost;

        public GameHub(GameHost gameHost)
        {
            _gameHost = gameHost;
        }

        public override Task OnConnectedAsync()
        {
            _gameHost.AddUser(Context.ConnectionId, Guid.NewGuid().ToString());

            return base.OnConnectedAsync();
        }

        public override Task OnDisconnectedAsync(Exception? exception)
        {
            return base.OnDisconnectedAsync(exception);
        }

        public ChannelReader<User> StreamUsers()
        {
            return _gameHost.StreamUsers().AsChannelReader(10);
        }

        public string Login(string name)
        {
            var user = _gameHost.GetUser(Context.ConnectionId);
            user.Name = name;

            Clients.AllExcept(Context.ConnectionId).SendAsync("UserCreate", user.Uuid,user.Name);

            return user.Uuid;
        }

        public async Task Move(float x, float y)
        {
            //var httpFeature = Context.Features.Get<IHttpConnectionFeature>();
            //var ip = httpFeature.RemoteIpAddress.ToString();
            
            var user = _gameHost.GetUser(Context.ConnectionId);
            user.X = x;
            user.Y = y;

            //_gameHost.Notify(user);

            //await Clients.All.SendAsync("UserMove", user.Uuid, user.X, user.Y);
        }
    }
}
