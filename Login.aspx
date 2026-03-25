<%@ Page Title="Login" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Login.aspx.cs" Inherits="MovieTicketBooking.Login" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row justify-content-center">
        <div class="col-md-4">
            <div class="card shadow p-4 mt-5">
                <h2 class="text-center mb-4">Login</h2>
                <div class="mb-3">
                    <label class="form-label">Username</label>
                    <asp:TextBox ID="txtUsername" runat="server" CssClass="form-control" placeholder="Enter username"></asp:TextBox>
                </div>
                <div class="mb-3">
                    <label class="form-label">Password</label>
                    <asp:TextBox ID="txtPassword" runat="server" CssClass="form-control" TextMode="Password" placeholder="Enter password"></asp:TextBox>
                </div>
                <div class="d-grid mt-4">
                    <asp:Button ID="btnLogin" runat="server" Text="Login" CssClass="btn btn-primary" OnClick="btnLogin_Click" />
                </div>
                <div class="text-center mt-3">
                    <p>Don't have an account? <a href="Register.aspx">Register here</a></p>
                </div>
                <div class="mt-2 text-center">
                    <asp:Label ID="lblError" runat="server" CssClass="text-danger small"></asp:Label>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
