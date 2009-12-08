<%@ Page Language="VB" AutoEventWireup="false" CodeFile="ParkingBeheer.aspx.vb" Inherits="App_Presentation_Webpaginas_FiliaalBeheer"
    MasterPageFile="~/App_Presentation/MasterPage.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Main" ContentPlaceHolderID="plcMain" runat="server">

    <script type="text/javascript">
        
      function VeranderKleur()
      {
        <%=PostBackString%>
      }    

    </script>

                    <asp:Label ID="Label1" runat="server" Text="FiliaalID (test): "></asp:Label>
            <asp:TextBox ID="txtFiliaal" runat="server"></asp:TextBox>
            <br />
                <asp:Label ID="lblKolommen" runat="server" Text="Aantal kolommen: "></asp:Label>
            <asp:TextBox ID="txtKolommen" runat="server"></asp:TextBox>
            <br />
            <asp:Label ID="lblRijen" runat="server" Text="Aantal rijen: "></asp:Label>
            <asp:TextBox ID="txtRijen" runat="server"></asp:TextBox>
            <br />
            <asp:Button ID="btnMaakLayout" runat="server" Text="Maak Layout" />
            <br />
    
    <asp:UpdatePanel ID="updLayout" runat="server">
        <ContentTemplate>
            <asp:PlaceHolder ID="plcParkingLayout" runat="server"></asp:PlaceHolder>
        </ContentTemplate>
    </asp:UpdatePanel>
    
    <asp:Button ID="btnLayoutOpslaan" runat="server" Text="Layout Opslaan" />
        
    <cc1:Accordion ID="FiliaalAccordion" runat="server" AutoSize="None" TransitionDuration="250" headercssclass="art-BlockHeaderStrong">
        <Panes>
            <cc1:AccordionPane ID="PaneToevoegen" runat="server">
                
            </cc1:AccordionPane>
        </Panes>
    </cc1:Accordion>
</asp:Content>
