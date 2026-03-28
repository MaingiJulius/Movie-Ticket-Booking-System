<%@ Page Title="My Dashboard" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="UserDashboard.aspx.cs" Inherits="MovieTicketBooking.UserDashboard" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="container mt-4">
        <div class="row mb-4 align-items-center">
            <div class="col-auto">
                <div class="bg-primary text-white rounded-circle d-flex align-items-center justify-content-center shadow-sm" style="width: 64px; height: 64px;">
                    <h3 class="mb-0 fw-bold"><asp:Literal ID="litInitials" runat="server">U</asp:Literal></h3>
                </div>
            </div>
            <div class="col">
                <h2 class="mb-0 fw-bold">Welcome back, <asp:Literal ID="litWelcomeName" runat="server" />!</h2>
                <p class="text-muted mb-0">Your personal cinema hub. Ready for your next movie?</p>
            </div>
        </div>

        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="card border-0 shadow-sm rounded-4 h-100 hover-lift">
                    <div class="card-body p-4 text-center">
                        <div class="bg-primary-subtle text-primary p-3 rounded-4 d-inline-block mb-3">
                            <i class="fas fa-ticket-alt fa-2x"></i>
                        </div>
                        <h5 class="fw-bold">My Bookings</h5>
                        <p class="text-muted small">Manage your current tickets and viewing history.</p>
                        <a href="MyBookings.aspx" class="btn btn-primary rounded-pill w-100 fw-bold py-2 shadow-sm">View Tickets</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm rounded-4 h-100 hover-lift">
                    <div class="card-body p-4 text-center">
                        <div class="bg-warning-subtle text-warning p-3 rounded-4 d-inline-block mb-3">
                            <i class="fas fa-film fa-2x"></i>
                        </div>
                        <h5 class="fw-bold">Browse Movies</h5>
                        <p class="text-muted small">Explore the latest releases and find your next favorite.</p>
                        <a href="Movies.aspx" class="btn btn-outline-warning rounded-pill w-100 fw-bold py-2">Go to Catalog</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card border-0 shadow-sm rounded-4 h-100 hover-lift">
                    <div class="card-body p-4 text-center">
                        <div class="bg-success-subtle text-success p-3 rounded-4 d-inline-block mb-3">
                            <i class="fas fa-user-edit fa-2x"></i>
                        </div>
                        <h5 class="fw-bold">Profile Settings</h5>
                        <p class="text-muted small">Keep your account details and preferences up to date.</p>
                        <a href="EditProfile.aspx" class="btn btn-outline-success rounded-pill w-100 fw-bold py-2">Edit Profile</a>
                    </div>
                </div>
            </div>
        </div>

        <h4 class="fw-bold mb-4"><i class="fas fa-star text-primary me-2"></i>Hand-picked for You</h4>
        <div class="row row-cols-1 row-cols-md-4 g-4">
            <asp:Repeater ID="rptFeatured" runat="server">
                <ItemTemplate>
                    <div class="col">
                        <div class="card h-100 movie-card-premium border-0 shadow-sm rounded-4 overflow-hidden">
                            <div class="position-relative" style="height: 300px;">
                                <img src='<%# GetPosterUrl(Eval("PosterUrl")) %>' 
                                     class="w-100 h-100" style="object-fit: cover;" 
                                     onerror="this.src='data:image/svg+xml;charset=UTF-8,%3Csvg%20width%3D%22400%22%20height%3D%22600%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3E%3Crect%20width%3D%22100%25%22%20height%3D%22100%25%22%20fill%3D%22%23f1f5f9%22%2F%3E%3Ctext%20x%3D%2250%25%22%20y%3D%2250%25%22%20font-family%3D%22Arial%22%20font-size%3D%2224%22%20fill%3D%22%2364748b%22%20text-anchor%3D%22middle%22%20dy%3D%22.3em%22%3ENo%20Poster%3C%2Ftext%3E%3C%2Fsvg%3E';">
                                <div class="position-absolute bottom-0 start-0 p-2">
                                    <span class="badge bg-primary rounded-pill shadow-sm"><%# Eval("Genre") %></span>
                                </div>
                            </div>
                            <div class="card-body p-3">
                                <h6 class="fw-bold text-truncate mb-1"><%# Eval("Title") %></h6>
                                <a href='MovieDetails.aspx?id=<%# Eval("MovieId") %>' class="btn btn-sm btn-link text-primary p-0 text-decoration-none">Quick View</a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </div>
</asp:Content>
