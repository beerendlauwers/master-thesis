<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="AlleArtikels.aspx.vb" Inherits="App_Presentation_AlleArtikels" title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderTitel" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:DropDownList ID="ddlBedrijf" runat="server" AutoPostBack="false">
    </asp:DropDownList>
    <asp:DropDownList ID="ddlVersie" runat="server" AutoPostBack="false">
    </asp:DropDownList>
    <asp:DropDownList ID="ddlTaal" runat="server"  AutoPostBack="false">
    </asp:DropDownList>
    <asp:Button ID="btnFilter" runat="server" Text="Filter" />
    <asp:GridView ID="GridView1" runat="server" PageSize="30" AutoGenerateColumns="False" AllowPaging="true" AllowSorting="true"
        DataSourceID="SqlDataSource1">
        <Columns>
            <asp:BoundField DataField="titel" HeaderText="titel" SortExpression="titel" />
            <asp:BoundField DataField="naam" HeaderText="naam" SortExpression="naam" />
            <asp:BoundField DataField="taaltag" HeaderText="taaltag" 
                SortExpression="taaltag" />
            <asp:BoundField DataField="versie" HeaderText="versie" 
                SortExpression="versie" />
        </Columns>
    </asp:GridView>
    
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
        ProviderName="System.Data.SqlClient" SelectCommand="select titel, B.naam, T.taaltag, V.versie 
from tblArtikel A, tblBedrijf B, tblTaal T, tblVersie V
where B.naam LIKE @naam and T.Taal LIKE @Taal AND V.versie LIKE @Versie AND A.FK_Bedrijf = B.BedrijfID AND A.FK_Taal = T.TaalID and
A.FK_Versie=V.versieID;">
        <SelectParameters>
            <asp:ControlParameter ControlID="ddlBedrijf" Name="naam" 
                PropertyName="SelectedValue" Type="String"/>
            <asp:ControlParameter ControlID="ddlTaal" Name="Taal" 
                PropertyName="SelectedValue" Type="String" />
                <asp:ControlParameter ControlID="ddlVersie" Name="Versie" PropertyName="SelectedValue" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

