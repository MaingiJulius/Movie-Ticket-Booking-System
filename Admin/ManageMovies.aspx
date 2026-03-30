<%@ Page Title="Manage Movies" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageMovies.aspx.cs" Inherits="MovieTicketBooking.ManageMovies" MaintainScrollPositionOnPostback="true" %>

<%-- No head content --%>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <style>
        .rating-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 32px;
            height: 32px;
            border-radius: 6px;
            font-weight: 800;
            font-size: 0.75rem;
            margin-right: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }
        .rating-g { background-color: #28a745; color: white; }
        .rating-pg { background-color: #ffc107; color: #333; }
        .rating-pg13 { background-color: #fd7e14; color: white; }
        .rating-r { background-color: #dc3545; color: white; border: 2px solid #ffc107; }
        .rating-nc17 { background-color: #6f42c1; color: white; }
        
        .glass-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.2);
        }
        .x-small { font-size: 0.7rem; }
    </style>

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="text-primary fw-bold mb-0">Manage Movies</h2>
            <p class="text-muted">Add, modify, or deactivate movies and manage theater listings</p>
        </div>
        <button type="button" class="btn btn-primary rounded-pill shadow-sm py-2 px-4" data-bs-toggle="modal" data-bs-target="#addMovieModal">
            <i class="fas fa-plus me-2"></i>Add New Movie
        </button>
    </div>

    <asp:UpdatePanel ID="upMovies" runat="server">
        <ContentTemplate>
            <div class="card glass-card border-0 shadow-sm overflow-hidden">
                <div class="card-body p-0">
                    <asp:GridView ID="gvMovies" runat="server" AutoGenerateColumns="False" 
                        CssClass="table table-hover mb-0 align-middle" GridLines="None"
                        OnRowCommand="gvMovies_RowCommand" DataKeyNames="MovieId">
                        <HeaderStyle CssClass="bg-light text-secondary border-bottom py-3" />
                        <Columns>
                            <asp:BoundField DataField="MovieId" HeaderText="Movie ID" ReadOnly="True" ItemStyle-CssClass="fw-bold px-4" />
                            <asp:BoundField DataField="Title" HeaderText="Title" ItemStyle-CssClass="fw-semibold" />
                            <asp:BoundField DataField="Genre" HeaderText="Genre" />
                            <asp:TemplateField HeaderText="Poster Image">
                                <ItemTemplate>
                                    <asp:Image ID="imgPosterPreview" runat="server" ImageUrl='<%# Eval("PosterUrl") != null && Eval("PosterUrl").ToString().StartsWith("http") ? Eval("PosterUrl") : "~/Content/Images/" + Eval("PosterUrl") %>' CssClass="rounded shadow-sm" Width="40" Height="60" />
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class='badge <%# GetStatusBadgeClass(Eval("IsActive")) %> px-3 rounded-pill'>
                                        <%# GetStatusText(Eval("IsActive")) %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Operations" ItemStyle-CssClass="text-end px-4">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnModify" runat="server" CommandName="ModifyMovie" 
                                        CommandArgument='<%# Eval("MovieId") %>' CssClass="btn btn-sm btn-outline-info rounded-pill px-3 me-2" ToolTip="Modify Movie">
                                        <i class="fas fa-sliders-h me-1"></i>Modify
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteMovie" 
                                        CommandArgument='<%# Eval("MovieId") %>' CssClass="btn btn-sm btn-outline-danger border-0" 
                                        OnClientClick="return confirm('WARNING: This will permanently delete the movie and ALL related bookings, showtimes, and ratings. Proceed?');" ToolTip="Permanently Delete">
                                        <i class="fas fa-trash-alt"></i>
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="text-center py-5">
                                <i class="fas fa-film fa-3x text-muted opacity-25 mb-3"></i>
                                <p class="text-muted">No movies found.</p>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>

            <!-- Edit/Modify Movie Modal -->
            <asp:HiddenField ID="hfShowEditModal" runat="server" Value="false" />
            <asp:HiddenField ID="hfEditMovieId" runat="server" />
            <div class="modal fade" id="editMovieModal" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content border-0 shadow">
                        <div class="modal-header bg-info text-white border-0">
                            <h5 class="modal-title fw-bold">Modify Movie Details</h5>
                            <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body p-4">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label small fw-bold text-muted">Title</label>
                                    <asp:TextBox ID="txtEditTitle" runat="server" CssClass="form-control rounded-pill px-3" />
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label small fw-bold text-muted">Genre</label>
                                    <asp:TextBox ID="txtEditGenre" runat="server" CssClass="form-control rounded-pill px-3" />
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-4 mb-3">
                                    <label class="form-label small fw-bold text-muted">Duration (min)</label>
                                    <asp:TextBox ID="txtEditDuration" runat="server" CssClass="form-control rounded-pill px-3" />
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label small fw-bold text-muted">Language</label>
                                    <asp:TextBox ID="txtEditLanguage" runat="server" CssClass="form-control rounded-pill px-3" />
                                </div>
                                <div class="col-md-4 mb-3">
                                    <label class="form-label small fw-bold text-muted">Rating</label>
                                    <div class="d-flex align-items-center">
                                        <span id="editRatingPreview" class="rating-badge rating-g">G</span>
                                        <asp:DropDownList ID="ddlEditRating" runat="server" CssClass="form-select rounded-pill px-3" onchange="updateRatingSign(this, 'editRatingPreview')">
                                            <asp:ListItem Value="G">G</asp:ListItem>
                                            <asp:ListItem Value="PG">PG</asp:ListItem>
                                            <asp:ListItem Value="PG-13">PG-13</asp:ListItem>
                                            <asp:ListItem Value="R">R</asp:ListItem>
                                            <asp:ListItem Value="NC-17">NC-17</asp:ListItem>
                                        </asp:DropDownList>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label small fw-bold text-muted">Status</label>
                                    <asp:DropDownList ID="ddlEditStatus" runat="server" CssClass="form-select rounded-pill px-3">
                                        <asp:ListItem Value="true">Active (Now Showing)</asp:ListItem>
                                        <asp:ListItem Value="false">Inactive / Hidden</asp:ListItem>
                                    </asp:DropDownList>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label small fw-bold text-muted">Current Poster</label>
                                    <div class="d-flex align-items-center bg-light p-2 rounded-3">
                                        <asp:Image ID="imgEditPosterCurrent" runat="server" CssClass="rounded shadow-sm me-3" Width="40" Height="60" />
                                        <div class="small text-muted overflow-hidden flex-grow-1">
                                            <asp:Label ID="lblCurrentPosterName" runat="server" CssClass="d-block text-truncate" />
                                            <asp:HiddenField ID="hfCurrentEditPoster" runat="server" />
                                        </div>
                                        <div class="form-check ms-2" title="Check this to remove the current image and reset to default poster.">
                                            <asp:CheckBox ID="chkRemovePoster" runat="server" CssClass="form-check-input" />
                                            <label class="form-check-label x-small text-danger fw-bold">Remove Image</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">Full Movie Description</label>
                                <asp:TextBox ID="txtEditDesc" runat="server" CssClass="form-control rounded-3" TextMode="MultiLine" Rows="4" />
                            </div>
                            <div class="mb-3">
                                <label class="form-label small fw-bold text-muted">Replace Poster Image (Optional)</label>
                                <asp:FileUpload ID="fuEditPosterUrl" runat="server" CssClass="form-control rounded-pill" onchange="encodeImageFileAsURL(this, 'MainContent_hfEditPosterBase64');" />
                                <asp:HiddenField ID="hfEditPosterBase64" runat="server" />
                            </div>
                        </div>
                        <div class="modal-footer border-0">
                            <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                            <asp:Button ID="btnUpdateMovie" runat="server" Text="Update Movie" CssClass="btn btn-info text-white rounded-pill px-4 shadow-sm" OnClick="btnUpdateMovie_Click" />
                        </div>
                    </div>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <script type="text/javascript">
        function encodeImageFileAsURL(element, hiddenFieldId) {
            var file = element.files[0];
            if (file) {
                var reader = new FileReader();
                reader.onloadend = function () {
                    var hiddenField = document.getElementById(hiddenFieldId);
                    if (hiddenField) {
                        hiddenField.value = reader.result;
                    }
                }
                reader.readAsDataURL(file);
            }
        }
        
        function updateRatingSign(dropdown, previewId) {
            var val = dropdown.value;
            var preview = document.getElementById(previewId);
            if (preview) {
                preview.className = 'rating-badge rating-' + val.toLowerCase().replace('-', '');
                preview.innerText = val;
            }
        }

        // Handle WebForms Async Postbacks to re-attach events or show modals
        var prm = Sys.WebForms.PageRequestManager.getInstance();
        prm.add_endRequest(function (sender, args) {
            // Clean up backdrop and body styles regardless of errors to keep UI responsive
            document.querySelectorAll('.modal-backdrop').forEach(el => el.remove());
            document.body.classList.remove('modal-open');
            document.body.style.overflow = '';
            document.body.style.paddingRight = '';

            if (args.get_error() === null) {
                // Check if we need to show the edit modal
                var hfShow = document.getElementById('<%= hfShowEditModal.ClientID %>');
                var modalEl = document.getElementById('editMovieModal');
                
                if (hfShow && hfShow.value === "true") {
                    var myModal = new bootstrap.Modal(modalEl);
                    myModal.show();
                    // Reset hidden field
                    hfShow.value = "false";
                } else {
                    // Force hide modal if shown and not requested
                    var existingModal = bootstrap.Modal.getInstance(modalEl);
                    if (existingModal) existingModal.hide();
                }
            }
        });
    </script>

    <!-- Add Movie Modal -->
    <div class="modal fade" id="addMovieModal" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-primary text-white border-0">
                    <h5 class="modal-title fw-bold">Add New Movie</h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label small fw-bold text-muted">Title</label>
                            <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control rounded-pill px-3" placeholder="e.g. Inception" />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label small fw-bold text-muted">Genre</label>
                            <asp:TextBox ID="txtGenre" runat="server" CssClass="form-control rounded-pill px-3" placeholder="e.g. Sci-Fi, Action" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label small fw-bold text-muted">Duration (min)</label>
                            <asp:TextBox ID="txtDuration" runat="server" CssClass="form-control rounded-pill px-3" placeholder="120" />
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label small fw-bold text-muted">Language</label>
                            <asp:TextBox ID="txtLanguage" runat="server" CssClass="form-control rounded-pill px-3" placeholder="English" />
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label small fw-bold text-muted">Rating</label>
                            <div class="d-flex align-items-center">
                                <span id="addRatingPreview" class="rating-badge rating-g">G</span>
                                <asp:DropDownList ID="ddlRating" runat="server" CssClass="form-select rounded-pill px-3" onchange="updateRatingSign(this, 'addRatingPreview')">
                                    <asp:ListItem Value="G">G</asp:ListItem>
                                    <asp:ListItem Value="PG">PG</asp:ListItem>
                                    <asp:ListItem Value="PG-13">PG-13</asp:ListItem>
                                    <asp:ListItem Value="R">R</asp:ListItem>
                                    <asp:ListItem Value="NC-17">NC-17</asp:ListItem>
                                </asp:DropDownList>
                            </div>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Full Movie Description</label>
                        <asp:TextBox ID="txtDesc" runat="server" CssClass="form-control rounded-3" TextMode="MultiLine" Rows="4" placeholder="Enter movie synopsis..." />
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Upload Poster Image</label>
                        <asp:FileUpload ID="fuPosterUrl" runat="server" CssClass="form-control rounded-pill" />
                    </div>
                </div>
                <div class="modal-footer border-0">
                    <button type="button" class="btn btn-light rounded-pill px-4" data-bs-dismiss="modal">Cancel</button>
                    <asp:Button ID="btnSave" runat="server" Text="Save Movie" CssClass="btn btn-primary rounded-pill px-4 shadow-sm" OnClick="btnSave_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
