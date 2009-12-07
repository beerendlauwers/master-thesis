<%@ Page Language="VB" AutoEventWireup="false" CodeFile="GoogleApi.aspx.vb" Inherits="App_Presentation_Webpaginas_Default2" %>

<%@ Register assembly="GMaps" namespace="Subgurim.Controles" tagprefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Filiaal locatie</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
    <cc1:GMap ID="GMap1" runat="server" enableServerEvents="true"/>
    </div>
    </form>
</body>
</html>
