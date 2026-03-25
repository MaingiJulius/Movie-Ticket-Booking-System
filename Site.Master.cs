using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MovieTicketBooking
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ConfigureNavigation();
            }
        }

        private void ConfigureNavigation()
        {
            // Default visibility
            phGuest.Visible = true;
            phUser.Visible = false;
            phAdmin.Visible = false;

            if (Session["UserId"] != null)
            {
                phGuest.Visible = false;
                string role = Session["UserRole"] != null ? Session["UserRole"].ToString() : "User";
                litUsername.Text = Session["Username"] != null ? Session["Username"].ToString() : "User";

                if (role == "Admin")
                {
                    phAdmin.Visible = true;
                }
                else
                {
                    phUser.Visible = true;
                }
            }
        }
    }
}
