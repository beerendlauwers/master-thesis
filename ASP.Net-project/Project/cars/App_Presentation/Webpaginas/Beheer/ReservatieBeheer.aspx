﻿
<%@ Page Language="VB" enableEventValidation="false" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false"
    CodeFile="ReservatieBeheer.aspx.vb" Inherits="App_Presentation_Webpaginas_GebruikersOnly_ToonReservatie"
    Title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" runat="Server">
Filteren op klant: 
        <asp:DropDownList ID="ddlKlant" runat="server" 
                DataTextField="userVoornaam" DataValueField="userID" AutoPostBack="true"></asp:DropDownList>
    &nbsp;&nbsp; Filteren op auto: <asp:DropDownList ID="ddlAuto" runat="server" 
        AutoPostBack="True">
    </asp:DropDownList>
    
    <asp:UpdatePanel ID="updReservatieBeheer" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
    <asp:Panel ID="pnlOverzicht" runat="server">
              <asp:UpdateProgress ID="progress1" runat="server">
        <ProgressTemplate>
        
            <div class="progress" align="center">
            <br />
                <img src="../../Images/ajax-loader.gif" />
                Even wachten aub...
                <br /><br />
            </div>
        
        </ProgressTemplate>
    </asp:UpdateProgress>
    <div align="center" runat="server" id="divFeedback" Visible="false">
        <br /><asp:Image ID="imgFeedback" runat="server" />&nbsp;<asp:Label ID="lblFeedback" runat="server"></asp:Label><br /><br /></div>
               <table>
                <tr>
                    <th>
                        Auto
                    </th>
                    <th>
                        Kleur
                    </th>
                    <th>
                        Begindatum
                    </th>
                    <th>
                        Einddatum
                    </th>
                    <th>
                        # Dagen
                    </th>
                    <th>
                        # Opties
                    </th>
                    <th>
                        Totaalkost
                    </th>
                    <th>
                        &nbsp;
                    </th>
                    <th>
                        &nbsp;
                    </th>
                </tr>
                <asp:Repeater ID="repOverzicht" runat="server" OnItemCommand="repOverzicht_ItemCommand">
                    <ItemTemplate>
                        <tr style="background-color:#<%# DataBinder.Eval(Container.DataItem, "rijKleur") %>">
                            <td align="center">
                                <%# DataBinder.Eval(Container.DataItem, "autoNaam") %>
                            </td>
                            <td align="center">
                                <%#DataBinder.Eval(Container.DataItem, "autoKleur")%>
                            </td>
                            <td align="center">
                                <%#(CType(Container.DataItem, System.Data.DataRowView)("begindat")).ToShortDateString()%> 
                            </td>
                            <td align="center">
                                <%#(CType(Container.DataItem, System.Data.DataRowView)("einddat")).ToShortDateString()%> 
                            </td>
                            <td align="center">
                                 <%#DataBinder.Eval(Container.DataItem, "aantalDagen")%>
                            </td>
                            <td align="center">
                                <%#DataBinder.Eval(Container.DataItem, "aantalOpties")%>
                            </td>
                            <td align="right">
                                <%#DataBinder.Eval(Container.DataItem, "totaalKost")%>
                            </td>
                            <td align="center">
                                <asp:ImageButton ID="imgButton" runat="server" ImageUrl="~/App_Presentation/Images/wrench.png"
                                    CommandArgument='<%#DataBinder.Eval(Container.DataItem, "autoWijzigen")%>' />
                            </td>
                            <td align="center">
                                <asp:ImageButton ID="imgButtonVerwijderen" runat="server" ImageUrl="~/App_Presentation/Images/remove.png"
                                    CommandArgument='<%#DataBinder.Eval(Container.DataItem, "autoVerwijderen")%>' />
                            </td>
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </table>
        </asp:Panel>
            <asp:Label ID="lblGeenReservaties" runat="server" Text="Label"></asp:Label>
        <br />
        
        
      
        
<asp:Button ID="btnVerwijder" runat="server" Text="Verwijder" Visible="False" />
        <asp:Button ID="btnReserve" runat="server" Text="Reserve" Visible="False" />
        <asp:Label ID="lblInfo" runat="server" Visible="False"></asp:Label>
    
</ContentTemplate>
    </asp:UpdatePanel><asp:Repeater ID="repReserve" runat="server">
    <ItemTemplate>
                        <tr style="background-color:#<%# DataBinder.Eval(Container.DataItem, "rijKleur") %>">
                            <td align="center">
                                <%# DataBinder.Eval(Container.DataItem, "autoNaam") %>
                            </td>
                            <td align="center">
                                <%#DataBinder.Eval(Container.DataItem, "autoKleur2")%>
                            </td>
                           <%--<td align="center">
                                <%#DataBinder.Eval(Container.DataItem, "autoKenteken2")%>
                            </td>--%>
                            <td align="center">
                                <%#DataBinder.Eval(Container.DataItem, "autoDagtarief2")%>
                            </td>
                        </tr>
                    </ItemTemplate>
    </asp:Repeater>
</asp:Content>
