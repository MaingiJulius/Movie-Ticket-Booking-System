<%@ Page Title="Home" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="MovieTicketBooking.Default" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .hero-section {
            background: linear-gradient(rgba(0,0,0,0.6), rgba(0,0,0,0.6)), url('https://images.unsplash.com/photo-1489599849927-2ee91cede3ba?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');
            background-size: cover;
            background-position: center;
            color: white;
            padding: 100px 0;
            border-radius: 15px;
            margin-bottom: 50px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="hero-section text-center shadow">
        <h1 class="display-3 fw-bold">Welcome to <span class="text-primary">CineTicket</span></h1>
        <p class="lead">Book your favorite movies in just a few clicks.</p>
        <a href="Movies.aspx" class="btn btn-primary btn-lg px-5 mt-3">Browse Movies</a>
    </div>

    <div class="container">
        <h2 class="mb-4">Quick Navigation</h2>
        <div class="row g-4">
            <div class="col-md-4">
                <div class="card h-100 shadow-sm border-0">
                    <div class="card-body text-center">
                        <i class="bi bi-film fs-1 text-primary"></i>
                        <h5 class="card-title mt-3">Latest Movies</h5>
                        <p class="card-text">Explore what is currently playing in theaters.</p>
                        <a href="Movies.aspx" class="btn btn-outline-primary">View All</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card h-100 shadow-sm border-0">
                    <div class="card-body text-center">
                        <i class="bi bi-ticket-perforated fs-1 text-primary"></i>
                        <h5 class="card-title mt-3">My Bookings</h5>
                        <p class="card-text">Check your history and manage active tickets.</p>
                        <a href="MyBookings.aspx" class="btn btn-outline-primary">My Dashboard</a>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <div class="card h-100 shadow-sm border-0">
                    <div class="card-body text-center">
                        <i class="bi bi-person fs-1 text-primary"></i>
                        <h5 class="card-title mt-3">Account</h5>
                        <p class="card-text">Update your profile and security settings.</p>
                        <a href="Login.aspx" class="btn btn-outline-primary">Sign In</a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
