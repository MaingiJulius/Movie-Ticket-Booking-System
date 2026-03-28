using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MovieTicketBooking.DataAccess;

namespace MovieTicketBooking.Admin
{
    public partial class ViewBookings : Page
    {
        AdminRepository _adminRepo = new AdminRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserRole"] == null || Session["UserRole"].ToString() != "Admin")
            {
                Response.Redirect("~/Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadAllBookings();
            }
        }

        private void LoadAllBookings()
        {
            DataTable dt = _adminRepo.GetAllBookings();
            gvAllBookings.DataSource = dt;
            gvAllBookings.DataBind();

            decimal grandTotal = 0;
            if (dt != null)
            {
                foreach (DataRow row in dt.Rows)
                {
                    if (row["Status"].ToString() == "Confirmed")
                    {
                        grandTotal += Convert.ToDecimal(row["TotalAmount"]);
                    }
                }
            }
            litGrandTotal.Text = grandTotal.ToString("N2");
        }

        protected void gvAllBookings_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            int bookingId = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "CancelBooking")
            {
                if (_adminRepo.CancelBooking(bookingId))
                {
                    LoadAllBookings();
                }
            }
            else if (e.CommandName == "DeleteBooking")
            {
                if (_adminRepo.DeleteBooking(bookingId))
                {
                    LoadAllBookings();
                }
            }
        }

        public string GetStatusBadgeClass(object status)
        {
            if (status == null || status == DBNull.Value) return "bg-secondary";
            string s = status.ToString();
            switch (s)
            {
                case "Confirmed": return "bg-success-subtle text-success border border-success";
                case "Canceled": return "bg-danger-subtle text-danger border border-danger";
                case "Pending": return "bg-warning-subtle text-warning border border-warning";
                default: return "bg-secondary-subtle text-secondary";
            }
        }
    }
}
