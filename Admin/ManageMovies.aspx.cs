using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using MovieTicketBooking.DataAccess;
using System.Data;

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
            gvMovies.DataSource = _movieRepo.GetAllMoviesForAdmin();
            gvMovies.DataBind();
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            try
            {
                string title = txtTitle.Text;
                string genre = txtGenre.Text;
                int dur = 0;
                int.TryParse(txtDuration.Text, out dur);
                string lang = txtLanguage.Text;
                string rating = ddlRating.SelectedValue;
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
                    txtDesc.Text = "";
                    ScriptManager.RegisterStartupScript(this, GetType(), "success", "alert('Movie added successfully!');", true);
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "error", "alert('Error adding movie: " + ex.Message.Replace("'", "\\'") + "');", true);
            }
        }

        protected void gvMovies_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteMovie")
            {
                try
                {
                    int id = Convert.ToInt32(e.CommandArgument);
                    if (_adminRepo.DeleteMovie(id))
                    {
                        LoadMovies();
                        ScriptManager.RegisterStartupScript(this, GetType(), "success", "alert('Movie and all related data deleted permanently.');", true);
                    }
                }
                catch (Exception ex)
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "error", "alert('Error deleting movie: " + ex.Message.Replace("'", "\\'") + "');", true);
                }
            }
            else if (e.CommandName == "ModifyMovie")
            {
                int id = Convert.ToInt32(e.CommandArgument);
                LoadMovieForEdit(id);
            }
        }

        private void LoadMovieForEdit(int movieId)
        {
            try
            {
                DataTable dt = _movieRepo.GetMovieDetails(movieId);
                if (dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    hfEditMovieId.Value = movieId.ToString();
                    txtEditTitle.Text = row["Title"].ToString();
                    txtEditGenre.Text = row["Genre"].ToString();
                    txtEditDuration.Text = row["Duration"].ToString();
                    txtEditLanguage.Text = row["Language"].ToString();
                    txtEditDesc.Text = row["Description"].ToString();
                    
                    string rating = row["Rating"].ToString();
                    if (ddlEditRating.Items.FindByValue(rating) != null)
                    {
                        ddlEditRating.SelectedValue = rating;
                    }
                    
                    ddlEditStatus.SelectedValue = row["IsActive"].ToString().ToLower();
                    
                    string posterUrl = row["PosterUrl"].ToString();
                    hfCurrentEditPoster.Value = posterUrl;
                    lblCurrentPosterName.Text = posterUrl;
                    imgEditPosterCurrent.ImageUrl = posterUrl.StartsWith("http") ? posterUrl : "~/Content/Images/" + posterUrl;

                    // Trigger JS to show modal
                    hfShowEditModal.Value = "true";
                    
                    // Also trigger JS to update rating icon
                    ScriptManager.RegisterStartupScript(this, GetType(), "UpdateRatingIcon", 
                        "updateRatingSign(document.getElementById('" + ddlEditRating.ClientID + "'), 'editRatingPreview');", true);
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "error", "alert('Error loading movie for edit: " + ex.Message.Replace("'", "\\'") + "');", true);
            }
        }

        protected void btnUpdateMovie_Click(object sender, EventArgs e)
        {
            try
            {
                int movieId = int.Parse(hfEditMovieId.Value);
                string title = txtEditTitle.Text;
                string genre = txtEditGenre.Text;
                int dur = 0;
                int.TryParse(txtEditDuration.Text, out dur);
                string lang = txtEditLanguage.Text;
                string rating = ddlEditRating.SelectedValue;
                string desc = txtEditDesc.Text;
                bool isActive = bool.Parse(ddlEditStatus.SelectedValue);
                
                string poster = hfCurrentEditPoster.Value;

                if (chkRemovePoster.Checked)
                {
                    poster = "default.jpg";
                }
                else if (!string.IsNullOrEmpty(hfEditPosterBase64.Value))
                {
                    string base64Data = hfEditPosterBase64.Value;
                    int dataIndex = base64Data.IndexOf("base64,") + 7;
                    if (dataIndex >= 7)
                    {
                        string base64String = base64Data.Substring(dataIndex);
                        byte[] imageBytes = Convert.FromBase64String(base64String);

                        string folderPath = Server.MapPath("~/Content/Images/");
                        if (!System.IO.Directory.Exists(folderPath))
                            System.IO.Directory.CreateDirectory(folderPath);

                        poster = Guid.NewGuid().ToString() + ".jpg";
                        System.IO.File.WriteAllBytes(folderPath + poster, imageBytes);
                    }
                }

                if (_adminRepo.UpdateMovie(movieId, title, desc, genre, dur, lang, rating, poster, isActive))
                {
                    LoadMovies();
                    hfShowEditModal.Value = "false";
                    ScriptManager.RegisterStartupScript(this, GetType(), "success", "alert('Movie updated successfully!');", true);
                }
                else
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "error", "alert('Error: Could not update movie in database.');", true);
                }
            }
            catch (Exception ex)
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "error", "alert('System Error: " + ex.Message.Replace("'", "\\'") + "');", true);
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
