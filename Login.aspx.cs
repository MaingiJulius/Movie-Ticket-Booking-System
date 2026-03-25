using System;
using System.Data;
using System.Web.UI;
using MovieTicketBooking.DataAccess;

namespace MovieTicketBooking
{
    public partial class Login : Page
    {
        UserRepository _userRepo = new UserRepository();

        protected void btnLogin_Click(object sender, EventArgs e)
        {
            DataTable dt = _userRepo.Login(txtUsername.Text, txtPassword.Text);
            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                Session["UserId"] = row["UserId"];
                Session["Username"] = row["Username"];
                Session["UserRole"] = row["Role"];

                if (row["Role"].ToString() == "Admin")
                {
                    Response.Redirect("~/Admin/AdminDashboard.aspx");
                }
                else
                {
                    Response.Redirect("~/Default.aspx");
                }
            }
            else
            {
                lblError.Text = "Invalid username or password.";
            }
        }
    }
}
