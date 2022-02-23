"use strict";

var connection = new signalR.HubConnectionBuilder().withUrl("/gameHub")
    .withHubProtocol(new signalR.protocols.msgpack.MessagePackHubProtocol()) //use binary instead of json, 1/2~1/3 smaller data transfer
    .build();

//client side methods (for server to call)
//connection.on("UserMove", function (userUid, x, y) {
//    console.log('from gameHub: UserMove', userUid, x, y);

//    playerMoveTo(userUid, x, y);
//});
//connection.on("UserCreate", function (userUid, userName) {
//    console.log('from gameHub: UserCreate', userUid, userName);

//    playerCreateNew(userUid, userName);
//});

//streaming
function startStreaming() {
    connection.stream("StreamUsers").subscribe({
        close: false,
        next: updateUser,
        error: function (err) {
            logger.log(err);
        }
    });
}

//start
connection.start().then(function () {//connected

    onServerConnected();

    startStreaming();

}).catch(function (err) {
    return console.error(err.toString());
});

//calls server method
var gameHub = {
    move: function (x, y) {
        console.log('to gameHub: Move', x, y);
        connection.invoke("Move", x, y).catch(function (err) {
            return console.error(err.toString());
        });
    },
    login: function (name) {
        console.log('to gameHub: Login', name);
        //debugger;
        return connection.invoke("Login", name)
            .catch(function (err) {
                return console.error(err.toString());
            }).then(result => {
                console.log('uid:', result);
                return result;
            });
        
    }
};