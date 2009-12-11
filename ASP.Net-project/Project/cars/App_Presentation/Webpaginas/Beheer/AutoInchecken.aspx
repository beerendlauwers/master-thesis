<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false"
    CodeFile="AutoInchecken.aspx.vb" Inherits="App_Presentation_Webpaginas_Beheer_AutoInchecken"
    Title="Untitled Page" %>
    
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" runat="Server">
  
Kenteken:
         
                <asp:DropDownList ID="ddlKenteken" runat="server">
                </asp:DropDownList>
      
          
                <br />
                <br />
                ReservatieID:
                <asp:TextBox ID="txtResID" runat="server"></asp:TextBox>
      
          
                <br />
                Datum:
          
                <asp:TextBox ID="txtDatum" runat="server"></asp:TextBox>
                <cc1:CalendarExtender ID="calDatum" runat="server" 
                TargetControlID="txtDatum" Format="d/MM/yyyy" FirstDayOfWeek="Monday" 
                TodaysDateFormat="d MMMM, yyyy" PopupButtonID="imgDatumKalender"></cc1:CalendarExtender>
            <asp:Image ImageAlign="AbsMiddle" ID="imgDatumKalender" runat="server" ImageUrl="~/App_Presentation/Images/kalender.png" /> 
                </cc1:CalendarExtender>
                
                 
                 <br />
                <br />
                
                 
                 Boete:<br />
&nbsp;<asp:TextBox ID="txtBoete" runat="server"></asp:TextBox>
    
                <br />
                <br />
                Problematisch:<br />
&nbsp;<asp:TextBox ID="txtProblematisch" runat="server" Height="96px" Width="323px"></asp:TextBox>
                 
                 

    

 

                
        
     

                <br />
                <br />
                <asp:Button ID="cmdCheckIn" runat="server" Text="Check in" />
                 
                 

    

 

                
        
     

</asp:Content>
