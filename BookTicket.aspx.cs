using System;
using System.Collections.Generic;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MovieTicketBooking.DataAccess;

namespace MovieTicketBooking
{
    public partial class BookTicket : Page
    {
        MovieRepository _movieRepo = new MovieRepository();
        BookingRepository _bookRepo = new BookingRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null) Response.Redirect("Login.aspx");

            if (Request.QueryString["showId"] != null)
            {
                int showId = Convert.ToInt32(Request.QueryString["showId"]);
                if (!IsPostBack)
                {
                    LoadShowDetails(showId);
                }
                LoadSeats(showId); // Always call this to re-apply classes
            }
            else
            {
                Response.Redirect("Movies.aspx");
            }
        }

        private void LoadShowDetails(int showId)
        {
            DataTable dt = _movieRepo.GetShowtimeDetails(showId);
            if (dt.Rows.Count > 0)
            {
                DataRow r = dt.Rows[0];
                lblMovie.Text = r["Title"].ToString();
                lblTime.Text = Convert.ToDateTime(r["StartTime"]).ToString("f");
                lblTheater.Text = r["TheaterName"].ToString();
                lblPrice.Text = r["Price"].ToString();
                ViewState["Price"] = r["Price"];
                ViewState["ShowId"] = showId;
            }
        }

        private void LoadSeats(int showId)
        {
            DataTable occupied = _bookRepo.GetOccupiedSeats(showId);
            HashSet<string> occupiedList = new HashSet<string>();
            foreach (DataRow r in occupied.Rows) occupiedList.Add(r["SeatNumber"].ToString());

            if (!IsPostBack)
            {
                cblSeats.Items.Clear();
                char[] rows = { 'A', 'B', 'C', 'D' };
                for (int i = 0; i < 4; i++)
                {
                    for (int j = 1; j <= 5; j++)
                    {
                        string seat = rows[i].ToString() + j.ToString();
                        ListItem item = new ListItem(seat, seat);
                        ApplySeatClass(item, occupiedList);
                        cblSeats.Items.Add(item);
                    }
                }
            }
            else
            {
                // Re-apply classes to existing items on postback
                foreach (ListItem item in cblSeats.Items)
                {
                    ApplySeatClass(item, occupiedList);
                }
            }
        }

        private void ApplySeatClass(ListItem item, HashSet<string> occupiedList)
        {
            if (occupiedList.Contains(item.Value))
            {
                item.Enabled = false;
                item.Attributes["class"] = "occupied"; 
            }
            else if (item.Selected)
            {
                item.Attributes["class"] = "selected";
            }
            else
            {
                item.Attributes["class"] = "available";
            }
        }

        protected void btnProceed_Click(object sender, EventArgs e)
        {
            List<string> selected = new List<string>();
            foreach (ListItem item in cblSeats.Items)
            {
                if (item.Selected) selected.Add(item.Value);
            }

            if (selected.Count > 0)
            {
                Session["SelectedSeats"] = selected;
                Session["ShowId"] = ViewState["ShowId"];
                Session["MovieTitle"] = lblMovie.Text;
                Session["ShowTime"] = lblTime.Text;
                Session["Theater"] = lblTheater.Text;
                Session["Price"] = ViewState["Price"];

                Response.Redirect("BookingSummary.aspx");
            }
            else
            {
                lblError.Text = "Please select at least one seat.";
            }
        }
    }
}
