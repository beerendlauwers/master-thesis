<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="AutoSchema.aspx.vb" Inherits="App_Presentation_Webpaginas_Beheer_AutoSchema"  title="Reservatieschema"%>


<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" Runat="Server">
<%--deze pagina wordt opgemaakt adh een querystring die het autoID in zich draagt--%>
<%--de gegevens van de auto van wie de gelinkte ID is worden opgehaald--%>


<asp:ObjectDataSource ID="odsAutoGegevens" runat="server" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetData" TypeName="AutosTableAdapters.tblAutoTableAdapter">
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="odsReservatieGegevens" runat="server" 
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" 
        TypeName="ReservatiesTableAdapters.tblReservatieTableAdapter">
    </asp:ObjectDataSource>
    
    <asp:ObjectDataSource ID="odsKlantGegevens" runat="server" 
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" 
        TypeName="KlantenTableAdapters.tblUserProfielTableAdapter"></asp:ObjectDataSource>
    
    <br />
    
<%--    
    een overzicht laten zien van de bestellingen van de gezochte auto via de ontvangen autoID van de queriestring
    deze reservaties zouden dan nog aangepast moeten kunnen worden (oa verwijderen)
    die aanpassingen gebeuren in andere pagina bij ReservatieWijzigen--%>
    
    
    <asp:Panel ID="pnlOverzicht1" runat="server">

               <table>
                <tr>
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
                <asp:Repeater ID="repOverzicht1" runat="server" OnItemCommand="repOverzicht1_ItemCommand">
                    <ItemTemplate>
                        <tr style="background-color:#<%# DataBinder.Eval(Container.DataItem, "rijKleur") %>">

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
                                <asp:ImageButton ID="imgDelete" runat="server" ImageUrl="~/App_Presentation/Images/remove.png"
                                    CommandArgument='<%#DataBinder.Eval(Container.DataItem, "autoWijzigen")%>' /><%-- moet reservatieVerwijderen worden--%>
                            </td>
                             
                        </tr>
                    </ItemTemplate>
                </asp:Repeater>
            </table>
        </asp:Panel>
    <asp:Label ID="lblGeenReservaties" runat="server" Text="Label"></asp:Label>

    
    <%--ophalen van de reservatie-info, begindatums & einddatums vooral; voor het aanpassen van de calender-kleuren
    dag nadat reservatieStatus = 4 moet op paars of whatever komen te staan voor onderhoud--%>
    
    
    <%--informatie van de auto met het gelinkte ID laten zien--%>
     
	  <asp:Panel ID="pnlOverzicht" runat="server">
	 <div runat="server" id="divOverzichtHeader" visible="false">    
 
        <asp:PlaceHolder ID="plcOverzicht" runat="server"></asp:PlaceHolder>
            <br />
            <div runat="server" class=" art-Overzicht" id="divRepOverzicht">                 
                <asp:Repeater ID="RepOverzicht" runat="server">
                    <ItemTemplate>
                        <div style="display: inline">
                            <a href="ReservatieBevestigen.aspx?autoID=<%# DataBinder.Eval(Container.DataItem, "autoID") %>&begindat=<%# DataBinder.Eval(Container.DataItem, "begindat") %>&einddat=<%# DataBinder.Eval(Container.DataItem, "einddat") %>">
                                                                
                                <table border="0">
                                <tr>
                                    <td colspan="2"><h3><%#DataBinder.Eval(Container.DataItem, "Naam")%></h3></td>
                                </tr>
                                <tr>
                                    <td rowspan="5"><img src="../AutoFoto.ashx?autoID=<%# DataBinder.Eval(Container.DataItem, "autoID") %>" alt="foto" width="200" height="150" style="display:inline" /></td>
                                </tr>
                                <tr>
                                    <td><b>Nummerplaat:</b> <%#DataBinder.Eval(Container.DataItem, "autoKenteken")%></td>
                                </tr>
                                    <tr>
                                    <td><b>Aantal kilometer tot olieverversing:</b> <%#DataBinder.Eval(Container.DataItem, "autoKMTotOlieVerversing")%></td>
                                </tr>
                                </table>
                        </div>
                        <br />
                    </ItemTemplate>
                </asp:Repeater>
            </div>
          </div>
</asp:Panel>

        <br />
        Filteren op klant:<br />
          <br />

        <asp:DropDownList ID="ddlKlant" runat="server" DataSourceID="odsKlantGegevens" 
                DataTextField="userVoornaam" DataValueField="userID"></asp:DropDownList>
                <%--achternaam moet hier nog achter komen te staan, anders niet uniek/of moet gebruik maken van gebruiksnaam of gebruikersID--%>
   
    <br />
    <br />


    Overzicht van den reservaties:
    
    <br />
    <br />
    
    <asp:Calendar ID="calAutoSchema" runat="server" BackColor="White" 
        BorderColor="White" BorderWidth="1px" Font-Names="Verdana" Font-Size="9pt" 
        ForeColor="Black" Height="384px" NextPrevFormat="FullMonth" Width="737px">
        <SelectedDayStyle BackColor="#333399" ForeColor="White" />
        <TodayDayStyle BackColor="#CCCCCC" />
        <OtherMonthDayStyle ForeColor="#999999" />
        <NextPrevStyle Font-Bold="True" Font-Size="8pt" ForeColor="#333333" 
            VerticalAlign="Bottom" />
        <DayHeaderStyle Font-Bold="True" Font-Size="8pt" />
        <TitleStyle BackColor="White" BorderColor="Black" BorderWidth="4px" 
            Font-Bold="True" Font-Size="12pt" ForeColor="#333399" />
    </asp:Calendar>
    
<%--    de gereserveerde dagen moeten in het rood komen te staan
    de dagen dat er onderhoud moet gedaan worden in het paars of whatever
    => wanneer wordt een dag paars voor onderhoud? => standaard=einddatum van reservering+1 OF wanneer het aantal km tot olieverversing op 0 komt te staan?)
    de vrije dagen gewoon wit laten of groen?--%>
    <%--
    als ge klikt op nen dag die rood gekleurd is (gerserveerd dus), krijgt ge de pagina met de reservatiegegevens te zien
    als ge klikt op nen dag die paars gekleurd is (onderhoud), dan krijgt ge de pagina te zien met de onderhoudsgegevens
    manueel ook mogelijk om een onderhoudsdag toe te voegen door op een witte dag te klikken?--%>
    
    </asp:Content>
