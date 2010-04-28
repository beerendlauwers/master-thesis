<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" EnableEventValidation="false" ValidateRequest="false" AutoEventWireup="false" CodeFile="ArtikelBewerken.aspx.vb" Inherits="App_Presentation_ArtikelBewerken" title="Untitled Page"%>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>
<%@ Register Assembly="FredCK.CKEditor" Namespace="FredCK.CKEditor" TagPrefix="FredCK" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Artikel Bewerken</title>

    <script src="JS/ckeditor/ckeditor.js" language="javascript" type="text/javascript"></script>
    <script src="JS/ckfinder/ckfinder.js" language="javascript" type="text/javascript"></script>
    <script type="text/javascript">
    function wijzigLabel(field)
    {
        var lbl = document.getElementById("ctl00_ContentPlaceHolder1_lblTagvoorbeeld");
        var dropdownIndexversie = document.getElementById('ctl00_ContentPlaceHolder1_ddlVersie').selectedIndex;
        var dropdownValueversie = document.getElementById('ctl00_ContentPlaceHolder1_ddlVersie')[dropdownIndexversie].text;
        var dropdownIndextaal = document.getElementById('ctl00_ContentPlaceHolder1_ddlTaal').selectedIndex;
        var dropdownValueTaal = document.getElementById('ctl00_ContentPlaceHolder1_ddlTaal')[dropdownIndextaal].text;
        var dropdownIndexBedrijf = document.getElementById('ctl00_ContentPlaceHolder1_ddlBedrijf').selectedIndex;
        var dropdownValueBedrijf = document.getElementById('ctl00_ContentPlaceHolder1_ddlBedrijf')[dropdownIndexBedrijf].text;
        var dropdownIndexModule = document.getElementById('ctl00_ContentPlaceHolder1_ddlModule').selectedIndex;
        var dropdownValueModule = document.getElementById('ctl00_ContentPlaceHolder1_ddlModule')[dropdownIndexModule].text;
        var taaltag = document.getElementById("ctl00_ContentPlaceHolder1_lblTaalTag").innerHTML;
        if(lbl)
        {
        lbl.innerHTML = dropdownValueversie + "_" + taaltag + "_" + dropdownValueBedrijf + "_" + dropdownValueModule + "_" +  field.value;
        }
        else
        {
        alert('iets is niet gevonden');
        }
    }
    </script>
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolderTitel" runat="server">
    Artikel Bewerken
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="divLoggedIn" runat="server">
    <asp:UpdatePanel ID="updZoeken" runat="server" UpdateMode="Conditional">
<ContentTemplate>

<table>
<tr>
<th align="left">Zoekopdracht verfijnen</th>
</tr>
<tr>
<td class="lbl"><asp:Label ID="lblVersieVerfijnen" runat="server" Text="Versie: "></asp:Label></td>
<td class="ietd"><asp:DropDownList ID="ddlVersieVerfijnen" runat="server" Width="100%"></asp:DropDownList></td>
<td><span style="vertical-align:middle" id='tipVersieVerfijnen'><img src="CSS/images/help.png" alt=''/></span></td>
</tr>
<tr>
<td class="lbl"><asp:Label ID="lblTaalVerfijnen" runat="server" Text="Taal: "></asp:Label></td>
<td class="ietd"><asp:DropDownList ID="ddlTaalVerfijnen" runat="server" Width="100%"></asp:DropDownList></td>
<td><span style="vertical-align:middle" id='tipTaalVerfijnen'><img src="CSS/images/help.png" alt=''/></span></td>
</tr>
<tr>
<td class="lbl"><asp:Label ID="lblBedrijfVerfijnen" runat="server" Text="Bedrijf: "></asp:Label></td>
<td class="ietd"><asp:DropDownList ID="ddlBedrijfVerfijnen" runat="server" Width="100%"></asp:DropDownList></td>
<td><span style="vertical-align:middle" id='tipBedrijfVerfijnen'><img src="CSS/images/help.png" alt=''/></span></td>
</tr>
<tr>
<td class="lbl"><asp:Label ID="lblFinaalVerfijnen" runat="server" Text="Artikel is finaal: "></asp:Label></td>
<td class="ietd"><asp:DropDownList ID="ddlIsFInaalVerfijnen" runat="server" Width="100%"></asp:DropDownList></td>
<td><span style="vertical-align:middle" id='tipIsFinaalVerfijnen'><img src="CSS/images/help.png" alt=''/></span></td>
</tr>
<tr>
<th align="left">Zoeken op...</th>
</tr>
<tr>
    <td class="lbl">
        <asp:Label ID="lblZoekTitel" runat="server" Text="Titel of trefwoord: "></asp:Label>
    </td>
    <td>
        <asp:TextBox ID="txtZoekTitel" runat="server" Width="100%"></asp:TextBox>
        <asp:CustomValidator ID="vleZoekTitel" runat="server" 
            ClientValidationFunction="ValideerZoekTerm" ControlToValidate="txtZoekTitel" 
            Display="None" ErrorMessage="Gelieve een zoekterm in te geven." 
            OnServerValidate="ValideerZoekTerm" ValidateEmptyText="true" 
            ValidationGroup="zoekTitel"></asp:CustomValidator>
        <cc2:ValidatorCalloutExtender ID="extSearchTitel" runat="server" 
            TargetControlID="vleZoekTitel">
        </cc2:ValidatorCalloutExtender>
    </td>
    <td>
        <span id="tipZoekTitel" style="vertical-align: middle">
        <img alt="" src="CSS/images/help.png" /></span></td>
    <tr>
        <td class="lbl">
            <asp:Label ID="lblZoekTag" runat="server" Text="Artikeltag: "></asp:Label>
        </td>
        <td>
            <asp:TextBox ID="txtZoekTag" runat="server" Width="100%"></asp:TextBox>
            <asp:CustomValidator ID="vleZoekTag" runat="server" 
                ClientValidationFunction="ValideerZoekTerm" ControlToValidate="txtZoekTag" 
                Display="None" ErrorMessage="Gelieve een tag in te geven." 
                OnServerValidate="ValideerZoekTerm" ValidateEmptyText="true" 
                ValidationGroup="zoekTitel"></asp:CustomValidator>
            <cc2:ValidatorCalloutExtender ID="extZoekTag" runat="server" 
                TargetControlID="vleZoekTag">
            </cc2:ValidatorCalloutExtender>
        </td>
        <td>
            <span ID="tipZoekTag" style="vertical-align: middle">
            <img alt="" src="CSS/images/help.png" /></span></td>
    </tr>
    <tr>
        <td>
            &nbsp;</td>
        <td>
            <asp:Button ID="btnZoek" runat="server" Text="Zoeken" 
                ValidationGroup="zoekTitel" Width="100%" />
        </td>
        <td>
            <asp:UpdateProgress ID="prgZoeken" runat="server" 
                AssociatedUpdatePanelID="updZoeken" DisplayAfter="0">
                <ProgressTemplate>
                    <div style="vertical-align: middle;">
                        <img src="CSS/Images/ajaxloader.gif" /> Even wachten aub...
                    </div>
                </ProgressTemplate>
            </asp:UpdateProgress>
        </td>
    </tr>

</table>
                        
<script type="text/javascript">
<!--
function ValideerZoekTerm (source, args)
{
    // Default Value
    args.IsValid = true;

    var resultaten = document.getElementById('<%=txtZoekTag.clientID%>').value + document.getElementById('<%=txtZoekTitel.clientID%>').value;
    
    if( resultaten === '' )
        args.isValid = false;
    
}
-->
</script>

<br />
<div id="divResultatenTonen" runat="server" visible="false">
<ul class="list-menu">
            <li><a href="#" onclick="Effect.toggle('divZoekResultaten', 'slide'); return false;"><span class="l"></span><span class="r"></span>
                <span class="t"><img src="CSS/images/magnify.png" border="0" style="vertical-align:middle;" />&nbsp;Resultaten Openen / Sluiten</span></a> </li>
</ul>

</div>

  
<div id="divZoekResultaten" style="display:none;">
<div id="gridview">
            <asp:GridView ID="grdvLijst" runat="server" AutoGenerateColumns="False" Visible="true" Width="100%">
        <Columns>
            <asp:BoundField DataField="Titel" HeaderText="Titel" SortExpression="Titel" />
            <asp:BoundField DataField="Tag" HeaderText="Tag" SortExpression="Tag" />
            <asp:BoundField DataField="Versie" HeaderText="Versie" SortExpression="Versie" />
            <asp:BoundField DataField="Naam" HeaderText="Bedrijf" SortExpression="Bedrijf" />
            <asp:BoundField DataField="Taal" HeaderText="Taal" SortExpression="Taal" />
            <asp:BoundField DataField="Is_final" HeaderText="Finale Versie" 
                SortExpression="Is_final" />
            <asp:CommandField ButtonType="Image" 
                SelectImageUrl="~/App_Presentation/CSS/images/wrench.png" 
                ShowSelectButton="True" />
            <asp:BoundField DataField="ArtikelID" HeaderText="ArtikelID" SortExpression="ArtikelID" />
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
<td class="lbl">   <asp:Label ID="lblTitel" runat="server" Text="Titel: " ></asp:Label></td> 
    <td> <asp:TextBox ID="txtTitel" runat="server" Width="100%"></asp:TextBox>
        <asp:RequiredFieldValidator
        ID="vleTitel" runat="server" ErrorMessage="Gelieve een titel in te geven." 
        ControlToValidate="txtTitel" Display="None" ValidationGroup="bewerkTekst"></asp:RequiredFieldValidator>
    <cc2:ValidatorCalloutExtender
            ID="extTitel" runat="server" TargetControlID="vleTitel">
        </cc2:ValidatorCalloutExtender>
    </td> 
    <td>
    <span style="vertical-align:middle" id='tipTitel'><img src="CSS/images/help.png" alt=''/></span>
    </td>
  </tr>
  <tr>  
   <td class="lbl">  <asp:Label ID="lblTag" runat="server" Text="Tag:"></asp:Label></td> 
   

   <td>  <asp:TextBox ID="txtTag" runat="server" Width="100%" TabIndex="-1" onkeyup="wijzigLabel(this)"></asp:TextBox>

       
   <asp:RequiredFieldValidator
        ID="vleTag" runat="server" Display="None" 
        ErrorMessage="Gelieve een tag in te geven. Deze mag enkel letters, nummers en een underscore ( _ ) bevatten." 
        ControlToValidate="txtTag" ValidationGroup="bewerkTekst"></asp:RequiredFieldValidator>
    <cc2:ValidatorCalloutExtender
            ID="extTag" runat="server" TargetControlID="vleTag">
        </cc2:ValidatorCalloutExtender>
    <cc2:FilteredTextBoxExtender ID="fltTag" runat="server" 
        FilterType="Custom, Numbers, UppercaseLetters, LowercaseLetters" TargetControlID="txtTag" 
        ValidChars="."></cc2:FilteredTextBoxExtender>
        <span id="lblTaalTag" runat="server" style="display:none;"></span>
        <script type="text/javascript">
    function wijzigLabel(field)
    {
        var lbl = document.getElementById("ctl00_ContentPlaceHolder1_lblTagvoorbeeld");
        var dropdownIndexversie = document.getElementById('ctl00_ContentPlaceHolder1_ddlVersie').selectedIndex;
        var dropdownValueversie = document.getElementById('ctl00_ContentPlaceHolder1_ddlVersie')[dropdownIndexversie].text;
        var dropdownIndextaal = document.getElementById('ctl00_ContentPlaceHolder1_ddlTaal').selectedIndex;
        var dropdownValueTaal = document.getElementById('ctl00_ContentPlaceHolder1_ddlTaal')[dropdownIndextaal].text;
        var dropdownIndexBedrijf = document.getElementById('ctl00_ContentPlaceHolder1_ddlBedrijf').selectedIndex;
        var dropdownValueBedrijf = document.getElementById('ctl00_ContentPlaceHolder1_ddlBedrijf')[dropdownIndexBedrijf].text;
        var dropdownIndexModule = document.getElementById('ctl00_ContentPlaceHolder1_ddlModule').selectedIndex;
        var dropdownValueModule = document.getElementById('ctl00_ContentPlaceHolder1_ddlModule')[dropdownIndexModule].text;
        var taaltag = document.getElementById("ctl00_ContentPlaceHolder1_lblTaalTag").innerHTML;
        if(lbl)
        {
        lbl.innerHTML = dropdownValueversie + "_" + taaltag + "_" + dropdownValueBedrijf + "_" + dropdownValueModule + "_" +  field.value;
        }
        else
        {
        alert('iets is niet gevonden');
        }
    }
    </script>
   </td>
   <td>
   <span style="vertical-align:middle" id='tipTag'><img src="CSS/images/help.png" alt=''/></span>
   </td></tr> 
   <tr><td></td><td>
<span id="lblTagvoorbeeld" name="Tagvoorbeeld" runat="server"></span>
</td></tr>    
   <tr ><td class="lbl">&nbsp</td>
   <td runat="server" id="trRadio" name="trRad">
   <asp:RadioButton ID="rdbAlleTalen" runat="server" GroupName="Tag"  />Tag voor alle talen,alle bedrijven en alle versies wijzigen waar deze Tag voorkomt.<br />
   <asp:RadioButton ID="rdbTalenperVersieBedrijf" runat="server" GroupName="Tag" />Tag voor Alle talen,alleen in deze versie en dit bedrijf. 
       <br> </br><br />
   <asp:RadioButton ID="rdbEnkeleTaal" runat="server" GroupName="Tag" Checked="true" />Alleen tag in deze taal wijzigen.
   
   </td></tr>         
    <tr>
    <td class="lbl"><asp:Label ID="lblModule" runat="server" Text="Module: "></asp:Label></td>
    <td>
        <asp:DropDownList ID="ddlModule" runat="server" DataSourceID="objdModule" 
            DataTextField="module" DataValueField="module" AutoPostBack="true">
        </asp:DropDownList>
    </td>
    </tr>
<tr>
<td class="lbl"><asp:Label ID="lblTaal" runat="server" Text="Taal:"></asp:Label></td>
<td><asp:DropDownList ID="ddlTaal" runat="server" AutoPostBack="true" Width="100%">
    </asp:DropDownList>
</td>
    
<td>
<span style="vertical-align:middle" id='tipTaal'><img src="CSS/images/help.png" alt=''/></span>
</td>
</tr>

<tr>
<td class="lbl"><asp:Label ID="lblBedrijf" runat="server" Text="Bedrijf:"></asp:Label></td>
<td><asp:DropDownList ID="ddlBedrijf" runat="server" AutoPostBack="true" Width="100%">
    </asp:DropDownList>
</td>
<td>
<span style="vertical-align:middle" id='tipBedrijf'><img src="CSS/images/help.png" alt=''/></span>
</td>
</tr>

<tr>
<td class="lbl"><asp:Label ID="lblVersie" runat="server" Text="Versie:"></asp:Label></td>
<td><asp:DropDownList ID="ddlVersie" runat="server" AutoPostBack="true" Width="100%"> 
    </asp:DropDownList>
</td>
<td>
<span style="vertical-align:middle" id='tipVersie'><img src="CSS/images/help.png" alt=''/></span>
</td>
</tr>

<tr>
<td class="lbl"><asp:Label ID="lblCategorie" runat="server" Text="Categorie:"></asp:Label></td>
<td class="ietd"><asp:DropDownList ID="ddlCategorie" runat="server" Width="100%"></asp:DropDownList>
    
    
    <asp:Label ID="lblGeenCategorie" runat="server" Text="Er zijn geen categorieën beschikbaar." Visible="false"></asp:Label>
<asp:HyperLink ID="hplAddCategorie" runat="server" Visible="false">Categorie toevoegen</asp:HyperLink>
</td>
<td>
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
<td class="lbl"><asp:Label ID="lblIs_final" runat="server" Text="Finale versie: " 
        Visible="true"></asp:Label></td>
        <td><asp:CheckBox ID="ckbFinal" runat="server" Visible="true" />
        <span style="vertical-align:middle" id='tipFinaal'><img src="CSS/images/help.png" alt=''/></span>
        </td>
</tr>
 
    </table>
    
    <script type="text/javascript">

function namodalpopup()
{
    var mpe = $find('mpe');
    mpe.dispose();
    ctl00_contentplaceholder1_txtTag.focus();
}

function trVisible()
{
var tr = document.getElementsByName('trRad')[0];
tr.style.display="inline";
}
function trInvisible()
{
var tr = document.getElementsByName('trRad')[0];
tr.style.display="none";
}

</script>

</ContentTemplate>
</asp:UpdatePanel>

<asp:UpdatePanel ID="updContent" runat="server" UpdateMode="Conditional">
<ContentTemplate>

<table>
<tr>
<td align="center">Sjabloon selecteren&nbsp;<span style="vertical-align:middle" id='tipSjabloon'><img src="CSS/images/help.png" alt=''/></span></td>
</tr>
<tr>
<td align="center"><asp:ListBox runat="server" ID="lstSjablonen" width="100%"></asp:ListBox></td>
</tr>
<tr>
<td align="center"><asp:Button runat="server" ID="btnSjablonen" Text="Sjabloon Toevoegen" width="100%" CausesValidation="false" style="vertical-align:middle;" /></td>
</tr>
</table>
<br />
<div runat="server" id="EditorEditDiv">
    <FredCK:CKEditor runat="server" ID="EditorBewerken" Height="600"></FredCK:CKEditor>
    <script type="text/javascript">
    CKFinder.SetupCKEditor( null, 'JS/ckfinder/' );
    </script></div>
</ContentTemplate>
</asp:UpdatePanel>

</div>
<br />
<div style="text-align:center;">
        <asp:Button ID="btnUpdate" runat="server" Text="Artikel Wijzigen" style="display:none;" ValidationGroup="bewerkTekst"/>
    <asp:UpdateProgress ID="prgUpdaten" runat="server" AssociatedUpdatePanelID="updBewerken">
    <ProgressTemplate>
    <div class="update">
    <img src="CSS/Images/ajaxloader.gif" />
    Bezig met opslaan...
    </div>
    </ProgressTemplate>
    </asp:UpdateProgress>
    <div runat="server" id="divFeedback" style="display:none;">
        <asp:Image ID="imgResultaat" runat="server" ImageUrl="~/App_Presentation/CSS/images/spacer.gif" />&nbsp;<asp:Label ID="lblresultaat" runat="server"></asp:Label><br />
    </div>

</div>
        <asp:ObjectDataSource ID="objdModule" runat="server" DeleteMethod="Delete" 
            InsertMethod="Insert" OldValuesParameterFormatString="original_{0}" 
            SelectMethod="GetData" TypeName="ManualTableAdapters.tblModuleTableAdapter" 
            UpdateMethod="Update">
            <DeleteParameters>
                <asp:Parameter Name="Original_moduleID" Type="Int32" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="_module" Type="String" />
                <asp:Parameter Name="Original_moduleID" Type="Int32" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="_module" Type="String" />
            </InsertParameters>
        </asp:ObjectDataSource>
</ContentTemplate>
</asp:UpdatePanel>
</div>
</asp:Content>


