<%@ Page Language="VB" AutoEventWireup="false" CodeFile="Chauffeur.aspx.vb" Inherits="App_Presentation_Chauffeur"
    MasterPageFile="~/App_Presentation/MasterPage.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Main" ContentPlaceHolderID="plcMain" runat="server">
    <div>
        <asp:ScriptManager ID="scmChauffeur" runat="server" EnablePartialRendering="true" >
        </asp:ScriptManager>
        <cc1:Accordion ID="ChaffeurAccordion" runat="server" AutoSize="None" TransitionDuration="250" headercssclass="art-BlockHeaderStrong">
        <Panes>
        <cc1:AccordionPane ID="paneVoegtoe" runat="server">
        <Header><asp:Image ID="imgToevoegen" runat="server" ImageAlign="Top" ImageUrl="~/App_Presentation/Images/add.png" /> Chauffeur toevoegen</Header>
                <Content>
                    <asp:UpdatePanel runat="server" ID="updToevoegen" UpdateMode="Always">
                        <ContentTemplate>
                             <table>
            <tr>
                <td align="right">
                    <asp:Label ID="lblNaam" runat="server" Text="Naam chauffeur: "></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtNaam" runat="server"></asp:TextBox>
                </td>
                <td>
                    <asp:Label ID="lblNaamError" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <asp:Label ID="lblVoornaam" runat="server" Text="Voornaam chauffeur: "></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtVoornaam" runat="server"></asp:TextBox>
                </td>
                <td>
                    <asp:Label ID="lblVoornaamError" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <asp:Label ID="lblRijbewijs" runat="server" Text="Rijbewijs chauffeur: "></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtRijbewijs" runat="server"></asp:TextBox>
                </td>
                <td>
                    <asp:Label ID="lblRijbewijsError" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:Button ID="btnInsert" runat="server" Text="Voeg toe" />
                </td>
                <td colspan="2">
                    <asp:Image ID="imgInsertResultaat" runat="server" Visible="false" />&nbsp;<asp:Label ID="lblInsertResultaat" runat="server"></asp:Label>
                </td>
            </tr>
        </table>
        </ContentTemplate>
        </asp:UpdatePanel>
        </content>
        </cc1:AccordionPane>
        
        <cc1:AccordionPane ID="PaneWijzig" runat="server">
        <Header><asp:Image ID="imgWijzigen" runat="server" ImageAlign="Top" ImageUrl="~/App_Presentation/Images/wrench.png" /> Chauffeur Wijzigen</Header>
                <Content>
                    <asp:UpdatePanel runat="server" ID="updWijzigen" updateMode="Always" >
                        <ContentTemplate>
        <table>
        <tr>
                <td align="right">
                    <asp:Label ID="lblNaamup" runat="server" Text="Naam chauffeur: "></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtNaamup" runat="server"></asp:TextBox>
                </td>
                <td>
                    <asp:Label ID="lblNaamupError" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <asp:Label ID="lblvoornaamup" runat="server" Text="Voornaam chauffeur: "></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtVoornaamup" runat="server"></asp:TextBox>
                </td>
                <td>
                    <asp:Label ID="lblVoornaamupError" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <asp:Label ID="lblRijbewijsup" runat="server" Text="Rijbewijs chauffeur: "></asp:Label>
                </td>
                <td>
                    <asp:TextBox ID="txtRijbewijsup" runat="server"></asp:TextBox>
                </td>
                <td>
                    <asp:Label ID="lblRijbweijsupError" runat="server" Text=""></asp:Label>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <asp:Label ID="lblChauffeurDelete" runat="server" Text="Chauffeur: "></asp:Label>
                </td>
                <td>
                    <asp:DropDownList ID="ddlChauffeurWijzig" runat="server" AutoPostBack="True"></asp:DropDownList>
                </td>
                
            </tr>
            <tr>
                <td align="right">
                    <asp:Button ID="btnWijzig" runat="server" Text="Wijzig chauffeur" />
                </td>
                <td colspan="2">
                    <asp:Image ID="imgWijzigResultaat" runat="server" Visible="false" />&nbsp;<asp:Label ID="lblWijzigResultaat" runat="server"></asp:Label>
                </td>
            </tr>
        </table>
        </ContentTemplate>
        </asp:UpdatePanel>
        </Content>
        </cc1:AccordionPane>
        
        <cc1:AccordionPane ID="PaneDelete" runat="server">
        <Header><asp:Image ID="Image1" runat="server" ImageAlign="Top" ImageUrl="~/App_Presentation/Images/remove.png" /> Chauffeur verwijderen</Header>
                <Content>
                    <asp:UpdatePanel runat="server" ID="updVerwijderen" UpdateMode="Always">
                        <ContentTemplate>
        <table>
        
            <tr>
                <td align="right">
                    <asp:Label ID="lblChauffeur" runat="server" Text="Chauffeur: "></asp:Label>
                </td>
                <td>
                    <asp:DropDownList ID="ddlChauffeurdelete" runat="server" AutoPostBack="True"></asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td align="right">
                    <asp:Button ID="btnVerwijder" runat="server" Text="Verwijder" />
                </td>
                <td colspan="2">
                    <asp:Image ID="imgVerwijderResultaat" runat="server" Visible="false" />&nbsp;<asp:Label ID="lblVerwijderResultaat" runat="server"></asp:Label>
                </td>
            </tr>
        </table>
        </ContentTemplate>
        </asp:UpdatePanel>
        </Content>
        </cc1:AccordionPane>
        </Panes>
        </cc1:Accordion>
        <asp:ObjectDataSource ID="odsChauffeur" runat="server" 
            DeleteMethod="DeleteChauffeurByID" InsertMethod="AddChauffeur" 
            OldValuesParameterFormatString="original_{0}" SelectMethod="GetAllChauffeurs" 
            TypeName="ChauffeurBLL" DataObjectTypeName="Klanten+tblChauffeurRow&amp;">
            <DeleteParameters>
                <asp:Parameter Name="ChauffeurID" Type="Int32" />
            </DeleteParameters>
        </asp:ObjectDataSource>
        
    </div>
</asp:Content>