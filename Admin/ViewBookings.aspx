<%@ Page Title="View Bookings" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ViewBookings.aspx.cs" Inherits="MovieTicketBooking.Admin.ViewBookings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="server">
    <div class="mb-4 d-flex justify-content-between align-items-center">
        <div>
            <h2 class="text-primary fw-bold mb-0">Comprehensive Booking View</h2>
            <p class="text-muted">Detailed list of all transactions and reservations</p>
        </div>
        <a href="AdminDashboard.aspx" class="btn btn-outline-secondary rounded-pill px-4">
            <i class="fas fa-arrow-left me-2"></i>Back to Dashboard
        </a>
    </div>

    <asp:UpdatePanel ID="upBookings" runat="server">
        <ContentTemplate>
            <div class="card glass-card border-0 shadow-sm overflow-hidden rounded-4 mb-4">
                <div class="card-body p-0">
                    <asp:GridView ID="gvAllBookings" runat="server" AutoGenerateColumns="False"
                        CssClass="table table-hover mb-0 align-middle" GridLines="None" 
                        DataKeyNames="BookingId" OnRowCommand="gvAllBookings_RowCommand">
                        <HeaderStyle CssClass="bg-light text-secondary border-bottom py-3" />
                        <Columns>
                            <asp:BoundField DataField="BookingId" HeaderText="Booking ID" ItemStyle-CssClass="fw-bold px-4" />
                            <asp:TemplateField HeaderText="Customer">
                                <ItemTemplate>
                                    <div class="d-flex align-items-center">
                                        <div class="bg-primary-subtle text-primary rounded-circle p-2 me-2 x-small">
                                            <i class="fas fa-user"></i>
                                        </div>
                                        <span class="fw-semibold"><%# Eval("Username") %></span>
                                    </div>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:BoundField DataField="Title" HeaderText="Movie" ItemStyle-CssClass="fw-semibold" />
                            <asp:BoundField DataField="TheaterName" HeaderText="Theater" />
                            <asp:BoundField DataField="StartTime" HeaderText="Showtime" DataFormatString="{0:g}" />
                            <asp:BoundField DataField="TotalAmount" HeaderText="Amount" DataFormatString="${0:N2}" ItemStyle-CssClass="fw-bold text-success" />
                            <asp:TemplateField HeaderText="Status">
                                <ItemTemplate>
                                    <span class='badge <%# GetStatusBadgeClass(Eval("Status")) %> px-3 rounded-pill'>
                                        <%# Eval("Status") %>
                                    </span>
                                </ItemTemplate>
                            </asp:TemplateField>
                            <asp:TemplateField HeaderText="Actions" ItemStyle-CssClass="text-end px-4">
                                <ItemTemplate>
                                    <asp:LinkButton ID="btnCancel" runat="server" CommandName="CancelBooking" 
                                        CommandArgument='<%# Eval("BookingId") %>' CssClass="btn btn-sm btn-outline-warning border-0 me-1"
                                        Visible='<%# Eval("Status").ToString() == "Confirmed" %>'
                                        OnClientClick="return confirm('Are you sure you want to cancel this booking?');">
                                        <i class="fas fa-ban me-1"></i>Cancel
                                    </asp:LinkButton>
                                    <button type="button" class="btn btn-sm btn-outline-primary border-0 me-1 btn-print-ticket"
                                        data-bookingid='<%# Eval("BookingId") %>'
                                        data-fullname='<%# Eval("FullName") %>'
                                        data-movie='<%# Eval("Title") %>'
                                        data-date='<%# Eval("StartTime", "{0:g}") %>'
                                        data-theater='<%# Eval("TheaterName") %>'
                                        data-seats='<%# Eval("Seats") %>'
                                        data-amount='<%# Eval("TotalAmount", "${0:N2}") %>'>
                                        <i class="fas fa-print me-1"></i>Print
                                    </button>
                                    <asp:LinkButton ID="btnDelete" runat="server" CommandName="DeleteBooking" 
                                        CommandArgument='<%# Eval("BookingId") %>' CssClass="btn btn-sm btn-outline-danger border-0"
                                        OnClientClick="return confirm('PERMANENT DELETE: Are you sure? This cannot be undone.');">
                                        <i class="fas fa-trash-alt me-1"></i>Delete
                                    </asp:LinkButton>
                                </ItemTemplate>
                            </asp:TemplateField>
                        </Columns>
                        <EmptyDataTemplate>
                            <div class="text-center py-5">
                                <i class="fas fa-receipt fa-4x text-muted opacity-25 mb-3"></i>
                                <p class="text-muted">No booking records found.</p>
                            </div>
                        </EmptyDataTemplate>
                    </asp:GridView>
                </div>
            </div>
        </ContentTemplate>
    </asp:UpdatePanel>

    <div class="row justify-content-end px-4">
        <div class="col-md-4">
            <div class="card bg-dark text-white rounded-4 shadow-sm border-0">
                <div class="card-body p-4 d-flex justify-content-between align-items-center">
                    <div>
                        <span class="text-white-50 small text-uppercase d-block mb-1">Grand Total (Confirmed)</span>
                        <h2 class="fw-bold mb-0 text-success">$<asp:Literal ID="litGrandTotal" runat="server" /></h2>
                    </div>
                    <i class="fas fa-cash-register fa-2x opacity-25"></i>
                </div>
            </div>
        </div>
    </div>
</asp:Content>
