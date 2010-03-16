<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="Beheer.aspx.vb" Inherits="App_Presentation_Beheer" title="Untitled Page" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <cc1:TabContainer ID="TabContainer1" runat="server" ActiveTabIndex="0" 
    Width="570px">
        <cc1:TabPanel runat="server" HeaderText="Bedrijf" ID="TabPanel1">
            <HeaderTemplate>
                Bedrijf
            </HeaderTemplate>
            <ContentTemplate>
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                        <cc1:Accordion ID="Accordion1" runat="server" SelectedIndex="0" HeaderCssClass="art-BlockHeaderStrong"
                            ContentCssClass="art-content">
                            <Panes>
                                <cc1:AccordionPane runat="server" BackColor="Black">
                                    <Header>
                                        bedrijf toevoegen</Header>
                                    <Content>
                                        <asp:Label ID="Label1" runat="server" Text="Bedrijfsnaam: "></asp:Label><asp:TextBox
                                            ID="TextBox4" runat="server"></asp:TextBox></Content>
                                </cc1:AccordionPane>
                                <cc1:AccordionPane ID="AccordionPane1" runat="server">
                                    <Header>
                                        bedrijf Bewerken</Header>
                                    <Content>
                                        <asp:Label ID="Label2" runat="server" Text="Bedrijfsnaam: "></asp:Label><asp:TextBox
                                            ID="TextBox1" runat="server"></asp:TextBox></Content>
                                </cc1:AccordionPane>
                                <cc1:AccordionPane ID="AccordionPane2" runat="server">
                                    <Header>
                                        bedrijf verwijderen</Header>
                                    <Content>
                                        <asp:Label ID="Label3" runat="server" Text="Bedrijf: "></asp:Label><asp:DropDownList
                                            ID="DropDownList1" runat="server" DataSourceID="objdBedrijf" DataTextField="naam" DataValueField="bedrijfID">
                                        </asp:DropDownList>
                                        <asp:Button ID="Button4" runat="server" Text="Verwijder" /></Content>
                                </cc1:AccordionPane>
                            </Panes>
                        </cc1:Accordion>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </ContentTemplate>
        </cc1:TabPanel>
        <cc1:TabPanel runat="server" HeaderText="Taal" ID="TabPanel2">
            <HeaderTemplate>
                Taal
            </HeaderTemplate>
            <ContentTemplate>
                <asp:UpdatePanel ID="UpdatePanel2" runat="server">
                    <ContentTemplate>
                        <cc1:Accordion ID="Accordion2" runat="server" SelectedIndex="0" HeaderCssClass="art-BlockHeaderStrong"
                            ContentCssClass="art-content">
                            <Panes>
                                <cc1:AccordionPane ID="AccordionPane3" runat="server" BackColor="Black">
                                    <Header>
                                        Taal toevoegen</Header>
                                    <Content>
                                        <asp:Label ID="Label4" runat="server" Text="Taal: "></asp:Label><asp:TextBox
                                            ID="TextBox2" runat="server"></asp:TextBox></Content>
                                </cc1:AccordionPane>
                                <cc1:AccordionPane ID="AccordionPane4" runat="server">
                                    <Header>
                                        Taal Bewerken</Header>
                                    <Content>
                                        <asp:Label ID="Label5" runat="server" Text="Taal: "></asp:Label><asp:TextBox
                                            ID="TextBox3" runat="server"></asp:TextBox></Content>
                                </cc1:AccordionPane>
                                <cc1:AccordionPane ID="AccordionPane5" runat="server">
                                    <Header>
                                        Taal verwijderen</Header>
                                    <Content>
                                        <asp:Label ID="Label6" runat="server" Text="Taal: "></asp:Label><asp:DropDownList
                                            ID="DropDownList2" runat="server" DataSourceID="objdTaal" DataTextField="taal" DataValueField="TaalID">
                                        </asp:DropDownList>
                                        <asp:Button ID="Button3" runat="server" Text="Verwijder" /></Content>
                                </cc1:AccordionPane>
                            </Panes>
                        </cc1:Accordion>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </ContentTemplate>
        </cc1:TabPanel>
        <cc1:TabPanel runat="server" HeaderText="Versie" ID="TabPanel3">
            <HeaderTemplate>
                Versie
            </HeaderTemplate>
            <ContentTemplate>
                <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                    <ContentTemplate>
                        <cc1:Accordion ID="Accordion3" runat="server" SelectedIndex="0" HeaderCssClass="art-BlockHeaderStrong"
                            ContentCssClass="art-content">
                            <Panes>
                                <cc1:AccordionPane ID="AccordionPane6" runat="server" BackColor="Black">
                                    <Header>
                                        Versie toevoegen</Header>
                                    <Content>
                                        <asp:Label ID="Label7" runat="server" Text="Versie: "></asp:Label><asp:TextBox
                                            ID="TextBox5" runat="server"></asp:TextBox></Content>
                                </cc1:AccordionPane>
                                <cc1:AccordionPane ID="AccordionPane7" runat="server">
                                    <Header>
                                        Versie Bewerken</Header>
                                    <Content>
                                        <asp:Label ID="Label8" runat="server" Text="Versie: "></asp:Label><asp:TextBox
                                            ID="TextBox6" runat="server"></asp:TextBox></Content>
                                </cc1:AccordionPane>
                                <cc1:AccordionPane ID="AccordionPane8" runat="server">
                                    <Header>
                                        Versie verwijderen</Header>
                                    <Content>
                                        <asp:Label ID="Label9" runat="server" Text="Versie: "></asp:Label><asp:DropDownList
                                            ID="DropDownList3" runat="server" datasourceID="objdVersie" DataTextField="versie" DataValueField="versieID">
                                        </asp:DropDownList>
                                        <asp:Button ID="Button2" runat="server" Text="Verwijder" /></Content>
                                </cc1:AccordionPane>
                            </Panes>
                        </cc1:Accordion>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </ContentTemplate>
        </cc1:TabPanel>
        <cc1:TabPanel runat="server" HeaderText="Categorie" ID="TabPanel4">
            <HeaderTemplate>
                Categorie
            </HeaderTemplate>
            <ContentTemplate>
                <asp:UpdatePanel ID="UpdatePanel4" runat="server">
                    <ContentTemplate>
                        <cc1:Accordion ID="Accordion4" runat="server" SelectedIndex="0" HeaderCssClass="art-BlockHeaderStrong"
                            ContentCssClass="art-content">
                            <Panes>
                                <cc1:AccordionPane ID="AccordionPane9" runat="server" BackColor="Black">
                                    <Header>
                                        Categorie toevoegen</Header>
                                    <Content>
                                        <asp:Label ID="Label10" runat="server" Text="Categorie: "></asp:Label><asp:TextBox
                                            ID="TextBox7" runat="server"></asp:TextBox></Content>
                                </cc1:AccordionPane>
                                <cc1:AccordionPane ID="AccordionPane10" runat="server">
                                    <Header>
                                        Categorie Bewerken</Header>
                                    <Content>
                                        <asp:Label ID="Label11" runat="server" Text="Categorie: "></asp:Label><asp:TextBox
                                            ID="TextBox8" runat="server"></asp:TextBox></Content>
                                </cc1:AccordionPane>
                                <cc1:AccordionPane ID="AccordionPane11" runat="server">
                                    <Header>
                                        Categorie verwijderen</Header>
                                    <Content>
                                        <asp:Label ID="Label12" runat="server" Text="Categorie: "></asp:Label><asp:DropDownList
                                            ID="DropDownList4" runat="server" datasourceID="obdjCategorie" DataTextField="Categorie" DataValueField="CategorieID">
                                        </asp:DropDownList>
                                        <asp:Button ID="Button1" runat="server" Text="Verwijder" /></Content>
                                </cc1:AccordionPane>
                            </Panes>
                        </cc1:Accordion>
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

