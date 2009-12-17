<%@ Page Language="VB" Debug="true" AutoEventWireup="false" CodeFile="ParkingBeheer.aspx.vb"
    Inherits="App_Presentation_Webpaginas_FiliaalBeheer" MasterPageFile="~/App_Presentation/MasterPage.master" title="Parkingbeheer"%>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Main" ContentPlaceHolderID="plcMain" runat="server">

<h1>Parkingbeheer</h1>

    <script type="text/javascript">
        
      function VeranderKleur()
      {
        <%=PostBackString%>
      }    

    </script>

    <table>
        <tr>
            <td>
                Selecteer Filiaal:
            </td>
            <td>
                <asp:DropDownList ID="ddlFiliaal" runat="server" AutoPostBack="True" DataSourceID="odsFiliaal"
                    DataTextField="filiaalNaam" DataValueField="filiaalID">
                </asp:DropDownList>
            </td>
        </tr>
    </table>
    <table>
        <tr>
            <td>
                Aantal kolommen:
            </td>
            <td>
                <asp:TextBox ID="txtKolommen" runat="server" ></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
                Aantal rijen:
            </td>
            <td>
                <asp:TextBox ID="txtRijen" runat="server"></asp:TextBox>
            </td>
        </tr>
    </table>
    <asp:Button ID="btnMaakLayout" runat="server" Text="Maak Layout" />
    <asp:UpdatePanel ID="updLayout" runat="server" UpdateMode="Always">
        <ContentTemplate>
            <br />
            <asp:Label ID="lblGeenData" runat="server"></asp:Label>
            <br /><br />
            <div style="background-color: #D2D2D0;padding: 5px 5px 5px 5px;border: dashed 1px black;">
            <b>Legende:</b><br />
            <img src="../../Images/parkeerplaats.png" /> - Parkeerplaats<br />
            <img src="../../Images/rijweg.png" /> - Rijweg<br />
            <img src="../../Images/house.png" /> - Gebouw<br />
            <img src="../../Images/spacer.gif" height="20" width="20" /> - (leeg) Geen bedrijfsterrein<br />
            </div>
            <br />
            <div style="background-color: Gray; color: White;">
                <asp:PlaceHolder ID="plcParkingLayout" runat="server"></asp:PlaceHolder>
            </div>
            <asp:Button ID="btnLayoutOpslaan" runat="server" Text="Layout Opslaan" />
        </ContentTemplate>
    </asp:UpdatePanel>
    <br />
    <asp:ObjectDataSource ID="odsFiliaal" runat="server" DataObjectTypeName="Autos+tblFiliaalRow&amp;"
        DeleteMethod="DeleteFiliaal" InsertMethod="AddFiliaal" SelectMethod="GetAllFilialen"
        TypeName="FiliaalBLL" UpdateMethod="UpdateFiliaal">
        <DeleteParameters>
            <asp:Parameter Name="filiaalID" Type="Int32" />
        </DeleteParameters>
    </asp:ObjectDataSource>
    <cc1:Accordion ID="FiliaalAccordion" runat="server" AutoSize="None" TransitionDuration="250"
        HeaderCssClass="art-BlockHeaderStrong">
        <Panes>
            <cc1:AccordionPane ID="PaneToevoegen" runat="server">
            </cc1:AccordionPane>
        </Panes>
    </cc1:Accordion>
</asp:Content>
