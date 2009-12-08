<%@ Page Language="VB" AutoEventWireup="false" CodeFile="NieuweAutoAanmaken.aspx.vb" EnableEventValidation="false" Inherits="App_Presentation_NieuweAutoAanmaken" MasterPageFile="~/App_Presentation/MasterPage.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Main" ContentPlaceHolderID="plcMain" runat="server">
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
                <table>
                    <tr>
                        <td>
                            Categorie:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlCategorie" runat="server" SelectedValue='<%# Bind("autoCategorie") %>'
                                DataSourceID="odsCategorie" DataTextField="categorieNaam" DataValueField="categorieID">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Model:
                        </td>
                        <td>
                            <asp:UpdatePanel ID="updMerkModel" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <asp:DropDownList ID="ddlMerk" runat="server">
                                    </asp:DropDownList>
                                    <asp:DropDownList ID="ddlModel" runat="server" DataTextField="modelNaam" DataValueField="modelID"
                                        SelectedValue='<%# Bind("modelID") %>' DataSourceID="odsModel">
                                    </asp:DropDownList>
                                    <cc1:CascadingDropDown ID="cddMerk" runat="server" Category="Merk" PromptText="Selecteer een merk"
                                        ServiceMethod="GeefMerken" ServicePath="~/App_Presentation/WebServices/AutoService.asmx"
                                        TargetControlID="ddlMerk">
                                    </cc1:CascadingDropDown>
                                    <cc1:CascadingDropDown ID="cddModel" runat="server" Category="Model" ParentControlID="ddlMerk"
                                        PromptText="Selecteer een model" ServiceMethod="GeefModellenVoorMerk" ServicePath="~/App_Presentation/WebServices/AutoService.asmx"
                                        TargetControlID="ddlModel">
                                    </cc1:CascadingDropDown>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Kleur:
                        </td>
                        <td>
                            <asp:TextBox ID="txtAutoKleur" runat="server" Text='<%# Bind("autoKleur") %>' />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Bouwjaar:
                        </td>
                        <td>
                            <asp:UpdatePanel ID="updBouwjaar" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                            <asp:TextBox ID="txtAutoBouwjaar" runat="server" Text='<%# Bind("autoBouwjaar") %>' />
                            <cc1:MaskedEditExtender ID="mskAutoBouwjaar" runat="server" AutoComplete="False" MaskType="Number" Mask="9999" TargetControlID="txtAutoBouwjaar" ClearTextOnInvalid="True" PromptCharacter=".">
                            </cc1:MaskedEditExtender>
                            <cc1:MaskedEditValidator ID="valAutoBouwjaar" runat="server" ControlToValidate="txtAutoBouwjaar" InvalidValueMessage="Gelieve een geldig jaar in te vullen." IsValidEmpty="False" MinimumValue="1900" ControlExtender="mskAutoBouwjaar" EmptyValueMessage="Gelieve een geldig jaar in te vullen." InvalidValueBlurredMessage="Gelieve een geldig jaar in te vullen." MinimumValueBlurredText="Het minimumjaar is 1900." EmptyValueBlurredText="Gelieve een geldig jaar in te vullen.">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </cc1:MaskedEditValidator>
                            </ContentTemplate>
                            <Triggers>
                            <asp:AsyncPostBackTrigger ControlID = "txtAutoBouwjaar" />
                            </Triggers>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Brandstoftype:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlBrandstofType" runat="server" DataSourceID="odsBrandstofType"
                                DataTextField="brandstofNaam" DataValueField="brandstofID" SelectedValue='<%# Bind("brandstofID") %>'>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Kenteken:
                        </td>
                        <td>
                            <asp:UpdatePanel ID="updAutoKenteken" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <asp:TextBox ID="txtAutoKenteken" runat="server" AutoPostBack = "true" 
                                        Text='<%# Bind("autoKenteken") %>' 
                                        ontextchanged="txtAutoKenteken_TextChanged" />
                                    <cc1:MaskedEditExtender ID="mskAutoKenteken" runat="server" TargetControlID="txtAutoKenteken" AutoComplete="False" PromptCharacter="." Mask="LLL999" ClearTextOnInvalid="True" ></cc1:MaskedEditExtender>
                                    <cc1:MaskedEditValidator ID="valAutoKenteken" runat="server" 
                                        ControlExtender="mskAutoKenteken" ControlToValidate="txtAutoKenteken">&nbsp;&nbsp;&nbsp;&nbsp; </cc1:MaskedEditValidator>
                                        <asp:Label ID="lblAutoKentekenIncorrect" runat="server" Text="Dit kenteken is reeds in gebruik." Visible="false" ForeColor="red"></asp:Label>                                
                                </ContentTemplate>
                                <Triggers>
                                    <asp:AsyncPostBackTrigger ControlID="txtAutoKenteken" />
                                </Triggers>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Status:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlStatus" runat="server" DataSourceID="odsAutoStatus" DataTextField="autostatusNaam"
                                DataValueField="autostatusID" SelectedValue='<%# Bind("statusID") %>'>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Filiaal:
                        </td>
                        <td>
                            <asp:UpdatePanel ID="updFiliaal" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <asp:DropDownList ID="ddlFiliaal" runat="server" DataSourceID="odsFiliaal" DataTextField="filiaalNaam"
                                        DataValueField="filiaalID" SelectedValue='<%# Bind("filiaalID") %>' OnSelectedIndexChanged="ddlFiliaal_SelectedIndexChanged"
                                        AutoPostBack="true">
                                    </asp:DropDownList>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                    <tr>
                        <td>
                           Parkeerplaats:
                        </td>
                        <td>
                            <asp:UpdatePanel ID="updParkingOverzicht" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <asp:TextBox ID="txtAutoParkeerplaats" runat="server" Text='<%# Bind("autoParkeerplaats") %>'
                                        Enabled="false" />
                                    <asp:ImageButton ID="imgParkeerPlaats" runat="server" ImageUrl="~/App_Presentation/Images/kalender.png"
                                        Visible="false" />
                                </ContentTemplate>
                            </asp:UpdatePanel>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Dagtarief:
                        </td>
                        <td>
                            <asp:TextBox ID="txtAutoDagTarief" runat="server" Text='<%# Bind("autoDagTarief") %>' />
                            <cc1:FilteredTextBoxExtender ID="fltAutoDagTarief" runat="server" TargetControlID="txtAutoDagTarief" FilterType="Custom, Numbers" ValidChars=",">
                            </cc1:FilteredTextBoxExtender>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Foto:
                        </td>
                        <td>
                            <cc1:AsyncFileUpload ID="uplFoto" runat="server" Width="250px" OnUploadedComplete="FotoGeupload" />
                        </td>
                    </tr>
                </table>
                <asp:UpdatePanel ID="updOpties" runat="server">
                    <ContentTemplate>
                        <table>
                            <tr>
                                <th colspan="2" align="center">
                                    <br />
                                    Optiebeheer
                                </th>
                            </tr>
                            <tr>
                                <td>
                                    Optie:
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlOpties" runat="server" DataSourceID="odsOptie" DataTextField="optieOmschrijving"
                                        DataValueField="optieID">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="right">
                                    <asp:Button ID="btnVoegtoe" runat="server" OnClick="btnVoegtoe_Click" Text="Optie Toevoegen" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="right">
                                    <asp:Button ID="btnNieuweOptie" runat="server" Text="Nieuwe Optie Aanmaken" OnClick="btnNieuweOptie_Click" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblOptieNaam" runat="server" Text="Optienaam: "></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtOptieNaam" runat="server"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblOptiePrijs" runat="server" Text="Optieprijs: "></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtOptiePrijs" runat="server"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="right">
                                    <asp:Button ID="btnVoegoptietoe" runat="server" OnClick="btnVoegoptietoe_Click" Text="Toevoegen" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:ListBox ID="lstOpties" runat="server" SelectionMode="Multiple"></asp:ListBox>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:Button ID="btnVerwijderLijst" runat="server" OnClick="btnVerwijderLijst_Click"
                                        Text="Verwijder Optie" />
                                </td>
                            </tr>
                        </table>
                    
                    <hr />
               </div>
                </ContentTemplate>
                </asp:UpdatePanel>
                <asp:UpdatePanel ID="updAutoToevoegen" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <asp:Button ID="btnInsert" runat="server" CausesValidation="True" CommandName="Insert"
                            OnClick="btnInsert_Click" Text="Auto Toevoegen" />
                        &nbsp;<asp:LinkButton ID="btnInsertCancel" runat="server" CausesValidation="False"
                            CommandName="Cancel" Text="Annuleren" />
                        <asp:Label ID="lblTest" runat="server" Visible="false"></asp:Label>
                    </ContentTemplate>
                </asp:UpdatePanel>
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
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetAllBrandstofTypes" 
        TypeName="BrandstofBLL">
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsAutoStatus" runat="server" 
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetAllAutoStatusToewijsbaarBijMaken" 
        TypeName="AutoStatusBLL">
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsCategorie" runat="server" 
        TypeName="CategorieBLL" 
        OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetAllCategorien">
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsFiliaal" runat="server" DeleteMethod="DeleteFiliaal" 
        InsertMethod="AddFiliaal" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetAllFilialen" TypeName="FiliaalBLL" 
        DataObjectTypeName="Autos+tblFiliaalRow&amp;">
        <DeleteParameters>
            <asp:Parameter Name="filiaalID" Type="Int32" />
        </DeleteParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsOptie" runat="server" 
        InsertMethod="AddOptie" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetAllOpties" TypeName="OptieBLL" 
        DataObjectTypeName="Optie&amp;">
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsModel" runat="server" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetAllModels" TypeName="ModelBLL">
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="odsAuto" runat="server" 
        DataObjectTypeName="Autos+tblAutoRow&amp;" DeleteMethod="DeleteAuto" 
        SelectMethod="GetAllAutos" TypeName="AutoBLL" 
        OldValuesParameterFormatString="original_{0}" UpdateMethod="UpdateAuto" 
        InsertMethod="AddAuto">
        <DeleteParameters>
            <asp:Parameter Name="autoID" Type="Int32" />
        </DeleteParameters>
    </asp:ObjectDataSource>
</asp:Content>
