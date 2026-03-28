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
                    
                    // Feedback permissions
                    phAddReview.Visible = Session["UserId"] != null;
                    phLoginPrompt.Visible = Session["UserId"] == null;

                    LoadDetails(movieId);
                    LoadShowtimes(movieId);
                    LoadReviews(movieId);
                    phDetails.Visible = true;
                }
                else
                {
                    phDetails.Visible = false;
                    divError.Visible = true;
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
                litLanguage.Text = row["Language"].ToString();
                
                string posterUrl = row["PosterUrl"].ToString();
                imgPoster.ImageUrl = posterUrl.StartsWith("http") ? posterUrl : "Content/Images/" + posterUrl;

                phDetails.Visible = true;
                divError.Visible = false;
            }
            else
            {
                phDetails.Visible = false;
                divError.Visible = true;
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

        private void LoadReviews(int movieId)
        {
            rptReviews.DataSource = _movieRepo.GetRatings(movieId);
            rptReviews.DataBind();
        }

        private void UpdateWatchlistButton(int movieId)
        {
            if (Session["UserId"] != null)
            {
                int userId = Convert.ToInt32(Session["UserId"]);
                if (_movieRepo.IsInWatchlist(movieId, userId))
                {
                    btnWatchlist.Text = "<i class='fas fa-bookmark me-2'></i>In Watchlist";
                    btnWatchlist.CssClass = "btn btn-primary w-100 rounded-pill py-2 shadow-sm mb-3";
                }
                else
                {
                    btnWatchlist.Text = "<i class='far fa-bookmark me-2'></i>Add to Watchlist";
                    btnWatchlist.CssClass = "btn btn-outline-primary w-100 rounded-pill py-2 shadow-sm mb-3";
                }
            }
        }

        protected void btnWatchlist_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            int movieId = Convert.ToInt32(Request.QueryString["id"]);
            int userId = Convert.ToInt32(Session["UserId"]);
            _movieRepo.ToggleWatchlist(movieId, userId);
            UpdateWatchlistButton(movieId);
        }

        protected void btnSubmitReview_Click(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (ddlUserRating.SelectedValue == "0")
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Please select a star rating.');", true);
                return;
            }

            int movieId = Convert.ToInt32(Request.QueryString["id"]);
            int userId = Convert.ToInt32(Session["UserId"]);
            int score = Convert.ToInt32(ddlUserRating.SelectedValue);
            string comment = txtComment.Text.Trim();

            if (_movieRepo.AddRating(movieId, userId, score, comment))
            {
                txtComment.Text = "";
                ddlUserRating.SelectedIndex = 0;
                LoadReviews(movieId);
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Thank you for your review!');", true);
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
