<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MovieTicketBooking.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .hero-banner {
            background: linear-gradient(rgba(15, 23, 42, 0.7), rgba(15, 23, 42, 0.7)), 
                        url('https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?ixlib=rb-1.2.1&auto=format&fit=crop&w=1920&q=80');
            background-size: cover;
            background-position: center;
            height: 60vh;
            min-height: 400px;
            display: flex;
            align-items: center;
            border-radius: 24px;
            overflow: hidden;
        }

        .category-pill {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
            padding: 8px 16px;
            border-radius: 50px;
            font-size: 0.85rem;
            transition: all 0.3s ease;
        }

        .category-pill:hover {
            background: var(--primary-color);
            border-color: var(--primary-color);
        }
    </style>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <!-- Hero Section -->
    <div class="hero-banner mb-5 shadow-lg position-relative">
        <div class="container px-5">
            <div class="row align-items-center">
                <div class="col-lg-7 text-white animate__animated animate__fadeInLeft">
                    <span class="badge bg-primary px-3 py-2 rounded-pill mb-3 text-uppercase fw-bold ls-1">New Experience</span>
                    <h1 class="display-2 fw-bold mb-3">Cinema as it <br /><span class="text-primary text-gradient">Should Be.</span></h1>
                    <p class="lead opacity-75 mb-4 pe-lg-5">Experience the latest blockbusters with crystal clear sound and ultimate comfort. Book your seats in seconds.</p>
                    <div class="d-flex gap-3">
                        <a href="Movies.aspx" class="btn btn-primary btn-lg rounded-pill px-5 py-3 shadow-sm fw-bold">
                            <i class="fas fa-ticket-alt me-2"></i>Book Now
                        </a>
                        <asp:PlaceHolder ID="phGuestAction" runat="server">
                            <a href="Login.aspx" class="btn btn-outline-light btn-lg rounded-pill px-5 py-3 fw-bold">
                                Join the Club
                            </a>
                        </asp:PlaceHolder>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Top Rated / Featured Section -->
    <div class="container mb-5">
        <div class="d-flex justify-content-between align-items-end mb-4">
            <div>
                <h2 class="fw-bold mb-0">Top Rated Picks</h2>
                <p class="text-muted">Hand-picked blockbusters our community loves</p>
            </div>
            <a href="Movies.aspx" class="btn btn-link text-primary fw-bold text-decoration-none p-0">
                View Theater Catalog <i class="fas fa-arrow-right ms-2"></i>
            </a>
        </div>

        <div class="row row-cols-1 row-cols-sm-2 row-cols-md-4 g-4 mb-5">
            <asp:Repeater ID="rptFeatured" runat="server">
                <ItemTemplate>
                    <div class="col">
                        <a href='<%# "MovieDetails.aspx?id=" + Eval("MovieId") %>' class="text-decoration-none">
                            <div class="card h-100 border-0 rounded-4 shadow-sm hover-lift overflow-hidden bg-transparent">
                                <div class="position-relative overflow-hidden group">
                                    <img src='<%# GetPosterUrl(Eval("PosterUrl")) %>' 
                                         class="card-img-top rounded-4" style="height: 380px; object-fit: cover;" alt='<%# Eval("Title") %>'
                                         onerror="this.src='data:image/svg+xml;charset=UTF-8,%3Csvg%20width%3D%22400%22%20height%3D%22600%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3E%3Crect%20width%3D%22100%25%22%20height%3D%22100%25%22%20fill%3D%22%23f1f5f9%22%2F%3E%3Ctext%20x%3D%2250%25%22%20y%3D%2250%25%22%20font-family%3D%22Arial%22%20font-size%3D%2224%22%20fill%3D%22%2364748b%22%20text-anchor%3D%22middle%22%20dy%3D%22.3em%22%3ENo%20Poster%3C%2Ftext%3E%3C%2Fsvg%3E';">
                                    <div class="card-body px-0 pt-3">
                                        <h6 class="fw-bold text-dark mb-1 text-truncate"><%# Eval("Title") %></h6>
                                        <div class="d-flex justify-content-between align-items-center">
                                            <span class="text-muted x-small"><%# Eval("Genre") %> • <%# Eval("Duration") %>m</span>
                                            <span class="badge bg-secondary-subtle text-secondary rounded-pill px-2 py-1"><%# Eval("Rating") %></span>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </a>
                    </div>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <!-- Quick Actions -->
        <h4 class="fw-bold mb-4 mt-5"><i class="fas fa-th-large text-primary me-2"></i>Quick Navigation</h4>
        <div class="row g-4 mb-5">
            <div class="col-md-4">
                <div class="card glass-card border-0 h-100 rounded-4 shadow-sm hover-lift">
                    <div class="card-body p-4 text-center">
                        <div class="bg-primary-subtle text-primary p-3 rounded-4 d-inline-block mb-3">
                            <i class="fas fa-film fa-2x"></i>
                        </div>
                        <h5 class="fw-bold">Weekly Schedule</h5>
                        <p class="text-muted small">See what's playing this week and plan your next visit.</p>
                        <a href="Movies.aspx" class="btn btn-light rounded-pill px-4 btn-sm fw-bold">Check Schedule</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card glass-card border-0 h-100 rounded-4 shadow-sm hover-lift">
                    <div class="card-body p-4 text-center">
                        <div class="bg-success-subtle text-success p-3 rounded-4 d-inline-block mb-3">
                            <i class="fas fa-ticket-alt fa-2x"></i>
                        </div>
                        <h5 class="fw-bold">My Dashboard</h5>
                        <p class="text-muted small">View your active tickets and past booking history.</p>
                        <a href="MyBookings.aspx" class="btn btn-light rounded-pill px-4 btn-sm fw-bold">Go to Dashboard</a>
                    </div>
                </div>
            </div>
            <asp:PlaceHolder ID="phGuestCommunity" runat="server">
                <div class="col-md-4">
                    <div class="card glass-card border-0 h-100 rounded-4 shadow-sm hover-lift">
                        <div class="card-body p-4 text-center">
                            <div class="bg-info-subtle text-info p-3 rounded-4 d-inline-block mb-3">
                                <i class="fas fa-user-circle fa-2x"></i>
                            </div>
                            <h5 class="fw-bold">Join the Community</h5>
                            <p class="text-muted small">Create an account to save movies and earn rewards.</p>
                            <a href="Register.aspx" class="btn btn-light rounded-pill px-4 btn-sm fw-bold">Sign Up Today</a>
                        </div>
                    </div>
                </div>
            </asp:PlaceHolder>
        </div>
    </div>
</asp:Content>
