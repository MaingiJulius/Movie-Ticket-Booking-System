<%@ Page Title="Manage Bookings" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageBookings.aspx.cs" Inherits="MovieTicketBooking.Admin.ManageBookings" %>

<%-- No head content --%>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="mb-4">
        <h2 class="text-primary fw-bold mb-0">Booking Management</h2>
        <p class="text-muted">Monitor customer reservations and track revenue</p>
    </div>

    <div class="card glass-card border-0 shadow-sm overflow-hidden rounded-4">
        <div class="card-body p-0">
            <asp:GridView ID="gvBookings" runat="server" AutoGenerateColumns="False"
                CssClass="table table-hover mb-0 align-middle" GridLines="None" DataKeyNames="BookingId">
                <HeaderStyle CssClass="bg-light text-secondary border-bottom py-3" />
                <Columns>
                    <asp:BoundField DataField="BookingId" HeaderText="Booking ID" ItemStyle-CssClass="fw-bold px-4" />
                    <asp:TemplateField HeaderText="Customer">
                        <ItemTemplate>
                            <div class="d-flex align-items-center">
                                <i class="fas fa-user-circle text-muted me-2"></i>
                                <span class="fw-semibold"><%# Eval("Username") %></span>
                            </div>
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="Title" HeaderText="Movie" ItemStyle-CssClass="fw-semibold" />
                    <asp:BoundField DataField="StartTime" HeaderText="Showtime" DataFormatString="{0:f}" ItemStyle-CssClass="small text-muted" />
                    <asp:BoundField DataField="TotalAmount" HeaderText="Amount" DataFormatString="${0:N2}" ItemStyle-CssClass="fw-bold text-success" />
                    <asp:TemplateField HeaderText="Status">
                        <ItemTemplate>
                            <span class='badge <%# GetStatusBadgeClass(Eval("Status")) %> px-3 rounded-pill'>
                                <%# Eval("Status") %>
                            </span>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
                <EmptyDataTemplate>
                    <div class="text-center py-5">
                        <i class="fas fa-ticket-alt fa-3x text-muted opacity-25 mb-3"></i>
                        <p class="text-muted">No bookings recorded yet.</p>
                    </div>
                </EmptyDataTemplate>
            </asp:GridView>
        </div>
    </div>

    <div class="mt-4 text-end px-4">
        <div class="d-inline-block p-3 bg-success-subtle rounded-4 border border-success border-opacity-25 shadow-sm">
            <span class="text-success small fw-bold text-uppercase d-block mb-1">Total Revenue</span>
            <asp:Label ID="lblTotalRevenue" runat="server" CssClass="h3 text-success fw-bold mb-0"></asp:Label>
        </div>
    </div>
</asp:Content>
