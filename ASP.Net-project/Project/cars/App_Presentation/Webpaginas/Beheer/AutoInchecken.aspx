<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false"
    CodeFile="AutoInchecken.aspx.vb" Inherits="App_Presentation_Webpaginas_Beheer_AutoInchecken"
    Title="Untitled Page" %>
    
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" runat="Server">
  
  <h1>Auto Inchecken</h1>
    <asp:UpdatePanel ID="updAutoInchecken" runat="server">
        <ContentTemplate>
        
<table>
 <tr>
<td>&nbsp;</td>
</tr>
 <tr>
<td colspan="2">Selecteer klant op:</td>
</tr>
<tr>
<td>Naam en voornaam</td>
<td>
<asp:TextBox ID="txtNaam" runat="server"></asp:TextBox> <asp:TextBox ID="txtVoornaam" runat="server"></asp:TextBox>
</td>
</tr>
<tr>
<td>Rijbewijsnummer</td>
<td><asp:TextBox ID="txtRijbewijs" runat="server"></asp:TextBox> </td>
</tr>
<tr>
<td>Identiteitskaartnummer</td>
<td><asp:TextBox ID="txtIdenteitskaart" runat="server"></asp:TextBox> </td>
</tr>
<tr>
    <td align="center">
        <asp:UpdatePanel ID="updToonReservaties" runat="server">
    <ContentTemplate>
    <asp:Button ID="btnToonReservaties" runat="server" Text="Toon Reservaties" />
    </td>
    <td>
        <asp:UpdateProgress ID="prgToonReservaties" AssociatedUpdatePanelID="updToonReservaties" runat="server">
        <ProgressTemplate>
        
            <div class="progress">
                <img src="../../Images/ajax-loader.gif" />
                Even wachten aub...
            </div>
        
        </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:Label runat="server" ID="lblError"></asp:Label>
        </ContentTemplate>
    </asp:UpdatePanel>
    </td>
</tr>
</table>
<br />


<h3>Reservatieoverzicht</h3>
<table>
<tr>
<td>
   Reservaties bezien voor filiaal <asp:DropDownList ID="ddlFiliaal" runat="server" AutoPostBack="true"></asp:DropDownList>
    <br /><br />
    <asp:Label ID="lblGeenReservaties" runat="server" Visible="false"></asp:Label>
</td>
<td>
<asp:UpdateProgress ID="UpdateProgress2" runat="server">
        <ProgressTemplate>
        
            <div class="progress">
                <img src="../../Images/ajax-loader.gif" />
                Even wachten aub...
            </div>
                    </ProgressTemplate>
    </asp:UpdateProgress>
</td>
</tr>
</table>
   
   <div runat="server" id="divReservatieOverzicht" visible="false">     
<table>
        <tr>
            <th>
                Kenteken
            </th>
            <th>
                Merk En Model
            </th>
            <th>
                Begindatum
            </th>
            <th>
                Einddatum
            </th>
            <th>
                &nbsp;
            </th>
            <th>
                &nbsp;
            </th>
        </tr>
            <asp:Repeater ID="repReservatieOverzicht" runat="server">
    <ItemTemplate>
            <tr>
            <td>
                <%#DataBinder.Eval(Container.DataItem, "Kenteken")%>
            </td>
            <td>
                <%#DataBinder.Eval(Container.DataItem, "MerkModel")%>
            </td>
            <td>
            <%#DataBinder.Eval(Container.DataItem, "BeginDatum")%>
            </td>
            <td>
            <%#DataBinder.Eval(Container.DataItem, "EindDatum")%>
            </td>
            <td>
                <asp:LinkButton ID="lnkAutoUitchecken" runat="server" CommandArgument='<%#DataBinder.Eval(Container.DataItem, "Data")%>'>Deze auto inchecken</asp:LinkButton>
            </td>
            <td style='display:<%#DataBinder.Eval(Container.DataItem, "Display")%>'>
                <img src="../../Images/pijllinks.png" />
            </td>
        </tr>
        
</ItemTemplate>
    </asp:Repeater>
            </table>
            
            </div>


    <asp:UpdatePanel ID="updInCheckFormulier" runat="server">
    <ContentTemplate>
    <div runat="server" id="divIncheckFormulier" visible="false">
<br /><br />
<table>
        <tr>
            <td>
            Datum:
            </td>
            <td>
                <asp:Label ID="lblDatum" runat="server" ></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                Boete:
            </td>
            <td>
                <asp:Label ID="lblBoete" runat="server" ></asp:Label>
           </td>
        </tr>
                <tr>
            <td>
                Geen boete geven:
            </td>
            <td>
                <asp:CheckBox ID="chkGeenBoeteGeven" runat="server" />
           </td>
        </tr>
                <tr>
            <td>
                 Deze klant is <br />problematisch geworden:  
            </td>
            <td>
                 <asp:CheckBox ID="chkProblematisch" runat="server" AutoPostBack="true" />  
            </td>
        </tr>
        <tr>
            <td colspan="2">
            <div runat="server" id="divCommentaarVak" visible="false">
                Commentaar:<br />
                <textarea id="txtCommentaar" runat="server" cols="20" rows="3"></textarea>
            </div>
            </td>      
        </tr>
        <tr>
            <td>
                <asp:Button ID="cmdCheckIn" runat="server" Text="Check in" />
                
            </td>
            <td>
            
                
                <asp:UpdateProgress ID="UpdateProgress1" AssociatedUpdatePanelID="updInCheckFormulier" runat="server">
                    <ProgressTemplate>
                        <div class="progress">
                            <img src="../../Images/ajax-loader.gif" /> Even wachten aub...
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>
            </td>
        </tr>
            </table>

            </div>
    <asp:Label ID="lblResultaat" runat="server" Text=""></asp:Label>
    </ContentTemplate>
    </asp:UpdatePanel>
        </ContentTemplate>
    </asp:UpdatePanel>

                  
                 

</asp:Content>
