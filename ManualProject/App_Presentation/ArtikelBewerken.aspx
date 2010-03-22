<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="ArtikelBewerken.aspx.vb" Inherits="App_Presentation_ArtikelBewerken" title="Untitled Page"%>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor"
    TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolderTitel" runat="server">
    Artikel Bewerken
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <asp:UpdatePanel ID="updZoeken" runat="server" UpdateMode="Conditional">
<ContentTemplate>

<table>

<tr>
<td><asp:Label ID="lblZoekTitel" runat="server" Text="Zoek op titel: "></asp:Label></td>
<td><asp:TextBox ID="txtZoekTitel" runat="server"></asp:TextBox>
<asp:RequiredFieldValidator
        ID="vleZoekTitel" runat="server" ErrorMessage="Gelieve een titel in te geven." 
        ControlToValidate="txtZoekTitel" Display="None"></asp:RequiredFieldValidator>
    <cc2:ValidatorCalloutExtender
            ID="extZoekTitel" runat="server" TargetControlID="vleZoekTitel">
        </cc2:ValidatorCalloutExtender>
        <span style="vertical-align:middle" id='tipZoekTitel'><img src="CSS/images/help.png" alt=''/></span>
</td>
</tr>

<tr>
<td colspan="2"><asp:Button ID="btnZoek" runat="server" Text="Zoeken" Width="100%" /></td>
<td><asp:UpdateProgress ID="prgZoeken" runat="server" DisplayAfter="0" AssociatedUpdatePanelID="updZoeken">
                            <ProgressTemplate>
                                <div style="vertical-align:middle">
                                    <img src="CSS/Images/ajaxloader.gif" />
                                    Even wachten aub...
                                </div>
                            </ProgressTemplate>
                        </asp:UpdateProgress></td>
</tr>

</table>
                        
        

<br />
<div id="divResultatenTonen" runat="server" visible="false">
<ul class="list-menu">
            <li><a href="#" onclick="Effect.toggle('divZoekResultaten', 'slide'); return false;"><span class="l"></span><span class="r"></span>
                <span class="t"><img src="CSS/images/magnify.png" border="0" style="vertical-align:middle;" />&nbsp;Resultaten Openen / Sluiten</span></a> </li>
</ul>

</div>
<div id="divZoekResultaten" style="display:none;">
<div id="gridview">
            <asp:GridView ID="grdvLijst" runat="server" AutoGenerateColumns="False" Visible="false" Width="100%">
        <Columns>
            <asp:BoundField DataField="Titel" HeaderText="Titel" SortExpression="Titel" />
            <asp:BoundField DataField="Tag" HeaderText="Tag" SortExpression="Tag" />
            <asp:BoundField DataField="Versie" HeaderText="Versie" 
                SortExpression="Versie" />
            <asp:BoundField DataField="Naam" HeaderText="Bedrijf" SortExpression="Bedrijf" />
            <asp:BoundField DataField="Taal" HeaderText="Taal" SortExpression="Taal" />
            <asp:CommandField ButtonType="Image" 
                SelectImageUrl="~/App_Presentation/CSS/images/wrench.png" 
                ShowSelectButton="True" />
        </Columns>
    </asp:GridView>
</div>

</div>


</ContentTemplate>
</asp:UpdatePanel>
<br />
    <asp:UpdatePanel ID="updBewerken" runat="server" UpdateMode="conditional">
    <ContentTemplate>

<div runat="server" id="divInvullen">
    
        <asp:UpdatePanel ID="updCategorie" runat="server" UpdateMode="conditional">
    <ContentTemplate>
    
<table>
<tr>
<td>   <asp:Label ID="lblTitel" runat="server" Text="Titel:"></asp:Label></td> 
    <td> <asp:TextBox ID="txtTitel" runat="server"></asp:TextBox>
        <asp:RequiredFieldValidator
        ID="vleTitel" runat="server" ErrorMessage="Gelieve een titel in te geven." 
        ControlToValidate="txtTitel" Display="None"></asp:RequiredFieldValidator>
    <cc2:ValidatorCalloutExtender
            ID="extTitel" runat="server" TargetControlID="vleTitel">
        </cc2:ValidatorCalloutExtender>
        <span style="vertical-align:middle" id='tipTitel'><img src="CSS/images/help.png" alt=''/></span>
    </td> 
  </tr><tr>  
   <td>  <asp:Label ID="lblTag" runat="server" Text="Tag:"></asp:Label></td> 
   <td>  <asp:TextBox ID="txtTag" runat="server"></asp:TextBox>
   <asp:RequiredFieldValidator
        ID="vleTag" runat="server" Display="None" 
        ErrorMessage="Gelieve een tag in te geven. Deze mag enkel letters, nummers en een underscore ( _ ) bevatten." 
        ControlToValidate="txtTag"></asp:RequiredFieldValidator>
    <cc2:ValidatorCalloutExtender
            ID="extTag" runat="server" TargetControlID="vleTag">
        </cc2:ValidatorCalloutExtender>
    <cc2:FilteredTextBoxExtender ID="fltTag" runat="server" 
        FilterType="Custom, Numbers, UppercaseLetters, LowercaseLetters" TargetControlID="txtTag" 
        ValidChars="_"></cc2:FilteredTextBoxExtender>
                <span style="vertical-align:middle" id='tipTag'><img src="CSS/images/help.png" alt=''/></span></td> 
  </tr>
  
 
 
<tr>
<td><asp:Label ID="lblTaal" runat="server" Text="Taal:"></asp:Label></td>
<td><asp:DropDownList ID="ddlTaal" runat="server" DataSourceID="objdTaal" 
        DataTextField="Taal" DataValueField="TaalID" AutoPostBack="true">
    </asp:DropDownList>
<span style="vertical-align:middle" id='tipTaal'><img src="CSS/images/help.png" alt=''/></span></td>
</tr>

<tr>
<td><asp:Label ID="lblBedrijf" runat="server" Text="Bedrijf:"></asp:Label></td>
<td><asp:DropDownList ID="ddlBedrijf" runat="server" DataSourceID="objdBedrijf" 
        DataTextField="Naam" DataValueField="BedrijfID" AutoPostBack="true">
    </asp:DropDownList>
                        <span style="vertical-align:middle" id='tipBedrijf'><img src="CSS/images/help.png" alt=''/></span>
</td>
</tr>

<tr>
<td><asp:Label ID="lblVersie" runat="server" Text="Versie:"></asp:Label></td>
<td><asp:DropDownList ID="ddlVersie" runat="server" DataSourceID="objdVersie" 
    DataTextField="Versie" DataValueField="VersieID" AutoPostBack="true">
    </asp:DropDownList>
    <span style="vertical-align:middle" id='tipVersie'><img src="CSS/images/help.png" alt=''/></span>
</td>
</tr>

<tr>
<td><asp:Label ID="lblCategorie" runat="server" Text="Categorie:"></asp:Label></td>
<td><asp:DropDownList ID="ddlCategorie" runat="server"></asp:DropDownList>
    <asp:Label ID="lblGeenCategorie" runat="server" Text="Er zijn geen categorieën beschikbaar." Visible="false"></asp:Label>
<span style="vertical-align:middle" id='tipCategorie'><img src="CSS/images/help.png" alt=''/></span>
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
<td><asp:Label ID="lblIs_final" runat="server" Text="Artikel is finaal: " 
        Visible="False"></asp:Label></td>
        <td<asp:CheckBox ID="ckbFinal" runat="server" Visible="false" />></td>
</tr>
 
    </table>  

</ContentTemplate>
</asp:UpdatePanel>
    
    <cc1:Editor ID="Editor1" runat="server" Height="300px" Width="100%"/>
   
</div>
<br />
<div style="text-align:center;">
        <asp:Button ID="btnUpdate" runat="server" Text="Artikel Wijzigen" Visible="false"/>
    <asp:UpdateProgress ID="prgUpdaten" runat="server" AssociatedUpdatePanelID="updBewerken">
    <ProgressTemplate>
    <div class="update">
    <img src="CSS/Images/ajaxloader.gif" />
    Bezig met opslaan...
    </div>
    </ProgressTemplate>
    </asp:UpdateProgress>
    <div runat="server" id="divFeedback" visible="false">
        <asp:Image ID="imgResultaat" runat="server" />&nbsp;<asp:Label ID="lblresultaat" runat="server"></asp:Label><br />
    </div>

</div>

</ContentTemplate>
</asp:UpdatePanel>



    
    <asp:ObjectDataSource ID="objdVersie" runat="server" 
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


