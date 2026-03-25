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
            DataTable dt = _movieRepo.GetAllMovies();
            if (dt.Rows.Count > 0)
            {
                rptMovies.DataSource = dt;
                rptMovies.DataBind();
                lblNoData.Visible = false;
            }
            else
            {
                lblNoData.Visible = true;
            }
        }
    }
}
