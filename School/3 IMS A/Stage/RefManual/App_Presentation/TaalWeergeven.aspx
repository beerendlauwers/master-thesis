<%@ Page Language="VB" AutoEventWireup="false" CodeFile="TaalWeergeven.aspx.vb" Inherits="App_Presentation_TaalWeergeven" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">
<link href="CSS/xml.css" type="text/css" rel="Stylesheet" />
<link href="CSS/appligen.css" rel="stylesheet" type="text/css" />
<link href="CSS/prototip.css" rel="stylesheet" type="text/css" />
<script src="JS/prototype.js" language="javascript" type="text/javascript"></script>
<script src="JS/scriptaculous.js" language="javascript" type="text/javascript"></script>
<script src="js/prototip.js" language="javascript" type='text/javascript' ></script>
<script src="JS/custom.js" language="javascript" type="text/javascript"></script>
    <title>Overzicht Taallokalisatie</title>
</head>
<body>
    <form id="frmWeergave" runat="server">
    <div>
        <asp:ScriptManager ID="scmManager" runat="server"></asp:ScriptManager>
        <asp:UpdatePanel ID="updWeergave" runat="server">
        <ContentTemplate>
            Begin gelokaliseerde teksten
            <hr />
            <span id="lblWeergave" runat="server"></span><br />
            <hr />
            Einde gelokaliseerde teksten
        </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    </form>
</body>
</html>
