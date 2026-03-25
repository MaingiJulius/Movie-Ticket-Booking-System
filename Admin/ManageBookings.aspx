<%@ Page Title="Manage Bookings" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="ManageBookings.aspx.cs" Inherits="MovieTicketBooking.Admin.ManageBookings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="mb-4">
        <h2>All Bookings</h2>
        <p class="text-muted">View and manage all customer bookings.</p>
    </div>

    <asp:GridView ID="gvBookings" runat="server" AutoGenerateColumns="False"
        CssClass="table table-hover shadow-sm" DataKeyNames="BookingId">
        <Columns>
            <asp:BoundField DataField="BookingId" HeaderText="Booking ID" />
            <asp:BoundField DataField="Username" HeaderText="Customer" />
            <asp:BoundField DataField="Title" HeaderText="Movie" />
            <asp:BoundField DataField="StartTime" HeaderText="Showtime" DataFormatString="{0:f}" />
            <asp:BoundField DataField="TotalAmount" HeaderText="Amount ($)" DataFormatString="{0:N2}" />
            <asp:TemplateField HeaderText="Status">
                <ItemTemplate>
                    <span class='<%# Eval("Status").ToString() == "Confirmed" ? "badge bg-success" : "badge bg-danger" %>'>
                        <%# Eval("Status") %>
                    </span>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>

    <div class="mt-4 text-end">
        <asp:Label ID="lblTotalRevenue" runat="server" CssClass="h4 text-success fw-bold" Visible="false"></asp:Label>
    </div>

    <asp:Label ID="lblNoData" runat="server" Text="No bookings found." Visible="false" CssClass="text-muted" />
</asp:Content>
