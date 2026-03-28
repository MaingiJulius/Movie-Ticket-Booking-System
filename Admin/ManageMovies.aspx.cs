using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using MovieTicketBooking.DataAccess;

namespace MovieTicketBooking
{
    public partial class ManageMovies : Page
    {
        MovieRepository _movieRepo = new MovieRepository();
        AdminRepository _adminRepo = new AdminRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserRole"] == null || Session["UserRole"].ToString() != "Admin")
            {
                Response.Redirect("~/Login.aspx");
            }

            if (!IsPostBack)
            {
                LoadMovies();
            }
        }

        private void LoadMovies()
        {
            gvMovies.DataSource = _movieRepo.GetAllMovies();
            gvMovies.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            string title = txtTitle.Text;
            string genre = txtGenre.Text;
            int dur = 0;
            int.TryParse(txtDuration.Text, out dur);
            string lang = txtLanguage.Text;
            string rating = txtRating.Text;
            string desc = txtDesc.Text;
            
            string poster = "default.jpg";
            if (fuPosterUrl.HasFile)
            {
                string folderPath = Server.MapPath("~/Content/Images/");
                if (!System.IO.Directory.Exists(folderPath))
                    System.IO.Directory.CreateDirectory(folderPath);

                string ext = System.IO.Path.GetExtension(fuPosterUrl.FileName);
                poster = Guid.NewGuid().ToString() + ext;
                fuPosterUrl.SaveAs(folderPath + poster);
            }

            if (_adminRepo.AddMovie(title, desc, genre, dur, lang, rating, poster))
            {
                LoadMovies();
                // Clear fields
                txtTitle.Text = "";
                txtGenre.Text = "";
                txtDuration.Text = "";
                txtLanguage.Text = "";
                txtRating.Text = "";
                txtDesc.Text = "";
            }
        }

        protected void gvMovies_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteMovie")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                if (_adminRepo.DeleteMovie(id))
                {
                    LoadMovies();
                }
            }
        }

        protected void gvMovies_RowEditing(object sender, GridViewEditEventArgs e)
        {
            gvMovies.EditIndex = e.NewEditIndex;
            LoadMovies();
        }

        protected void gvMovies_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            gvMovies.EditIndex = -1;
            LoadMovies();
        }

        protected void gvMovies_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            int movieId = Convert.ToInt32(gvMovies.DataKeys[e.RowIndex].Value);
            GridViewRow row = gvMovies.Rows[e.RowIndex];

            // Corrected indices based on new Columns collection:
            // 0=ID, 1=Title, 2=Genre, 3=Trailer (Template), 4=Poster (Template)
            string title = (row.Cells[1].Controls[0] as TextBox).Text;
            string genre = (row.Cells[2].Controls[0] as TextBox).Text;
            
            FileUpload fuEdit = (FileUpload)row.FindControl("fuEditPoster");
            HiddenField hfEdit = (HiddenField)row.FindControl("hfCurrentPoster");
            
            string poster = hfEdit.Value;
            if (fuEdit != null && fuEdit.HasFile)
            {
                string folderPath = Server.MapPath("~/Content/Images/");
                if (!System.IO.Directory.Exists(folderPath))
                    System.IO.Directory.CreateDirectory(folderPath);

                string ext = System.IO.Path.GetExtension(fuEdit.FileName);
                poster = Guid.NewGuid().ToString() + ext;
                fuEdit.SaveAs(folderPath + poster);
            }

            // We don't have Language in the edit grid as per the markupBoundFields, we can add it if needed
            // For now, let's keep it consistent with the markup
            string lang = "English"; // Default or fetch from DB if needed

            if (_adminRepo.UpdateMovie(movieId, title, genre, lang, poster))
            {
                gvMovies.EditIndex = -1;
                LoadMovies();
            }
        }

        public string GetStatusBadgeClass(object isActive)
        {
            if (isActive == null || isActive == DBNull.Value) return "bg-secondary";
            return Convert.ToBoolean(isActive) ? "bg-success-subtle text-success border border-success" : "bg-danger-subtle text-danger border border-danger";
        }

        public string GetStatusText(object isActive)
        {
            if (isActive == null || isActive == DBNull.Value) return "Unknown";
            return Convert.ToBoolean(isActive) ? "Active" : "Inactive";
        }
    }
}
