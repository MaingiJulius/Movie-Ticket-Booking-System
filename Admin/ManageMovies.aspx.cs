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
            int dur = Convert.ToInt32(txtDuration.Text);
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
                txtTitle.Text = "";
                txtGenre.Text = "";
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

            // Cells are: 0=Edit, 1=ID, 2=Title, 3=Genre, 4=Language, 5=PosterImage (TemplateField)
            string title = (row.Cells[2].Controls[0] as TextBox).Text;
            string genre = (row.Cells[3].Controls[0] as TextBox).Text;
            string lang = (row.Cells[4].Controls[0] as TextBox).Text;
            
            FileUpload fuEdit = (FileUpload)row.Cells[5].FindControl("fuEditPoster");
            HiddenField hfEdit = (HiddenField)row.Cells[5].FindControl("hfCurrentPoster");
            
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

            if (_adminRepo.UpdateMovie(movieId, title, genre, lang, poster))
            {
                gvMovies.EditIndex = -1;
                LoadMovies();
            }
        }    
    }
}
