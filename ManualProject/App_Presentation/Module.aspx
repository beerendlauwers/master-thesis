<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="Module.aspx.vb" Inherits="App_Presentation_Module" title="Untitled Page" %>
<%@ MasterType VirtualPath="~/App_Presentation/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderTitel" Runat="Server">
    <asp:Label ID="lblTitel" runat="server" Text=""></asp:Label>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <br/>
    <div id="gridview">
    <asp:UpdatePanel ID="updModuleOverzicht" runat="server">
   <ContentTemplate>

    <asp:DropDownList ID="ddlModule" runat="server" DataTextField="tag" DataValueField="tag"  
         AutoPostBack="true">
    </asp:DropDownList>
       <asp:Label ID="lblDropdown" runat="server" Text=""></asp:Label>
       &nbsp;&nbsp;
       <asp:CheckBox ID="ckbModules" runat="server" AutoPostBack="True" 
           Checked="true" />
       <asp:Label ID="lblCkb" runat="server" 
           Text=""></asp:Label>
    <asp:GridView ID="grdvmodule" runat="server" AutoGenerateColumns="False" 
        DataKeyNames="ArtikelID" AllowPaging="True" 
           PagerStyle-CssClass="gridview_pager" AllowSorting="True" PageSize="30" 
           Width="100%">
        <Columns>
            <asp:BoundField DataField="Titel" HeaderText="Titel" SortExpression="Titel" />
            <asp:BoundField DataField="ArtikelID" HeaderText="ArtikelID" 
                InsertVisible="False" ReadOnly="True" SortExpression="ArtikelID" />
            <asp:TemplateField Headertext="">
            <ItemTemplate >
            <asp:HyperLink ID="HyperLink1" runat="server"  NavigateUrl='<%# DataBinder.Eval(Container.DataItem,"ArtikelID","Page.aspx?id={0}") %>'><asp:Image ID="Image1" runat="server" ImageUrl="~/App_Presentation/CSS/images/magnify.png" /></asp:HyperLink>
            </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <pagertemplate>
         <asp:label id="lblPagina" text="Pagina:" runat="server"/><br />      
        </pagertemplate>
                <PagerStyle CssClass="gridview_pager" />
    </asp:GridView>    
    </ContentTemplate>
    </asp:UpdatePanel></div>
   </asp:Content>

