<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="AutoSchema.aspx.vb" Inherits="App_Presentation_Webpaginas_Beheer_AutoSchema"  title="Reservatieschema"%>

<asp:Content ID="Content2" ContentPlaceHolderID="plcMain" Runat="Server">

    <asp:UpdatePanel ID="updKalenderOverzicht" runat="server" UpdateMode="Conditional">
    <ContentTemplate>

    <h2>Kalenderoverzicht van <asp:Label ID="lblAuto" runat="server"></asp:Label>:</h2>

        <br />
        Filteren op klant: 
        <asp:DropDownList ID="ddlKlant" runat="server" 
                DataTextField="userVoornaam" DataValueField="userID" AutoPostBack="true"></asp:DropDownList>
       <br />
    <br />
    
    <asp:Calendar ID="calAutoSchema" runat="server" BackColor="White" 
        BorderColor="White" BorderWidth="1px" Font-Names="Verdana" Font-Size="9pt" 
        ForeColor="Black" Height="384px" NextPrevFormat="FullMonth" Width="737px">
        <SelectedDayStyle BackColor="#333399" ForeColor="White" />
        <TodayDayStyle BackColor="#CCCCCC" />
        <OtherMonthDayStyle ForeColor="#999999" />
        <NextPrevStyle Font-Bold="True" Font-Size="8pt" ForeColor="#333333" 
            VerticalAlign="Bottom" />
        <DayHeaderStyle Font-Bold="True" Font-Size="8pt" />
        <TitleStyle BackColor="White" BorderColor="Black" BorderWidth="4px" 
            Font-Bold="True" Font-Size="12pt" ForeColor="#333399" />
    </asp:Calendar>
    </ContentTemplate>
    </asp:UpdatePanel>
    </asp:Content>
