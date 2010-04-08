<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="ArtikelVerwijderen.aspx.vb" Inherits="App_Presentation_verwijderenTekst" title="Untitled Page" %>

<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Artikel Verwijderen</title>
</asp:Content>
<asp:Content runat="server" ID="Content3" ContentPlaceHolderID="ContentPlaceHolderTitel">Artikel Verwijderen</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div id="divLoggedIn" runat="server">
    
    <asp:UpdatePanel ID="updVerwijderen" runat="server">
    <ContentTemplate>
    
        <asp:Panel ID="pnlConfirmatie" runat="server" style="display:none;" CssClass="modalPopup">
        <asp:UpdatePanel ID="updConfirmatie" runat="server">
        <ContentTemplate>
        <table align="center">
        <tr>
        <td colspan="2">Bent u zeker dat u het artikel "<asp:Label runat="server" ID="lblArtikeltitel"></asp:Label>" wilt verwijderen?</td>
        </tr>
        <tr>
        <td><asp:Button ID="btnOK" runat="server" Text="Ja" /></td>
        <td><asp:Button ID="btnAnnuleer" runat="server" Text="Annuleren" /></td>
        </tr>
        </table>
        </ContentTemplate>
        </asp:UpdatePanel>
        </asp:Panel>
        <asp:HiddenField ID="hdnRowID" runat="server" />
        <asp:Button ID="btnDummyButton" runat="server" style="display:none;" />
        <cc1:ModalPopupExtender ID="mpeConfirmatie" runat="server" TargetControlID="btnDummyButton" BackgroundCssClass="modalBackground" OkControlID="btnOK" CancelControlID="btnAnnuleer" PopupControlID="pnlConfirmatie">
        </cc1:ModalPopupExtender>
    
<table>
<tr>
<th align="left">Zoekopdracht verfijnen</th>
</tr>
<tr>
<td class="lbl"><asp:Label ID="lblVersie" runat="server" Text="Versie: "></asp:Label></td>
<td><asp:DropDownList ID="ddlVersie" runat="server" Width="100%"></asp:DropDownList></td>
<td><span style="vertical-align:middle" id='tipVersie'><img src="CSS/images/help.png" alt=''/></span></td>
</tr>
<tr>
<td class="lbl"><asp:Label ID="lblTaal" runat="server" Text="Taal: "></asp:Label></td>
<td><asp:DropDownList ID="ddlTaal" runat="server" Width="100%"></asp:DropDownList></td>
<td><span style="vertical-align:middle" id='tipTaal'><img src="CSS/images/help.png" alt=''/></span></td>
</tr>
<tr>
<td class="lbl"><asp:Label ID="lblBedrijf" runat="server" Text="Bedrijf: "></asp:Label></td>
<td><asp:DropDownList ID="ddlBedrijf" runat="server" Width="100%"></asp:DropDownList></td>
<td><span style="vertical-align:middle" id='tipBedrijf'><img src="CSS/images/help.png" alt=''/></span></td>
</tr>
<tr>
<td class="lbl"><asp:Label ID="lblFinaal" runat="server" Text="Artikel is finaal: "></asp:Label></td>
<td><asp:DropDownList ID="ddlIsFInaal" runat="server" Width="100%"></asp:DropDownList></td>
<td><span style="vertical-align:middle" id='tipIsFinaal'><img src="CSS/images/help.png" alt=''/></span></td>
</tr>
<tr>
<th align="left">Zoeken op...</th>
</tr>
<tr>
<td class="lbl"><asp:Label ID="lblZoekTitel" runat="server" Text="Titel:"></asp:Label></td>
<td><asp:TextBox ID="txtSearchTitel" runat="server" Width="100%"></asp:TextBox>
    <asp:CustomValidator ID="vleZoekTitel" runat="server" ErrorMessage="Gelieve een zoekterm in te geven." Display="None" ControlToValidate="txtSearchTitel" OnServerValidate="ValideerZoekTerm" ClientValidationFunction="ValideerZoekTerm" ValidateEmptyText="true" ></asp:CustomValidator>
    <cc1:ValidatorCalloutExtender
            ID="extSearchTitel" runat="server" TargetControlID="vleZoekTitel"></cc1:ValidatorCalloutExtender>
</td>
<td>
<span style="vertical-align:middle" id="tipZoekTitel"><img src="CSS/images/help.png" alt=''/></span>
</td>
</tr>
<tr>
<td class="lbl"><asp:Label ID="lblZoekTekst" runat="server" Text="Tekst:"></asp:Label></td>
<td><asp:TextBox ID="txtSearchText" runat="server" Width="100%"></asp:TextBox>
    <asp:CustomValidator ID="vleZoekText" runat="server" ErrorMessage="Gelieve een zoekterm in te geven." Display="None" ControlToValidate="txtSearchText" OnServerValidate="ValideerZoekTerm" ClientValidationFunction="ValideerZoekTerm" ValidateEmptyText="true" ></asp:CustomValidator>
    <cc1:ValidatorCalloutExtender
            ID="extSearchText" runat="server" TargetControlID="vleZoekText"></cc1:ValidatorCalloutExtender>
</td>
<td>
<span style="vertical-align:middle" id="tipZoekTekst"><img src="CSS/images/help.png" alt=''/></span>
</td>
</tr>

<tr>
<th colspan="2">&nbsp;</th>
</tr>

<tr>
<td>&nbsp;</td>
<td><asp:Button ID="btnZoek" runat="server" Text="Zoeken" Width="100%" /></td>
<td><asp:UpdateProgress ID="prgZoeken" runat="server" AssociatedUpdatePanelID="updVerwijderen">
    <ProgressTemplate>
    <div class="update">
    <img src="CSS/Images/ajaxloader.gif" />
    <asp:label runat="server" id="lblProgressTekst" Text="Bezig met ophalen van artikels..."></asp:label>
    </div>
    </ProgressTemplate>
    </asp:UpdateProgress></td>
</tr>

</table>

<br />
<div id="gridview" style="display:none">
<div>
    <asp:GridView ID="grdResultaten" runat="server" 
        AutoGenerateColumns="False" Width="100%">
        <Columns>
            <asp:BoundField DataField="Titel" HeaderText="Titel" SortExpression="Titel" />
            <asp:BoundField DataField="Tag" HeaderText="Tag" SortExpression="Tag" />
            <asp:BoundField DataField="Versie" HeaderText="Versie" 
                SortExpression="Versie" />
            <asp:BoundField DataField="Naam" HeaderText="Naam" SortExpression="Bedrijf" />
            <asp:BoundField DataField="Taal" HeaderText="Taal" SortExpression="Taal" />
            <asp:BoundField DataField="Is_final" HeaderText="Finale Versie" 
                SortExpression="Is_final" />
            <asp:CommandField ButtonType="Image" 
                SelectImageUrl="~/App_Presentation/CSS/images/remove.png" 
                ShowSelectButton="True" />
        </Columns>
    </asp:GridView>
</div>
</div>

<asp:Label runat="server" ID="lblSelecteerArtikel" Text="Selecteer een artikel om te verwijderen." Visible="false"></asp:Label>
<br /><br />
<div runat="server" id="divFeedback" visible="false" style="text-align:center;">
        <asp:Image ID="imgResultaat" runat="server" />&nbsp;<asp:Label ID="lblResultaat" runat="server"></asp:Label>
</div>

<script type="text/javascript">
function ValideerZoekTerm (source, args)
{
    // Default Value
    args.IsValid = true;

    var resultaten = document.getElementById('<%=txtSearchTitel.clientID%>').value + document.getElementById('<%=txtSearchText.clientID%>').value;
    
    if( resultaten === '' )
        args.isValid = false;
    
}
</script>

    </ContentTemplate>
    </asp:UpdatePanel>
</div>
</asp:Content>

