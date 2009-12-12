<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false"
    CodeFile="AutoInchecken.aspx.vb" Inherits="App_Presentation_Webpaginas_Beheer_AutoInchecken"
    Title="Untitled Page" %>
    
    <%@ Register Assembly="AjaxControlToolkit" Namespace="AjaxControlToolkit" TagPrefix="cc1" %>


<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" runat="Server">
  
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
        
        <table>
        <tr>
            <td>
            ReservatieID:
            </td>
            <td>
            <asp:TextBox ID="txtResID" runat="server" AutoPostBack="True"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td>
            Datum:
            </td>
            <td>
                </calendarextender>
                <asp:TextBox ID="txtDatum" runat="server" AutoPostBack="True"></asp:TextBox>
                <cc1:CalendarExtender ID="calDatum" runat="server" 
                    TargetControlID="txtDatum" Format="d/MM/yyyy" FirstDayOfWeek="Monday" 
                    TodaysDateFormat="d MMMM, yyyy" 
                    PopupButtonID="imgDatumKalender">
                </cc1:CalendarExtender>
                <asp:Image ID="imgDatumKalender" runat="server" ImageAlign="AbsMiddle" 
                    ImageUrl="~/App_Presentation/Images/kalender.png" />
            </td>
        </tr>
        <tr>
            <td>
                Boete:
            </td>
            <td>
                <asp:TextBox ID="txtBoete" runat="server"></asp:TextBox>
           </td>
        </tr>
        <tr>
            <td>
                 Problematisch:  
            </td>
            <td>
                 <asp:CheckBox ID="chkProblematisch" runat="server" />  
            </td>
        </tr>
        <tr>
            <td colspan="2">
                Commentaar:<br />
                <asp:TextBox ID="txtCommentaar" runat="server" Height="96px" Width="323px"></asp:TextBox>
            </td>      
        </tr>
        <tr>
            <td>
                <asp:Button ID="cmdCheckIn" runat="server" Text="Check in" />
                
            </td>
            <td>
            
                <asp:Label ID="lblResultaat" runat="server" Text=""></asp:Label>
                <asp:UpdateProgress ID="UpdateProgress1" runat="server">
                    <ProgressTemplate>
                        <div class="progress">
                            <img src="../../Images/ajax-loader.gif" /> Even wachten aub...
                        </div>
                    </ProgressTemplate>
                </asp:UpdateProgress>
            </td>
        </tr>
            </table>
            
        </ContentTemplate>
    </asp:UpdatePanel>

                  
                 

</asp:Content>
