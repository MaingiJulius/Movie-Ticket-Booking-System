<%@ Page Title="Movie Details" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MovieDetails.aspx.cs" Inherits="MovieTicketBooking.MovieDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:PlaceHolder ID="phDetails" runat="server" Visible="false">
        <nav aria-label="breadcrumb">
            <ol class="breadcrumb">
                <li class="breadcrumb-item"><a href="Movies.aspx">Movies</a></li>
                <li class="breadcrumb-item active" aria-current="page"><asp:Literal ID="litBreadcrumb" runat="server"></asp:Literal></li>
            </ol>
        </nav>

        <div class="row">
            <div class="col-md-4">
                <asp:Image ID="imgPoster" runat="server" CssClass="img-fluid rounded shadow" />
            </div>
            <div class="col-md-8">
                <h1 class="fw-bold mb-3"><asp:Literal ID="litTitle" runat="server"></asp:Literal></h1>
                
                <div class="mb-4">
                    <span class="badge bg-primary fs-6"><asp:Literal ID="litGenre" runat="server"></asp:Literal></span>
                    <span class="badge bg-dark fs-6 ms-2"><asp:Literal ID="litDuration" runat="server"></asp:Literal> mins</span>
                    <span class="badge bg-warning text-dark fs-6 ms-2"><asp:Literal ID="litRating" runat="server"></asp:Literal></span>
                </div>

                <h5>Description</h5>
                <p class="text-muted"><asp:Literal ID="litDescription" runat="server"></asp:Literal></p>
                
                <hr />

                <h4 class="mt-4 mb-3">Available Showtimes</h4>
                <asp:Repeater ID="rptShowtimes" runat="server">
                    <HeaderTemplate>
                        <div class="list-group">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="list-group-item list-group-item-action d-flex justify-content-between align-items-center mb-2 rounded shadow-sm">
                            <div>
                                <h6 class="mb-1 fw-bold"><%# Eval("TheaterName") %></h6>
                                <p class="mb-0 text-muted small"><%# Eval("StartTime", "{0:f}") %></p>
                            </div>
                            <div class="text-end">
                                <span class="d-block fw-bold text-primary fs-5 mb-1">$<%# Eval("Price") %></span>
                                <a href='<%# "BookTicket.aspx?showId=" + Eval("ShowtimeId") %>' class="btn btn-sm btn-primary px-3">Book Seats</a>
                            </div>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>
                <asp:Label ID="lblNoShows" runat="server" Text="No upcoming shows available for this movie." Visible="false" CssClass="text-muted"></asp:Label>
            </div>
        </div>
    </asp:PlaceHolder>

    <asp:Label ID="lblError" runat="server" Text="Movie not found." Visible="false" CssClass="alert alert-danger d-block"></asp:Label>
</asp:Content>
