using System;
using System.Data;
using System.Web.UI;
using MovieTicketBooking.DataAccess;

namespace MovieTicketBooking.Admin
{
    public partial class ManageBookings : Page
    {
        AdminRepository _adminRepo = new AdminRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserRole"] == null || Session["UserRole"].ToString() != "Admin")
                Response.Redirect("~/Login.aspx");

            if (!IsPostBack)
                LoadBookings();
        }

        private void LoadBookings()
        {
            DataTable dt = _adminRepo.GetAllBookings();
            if (dt.Rows.Count > 0)
            {
                gvBookings.DataSource = dt;
                gvBookings.DataBind();
                lblNoData.Visible = false;

                decimal total = 0;
                foreach (DataRow row in dt.Rows)
                {
                    if (row["Status"].ToString() == "Confirmed")
                    {
                        total += Convert.ToDecimal(row["TotalAmount"]);
                    }
                }
                lblTotalRevenue.Text = "Total Confirmed Revenue: $" + total.ToString("N2");
                lblTotalRevenue.Visible = true;
            }
            else
            {
                gvBookings.DataSource = null;
                gvBookings.DataBind();
                lblNoData.Visible = true;
                lblTotalRevenue.Visible = false;
            }
        }
    }
}
