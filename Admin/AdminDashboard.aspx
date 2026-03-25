<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="MovieTicketBooking.Admin.AdminDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <h2 class="mb-4 text-primary">Admin Dashboard</h2>
        
        <div class="row g-4 mb-5">
            <div class="col-md-3">
                <div class="card bg-primary text-white shadow">
                    <div class="card-body">
                        <h5>Movies</h5>
                        <h2 class="fw-bold"><asp:Literal ID="litTotalMovies" runat="server">0</asp:Literal></h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-success text-white shadow">
                    <div class="card-body">
                        <h5>Total Users</h5>
                        <h2 class="fw-bold"><asp:Literal ID="litTotalUsers" runat="server">0</asp:Literal></h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <div class="card bg-warning text-dark shadow">
                    <div class="card-body">
                        <h5>Active Bookings</h5>
                        <h2 class="fw-bold"><asp:Literal ID="litActiveBookings" runat="server">0</asp:Literal></h2>
                    </div>
                </div>
            </div>
            <div class="col-md-3">
                <a href="ManageBookings.aspx" class="text-decoration-none">
                    <div class="card bg-info text-white shadow h-100">
                        <div class="card-body">
                            <h5>Total Revenue</h5>
                            <h2 class="fw-bold">$<asp:Literal ID="litRevenue" runat="server">0.00</asp:Literal></h2>
                            <small class="text-white-50">Click to view bookings</small>
                        </div>
                    </div>
                </a>
            </div>
        </div>

        <h4 class="mb-3 text-secondary">Admin Tools</h4>
        <div class="row g-4">
            <div class="col-md-4">
                <a href="ManageMovies.aspx" class="text-decoration-none">
                    <div class="card shadow-sm h-100 border-0" style="background: linear-gradient(135deg,#1e3c72,#2a5298); color:white;">
                        <div class="card-body text-center py-4">
                            <h2 class="display-4 fw-bold mb-3">M</h2>
                            <h5 class="mt-2 fw-bold">Manage Movies</h5>
                            <p class="small mb-0 opacity-75">Add, view, or deactivate movies</p>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col-md-4">
                <a href="ManageShowtimes.aspx" class="text-decoration-none">
                    <div class="card shadow-sm h-100 border-0" style="background: linear-gradient(135deg,#11998e,#38ef7d); color:white;">
                        <div class="card-body text-center py-4">
                            <h2 class="display-4 fw-bold mb-3">S</h2>
                            <h5 class="mt-2 fw-bold">Manage Showtimes</h5>
                            <p class="small mb-0 opacity-75">Schedule showings for any movie</p>
                        </div>
                    </div>
                </a>
            </div>
            <div class="col-md-4">
                <a href="ManageBookings.aspx" class="text-decoration-none">
                    <div class="card shadow-sm h-100 border-0" style="background: linear-gradient(135deg,#8e2de2,#4a00e0); color:white;">
                        <div class="card-body text-center py-4">
                            <h2 class="display-4 fw-bold mb-3">B</h2>
                            <h5 class="mt-2 fw-bold">View All Bookings</h5>
                            <p class="small mb-0 opacity-75">See all customer reservations</p>
                        </div>
                    </div>
                </a>
            </div>
        </div>
    </div>
</asp:Content>
