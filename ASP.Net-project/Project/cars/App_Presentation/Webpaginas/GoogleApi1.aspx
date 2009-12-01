<%@ Page Language="VB" AutoEventWireup="false" CodeFile="GoogleApi1.aspx.vb" Inherits="App_Presentation_Webpaginas_Default2" %>

<%@ Register assembly="GMaps" namespace="Subgurim.Controles" tagprefix="cc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
    
        Kies filiaal<asp:DropDownList ID="ddlGmap" runat="server" 
            DataSourceID="SqlDataSource1" DataTextField="filiaalLocatie" 
            DataValueField="filiaalLocatie" AutoPostBack="true">
        </asp:DropDownList>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="<%$ ConnectionStrings:frankRemoteDB %>" 
            SelectCommand="SELECT [filiaalLocatie] FROM [tblFiliaal]">
        </asp:SqlDataSource>
    </div>
    <cc1:GMap ID="GMap1" runat="server" enableServerEvents="true"/>
    </form>
</body>
</html>
