<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="Default.aspx.vb" Inherits="App_Presentation_Default" title="Untitled Page" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    
<a href="#" onclick="Effect.toggle('toggle_appear', 'appear'); return false;">Toggle the following paragraph with an 'appear'-effect</a>
<div id="toggle_appear" style="background:#ccc;">
  <div>
    Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
  </div>
</div>
<br />
<br />
<div id="appear_demo" style="display:none; width:80px; height:80px; background:#c2defb; border:1px solid #333;"></div>
<ul>
  <li><a href="#" onclick="$('appear_demo').appear(); return false;">Click here for a demo!</a></li>
  <li><a href="#" onclick="$('appear_demo').hide(); return false;">Reset</a></li>
</ul>



</asp:Content>