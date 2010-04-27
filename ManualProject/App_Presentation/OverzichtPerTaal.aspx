<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="OverzichtPerTaal.aspx.vb" Inherits="App_Presentation_OverzichtPerTaal" title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Overzicht Per Taal</title>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderTitel" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <div runat="server" id="divLoggedIn">
<div id="gridview">
    <table>
   <tr><td>Versie</td><td>Bedrijf</td></tr><tr>
    <td><asp:DropDownList ID="ddlVersie" runat="server" DataSourceID="objdVersie" 
        DataTextField="Versie" DataValueField="VersieID"></asp:DropDownList> </td>
   <td>
    <asp:DropDownList ID="ddlBedrijf" runat="server" DataSourceID="objdBedrijf" 
        DataTextField="Naam" DataValueField="BedrijfID"></asp:DropDownList></td>
    </tr>
    </table>
    <p>Vink de talen aan die u wil vergelijken</p>
    <asp:GridView ID="GridView1" runat="server" AllowSorting="True" 
        AutoGenerateColumns="False" DataKeyNames="TaalID" DataSourceID="objdTaal">
        <Columns>
            <asp:BoundField DataField="Taal" HeaderText="Taal" SortExpression="Taal" />
            <asp:TemplateField Headertext="Selecteer">
            <ItemTemplate >
            <asp:CheckBox runat="server" Checked="false" ID="chkTaal"></asp:CheckBox>
            </ItemTemplate>
            </asp:TemplateField>
        </Columns>  
    </asp:GridView>
    <asp:Label ID="lblHiddenTalen" runat="server" Text="" style="display:none;"></asp:Label>
    &nbsp;</div>
    Enkel tonen wanneer er artikels <br />ontbreken in één van de geselecteerd Talen: 
              <asp:CheckBox ID="ckbOntbreek" runat="server" Checked="true"/>
      <asp:UpdatePanel runat="server" ID="updGrid" UpdateMode="Always">
          <ContentTemplate>
          <asp:Button ID="btnVergelijk" runat="server" Text="Vergelijk" />
          <br />
          
          <p>Hier krijgt u een overzicht van uw selectie. Een kruisje betekent dat er geen artikel aanwezig is voor die taal. Als u op het kruisje klikt kan u een artikel toevoegen voor die taal (waarbij de meeste gegevens voor u automatisch zullen worden ingevuld).</p>
          
             <div id="gridview" style="width:100%;text-align:center;">
             &nbsp;<asp:GridView width=100% ID="GridView3" OnSorting="GridView3_Sorting" runat="server" Visible ="false" AllowPaging="true" AllowSorting="true"  PageSize="20" PagerStyle-CssClass="gridview_pager">
              <Columns>
              </Columns>
              <pagertemplate>
         <asp:label id="lblPagina" text="Pagina:" runat="server"/><br />      
        </pagertemplate>
        
        <PagerStyle CssClass="gridview_pager" />
              </asp:GridView>
              &nbsp;</div>
    <asp:UpdateProgress ID="prgZoeken" runat="server" AssociatedUpdatePanelID="updGrid">
    <ProgressTemplate>
    <div class="update">
    <img src="CSS/Images/ajaxloader.gif" />
    <asp:label runat="server" id="lblProgressTekst" Text="Even geduld..."></asp:label>
    </div>
    </ProgressTemplate>
    </asp:UpdateProgress>
    <asp:Label ID="lblTest" runat="server" Text=""></asp:Label>
    </ContentTemplate>
    <Triggers>
    <asp:PostBackTrigger ControlID="btnVergelijk" />
    </Triggers>
    </asp:UpdatePanel>
    
    
    </div>
    
    <asp:ObjectDataSource ID="objdTaal" runat="server" DeleteMethod="Delete" 
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

    <asp:ObjectDataSource ID="objdsVglTaal" runat="server" InsertMethod="Insert" 
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" 
        TypeName="ManualTableAdapters.tblVglTaalTableAdapter">
        <InsertParameters>
            <asp:Parameter Name="Tag" Type="String" />
            <asp:Parameter Name="Nederlands" Type="Int32" />
            <asp:Parameter Name="Frans" Type="Int32" />
            <asp:Parameter Name="Duits" Type="Int32" />
            <asp:Parameter Name="chinees" Type="Int32" />
        </InsertParameters>
    </asp:ObjectDataSource>

    <asp:SqlDataSource ID="sqlDsVglTaal" runat="server" 
        ConnectionString="<%$ ConnectionStrings:Reference_manualConnectionString %>" 
        
        SelectCommand="SELECT * FROM [tblVglTaal]">
    </asp:SqlDataSource>
    <asp:ObjectDataSource ID="objdBedrijf" runat="server" DeleteMethod="Delete" 
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
</asp:Content>

