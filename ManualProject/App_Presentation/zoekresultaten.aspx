<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="zoekresultaten.aspx.vb" Inherits="App_Presentation_zoekresultaten" title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderTitel" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<h4>Artikels die overeenkomen met u zoektekst:</h4>
    <asp:Label ID="lblSort" runat="server" Text="Klik op 1 van de kolommen om de items volgens deze waarde te sorteren." Visible="false"></asp:Label>
    <div id="gridview">
    <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" AllowPaging="true" 
        AllowSorting="True" DataSourceID="sqldsArtikel">
    <Columns>
            <asp:BoundField DataField="titel" HeaderText="titel" SortExpression="titel" />
            <asp:BoundField DataField="tag" HeaderText="tag" SortExpression="tag" />
            <asp:BoundField DataField="Versie" HeaderText="Versie" 
                SortExpression="Versie" />
            <asp:BoundField DataField="taal" HeaderText="taal" SortExpression="taal" />
            <asp:CommandField ButtonType="Image" 
                SelectImageUrl="~/App_Presentation/CSS/images/Glass.png" 
                ShowSelectButton="True"/>
        </Columns>
    </asp:GridView>
    </div>

<br />
<br />

<asp:Label ID="lblRes" runat="server" Text=""></asp:Label>
    <asp:SqlDataSource ID="sqldsArtikel" runat="server" 
        ConnectionString="Data Source=PC_VAN_FRANK\SQLEXPRESS;Initial Catalog=Reference_manual;Persist Security Info=True;User ID=beerend;Password=beerend!" 
        ProviderName="System.Data.SqlClient" SelectCommand="Manual_theUltimateGet" 
        SelectCommandType="StoredProcedure">
        <SelectParameters>
            <asp:QueryStringParameter Name="bedrijfID" QueryStringField="bedrijfID" 
                Type="Int32" />
            <asp:QueryStringParameter Name="versieID" QueryStringField="versieID" 
                Type="Int32" />
            <asp:QueryStringParameter Name="TaalID" QueryStringField="TaalID" 
                Type="Int32" />
            <asp:QueryStringParameter Name="tekst" QueryStringField="tag" Type="String" />
        </SelectParameters>
    </asp:SqlDataSource>
</asp:Content>

