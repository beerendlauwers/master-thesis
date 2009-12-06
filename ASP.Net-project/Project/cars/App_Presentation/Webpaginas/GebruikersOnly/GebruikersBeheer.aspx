<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="GebruikersBeheer.aspx.vb" Inherits="App_Presentation_Webpaginas_GebruikersBeheer" title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" Runat="Server">
    <table>
<tr>
<td>
    <asp:Button ID="btnChauffeurs" runat="server" Text="Uw chauffeurs bewerken" />
</td>
<td>
</td>
</tr>
<tr>
    <td>
    <asp:Label ID="Label1" runat="server" Text="Uw gebruikersnaam: "></asp:Label>
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
        <asp:Label ID="Label4" runat="server" Text="Naam: "></asp:Label>
    </td>
    <td>
        <asp:TextBox ID="txtNaam" runat="server"></asp:TextBox>
    </td>
</tr>
<tr>
    <td>
        <asp:Label ID="Label5" runat="server" Text="Voornaam: "></asp:Label>
    </td>
    <td>
        <asp:TextBox ID="txtVoornaam" runat="server"></asp:TextBox>
    </td>
</tr>
<tr>
    <td>
        <asp:Label ID="Label2" runat="server" Text="Geboortedatum: "></asp:Label>
    </td>
    <td>
        <asp:TextBox ID="txtGeboorte" runat="server"></asp:TextBox>
    </td>
</tr>
<tr>
    <td>
        <asp:Label ID="IdentiteitsNr" runat="server" Text="IdentiteitsNr: "></asp:Label>
    </td>
    <td>
        <asp:TextBox ID="txtIdentiteitsNr" runat="server"></asp:TextBox>
    </td>
</tr>
<tr>
    <td>
        <asp:Label ID="Label3" runat="server" Text="RijbewijsNr: "></asp:Label>
    </td>
    <td>
        <asp:TextBox ID="txtRijbewijsNr" runat="server"></asp:TextBox>
    </td>
</tr>
<tr>
<td>
    <asp:Label ID="lblTelefoon" runat="server" Text="Telefoonnummer: "></asp:Label>
</td>
<td>
    <asp:TextBox ID="txtTelefoon" runat="server"></asp:TextBox>
</td>
</tr>
<tr>
    <td>
        <asp:Label ID="Label6" runat="server" Text="Bedrijfsnaam: " Visible="False"></asp:Label>
    </td>
    <td>
        <asp:TextBox ID="txtBedrijfnaam" runat="server" Visible="False"></asp:TextBox>
    </td>
</tr>
<tr>
    <td>
        <asp:Label ID="Label7" runat="server" Text="Vestigingslocatie: " 
            Visible="False"></asp:Label>
    </td>
    <td>
        <asp:TextBox ID="txtVestigingslocatie" runat="server" Visible="False"></asp:TextBox>
    </td>
</tr><tr>
    <td>
        <asp:Label ID="Label8" runat="server" Text="BTWnummer: " Visible="False"></asp:Label>
    </td>
    <td>
        <asp:TextBox ID="txtBTW" runat="server" Visible="False"></asp:TextBox>
    </td>
</tr>

<tr>
<td>
    <asp:Button ID="btnWijzig" runat="server" Text="Wijzig gegevens" 
        UseSubmitBehavior="False" />
</td>    
</tr>

</table>
</asp:Content>

