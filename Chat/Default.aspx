<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="Chat.Default" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<meta http-equiv="X-UA-Compatible" content="IE=edge" />

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Chat</title>
    <%--<script src="http://gravityscript.googlecode.com/svn/trunk/gravityscript.js"></script>--%>
    <style type="text/css">
        body{
            word-break: break-all;
            font-family:Meiryo UI;
            font-size:small;
        }
        textarea,select{font-family:Meiryo UI}
        a, a:visited, a:active {color: #444;}
         a:hover{color: #4169E1;}
        .button
        {
            cursor:pointer;
            border:1px solid #666;
            padding:3px;
            background-color:#eee;
            height:20px;
            display:inline-block;
        }
        .button:hover
        {
            border:1px solid #6881B2;
            background-color:#B4CDFF;
        }
        .button:active
        {
            border:1px solid #6881B2;
            background-color:#85A6E6;
        }
        .fileUpload
        {
            display:none
        }
         pre { 
            font-size:small;
            font-family:Meiryo UI;
 
            /* Mozilla */ 
            white-space: -moz-pre-wrap; 
            /* Opera 4-6 */ 
            white-space: -pre-wrap; 
            /* Opera 7 */ 
            white-space: -o-pre-wrap; 
            /* CSS3 */ 
            white-space: pre-wrap; 
            /* IE 5.5+ */ 
            word-wrap: break-word;
         }
         textarea
         {
             margin:0px;
             padding:2px
         }
         #divEmoji
         {
             display:none;
             position:absolute;
             width:500px;
             height:300px;
             overflow:auto;
             background-color:#fff;
             border:1px solid grey;
         }
         #divEmoji img
         {
             cursor:pointer;
         }
         #emojiToggler
         {
             background:url(Image/MissingBear/2{3A5XHQ8RFZO]}28]RTZ{A.jpg); background-size:23px 23px; border:0px; padding:0px; width:23px; height:23px; vertical-align:middle;
         }
         #emojiToggler:hover
         {
             background:url('Image%2fMissingBear%2f1BO%25ZGQ%5b%24%7d1%40T(%5dN5_7%7d)CI.GIF');background-size:23px 23px;
         }
    </style>
</head>
<body>
    <form id="form1" runat="server">

    <div id="divSingle">
        <%--<div id="fo">focusout fire</div> <div id="b">blur fire</div> --%>
        <%--<a href="Translator v1.0.jar">迷你6合1词典（ミニ 6-in-1 辞書）</a>--%>
        <a href="Drawing.aspx">>>你画我猜</a>
        <%--<a href="Videos.aspx" style="margin-left:30px">LoL All-Star 2014</a>--%>
        <%--<a href="JavaCode.aspx" style="margin-left:30px">Java個人演習</a>--%>
        <div style="height:5px"></div>
        <%--<input type="text" id="label1" value="sdfasfd" />--%>
        <%--<label style="font-size:small">取消windows任务栏的合并，便可以获得新消息提示功能：</label>
		<br/>--%>
        <label style="font-size:small">
            新消息提醒功能：请取消windows任务栏的合并
        </label>
        <br />
        <%--<label style="font-size:small">スクリーンショットをキャプチャしたい場合はWindowsのSnipping Toolをご利用ください。(要截图请使用Windows的Snipping Tool)</label>--%>
        <%--<label style="font-size:small">設定方法：任务栏-〉右键-〉タスクバーのボタンー＞结合しない</label>--%>
        <div style="height:5px"></div>
        <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td style="width:85%">
                    <%--<input type="text" id="txtInput" style="width:90%;font-family:Meiryo UI" onkeypress="if(event.keyCode==13) {$('#btnSend').click();return false;}" autocomplete="off" />--%>
                    <%--<textarea id="txtMain" rows="30" style="width:100%; overflow:auto;font-family:Meiryo UI"></textarea>--%>
                    <div id="divMain" style="height:500px; border:1px solid #aaa; margin:0px; overflow:auto;"></div>
                </td>
                <td style="padding-left:6px">
                    <textarea id="txtOnline" style="width:100%; height:496px; overflow:auto; border:1px solid #aaa;"></textarea>
                </td>
            </tr>
        </table>

        <div style="height:6px"></div>

        <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td valign="middle">
                    <%--発送先：--%>
                    <input id="cbPM" type="checkbox" value="check" onchange="cbPMOnChange(this)" style="vertical-align:middle;cursor:pointer;margin:0px" />
                    <label id="lblPM" for="cbPM" style="cursor:pointer">私信</label>
                    <asp:DropDownList runat="server" ID="ddlTo"></asp:DropDownList>

                    <span style="width:10px; display:inline-block;"></span>

                    <label id="emojiToggler" class="button"></label>
                    <%--<label id="emojiToggler"></label>--%>
                    <div id="divEmoji" runat="server" tabindex="-1">
                    </div>

                    <span style="width:10px; display:inline-block;"></span>

                    发送图片：
                    <label for="fileUpload" class="button" title="选择图片文件发送">从文件</label>
                    <input type="file" id="fileUpload" onchange="SendPic(this,event)" style="display:none" />
                    &nbsp;
                    <div style="display:inline-block" class="button" onclick="divPasteOnClick(this)"
                        contenteditable="true" onpaste="return divPasteOnPaste(this,event)" onblur="divPasteOnBlur(this)" title="将已拷贝的图片粘贴到这里发送">
                        <%--ここに貼り付けてください--%>
                        从剪贴板粘贴
                    </div>
                    &nbsp;&nbsp;
                    <%--使い方：画像または<a href="http://vcl.vaio.sony.co.jp/support/special/beginner/dialogue/068.html" target="_blank">画面</a>をコピーして、左のボックスに貼り付けてください--%>
                    <%--&nbsp;&nbsp;氏名：<input type="text" id="txtName" style="width:50px" />--%>
                </td>
            </tr>
        </table>

        <div style="height:6px"></div>

        <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td style="width:85%;padding-right:6px">

                    <textarea id="txtInput" rows="6" style="width:100%; " onkeydown="return txtInputKeyCtrl(event, this);"></textarea>
                </td>
                <td valign="bottom">
                    <%--<div style="height:10px"></div>
                    <div style="height:10px"></div>   --%>                 

                    <%--氏名：<input type="text" id="txtName" style="width:50px" />
                    <br />
                    <br />--%>

                    <label for="btnSend" class="button">发送</label>
                    <input type="button" id="btnSend" value="发送" onclick="Send()" style="display:none" />
                </td>
            </tr>
            <tr>
                <td>
                    Enter: 发送
                    <span style="width:10px; display:inline-block"></span>
                    Ctrl+Enter: 换行
                    <span style="width:10px; display:inline-block"></span>
                    PrtSc: 屏幕拷贝
                    <span style="width:10px; display:inline-block"></span>
                    Alt+PrtSc: 当前窗口拷贝
                    <span style="width:10px; display:inline-block"></span>
                    Alt+Tab: 老板键
                </td>
                <td></td>
            </tr>
            <%--<tr>
                <td>
                    画像を選択：<input type="file" id="fileUpload" />
                </td>
                <td></td>
            </tr>--%>
        </table>
    </div>


<script type="text/javascript" src="Script/jquery-1.11.0.min.js"></script>
<script type="text/javascript">
    var msgAutoID = 0;

    $('#divEmoji').children('img').each(function () {
        this.onclick = function () {
            PostURLImage(this.src);
            $('#divEmoji').hide();
        };
    });

    $('#divEmoji')[0].onblur = function () {
        $('#divEmoji').hide();

        window.setTimeout(function () {
            $('#emojiToggler')[0].onclick = ShowEmoji;
        }, 100);
    };

    $('#emojiToggler')[0].onclick = ShowEmoji;

    function ShowEmoji() {
        var emoji = $('#divEmoji');
        var btn = $('#emojiToggler');
        emoji.css('left', (btn[0].offsetLeft + 10) + 'px');
        emoji.css('top', (btn.offset().top - 305) + 'px');
        emoji.show();
        emoji.focus();

        $('#emojiToggler')[0].onclick = EmptyFunction;
    }

    function EmptyFunction() { }

    //$('#tdLeft').width(document.body.style.width * 0.85);
    function resize() {
        var w = $(window).width() - 50;
        $('#divMain').parent().width(w * 0.85);
        $('#divMain').width(w * 0.85);

        $('#txtInput').width(w * 0.85 - 4);
        $('#txtInput').parent().width(w * 0.85 - 4);

        var h = $(window).height() - 130;
        $('#divMain').height(h * 0.8);
        $('#divMain').parent().height(h * 0.8);
        $('#txtOnline').height(h * 0.8 - 4);
        $('#txtOnline').parent().height(h * 0.8 - 4);

        $('#txtInput').height(h * 0.2);
        $('#txtInput').parent().height(h * 0.2);
    }
    $(resize());
    window.onresize = resize;

    cbPMOnChange($('#cbPM')[0].checked);
    function cbPMOnChange(obj) {
        if (obj.checked) {
            $('#<%=ddlTo.ClientID %>').prop('disabled', false);
            //$('#txtInput').css('color', '#2A7D4F');
            //$('#txtInput').css('border', 'solid 1px #2A7D4F');
        }
        else {
            $('#<%=ddlTo.ClientID %>').prop('disabled', true);
            //$('#txtInput').css('color', '#000');
            //$('#txtInput').removeCss('border');
        }
    }

    function divPasteOnClick(obj) {
        $(obj).html('请按Ctrl+V');
    }

    function divPasteOnBlur(obj) {
        $(obj).html('从剪贴板粘贴');
    }

    //var savedcontent;
    var isReturn = false;
    function divPasteOnPaste(elem, e) {
        if (e && e.clipboardData && e.clipboardData.getData) {//Webkit
            debugger;
            if (e.clipboardData.items) {//chrome

                // find pasted image among pasted items
                for (var i = 0; i < e.clipboardData.items.length; i++) {
                    if (e.clipboardData.items[i].type.indexOf("image") == 0) {
                        var blob = e.clipboardData.items[i].getAsFile();

                        // load image if there is a pasted image
                        if (blob) {
                            var reader = new FileReader();
                            reader.onload = function (event) {
                                PostURIImage(reader.result);
                                elem.innerHTML = '图片已发送';
                            };
                            reader.readAsDataURL(blob);
                        }
                        return false;
                    }

                    if (e.clipboardData.items[i].type == "text/html") {
                        e.clipboardData.items[i].getAsString(function (str) {
                            var idx = str.indexOf('src="');
                            if (idx >= 0) {
                                str = str.substr(idx + 'src="'.length);
                                idx = str.indexOf('"');
                                str = str.substr(0, idx == -1 ? null : idx);

                                //URL
                                PostURLImage(str);
                                elem.innerHTML = '图片已发送';
                            }
                            isReturn = true;
                        });

                        if (isReturn) return false;
                    }
                }

                alert('不是图像，无法发送。');
                return false;
            }
            else {//firefox
                elem.innerHTML = "";
                waitforpastedata(elem);
            }
        }
        else {// IE, Everything else, not webkit
            elem.innerHTML = "";
            waitforpastedata(elem);
            //return true;
        }
    }

    //function waitforpastedata(elem, savedcontent) {
    function waitforpastedata(elem) {
        //$('#txtInput').append(' waitforpastedata called\n');
        if (elem.childNodes && elem.childNodes.length > 0) {
            //$('#txtInput').append('element found\n');
            //processpaste(elem, savedcontent);
            processpaste(elem);
        }
        else {
            //$('#txtInput').append('element not found. check after 20 ms.\n');
            that = {
                e: elem//,
                //s: savedcontent
            }
            that.callself = function () {
                //waitforpastedata(that.e, that.s)
                waitforpastedata(that.e)
            }
            setTimeout(that.callself, 20);
        }
    }

    //function processpaste(elem, savedcontent) {
    function processpaste(elem) {
        pasteddata = elem.innerHTML;

        //data uri and html url of img are both acceptable
        var idx = pasteddata.indexOf('src="');
        if (idx >= 0) {
            pasteddata = pasteddata.substr(idx + 'src="'.length);
            idx = pasteddata.indexOf('"');
            pasteddata = pasteddata.substr(0, idx == -1 ? null : idx);
        }
        else {
            alert('不是图像，无法发送。');
            return;
        }

        if (pasteddata.substr('data:image/') == 0) {//data URI
            PostURIImage(src);
            elem.innerHTML = '图片已发送';
        }
        else {//URL
            PostURLImage(pasteddata);
            elem.innerHTML = '图片已发送';
        }
    }

    function PostURIImage(src) {
        $.post('Ajax/Chat.ashx?LastID=' + lastID + '&isPic=1' + '&to=' + escape(GetReceiver()), { img: src }, function (data) {
            AppendMsg(data);
        }, "json");
    }

    function PostURLImage(src) {
        var img = new Image();
        img.onload = function () {
            //debugger;
            if (img.width > 0) {
                $.post('Ajax/Chat.ashx?LastID=' + lastID + '&isPic=1' + '&to=' + escape(GetReceiver()), { img: img.src }, function (data) {
                    AppendMsg(data);
                }, "json");
                //alert(elem);
            };
        }
        img.src = src;
    }

    var isFocus = true;
    var newCount = 0;
    function Flash() {
        if (!isFocus && newCount != 0)
            document.title = document.title == '[　　] Chat' ? '[新着] Chat' : '[　　] Chat';
        else
            document.title = 'Chat';
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

    //Refresher
    $(Refresh());
    function Refresh() {
        $.getJSON('Ajax/Chat.ashx', 'LastID=' + lastID, function (data) {
            if (!isFocus && data.length > 0)
                newCount += data.length;

            AppendMsg(data);
        });

        window.setTimeout(Refresh, 2000);
    }

    //Send Message
    function Send() {
        var str = $('#txtInput').val();

        if (str == '') return; //不允许输入空字符串

        $('#txtInput').val('');

        //        $.getJSON('Ajax/Chat.ashx', 'Content=' + escape(str) + '&LastID=' + lastID, function (data) {
        //            AppendMsg(data);
        //        });

        $.post('Ajax/Chat.ashx?LastID=' + lastID + '&to=' + escape(GetReceiver()), { str: str }, function (data) {
            AppendMsg(data);
        }, "json");

        $('#txtInput').focus();
    }

    function GetReceiver() {
        return $('#cbPM')[0].checked ? $('#<%=ddlTo.ClientID %>').val() : '';
    }

//    var imageDataUrl = '';
    function SendPic(obj,e) {
        var file = e.srcElement ? e.srcElement.files[0] : obj.files[0]; //firefox dont have event.srcElement
        var reader = new FileReader();
        reader.onloadend = function () {
            //            imageDataUrl = reader.result;
            //            alert(imageDataUrl);
            if (reader.result.indexOf('data:image/') != 0) {
                alert('不是图像，无法发送。');
                return;
            }

            $.post('Ajax/Chat.ashx?LastID=' + lastID + '&isPic=1' + '&to=' + escape(GetReceiver()), { img: reader.result }, function (data) {
                AppendMsg(data);
            }, "json");
        }
        reader.readAsDataURL(file);

        $('#fileUpload').val('');
    }

    function AppendMsg(data) {
        $.each(data, function (key, val) {
            //            //alert('receive:' + val.Content);
            //            var txtMain = $('#txtMain');
            //            //txtMain.append((txtMain.val() == '' ? '' : '\r\n') + '->' + val.Time + ' ' + val.User + ': ' + val.Content);
            //            txtMain.val(txtMain.val() + (txtMain.val() == '' ? '' : '\r\n') + '->' + val.Time + ' ' + val.User + ': ' + val.Content);
            //            lastID = val.ID;

            //            txtMain[0].scrollTop = txtMain[0].scrollHeight;


            //            jQuery('<span/>', {
            //                style: "display:inline-block;",
            //                text: val.Time + ' ' + val.User + ': '
            //            }).appendTo('#divMain');

            //            jQuery('<pre/>', {
            //                style: "display:inline-block;",
            //                text: val.Content
            //            }).appendTo('#divMain');

            //            jQuery('<div/>', {
            //                style: "clear:both"
            //            }).appendTo('#divMain');

            //alert('received: length:' + val.Content.length + '    ispic:' + val.IsPic);

            var strColor = '';
            if (val.To == '<%=User.FullName %>')
                strColor = 'color:RoyalBlue;';
            if (val.From == '<%=User.FullName %>') {
                if (val.To == '')
                    strColor = ''; //'color:#555;';
                else
                    strColor = 'color:#2A7D4F;';
            }

            var strNames;
            if (val.From != '<%=User.FullName %>') {
                strNames = ' ' + '<font title="发送给' + val.User + '" style="cursor:pointer;font-weight:bold;" onclick="SetReceiver(this.innerHTML)">' + val.User + '</font>';
            }
            else if (val.To != '') {
                strNames = ' to ' + '<font title="发送给' + val.To + '" style="cursor:pointer;font-weight:bold;" onclick="SetReceiver(this.innerHTML)">' + val.To + '</font>' + ' ';
            }
            else {
                strNames = ' ' + val.User;
            }

            $('<div/>', {
                style: "padding:5px;" + strColor,
                id: 'div' + msgAutoID
            }).appendTo('#divMain');

            $('<font/>', {
                style: "display:block; float:left; margin-right:5px",
                html: val.Time + strNames + ':'
            }).appendTo('#div' + msgAutoID);

            if (val.IsPic) { //图片
                $('<img/>', {
                    style: 'max-width: 800px; ',
                    id: 'img' + msgAutoID,
                    src: val.Content//,
                    //onload: function () { var H = this.height; var W = this.width; }
                }).appendTo('#div' + msgAutoID);

                var img = $('#img' + msgAutoID);
                if (img[0].naturalWidth > img.width()) {
                    //if($.browser.
                    //img.css('cursor', 'zoom-in,-webkit-zoom-in,-moz-zoom-in');
                    img.click(function () {
                        var newWin = window.open('');
                        newWin.document.open();
                        newWin.document.write('<html><body><img src="' + img[0].src + '"/></body></html>');
                        newWin.document.close();
                    });
                    img.css('cursor', 'pointer');
                    img.attr('title', '放大');
                    //img.attr('href', '#');
                }
            }
            else { //文本
                $('<pre/>', {
                    style: "display:block; margin:0px",
                    text: val.Content
                }).appendTo('#div' + msgAutoID);
            }
            msgAutoID++;

            lastID = val.ID;

            $('#divMain')[0].scrollTop = $('#divMain')[0].scrollHeight;
        });
    }

    //OnlineUser
    $(OnlineUser());
    function OnlineUser() {
        //$('#txtMain').append('onlineuser is called');
        //$('#txtOnline').val('');
        //$('#txtOnline').append('1');

        $.getJSON('Ajax/OnlineUser.ashx', '', function (data) {
            //alert(data.length);
            $('#txtOnline').val('');

            $.each(data, function (key, val) {
                var txtOnline = $('#txtOnline');
                //txtOnline.append((txtOnline.val() == '' ? '' : '\r\n') + ' ' + val.User);
                txtOnline.val(txtOnline.val() + (txtOnline.val() == '' ? '' : '\r\n') + ' ' + val.User);
            });
        });

        window.setTimeout(OnlineUser, 2000);
    }

    function txtInputKeyCtrl(event, obj) {
        if (event.keyCode == 13 && !event.ctrlKey) {
            window.setTimeout(function () { $('#btnSend').click() }, 0);
            return false;
        }
        else if (event.keyCode == 13) {
            var val = obj.value;
            if (typeof obj.selectionStart == "number" && typeof obj.selectionEnd == "number") {
                var start = obj.selectionStart;
                obj.value = val.slice(0, start) + "\n" + val.slice(obj.selectionEnd);
                obj.selectionStart = obj.selectionEnd = start + 1;
            } else if (document.selection && document.selection.createRange) {
                obj.focus();
                var range = document.selection.createRange();
                range.text = "\r\n";
                range.collapse(false);
                range.select();
            }
        }

        return true;
    }

    function SetReceiver(name) {
        var select = $('#<%=ddlTo.ClientID %>');

        var checkbox = $('#cbPM');
        checkbox[0].checked = true;
        cbPMOnChange(checkbox[0]);

        select.val(name);

        if (select[0].selectedIndex == -1) {
            select.append($("<option></option>").attr("value", name).text(name));
            select.val(name);
        }
    }

//    $("#fileUpload").change(function (e) {

//        for (var i = 0; i < e.originalEvent.srcElement.files.length; i++) {

//            var file = e.originalEvent.srcElement.files[i];

//            var img = document.createElement("img");
//            img.style.height = "200px";
//            var reader = new FileReader();
//            reader.onloadend = function () {
//                img.src = reader.result;
//            }
//            reader.readAsDataURL(file);
//            $("#fileUpload").after(img);
//            $("#fileUpload").after('<br/>プリビュー：');
//            $("#fileUpload").after('<input type="button"');
//        }
//    });


    //Signal
    //    var isBlur = 0;
    //    $(window).focusin(function () {
    //        isBlur = 0;
    //    }).blur(function () {
    //        isBlur = 1;
    //    });
</script>

    </form>
</body>
</html>
