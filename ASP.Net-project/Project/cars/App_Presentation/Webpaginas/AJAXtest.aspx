<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AJAXtest.aspx.vb" Inherits="_Default" MasterPageFile="~/App_Presentation/MasterPage.master" %>

<script runat="server">
    Sub DropDownSelection_Change(ByVal Sender As Object, ByVal E As EventArgs)
        Calendar1.DayStyle.BackColor = _
        System.Drawing.Color.FromName(ColorList.SelectedItem.Value)
    End Sub

    Protected Sub Calendar1_SelectionChanged(ByVal Sender As Object, ByVal E As EventArgs)
        SelectedDate.Text = Calendar1.SelectedDate.ToString()
    End Sub

</script>

<asp:Content ID="Main" ContentPlaceHolderID="plcMain" runat="server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <div>
        <asp:UpdatePanel ID="UpdatePanel1" runat="server">
            <ContentTemplate>
                <asp:Label ID="Label1" runat="server" Text="Label"></asp:Label>
                <asp:Button ID="Button1" runat="server" Text="Button" />
            </ContentTemplate>
        </asp:UpdatePanel>
        
        <asp:UpdatePanel ID="UpdatePanel2"
                             runat="server">
                <ContentTemplate>
                    <asp:Calendar ID="Calendar1" 
                                  ShowTitle="True"
                                  OnSelectionChanged="Calendar1_SelectionChanged"
                                  runat="server" />
                    <div>
                        Background:
                        <br />
                        <asp:DropDownList ID="ColorList" 
                                          AutoPostBack="True" 
                                          OnSelectedIndexChanged="DropDownSelection_Change"
                                          runat="server">
                            <asp:ListItem Selected="True" Value="White"> 
                            White </asp:ListItem>
                            <asp:ListItem Value="Silver"> 
                            Silver </asp:ListItem>
                            <asp:ListItem Value="DarkGray"> 
                            Dark Gray </asp:ListItem>
                            <asp:ListItem Value="Khaki"> 
                            Khaki </asp:ListItem>
                            <asp:ListItem Value="DarkKhaki"> D
                            ark Khaki </asp:ListItem>
                        </asp:DropDownList>
                    </div>
                    <br />
                    Selected date:
                    <asp:Label ID="SelectedDate" 
                               runat="server">None.</asp:Label>
                </ContentTemplate>
            </asp:UpdatePanel>

    </div>
</asp:Content>