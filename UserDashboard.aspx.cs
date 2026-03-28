using System;
using System.Web.UI;
using MovieTicketBooking.DataAccess;

namespace MovieTicketBooking
{
    public partial class UserDashboard : Page
    {
        MovieRepository _movieRepo = new MovieRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadUserData();
                LoadFeaturedMovies();
            }
        }

        private void LoadUserData()
        {
            string username = Session["Username"]?.ToString() ?? "User";
            litWelcomeName.Text = username;
            litInitials.Text = GetInitials(username);
        }

        private void LoadFeaturedMovies()
        {
            rptFeatured.DataSource = _movieRepo.GetTopRatedMovies(4);
            rptFeatured.DataBind();
        }

        private string GetInitials(string name)
        {
            if (string.IsNullOrEmpty(name)) return "U";
            string[] parts = name.Split(new[] { ' ' }, StringSplitOptions.RemoveEmptyEntries);
            if (parts.Length >= 2) return (parts[0][0].ToString() + parts[1][0].ToString()).ToUpper();
            return name.Substring(0, Math.Min(2, name.Length)).ToUpper();
        }

        public string GetPosterUrl(object url)
        {
            if (url == null || string.IsNullOrEmpty(url.ToString())) return "";
            string poster = url.ToString();
            if (poster.StartsWith("http")) return poster;
            return "Content/Images/" + poster;
        }
    }
}
