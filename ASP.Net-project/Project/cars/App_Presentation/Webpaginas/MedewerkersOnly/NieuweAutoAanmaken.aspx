<%@ Page Language="VB" AutoEventWireup="false" CodeFile="NieuweAutoAanmaken.aspx.vb" EnableEventValidation="false" Inherits="App_Presentation_NieuweAutoAanmaken" MasterPageFile="~/App_Presentation/MasterPage.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="ajaxToolkit" %>

<asp:Content ID="Main" ContentPlaceHolderID="plcMain" runat="server">
    <asp:ScriptManager ID="scmManager" runat="server"></asp:ScriptManager>
    <div>
    
        <asp:FormView ID="frvNieuweAuto" runat="server" DataKeyNames="autoID" 
            DataSourceID="odsAuto" DefaultMode="Insert" Width="670px">
            <EditItemTemplate>
                autoID:
                <asp:Label ID="lblAutoID" runat="server" Text='<%# Eval("autoID") %>' />
                <br />
                autoCategorie:
                <asp:TextBox ID="txtAutoCategorie" runat="server" 
                    Text='<%# Bind("autoCategorie") %>' />
                <br />
                modelID:
                <asp:TextBox ID="txtModelID" runat="server" Text='<%# Bind("modelID") %>' />
                <br />
                autoKleur:
                <asp:TextBox ID="txtAutoKleur" runat="server" 
                    Text='<%# Bind("autoKleur") %>' />
                <br />
                autoBouwjaar:
                <asp:TextBox ID="txtAutoBouwjaar" runat="server" 
                    Text='<%# Bind("autoBouwjaar") %>' />
                <br />
                brandstofID:
                <asp:TextBox ID="txtBrandstofID" runat="server" 
                    Text='<%# Bind("brandstofID") %>' />
                <br />
                autoKenteken:
                <asp:TextBox ID="txtAutoKenteken" runat="server" 
                    Text='<%# Bind("autoKenteken") %>' />
                <br />
                autoDagTarief:
                <asp:TextBox ID="txtAutoDagTarief" runat="server" 
                    Text='<%# Bind("autoDagTarief") %>' />
                <br />
                autoKMTotOlieVerversing:
                <asp:TextBox ID="txtAutoKMTotOlieVerversing" runat="server" 
                    Text='<%# Bind("autoKMTotOlieVerversing") %>' />
                <br />
                statusID:
                <asp:TextBox ID="txtStatusID" runat="server" 
                    Text='<%# Bind("statusID") %>' />
                <br />
                filiaalID:
                <asp:TextBox ID="txtFiliaalID" runat="server" 
                    Text='<%# Bind("filiaalID") %>' />
                <br />
                autoParkeerplaats:
                <asp:TextBox ID="txtAutoParkeerplaats" runat="server" 
                    Text='<%# Bind("autoParkeerplaats") %>' />
                <br />
                <asp:LinkButton ID="btnUpdate" runat="server" CausesValidation="True" 
                    CommandName="Update" Text="Update" />
                &nbsp;<asp:LinkButton ID="btnUpdateCancel" runat="server" 
                    CausesValidation="False" CommandName="Cancel" Text="Cancel" />
            </EditItemTemplate>
            <InsertItemTemplate>
                Categorie:
                <asp:DropDownList ID="ddlCategorie" runat="server" 
                    SelectedValue='<%# Bind("autoCategorie") %>' DataSourceID="odsCategorie" 
                    DataTextField="categorieNaam" DataValueField="categorieID">
                </asp:DropDownList>
                <br />
                Model:
                <asp:UpdatePanel ID="updMerkModel" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:DropDownList ID="ddlMerk" runat="server">
                        </asp:DropDownList>
                        <asp:DropDownList ID="ddlModel" runat="server" DataTextField="modelNaam" 
                            DataValueField="modelID" SelectedValue='<%# Bind("modelID") %>'>
                        </asp:DropDownList>
                        <ajaxToolkit:CascadingDropDown ID="cddMerk" runat="server" Category="Merk" 
                            PromptText="Selecteer een merk" ServiceMethod="GeefMerken" 
                            ServicePath="~/App_Presentation/WebServices/AutoService.asmx" TargetControlID="ddlMerk">
                        </ajaxToolkit:CascadingDropDown>
                        <ajaxToolkit:CascadingDropDown ID="cddModel" runat="server" Category="Model" 
                            ParentControlID="ddlMerk" PromptText="Selecteer een model" 
                            ServiceMethod="GeefModellenVoorMerk" ServicePath="~/App_Presentation/WebServices/AutoService.asmx" 
                            TargetControlID="ddlModel">
                        </ajaxToolkit:CascadingDropDown>
                    </ContentTemplate>
                </asp:UpdatePanel>
                Kleur:
                <asp:TextBox ID="txtAutoKleur" runat="server" 
                    Text='<%# Bind("autoKleur") %>' />
                <br />
                Bouwjaar:
                <asp:TextBox ID="txtAutoBouwjaar" runat="server" 
                    Text='<%# Bind("autoBouwjaar") %>' />
                <br />
                Type brandstof:
                <asp:DropDownList ID="ddlBrandstofType" runat="server" 
                    DataSourceID="odsBrandstofType" DataTextField="brandstofNaam" 
                    DataValueField="brandstofID" SelectedValue='<%# Bind("brandstofID") %>'>
                </asp:DropDownList>
                <br />
                Kenteken:
                <asp:TextBox ID="txtAutoKenteken" runat="server" 
                    Text='<%# Bind("autoKenteken") %>' />
                <br />
                Status
                <asp:DropDownList ID="ddlStatus" runat="server" DataSourceID="odsAutoStatus" 
                    DataTextField="autostatusNaam" DataValueField="autostatusID" 
                    SelectedValue='<%# Bind("statusID") %>'>
                </asp:DropDownList>
                <br />
                Parkeerplaats:
                <asp:TextBox ID="txtAutoParkeerplaats" runat="server" 
                    Text='<%# Bind("autoParkeerplaats") %>' />
                <br />
                Filiaal:
                <asp:DropDownList ID="ddlFiliaal" runat="server" DataSourceID="odsFiliaal" 
                    DataTextField="filiaalNaam" DataValueField="filiaalID" 
                    SelectedValue='<%# Bind("filiaalID") %>'>
                </asp:DropDownList>
                <br />
                Dagtarief:&nbsp;<asp:TextBox ID="txtAutoDagTarief" runat="server" 
                    Text='<%# Bind("autoDagTarief") %>' />
                <br />
                Foto:&nbsp;<asp:FileUpload ID="fupAutoFoto" runat="server" />
                <br />
                <asp:LinkButton ID="btnInsert" runat="server" CausesValidation="True" 
                    CommandName="Insert" onclick="btnInsert_Click" Text="Auto Toevoegen" />
                &nbsp;<asp:LinkButton ID="btnInsertCancel" runat="server" 
                    CausesValidation="False" CommandName="Cancel" Text="Annuleren" />
            </InsertItemTemplate>
            <ItemTemplate>
                autoID:
                <asp:Label ID="lblAutoID" runat="server" Text='<%# Eval("autoID") %>' />
                <br />
                autoCategorie:
                <asp:Label ID="lblAutoCategorie" runat="server" 
                    Text='<%# Bind("autoCategorie") %>' />
                <br />
                modelID:
                <asp:Label ID="lblModelID" runat="server" Text='<%# Bind("modelID") %>' />
                <br />
                autoKleur:
                <asp:Label ID="lblAutoKleur" runat="server" Text='<%# Bind("autoKleur") %>' />
                <br />
                autoBouwjaar:
                <asp:Label ID="lblAutoBouwjaar" runat="server" 
                    Text='<%# Bind("autoBouwjaar") %>' />
                <br />
                brandstofID:
                <asp:Label ID="lblBrandstofID" runat="server" 
                    Text='<%# Bind("brandstofID") %>' />
                <br />
                autoKenteken:
                <asp:Label ID="lblAutoKenteken" runat="server" 
                    Text='<%# Bind("autoKenteken") %>' />
                <br />
                autoDagTarief:
                <asp:Label ID="lblAutoDagTarief" runat="server" 
                    Text='<%# Bind("autoDagTarief") %>' />
                <br />
                autoKMTotOlieVerversing:
                <asp:Label ID="lblAutoKMTotOlieVerversing" runat="server" 
                    Text='<%# Bind("autoKMTotOlieVerversing") %>' />
                <br />
                statusID:
                <asp:Label ID="lblStatusID" runat="server" Text='<%# Bind("statusID") %>' />
                <br />
                filiaalID:
                <asp:Label ID="lblFiliaalID" runat="server" 
                    Text='<%# Bind("filiaalID") %>' />
                <br />
                autoParkeerplaats:
                <asp:Label ID="lblAutoParkeerplaats" runat="server" 
                    Text='<%# Bind("autoParkeerplaats") %>' />
                <br />
                <asp:LinkButton ID="btnDelete" runat="server" CausesValidation="False" 
                    CommandName="Delete" Text="Delete" />
                &nbsp;<asp:LinkButton ID="btnNew" runat="server" CausesValidation="False" 
                    CommandName="New" Text="New" />
            </ItemTemplate>
        </asp:FormView>
    
    </div>
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
    <asp:ObjectDataSource ID="odsCategorie" runat="server" 
        TypeName="Auto_sTableAdapters.tblCategorieTableAdapter" 
        DeleteMethod="Delete" InsertMethod="Insert" 
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" 
        UpdateMethod="Update">
        <DeleteParameters>
            <asp:Parameter Name="Original_categorieID" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="categorieNaam" Type="String" />
            <asp:Parameter Name="Original_categorieID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="categorieNaam" Type="String" />
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
    <asp:ObjectDataSource ID="odsAuto" runat="server" 
        DataObjectTypeName="Auto&amp;" DeleteMethod="DeleteAuto" InsertMethod="AddAuto" 
        SelectMethod="GetAllAutos" TypeName="AutoBLL">
        <DeleteParameters>
            <asp:Parameter Name="autoID" Type="Int32" />
        </DeleteParameters>
    </asp:ObjectDataSource>
    <br />
</asp:Content>
