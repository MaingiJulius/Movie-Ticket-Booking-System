<%@ Page Title="Admin Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="AdminDashboard.aspx.cs" Inherits="MovieTicketBooking.Admin.AdminDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <h2 class="mb-4 text-primary">Admin Dashboard</h2>
        
    <div class="row g-4 mb-5 text-white">
        <div class="col-md-3">
            <a href="ManageMovies.aspx" class="text-decoration-none h-100">
                <div class="card dashboard-card bg-primary shadow-sm h-100 border-0" style="background: linear-gradient(135deg, #4f46e5, #6366f1);">
                    <div class="card-body d-flex flex-column justify-content-between p-4">
                        <div>
                            <i class="fas fa-film fa-2x mb-3 opacity-50"></i>
                            <h5 class="text-white-50 small text-uppercase fw-bold">Movies</h5>
                        </div>
                        <h2 class="fw-bold mb-0"><asp:Literal ID="litTotalMovies" runat="server">0</asp:Literal></h2>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="ManageUsers.aspx" class="text-decoration-none h-100">
                <div class="card dashboard-card bg-success shadow-sm h-100 border-0" style="background: linear-gradient(135deg, #10b981, #34d399);">
                    <div class="card-body d-flex flex-column justify-content-between p-4">
                        <div>
                            <i class="fas fa-users fa-2x mb-3 opacity-50"></i>
                            <h5 class="text-white-50 small text-uppercase fw-bold">Total Users</h5>
                        </div>
                        <h2 class="fw-bold mb-0"><asp:Literal ID="litTotalUsers" runat="server">0</asp:Literal></h2>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="ManageBookings.aspx" class="text-decoration-none h-100">
                <div class="card dashboard-card bg-warning shadow-sm h-100 border-0" style="background: linear-gradient(135deg, #f59e0b, #fbbf24);">
                    <div class="card-body d-flex flex-column justify-content-between p-4 text-dark">
                        <div>
                            <i class="fas fa-ticket-alt fa-2x mb-3 opacity-50 text-dark"></i>
                            <h5 class="text-dark opacity-50 small text-uppercase fw-bold">Active Bookings</h5>
                        </div>
                        <h2 class="fw-bold mb-0"><asp:Literal ID="litActiveBookings" runat="server">0</asp:Literal></h2>
                    </div>
                </div>
            </a>
        </div>
        <div class="col-md-3">
            <a href="ViewBookings.aspx" class="text-decoration-none h-100 d-block">
                <div class="card dashboard-card bg-info shadow-sm h-100 border-0 hover-lift" style="background: linear-gradient(135deg, #0ea5e9, #38bdf8);">
                    <div class="card-body d-flex flex-column justify-content-between p-4">
                        <div>
                            <i class="fas fa-dollar-sign fa-2x mb-3 opacity-50"></i>
                            <h5 class="text-white-50 small text-uppercase fw-bold">Total Revenue</h5>
                        </div>
                        <h2 class="fw-bold mb-0 text-white">$<asp:Literal ID="litRevenue" runat="server">0.00</asp:Literal></h2>
                        <div class="mt-2 text-white-50 small"><i class="fas fa-arrow-right me-1"></i>View Details</div>
                    </div>
                </div>
            </a>
        </div>
    </div>

        <h4 class="mb-4 text-secondary"><i class="fas fa-tools me-2"></i>Administrative Tools</h4>
        <div class="row g-4 pb-5">
            <div class="col-md-4">
                <div class="card glass-card border-0 shadow-sm h-100 rounded-4 hover-lift overflow-hidden">
                    <div class="card-body p-4 text-center">
                        <div class="icon-box bg-primary-subtle text-primary mx-auto mb-3 shadow-sm">
                            <i class="fas fa-edit fa-lg"></i>
                        </div>
                        <h5 class="fw-bold mb-2">Manage Movies</h5>
                        <p class="text-muted small mb-4">Add new movies, edit details, or manage the theater catalog.</p>
                        <a href="ManageMovies.aspx" class="btn btn-primary rounded-pill px-4 shadow-sm w-100 fw-bold">Open Module</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card glass-card border-0 shadow-sm h-100 rounded-4 hover-lift overflow-hidden">
                    <div class="card-body p-4 text-center">
                        <div class="icon-box bg-success-subtle text-success mx-auto mb-3 shadow-sm">
                            <i class="fas fa-users-cog fa-lg"></i>
                        </div>
                        <h5 class="fw-bold mb-2">Manage Users</h5>
                        <p class="text-muted small mb-4">View all users, change roles, or deactivate accounts.</p>
                        <a href="ManageUsers.aspx" class="btn btn-success rounded-pill px-4 shadow-sm w-100 fw-bold">Open Module</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card glass-card border-0 shadow-sm h-100 rounded-4 hover-lift overflow-hidden">
                    <div class="card-body p-4 text-center">
                        <div class="icon-box bg-info-subtle text-info mx-auto mb-3 shadow-sm">
                            <i class="fas fa-receipt fa-lg"></i>
                        </div>
                        <h5 class="fw-bold mb-2">View Bookings</h5>
                        <p class="text-muted small mb-4">View detailed booking logs, cancel tickets, or delete records.</p>
                        <a href="ViewBookings.aspx" class="btn btn-info text-white rounded-pill px-4 shadow-sm w-100 fw-bold">Open Module</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card glass-card border-0 shadow-sm h-100 rounded-4 hover-lift overflow-hidden">
                    <div class="card-body p-4 text-center">
                        <div class="icon-box bg-danger-subtle text-danger mx-auto mb-3 shadow-sm">
                            <i class="fas fa-calendar-alt fa-lg"></i>
                        </div>
                        <h5 class="fw-bold mb-2">Manage Showtimes</h5>
                        <p class="text-muted small mb-4">Set movie timings, theaters, and ticket pricing.</p>
                        <a href="ManageShowtimes.aspx" class="btn btn-danger rounded-pill px-4 shadow-sm w-100 fw-bold">Open Module</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card glass-card border-0 shadow-sm h-100 rounded-4 hover-lift overflow-hidden">
                    <div class="card-body p-4 text-center">
                        <div class="icon-box bg-warning-subtle text-warning mx-auto mb-3 shadow-sm">
                            <i class="fas fa-comments fa-lg"></i>
                        </div>
                        <h5 class="fw-bold mb-2">Manage Feedback</h5>
                        <p class="text-muted small mb-4">View user reviews, monitor ratings, and delete feedback.</p>
                        <a href="ManageFeedback.aspx" class="btn btn-warning rounded-pill px-4 shadow-sm w-100 fw-bold text-dark">Open Module</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <style>
        .icon-box {
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            border-radius: 12px;
        }
        .bg-primary-subtle { background-color: #e0e7ff; }
        .bg-success-subtle { background-color: #dcfce7; }
        .bg-warning-subtle { background-color: #fef3c7; }
        .bg-info-subtle { background-color: #e0f2fe; }
        .bg-danger-subtle { background-color: #fee2e2; }
    </style>
</asp:Content>
