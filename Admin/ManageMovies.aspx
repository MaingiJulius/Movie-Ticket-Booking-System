<%@ Page Title="Manage Movies" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageMovies.aspx.cs" Inherits="MovieTicketBooking.ManageMovies" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Manage Movies</h2>
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addMovieModal">
            Add New Movie
        </button>
    </div>

    <asp:GridView ID="gvMovies" runat="server" AutoGenerateColumns="False" CssClass="table table-hover shadow-sm" 
        OnRowCommand="gvMovies_RowCommand" DataKeyNames="MovieId"
        AutoGenerateEditButton="True"
        OnRowEditing="gvMovies_RowEditing" 
        OnRowCancelingEdit="gvMovies_RowCancelingEdit" 
        OnRowUpdating="gvMovies_RowUpdating">
        <Columns>
            <asp:BoundField DataField="MovieId" HeaderText="ID" ReadOnly="True" />
            <asp:BoundField DataField="Title" HeaderText="Title" />
            <asp:BoundField DataField="Genre" HeaderText="Genre" />
            <asp:BoundField DataField="Language" HeaderText="Language" />
            <asp:TemplateField HeaderText="Poster Image">
                <ItemTemplate>
                    <asp:Image ID="imgPosterPreview" runat="server" ImageUrl='<%# Eval("PosterUrl").ToString().StartsWith("http") ? Eval("PosterUrl") : "~/Content/Images/" + Eval("PosterUrl") %>' Width="50" Height="75" />
                </ItemTemplate>
                <EditItemTemplate>
                    <asp:FileUpload ID="fuEditPoster" runat="server" />
                    <asp:HiddenField ID="hfCurrentPoster" runat="server" Value='<%# Eval("PosterUrl") %>' />
                    <small class="d-block text-muted">Leave blank to keep existing image</small>
                </EditItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Active">
                <ItemTemplate>
                    <span class='<%# Convert.ToBoolean(Eval("IsActive")) ? "badge bg-success" : "badge bg-danger" %>'>
                        <%# Convert.ToBoolean(Eval("IsActive")) ? "Yes" : "No" %>
                    </span>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteMovie" 
                        CommandArgument='<%# Eval("MovieId") %>' CssClass="btn btn-sm btn-outline-danger" 
                        OnClientClick="return confirm('Are you sure you want to deactivate this movie?');">
                        Deactivate
                    </asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

    <!-- Add Movie Modal -->
    <div class="modal fade" id="addMovieModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Movie</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label>Title</label>
                        <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <label>Genre</label>
                        <asp:TextBox ID="txtGenre" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <label>Duration (min)</label>
                        <asp:TextBox ID="txtDuration" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <label>Language</label>
                        <asp:TextBox ID="txtLanguage" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <label>Rating</label>
                        <asp:TextBox ID="txtRating" runat="server" CssClass="form-control" />
                    </div>
                    <div class="mb-3">
                        <label>Description</label>
                        <asp:TextBox ID="txtDesc" runat="server" CssClass="form-control" TextMode="MultiLine" Rows="3" />
                    </div>
                    <div class="mb-3">
                        <label>Upload Poster Image</label>
                        <asp:FileUpload ID="fuPosterUrl" runat="server" CssClass="form-control" />
                        <div class="form-text">Choose an image file from your computer (JPG, PNG). Overrides specific URLs.</div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <asp:Button ID="btnSave" runat="server" Text="Save Movie" CssClass="btn btn-primary" OnClick="btnSave_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
