<%@ Page Title="My Bookings" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="MyBookings.aspx.cs" Inherits="MovieTicketBooking.MyBookings" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>My Booking History</h2>
        <asp:Label ID="lblSuccess" runat="server" CssClass="alert alert-success py-2 px-3 m-0" Visible="false"></asp:Label>
    </div>

    <asp:GridView ID="gvBookings" runat="server" AutoGenerateColumns="False" CssClass="table table-hover shadow-sm border-0" 
        OnRowCommand="gvBookings_RowCommand" OnRowDataBound="gvBookings_RowDataBound">
        <Columns>
            <asp:TemplateField HeaderText="Booking #">
                <ItemTemplate>
                    <%# (int)Eval("BookingId") > 1000 ? (int)Eval("BookingId") - 1000 : Eval("BookingId") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="Title" HeaderText="Movie" />
            <asp:TemplateField HeaderText="Date & Time">
                <ItemTemplate>
                    <%# Eval("StartTime", "{0:f}") %>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="TheaterName" HeaderText="Theater" />
            <asp:BoundField DataField="Seats" HeaderText="Seats" />
            <asp:TemplateField HeaderText="Status">
                <ItemTemplate>
                    <span class='<%# GetStatusClass(Eval("Status").ToString()) %>'>
                        <%# Eval("Status") %>
                    </span>
                </ItemTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="TotalAmount" HeaderText="Amount" DataFormatString="${0:N2}" />
            <asp:TemplateField HeaderText="Actions">
                <ItemTemplate>
                    <asp:LinkButton ID="btnCancel" runat="server" CommandName="CancelBooking" 
                        CommandArgument='<%# Eval("BookingId") %>' CssClass="btn btn-sm btn-outline-danger me-1" 
                        OnClientClick="return confirm('Are you sure you want to cancel this booking?');"
                        Visible='<%# Eval("Status").ToString() == "Confirmed" %>'>
                        <i class="fas fa-times me-1"></i>Cancel
                    </asp:LinkButton>
                    <button type="button" class="btn btn-sm btn-primary btn-print-ticket" 
                        data-bookingid='<%# (int)Eval("BookingId") > 1000 ? (int)Eval("BookingId") - 1000 : Eval("BookingId") %>'
                        data-fullname='<%# Eval("FullName") %>'
                        data-movie='<%# Eval("Title") %>'
                        data-date='<%# Eval("StartTime", "{0:f}") %>'
                        data-theater='<%# Eval("TheaterName") %>'
                        data-seats='<%# Eval("Seats") %>'
                        data-amount='<%# Eval("TotalAmount", "${0:N2}") %>'>
                        <i class="fas fa-print me-1"></i>Print
                    </button>
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
        <EmptyDataTemplate>
            <div class="text-center p-5">
                <p class="text-muted fs-5">You haven't made any bookings yet.</p>
                <a href="Movies.aspx" class="btn btn-primary">Book Now</a>
            </div>
        </EmptyDataTemplate>
    </asp:GridView>
</asp:Content>
