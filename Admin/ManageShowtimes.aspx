<%@ Page Title="Manage Showtimes" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageShowtimes.aspx.cs" Inherits="MovieTicketBooking.Admin.ManageShowtimes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Manage Showtimes</h2>
        <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#addShowtimeModal">
            Add New Showtime
        </button>
    </div>

    <asp:Label ID="lblMsg" runat="server" CssClass="alert alert-success d-block mb-3" Visible="false" />

    <asp:GridView ID="gvShowtimes" runat="server" AutoGenerateColumns="False"
        CssClass="table table-hover shadow-sm" OnRowCommand="gvShowtimes_RowCommand" DataKeyNames="ShowtimeId"
        AutoGenerateEditButton="True"
        OnRowEditing="gvShowtimes_RowEditing"
        OnRowCancelingEdit="gvShowtimes_RowCancelingEdit"
        OnRowUpdating="gvShowtimes_RowUpdating">
        <Columns>
            <asp:BoundField DataField="ShowtimeId" HeaderText="ID" ReadOnly="True" />
            <asp:BoundField DataField="Title" HeaderText="Movie" ReadOnly="True" />
            <asp:BoundField DataField="TheaterName" HeaderText="Theater/Hall" />
            <asp:BoundField DataField="StartTime" HeaderText="Date & Time" />
            <asp:BoundField DataField="Price" HeaderText="Price ($)" />
            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteShowtime"
                        CommandArgument='<%# Eval("ShowtimeId") %>' CssClass="btn btn-sm btn-outline-danger"
                        OnClientClick="return confirm('Delete this showtime?');">Delete</asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

    <asp:Label ID="lblNoData" runat="server" Text="No showtimes available." Visible="false" CssClass="text-muted" />

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
