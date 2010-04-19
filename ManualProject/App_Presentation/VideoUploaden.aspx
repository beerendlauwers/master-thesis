<%@ Page Language="VB"  MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="VideoUploaden.aspx.vb" Inherits="App_Presentation_VideoUploaden" title="Untitled Page" %>

<%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server"><title>Upload uw videobestanden</title> 
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderTitel" Runat="Server">
   
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
<div id="divLoggedIn" runat="server">
    <br />
<asp:Label ID="lblBestand" runat="server" Text="Upload: "></asp:Label>
<asp:UpdatePanel ID="updVideo" runat="server" UpdateMode="conditional">
                    <ContentTemplate>                           
<asp:FileUpload ID="FileUpload1" runat="server" />
<br /><asp:Button ID="btnUpload" runat="server" Text="Opslaan" /><span style="vertical-align:middle" id='tipOpslaan'><img src="CSS/images/help.png" alt=''/></span>
    <br />
          <asp:Button ID="btnVoorbeeld" runat="server" Text="Voorbeeld" Visible="true" style="display:none;"/><span style="vertical-align:middle; display:none;" id='tipVoorbeeld' runat="server" ><img src="CSS/images/help.png" alt=''/></span>
    <br />
    <asp:Label ID="lblRes" runat="server" Text=""></asp:Label>
                        <br />
                        <br />
  <asp:UpdateProgress ID="UpdateProgress1" runat="server">
                            <ProgressTemplate>
                                <div class="update">
                                    <img src="CSS/Images/ajaxloader.gif" />
                                    Even wachten aub...
                                </div>
                            </ProgressTemplate>
                        </asp:UpdateProgress>
 Reeds Geüploade video's:    
   <br />
   <%--<asp:ListBox ID="lstVideo" runat="server" Height="150px"></asp:ListBox>--%>
                        <asp:DropDownList ID="ddlVideo" runat="server">
                        </asp:DropDownList><span style="vertical-align:middle" id='tipAfspelen'><img src="CSS/images/help.png" alt=''/></span>
   <ul class="view"><li>
  <asp:ImageButton ID="imgbtnView" runat="server" 
        ImageUrl="~/App_Presentation/CSS/images/view.png" /> Klik om de geselecteerde video te bekijken.</li>
        <li>
  <asp:ImageButton ID="imgBtnRemove" runat="server" 
        ImageUrl="~/App_Presentation/CSS/images/remove.png" /> Klik om de geselecteerde video te Verwijderen.</li>
        </ul>
&nbsp;</ContentTemplate>
<Triggers>
<asp:PostBackTrigger ControlID="btnUpload" />
</Triggers>
</asp:UpdatePanel>
</div>
</asp:Content>

