<%@ Page Title="Book Ticket" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="BookTicket.aspx.cs" Inherits="MovieTicketBooking.BookTicket" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <style>
        .seat-map { display: flex; flex-wrap: wrap; max-width: 450px; margin: 20px auto; }
        .seat-list { width: 100%; border-collapse: separate; border-spacing: 12px; }
        .seat-list td { padding: 0; }
        .seat-list td span { 
            display: flex !important; 
            align-items: center; 
            justify-content: center; 
            width: 45px; 
            height: 45px; 
            border-radius: 10px; 
            cursor: pointer; 
            font-weight: bold; 
            transition: all 0.3s; 
            position: relative;
            color: white !important;
            user-select: none;
        }
        .seat-list td span.available { background-color: #10b981; }
        .seat-list td span.occupied, 
        .seat-list td span.aspNetDisabled { 
            background-color: #ef4444 !important; 
            cursor: not-allowed !important;
            opacity: 1 !important;
        }
        .seat-list td span.selected { 
            background-color: #3b82f6 !important; 
            box-shadow: 0 0 15px rgba(59,130,246,0.6);
            transform: scale(1.05);
        }
        .seat-list td span:hover:not(.occupied):not(.aspNetDisabled) { 
            transform: scale(1.1); 
            filter: brightness(1.1);
        }
        .seat-list input { 
            position: absolute !important;
            opacity: 0 !important;
            width: 1px !important;
            height: 1px !important;
            margin: -1px !important;
            overflow: hidden !important;
            clip: rect(0, 0, 0, 0) !important;
            white-space: nowrap !important;
            border: 0 !important;
        }
        .seat-list label { 
            margin: 0; 
            cursor: pointer; 
            width: 100%; 
            height: 100%; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            user-select: none;
        }
        
        .screen { border-top: 6px solid #e2e8f0; text-align: center; padding: 15px; margin-bottom: 30px; font-weight: 800; color: #94a3b8; letter-spacing: 4px; text-transform: uppercase; font-size: 0.9rem; }
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
                <div class="d-flex justify-content-center mt-4 gap-4">
                    <div class="d-flex align-items-center gap-2"><div style="width: 20px; height: 20px; background: #10b981; border-radius: 4px;"></div> <span class="small fw-bold">Available</span></div>
                    <div class="d-flex align-items-center gap-2"><div style="width: 20px; height: 20px; background: #3b82f6; border-radius: 4px;"></div> <span class="small fw-bold">Selection</span></div>
                    <div class="d-flex align-items-center gap-2"><div style="width: 20px; height: 20px; background: #ef4444; border-radius: 4px;"></div> <span class="small fw-bold">Booked</span></div>
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

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const seatList = document.querySelector('.seat-list');
            if (!seatList) return;

            seatList.addEventListener('change', function (e) {
                if (e.target.tagName === 'INPUT' && e.target.type === 'checkbox') {
                    const span = e.target.closest('span');
                    if (span) {
                        if (e.target.checked) {
                            span.classList.add('selected');
                            span.classList.remove('available');
                        } else {
                            span.classList.remove('selected');
                            span.classList.add('available');
                        }
                    }
                }
            });
            
            // Handle clicking the span background directly
            seatList.addEventListener('click', function(e) {
                const span = e.target.closest('span');
                if (span && e.target.tagName === 'SPAN' && !span.classList.contains('aspNetDisabled') && !span.classList.contains('occupied')) {
                    const checkbox = span.querySelector('input[type="checkbox"]');
                    if (checkbox) {
                        checkbox.click(); // Trigger native click which triggers change
                    }
                }
            });
        });
    </script>
</asp:Content>
