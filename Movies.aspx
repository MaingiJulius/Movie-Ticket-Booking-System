<%@ Page Title="Browse Movies" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Movies.aspx.cs" Inherits="MovieTicketBooking.MoviesPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Now Showing</h2>
        <div class="input-group w-50">
            <input type="text" class="form-control" placeholder="Search movies by title or genre..." />
            <button class="btn btn-outline-secondary" type="button">Search</button>
        </div>
    </div>

    <asp:Repeater ID="rptMovies" runat="server">
        <HeaderTemplate>
            <div class="row row-cols-1 row-cols-md-3 row-cols-lg-4 g-4">
        </HeaderTemplate>
        <ItemTemplate>
            <div class="col">
                <div class="card h-100 movie-card shadow-sm">
                    <img src='<%# Eval("PosterUrl").ToString().StartsWith("http") ? Eval("PosterUrl").ToString() : "Content/Images/" + Eval("PosterUrl") %>' class="card-img-top movie-poster" alt='<%# Eval("Title") %>' onerror="this.src='https://via.placeholder.com/300x450?text=No+Poster';">
                    <div class="card-body">
                        <h5 class="card-title text-truncate"><%# Eval("Title") %></h5>
                        <p class="card-text small text-muted">
                            <span class="badge bg-secondary"><%# Eval("Genre") %></span>
                            <span class="ms-2"><%# Eval("Duration") %> mins</span>
                        </p>
                        <p class="card-text text-truncate small"><%# Eval("Description") %></p>
                    </div>
                    <div class="card-footer bg-transparent border-0 pb-3">
                        <a href='<%# "MovieDetails.aspx?id=" + Eval("MovieId") %>' class="btn btn-primary w-100 shadow-sm">View Details</a>
                    </div>
                </div>
            </div>
        </ItemTemplate>
        <FooterTemplate>
            </div>
        </FooterTemplate>
    </asp:Repeater>

    <asp:Label ID="lblNoData" runat="server" Text="No movies available at the moment." Visible="false" CssClass="text-center d-block my-5 fs-4 text-muted"></asp:Label>
</asp:Content>
