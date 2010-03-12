<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="invoerenTekst.aspx.vb" Inherits="App_Presentation_invoerenTest" title="Untitled Page" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor"
    TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Artikel toevoegen</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">


    <br />
    <br />
    <asp:Label ID="lbltitel" runat="server" Text="Titel: "></asp:Label>
    <asp:TextBox ID="txtTitel" runat="server"></asp:TextBox>
    <br />
    <br />
    <asp:Label ID="lblTag" runat="server" Text="Tag: "></asp:Label>
&nbsp;<asp:TextBox ID="txtTag" runat="server"></asp:TextBox>
    <br />
    <br />
    <asp:Label ID="lblCategorie" runat="server" Text="Categorie: "></asp:Label>
<asp:DropDownList ID="ddlCategorie" runat="server" DataSourceID="objdCategorie" 
        DataTextField="Categorie" DataValueField="CategorieID">
</asp:DropDownList>
    <br />
    <br />


    <asp:Label ID="lblBedrijf" runat="server" Text="Bedrijf: "></asp:Label>
    <asp:DropDownList ID="ddlBedrijf" runat="server" DataSourceID="objdBedrijf" 
        DataTextField="Naam" DataValueField="BedrijfID">
    </asp:DropDownList>
    <br />
    <br />
    <asp:Label ID="lblTaal" runat="server" Text="Taal: "></asp:Label>
    <asp:DropDownList ID="ddlTaal" runat="server" DataSourceID="objdTaal" 
        DataTextField="Taal" DataValueField="TaalID">
    </asp:DropDownList>
    <br />
    <br />


    <asp:Label ID="Label1" runat="server" Text="Versie (optioneel): "></asp:Label>
<asp:TextBox ID="txtVersie" runat="server"></asp:TextBox>


    <br />
    <br />
    <asp:Label ID="lblFinaal" runat="server" Text="Finale versie: "></asp:Label>
    <asp:CheckBox ID="ckbFinaal" runat="server" />
    <br />


    <cc1:Editor ID="Editor1" runat="server" height="300px" Width="450px"/>

    <asp:Button ID="btnTest" runat="server" Text="btnTest" />
<asp:Label ID="lblresultaat" runat="server"></asp:Label>
<br />
<br />
<asp:Button ID="btnVoegtoe" runat="server" Text="Toevoegen" />

    <asp:ObjectDataSource ID="objdTaal" runat="server" DeleteMethod="Delete" 
        InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetData" TypeName="ManualTableAdapters.tblTaalTableAdapter" 
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
    <asp:ObjectDataSource ID="objdCategorie" runat="server" DeleteMethod="Delete" 
        InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetData" TypeName="ManualTableAdapters.tblCategorieTableAdapter" 
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
    <asp:ObjectDataSource ID="objdBedrijf" runat="server" DeleteMethod="Delete" 
        InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" 
        SelectMethod="GetData" TypeName="ManualTableAdapters.tblBedrijfTableAdapter" 
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

    <br />

</asp:Content>

