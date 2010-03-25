<%@ Page Language="VB"  MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="VideoUploaden.aspx.vb" Inherits="App_Presentation_VideoUploaden" title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderTitel" Runat="Server">
    Upload uw videobestanden
</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <br />
     
    <asp:Label ID="lblBestand" runat="server" Text="Upload: "></asp:Label>

    <asp:FileUpload ID="FileUpload1" runat="server" />
    <%--<asp:RegularExpressionValidator
        ID="RegularExpressionValidator1" runat="server" 
        ErrorMessage="Enkel avi, mov, swf en wmv bestanden worden ondersteund." 
        ControlToValidate="FileUpload1" 
        ValidationExpression="^(([a-zA-Z]:)|(\\{2}\w+)\$?)(\\(\w[\w].*))(.avi|.mov|.swf|.wmv)$" 
        ></asp:RegularExpressionValidator>--%>
<br /><asp:Button ID="btnUpload" runat="server" Text="Opslaan" />
    <br />
<asp:UpdatePanel ID="updVideo" runat="server">
                    <ContentTemplate>
    
                        <asp:Button ID="btnVoorbeeld" runat="server" Text="Voorbeeld" Visible="False" />
    
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
    </ContentTemplate>
    </asp:UpdatePanel>
    
 Reeds Geüploade video's:    
    <br />
   <asp:ListBox ID="lstVideo" runat="server" Height="150px"></asp:ListBox>
   <ul class="view"><li>
  <asp:ImageButton ID="imgbtnView" runat="server" 
        ImageUrl="~/App_Presentation/CSS/images/view.png" /> Klik om te selectie te bekijken.</li>
        </ul>
&nbsp;

</asp:Content>

