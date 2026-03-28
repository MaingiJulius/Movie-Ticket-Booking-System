using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MovieTicketBooking.DataAccess;

namespace MovieTicketBooking
{
    public partial class MyBookings : Page
    {
        BookingRepository _bookRepo = new BookingRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("Login.aspx");
            }

            if (!IsPostBack)
            {
                if (Request.QueryString["msg"] == "success")
                {
                    lblSuccess.Text = "Booking placed successfully!";
                    lblSuccess.Visible = true;
                }
                LoadBookings();
            }
        }

        private void LoadBookings()
        {
            int userId = Convert.ToInt32(Session["UserId"]);
            gvBookings.DataSource = _bookRepo.GetUserBookings(userId);
            gvBookings.DataBind();
        }

        protected void gvBookings_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "CancelBooking")
            {
                int bookingId = Convert.ToInt32(e.CommandArgument);
                if (_bookRepo.CancelBooking(bookingId))
                {
                    lblSuccess.Text = "Booking cancelled successfully.";
                    lblSuccess.Visible = true;
                    LoadBookings();
                }
            }
        }

        protected string GetStatusClass(string status)
        {
            if (status == "Confirmed") return "badge bg-success";
            if (status == "Canceled") return "badge bg-danger";
            return "badge bg-secondary";
        }

        protected void gvBookings_RowDataBound(object sender, GridViewRowEventArgs e)
        {
            // Leaving this empty for extra safety
        }
    }
}
