using System;
using System.Data;
using System.Web.UI;
using MovieTicketBooking.DataAccess;

namespace MovieTicketBooking
{
    public partial class MoviesPage : Page
    {
        MovieRepository _movieRepo = new MovieRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadMovies();
            }
        }

        private void LoadMovies()
        {
            string title = txtSearch.Text.Trim();
            string category = ddlCategory.SelectedValue;

            DataTable dt;
            if (string.IsNullOrEmpty(title) && string.IsNullOrEmpty(category))
            {
                dt = _movieRepo.GetAllMovies();
            }
            else
            {
                dt = _movieRepo.SearchMovies(title, category);
            }

            if (dt.Rows.Count > 0)
            {
                rptMovies.DataSource = dt;
                rptMovies.DataBind();
                divNoResults.Visible = false;
                rptMovies.Visible = true;
            }
            else
            {
                rptMovies.Visible = false;
                divNoResults.Visible = true;
                // Show toast via JS
                ScriptManager.RegisterStartupScript(this, GetType(), "showToast", "const toast = new bootstrap.Toast(document.getElementById('infoToast')); toast.show();", true);
            }
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            LoadMovies();
        }

        protected void btnReset_Click(object sender, EventArgs e)
        {
            txtSearch.Text = "";
            ddlCategory.SelectedIndex = 0;
            LoadMovies();
        }

        protected string GetMoviePoster(object posterUrl)
        {
            if (posterUrl == null || posterUrl == DBNull.Value) return "https://via.placeholder.com/400x600?text=No+Poster";
            string url = posterUrl.ToString();
            if (url.StartsWith("http")) return url;
            return "Content/Images/" + url;
        }

        protected string GetRatingClass(object rating)
        {
            if (rating == null || rating == DBNull.Value) return "bg-secondary";
            string r = rating.ToString().ToUpper();
            if (r.Contains("R") || r.Contains("18")) return "bg-danger text-white";
            if (r.Contains("PG")) return "bg-warning text-dark";
            if (r.Contains("G") || r.Contains("U")) return "bg-success text-white";
            return "bg-secondary text-white";
        }
    }
}
