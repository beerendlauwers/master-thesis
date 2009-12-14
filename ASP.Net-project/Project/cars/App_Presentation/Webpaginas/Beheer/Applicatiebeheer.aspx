<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Applicatiebeheer.aspx.vb" Inherits="App_Presentation_Webpaginas_Default2" MasterPageFile="~/App_Presentation/MasterPage.master" Title="Applicatiebeheer" %>

<%@ Register assembly="GMaps" namespace="Subgurim.Controles" tagprefix="cc1" %>

<asp:Content ID="Main" ContentPlaceHolderID="plcMain" runat="server">

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<body>

<h1>Applicatiebeheer</h1>
<br />
    <table>
    <tr>
        <th>Reservatiebeheer</th>
        <th></th>      
    </tr>
    <tr>
        <td><a href="AutoUitchecken.aspx">Auto Uitchecken</a></td>
        <td>Hier kan u een auto ontlenen</td>      
    </tr>
    <tr>
        <td><a href="AutoInchecken.aspx">Auto Inchecken</a></td>
        <td>Hier kan u een uitgeleende auto opnieuw inchecken</td>      
    </tr>
    
    <tr>
        <td><br /> </td>
        <td> </td>
    </tr>
    
    
    
    <tr>
        <th align="left">Auto's beheren</th>
        <th></th>      
    </tr>
    <tr>
        <td><a href="AutoBeheer.aspx">Auto's wijzigen</a></td>
        <td>Hier kunt u de reservatiegegevens en opties van een auto aanpassen</td>      
    </tr>
      <tr>
        <td><a href="NieuweAutoAanmaken.aspx">Nieuwe auto</a></td>
        <td>Hier kunt u nieuwe auto's aan het wagenpark toevoegen</td>      
    </tr>
    
    <tr>
    <td> <br /></td>
    <td> </td>
    </tr>
    
    
    <tr>
        <th align="left">Filiaalbeheer</th>
        <th></th>      
    </tr>
      <tr>
        <td><a href="FiliaalBeheer.aspx">Filiaal bewerken</a></td>
        <td>Hier kan u de gegevens van een filiaal bewerken</td>      
    </tr>
      <tr>
        <td><a href="ParkingBeheer.aspx">Parkingbeheer</a></td>
        <td>Hier kan u de ingedeeldheid van een parkeerplaats aanpassen</td>      
    </tr>
    
       
    
    </table>
    
    <br />
    <br />
    <br />
    <br />
  
</body>
</html>

</asp:Content>
