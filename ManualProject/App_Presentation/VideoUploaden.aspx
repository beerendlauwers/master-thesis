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
    
    <asp:Label ID="lblRes" runat="server" Text=""></asp:Label>
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
   
    <%--<object height="480" width="640">
        <param name="movie" value="../video/video.swf" />
        <embed height="480" src="../video/video.swf" width="640">
        </embed>
    </object>--%>
    <%--<object width="640" height="480">
<param name="movie" value="../video.swf" />
<embed src="../video.swf" width="640" height="480"/>
</embed>
</object>--%>

<%--<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
   codebase="http://fpdownload.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0"
   width="550" height="400" id="Untitled-1" align="middle">
<param name="allowScriptAccess" value="sameDomain" />
<param name="movie" value="../video/video.swf" />
<param name="quality" value="high" />
<param name="bgcolor" value="#ffffff" />
<embed src="../video/video.swf" quality="high" bgcolor="#ffffff" width="550"
   height="400" name="mymovie" align="middle" allowScriptAccess="sameDomain"
   type="application/x-shockwave-flash" pluginspage="http://www.adobe.com/go/getflashplayer" />
</object>--%>


</asp:Content>

