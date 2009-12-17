<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Contact.aspx.vb" Inherits="App_Presentation_Webpaginas_Default2" MasterPageFile="~/App_Presentation/MasterPage.master" title="Contact"%>

<%@ Register assembly="GMaps" namespace="Subgurim.Controles" tagprefix="cc1" %>

<asp:Content ID="Main" ContentPlaceHolderID="plcMain" runat="server">

    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Contactpagina</title>
</head>
<body>
  
    <asp:UpdatePanel ID="updGmap" runat="server">
    <ContentTemplate>
    <h1>Contact</h1>
    <div style="font-size:larger;">


        
      <%--  <div id="directions">
            Van: <asp:TextBox ID="txtVan" runat="server"></asp:TextBox>
            Naar: <asp:TextBox ID="txtNaar" runat="server"></asp:TextBox>
            <asp:Button ID="cmdGo" runat="server" Text="Go" />
        
               
        </div>--%>
        
       


 


 
    </div>
    
  
        
        <asp:Label ID="lblVan" runat="server" Text="Van: "></asp:Label><asp:TextBox ID="txtVan" runat="server" Width="225px"></asp:TextBox>
        &nbsp;&nbsp;&nbsp;<asp:Label ID="lblNaar" runat="server" Text="Naar: "></asp:Label><asp:TextBox ID="txtNaar" runat="server" Width="225px"></asp:TextBox>
        &nbsp;&nbsp;&nbsp;<input type="button" id="cmdGo" value="Bereken route" />
        <asp:ImageButton ID="cmdAfdrukken" runat="server" ImageUrl="../Images/printer.png" />
        <br /><br />
        <cc1:GMap ID="GMap1" runat="server" enableServerEvents="true"/>
        <div id="div1"></div>   
        

        <a href="Contact.aspx.vb">Contact.aspx.vb</a>
        
        
    </ContentTemplate>
    </asp:UpdatePanel>
</body>
</html>

</asp:Content>
