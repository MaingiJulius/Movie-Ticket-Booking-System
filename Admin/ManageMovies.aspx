<%@ Page Title="Manage Movies" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageMovies.aspx.cs" Inherits="MovieTicketBooking.ManageMovies" MaintainScrollPositionOnPostback="true" %>

<%-- No head content --%>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="text-primary fw-bold mb-0">Manage Movies</h2>
            <p class="text-muted">Add, edit, or deactivate movies and manage theater listings</p>
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
                        OnRowCommand="gvMovies_RowCommand" DataKeyNames="MovieId"
                        OnRowEditing="gvMovies_RowEditing" 
                        OnRowCancelingEdit="gvMovies_RowCancelingEdit" 
                        OnRowUpdating="gvMovies_RowUpdating">
                        <HeaderStyle CssClass="bg-light text-secondary border-bottom py-3" />
                        <Columns>
                            <asp:BoundField DataField="MovieId" HeaderText="Movie ID" ReadOnly="True" ItemStyle-CssClass="fw-bold px-4" />
                            <asp:BoundField DataField="Title" HeaderText="Title" ItemStyle-CssClass="fw-semibold" />
                            <asp:BoundField DataField="Genre" HeaderText="Genre" />
                            <asp:TemplateField HeaderText="Poster Image">
                                <ItemTemplate>
                                    <asp:Image ID="imgPosterPreview" runat="server" ImageUrl='<%# Eval("PosterUrl").ToString().StartsWith("http") ? Eval("PosterUrl") : "~/Content/Images/" + Eval("PosterUrl") %>' CssClass="rounded shadow-sm" Width="40" Height="60" />
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:FileUpload ID="fuEditPoster" runat="server" CssClass="form-control form-control-sm mb-1" onchange="encodeImageFileAsURL(this);" />
                                    <asp:HiddenField ID="hfNewPosterBase64" runat="server" />
                                    <asp:HiddenField ID="hfCurrentPoster" runat="server" Value='<%# Eval("PosterUrl") %>' />
                                    <small class="x-small text-muted">Leave blank to keep current</small>
                                </EditItemTemplate>
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
                                    <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" CssClass="btn btn-sm btn-outline-primary border-0 me-2" ToolTip="Edit Movie">
                                        <i class="fas fa-edit"></i>
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteMovie" 
                                        CommandArgument='<%# Eval("MovieId") %>' CssClass="btn btn-sm btn-outline-danger border-0" 
                                        Visible='<%# Convert.ToBoolean(Eval("IsActive")) %>'
                                        OnClientClick="return confirm('Are you sure you want to deactivate this movie?');" ToolTip="Deactivate">
                                        <i class="fas fa-trash-alt"></i>
                                    </asp:LinkButton>
                                </ItemTemplate>
                                <EditItemTemplate>
                                    <asp:LinkButton ID="btnUpdate" runat="server" CommandName="Update" CssClass="btn btn-sm btn-success rounded-pill px-3 me-1">
                                        <i class="fas fa-save me-1"></i>Save
                                    </asp:LinkButton>
                                    <asp:LinkButton ID="btnCancel" runat="server" CommandName="Cancel" CssClass="btn btn-sm btn-light rounded-pill px-3">
                                        <i class="fas fa-times me-1"></i>Cancel
                                    </asp:LinkButton>
                                </EditItemTemplate>
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
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="gvMovies" />
        </Triggers>
    </asp:UpdatePanel>

    <script type="text/javascript">
        function encodeImageFileAsURL(element) {
            var file = element.files[0];
            if (file) {
                var reader = new FileReader();
                reader.onloadend = function () {
                    // Find the hidden field in the same container.
                    var parent = element.parentElement;
                    var hiddenField = parent.querySelector('input[id*="hfNewPosterBase64"]');
                    // Because WebForms mangles IDs, we find it by the static suffix we gave it
                    if (hiddenField) {
                        hiddenField.value = reader.result;
                    }
                }
                reader.readAsDataURL(file);
            }
        }
    </script>

    <!-- Add Movie Modal -->
    <div class="modal fade" id="addMovieModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Movie</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label small fw-bold text-muted">Title</label>
                            <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control rounded-pill px-3" />
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label small fw-bold text-muted">Genre</label>
                            <asp:TextBox ID="txtGenre" runat="server" CssClass="form-control rounded-pill px-3" />
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4 mb-3">
                            <label class="form-label small fw-bold text-muted">Duration (min)</label>
                            <asp:TextBox ID="txtDuration" runat="server" CssClass="form-control rounded-pill px-3" />
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label small fw-bold text-muted">Language</label>
                            <asp:TextBox ID="txtLanguage" runat="server" CssClass="form-control rounded-pill px-3" />
                        </div>
                        <div class="col-md-4 mb-3">
                            <label class="form-label small fw-bold text-muted">Rating</label>
                            <asp:TextBox ID="txtRating" runat="server" CssClass="form-control rounded-pill px-3" />
                        </div>
                    </div>
                    <div class="mb-3">
                        <label class="form-label small fw-bold text-muted">Description</label>
                        <asp:TextBox ID="txtDesc" runat="server" CssClass="form-control rounded-3" TextMode="MultiLine" Rows="3" />
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
