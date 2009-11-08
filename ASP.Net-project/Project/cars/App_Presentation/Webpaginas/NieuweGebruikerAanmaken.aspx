<%@ Page Language="VB" AutoEventWireup="false" CodeFile="NieuweGebruikerAanmaken.aspx.vb" Inherits="App_Presentation_NieuweGebruikerAanmaken" MasterPageFile="~/App_Presentation/MasterPage.master" %>

<asp:Content ID="Main" ContentPlaceHolderID="plcMain" runat="server">
    <form id="frmNieuweGebruiker" runat="server">
    <div>
    
    <asp:FormView ID="frvNieuweGebruiker" runat="server" DataKeyNames="klantID" 
        DataSourceID="odsKlanten" DefaultMode="Insert" style="margin-top: 0px" 
            Height="280px" Width="428px">
        <InsertItemTemplate>
            Gebruikersnaam:
            <asp:TextBox ID="txtGebruikersnaam" runat="server" 
                Text='<%# Bind("klantGebruikersnaam") %>' />
            <asp:RequiredFieldValidator ID="valGebruikersnaam" runat="server" 
                ControlToValidate="txtGebruikersnaam" 
                ErrorMessage="U dient een gebruikersnaam op te geven.">
                <img src="../Images/remove.gif" alt='remove' /></asp:RequiredFieldValidator>
            <br />
            Paswoord:
            <asp:TextBox ID="txtPaswoord" runat="server" 
                Text='<%# Bind("klantPaswoord") %>' TextMode="Password" />
            <asp:CompareValidator ID="valPaswoord" runat="server" 
                ControlToCompare="txtPaswoordOpnieuw" ControlToValidate="txtPaswoord" 
                ErrorMessage="De paswoorden komen niet met elkaar overeen."><img 
                src="../Images/remove.gif" alt='remove'/></asp:CompareValidator>
            <br />
            <asp:Label ID="lblPaswoordOpnieuw" runat="server" 
                Text="Geef paswoord opnieuw in:"></asp:Label>
            <asp:TextBox ID="txtPaswoordOpnieuw" runat="server" TextMode="Password"></asp:TextBox>
            <br />
            Naam:
            <asp:TextBox ID="txtNaam" runat="server" Text='<%# Bind("klantNaam") %>' />
            <asp:RequiredFieldValidator ID="valNaam" runat="server" 
                ControlToValidate="txtNaam" ErrorMessage="U dient een naam op te geven."><img 
                src="../Images/remove.gif" alt='remove' /></asp:RequiredFieldValidator>
            <br />
            Voornaam:
            <asp:TextBox ID="txtVoornaam" runat="server" 
                Text='<%# Bind("klantVoornaam") %>' />
            <asp:RequiredFieldValidator ID="valVoornaam" runat="server" 
                ControlToValidate="txtVoornaam" 
                ErrorMessage="U dient een voornaam op te geven."><img 
                src="../Images/remove.gif" alt='remove'/></asp:RequiredFieldValidator>
            <br />
            Geboortedatum:
            <asp:TextBox ID="txtGebdat" runat="server" Text='<%# Bind("klantGebdat") %>' />
            <asp:RegularExpressionValidator ID="valGeboorteDatum" runat="server" 
                ControlToValidate="txtGebdat" 
                ErrorMessage="U dient een geldige datum op te geven." 
                ValidationExpression="(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d"><img 
                src="../Images/remove.gif" /></asp:RegularExpressionValidator>
            <br />
            Identiteitskaartnummer:
            <asp:TextBox ID="txtIdKaartNummer" runat="server" 
                Text='<%# Bind("klantIdKaartNummer") %>' />
            <asp:RegularExpressionValidator ID="valIdentiteitskaartNR" runat="server" 
                ControlToValidate="txtIdKaartNummer" 
                ErrorMessage="U dient een geldig identiteitskaartnummer op te geven." 
                ValidationExpression="\d{3}-\d{7}-\d{2}"><img src="../Images/remove.gif" alt='remove'/></asp:RegularExpressionValidator>
            <br />
            Rijbewijsnummer:
            <asp:TextBox ID="txtRijbewijs" runat="server" 
                Text='<%# Bind("klantRijbewijs") %>' />
            <asp:RequiredFieldValidator ID="valRijbewijsnummer" runat="server" 
                ControlToValidate="txtRijbewijs" 
                ErrorMessage="U dient een geldig rijbewijsnummer op te geven."><img 
                src="../Images/remove.gif" /></asp:RequiredFieldValidator>
            <br />
            Telefoon:
            <asp:TextBox ID="txtTelefoon" runat="server" 
                Text='<%# Bind("klantTelefoon") %>' />
            <asp:RequiredFieldValidator ID="valTelefoon" runat="server" 
                ControlToValidate="txtTelefoon" 
                ErrorMessage="U dient een geldig telefoonnummer op te geven."><img 
                src="../Images/remove.gif" /></asp:RequiredFieldValidator>
            <br />
            E-mail adres:
            <asp:TextBox ID="txtEmail" runat="server" Text='<%# Bind("klantEmail") %>' />
            <asp:RegularExpressionValidator ID="valEmail" runat="server" 
                ControlToValidate="txtEmail" 
                ErrorMessage="U dient een geldig E-mail adres op te geven." 
                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"><img 
                src="../Images/remove.gif" /></asp:RegularExpressionValidator>
            <br />
            BTW-nummer:
            <asp:TextBox ID="txtBTWnummer" runat="server" 
                Text='<%# Bind("klantBTWnummer") %>' />
            <br />
            <asp:LinkButton ID="InsertButton0" runat="server" CausesValidation="True" 
                CommandName="Insert" Text="Maak gebruiker aan" />
            &nbsp;<asp:LinkButton ID="InsertCancelButton0" runat="server" 
                CausesValidation="False" CommandName="Cancel" Text="Annuleer" />
        </InsertItemTemplate>
    </asp:FormView>
    
        <asp:ValidationSummary ID="vlsFoutenOverzicht" runat="server" />
    
    </div>
    
        <asp:ObjectDataSource ID="odsKlanten" runat="server" 
        DataObjectTypeName="Klant&amp;" DeleteMethod="DeleteKlant" 
        InsertMethod="AddKlant" SelectMethod="GetAllKlanten" TypeName="KlantBLL">
            <DeleteParameters>
                <asp:Parameter Name="klantID" Type="Int32" />
            </DeleteParameters>
    </asp:ObjectDataSource>
    
    </form>
</asp:Content>