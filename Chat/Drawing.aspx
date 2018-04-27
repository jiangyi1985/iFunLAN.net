<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Drawing.aspx.cs" Inherits="Chat.Drawing" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<meta http-equiv="X-UA-Compatible" content="IE=edge"/>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>你画我猜</title>
    <style type="text/css">
    <%--div{border:1px solid #000}--%>
    #colorPalet div
    {
        border:1px solid #aaa;
        width:20px;
        height:20px;
        float:left;
        margin:2px;
        cursor:pointer;
    }
    </style>
    <script type="text/javascript" src="Script/jquery-1.11.0.min.js"></script>
    <script type="text/javascript" src="Script/jquery-ui-1.10.4.custom/js/jquery-ui-1.10.4.custom.min.js"></script>
    <link rel="stylesheet" href="Script/jquery-ui-1.10.4.custom/css/ui-lightness/jquery-ui-1.10.4.custom.css" type="text/css" media="all"/>
    </head>
<body style="font-size:small; font-family:Meiryo UI">
    <form id="form1" runat="server">

    <div>
        
        <table>
            <tr>
                <td id="txtTip" style="font-size:larger; font-weight:bold">
                    游戏未开始。等待玩家进入。。。。。。 
                </td>
                <td align="right" valign="top"><a href="Default.aspx">返回Chat</a></td>
            </tr>
            <tr>
                <td>
                    <table id="tblDraw">
                        <tr>
                            <td style="border:1px solid #aaa">
                                <canvas id="myCanvas" width="640" height="480" style="cursor:crosshair">
                                    HTML5　Canvasに対応したブラウザーを使用してください。
                                </canvas>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <table>
                                    <tr>
                                        <td>粗细：&nbsp;&nbsp;&nbsp;&nbsp;</td>
                                        <td><div id="slider" style="width:200px"></div></td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <div id="colorPalet">
                                    <div id="black"></div>
                                    <div id="blue"></div>
                                    <div id="red"></div>
                                    <div id="magenta"></div>
                                    <div id="green"></div>
                                    <div id="cyan"></div>
                                    <div id="yellow"></div>
                                    <div id="white"></div>
                                </div>
                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                <input type="button" onclick="clearData()" value="清空画板" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <%--<input type="button" onclick="saveData()" value="save" />--%>
                            </td>
                        </tr>
                    </table>

                    <table id="tblGuess">
                        <tr>
                            <td>
                                <div  style="width:640px;height:480">
                                    <img alt="" id="img1" src="Ajax/Drawing.ashx" />
                                </div>
                                <%--<input type="button" onclick="loadimg()" value="load img" />--%>
                            </td>
                        </tr>
                        <tr>
                            <td></td>
                        </tr>
                    </table>
                </td>
                <td valign="top" style="padding-top:3px">
                    <textarea id="txtOnline" style="width:200px; overflow:auto;font-family:Meiryo UI; height:478px"></textarea>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <textarea id="txtMain" rows="8" style="width:100%; overflow:auto;font-family:Meiryo UI"></textarea>
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="text" id="txtInput" style="width:90%;font-family:Meiryo UI" onkeypress="if(event.keyCode==13) {$('#btnSend').click();return false;}" autocomplete="off" />
                    <input type="button" id="btnSend" value="发送" onclick="Send()" />
                </td>
            </tr>
        </table>
    </div>

    <script type="text/javascript">
        var drawFlag = false;
        var oldX = 0;
        var oldY = 0;
        var brushSize = 1;
        var colorList = {
            "black": "rgba(0,0,0,1)",
            "blue": "rgba(0,0,255,1)",
            "red": "rgba(255,0,0,1)",
            "magenta": "rgba(255,0,255,1)",
            "green": "rgba(0,255,0,1)",
            "cyan": "rgba(0,255,255,1)",
            "yellow": "rgba(255,255,0,1)",
            "white": "rgba(255,255,255,1)"
        }
        var penColor = "rgba(255,0,0,1)";

        window.addEventListener("load", function () {
            var can = document.getElementById("myCanvas");
            can.addEventListener("mousemove", draw, true);
            can.addEventListener("mousedown", function (e) {
                drawFlag = true;
                //                oldX = e.clientX;
                //                oldY = e.clientY;
                oldX = e.offsetX;
                oldY = e.offsetY;
            }, true);
            can.addEventListener("mouseup", function () {
                drawFlag = false;
            }, true);
            // カラーパレット初期化
            $("#colorPalet div").click(function (e) {
                penColor = colorList[this.id];
            });
            $("#colorPalet div").each(function () {
                $(this).css("backgroundColor", this.id);
            });
            // ブラシサイズの設定を行うスライダー
            $("#slider").slider({
                min: 0,
                max: 100, // ブラシの最大サイズ
                value: 1,  // 最初のブラシサイズ
                slide: function (evt, ui) {
                    brushSize = ui.value; // ブラシサイズを設定
                }
            });
        }, true);

        // 描画処理
        function draw(e) {
            if (!drawFlag) return;

            var can = document.getElementById("myCanvas");
            //debugger;
            var x = e.offsetX;
            var y = e.offsetY;

            var context = can.getContext("2d");
            context.strokeStyle = penColor;
            context.lineWidth = brushSize;
            context.lineJoin = "round";  // 連結部分を丸にする
            context.lineCap = "round";
            context.beginPath();
            context.moveTo(oldX, oldY);
            context.lineTo(x, y);
            context.stroke();
            context.closePath();
            oldX = x;
            oldY = y;
        }

        //-----------------------------------------------------------------------------------
        var isFocus = true;
        var newCount = 0;
        function Flash() {
            if (!isFocus && newCount != 0)
                document.title = document.title == '[　　] 你画我猜' ? '[新着] 你画我猜' : '[　　] 你画我猜';
            else
                document.title = '你画我猜';
        }
        $(window.setInterval(Flash, 500));

        window.onfocus = function () {
            isFocus = true;
            newCount = 0;
            //document.getElementById('label1').value = 'focused';
        };

        window.onblur = function () {
            isFocus = false;
            //document.getElementById('label1').value = 'blured';
        };

        //Initialize
        var lastID = 0;
        $.ajaxSetup({ cache: false, async: false });
        $(function () { $('#txtInput').focus(); });

//        //Refresher
//        $(Refresh());
//        function Refresh() {
//            $.getJSON('Ajax/Chat.ashx', 'LastID=' + lastID, function (data) {
//                if (!isFocus && data.length > 0)
//                    newCount += data.length;

//                $.each(data, function (key, val) {
//                    //alert('receive:' + val.ID);
//                    var txtMain = $('#txtMain');
//                    txtMain.append((txtMain.val() == '' ? '' : '\r\n') + ' ' + val.Time + ' ' + val.User + ': ' + val.Content);
//                    lastID = val.ID;

//                    txtMain[0].scrollTop = txtMain[0].scrollHeight;
//                });
//            });

//            window.setTimeout(Refresh, 2000);
//        }

        //Send Message
        function Send() {
            var str = $('#txtInput').val();

            if (str == '') return; //不允许输入空字符串

            $('#txtInput').val('');

            PostTickJSON(str);

            $('#txtInput').focus();
        }

        //-----------------------------------------------------------------------------------------------------

        //var IsLoading = true;
        var IsDrawing=false;

        // 保存処理
        $(saveData());
        function saveData() {
            if (IsDrawing) {
                var can = document.getElementById("myCanvas");

                var data = can.toDataURL("image/png");
                $.post("Ajax/Drawing.ashx", { img: data }, null);

//                //-------------------logging---------------------
//                var txtMain = $('#txtMain');
//                txtMain.append((txtMain.val() == '' ? '' : '\r\n') + (new Date()) + ' ' + ' image posted. length: ' + data.length);
//                txtMain[0].scrollTop = txtMain[0].scrollHeight;
            }

            window.setTimeout(saveData, 1000);
        }

        $(loadimg());
        function loadimg() {
            if (!IsDrawing) {
                $.ajax({
                    type: "get",
                    url: "Ajax/Drawing.ashx",
                    success: function (data) {
                        document.getElementById('img1').src = data;

//                        //---------------------logging-------------------------
//                        var txtMain = $('#txtMain');
//                        txtMain.append((txtMain.val() == '' ? '' : '\r\n') + (new Date()) + ' ' + ' image loaded. length: ' + data.length);
//                        txtMain[0].scrollTop = txtMain[0].scrollHeight;
                    }
                });
            }

            window.setTimeout(loadimg, 1000);
        }

        function clearData() {
            var can = document.getElementById("myCanvas");
            var context = can.getContext("2d");
            context.clearRect(0, 0, 640, 480);
        }

        //OnlineUser
        $(Tick());
        //$(window.setTimeout(OnlineUser, 0));
        function Tick() {
            PostTickJSON();

            window.setTimeout(Tick, 1000);
        }

        function PostTickJSON(strChat) {
            $.getJSON('Ajax/DrawingControl.ashx', 'LastID=' + lastID + (strChat == null ? '' : '&Content=' + escape(strChat)), function (data) {
                if (!isFocus && data.Chat.length > 0)
                    newCount += data.Chat.length;

                $.each(data.Chat, function (key, val) {
                    //alert('receive:' + val.ID);
                    var txtMain = $('#txtMain');
                    txtMain.append((txtMain.val() == '' ? '' : '\r\n') + ' ' + val.Time + ' ' + val.User + ': ' + val.Content);
                    lastID = val.ID;

                    txtMain[0].scrollTop = txtMain[0].scrollHeight;
                });

                //------------------------------------------------------------------------------------
                //alert(data.isGuess + ' ' + data.isDraw + ' ' + data.Users.length);
                $('#txtTip').html(data.Tip);

                if (data.Step == 1 && data.isDraw) {
                    IsDrawing = true;
                    if (!$('#tblDraw').is(':visible')) clearData();//新游戏开始 清空画板
                    $('#tblDraw').show();
                    $('#tblGuess').hide();
                    //$('#txtTip').html($('#txtTip').html() + ' 你要画的是：' + data.Keyword + '');
                }
                else {
                    IsDrawing = false;
                    $('#tblDraw').hide();
                    $('#tblGuess').show();
                }

                //user list
                $('#txtOnline').val('');
                $.each(data.Users, function (key, val) {
                    //debugger;
                    var txtOnline = $('#txtOnline');
                    txtOnline.val(txtOnline.val() + (txtOnline.val() == '' ? '' : '\r\n') + ' ' + val.User + val.Tip);
                });
            });
        }
    </script>
    </form>
</body>
</html>
