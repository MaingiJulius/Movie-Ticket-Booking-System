using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MovieTicketBooking.DataAccess;

namespace MovieTicketBooking.Admin
{
    public partial class ManageFeedback : Page
    {
        AdminRepository _adminRepo = new AdminRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserRole"] == null || Session["UserRole"].ToString() != "Admin")
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadFeedback();
            }
        }

        private void LoadFeedback()
        {
            gvFeedback.DataSource = _adminRepo.GetFeedback();
            gvFeedback.DataBind();
        }

        protected void gvFeedback_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteFeedback")
            {
                int ratingId = Convert.ToInt32(e.CommandArgument);
                if (_adminRepo.DeleteFeedback(ratingId))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Feedback deleted successfully!');", true);
                    LoadFeedback();
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Error deleting feedback.');", true);
                }
            }
        }

        public string GetStarRating(object score)
        {
            if (score == null || score == DBNull.Value) return "";
            int s = Convert.ToInt32(score);
            return new string('★', s) + new string('☆', 5 - s);
        }

        public string GetInitials(object username)
        {
            if (username == null || username == DBNull.Value || string.IsNullOrEmpty(username.ToString())) return "?";
            return username.ToString().Substring(0, 1).ToUpper();
        }
    }
}
