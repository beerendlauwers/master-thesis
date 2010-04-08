<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="AlleArtikels.aspx.vb" Inherits="App_Presentation_AlleArtikels" title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
<title>Artikels</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderTitel" Runat="Server">
Artikels
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div id="divLoggedIn" runat="server">
    <asp:DropDownList ID="ddlBedrijf" runat="server" AutoPostBack="false">
    </asp:DropDownList>
    <asp:DropDownList ID="ddlVersie" runat="server" AutoPostBack="false">
    </asp:DropDownList>
    <asp:DropDownList ID="ddlTaal" runat="server"  AutoPostBack="false">
    </asp:DropDownList>
    &nbsp;Finaal:
    <asp:CheckBox ID="CheckBox1" runat="server" />
    <asp:Button ID="btnFilter" runat="server" Text="Filter" />
    <asp:Label ID="lblFinaal" runat="server" Visible="False"></asp:Label>
    <div id="gridview">
    <asp:GridView ID="GridView1" runat="server" PageSize="30" 
            AutoGenerateColumns="False" AllowPaging="True" AllowSorting="True"
        DataSourceID="SqlDataSource1">
        <Columns>
            <asp:BoundField DataField="titel" HeaderText="titel" SortExpression="titel" />
            <asp:BoundField DataField="tag" HeaderText="tag" SortExpression="tag" />
            <asp:BoundField DataField="naam" HeaderText="Bedrijf" SortExpression="naam" />
            <asp:BoundField DataField="taaltag" HeaderText="taaltag" 
                SortExpression="taaltag" />
            <asp:BoundField DataField="versie" HeaderText="versie" 
                SortExpression="versie" />
            <asp:CommandField ButtonType="Image" 
                SelectImageUrl="~/App_Presentation/CSS/images/magnify.png" 
                ShowSelectButton="True" />
             <asp:TemplateField Headertext="">
            <ItemTemplate >
            <asp:HyperLink ID="HyperLink1" runat="server"  NavigateUrl='<%# DataBinder.Eval(Container.DataItem,"tag","ArtikelBewerken.aspx?tag={0:c}") %>'><asp:Image ID="Image1" runat="server" ImageUrl="~/App_Presentation/CSS/images/wrench.png" /></asp:HyperLink>
            </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    </div>
    <asp:ObjectDataSource ID="objdsVersie" runat="server" DeleteMethod="Delete" 
        InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetData" TypeName="ManualTableAdapters.tblVersieTableAdapter" 
        UpdateMethod="Update">
        <DeleteParameters>
            <asp:Parameter Name="Original_VersieID" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Versie" Type="String" />
            <asp:Parameter Name="Original_VersieID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="Versie" Type="String" />
        </InsertParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="objdsTaal" runat="server" DeleteMethod="Delete" 
        InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetData" TypeName="ManualTableAdapters.tblTaalTableAdapter" 
        UpdateMethod="Update">
        <DeleteParameters>
            <asp:Parameter Name="Original_TaalID" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Taal" Type="String" />
            <asp:Parameter Name="TaalTag" Type="String" />
            <asp:Parameter Name="Original_TaalID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="Taal" Type="String" />
            <asp:Parameter Name="TaalTag" Type="String" />
        </InsertParameters>
    </asp:ObjectDataSource>
    <asp:ObjectDataSource ID="objdsBedrijf" runat="server" DeleteMethod="Delete" 
        InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetData" TypeName="ManualTableAdapters.tblBedrijfTableAdapter" 
        UpdateMethod="Update">
        <DeleteParameters>
            <asp:Parameter Name="Original_BedrijfID" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Naam" Type="String" />
            <asp:Parameter Name="Tag" Type="String" />
            <asp:Parameter Name="Original_BedrijfID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="Naam" Type="String" />
            <asp:Parameter Name="Tag" Type="String" />
        </InsertParameters>
    </asp:ObjectDataSource>
    <asp:SqlDataSource ID="SqlDataSource1" runat="server" 
        ConnectionString="Data Source=PC_VAN_FRANK\SQLEXPRESS;Initial Catalog=Reference_manual;Persist Security Info=True;User ID=beerend;Password=beerend!" 
        ProviderName="System.Data.SqlClient" SelectCommand="select titel, A.tag, B.naam, T.taaltag, V.versie 
from tblArtikel A, tblBedrijf B, tblTaal T, tblVersie V
where A.Is_final=@Is_final and B.naam LIKE @naam and T.Taal LIKE @Taal AND V.versie LIKE @Versie AND A.FK_Bedrijf = B.BedrijfID AND A.FK_Taal = T.TaalID and
A.FK_Versie=V.versieID;">
        <SelectParameters>
            <asp:ControlParameter ControlID="lblFinaal" Name="Is_final" 
                PropertyName="Text" />
            <asp:ControlParameter ControlID="ddlBedrijf" Name="naam" 
                PropertyName="SelectedValue" Type="String"/>
            <asp:ControlParameter ControlID="ddlTaal" Name="Taal" 
                PropertyName="SelectedValue" Type="String" />
                <asp:ControlParameter ControlID="ddlVersie" Name="Versie" PropertyName="SelectedValue" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
    </div>
</asp:Content>

