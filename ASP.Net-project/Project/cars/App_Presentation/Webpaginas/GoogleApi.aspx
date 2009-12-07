<%@ Page Language="VB" AutoEventWireup="false" CodeFile="GoogleApi.aspx.vb" Inherits="App_Presentation_Webpaginas_Default2" MasterPageFile="~/App_Presentation/MasterPage.master" %>

<%@ Register assembly="GMaps" namespace="Subgurim.Controles" tagprefix="cc1" %>

<asp:Content ID="Main" ContentPlaceHolderID="plcMain" runat="server">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Locatie Filiaal - Google Map</title>
</head>
<body>
  
    <div>
<%--        Kies filiaal<asp:DropDownList ID="ddlGmap" runat="server" 
            DataSourceID="SqlDataSource1" DataTextField="filiaalLocatie" 
            DataValueField="filiaalLocatie" AutoPostBack="true">
        </asp:DropDownList>--%>
        <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
            ConnectionString="<%$ ConnectionStrings:frankRemoteDB %>" 
            SelectCommand="SELECT [filiaalLocatie] FROM [tblFiliaal]">
        </asp:SqlDataSource>
    </div>
    <cc1:GMap ID="GMap1" runat="server" enableServerEvents="true"/>
    
</body>
</html>

</asp:Content>
