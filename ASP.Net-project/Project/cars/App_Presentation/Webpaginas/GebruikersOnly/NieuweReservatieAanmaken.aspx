<%@ Page Language="VB" AutoEventWireup="false" CodeFile="NieuweReservatieAanmaken.aspx.vb" Inherits="App_Presentation_NieuweReservatieAanmaken" EnableEventValidation="false" MasterPageFile="~/App_Presentation/MasterPage.master" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Main" ContentPlaceHolderID="plcMain" runat="server">
    <asp:ScriptManager ID="scmManager" runat="server"></asp:ScriptManager>
    <div>
    <asp:UpdatePanel ID="updOverview" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
        Selecteer uw categorie:
        <asp:DropDownList ID="ddlCategorie" runat="server" AutoPostBack="True">
        </asp:DropDownList>
        <cc1:CascadingDropDown ID="ccdCategorie" runat="server" Category="Categorie" 
            PromptText="Categorie" ServiceMethod="GeefCategorien" 
            TargetControlID="ddlCategorie" ServicePath="~/App_Presentation/WebServices/AutoService.asmx">
        </cc1:CascadingDropDown>
            <asp:Label ID="lblCategorieVerkeerd" runat="server"></asp:Label>
            <br />
            <br />
        Begindatum: 
        <asp:TextBox ID="txtBegindatum" runat="server" AutoPostBack="True" 
                CausesValidation="True"></asp:TextBox>
            <asp:RequiredFieldValidator ID="valBegindatum" runat="server" 
                ControlToValidate="txtBegindatum" ErrorMessage="Dit veld is verplicht."></asp:RequiredFieldValidator>
            <br />
        Einddatum: <asp:TextBox ID="txtEinddatum" runat="server" AutoPostBack="True" 
                CausesValidation="True"></asp:TextBox>
            <asp:RequiredFieldValidator ID="valEinddatum" runat="server" 
                ControlToValidate="txtBegindatum" ErrorMessage="Dit veld is verplicht."></asp:RequiredFieldValidator>
            <br />
            <asp:Label ID="lblDatumVerkeerd" runat="server"></asp:Label>
            <br />
        
    
    
        <asp:Button ID="btnOverzicht" runat="server" Text="Toon Auto's" />
    
        <br /><br />
        Extra opties:<br />
            <asp:DropDownList ID="ddlKleur" runat="server">
            </asp:DropDownList>
            <cc1:CascadingDropDown ID="ccdKleur" runat="server" Category="Kleur" 
                ParentControlID="ddlCategorie" PromptText="Kleur" 
                ServiceMethod="GeefKleurPerCategorie" 
                ServicePath="~/App_Presentation/WebServices/AutoService.asmx" TargetControlID="ddlKleur">
            </cc1:CascadingDropDown>
        <br />
        <br />
        Overzicht:<br />
        <asp:PlaceHolder ID="plcOverzicht" runat="server"></asp:PlaceHolder>
        <br />
        <asp:Repeater ID="repOverzicht" runat="server">
          <ItemTemplate>
            <a href="<%# DataBinder.Eval(Container.DataItem, "autoID") %>">
            <img src="<%# DataBinder.Eval(Container.DataItem, "autoFoto") %>" border="0"
            alt="<%# DataBinder.Eval(Container.DataItem, "modelnaam") %>"/></a>
          </ItemTemplate>
        </asp:Repeater>
        <br />
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="ddlCategorie" />
            <asp:AsyncPostBackTrigger ControlID="txtBegindatum" />
            <asp:AsyncPostBackTrigger ControlID="txtEinddatum" />  
        </Triggers>
        </asp:UpdatePanel>
    
    </div>
    <asp:ObjectDataSource ID="odsReservatie" runat="server" 
        DataObjectTypeName="Reservatie&amp;" DeleteMethod="DeleteReservatie" 
        InsertMethod="InsertReservatie" SelectMethod="GetAllReservaties" 
        TypeName="ReservatieBLL">
        <DeleteParameters>
            <asp:Parameter Name="reservatieID" Type="Int32" />
        </DeleteParameters>
    </asp:ObjectDataSource>
    <br />
</asp:Content>