using System;
using System.Data;
using System.Web.UI;
using MovieTicketBooking.DataAccess;

namespace MovieTicketBooking
{
    public partial class MovieDetails : Page
    {
        MovieRepository _movieRepo = new MovieRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                if (Request.QueryString["id"] != null)
                {
                    int movieId = Convert.ToInt32(Request.QueryString["id"]);
                    LoadDetails(movieId);
                    LoadShowtimes(movieId);
                }
                else
                {
                    lblError.Visible = true;
                }
            }
        }

        private void LoadDetails(int movieId)
        {
            DataTable dt = _movieRepo.GetMovieDetails(movieId);
            if (dt.Rows.Count > 0)
            {
                DataRow row = dt.Rows[0];
                litTitle.Text = row["Title"].ToString();
                litBreadcrumb.Text = row["Title"].ToString();
                litGenre.Text = row["Genre"].ToString();
                litDuration.Text = row["Duration"].ToString();
                litRating.Text = row["Rating"].ToString();
                litDescription.Text = row["Description"].ToString();
                string posterUrl = row["PosterUrl"].ToString();
                imgPoster.ImageUrl = posterUrl.StartsWith("http") ? posterUrl : "Content/Images/" + posterUrl;

                phDetails.Visible = true;
            }
            else
            {
                lblError.Visible = true;
            }
        }

        private void LoadShowtimes(int movieId)
        {
            DataTable dt = _movieRepo.GetShowtimesByMovieId(movieId);
            if (dt.Rows.Count > 0)
            {
                rptShowtimes.DataSource = dt;
                rptShowtimes.DataBind();
                lblNoShows.Visible = false;
            }
            else
            {
                lblNoShows.Visible = true;
            }
        }
    }
}
