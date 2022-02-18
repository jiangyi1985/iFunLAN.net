"use strict";

var connection = new signalR.HubConnectionBuilder().withUrl("/gameHub")
    .withHubProtocol(new signalR.protocols.msgpack.MessagePackHubProtocol()) //use binary instead of json, 1/2~1/3 smaller data transfer
    .build();

connection.on("UserMove", function (user, x, y) {
    console.log('from gameHub: userMove', user, x, y);

    me.moveTo(x, y);
});

connection.start().then(function () {//connected

    var name = prompt('Enter your name:', '');
    //console.log('user:',name,uid);
    gameHub.getUuid(name).then(result => uid = result);

}).catch(function (err) {
    return console.error(err.toString());
});

var gameHub = {
    move: function (user, x, y) {
        console.log('to gameHub: Move', uid, x, y);
        connection.invoke("Move", user, x, y).catch(function (err) {
            return console.error(err.toString());
        });
    },
    getUuid: function (name) {
        console.log('to gameHub: GetUuid', name);
        //debugger;
        return connection.invoke("GetUuid", name)
            .catch(function (err) {
                return console.error(err.toString());
            }).then(result => {
                console.log('uid:', result);
                return result;
            });
        
    }
};