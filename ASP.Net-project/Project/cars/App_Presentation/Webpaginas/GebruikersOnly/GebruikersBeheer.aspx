<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="GebruikersBeheer.aspx.vb" Inherits="App_Presentation_Webpaginas_GebruikersBeheer" title="Untitled Page" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" Runat="Server">
        <asp:UpdatePanel ID="updGegevens" runat="server" updateMode="Always">
        <ContentTemplate>
        <table>
        
<tr>
    <td>
    <asp:Label ID="lblUserNameUitleg" runat="server" Text="Uw gebruikersnaam: "></asp:Label>
    </td>
    <td>
    <asp:Label ID="lblUserName" runat="server" Text=""></asp:Label>
    </td>    
</tr>

<tr>
    <td>
    <asp:Label ID="lblPaswoordNieuw" runat="server" Text="Paswoord: "></asp:Label>
    </td>
    <td>
        <asp:ChangePassword ID="ChangePassword1" runat="server">
            <ChangePasswordTemplate>
                <table border="0" cellpadding="1" cellspacing="0" 
                    style="border-collapse:collapse;">
                    <tr>
                        <td>
                            <table border="0" cellpadding="0">
                                <tr>
                                    <td align="center" colspan="2">
                                        Verander uw paswoord</td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <asp:Label ID="CurrentPasswordLabel" runat="server" 
                                            AssociatedControlID="CurrentPassword">Huidig Paswoord:</asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="CurrentPassword" runat="server" TextMode="Password"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="CurrentPasswordRequired" runat="server" 
                                            ControlToValidate="CurrentPassword" ErrorMessage="Invullen van het oude paswoord is vereist." 
                                            ToolTip="Password is required." ValidationGroup="ChangePassword1">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <asp:Label ID="NewPasswordLabel" runat="server" 
                                            AssociatedControlID="NewPassword">Nieuw Paswoord:</asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="NewPassword" runat="server" TextMode="Password"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="NewPasswordRequired" runat="server" 
                                            ControlToValidate="NewPassword" ErrorMessage="Nieuw paswoord is vereist." 
                                            ToolTip="New Password is required." ValidationGroup="ChangePassword1">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <asp:Label ID="ConfirmNewPasswordLabel" runat="server" 
                                            AssociatedControlID="ConfirmNewPassword">Bevestig nieuw paswoord:</asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="ConfirmNewPassword" runat="server" TextMode="Password"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="ConfirmNewPasswordRequired" runat="server" 
                                            ControlToValidate="ConfirmNewPassword" 
                                            ErrorMessage="Bevestiging van het nieuwe paswoord is vereist." 
                                            ToolTip="Confirm New Password is required." ValidationGroup="ChangePassword1">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" colspan="2">
                                        <asp:CompareValidator ID="NewPasswordCompare" runat="server" 
                                            ControlToCompare="NewPassword" ControlToValidate="ConfirmNewPassword" 
                                            Display="Dynamic" 
                                            ErrorMessage="De bevestiging van het paswoord moet gelijk zijn aan het nieuwe paswoord." 
                                            ValidationGroup="ChangePassword1"></asp:CompareValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" colspan="2" style="color:Red;">
                                        <asp:Literal ID="FailureText" runat="server" EnableViewState="False"></asp:Literal>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">
                                        <asp:Button ID="ChangePasswordPushButton" runat="server" 
                                            CommandName="ChangePassword" Text="Wijzig paswoord" 
                                            ValidationGroup="ChangePassword1" />
                                    </td>
                                    <td>
                                        <asp:Button ID="CancelPushButton" runat="server" CausesValidation="False" 
                                            CommandName="Cancel" Text="Cancel" />
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
            </ChangePasswordTemplate>
        </asp:ChangePassword>
    </td>
</tr>
<tr>
    <td>
        <asp:Label ID="lblNaam" runat="server" Text="Naam: "></asp:Label>
    </td>
    <td>
        <asp:TextBox ID="txtNaam" runat="server" Enabled="False"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
            ControlToValidate="txtNaam" ErrorMessage="Dit veld kan u niet leeg laten."></asp:RequiredFieldValidator>
    </td>
</tr>
<tr>
    <td>
        <asp:Label ID="lblVoornaam" runat="server" Text="Voornaam: "></asp:Label>
    </td>
    <td>
        <asp:TextBox ID="txtVoornaam" runat="server" Enabled="False"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
            ControlToValidate="txtVoornaam" ErrorMessage="Dit veld kan u niet leeg laten."></asp:RequiredFieldValidator>
    </td>
</tr>
<tr>
    <td>
        <asp:Label ID="lblGebDat" runat="server" Text="Geboortedatum: "></asp:Label>
    </td>
    <td>
        <asp:TextBox ID="txtGeboorte" runat="server" Enabled="False"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" 
            ControlToValidate="txtGeboorte" ErrorMessage="Dit veld kan u niet leeg laten."></asp:RequiredFieldValidator>
    </td>
</tr>
<tr>
    <td>
        <asp:Label ID="IdentiteitsNr" runat="server" Text="IdentiteitsNr: "></asp:Label>
    </td>
    <td>
        <asp:TextBox ID="txtIdentiteitsNr" runat="server" Enabled="False">XXXXXX-XXXXX</asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" 
            ControlToValidate="txtIdentiteitsNr" 
            ErrorMessage="Dit veld kan u niet leeg laten."></asp:RequiredFieldValidator>
    </td>
</tr>
<tr>
    <td>
        <asp:Label ID="lblRijbewijsnr" runat="server" Text="RijbewijsNr: "></asp:Label>
    </td>
    <td>
        <asp:TextBox ID="txtRijbewijsNr" runat="server" Enabled="False">XXXXXXXXXX</asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" 
            ControlToValidate="txtRijbewijsNr" 
            ErrorMessage="Dit veld kan u niet leeg laten."></asp:RequiredFieldValidator>
    </td>
</tr>
<tr>
<td>
    <asp:Label ID="lblTelefoon" runat="server" Text="Telefoonnummer: "></asp:Label>
</td>
<td>
    <asp:TextBox ID="txtTelefoon" runat="server" Enabled="False"></asp:TextBox>
    <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" 
        ControlToValidate="txtTelefoon" ErrorMessage="Dit veld kan u niet leeg laten."></asp:RequiredFieldValidator>
</td>
</tr>
</tr>
<tr>
    <td>
        <asp:Label ID="lblBedrijfsnaam" runat="server" Text="Bedrijfsnaam: " Visible="False"></asp:Label>
    </td>
    <td>
        <asp:TextBox ID="txtBedrijfnaam" runat="server" Visible="False" Enabled="False"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" 
            ControlToValidate="txtBedrijfnaam" 
            ErrorMessage="Dit veld kan u niet leeg laten."></asp:RequiredFieldValidator>
    </td>
</tr>
<tr>
    <td>
        <asp:Label ID="lblVestigingslocatie" runat="server" Text="Vestigingslocatie: " 
            Visible="False"></asp:Label>
    </td>
    <td>
        <asp:TextBox ID="txtVestigingslocatie" runat="server" Visible="False" 
            Enabled="False"></asp:TextBox>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" 
            ControlToValidate="txtVestigingslocatie" 
            ErrorMessage="Dit veld kan u niet leeg laten."></asp:RequiredFieldValidator>
    </td>
</tr><tr>
    <td>
        <asp:Label ID="lblBTW" runat="server" Text="BTWnummer: " Visible="False"></asp:Label>
    </td>
    <td>
        <asp:TextBox ID="txtBTW" runat="server" Visible="False" Enabled="False">XXX-XXX-XXX</asp:TextBox>
        <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server"  ClearMaskOnLostFocus="false" TargetControlID="txtBTW" Mask="999\-999\-999">
        </cc1:MaskedEditExtender>
    </td>
</tr>

<tr>
<td>
    <asp:Button ID="btnWeergave" runat="server" Text="Wijzig gegevens" 
        UseSubmitBehavior="False" />
</td>   
<td>
    <asp:Button ID="btnWijzig" runat="server" Text="Wijzigingen opslaan" />
</td> 
</tr>
<tr>
<td>
    <asp:Button ID="btnChauffeurs" runat="server" Text="Uw chauffeurs bewerken" />
</td>
<td>
</td>
</tr>

</table>
</ContentTemplate>
</asp:UpdatePanel>

</asp:Content>

