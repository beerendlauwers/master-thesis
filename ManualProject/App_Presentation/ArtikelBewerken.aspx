<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="ArtikelBewerken.aspx.vb" Inherits="App_Presentation_ArtikelBewerken" title="Untitled Page" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor"
    TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:UpdatePanel ID="UpdatePanel3" runat="server">

<ContentTemplate>
<asp:UpdateProgress ID="UpdateProgress3" runat="server" DisplayAfter="0">
                            <ProgressTemplate>
                                <div class="updatetop">
                                    <img src="CSS/Images/ajaxloader.gif" />
                                    Even wachten aub...
                                </div>
                            </ProgressTemplate>
                        </asp:UpdateProgress>
<asp:Label ID="lblSearch" runat="server" Text="Zoek: "></asp:Label>
        <asp:TextBox ID="txtSearch" runat="server"></asp:TextBox>
        &nbsp;&nbsp;
        <asp:Button ID="btnZoek" runat="server" Text="zoeken" />

    <br />
    
    
            <%--<asp:ListBox ID="lsbArtikels" runat="server" Visible="False"></asp:ListBox>--%>
            <asp:GridView ID="grdvLijst" runat="server" AutoGenerateColumns="False" Visible="false">
        <Columns>
            <%--<asp:BoundField DataField="ArtikelID" HeaderText="ArtikelID" 
                SortExpression="ArtikelID" />--%>
            <asp:BoundField DataField="Titel" HeaderText="Titel" SortExpression="Titel" />
            <asp:BoundField DataField="Tag" HeaderText="Tag" SortExpression="Tag" />
            <asp:BoundField DataField="Versie" HeaderText="Versie" 
                SortExpression="Versie" />
            <asp:BoundField DataField="Naam" HeaderText="Naam" SortExpression="Bedrijf" />
            <asp:BoundField DataField="Taal" HeaderText="Taal" SortExpression="Taal" />
            <asp:CommandField ButtonType="Image" 
                SelectImageUrl="~/App_Presentation/CSS/images/wrench.png" 
                ShowSelectButton="True" />
        </Columns>
    </asp:GridView>
&nbsp;<div id="gridview">

</div>
            <br />
   
    
<%--<asp:Button ID="btnBewerken" runat="server" Text="bewerken" Visible="False" OnClick="btnBewerken_Click" />
--%>    
    <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="conditional">
    <ContentTemplate>
<table>
<tr>
<td>   <asp:Label ID="lblTitel" runat="server" Text="Titel: " Visible="false"></asp:Label></td> 
    <td> <asp:TextBox ID="txtTitel" runat="server" Visible="false"></asp:TextBox></td> 
  </tr><tr>  
   <td>  <asp:Label ID="lblTag" runat="server" Text="Tag: " Visible="false"></asp:Label></td> 
   <td>  <asp:TextBox ID="txtTag" runat="server" Visible="false"></asp:TextBox></td> 
  </tr><tr>  
    <td> <asp:Label ID="lblCategorie" runat="server" Text="Categorie: " Visible="false"></asp:Label></td> 
    <td> <asp:DropDownList ID="ddlCategorie" runat="server" DataSourceID="objdCategorie" 
        DataTextField="Categorie" DataValueField="CategorieID" Visible="false" >
    </asp:DropDownList></td> 
  </tr><tr>  
    <td> <asp:Label ID="lblVersie" runat="server" Text="Versie: " Visible="false"></asp:Label></td> 
    <td> <asp:DropDownList ID="ddlVersie" runat="server" 
        DataSourceID="ObjectDataSource1" DataTextField="Versie" 
        DataValueField="VersieID" Visible="false">
    </asp:DropDownList></td> 
  </tr><tr>
   <td>  <asp:Label ID="lblTaal" runat="server" Text="Taal: " Visible="false"></asp:Label></td> 
   <td>  <asp:DropDownList ID="ddlTaal" runat="server" DataSourceID="objdTaal" 
        DataTextField="Taal" DataValueField="TaalID" Visible="false">
    </asp:DropDownList></td> 
  </tr><tr>  
    <td> <asp:Label ID="lblBedrijf" runat="server" Text="Bedrijf: " Visible="false"></asp:Label></td> 
   <td>  <asp:DropDownList ID="ddlBedrijf" runat="server" DataSourceID="objdBedrijf" 
        DataTextField="Naam" DataValueField="BedrijfID" Visible="false">
    </asp:DropDownList></td> 
   </tr> 
    </table>  
    &nbsp;
    <asp:Label ID="lblIs_final" runat="server" Text="Artikel is finaal: " 
        Visible="False"></asp:Label>
    <asp:CheckBox ID="ckbFinal" runat="server" Visible="false" />
    
    <cc1:Editor ID="Editor1" runat="server" Height="300px" Width="600px" Visible="false"/>
   
<asp:Button ID="btnUpdate" runat="server" Text="Wijzig" Visible="False" />
&nbsp;<asp:Label ID="lblVar" runat="server" Visible="False"></asp:Label>
</ContentTemplate>
</asp:UpdatePanel>

</ContentTemplate>
</asp:UpdatePanel>


    



    <asp:ObjectDataSource ID="ObjectDataSource1" runat="server" 
        DeleteMethod="Delete" InsertMethod="Insert" 
        OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" 
        TypeName="ManualTableAdapters.tblVersieTableAdapter" UpdateMethod="Update">
        <DeleteParameters>
            <asp:Parameter Name="Original_VersieID" Type="Int32" />
        </DeleteParameters>
        <UpdateParameters>
            <asp:Parameter Name="Versie" Type="String" />
            <asp:Parameter Name="Original_VersieID" Type="Int32" />
        </UpdateParameters>
        <InsertParameters>
            <asp:Parameter Name="VersieID" Type="Int32" />
            <asp:Parameter Name="Versie" Type="String" />
        </InsertParameters>
    </asp:ObjectDataSource>

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



</asp:Content>


