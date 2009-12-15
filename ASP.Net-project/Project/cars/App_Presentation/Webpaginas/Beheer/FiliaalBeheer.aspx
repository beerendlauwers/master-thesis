<%@ Page Language="VB" AutoEventWireup="false" CodeFile="FiliaalBeheer.aspx.vb" Inherits="App_Presentation_Webpaginas_FiliaalBeheer"
    MasterPageFile="~/App_Presentation/MasterPage.master" Title="Filiaalbeheer" %>


<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Main" ContentPlaceHolderID="plcMain" runat="server">
<h1>Filiaalbeheer</h1>
    <cc1:Accordion ID="FiliaalAccordion" runat="server" AutoSize="None" TransitionDuration="250" headercssclass="art-BlockHeaderStrong">
        <Panes>
            <cc1:AccordionPane ID="PaneToevoegen" runat="server">
                 <Header><asp:Image ID="imgToevoegen" runat="server" ImageAlign="Top" ImageUrl="~/App_Presentation/Images/add.png" />Filiaal Toevoegen</Header>
                <Content>
                <asp:UpdatePanel runat="server" ID="updToevoegen" UpdateMode="Always">
                <ContentTemplate>
                    <table>
                        <tr>
                            <td>
                                <asp:Label ID="lblFiliaalNaam" runat="server" Text="Naam: "></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtFiliaalNaam" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="lblFiliaalLocatie" runat="server" Text="Locatie: "></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtLocatie" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <asp:Label ID="lblAdres" runat="server" Text="Straat + Nr: "></asp:Label>
                            </td>
                            <td>
                                <asp:TextBox ID="txtAdres" runat="server"></asp:TextBox>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="right">
                                <asp:Button ID="btnVoegtoe" runat="server" Text="Voeg filiaal toe" />
                            </td>
                        </tr>
                        <tr>
                            <asp:Label ID="lblGeslaagd" runat="server" Text=""></asp:Label>
                        </tr>
                    </table>
                                            </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="btnVoegtoe" />
                        </Triggers>
                    </asp:UpdatePanel>
                </Content>
            </cc1:AccordionPane>
            <cc1:AccordionPane ID="PaneWijzigen" runat="server">
                <Header><asp:Image ID="imgWijzigen" runat="server" ImageAlign="Top" ImageUrl="~/App_Presentation/Images/wrench.png" /> Filiaal Wijzigen</Header>
                <Content>
                    <asp:UpdatePanel runat="server" ID="updWijzigen" UpdateMode="Always">
                        <ContentTemplate>
                            <table>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblSelecteerFiliaal" runat="server" Text="Selecteer Filiaal: "></asp:Label>
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlFilialen" runat="server" DataSourceID="objdFiliaalDelete"
                                            DataTextField="filiaalNaam" DataValueField="filiaalID" AutoPostBack="true">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblFiliaalWijzigenNaam" runat="server" Text="Naam: "></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtFiliaalWijzigenNaam" runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblFiliaalWijzigenLocatie" runat="server" Text="Locatie: "></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtFiliaalWijzigenLocatie" runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:Label ID="lblFiliaalWijzigenStraatNr" runat="server" Text="Straat + Nr: "></asp:Label>
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtFiliaalWijzigenStraatNr" runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" align="right">
                                        <asp:Button ID="btnFiliaalWijzigen" runat="server" Text="Wijzig filiaal" />
                                    </td>
                                </tr>
                                <tr>
                            <asp:Label ID="lblUpdate" runat="server" Text=""></asp:Label>
                        </tr>
                            </table>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="ddlFilialen" />
                        </Triggers>
                    </asp:UpdatePanel>
                </Content>
            </cc1:AccordionPane>
            <cc1:AccordionPane ID="PaneVerwijderen" runat="server">
                <Header><asp:Image ID="Image1" runat="server" ImageAlign="Top" ImageUrl="~/App_Presentation/Images/remove.png" />Filiaal Verwijderen</Header>
                    <content>
                <asp:UpdatePanel runat="server" ID="updVerwijderen" UpdateMode="Always">
                    <ContentTemplate>
                    <table>
                    <tr>
                        <td>
                            <asp:Label ID="lblInstructie" runat="server" Text="Selecteer Filiaal:"></asp:Label>
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlFiliaal" runat="server" DataSourceID="objdFiliaalDelete"
                                DataTextField="filiaalNaam" DataValueField="filiaalID">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="right">
                            <asp:Button ID="btnDelete" runat="server" Text="Verwijder" />
                        </td>
                    </tr>
                    <tr>
                            <asp:Label ID="lblDelete" runat="server" Text=""></asp:Label>
                        </tr>
                </table>
                    </ContentTemplate>
                    <Triggers>
                        <asp:AsyncPostBackTrigger ControlID="btnDelete" />
                    </Triggers>
                </asp:UpdatePanel>
                </Content>
            </cc1:AccordionPane>
        </Panes>
    </cc1:Accordion>

    <asp:ObjectDataSource ID="objdFiliaalDelete" runat="server" DeleteMethod="Delete"
        InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" SelectMethod="GetData"
        TypeName="AutosTableAdapters.tblFiliaalTableAdapter" UpdateMethod="Update">
        <DeleteParameters>
            <asp:Parameter Name="Original_filiaalID" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="filiaalLocatie" Type="String" />
            <asp:Parameter Name="filiaalNaam" Type="String" />
            <asp:Parameter Name="filiaalLongitude" Type="String" />
            <asp:Parameter Name="filiaalLatitude" Type="String" />
            <asp:Parameter Name="Original_filiaalID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="filiaalLocatie" Type="String" />
            <asp:Parameter Name="filiaalNaam" Type="String" />
            <asp:Parameter Name="filiaalLongitude" Type="String" />
            <asp:Parameter Name="filiaalLatitude" Type="String" />
        </InsertParameters>
    </asp:ObjectDataSource>
</asp:Content>
