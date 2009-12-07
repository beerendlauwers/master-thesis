<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="AutoBeheer.aspx.vb" Inherits="App_Presentation_Webpaginas_Beheer_AutoBeheer" title="Untitled Page" %>


<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" Runat="Server">

<table>
<tr>
<td>
    <asp:Button ID="btnNieuweAuto" runat="server" Text="Nieuwe Auto" />
</td>
<td>

</td>
</tr>
<tr>
<td>
    &nbsp;</td>
<td>
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 
    &nbsp;</td>
<td>
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
</td>
    <td>
        <asp:DropDownList ID="ddlKleur" runat="server" AutoPostBack="True">
        </asp:DropDownList>
    </td>
    <td>
        <asp:DropDownList ID="ddlBouwjaar" runat="server" AutoPostBack="True">
        </asp:DropDownList>
    </td>
    <td>
        <asp:DropDownList ID="ddlMerk" runat="server" AutoPostBack="True">
        </asp:DropDownList>
    </td>
    <td>
        <asp:DropDownList ID="ddlBrandstof" runat="server" AutoPostBack="True">
        </asp:DropDownList>
    </td>
    
</tr>
</table>

<asp:Label ID="Label2" runat="server" Text="Auto's volgens zoek-criteria: "></asp:Label>
    
    <asp:GridView ID="GridView1" runat="server" AllowPaging="True" 
        AllowSorting="True" AutoGenerateColumns="False" DataSourceID="SqlDataSource1" 
        Height="16px" Width="715px">
        <Columns>
            <asp:BoundField DataField="merkNaam" HeaderText="merk" 
                SortExpression="merkNaam" />
            <asp:BoundField DataField="modelNaam" HeaderText="model" 
                SortExpression="modelNaam" />
            <asp:BoundField DataField="autostatusNaam" HeaderText="status" 
                SortExpression="autostatusNaam" />
            <asp:BoundField DataField="filiaalNaam" HeaderText="filiaal" 
                SortExpression="filiaalNaam" />
            <asp:BoundField DataField="autoKenteken" HeaderText="Kenteken" 
                SortExpression="autoKenteken" />

            <asp:BoundField DataField="autoBouwjaar" HeaderText="Bouwjaar" 
                SortExpression="autoBouwjaar" />

            <asp:TemplateField Headertext="">
            <ItemTemplate >
            <asp:HyperLink ID="HyperLink1" runat="server"  NavigateUrl='<%# DataBinder.Eval(Container.DataItem,"autoKenteken","Auto.aspx?autoKenteken={0}") %>' Tooltip="details"><asp:Image ID="Image1" runat="server" ImageUrl="~/App_Presentation/images/wrench.png" /></asp:HyperLink>
            </ItemTemplate>
            </asp:TemplateField>
            
            <asp:TemplateField Headertext="">
            <ItemTemplate>
            <asp:HyperLink ID="HyperLink1" runat="server"  NavigateUrl='<%# DataBinder.Eval(Container.DataItem,"autoKenteken","Auto.aspx?autoKenteken={0}") %>' Tooltip="details"><asp:Image ID="Image1" runat="server" ImageUrl="~/App_Presentation/images/tick.gif" /></asp:HyperLink>
            </ItemTemplate>
            </asp:TemplateField>

            </Columns>
    </asp:GridView>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString="<%$ ConnectionStrings:frankRemoteDB %>" 
        SelectCommand="SELECT tblAuto.autoKleur, tblAuto.autoKenteken, tblAuto.autoBouwjaar, tblAutostatus.autostatusNaam, tblMerk.merkNaam, tblParkeerPlaats.parkeerPlaatsKolom, tblParkeerPlaats.parkeerPlaatsRij, tblModel.modelNaam, tblBrandstof.brandstofNaam, tblFiliaal.filiaalNaam FROM tblAuto INNER JOIN tblAutostatus ON tblAuto.statusID = tblAutostatus.autostatusID INNER JOIN tblFiliaal ON tblAuto.filiaalID = tblFiliaal.filiaalID INNER JOIN tblBrandstof ON tblAuto.brandstofID = tblBrandstof.brandstofID INNER JOIN tblModel ON tblAuto.modelID = tblModel.modelID INNER JOIN tblMerk ON tblModel.merkID = tblMerk.merkID INNER JOIN tblParkeerPlaats ON tblAuto.parkeerPlaatsID = tblParkeerPlaats.parkeerPlaatsID AND tblFiliaal.filiaalID = tblParkeerPlaats.filiaalID WHERE tblAuto.autoKleur LIKE @autoKleur AND tblMerk.merkNaam LIKE @autoMerk AND tblBrandstof.brandstofNaam LIKE @autoBrandstof AND tblAuto.autoBouwjaar LIKE @autoBouwjaar ">
		<SelectParameters>
           
            <asp:ControlParameter ControlID="ddlBouwjaar" Name="autoBouwjaar" PropertyName="Text" 
                Type="String"/>
            <asp:ControlParameter ControlID="ddlKleur" Name="autoKleur" PropertyName="Text" 
                Type="String"/>
            <asp:ControlParameter ControlID="ddlMerk" Name="autoMerk" PropertyName="Text" 
                Type="String"/>
            <asp:ControlParameter ControlID="ddlBrandstof" Name="autoBrandstof" PropertyName="Text" 
                Type="String"/>
            
                
                
        </SelectParameters>
    </asp:SqlDataSource>
<asp:ObjectDataSource ID="obdsKenteken" runat="server" DeleteMethod="Delete" 
        InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetData" TypeName="AutosTableAdapters.tblAutoTableAdapter" 
        UpdateMethod="Update">
    <DeleteParameters>
        <asp:Parameter Name="Original_autoID" Type="Int32" />
    </DeleteParameters>
    <UpdateParameters>
        <asp:Parameter Name="categorieID" Type="Int32" />
        <asp:Parameter Name="modelID" Type="Int32" />
        <asp:Parameter Name="autoKleur" Type="String" />
        <asp:Parameter Name="autoBouwjaar" Type="Int32" />
        <asp:Parameter Name="brandstofID" Type="Int32" />
        <asp:Parameter Name="autoKenteken" Type="String" />
        <asp:Parameter Name="autoDagTarief" Type="Double" />
        <asp:Parameter Name="autoKMTotOlieVerversing" Type="Double" />
        <asp:Parameter Name="statusID" Type="Int32" />
        <asp:Parameter Name="filiaalID" Type="Int32" />
        <asp:Parameter Name="parkeerPlaatsID" Type="Int32" />
        <asp:Parameter Name="Original_autoID" Type="Int32" />
    </UpdateParameters>
    <InsertParameters>
        <asp:Parameter Name="categorieID" Type="Int32" />
        <asp:Parameter Name="modelID" Type="Int32" />
        <asp:Parameter Name="autoKleur" Type="String" />
        <asp:Parameter Name="autoBouwjaar" Type="Int32" />
        <asp:Parameter Name="brandstofID" Type="Int32" />
        <asp:Parameter Name="autoKenteken" Type="String" />
        <asp:Parameter Name="autoDagTarief" Type="Double" />
        <asp:Parameter Name="autoKMTotOlieVerversing" Type="Double" />
        <asp:Parameter Name="statusID" Type="Int32" />
        <asp:Parameter Name="filiaalID" Type="Int32" />
        <asp:Parameter Name="parkeerPlaatsID" Type="Int32" />
    </InsertParameters>
    </asp:ObjectDataSource>
<asp:ObjectDataSource ID="obdsCategorie" runat="server" 
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" 
        TypeName="AutosTableAdapters.tblCategorieTableAdapter"></asp:ObjectDataSource>
<asp:ObjectDataSource ID="obdsMerk" runat="server" DeleteMethod="Delete" 
        InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetData" TypeName="AutosTableAdapters.tblMerkTableAdapter" 
        UpdateMethod="Update">
    <DeleteParameters>
        <asp:Parameter Name="Original_merkID" Type="Int32" />
    </DeleteParameters>
    <UpdateParameters>
        <asp:Parameter Name="merkNaam" Type="String" />
        <asp:Parameter Name="Original_merkID" Type="Int32" />
    </UpdateParameters>
    <InsertParameters>
        <asp:Parameter Name="merkNaam" Type="String" />
    </InsertParameters>
    </asp:ObjectDataSource>
<asp:ObjectDataSource ID="obdsbrandstof" runat="server" DeleteMethod="Delete" 
        InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetData" TypeName="AutosTableAdapters.tblBrandstofTableAdapter" 
        UpdateMethod="Update">
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



</asp:Content>


