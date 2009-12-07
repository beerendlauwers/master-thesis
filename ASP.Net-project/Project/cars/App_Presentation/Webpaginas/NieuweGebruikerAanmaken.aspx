<%@ Page Language="VB" AutoEventWireup="false" CodeFile="NieuweGebruikerAanmaken.aspx.vb"
    Inherits="App_Presentation_Webpaginas_nieuwe_gebruiker" MasterPageFile="~/App_Presentation/MasterPage.master" %>
<%@ Register assembly="AjaxControlToolkit" namespace="AjaxControlToolkit" tagprefix="cc1" %>

<%@ MasterType VirtualPath="~/App_Presentation/MasterPage.master" %>
<asp:Content ID="Main" ContentPlaceHolderID="plcMain" runat="server">
    <asp:ScriptManager ID="scmManager" runat="server" EnablePartialRendering="true">
    </asp:ScriptManager>
    <table>
        <tr>
            <td>
                <asp:UpdatePanel ID="updGebruiker" runat="server" UpdateMode="Always">
                    <ContentTemplate>
                        <asp:CreateUserWizard ID="wizard" runat="server">
                            <WizardSteps>
                                <asp:CreateUserWizardStep runat="server">
                                    <ContentTemplate>
                                        <asp:Label ID="lblAnoniemeReservatie" runat="server" Visible="False"></asp:Label> 
                                        <table border="0">
                                            <tr>
                                                <th align="center" colspan="2">
                                                <br />
                                                Nieuwe gebruiker aanmaken
                                                </td>
                                                    <br />
                                                    <br />
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    <asp:Label ID="UserNameLabel" runat="server" AssociatedControlID="UserName">Gebruikersnaam:</asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="UserName" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="UserNameRequired" runat="server" ControlToValidate="UserName"
                                                        ErrorMessage="User Name is required." ToolTip="User Name is required." ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    <asp:Label ID="PasswordLabel" runat="server" AssociatedControlID="Password">Paswoord:</asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="Password" runat="server" TextMode="Password"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="PasswordRequired" runat="server" ControlToValidate="Password"
                                                        ErrorMessage="Password is required." ToolTip="Password is required." ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    <asp:Label ID="ConfirmPasswordLabel" runat="server" AssociatedControlID="ConfirmPassword">Bevestig Paswoord:</asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="ConfirmPassword" runat="server" TextMode="Password"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="ConfirmPasswordRequired" runat="server" ControlToValidate="ConfirmPassword"
                                                        ErrorMessage="Confirm Password is required." ToolTip="Confirm Password is required."
                                                        ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    <asp:Label ID="EmailLabel" runat="server" AssociatedControlID="Email">E-mail:</asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="Email" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="EmailRequired" runat="server" ControlToValidate="Email"
                                                        ErrorMessage="E-mail is required." ToolTip="E-mail is required." ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    <asp:Label ID="QuestionLabel" runat="server" AssociatedControlID="Question">Beveiligingsvraag:</asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="Question" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="QuestionRequired" runat="server" ControlToValidate="Question"
                                                        ErrorMessage="Security question is required." ToolTip="Security question is required."
                                                        ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    <asp:Label ID="AnswerLabel" runat="server" AssociatedControlID="Answer">Beveiligingsantwoord:</asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="Answer" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="AnswerRequired" runat="server" ControlToValidate="Answer"
                                                        ErrorMessage="Security answer is required." ToolTip="Security answer is required."
                                                        ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    <asp:Label ID="lblVoornaam" runat="server" Text="Voornaam"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtVoornaam" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="AnswerRequired0" runat="server" ControlToValidate="txtVoornaam"
                                                        ErrorMessage="Voornaam moet ingevuld zijn." ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    <asp:Label ID="lblNaam" runat="server" Text="Naam"></asp:Label>
                                                </td>
                                                <td style="font-weight: 700">
                                                    <asp:TextBox ID="txtNaam" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="AnswerRequired1" runat="server" ControlToValidate="txtNaam"
                                                        ErrorMessage="Naam moet ingevuld zijn." ToolTip="Security answer is required."
                                                        ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    <asp:Label ID="lblGeboorte" runat="server" Text="Geboortedatum"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtGeboorte" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="AnswerRequired2" runat="server" ControlToValidate="txtGeboorte"
                                                        ErrorMessage="Geboortedatum moet ingevuld zijn." ToolTip="Security answer is required."
                                                        ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    <asp:Label ID="lblIdentiteitsnr" runat="server" Text="Identiteitsnummer"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtIdentiteitsNr" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="AnswerRequired3" runat="server" ControlToValidate="txtIdentiteitsNr"
                                                        ErrorMessage="Identiteitsnummer moet ingevuld zijn." ToolTip="Security answer is required."
                                                        ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    <asp:Label ID="lblRijbewijsnr" runat="server" Text="Rijbewijsnummer"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtRijbewijsNr" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="AnswerRequired4" runat="server" ControlToValidate="txtRijbewijsNr"
                                                        ErrorMessage="Rijbewijsnummer moet ingevuld zijn." ToolTip="Security answer is required."
                                                        ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    <asp:Label ID="lblTelefoon" runat="server" Text="Telefoon"></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtTelefoon" runat="server"></asp:TextBox>
                                                    <asp:RequiredFieldValidator ID="AnswerRequired5" runat="server" ControlToValidate="txtTelefoon"
                                                        ErrorMessage="Telefoon moet ingevuld zijn." ToolTip="Security answer is required."
                                                        ValidationGroup="CreateUserWizard1">*</asp:RequiredFieldValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">
                                                    Ik ben een bedrijfsverantwoordelijke.
                                                </td>
                                                <td>
                                                    <asp:CheckBox ID="chkIsBedrijf" runat="server" OnCheckedChanged="MaakBedrijfZichtbaar"
                                                        AutoPostBack="true" />
                                                </td>
                                            </tr>
                                            <asp:UpdatePanel ID="updBedrijf" runat="server" UpdateMode="Conditional">
                                                <Triggers>
                                                    <asp:AsyncPostBackTrigger ControlID="chkIsBedrijf" />
                                                </Triggers>
                                                <ContentTemplate>
                                                    <tr>
                                                        <td align="right">
                                                            <asp:Label ID="lblBedrijfnaam" runat="server" Text="Bedrijfsnaam" Visible="false"></asp:Label>
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtBedrijfnaam" runat="server" Visible="false"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="right">
                                                            <asp:Label ID="lblLocatie" runat="server" Text="Vestigingslocatie" Visible="false"></asp:Label>
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtLocatie" runat="server" Visible="false"></asp:TextBox>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="right">
                                                            <asp:Label ID="lblBTW" runat="server" Text="BTW-nummer" Visible="false"></asp:Label>
                                                        </td>
                                                        <td>
                                                            <asp:TextBox ID="txtBTW" runat="server" Visible="false"></asp:TextBox>
                                                            <cc1:MaskedEditExtender ID="MaskedEditExtender1" runat="server"  ClearMaskOnLostFocus="false" TargetControlID="txtBTW" Mask="999\-999\-999">
        </cc1:MaskedEditExtender>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="center" colspan="2">
                                                            <asp:CompareValidator ID="PasswordCompare" runat="server" ControlToCompare="Password"
                                                                ControlToValidate="ConfirmPassword" Display="Dynamic" ErrorMessage="The Password and Confirmation Password must match."
                                                                ValidationGroup="CreateUserWizard1"></asp:CompareValidator>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="center" colspan="2" style="color: Red;">
                                                            <asp:Literal ID="ErrorMessage" runat="server" EnableViewState="False"></asp:Literal>
                                                        </td>
                                                    </tr>
                                                    </table>
                                                </ContentTemplate>
                                            </asp:UpdatePanel>
                                    </ContentTemplate>
                                </asp:CreateUserWizardStep>
                                <asp:CompleteWizardStep runat="server">
                                    <ContentTemplate>
                                        <table border="0">
                                            <tr>
                                                <td align="center" colspan="2">
                                                    Voltooid
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    Uw account werd aangemaakt.
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right" colspan="2">
                                                    <asp:Button ID="ContinueButton" runat="server" CausesValidation="False" CommandName="Continue"
                                                        Text="Doorgaan" ValidationGroup="CreateUserWizard1" OnClick="ContinueButton_Click" />
                                                </td>
                                            </tr>
                                        </table>
                                    </ContentTemplate>
                                </asp:CompleteWizardStep>
                            </WizardSteps>
                        </asp:CreateUserWizard>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </td>
        </tr>
    </table>
</asp:Content>
