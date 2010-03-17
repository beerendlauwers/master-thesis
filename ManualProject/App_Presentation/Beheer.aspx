<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false"
    CodeFile="Beheer.aspx.vb" Inherits="App_Presentation_Beheer" Title="Untitled Page" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <cc1:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="3" Width="570px">
        <cc1:TabPanel runat="server" HeaderText="Bedrijf" ID="TabPanel1">
            <HeaderTemplate>
                Bedrijf
            </HeaderTemplate>
            <ContentTemplate>
                <asp:UpdatePanel ID="updBedrijf" runat="server">
                    <ContentTemplate>
                        <cc1:Accordion ID="Accordion1" runat="server" SelectedIndex="0" HeaderCssClass="art-BlockHeaderStrong"
                            ContentCssClass="art-content">
                            <Panes>
                                <cc1:AccordionPane runat="server" BackColor="Black">
                                    <Header>
                                        bedrijf toevoegen</Header>
                                    <Content>
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label1" runat="server" Text="Bedrijfsnaam: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtAddbedrijf" runat="server"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lblBedrijf" runat="server" Text="Tag: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtAddTag" runat="server"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnAddBedrijf" runat="server" Text="Toevoegen" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblAddBedrijfRes" runat="server" Text=""></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </Content>
                                </cc1:AccordionPane>
                                <cc1:AccordionPane ID="AccordionPane1" runat="server">
                                    <Header>
                                        bedrijf Bewerken</Header>
                                    <Content>
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lblBewerkBedrijf" runat="server" Text="Kies een bedrijf: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlBewerkBedrijf" runat="server" DataSourceID="objdBedrijf"
                                                        DataTextField="naam" DataValueField="bedrijfID" OnSelectedIndexChanged="ddlBewerkBedrijf_SelectedIndexChanged"
                                                        AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label2" runat="server" Text="Bedrijfsnaam: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtEditBedrijf" runat="server"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <tr>
                                                    <td>
                                                        <asp:Label ID="lblEditTag" runat="server" Text="Tag: "></asp:Label>
                                                    </td>
                                                    <td>
                                                        <asp:TextBox ID="txtEditTag" runat="server"></asp:TextBox>
                                                    </td>
                                                </tr>
                                                <td>
                                                    <asp:Button ID="btnEditBedrijf" runat="server" Text="Edit" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblEditbedrijfRes" runat="server" Text=""></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </Content>
                                </cc1:AccordionPane>
                                <cc1:AccordionPane ID="AccordionPane2" runat="server">
                                    <Header>
                                        bedrijf verwijderen</Header>
                                    <Content>
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label3" runat="server" Text="Bedrijf: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlDeleteBedrijf" runat="server" DataSourceID="objdBedrijf"
                                                        DataTextField="naam" DataValueField="bedrijfID">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnDeleteBedrijf" runat="server" Text="Verwijder" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblDeleteBedrijfRes" runat="server" Text=""></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </Content>
                                </cc1:AccordionPane>
                            </Panes>
                        </cc1:Accordion>
                        <asp:UpdateProgress runat="server">
                            <ProgressTemplate>
                                <div class="update">
                                    <img src="CSS/Images/ajaxloader.gif" />
                                    Even wachten aub...
                                </div>
                            </ProgressTemplate>
                        </asp:UpdateProgress>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </ContentTemplate>
        </cc1:TabPanel>
        <cc1:TabPanel runat="server" HeaderText="Taal" ID="TabPanel2">
            <HeaderTemplate>
                Taal
            </HeaderTemplate>
            <ContentTemplate>
                <asp:UpdatePanel ID="updTaal" runat="server">
                    <ContentTemplate>
                        <cc1:Accordion ID="Accordion2" runat="server" SelectedIndex="0" HeaderCssClass="art-BlockHeaderStrong"
                            ContentCssClass="art-content">
                            <Panes>
                                <cc1:AccordionPane ID="AccordionPane3" runat="server" BackColor="Black">
                                    <Header>
                                        Taal toevoegen</Header>
                                    <Content>
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lblAddTaal" runat="server" Text="Taal: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtAddTaal" runat="server"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnAddTaal" runat="server" Text="Toevoegen" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblAddTaalRes" runat="server" Text=""></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </Content>
                                </cc1:AccordionPane>
                                <cc1:AccordionPane ID="AccordionPane4" runat="server">
                                    <Header>
                                        Taal Bewerken</Header>
                                    <Content>
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lblBewerkTaal" runat="server" Text="Kies een Taal: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlBewerkTaal" runat="server" DataSourceID="objdTaal" DataTextField="Taal"
                                                        DataValueField="TaalID" OnSelectedIndexChanged="ddlBewerkTaal_SelectedIndexChanged"
                                                        AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lblEditTaal" runat="server" Text="Taal: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtEditTaal" runat="server"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnEditTaal" runat="server" Text="Edit" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblEditTaalRes" runat="server" Text=""></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </Content>
                                </cc1:AccordionPane>
                                <cc1:AccordionPane ID="AccordionPane5" runat="server">
                                    <Header>
                                        Taal verwijderen</Header>
                                    <Content>
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label6" runat="server" Text="Taal: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlTaalDelete" runat="server" DataSourceID="objdTaal" DataTextField="taal"
                                                        DataValueField="TaalID">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnTaalDelete" runat="server" Text="Verwijder" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblDeleteTaalRes" runat="server" Text=""></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </Content>
                                </cc1:AccordionPane>
                            </Panes>
                        </cc1:Accordion>
                        <asp:UpdateProgress ID="UpdateProgress1" runat="server">
                            <ProgressTemplate>
                                <div class="update">
                                    <img src="CSS/Images/ajaxloader.gif"/>
                                    Even wachten aub...
                                </div>
                            </ProgressTemplate>
                        </asp:UpdateProgress>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </ContentTemplate>
        </cc1:TabPanel>
        <cc1:TabPanel runat="server" HeaderText="Versie" ID="TabPanel3">
            <HeaderTemplate>
                Versie
            </HeaderTemplate>
            <ContentTemplate>
                <asp:UpdatePanel ID="updVersie" runat="server">
                    <ContentTemplate>
                        <cc1:Accordion ID="Accordion3" runat="server" SelectedIndex="0" HeaderCssClass="art-BlockHeaderStrong"
                            ContentCssClass="art-content">
                            <Panes>
                                <cc1:AccordionPane ID="AccordionPane6" runat="server" BackColor="Black">
                                    <Header>
                                        Versie toevoegen</Header>
                                    <Content>
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label7" runat="server" Text="Versie: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtAddVersie" runat="server"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnAddVersie" runat="server" Text="Toevoegen" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblAddVersieRes" runat="server" Text=""></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </Content>
                                </cc1:AccordionPane>
                                <cc1:AccordionPane ID="AccordionPane7" runat="server">
                                    <Header>
                                        Versie Bewerken</Header>
                                    <Content>
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lblBewerkVersie" runat="server" Text="Kies een Versie: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlBewerkVersie" runat="server" DataSourceID="objdVersie" DataTextField="Versie"
                                                        DataValueField="VersieID" OnSelectedIndexChanged="ddlBewerkVersie_SelectedIndexChanged"
                                                        AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label8" runat="server" Text="Versie: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtEditVersie" runat="server"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnEditVersie" runat="server" Text="Edit" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblEditVersieRes" runat="server" Text=""></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </Content>
                                </cc1:AccordionPane>
                                <cc1:AccordionPane ID="AccordionPane8" runat="server">
                                    <Header>
                                        Versie verwijderen</Header>
                                    <Content>
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label9" runat="server" Text="Versie: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlDeletVersie" runat="server" DataSourceID="objdVersie" DataTextField="versie"
                                                        DataValueField="versieID">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnDeleteVersie" runat="server" Text="Verwijder" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblDeleteVersieRes" runat="server" Text=""></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </Content>
                                </cc1:AccordionPane>
                            </Panes>
                        </cc1:Accordion>
                        <asp:UpdateProgress ID="UpdateProgress2" runat="server">
                            <ProgressTemplate>
                                <div class="update">
                                    <img src="CSS/Images/ajaxloader.gif" />
                                    Even wachten aub...
                                </div>
                            </ProgressTemplate>
                        </asp:UpdateProgress>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </ContentTemplate>
        </cc1:TabPanel>
        <cc1:TabPanel runat="server" HeaderText="Categorie" ID="TabPanel4">
            <HeaderTemplate>
                Categorie
            </HeaderTemplate>
            <ContentTemplate>
                <asp:UpdatePanel ID="updCategorie" runat="server">
                    <ContentTemplate>
                        <cc1:Accordion ID="Accordion4" runat="server" SelectedIndex="0" HeaderCssClass="art-BlockHeaderStrong"
                            ContentCssClass="art-content">
                            <Panes>
                                <cc1:AccordionPane ID="AccordionPane9" runat="server" BackColor="Black">
                                    <Header>
                                        Categorie toevoegen</Header>
                                    <Content>
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label13" runat="server" Text="Categorienaam: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtAddCatnaam" runat="server"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <td>
                                                <asp:Label ID="Label14" runat="server" Text="Kies een Taal: "></asp:Label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlAddCatTaal" runat="server" DataSourceID="objdTaal" DataTextField="Taal"
                                                    DataValueField="TaalID">
                                                </asp:DropDownList>
                                            </td>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label15" runat="server" Text="Kies een ParentCategorie: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlAddParentcat" runat="server" DataSourceID="objdCategorie"
                                                        DataTextField="Categorie" DataValueField="CategorieID" OnSelectedIndexChanged="ddlAddParentcat_SelectedIndexChanged"
                                                        AutoPostBack="True">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label16" runat="server" Text="Kies een Hoogte: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtAddhoogte" runat="server"></asp:TextBox>
                                                </td>
                                            </tr>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label4" runat="server" Text="Kies een versie: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlVersie" runat="server" DataSourceID="objdVersie"
                                                        DataTextField="Versie" DataValueField="VersieID" OnSelectedIndexChanged="ddlAddParentcat_SelectedIndexChanged"
                                                        AutoPostBack="True">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label10" runat="server" Text="Kies een Bedrijf: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="DropDownList1" runat="server" DataSourceID="objdBedrijf"
                                                        DataTextField="naam" DataValueField="bedrijfID" OnSelectedIndexChanged="ddlAddParentcat_SelectedIndexChanged"
                                                        AutoPostBack="True">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnCatAdd" runat="server" Text="Voeg toe"></asp:Button>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblResAdd" runat="server" Text=""></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </Content>
                                </cc1:AccordionPane>
                                <cc1:AccordionPane ID="AccordionPane10" runat="server">
                                    <Header>
                                        Categorie Bewerken</Header>
                                    <Content>
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lblBewerkCategorie" runat="server" Text="Kies een Categorie: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlEditCategorie" runat="server" OnSelectedIndexChanged="ddlEditCategorie_SelectedIndexChanged"
                                                        AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label11" runat="server" Text="Categorienaam: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtCatbewerknaam" runat="server"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <td>
                                                <asp:Label ID="lblBewerkCategorie1" runat="server" Text="Kies een Taal: "></asp:Label>
                                            </td>
                                            <td>
                                                <asp:DropDownList ID="ddlEditCatTaal" runat="server" DataSourceID="objdTaal" DataTextField="Taal"
                                                    DataValueField="TaalID">
                                                </asp:DropDownList>
                                            </td>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lblBewerkCategorie2" runat="server" Text="Kies een ParentCategorie: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlEditCatParent" runat="server" DataSourceID="objdCategorie"
                                                        DataTextField="Categorie" DataValueField="CategorieID" OnSelectedIndexChanged="ddlEditCatParent_SelectedIndexChanged"
                                                        AutoPostBack="true">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="lblBewerkCategorie3" runat="server" Text="Kies een Hoogte: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:TextBox ID="txtEditCathoogte" runat="server"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label17" runat="server" Text="Kies een versie: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="DropDownList2" runat="server" DataSourceID="objdVersie"
                                                        DataTextField="Versie" DataValueField="VersieID" OnSelectedIndexChanged="ddlAddParentcat_SelectedIndexChanged"
                                                        AutoPostBack="True">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label5" runat="server" Text="Kies een Bedrijf: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlBedrijf" runat="server" DataSourceID="objdBedrijf"
                                                        DataTextField="naam" DataValueField="bedrijfID" OnSelectedIndexChanged="ddlAddParentcat_SelectedIndexChanged"
                                                        AutoPostBack="True">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="btnCatEdit" runat="server" Text="Edit"></asp:Button>
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblResEdit" runat="server" Text=""></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </Content>
                                </cc1:AccordionPane>
                                <cc1:AccordionPane ID="AccordionPane11" runat="server">
                                    <Header>
                                        Categorie verwijderen</Header>
                                    <Content>
                                        <table>
                                            <tr>
                                                <td>
                                                    <asp:Label ID="Label12" runat="server" Text="Categorie: "></asp:Label>
                                                </td>
                                                <td>
                                                    <asp:DropDownList ID="ddlCatVerwijder" runat="server">
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>
                                                    <asp:Button ID="Button1" runat="server" Text="Verwijder" />
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblResDelete" runat="server" Text=""></asp:Label>
                                                </td>
                                            </tr>
                                        </table>
                                    </Content>
                                </cc1:AccordionPane>
                            </Panes>
                        </cc1:Accordion>
                        <asp:UpdateProgress ID="UpdateProgress3" runat="server">
                            <ProgressTemplate>
                                <div class="update">
                                    <img src="CSS/Images/ajaxloader.gif" />
                                    Even wachten aub...
                                </div>
                            </ProgressTemplate>
                        </asp:UpdateProgress>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </ContentTemplate>
        </cc1:TabPanel>
    </cc1:TabContainer>
    <asp:ObjectDataSource ID="objdBedrijf" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="ManualTableAdapters.tblBedrijfTableAdapter"
        UpdateMethod="Update">
        <DeleteParameters>
            <asp:Parameter Name="Original_BedrijfID" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Naam" Type="String" />
            <asp:Parameter Name="Original_BedrijfID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="BedrijfID" Type="Int32" />
            <asp:Parameter Name="Naam" Type="String" />
        </InsertParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="objdCategorie" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="ManualTableAdapters.tblCategorieTableAdapter"
        UpdateMethod="Update">
        <DeleteParameters>
            <asp:Parameter Name="Original_CategorieID" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Categorie" Type="String" />
            <asp:Parameter Name="Diepte" Type="Int32" />
            <asp:Parameter Name="Hoogte" Type="Int32" />
            <asp:Parameter Name="FK_parent" Type="Int32" />
            <asp:Parameter Name="FK_taal" Type="Int32" />
            <asp:Parameter Name="Original_CategorieID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="CategorieID" Type="Int32" />
            <asp:Parameter Name="Categorie" Type="String" />
            <asp:Parameter Name="Diepte" Type="Int32" />
            <asp:Parameter Name="Hoogte" Type="Int32" />
            <asp:Parameter Name="FK_parent" Type="Int32" />
            <asp:Parameter Name="FK_taal" Type="Int32" />
        </InsertParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="objdTaal" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="ManualTableAdapters.tblTaalTableAdapter"
        UpdateMethod="Update">
        <DeleteParameters>
            <asp:Parameter Name="Original_TaalID" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Taal" Type="String" />
            <asp:Parameter Name="Original_TaalID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="TaalID" Type="Int32" />
            <asp:Parameter Name="Taal" Type="String" />
        </InsertParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="objdVersie" runat="server" DeleteMethod="Delete" InsertMethod="Insert"
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" TypeName="ManualTableAdapters.tblVersieTableAdapter"
        UpdateMethod="Update">
        <DeleteParameters>
            <asp:Parameter Name="Original_VersieID" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Versie" Type="String" />
            <asp:Parameter Name="Original_VersieID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="VersieID" Type="Int32" />
            <asp:Parameter Name="Versie" Type="String" />
        </InsertParameters>
    </asp:ObjectDataSource>
</asp:Content>
