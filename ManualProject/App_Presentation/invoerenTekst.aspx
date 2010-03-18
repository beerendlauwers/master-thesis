<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="invoerenTekst.aspx.vb" Inherits="App_Presentation_invoerenTest" title="Untitled Page" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc2" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit.HTMLEditor"
    TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <title>Artikel toevoegen</title>
    
    </asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolderTitel" runat="server">Artikel Toevoegen</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

<div id="divInvullen">

<asp:UpdatePanel ID="updCategorie" runat="server">
<ContentTemplate>

<table>

<tr>
<td><asp:Label ID="lbltitel" runat="server" Text="Titel:"></asp:Label></td>
<td><asp:TextBox ID="txtTitel" runat="server"></asp:TextBox>
    <asp:RequiredFieldValidator
        ID="vleTitel" runat="server" ErrorMessage="Gelieve een titel in te geven." 
        ControlToValidate="txtTitel" Display="None"></asp:RequiredFieldValidator>
    <cc2:ValidatorCalloutExtender
            ID="extTitel" runat="server" TargetControlID="vleTitel">
        </cc2:ValidatorCalloutExtender>
        <span style="vertical-align:middle" id='tipTitel'><img src="CSS/images/help.png" alt=''/></span>
        <script type="text/javascript" language="javascript">
        //<![CDATA[
			new Tip('tipTitel', "De titel van het nieuwe artikel.",
			{   
				target: $('tipTitel'),
				hook: { target: 'rightMiddle', tip: 'leftMiddle' },
				offset: { x: 10, y: 0 },
				width: 'auto'
			 });
	    //]]>
	    </script>
</td>
</tr>

<tr>
<td><asp:Label ID="lblTag" runat="server" Text="Tag:"></asp:Label></td>
<td><asp:TextBox ID="txtTag" runat="server"></asp:TextBox><asp:RequiredFieldValidator
        ID="vleTag" runat="server" Display="None" 
        ErrorMessage="Gelieve een tag in te geven. Deze mag enkel letters, nummers en een underscore ( _ ) bevatten." 
        ControlToValidate="txtTag"></asp:RequiredFieldValidator>
    <cc2:ValidatorCalloutExtender
            ID="extTag" runat="server" TargetControlID="vleTag">
        </cc2:ValidatorCalloutExtender>
    <cc2:FilteredTextBoxExtender ID="fltTag" runat="server" 
        FilterType="Custom, Numbers, UppercaseLetters, LowercaseLetters" TargetControlID="txtTag" 
        ValidChars="_"></cc2:FilteredTextBoxExtender>
                <span style="vertical-align:middle" id='tipTag'><img src="CSS/images/help.png" alt=''/></span>
        <script type="text/javascript" language="javascript">
        //<![CDATA[
			new Tip('tipTag', "De tag van het nieuwe artikel. Mag enkel letters, nummers en een underscore ( _ ) bevatten.",
			{   
				target: $('tipTag'),
				hook: { target: 'rightMiddle', tip: 'leftMiddle' },
				offset: { x: 10, y: 0 },
				width: 'auto'
			 });
	    //]]>
	    </script>
	    </td>
</tr>

<tr>
<td><asp:Label ID="lblTaal" runat="server" Text="Taal:"></asp:Label></td>
<td><asp:DropDownList ID="ddlTaal" runat="server" DataSourceID="objdTaal" 
        DataTextField="Taal" DataValueField="TaalID" AutoPostBack="true">
    </asp:DropDownList>
                    <span style="vertical-align:middle" id='tipTaal'><img src="CSS/images/help.png" alt=''/></span>
        <script type="text/javascript" language="javascript">
        //<![CDATA[
			new Tip('tipTaal', "De taal van het nieuwe artikel.",
			{   
				target: $('tipTaal'),
				hook: { target: 'rightMiddle', tip: 'leftMiddle' },
				offset: { x: 10, y: 0 },
				width: 'auto'
			 });
	    //]]>
	    </script></td>
</tr>

<tr>
<td><asp:Label ID="lblBedrijf" runat="server" Text="Bedrijf: "></asp:Label></td>
<td><asp:DropDownList ID="ddlBedrijf" runat="server" DataSourceID="objdBedrijf" 
        DataTextField="Naam" DataValueField="BedrijfID" AutoPostBack="true">
    </asp:DropDownList>
                        <span style="vertical-align:middle" id='tipBedrijf'><img src="CSS/images/help.png" alt=''/></span>
        <script type="text/javascript" language="javascript">
        //<![CDATA[
			new Tip('tipBedrijf', "Het bedrijf waaronder dit artikel zal worden gepubliceerd.",
			{   
				target: $('tipBedrijf'),
				hook: { target: 'rightMiddle', tip: 'leftMiddle' },
				offset: { x: 10, y: 0 },
				width: 'auto'
			 });
	    //]]>
	    </script></td>
</tr>

<tr>
<td><asp:Label ID="lblVersie" runat="server" Text="Versie:"></asp:Label></td>
<td><asp:DropDownList ID="ddlVersie" runat="server" DataSourceID="objdVersie" 
    DataTextField="Versie" DataValueField="VersieID" AutoPostBack="true">
    </asp:DropDownList>
    <span style="vertical-align:middle" id='tipVersie'><img src="CSS/images/help.png" alt=''/></span>
        <script type="text/javascript" language="javascript">
        //<![CDATA[
			new Tip('tipVersie', "De versie waartoe het nieuwe artikel toebehoort. Dit nummer slaat op de versie van de applicatie, en niet op de versie van het artikel.",
			{   
				target: $('tipVersie'),
				hook: { target: 'rightMiddle', tip: 'leftMiddle' },
				offset: { x: 10, y: 0 },
				width: 'auto'
			 });
	    //]]>
	    </script></td>
</tr>

<tr>
<td><asp:Label ID="lblCategorie" runat="server" Text="Categorie:"></asp:Label></td>
<td><asp:DropDownList ID="ddlCategorie" runat="server" 
        DataTextField="Categorie" DataValueField="CategorieID">
</asp:DropDownList>
<span style="vertical-align:middle" id='tipCategorie'><img src="CSS/images/help.png" alt=''/></span>
        <script type="text/javascript" language="javascript">
        //<![CDATA[
			new Tip('tipCategorie', "De categorie waaronder dit artikel zal worden gepubliceerd. De 'root_node' categorie is het beginpunt van de structuur.",
			{   
				target: $('tipCategorie'),
				hook: { target: 'rightMiddle', tip: 'leftMiddle' },
				offset: { x: 10, y: 0 },
				width: 'auto'
			 });
	    //]]>
	    </script>
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
<td><asp:CheckBox ID="ckbFinaal" runat="server" />
<span style="vertical-align:middle" id='tipFinaal'><img src="CSS/images/help.png" alt=''/></span>
        <script type="text/javascript" language="javascript">
        //<![CDATA[
			new Tip('tipFinaal', "Bepaalt of het artikel gefinaliseerd is of niet.",
			{   
				target: $('tipFinaal'),
				hook: { target: 'rightMiddle', tip: 'leftMiddle' },
				offset: { x: 10, y: 0 },
				width: 'auto'
			 });
	    //]]>
	    </script></td>
</tr>

</table>

</ContentTemplate>
</asp:UpdatePanel>

</div>

<br />

<cc1:Editor ID="Editor1" runat="server" height="450px" />

<br />
<br />
<div style="text-align:center;">
    <asp:UpdatePanel ID="updToevoegen" runat="server">
    <ContentTemplate>
<asp:Button ID="btnVoegtoe" runat="server" UseSubmitBehavior="true" Text="Artikel Toevoegen" />
    <asp:UpdateProgress ID="prgToevoegen" runat="server" AssociatedUpdatePanelID="updToevoegen">
    <ProgressTemplate>
    <div class="update">
    <img src="CSS/Images/ajaxloader.gif" />
    Bezig met opslaan...
    </div>
    </ProgressTemplate>
    </asp:UpdateProgress>
    <div runat="server" id="divFeedback" visible="false">
        <asp:Image ID="imgResultaat" runat="server" />&nbsp;<asp:Label ID="lblresultaat" runat="server"></asp:Label><br />
        <input id="btnNieuwArtikel" type="button" value="Nog een artikel toevoegen" onclick="window.location = 'invoerenTekst.aspx'" />
    </div>
</ContentTemplate>
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

