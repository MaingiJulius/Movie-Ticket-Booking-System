<%@ Page Title="Manage Showtimes" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageShowtimes.aspx.cs" Inherits="MovieTicketBooking.Admin.ManageShowtimes" %>

<%-- No head content --%>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <div>
            <h2 class="text-primary fw-bold mb-0">Manage Showtimes</h2>
            <p class="text-muted">Schedule and manage movie screenings across theaters</p>
        </div>
        <button type="button" class="btn btn-primary rounded-pill shadow-sm py-2 px-4" data-bs-toggle="modal" data-bs-target="#addShowtimeModal">
            <i class="fas fa-plus me-2"></i>Add New Showtime
        </button>
    </div>

    <asp:Label ID="lblMsg" runat="server" CssClass="alert alert-success d-block mb-3 rounded-pill shadow-sm border-0" Visible="false" />

    <div class="card glass-card border-0 shadow-sm overflow-hidden rounded-4">
        <div class="card-body p-0">
            <asp:GridView ID="gvShowtimes" runat="server" AutoGenerateColumns="False"
                CssClass="table table-hover mb-0 align-middle" GridLines="None"
                OnRowCommand="gvShowtimes_RowCommand" DataKeyNames="ShowtimeId"
                OnRowEditing="gvShowtimes_RowEditing"
                OnRowCancelingEdit="gvShowtimes_RowCancelingEdit"
                OnRowUpdating="gvShowtimes_RowUpdating">
                <HeaderStyle CssClass="bg-light text-secondary border-bottom py-3" />
                <Columns>
                    <asp:BoundField DataField="ShowtimeId" HeaderText="ID" ReadOnly="True" ItemStyle-CssClass="fw-bold px-4" />
                    <asp:BoundField DataField="Title" HeaderText="Movie" ReadOnly="True" ItemStyle-CssClass="fw-semibold" />
                    <asp:TemplateField HeaderText="Theater/Hall">
                        <ItemTemplate><%# Eval("TheaterName") %></ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEditTheater" runat="server" Text='<%# Bind("TheaterName") %>' CssClass="form-control form-control-sm" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Date & Time">
                        <ItemTemplate><%# Eval("StartTime", "{0:g}") %></ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEditStartTime" runat="server" Text='<%# Bind("StartTime", "{0:yyyy-MM-ddTHH:mm}") %>' TextMode="DateTimeLocal" CssClass="form-control form-control-sm" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Price ($)">
                        <ItemTemplate><%# Eval("Price", "{0:N2}") %></ItemTemplate>
                        <EditItemTemplate>
                            <asp:TextBox ID="txtEditPrice" runat="server" Text='<%# Bind("Price") %>' CssClass="form-control form-control-sm" />
                        </EditItemTemplate>
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Operations" ItemStyle-CssClass="text-end px-4">
                        <ItemTemplate>
                            <asp:LinkButton ID="btnEdit" runat="server" CommandName="Edit" CssClass="btn btn-sm btn-outline-primary border-0 me-2" ToolTip="Edit">
                                <i class="fas fa-edit"></i>
                            </asp:LinkButton>
                            <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteShowtime"
                                CommandArgument='<%# Eval("ShowtimeId") %>' CssClass="btn btn-sm btn-danger rounded-pill px-3 shadow-sm"
                                OnClientClick="return confirm('Delete this showtime?');">
                                <i class="fas fa-trash-alt me-1"></i>Delete
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
                        <i class="fas fa-calendar-times fa-3x text-muted opacity-25 mb-3"></i>
                        <p class="text-muted">No showtimes found.</p>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>

    <!-- Add Showtime Modal -->
    <div class="modal fade" id="addShowtimeModal" tabindex="-1">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Add New Showtime</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="mb-3">
                        <label>Movie</label>
                        <asp:DropDownList ID="ddlMovies" runat="server" CssClass="form-select" DataTextField="Title" DataValueField="MovieId" />
                    </div>
                    <div class="mb-3">
                        <label>Theater / Hall Name</label>
                        <asp:TextBox ID="txtTheater" runat="server" CssClass="form-control" placeholder="e.g. Hall A" />
                    </div>
                    <div class="mb-3">
                        <label>Date & Time</label>
                        <asp:TextBox ID="txtStartTime" runat="server" CssClass="form-control" TextMode="DateTimeLocal" />
                    </div>
                    <div class="mb-3">
                        <label>Ticket Price ($)</label>
                        <asp:TextBox ID="txtPrice" runat="server" CssClass="form-control" placeholder="e.g. 12.50" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
                    <asp:Button ID="btnSave" runat="server" Text="Save Showtime" CssClass="btn btn-primary" OnClick="btnSave_Click" />
                </div>
            </div>
        </div>
    </div>
</asp:Content>
