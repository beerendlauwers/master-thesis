<%@ Page Language="VB" MasterPageFile="~/App_Presentation/MasterPage.master" AutoEventWireup="false" CodeFile="VideoAfspelen.aspx.vb" Inherits="App_Presentation_VideoAfspelen" title="Untitled Page" %>

<%@ Register Assembly="ASPNetFlashVideo.NET3" Namespace="ASPNetFlashVideo" TagPrefix="ASPNetFlashVideo" %>

<%@ Register Assembly="ASPNetVideo.NET3" Namespace="ASPNetVideo" TagPrefix="ASPNetVideo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style type="text/css">
        #film
        {
            height: 19px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolderTitel" Runat="Server">
    Video's Bekijken
</asp:Content>

<asp:Content ID="Content3" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
Kies een video om af te spelen. <br />
    <asp:DropDownList ID="ddlVideo" runat="server" DataSourceID="objdVideo" 
        DataTextField="videoNaam" DataValueField="VideoID"></asp:DropDownList>
       <asp:Button ID="btnPlay" runat="server" Text="Play" />
    
    <div runat="server" id="film">
        
        
    </div>
     <asp:Label ID="lblFilmNaam" runat="server" Text=""></asp:Label>
                     <br />

    <asp:Label ID="lblHelp" runat="server" Text=""></asp:Label>
                    <ASPNetVideo:QuickTime ID="QuickTime2" runat="server" Enabled="False">
        </ASPNetVideo:QuickTime>
        <ASPNetVideo:WindowsMedia ID="WindowsMedia1" runat="server" 
        AutoPlay="False" Enabled="False">
    </ASPNetVideo:WindowsMedia>
    <ASPNetFlashVideo:FlashVideo ID="FlashVideo1" runat="server" Enabled="False">
    </ASPNetFlashVideo:FlashVideo>
    
    
        <asp:ObjectDataSource ID="objdVideo" runat="server" 
            DeleteMethod="Delete" InsertMethod="Insert" 
            OldValuesParameterFormatString="original_{0}" SelectMethod="GetData" 
            TypeName="ManualTableAdapters.tblVideoTableAdapter" 
        UpdateMethod="Update">
            <DeleteParameters>
                <asp:Parameter Name="Original_VideoID" Type="Int32" />
            </DeleteParameters>
            <UpdateParameters>
                <asp:Parameter Name="videoNaam" Type="String" />
                <asp:Parameter Name="videoPad" Type="String" />
                <asp:Parameter Name="VideoCode" Type="String" />
                <asp:Parameter Name="Original_VideoID" Type="Int32" />
            </UpdateParameters>
            <InsertParameters>
                <asp:Parameter Name="videoNaam" Type="String" />
                <asp:Parameter Name="videoPad" Type="String" />
                <asp:Parameter Name="VideoCode" Type="String" />
            </InsertParameters>
        </asp:ObjectDataSource>
    
    
    
</asp:Content>

