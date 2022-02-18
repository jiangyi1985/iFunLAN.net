using Microsoft.AspNetCore.Http.Features;
using Microsoft.AspNetCore.SignalR;

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

        public async Task<string> GetUuid(string name)
        {
            return _gameHost.GetUser(Context.ConnectionId).Uuid;
        }

        public async Task Move(string userId, float x, float y)
        {
            //var httpFeature = Context.Features.Get<IHttpConnectionFeature>();
            //var ip = httpFeature.RemoteIpAddress.ToString();

            await Clients.All.SendAsync("UserMove", userId, x, y);
        }
    }
}
