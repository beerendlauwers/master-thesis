<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="AutoWijzigen.aspx.vb" Inherits="App_Presentation_Webpaginas_Beheer_AutoWijzigen" title="Auto wijzigen" %>
<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" Runat="Server">
<h1>Auto wijzigen</h1>
<script language="javascript" type="text/javascript">
    function CancelClick()
    {
        
    }
</script>

<table>
<tr><th colspan="2" align="center">
Algemeen Beheer
</th>
</tr>
<tr>
<td>
    <asp:Label ID="Label1" runat="server" Text="Dag-tarief: "></asp:Label>
</td>
<td>
    <asp:TextBox ID="txtTarief" runat="server"></asp:TextBox>
</td>
</tr>
<tr>
<td>
    <asp:Label ID="Label2" runat="server" Text="Km tot Olieverversing: "></asp:Label>
</td>
<td>
    <asp:TextBox ID="txtOlie" runat="server"></asp:TextBox>
</td>
</tr>

<tr>
<td>
    <asp:Label ID="Label5" runat="server" Text="Kilometerstand: "></asp:Label>
</td>
<td>
    <asp:TextBox ID="txtKilometerStand" runat="server"></asp:TextBox>
</td>
</tr>
<tr>
<td>
    <asp:Label ID="Label6" runat="server" Text="Autokenteken: "></asp:Label>
</td>
<td>
    <asp:TextBox ID="txtKenteken" runat="server"></asp:TextBox>
</td>
</tr>
<tr>
<td>
    <asp:Label ID="Label7" runat="server" Text="Tankinhoud: "></asp:Label>
</td>
<td>
    <asp:TextBox ID="txtTankinhoud" runat="server"></asp:TextBox>
</td>
</tr>
<td>
    <asp:Label ID="Label3" runat="server" Text="status van de auto: "></asp:Label>
</td>
<td>
    <asp:DropDownList ID="ddlStatus" runat="server" DataSourceID="obdsStatus" 
        DataTextField="autostatusNaam" DataValueField="autostatusID">
    </asp:DropDownList>
</td>
</tr>

<tr>
<td>
    <asp:Label ID="Label4" runat="server" Text="Kleur van de auto: "></asp:Label>
</td>
<td>
    <asp:DropDownList ID="ddlKleur" runat="server">
    </asp:DropDownList>
    <asp:Button ID="btnKleur" runat="server" Text="nieuwe kleur" />
    <asp:TextBox ID="txtKleurAdd" runat="server" Visible="False"></asp:TextBox>
    <asp:Button ID="btnkleuradd" runat="server" Text="toevoegen" Visible="False" />
</td>
</tr>
<tr><td>Filiaal:liaal:</td>


                       
                        <td>
                            
                                    <asp:DropDownList ID="ddlFiliaal" runat="server" 
                                        DataSourceID="obdsFiliaal" DataTextField="filiaalNaam" AutoPostBack="True" 
                                        DataValueField="filiaalID">
                                    </asp:DropDownList>
                               
                        </td>
                    </tr>
                    <tr>
                    <td>
                        <asp:Button ID="btnAlgemeen" runat="server" Text="Wijzigingen uitvoeren" />
                    </td>
                    <td>
                        <asp:Label ID="lblAlgemeengeslaagd" runat="server" Text=""></asp:Label>
                    </td>
                    </tr>

</table>

                                                <br />
<asp:UpdatePanel ID="updOpties" runat="server">
                    <ContentTemplate>
    <table>
                            <tr>
                                <th colspan="2" align="center">
                                    <br />
                                    Optie beheer
                                </th>
                            </tr>
                            <tr>
                                <td>
                                    Optie:
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlOpties" runat="server" 
                                        DataSourceID="obdsOptie" DataTextField="optieOmschrijving"
                                        DataValueField="optieID">
                                    </asp:DropDownList>
                                &nbsp;
                                    <asp:Button ID="btnVoegtoe" runat="server" Text="Optie Toevoegen" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="right">
                                    <asp:Label ID="lblReedsOptie" runat="server" ForeColor="Red"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="right">
                                    <asp:Button ID="btnNieuweOptie" runat="server" Text="Nieuwe Optie Aanmaken" OnClick="btnNieuweOptie_Click" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblOptieNaam" runat="server" Text="Optienaam: " Visible="False"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtOptieNaam" runat="server" Visible="False"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblOptiePrijs" runat="server" Text="Optieprijs: " 
                                        Visible="False"></asp:Label>
                                </td>
                                <td>
                                    <asp:TextBox ID="txtOptiePrijs" runat="server" Visible="False"></asp:TextBox>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="right">
                                    <asp:Button ID="btnVoegoptietoe" runat="server" OnClick="btnVoegoptietoe_Click" 
                                        Text="Toevoegen" Visible="False" />
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:ListBox ID="lstOpties" runat="server" SelectionMode="Multiple"></asp:ListBox>
                                    <asp:Button ID="btnVerwijderLijst" runat="server" OnClick="btnVerwijderLijst_Click"
                                        Text="Verwijder Optie" />
                                    <asp:ListBox ID="lstOptiesAdd" runat="server" Visible="False"></asp:ListBox>
                                </td>
                            </tr>
                            <tr><td>
                                <asp:Label ID="lblGeslaagd" runat="server" Text=""></asp:Label>
                            </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <asp:Button ID="btnOptiesWijzigen" runat="server" 
                                        Text="Optie-wijzigingen uitvoeren" />
                                    <br />
                                    <br />
                                    <asp:Button ID="btnVerwijderen" runat="server" Text="Auto Verwijderen" />
                                    <cc1:ConfirmButtonExtender ID="cbe" runat="server"
    TargetControlID="btnVerwijderen"
    ConfirmText="Bent u zeker dat u deze auto wilt verwijderen?"
    OnClientCancel="CancelClick" />
                                    <asp:Label ID="lblVerwijder" runat="server"></asp:Label>
                                    <br />
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                 </asp:UpdatePanel >
                 <%--<table>
                 
                 <tr>
                 <td>Parkeerplaats Wijzigen: 
                 </td>
                 <td>
                 <asp:UpdatePanel ID="updParkingOverzicht" runat="server" UpdateMode="Conditional">
                                <ContentTemplate>
                                    <asp:TextBox ID="txtAutoParkeerplaats" runat="server" 
                                        Text='<%# Bind("autoParkeerplaats") %>' />
                                    <asp:ImageButton ID="imgParkeerPlaats" runat="server" 
                                        ImageUrl="~/App_Presentation/Images/kalender.png" />
                                                    <br />
                                    <asp:Label ID="lblAutoParkeerplaats" runat="server"></asp:Label>
                                                    <asp:UpdateProgress ID="progress1" runat="server">
        <ProgressTemplate>
        
            <div class="progress">
                <img src="../../Images/ajax-loader.gif" />
                Even wachten aub...
            </div>
        
        </ProgressTemplate>
    </asp:UpdateProgress>
    <br />
                                    <asp:Label ID="lblGeenOverzicht" runat="server" Visible="false"></asp:Label>
                                    <asp:PlaceHolder ID="plcParkingLayout" runat="server"></asp:PlaceHolder>
                                </ContentTemplate>
                            </asp:UpdatePanel>
                 </td>
                 </tr>
                 </table>
                    --%>

    <asp:ObjectDataSource ID="obdsStatus" runat="server" 
        SelectMethod="GetAllAutoStatus" TypeName="AutoStatusBLL">
    </asp:ObjectDataSource>
    
    
    <asp:ObjectDataSource ID="obdsFiliaal" runat="server" 
        SelectMethod="GetAllFilialen" TypeName="FiliaalBLL">
    </asp:ObjectDataSource>

    <asp:ObjectDataSource ID="obdsOptie" runat="server" 
        SelectMethod="GetAllOpties" TypeName="OptieBLL"></asp:ObjectDataSource>

</asp:Content>

