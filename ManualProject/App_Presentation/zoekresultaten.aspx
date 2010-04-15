<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="zoekresultaten.aspx.vb" Inherits="App_Presentation_zoekresultaten" title="Untitled Page" EnableEventValidation="true"%>
<%@ MasterType VirtualPath="~/App_Presentation/MasterPage.master" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Zoekresultaten</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderTitel" Runat="Server">
    Zoekresultaten
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

   

    <h4 style="text-align:center;" runat="server" id="headerArtikels">Artikels die overeenkomen met uw zoektekst:</h4>
    <asp:Label ID="lblSort" runat="server" Text="Klik op één van de kolommen om de items volgens deze waarde te sorteren." Visible="false" style="text-align:center;width:100%;float:right;"></asp:Label><br />
    <div id="gridview">
    <asp:UpdatePanel runat="server" ID="updZoekresultaten" EnableViewState="False"><ContentTemplate>
    <asp:GridView ID="grdResultaten" runat="server" AutoGenerateColumns="False" AllowPaging="True" 
        AllowSorting="True" Width="100%" PageSize="30" 
            PagerStyle-CssClass="gridview_pager" EmptyDataText="Geen data gevonden" 
            DataSourceID="sqldsArtikel" EnableViewState="False">
    <Columns>
            <asp:BoundField DataField="titel" HeaderText="Titel" SortExpression="titel" />
            <asp:BoundField DataField="tag" HeaderText="Tag" SortExpression="tag" />
            <asp:CommandField ButtonType="Image" 
                SelectImageUrl="~/App_Presentation/CSS/images/magnify.png" 
                ShowSelectButton="True" />
        </Columns>
        
        <pagertemplate>
         <asp:label id="lblPagina" text="Pagina:" runat="server"/><br />      
        </pagertemplate>
        
        <PagerStyle CssClass="gridview_pager" />
        
    </asp:GridView>
    <br />
    </ContentTemplate></asp:UpdatePanel>
    </div>
<br />
<br />

<asp:Label ID="lblRes" runat="server" Text=""></asp:Label>
    <asp:SqlDataSource ID="sqldsArtikel" runat="server" 
        ConnectionString="Data Source=PC_VAN_FRANK\SQLEXPRESS;Initial Catalog=Reference_manual;Persist Security Info=True;User ID=beerend;Password=beerend!" 
        ProviderName="System.Data.SqlClient" SelectCommand="Manual_theUltimateGet" 
        SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:SessionParameter DefaultValue="0" Name="bedrijfID" SessionField="bedrijf" 
                Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="versieID" SessionField="versie" 
                Type="Int32" />
            <asp:SessionParameter DefaultValue="0" Name="TaalID" SessionField="taal" 
                Type="Int32" />
            <asp:SessionParameter DefaultValue="" Name="tekst" SessionField="tag" 
                Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
    
</asp:Content>

