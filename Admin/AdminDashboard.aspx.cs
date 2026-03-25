using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MovieTicketBooking.DataAccess;

namespace MovieTicketBooking.Admin
{
    public partial class AdminDashboard : Page
    {
        // Bridge to our DataAccess folder
        AdminRepository _adminRepo = new AdminRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            // Security Check: Only the Boss (Admin) can enter!
            if (Session["UserRole"] == null || Session["UserRole"].ToString() != "Admin")
            {
                Response.Redirect("~/Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadStats();
            }
        }

        private void LoadStats()
        {
            try
            {
                DataTable dt = _adminRepo.GetDashboardStats();
                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow r = dt.Rows[0];
                    litTotalMovies.Text = r["TotalMovies"].ToString();
                    litTotalUsers.Text = r["TotalUsers"].ToString();
                    litActiveBookings.Text = r["ActiveBookings"].ToString();
                    litRevenue.Text = Convert.ToDecimal(r["TotalRevenue"]).ToString("N2");
                }
            }
            catch (Exception ex)
            {
                // If there's an error, it will show up in your Output window
                System.Diagnostics.Debug.WriteLine(ex.Message);
            }
        }
    }
}
