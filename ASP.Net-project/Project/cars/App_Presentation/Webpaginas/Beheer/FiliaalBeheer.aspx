<%@ Page Language="VB" AutoEventWireup="false" CodeFile="FiliaalBeheer.aspx.vb" Inherits="App_Presentation_Webpaginas_FiliaalBeheer"
    MasterPageFile="~/App_Presentation/MasterPage.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Main" ContentPlaceHolderID="plcMain" runat="server">
    <asp:ScriptManager ID="scmFiliaal" runat="server"></asp:ScriptManager>
    
    <cc1:Accordion ID="FiliaalAccordion" runat="server" AutoSize="None" TransitionDuration="250">
        <Panes>
            <cc1:AccordionPane ID="PaneToevoegen" runat="server">
                <Header>Filiaal Toevoegen</Header>
                <Content>
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
                    </table>
                </Content>
            </cc1:AccordionPane>
            <cc1:AccordionPane ID="PaneVerwijderen" runat="server">
                <Header>Filiaal Verwijderen</Header>
                <Content>
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
                </table>
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
    </td> </tr> </table>
</asp:Content>
