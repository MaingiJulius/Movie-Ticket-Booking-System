<%@ Page Title="Movie Details" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MovieDetails.aspx.cs" Inherits="MovieTicketBooking.MovieDetails" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <asp:PlaceHolder ID="phDetails" runat="server" Visible="false">
        <div class="row mb-4">
            <div class="col-12">
                <nav aria-label="breadcrumb">
                    <ol class="breadcrumb mb-0">
                        <li class="breadcrumb-item"><a href="Movies.aspx" class="text-decoration-none">Movies</a></li>
                        <li class="breadcrumb-item active" aria-current="page"><asp:Literal ID="litBreadcrumb" runat="server"></asp:Literal></li>
                    </ol>
                </nav>
            </div>
        </div>

        <div class="row g-5">
            <div class="col-md-4">
                <div class="sticky-top" style="top: 100px;">
                    <asp:Image ID="imgPoster" runat="server" CssClass="img-fluid rounded-4 shadow-lg mb-4 w-100" />
                    
                    <asp:UpdatePanel ID="upWatchlist" runat="server">
                        <ContentTemplate>
                            <asp:LinkButton ID="btnWatchlist" runat="server" CssClass="btn btn-outline-primary w-100 rounded-pill py-2 shadow-sm mb-3" OnClick="btnWatchlist_Click">
                                <i class="far fa-bookmark me-2"></i>Add to Watchlist
                            </asp:LinkButton>
                        </ContentTemplate>
                    </asp:UpdatePanel>

                    <div class="card glass-card border-0 rounded-4 shadow-sm">
                        <div class="card-body p-4">
                            <h6 class="fw-bold mb-3"><i class="fas fa-info-circle me-2 text-primary"></i>Movie Stats</h6>
                            <div class="d-flex justify-content-between mb-2">
                                <span class="text-muted small">Language</span>
                                <span class="fw-bold small"><asp:Literal ID="litLanguage" runat="server"></asp:Literal></span>
                            </div>
                            <div class="d-flex justify-content-between mb-2">
                                <span class="text-muted small">Rating</span>
                                <span class="fw-bold small text-warning"><i class="fas fa-star me-1"></i><asp:Literal ID="litRating" runat="server"></asp:Literal></span>
                            </div>
                            <div class="d-flex justify-content-between">
                                <span class="text-muted small">Status</span>
                                <span class="badge bg-success-subtle text-success small border border-success">Now Showing</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="col-md-8">
                <div class="d-flex justify-content-between align-items-start mb-3">
                    <h1 class="display-5 fw-bold text-dark mb-0"><asp:Literal ID="litTitle" runat="server"></asp:Literal></h1>
                </div>
                
                <div class="mb-4">
                    <span class="badge bg-primary-subtle text-primary py-2 px-3 rounded-pill border border-primary"><asp:Literal ID="litGenre" runat="server"></asp:Literal></span>
                    <span class="badge bg-dark-subtle text-dark py-2 px-3 rounded-pill border border-dark ms-2"><i class="far fa-clock me-1"></i><asp:Literal ID="litDuration" runat="server"></asp:Literal> mins</span>
                </div>

                <p class="lead text-muted mb-5"><asp:Literal ID="litDescription" runat="server"></asp:Literal></p>
                

                <%-- Showtimes Section --%>
                <h4 class="fw-bold mb-3"><i class="fas fa-calendar-alt text-primary me-2"></i>Select Showtime</h4>
                <asp:Repeater ID="rptShowtimes" runat="server">
                    <HeaderTemplate>
                        <div class="row g-3 mb-5">
                    </HeaderTemplate>
                    <ItemTemplate>
                        <div class="col-sm-6">
                            <div class="card h-100 border-0 shadow-sm rounded-4 overflow-hidden hover-lift">
                                <div class="card-body p-4 d-flex justify-content-between align-items-center">
                                    <div>
                                        <h6 class="fw-bold mb-1 text-primary"><%# Eval("TheaterName") %></h6>
                                        <p class="mb-0 small text-muted"><i class="far fa-clock me-2"></i><%# Eval("StartTime", "{0:f}") %></p>
                                    </div>
                                    <div class="text-end">
                                        <div class="fw-bold fs-5 mb-2">$<%# Eval("Price") %></div>
                                        <a href='<%# "BookTicket.aspx?showId=" + Eval("ShowtimeId") %>' class="btn btn-primary rounded-pill btn-sm px-4 shadow-sm">Book</a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>
                    <FooterTemplate>
                        </div>
                    </FooterTemplate>
                </asp:Repeater>
                <asp:Label ID="lblNoShows" runat="server" Text="No upcoming shows available for this movie." Visible="false" CssClass="alert alert-info d-block rounded-pill text-center"></asp:Label>

                <hr class="my-5 opacity-25" />

                <%-- Ratings Section --%>
                <div class="row g-4">
                    <div class="col-md-6">
                        <h4 class="fw-bold mb-4">Reviews & Ratings</h4>
                        <asp:Repeater ID="rptReviews" runat="server">
                            <ItemTemplate>
                                <div class="card border-0 shadow-sm rounded-pill mb-3 overflow-hidden">
                                    <div class="card-body py-2 px-3 d-flex align-items-center">
                                         <div class="avatar-sm me-3 bg-primary text-white text-center rounded-circle" style="width: 32px; height: 32px; line-height:32px; font-size: 0.8rem;">
                                             <%# GetInitials(Eval("Username")) %>
                                         </div>
                                        <div class="flex-grow-1">
                                            <div class="d-flex justify-content-between">
                                                <span class="small fw-bold"><%# Eval("Username") %></span>
                                                 <span class="text-warning small">
                                                     <%# GetStarRating(Eval("Score")) %>
                                                 </span>
                                            </div>
                                            <p class="mb-0 x-small text-muted text-truncate" style="max-width: 250px;"><%# Eval("Comment") %></p>
                                        </div>
                                    </div>
                                </div>
                            </ItemTemplate>
                            <FooterTemplate>
                                <asp:Label runat="server" Visible='<%# rptReviews.Items.Count == 0 %>' Text="No reviews yet. Be the first!" CssClass="text-muted small italic"></asp:Label>
                            </FooterTemplate>
                        </asp:Repeater>
                    </div>
                    <div class="col-md-6">
                        <asp:PlaceHolder ID="phAddReview" runat="server">
                            <div class="card border-0 shadow-sm rounded-4 bg-light">
                                <div class="card-body p-4">
                                    <h6 class="fw-bold mb-3">Leave a Review</h6>
                                    <asp:DropDownList ID="ddlUserRating" runat="server" CssClass="form-select form-select-sm mb-3 rounded-pill px-3">
                                        <asp:ListItem Text="Select Star" Value="0" />
                                        <asp:ListItem Text="5 Stars - Excellent" Value="5" />
                                        <asp:ListItem Text="4 Stars - Great" Value="4" />
                                        <asp:ListItem Text="3 Stars - Good" Value="3" />
                                        <asp:ListItem Text="2 Stars - OK" Value="2" />
                                        <asp:ListItem Text="1 Star - Poor" Value="1" />
                                    </asp:DropDownList>
                                    <asp:TextBox ID="txtComment" runat="server" CssClass="form-control rounded-4 mb-3" TextMode="MultiLine" Rows="2" placeholder="Tell us what you thought..."></asp:TextBox>
                                    <asp:Button ID="btnSubmitReview" runat="server" Text="Post Review" CssClass="btn btn-primary btn-sm rounded-pill px-4 w-100 fw-bold" OnClick="btnSubmitReview_Click" />
                                </div>
                            </div>
                        </asp:PlaceHolder>
                        <asp:PlaceHolder ID="phLoginPrompt" runat="server" Visible="false">
                            <div class="card border-0 shadow-sm rounded-4 bg-light-subtle border border-dashed text-center">
                                <div class="card-body p-5">
                                    <i class="fas fa-lock text-muted mb-3 fa-2x"></i>
                                    <h6 class="fw-bold">Want to share your thoughts?</h6>
                                    <p class="text-muted small mb-3">Please log in to leave a movie review.</p>
                                    <a href="Login.aspx" class="btn btn-outline-primary btn-sm rounded-pill px-4">Login Now</a>
                                </div>
                            </div>
                        </asp:PlaceHolder>
                    </div>
                </div>
            </div>
        </div>
    </asp:PlaceHolder>

    <div id="divError" runat="server" visible="false" class="text-center py-5">
        <i class="fas fa-exclamation-circle fa-4x text-danger opacity-25 mb-4"></i>
        <h3 class="fw-bold">We missed the screening...</h3>
        <p class="text-muted">Sorry, we couldn't find the movie details you're looking for.</p>
        <a href="Movies.aspx" class="btn btn-primary rounded-pill px-4 mt-3">Back to Movies</a>
    </div>

    <style>
        .hover-lift { transition: transform 0.3s ease; }
        .hover-lift:hover { transform: translateY(-5px); }
        .x-small { font-size: 0.75rem; }
        .bg-primary-subtle { background-color: #e0e7ff; }
        .bg-success-subtle { background-color: #dcfce7; }
        .bg-dark-subtle { background-color: #f1f5f9; }
    </style>
</asp:Content>
