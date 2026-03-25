using System;
using System.Collections.Generic;
using System.Web.UI;
using MovieTicketBooking.DataAccess;

namespace MovieTicketBooking
{
    public partial class BookingSummary : Page
    {
        BookingRepository _bookRepo = new BookingRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null || Session["SelectedSeats"] == null)
            {
                Response.Redirect("Default.aspx");
            }

            if (!IsPostBack)
            {
                LoadSummary();
            }
        }

        private void LoadSummary()
        {
            lblMovie.Text = Session["MovieTitle"].ToString();
            lblTime.Text = Session["ShowTime"].ToString();
            lblTheater.Text = Session["Theater"].ToString();

            List<string> seats = (List<string>)Session["SelectedSeats"];
            lblSeats.Text = string.Join(", ", seats);

            decimal price = Convert.ToDecimal(Session["Price"]);
            decimal total = seats.Count * price;
            lblTotal.Text = total.ToString("N2");
            ViewState["Total"] = total;
        }

        protected void btnConfirm_Click(object sender, EventArgs e)
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            int showId = Convert.ToInt32(Session["ShowId"]);
            decimal total = (decimal)ViewState["Total"];
            List<string> seats = (List<string>)Session["SelectedSeats"];

            int bookingId = _bookRepo.CreateBooking(userId, showId, total, seats);
            if (bookingId > 0)
            {
                // Clear booking sessions
                Session.Remove("SelectedSeats");
                Session.Remove("ShowId");

                // Redirect to history with success message
                Response.Redirect("MyBookings.aspx?msg=success");
            }
            else
            {
                lblError.Text = "Sorry, an error occurred or seats were just taken. Please try again.";
            }
        }
    }
}
