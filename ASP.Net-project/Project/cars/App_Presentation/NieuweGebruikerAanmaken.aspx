<%@ Page Language="VB" AutoEventWireup="false" CodeFile="NieuweGebruikerAanmaken.aspx.vb" Inherits="App_Presentation_NieuweGebruikerAanmaken" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>

    <form id="frmNieuweGebruiker" runat="server">
    <div>
    
    <asp:FormView ID="frvNieuweGebruiker" runat="server" DataKeyNames="klantID" 
        DataSourceID="sdsDatabase" DefaultMode="Insert" style="margin-top: 0px" 
            Height="280px" Width="428px">
        <InsertItemTemplate>
            Gebruikersnaam:
            <asp:TextBox ID="txtGebruikersnaam" runat="server" 
                Text='<%# Bind("klantGebruikersnaam") %>' />
            <asp:RequiredFieldValidator ID="valGebruikersnaam" runat="server" 
                ErrorMessage="U dient een gebruikersnaam op te geven." 
                ControlToValidate="txtGebruikersnaam"><img src="Images/remove.gif" /></asp:RequiredFieldValidator>
            <br />
            Paswoord:
            <asp:TextBox ID="txtPaswoord" runat="server" 
                Text='<%# Bind("klantPaswoord") %>' TextMode="Password"  />
            <asp:CompareValidator ID="valPaswoord" runat="server" 
                ControlToCompare="txtPaswoordOpnieuw" ControlToValidate="txtPaswoord" 
                ErrorMessage="De paswoorden komen niet met elkaar overeen."><img src="Images/remove.gif" /></asp:CompareValidator>
            <br />
            <asp:Label ID="lblPaswoordOpnieuw" runat="server" 
                Text="Geef paswoord opnieuw in:"></asp:Label>
            <asp:TextBox ID="txtPaswoordOpnieuw" runat="server" TextMode="Password" ></asp:TextBox>
            <br />
            Naam:
            <asp:TextBox ID="txtNaam" runat="server" 
                Text='<%# Bind("klantNaam") %>' />
            <asp:RequiredFieldValidator ID="valNaam" runat="server" 
                ControlToValidate="txtNaam" ErrorMessage="U dient een naam op te geven."><img src="Images/remove.gif" /></asp:RequiredFieldValidator>
            <br />
            Voornaam:
            <asp:TextBox ID="txtVoornaam" runat="server" 
                Text='<%# Bind("klantVoornaam") %>' />
            <asp:RequiredFieldValidator ID="valVoornaam" runat="server" 
                ControlToValidate="txtVoornaam" 
                ErrorMessage="U dient een voornaam op te geven."><img src="Images/remove.gif" /></asp:RequiredFieldValidator>
            <br />
            Geboortedatum:
            <asp:TextBox ID="txtGebdat" runat="server" 
                Text='<%# Bind("klantGebdat") %>' />
            <asp:RegularExpressionValidator ID="valGeboorteDatum" runat="server" 
                ControlToValidate="txtGebdat" 
                ErrorMessage="U dient een geldige datum op te geven." 
                ValidationExpression="(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d"><img src="Images/remove.gif" /></asp:RegularExpressionValidator>
            <br />
            Identiteitskaartnummer:
            <asp:TextBox ID="txtIdKaartNummer" runat="server" 
                Text='<%# Bind("klantIdKaartNummer") %>' />
            <asp:RegularExpressionValidator ID="valIdentiteitskaartNR" runat="server" 
                ControlToValidate="txtIdKaartNummer" 
                ErrorMessage="U dient een geldig identiteitskaartnummer op te geven." 
                ValidationExpression="\d{3}-\d{7}-\d{2}"><img src="Images/remove.gif" /></asp:RegularExpressionValidator>
            <br />
            Rijbewijsnummer:
            <asp:TextBox ID="txtRijbewijs" runat="server" 
                Text='<%# Bind("klantRijbewijs") %>' />
            <asp:RequiredFieldValidator ID="valRijbewijsnummer" runat="server" 
                ControlToValidate="txtRijbewijs" 
                ErrorMessage="U dient een geldig rijbewijsnummer op te geven."><img src="Images/remove.gif" /></asp:RequiredFieldValidator>
            <br />
            Telefoon:
            <asp:TextBox ID="txtTelefoon" runat="server" 
                Text='<%# Bind("klantTelefoon") %>' />
            <asp:RequiredFieldValidator ID="valTelefoon" runat="server" 
                ErrorMessage="U dient een geldig telefoonnummer op te geven." 
                ControlToValidate="txtTelefoon"><img src="Images/remove.gif" /></asp:RequiredFieldValidator>
            <br />
            E-mail adres:
            <asp:TextBox ID="txtEmail" runat="server" 
                Text='<%# Bind("klantEmail") %>' />
            <asp:RegularExpressionValidator ID="valEmail" runat="server" 
                ControlToValidate="txtEmail" 
                ErrorMessage="U dient een geldig E-mail adres op te geven." 
                ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"><img src="Images/remove.gif" /></asp:RegularExpressionValidator>
            <br />
            BTW-nummer:
            <asp:TextBox ID="txtBTWnummer" runat="server" 
                Text='<%# Bind("klantBTWnummer") %>' />
            <br />
            <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" 
                CommandName="Insert" Text="Maak gebruiker aan"  />
            &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" 
                CausesValidation="False" CommandName="Cancel" Text="Annuleer" />
        </InsertItemTemplate>
        <ItemTemplate>
            Gebruikersnaam:
            <asp:TextBox ID="txtGebruikersnaam" runat="server" 
                Text='<%# Bind("klantGebruikersnaam") %>'  />
            <br />
            Paswoord:
            <asp:TextBox ID="txtPaswoord" runat="server" 
                Text='<%# Bind("klantPaswoord") %>' />
            <br />
            Naam:
            <asp:TextBox ID="txtNaam" runat="server" 
                Text='<%# Bind("klantNaam") %>' />
            <br />
            Voornaam:
            <asp:TextBox ID="txtVoornaam" runat="server" 
                Text='<%# Bind("klantVoornaam") %>' />
            <br />
            Geboortedatum:
            <asp:TextBox ID="txtGebdat" runat="server" 
                Text='<%# Bind("klantGebdat", "{0:d}") %>' />
            <br />
            Identiteitskaartnummer:
            <asp:TextBox ID="txtIdKaartNummer" runat="server" 
                Text='<%# Bind("klantIdKaartNummer") %>' />
            <br />
            Rijbewijsnummer:
            <asp:TextBox ID="txtRijbewijs" runat="server" 
                Text='<%# Bind("klantRijbewijs") %>' />
            <br />
            Telefoon:
            <asp:TextBox ID="txtTelefoon" runat="server" 
                Text='<%# Bind("klantTelefoon") %>' />
            <br />
            E-mail adres:
            <asp:TextBox ID="txtEmail" runat="server" 
                Text='<%# Bind("klantEmail") %>' />
            <br />
            BTW-nummer:
            <asp:TextBox ID="txtBTWnummerTextBox" runat="server" 
                Text='<%# Bind("klantBTWnummer") %>' />
            <br />
        </ItemTemplate>
    </asp:FormView>
    
        <asp:ValidationSummary ID="vlsFoutenOverzicht" runat="server" />
        <br />
    
    </div>
    
        <asp:SqlDataSource ID="sdsDatabase" runat="server" 
            ConnectionString="<%$ ConnectionStrings:ConnectToDatabase %>" 
            OldValuesParameterFormatString="original_{0}" 
            
            
            SelectCommand="SELECT [klantGebruikersnaam], [klantPaswoord], [klantRijbewijs], [klantTelefoon], [klantEmail], [klantBTWnummer], [klantNaam], [klantVoornaam], [klantGebdat], [klantIdKaartNummer], [klantID] FROM [tblKlant]" 
            ConflictDetection="CompareAllValues" 
            DeleteCommand="DELETE FROM [tblKlant] WHERE [klantID] = @original_klantID AND [klantGebruikersnaam] = @original_klantGebruikersnaam AND [klantPaswoord] = @original_klantPaswoord AND [klantRijbewijs] = @original_klantRijbewijs AND [klantTelefoon] = @original_klantTelefoon AND [klantEmail] = @original_klantEmail AND [klantBTWnummer] = @original_klantBTWnummer AND [klantNaam] = @original_klantNaam AND [klantVoornaam] = @original_klantVoornaam AND [klantGebdat] = @original_klantGebdat AND [klantIdKaartNummer] = @original_klantIdKaartNummer" 
            InsertCommand="INSERT INTO [tblKlant] ([klantGebruikersnaam], [klantPaswoord], [klantRijbewijs], [klantTelefoon], [klantEmail], [klantBTWnummer], [klantNaam], [klantVoornaam], [klantGebdat], [klantIdKaartNummer]) VALUES (@klantGebruikersnaam, @klantPaswoord, @klantRijbewijs, @klantTelefoon, @klantEmail, @klantBTWnummer, @klantNaam, @klantVoornaam, @klantGebdat, @klantIdKaartNummer)" 
            UpdateCommand="UPDATE [tblKlant] SET [klantGebruikersnaam] = @klantGebruikersnaam, [klantPaswoord] = @klantPaswoord, [klantRijbewijs] = @klantRijbewijs, [klantTelefoon] = @klantTelefoon, [klantEmail] = @klantEmail, [klantBTWnummer] = @klantBTWnummer, [klantNaam] = @klantNaam, [klantVoornaam] = @klantVoornaam, [klantGebdat] = @klantGebdat, [klantIdKaartNummer] = @klantIdKaartNummer WHERE [klantID] = @original_klantID AND [klantGebruikersnaam] = @original_klantGebruikersnaam AND [klantPaswoord] = @original_klantPaswoord AND [klantRijbewijs] = @original_klantRijbewijs AND [klantTelefoon] = @original_klantTelefoon AND [klantEmail] = @original_klantEmail AND [klantBTWnummer] = @original_klantBTWnummer AND [klantNaam] = @original_klantNaam AND [klantVoornaam] = @original_klantVoornaam AND [klantGebdat] = @original_klantGebdat AND [klantIdKaartNummer] = @original_klantIdKaartNummer">
            <DeleteParameters>
                <asp:Parameter Name="original_klantID" Type="Int32" />
                <asp:Parameter Name="original_klantGebruikersnaam" Type="String" />
                <asp:Parameter Name="original_klantPaswoord" Type="String" />
                <asp:Parameter Name="original_klantRijbewijs" Type="String" />
                <asp:Parameter Name="original_klantTelefoon" Type="String" />
                <asp:Parameter Name="original_klantEmail" Type="String" />
                <asp:Parameter Name="original_klantBTWnummer" Type="String" />
                <asp:Parameter Name="original_klantNaam" Type="String" />
                <asp:Parameter Name="original_klantVoornaam" Type="String" />
                <asp:Parameter DbType="DateTime" Name="original_klantGebdat" />
                <asp:Parameter Name="original_klantIdKaartNummer" Type="String" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="klantGebruikersnaam" Type="String" />
                <asp:Parameter Name="klantPaswoord" Type="String" />
                <asp:Parameter Name="klantRijbewijs" Type="String" />
                <asp:Parameter Name="klantTelefoon" Type="String" />
                <asp:Parameter Name="klantEmail" Type="String" />
                <asp:Parameter Name="klantBTWnummer" Type="String" />
                <asp:Parameter Name="klantNaam" Type="String" />
                <asp:Parameter Name="klantVoornaam" Type="String" />
                <asp:Parameter DbType="DateTime" Name="klantGebdat" />
                <asp:Parameter Name="klantIdKaartNummer" Type="String" />
                <asp:Parameter Name="original_klantID" Type="Int32" />
                <asp:Parameter Name="original_klantGebruikersnaam" Type="String" />
                <asp:Parameter Name="original_klantPaswoord" Type="String" />
                <asp:Parameter Name="original_klantRijbewijs" Type="String" />
                <asp:Parameter Name="original_klantTelefoon" Type="String" />
                <asp:Parameter Name="original_klantEmail" Type="String" />
                <asp:Parameter Name="original_klantBTWnummer" Type="String" />
                <asp:Parameter Name="original_klantNaam" Type="String" />
                <asp:Parameter Name="original_klantVoornaam" Type="String" />
                <asp:Parameter DbType="DateTime" Name="original_klantGebdat" />
                <asp:Parameter Name="original_klantIdKaartNummer" Type="String" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="klantGebruikersnaam" Type="String" />
                <asp:Parameter Name="klantPaswoord" Type="String" />
                <asp:Parameter Name="klantRijbewijs" Type="String" />
                <asp:Parameter Name="klantTelefoon" Type="String" />
                <asp:Parameter Name="klantEmail" Type="String" />
                <asp:Parameter Name="klantBTWnummer" Type="String" />
                <asp:Parameter Name="klantNaam" Type="String" />
                <asp:Parameter Name="klantVoornaam" Type="String" />
                <asp:Parameter DbType="DateTime" Name="klantGebdat" />
                <asp:Parameter Name="klantIdKaartNummer" Type="String" />
            </InsertParameters>
        </asp:SqlDataSource>
    
    </form>
</body>
</html>