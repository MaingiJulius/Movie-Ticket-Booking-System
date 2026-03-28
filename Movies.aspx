<%@ Page Title="Movies" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Movies.aspx.cs" Inherits="MovieTicketBooking.MoviesPage" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row mb-5 align-items-end g-3">
        <div class="col-md-4">
            <h2 class="display-6 fw-bold text-primary mb-0">Now Showing</h2>
            <p class="text-muted mb-0">Discover the latest blockbusters</p>
        </div>
        <div class="col-md-8">
            <div class="input-group shadow-sm rounded-pill overflow-hidden">
                <span class="input-group-text border-0 bg-white"><i class="fas fa-search text-muted"></i></span>
                <asp:TextBox ID="txtSearch" runat="server" CssClass="form-control border-0 py-3 px-2" placeholder="Search by title..."></asp:TextBox>
                <asp:DropDownList ID="ddlCategory" runat="server" CssClass="form-select border-0 border-start" style="max-width: 180px;">
                    <asp:ListItem Text="All Categories" Value="" />
                    <asp:ListItem Text="Action" Value="Action" />
                    <asp:ListItem Text="Animation" Value="Animation" />
                    <asp:ListItem Text="Biography" Value="Biography" />
                    <asp:ListItem Text="Comedy" Value="Comedy" />
                    <asp:ListItem Text="Crime" Value="Crime" />
                    <asp:ListItem Text="Drama" Value="Drama" />
                    <asp:ListItem Text="Fantasy" Value="Fantasy" />
                    <asp:ListItem Text="History" Value="History" />
                    <asp:ListItem Text="Horror" Value="Horror" />
                    <asp:ListItem Text="Sci-Fi" Value="Sci-Fi" />
                    <asp:ListItem Text="Thriller" Value="Thriller" />
                </asp:DropDownList>
                <asp:Button ID="btnSearch" runat="server" Text="Explore" CssClass="btn btn-primary px-4 fw-bold" OnClick="btnSearch_Click" />
            </div>
        </div>
    </div>

    <asp:UpdatePanel ID="upMovies" runat="server">
        <ContentTemplate>
            <asp:Repeater ID="rptMovies" runat="server">
                <HeaderTemplate>
                    <div class="row row-cols-1 row-cols-sm-2 row-cols-md-3 row-cols-lg-4 g-4">
                </HeaderTemplate>
                <ItemTemplate>
                    <div class="col">
                        <div class="card h-100 movie-card-premium shadow border-0 overflow-hidden">
                            <!-- Uniform Poster Image -->
                            <div class="position-relative overflow-hidden" style="height: 380px;">
                                <img src='<%# GetMoviePoster(Eval("PosterUrl")) %>' 
                                     class="w-100 h-100" 
                                     style="object-fit: cover; transition: transform 0.5s ease;"
                                     alt="<%# Eval("Title") %>" 
                                     onerror="this.src='data:image/svg+xml;charset=UTF-8,%3Csvg%20width%3D%22400%22%20height%3D%22600%22%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3E%3Crect%20width%3D%22100%25%22%20height%3D%22100%25%22%20fill%3D%22%23f1f5f9%22%2F%3E%3Ctext%20x%3D%2250%25%22%20y%3D%2250%25%22%20font-family%3D%22Arial%22%20font-size%3D%2224%22%20fill%3D%22%2364748b%22%20text-anchor%3D%22middle%22%20dy%3D%22.3em%22%3ENo%20Poster%3C%2Ftext%3E%3C%2Fsvg%3E';">
                                
                                <!-- Content Rating Badge (Top Right) -->
                                <div class="position-absolute top-0 end-0 p-2">
                                    <span class='badge <%# GetRatingClass(Eval("Rating")) %> shadow-sm rounded-pill px-3 py-2'>
                                        <%# Eval("Rating") %>
                                    </span>
                                </div>
                                
                                <!-- Genre Badge (Bottom Left overlay) -->
                                <div class="position-absolute bottom-0 start-0 p-3">
                                    <span class="badge bg-primary rounded-pill shadow"><%# Eval("Genre") %></span>
                                </div>
                            </div>

                            <!-- Visible Movie Info -->
                            <div class="card-body p-3">
                                <h5 class="fw-bold mb-1 text-truncate" title='<%# Eval("Title") %>'><%# Eval("Title") %></h5>
                                <div class="mb-3 text-center">
                                    <div class="small text-muted">
                                        <i class="far fa-clock me-1"></i><%# Eval("Duration") %> mins
                                    </div>
                                </div>
                                <a href='MovieDetails.aspx?id=<%# Eval("MovieId") %>' class="btn btn-outline-primary w-100 rounded-pill fw-bold">
                                    <i class="fas fa-info-circle me-2"></i>VIEW DETAILS
                                </a>
                            </div>
                        </div>
                    </div>
                </ItemTemplate>
                <FooterTemplate>
                    </div>
                </FooterTemplate>
            </asp:Repeater>

            <div id="divNoResults" runat="server" visible="false" class="text-center py-5">
                <div class="mb-4">
                    <i class="fas fa-search-minus fa-4x text-muted opacity-25"></i>
                </div>
                <h3 class="fw-bold text-secondary mb-3">Cinema mystery!</h3>
                <p class="text-muted mb-4">We couldn't find any movies matching your search. Try adjusting your lens!</p>
                <asp:LinkButton ID="btnReset" runat="server" CssClass="btn btn-primary rounded-pill px-5 py-2 shadow-sm fw-bold" OnClick="btnReset_Click">
                    <i class="fas fa-redo me-2"></i>Show All Movies
                </asp:LinkButton>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnSearch" EventName="Click" />
        </Triggers>
    </asp:UpdatePanel>

    <%-- Success/Info Toast for no results --%>
    <div class="toast-container position-fixed bottom-0 end-0 p-3">
      <div id="infoToast" class="toast hide shadow-lg border-0" role="alert" aria-live="assertive" aria-atomic="true">
        <div class="toast-header bg-info text-white">
          <i class="fas fa-info-circle me-2"></i>
          <strong class="me-auto">Search Result</strong>
          <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast" aria-label="Close"></button>
        </div>
        <div class="toast-body" id="toastBody">
          Sorry, no movies found.
        </div>
      </div>
    </div>
</asp:Content>
