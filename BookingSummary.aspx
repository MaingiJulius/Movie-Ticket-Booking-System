<%@ Page Title="Booking Summary" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookingSummary.aspx.cs" Inherits="MovieTicketBooking.BookingSummary" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="row justify-content-center">
        <div class="col-md-6">
            <div class="card shadow p-4">
                <h2 class="text-center mb-4">Confirm Your Booking</h2>
                <table class="table table-borderless">
                    <tr><th>Movie:</th><td><asp:Label ID="lblMovie" runat="server" /></td></tr>
                    <tr><th>Showtime:</th><td><asp:Label ID="lblTime" runat="server" /></td></tr>
                    <tr><th>Theater:</th><td><asp:Label ID="lblTheater" runat="server" /></td></tr>
                    <tr><th>Seats:</th><td><asp:Label ID="lblSeats" runat="server" /></td></tr>
                    <tr><td colspan="2"><hr /></td></tr>
                    <tr class="fs-4"><th>Total Amount:</th><td class="text-primary fw-bold">$<asp:Label ID="lblTotal" runat="server" /></td></tr>
                </table>
                <div class="d-grid gap-2 mt-4">
                    <asp:Button ID="btnConfirm" runat="server" Text="Place Booking" CssClass="btn btn-success btn-lg" OnClick="btnConfirm_Click" />
                    <a href="BookTicket.aspx" class="btn btn-outline-secondary">Go Back</a>
                </div>
                <asp:Label ID="lblError" runat="server" CssClass="text-danger mt-2 d-block"></asp:Label>
            </div>
        </div>
    </div>
</asp:Content>
