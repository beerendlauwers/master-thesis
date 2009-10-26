<%@ Page Language="VB" AutoEventWireup="false" CodeFile="NieuweAutoAanmaken.aspx.vb" EnableEventValidation="false" Inherits="App_Presentation_NieuweAutoAanmaken" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="frmNieuweAuto" runat="server">
    <asp:ScriptManager ID="scmManager" runat="server"></asp:ScriptManager>
    <div>
    
        <asp:FormView ID="frvNieuweAuto" runat="server" DataKeyNames="autoID" 
            DataSourceID="sqsDatabase" DefaultMode="Insert" Width="670px">
            <EditItemTemplate>
                autoID:
                <asp:Label ID="autoIDLabel1" runat="server" Text='<%# Eval("autoID") %>' />
                <br />
                autoCategorie:
                <asp:TextBox ID="autoCategorieTextBox" runat="server" 
                    Text='<%# Bind("autoCategorie") %>' />
                <br />
                modelID:
                <asp:TextBox ID="modelIDTextBox" runat="server" Text='<%# Bind("modelID") %>' />
                <br />
                autoKleur:
                <asp:TextBox ID="autoKleurTextBox" runat="server" 
                    Text='<%# Bind("autoKleur") %>' />
                <br />
                autoBouwjaar:
                <asp:TextBox ID="autoBouwjaarTextBox" runat="server" 
                    Text='<%# Bind("autoBouwjaar") %>' />
                <br />
                brandstofID:
                <asp:TextBox ID="brandstofIDTextBox" runat="server" 
                    Text='<%# Bind("brandstofID") %>' />
                <br />
                autoKenteken:
                <asp:TextBox ID="autoKentekenTextBox" runat="server" 
                    Text='<%# Bind("autoKenteken") %>' />
                <br />
                statusID:
                <asp:TextBox ID="statusIDTextBox" runat="server" 
                    Text='<%# Bind("statusID") %>' />
                <br />
                autoParkeerplaats:
                <asp:TextBox ID="autoParkeerplaatsTextBox" runat="server" 
                    Text='<%# Bind("autoParkeerplaats") %>' />
                <br />
                filiaalID:
                <asp:TextBox ID="filiaalIDTextBox" runat="server" 
                    Text='<%# Bind("filiaalID") %>' />
                <br />
                autoDagTarief:
                <asp:TextBox ID="autoDagTariefTextBox" runat="server" 
                    Text='<%# Bind("autoDagTarief") %>' />
                <br />
                <asp:LinkButton ID="UpdateButton" runat="server" CausesValidation="True" 
                    CommandName="Update" Text="Update" />
                &nbsp;<asp:LinkButton ID="UpdateCancelButton" runat="server" 
                    CausesValidation="False" CommandName="Cancel" Text="Cancel" />
            </EditItemTemplate>
            <InsertItemTemplate>
                Categorie:
                <asp:DropDownList ID="ddlCategorie" runat="server" 
                    SelectedValue='<%# Bind("autoCategorie") %>'>
                    <asp:ListItem>Klein/Middelmaat</asp:ListItem>
                    <asp:ListItem>Groot</asp:ListItem>
                    <asp:ListItem>Luxe</asp:ListItem>
                </asp:DropDownList>
                <br />
                Model:
                <asp:UpdatePanel ID="updMerkModel" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                     <asp:DropDownList ID="ddlMerk" runat="server"></asp:DropDownList>
                     <asp:DropDownList ID="ddlModel" runat="server"
                     DataTextField="modelNaam" DataValueField="modelID" SelectedValue='<%# Bind("modelID") %>' ></asp:DropDownList>
                    
                     <ajaxToolkit:CascadingDropDown ID="cddMerk" runat="server" Category="Merk" 
                            PromptText="Selecteer een merk" ServiceMethod="GeefMerken" 
                            TargetControlID="ddlMerk" ServicePath="WebServices/AutoService.asmx"></ajaxToolkit:CascadingDropDown>
                     <ajaxToolkit:CascadingDropDown ID="cddModel" runat="server" Category="Model" 
                            PromptText="Selecteer een model" ParentControlID="ddlMerk" 
                            ServiceMethod="GeefModellenVoorMerk" TargetControlID="ddlModel" 
                            ServicePath="WebServices/AutoService.asmx"></ajaxToolkit:CascadingDropDown>
                    </ContentTemplate>
                </asp:UpdatePanel>
                Kleur:
                <asp:TextBox ID="autoKleurTextBox" runat="server" 
                    Text='<%# Bind("autoKleur") %>' />
                <br />
                Bouwjaar:
                <asp:TextBox ID="autoBouwjaarTextBox" runat="server" 
                    Text='<%# Bind("autoBouwjaar") %>' />
                <br />
                Type brandstof:
                <asp:DropDownList ID="ddlBrandstofType" runat="server" 
                    DataSourceID="odsBrandstofType" DataTextField="brandstofNaam" 
                    DataValueField="brandstofID" SelectedValue='<%# Bind("brandstofID") %>'>
                </asp:DropDownList>
                <br />
                Kenteken:
                <asp:TextBox ID="autoKentekenTextBox" runat="server" 
                    Text='<%# Bind("autoKenteken") %>' />
                <br />
                Status
                <asp:DropDownList ID="ddlStatus" runat="server" DataSourceID="odsAutoStatus" 
                    DataTextField="autostatusNaam" DataValueField="autostatusID"
                    SelectedValue='<%# Bind("statusID") %>'>
                </asp:DropDownList>
                <br />
                Parkeerplaats:
                <asp:TextBox ID="autoParkeerplaatsTextBox" runat="server" 
                    Text='<%# Bind("autoParkeerplaats") %>' />
                <br />
                Filiaal:
                <asp:DropDownList ID="ddlFiliaal" runat="server" DataSourceID="odsFiliaal" 
                    DataTextField="filiaalNaam" DataValueField="filiaalID" 
                    SelectedValue='<%# Bind("filiaalID") %>'>
                </asp:DropDownList>
                <br />
                Dagtarief:&nbsp;<asp:TextBox ID="autoDagTariefTextBox" runat="server" 
                    Text='<%# Bind("autoDagTarief") %>' />
                <br />
                Foto:&nbsp;<asp:FileUpload ID="fupAutoFoto" runat="server" />
                <br />
                <asp:LinkButton ID="InsertButton" runat="server" CausesValidation="True" 
                    CommandName="Insert" Text="Insert"/>
                &nbsp;<asp:LinkButton ID="InsertCancelButton" runat="server" 
                    CausesValidation="False" CommandName="Cancel" Text="Cancel" />
            </InsertItemTemplate>
            <ItemTemplate>
                autoID:
                <asp:Label ID="autoIDLabel" runat="server" Text='<%# Eval("autoID") %>' />
                <br />
                autoCategorie:
                <asp:Label ID="autoCategorieLabel" runat="server" 
                    Text='<%# Bind("autoCategorie") %>' />
                <br />
                modelID:
                <asp:Label ID="modelIDLabel" runat="server" Text='<%# Bind("modelID") %>' />
                <br />
                autoKleur:
                <asp:Label ID="autoKleurLabel" runat="server" Text='<%# Bind("autoKleur") %>' />
                <br />
                autoBouwjaar:
                <asp:Label ID="autoBouwjaarLabel" runat="server" 
                    Text='<%# Bind("autoBouwjaar") %>' />
                <br />
                brandstofID:
                <asp:Label ID="brandstofIDLabel" runat="server" 
                    Text='<%# Bind("brandstofID") %>' />
                <br />
                autoKenteken:
                <asp:Label ID="autoKentekenLabel" runat="server" 
                    Text='<%# Bind("autoKenteken") %>' />
                <br />
                statusID:
                <asp:Label ID="statusIDLabel" runat="server" Text='<%# Bind("statusID") %>' />
                <br />
                autoParkeerplaats:
                <asp:Label ID="autoParkeerplaatsLabel" runat="server" 
                    Text='<%# Bind("autoParkeerplaats") %>' />
                <br />
                filiaalID:
                <asp:Label ID="filiaalIDLabel" runat="server" Text='<%# Bind("filiaalID") %>' />
                <br />
                autoDagTarief:
                <asp:Label ID="autoDagTariefLabel" runat="server" 
                    Text='<%# Bind("autoDagTarief") %>' />
                <br />
                <asp:LinkButton ID="EditButton" runat="server" CausesValidation="False" 
                    CommandName="Edit" Text="Edit" />
                &nbsp;<asp:LinkButton ID="DeleteButton" runat="server" CausesValidation="False" 
                    CommandName="Delete" Text="Delete" />
                &nbsp;<asp:LinkButton ID="NewButton" runat="server" CausesValidation="False" 
                    CommandName="New" Text="New" />
            </ItemTemplate>
        </asp:FormView>
    
    </div>
    <asp:SqlDataSource ID="sqsDatabase" runat="server" 
        ConflictDetection="CompareAllValues" 
        ConnectionString="<%$ ConnectionStrings:ConnectToDatabase %>" 
        DeleteCommand="DELETE FROM tblAuto WHERE (autoID = @original_autoID) AND (autoCategorie = @original_autoCategorie) AND (modelID = @original_modelID) AND (autoKleur = @original_autoKleur) AND (autoBouwjaar = @original_autoBouwjaar) AND (brandstofID = @original_brandstofID) AND (autoKenteken = @original_autoKenteken) AND (statusID = @original_statusID) AND (autoParkeerplaats = @original_autoParkeerplaats) AND (filiaalID = @original_filiaalID) AND (autoDagTarief = @original_autoDagTarief)" 
        InsertCommand="INSERT INTO tblAuto(autoCategorie, modelID, autoKleur, autoBouwjaar, brandstofID, autoKenteken, statusID, autoParkeerplaats, filiaalID, autoDagTarief, autoFoto, autoKMTotOlieVerversing) VALUES (@autoCategorie, @modelID, @autoKleur, @autoBouwjaar, @brandstofID, @autoKenteken, @statusID, @autoParkeerplaats, @filiaalID, @autoDagTarief, @autoFoto, @autoKMTotOlieVerversing)" 
        OldValuesParameterFormatString="original_{0}" 
        SelectCommand="SELECT autoID, autoCategorie, modelID, autoKleur, autoBouwjaar, brandstofID, autoKenteken, statusID, autoParkeerplaats, filiaalID, autoDagTarief, autoFoto, autoKMTotOlieVerversing FROM tblAuto" 
        
        
        UpdateCommand="UPDATE tblAuto SET autoCategorie = @autoCategorie, modelID = @modelID, autoKleur = @autoKleur, autoBouwjaar = @autoBouwjaar, brandstofID = @brandstofID, autoKenteken = @autoKenteken, statusID = @statusID, autoParkeerplaats = @autoParkeerplaats, filiaalID = @filiaalID, autoDagTarief = @autoDagTarief, autoFoto = @autoFoto, autoKMTotOlieVerversing = @autoKMTotOlieVerversing = WHERE (autoID = @original_autoID) AND (autoCategorie = @original_autoCategorie) AND (modelID = @original_modelID) AND (autoKleur = @original_autoKleur) AND (autoBouwjaar = @original_autoBouwjaar) AND (brandstofID = @original_brandstofID) AND (autoKenteken = @original_autoKenteken) AND (statusID = @original_statusID) AND (autoParkeerplaats = @original_autoParkeerplaats) AND (filiaalID = @original_filiaalID) AND (autoDagTarief = @original_autoDagTarief)">
        <DeleteParameters>
            <asp:Parameter Name="original_autoID" Type="Int32" />
            <asp:Parameter Name="original_autoCategorie" Type="String" />
            <asp:Parameter Name="original_modelID" Type="Int32" />
            <asp:Parameter Name="original_autoKleur" Type="String" />
            <asp:Parameter Name="original_autoBouwjaar" Type="Int32" />
            <asp:Parameter Name="original_brandstofID" Type="Int32" />
            <asp:Parameter Name="original_autoKenteken" Type="String" />
            <asp:Parameter Name="original_statusID" Type="Int32" />
            <asp:Parameter Name="original_autoParkeerplaats" Type="String" />
            <asp:Parameter Name="original_filiaalID" Type="Int32" />
            <asp:Parameter Name="original_autoDagTarief" Type="Double" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="autoCategorie" Type="String" />
            <asp:Parameter Name="modelID" Type="Int32" />
            <asp:Parameter Name="autoKleur" Type="String" />
            <asp:Parameter Name="autoBouwjaar" Type="Int32" />
            <asp:Parameter Name="brandstofID" Type="Int32" />
            <asp:Parameter Name="autoKenteken" Type="String" />
            <asp:Parameter Name="statusID" Type="Int32" />
            <asp:Parameter Name="autoParkeerplaats" Type="String" />
            <asp:Parameter Name="filiaalID" Type="Int32" />
            <asp:Parameter Name="autoDagTarief" Type="Double" />
            <asp:Parameter Name="original_autoID" Type="Int32" />
            <asp:Parameter Name="original_autoCategorie" Type="String" />
            <asp:Parameter Name="original_modelID" Type="Int32" />
            <asp:Parameter Name="original_autoKleur" Type="String" />
            <asp:Parameter Name="original_autoBouwjaar" Type="Int32" />
            <asp:Parameter Name="original_brandstofID" Type="Int32" />
            <asp:Parameter Name="original_autoKenteken" Type="String" />
            <asp:Parameter Name="original_statusID" Type="Int32" />
            <asp:Parameter Name="original_autoParkeerplaats" Type="String" />
            <asp:Parameter Name="original_filiaalID" Type="Int32" />
            <asp:Parameter Name="original_autoDagTarief" Type="Double" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="autoCategorie" Type="String" />
            <asp:Parameter Name="modelID" Type="Int32" />
            <asp:Parameter Name="autoKleur" Type="String" />
            <asp:Parameter Name="autoBouwjaar" Type="Int32" />
            <asp:Parameter Name="brandstofID" Type="Int32" />
            <asp:Parameter Name="autoKenteken" Type="String" />
            <asp:Parameter Name="statusID" Type="Int32" />
            <asp:Parameter Name="autoParkeerplaats" Type="String" />
            <asp:Parameter Name="filiaalID" Type="Int32" />
            <asp:Parameter Name="autoDagTarief" Type="Double" />
        </InsertParameters>
    </asp:SqlDataSource>
    <asp:ObjectDataSource ID="odsBrandstofType" runat="server" 
        DeleteMethod="Delete" InsertMethod="Insert" 
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" 
        TypeName="Auto_sTableAdapters.tblBrandstofTableAdapter" UpdateMethod="Update">
        <DeleteParameters>
            <asp:Parameter Name="Original_brandstofID" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="brandstofNaam" Type="String" />
            <asp:Parameter Name="Original_brandstofID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="brandstofNaam" Type="String" />
        </InsertParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsAutoStatus" runat="server" 
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetAutostatusBijAanmaken" 
        TypeName="Auto_sTableAdapters.tblAutostatusTableAdapter" 
        DeleteMethod="Delete" InsertMethod="Insert" UpdateMethod="Update">
        <DeleteParameters>
            <asp:Parameter Name="Original_autostatusID" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="autostatusNaam" Type="String" />
            <asp:Parameter Name="autostatusToewijsbaarBijMaken" Type="Boolean" />
            <asp:Parameter Name="Original_autostatusID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="autostatusNaam" Type="String" />
            <asp:Parameter Name="autostatusToewijsbaarBijMaken" Type="Boolean" />
        </InsertParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsFiliaal" runat="server" DeleteMethod="Delete" 
        InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetData" TypeName="Auto_sTableAdapters.tblFiliaalTableAdapter" 
        UpdateMethod="Update">
        <DeleteParameters>
            <asp:Parameter Name="Original_filiaalID" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="filiaalLocatie" Type="String" />
            <asp:Parameter Name="filiaalNaam" Type="Object" />
            <asp:Parameter Name="Original_filiaalID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="filiaalLocatie" Type="String" />
            <asp:Parameter Name="filiaalNaam" Type="Object" />
        </InsertParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsOptie" runat="server" DeleteMethod="Delete" 
        InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetData" TypeName="Auto_sTableAdapters.tblOptieTableAdapter" 
        UpdateMethod="Update">
        <DeleteParameters>
            <asp:Parameter Name="Original_optieID" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="optieOmschrijving" Type="String" />
            <asp:Parameter Name="optieKost" Type="Double" />
            <asp:Parameter Name="Original_optieID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="optieOmschrijving" Type="String" />
            <asp:Parameter Name="optieKost" Type="Double" />
        </InsertParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsModel" runat="server" DeleteMethod="Delete" 
        InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetData" TypeName="Auto_sTableAdapters.tblModelTableAdapter" 
        UpdateMethod="Update">
        <DeleteParameters>
            <asp:Parameter Name="Original_modelID" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="merkID" Type="Int32" />
            <asp:Parameter Name="modelNaam" Type="String" />
            <asp:Parameter Name="Original_modelID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="merkID" Type="Int32" />
            <asp:Parameter Name="modelNaam" Type="String" />
        </InsertParameters>
    </asp:ObjectDataSource>
    <br />
    </form>
</body>
</html>
