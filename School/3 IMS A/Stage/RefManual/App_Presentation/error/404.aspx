<%@ Page Language="VB" AutoEventWireup="false" CodeFile="404.aspx.vb" Inherits="_404" title="Untitled Page" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor"
    TagPrefix="cc1" %>
    

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<title>Untitled Page</title>
<meta content="IE=EmulateIE7" http-equiv="X-UA-Compatible"/>
<!--[if IE]>
<link href="../CSS/ie.css" type="text/css" rel="Stylesheet" />
<![endif]-->
<link href="../CSS/xml.css" type="text/css" rel="Stylesheet" />
<link href="../CSS/appligen.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="../JS/shadowbox/shadowbox.css" />
<link href="../CSS/prototip.css" rel="stylesheet" type="text/css" />
<link href="../JS/ckeditor/customcss.css" rel="Stylesheet" type="text/css" />

<script src="../JS/prototype.js" language="javascript" type="text/javascript"></script>
<script src="../js/prototip.js" language="javascript" type='text/javascript' ></script>
<script src="../JS/scriptaculous.js" language="javascript" type="text/javascript"></script>
<script src="../JS/custom.js" language="javascript" type="text/javascript"></script>
<script type="text/javascript" src="../JS/shadowbox/shadowbox.js"></script>
<script type="text/javascript">
Shadowbox.init({ modal: true });
</script>

</head>

<body id="MasterBody" runat="server">
    <form id="form1" runat="server">
     <asp:scriptmanager ID="Scriptmanager2" runat="server" EnablePartialRendering="true"></asp:scriptmanager>
          
    <div id="header" style="display:block">
    <img src="../CSS/images/rodebalk.gif" />
    </div>
    <div id="logo">
    <a href="../Default.aspx">
    <img src="../CSS/images/APPLIGEN-LOGO-BASE-RGB.gif" border="0" />
    </a>
    </div>
    <div>
    <div id="main">
    <div id="blok">
        <table>
        <tr>
        <td id="td-input">
        <div id="input">
            <asp:Label runat="server" ID="lbl404uitleg"></asp:Label>
        </div>
        </td>
        </tr>
        </table>
    </div>
    </div>
    </div>
    <div id="footer">
        <asp:TextBox ID="txtJavascriptOnEndRequest" runat="server" visible="false"></asp:TextBox>
    © 2010 Appligen
    </div>
     </form>
</body>
</html>
