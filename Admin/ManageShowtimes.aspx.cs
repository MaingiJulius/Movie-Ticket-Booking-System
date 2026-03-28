using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MovieTicketBooking.DataAccess;

namespace MovieTicketBooking.Admin
{
    public partial class ManageShowtimes : Page
    {
        AdminRepository _adminRepo = new AdminRepository();
        MovieRepository _movieRepo = new MovieRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserRole"] == null || Session["UserRole"].ToString() != "Admin")
                Response.Redirect("~/Login.aspx");

            if (!IsPostBack)
            {
                LoadShowtimes();
                LoadMoviesDropdown();
            }
        }

        private void LoadShowtimes()
        {
            DataTable dt = _adminRepo.GetAllShowtimes();
            if (dt.Rows.Count > 0)
            {
                gvShowtimes.DataSource = dt;
                gvShowtimes.DataBind();
            }
            else
            {
                gvShowtimes.DataSource = null;
                gvShowtimes.DataBind();
            }
        }

        private void LoadMoviesDropdown()
        {
            ddlMovies.DataSource = _movieRepo.GetAllMovies();
            ddlMovies.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            int movieId = Convert.ToInt32(ddlMovies.SelectedValue);
            string theater = txtTheater.Text.Trim();
            DateTime startTime = Convert.ToDateTime(txtStartTime.Text);
            decimal price = Convert.ToDecimal(txtPrice.Text);

            if (_adminRepo.AddShowtime(movieId, theater, startTime, price))
            {
                lblMsg.Text = "Showtime added successfully!";
                lblMsg.Visible = true;
                txtTheater.Text = "";
                txtStartTime.Text = "";
                txtPrice.Text = "";
                LoadShowtimes();
            }
        }

        protected void gvShowtimes_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteShowtime")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                _adminRepo.DeleteShowtime(id);
                LoadShowtimes();
            }
        }

        protected void gvShowtimes_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvShowtimes.EditIndex = e.NewEditIndex;
            LoadShowtimes();
        }

        protected void gvShowtimes_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvShowtimes.EditIndex = -1;
            LoadShowtimes();
        }

        protected void gvShowtimes_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int showtimeId = Convert.ToInt32(gvShowtimes.DataKeys[e.RowIndex].Value);
            GridViewRow row = gvShowtimes.Rows[e.RowIndex];

            // Corrected indices based on new Columns collection:
            // 0=ID, 1=Movie, 2=Theater (Bound), 3=StartTime (Bound), 4=Price (Bound)
            string theater = (row.FindControl("txtEditTheater") as TextBox).Text;
            DateTime startTime = Convert.ToDateTime((row.FindControl("txtEditStartTime") as TextBox).Text);
            decimal price = Convert.ToDecimal((row.FindControl("txtEditPrice") as TextBox).Text);

            if (_adminRepo.UpdateShowtime(showtimeId, theater, startTime, price))
            {
                gvShowtimes.EditIndex = -1;
                LoadShowtimes();
            }
        }
    }
}
