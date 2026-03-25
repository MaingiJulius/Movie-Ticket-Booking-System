<%@ Page Title="Book Ticket" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookTicket.aspx.cs" Inherits="MovieTicketBooking.BookTicket" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .seat-map { display: flex; flex-wrap: wrap; max-width: 400px; margin: 20px auto; }
        .seat { width: 40px; height: 40px; margin: 5px; background: #ddd; text-align: center; border-radius: 5px; cursor: pointer; line-height: 40px; }
        .seat.occupied { background: #ff4444; color: white; cursor: not-allowed; }
        .seat.selected { background: #0d6efd; color: white; }
        .screen { border-top: 5px solid #444; text-align: center; padding: 10px; margin-bottom: 30px; font-weight: bold; }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">
    <div class="card shadow p-4">
        <h2 class="text-center">Select Your Seats</h2>
        <div class="row mt-4">
            <div class="col-md-7 border-end">
                <div class="screen">SCREEN THIS WAY</div>
                <div class="seat-map">
                    <asp:CheckBoxList ID="cblSeats" runat="server" RepeatColumns="5" RepeatDirection="Horizontal" CssClass="table table-borderless seat-list">
                    </asp:CheckBoxList>
                </div>
                <div class="d-flex justify-content-center mt-4 gap-3">
                    <span class="badge bg-secondary p-2">Available</span>
                    <span class="badge bg-primary p-2">Your Selection</span>
                    <span class="badge bg-danger p-2">Occupied</span>
                </div>
            </div>
            <div class="col-md-5 ps-4">
                <h4>Booking Info</h4>
                <div class="my-3">
                    <p><strong>Movie:</strong> <asp:Label ID="lblMovie" runat="server" /></p>
                    <p><strong>Showtime:</strong> <asp:Label ID="lblTime" runat="server" /></p>
                    <p><strong>Theater:</strong> <asp:Label ID="lblTheater" runat="server" /></p>
                    <p><strong>Price per seat:</strong> $<asp:Label ID="lblPrice" runat="server" /></p>
                    <hr />
                    <asp:Button ID="btnProceed" runat="server" Text="Review Booking" CssClass="btn btn-primary w-100" OnClick="btnProceed_Click" />
                </div>
                <asp:Label ID="lblError" runat="server" CssClass="text-danger small"></asp:Label>
            </div>
        </div>
    </div>
</asp:Content>
