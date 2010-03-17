<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="invoerenTekst.aspx.vb" Inherits="App_Presentation_invoerenTest" title="Untitled Page" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor"
    TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Artikel toevoegen</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<asp:UpdatePanel ID="updCategorie" runat="server">
<ContentTemplate>

<table>

<tr>
<td><asp:Label ID="lbltitel" runat="server" Text="Titel:"></asp:Label></td>
<td><asp:TextBox ID="txtTitel" runat="server"></asp:TextBox></td>
</tr>

<tr>
<td><asp:Label ID="lblTag" runat="server" Text="Tag:"></asp:Label></td>
<td><asp:TextBox ID="txtTag" runat="server"></asp:TextBox></td>
</tr>

<tr>
<td><asp:Label ID="lblTaal" runat="server" Text="Taal:"></asp:Label></td>
<td><asp:DropDownList ID="ddlTaal" runat="server" DataSourceID="objdTaal" 
        DataTextField="Taal" DataValueField="TaalID" AutoPostBack="true">
    </asp:DropDownList></td>
</tr>

<tr>
<td><asp:Label ID="lblBedrijf" runat="server" Text="Bedrijf: "></asp:Label></td>
<td><asp:DropDownList ID="ddlBedrijf" runat="server" DataSourceID="objdBedrijf" 
        DataTextField="Naam" DataValueField="BedrijfID" AutoPostBack="true">
    </asp:DropDownList></td>
</tr>

<tr>
<td><asp:Label ID="lblVersie" runat="server" Text="Versie:"></asp:Label></td>
<td><asp:DropDownList ID="ddlVersie" runat="server" DataSourceID="objdVersie" 
    DataTextField="Versie" DataValueField="VersieID" AutoPostBack="true">
    </asp:DropDownList></td>
</tr>

<tr>
<td><asp:Label ID="lblCategorie" runat="server" Text="Categorie:"></asp:Label></td>
<td><asp:DropDownList ID="ddlCategorie" runat="server" 
        DataTextField="Categorie" DataValueField="CategorieID">
</asp:DropDownList>
</td>
<td>
    <asp:UpdateProgress ID="prgCategorie" runat="server" AssociatedUpdatePanelID="updCategorie">
    <ProgressTemplate>
    <div class="update">
    <img src="CSS/Images/ajaxloader.gif" />
    Bezig met ophalen van categoriëen...
    </div>
    </ProgressTemplate>
    </asp:UpdateProgress>
</td>
</tr>

<tr>
<td><asp:Label ID="lblFinaal" runat="server" Text="Finale versie:"></asp:Label></td>
<td><asp:CheckBox ID="ckbFinaal" runat="server" /></td>
</tr>

</table>

</ContentTemplate>
</asp:UpdatePanel>

<br />

<cc1:Editor ID="Editor1" runat="server" height="450px" />

<br />
<br />
    <asp:UpdatePanel ID="updToevoegen" runat="server">
    <ContentTemplate>
<asp:Button ID="btnVoegtoe" runat="server" Text="Toevoegen" />
    <asp:UpdateProgress ID="prgToevoegen" runat="server" AssociatedUpdatePanelID="updToevoegen">
    <ProgressTemplate>
    <div class="update">
    <img src="CSS/Images/ajaxloader.gif" />
    Bezig met opslaan...
    </div>
    </ProgressTemplate>
    </asp:UpdateProgress>
<asp:Label ID="lblresultaat" runat="server"></asp:Label>
</ContentTemplate>
    </asp:UpdatePanel>


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

    <asp:ObjectDataSource ID="objdVersie" runat="server" DeleteMethod="Delete" 
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

    <br />
    </asp:Content>

