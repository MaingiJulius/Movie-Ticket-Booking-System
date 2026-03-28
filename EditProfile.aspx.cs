using System;
using System.Data;
using MovieTicketBooking.DataAccess;

namespace MovieTicketBooking
{
    public partial class EditProfile : System.Web.UI.Page
    {
        UserRepository userRepo = new UserRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (Session["UserId"] == null)
            {
                Response.Redirect("~/Login.aspx");
                return;
            }

            if (!IsPostBack)
            {
                LoadUserData();
            }
        }

        private void LoadUserData()
        {
            try
            {
                int userId = Convert.ToInt32(Session["UserId"]);
                DataTable dt = userRepo.GetUserById(userId);

                if (dt != null && dt.Rows.Count > 0)
                {
                    DataRow row = dt.Rows[0];
                    txtUsername.Text = row["Username"].ToString();
                    txtFullName.Text = row["FullName"].ToString();
                    txtEmail.Text = row["Email"].ToString();
                }
                else
                {
                    ShowError("User data not found.");
                }
            }
            catch (Exception ex)
            {
                ShowError("Error loading profile: " + ex.Message);
            }
        }

        protected void btnSave_Click(object sender, EventArgs e)
        {
            lblError.Visible = false;
            lblMessage.Visible = false;

            try
            {
                int userId = Convert.ToInt32(Session["UserId"]);
                string fullName = txtFullName.Text.Trim();
                string email = txtEmail.Text.Trim();
                string newPassword = txtNewPassword.Text;
                string confirmPassword = txtConfirmPassword.Text;

                if (string.IsNullOrEmpty(fullName) || string.IsNullOrEmpty(email))
                {
                    ShowError("Full Name and Email are required.");
                    return;
                }

                if (!string.IsNullOrEmpty(newPassword))
                {
                    if (newPassword != confirmPassword)
                    {
                        ShowError("Passwords do not match.");
                        return;
                    }
                }

                bool success = userRepo.UpdateUser(userId, email, fullName, string.IsNullOrEmpty(newPassword) ? null : newPassword);

                if (success)
                {
                    ShowSuccess("Profile updated successfully!");
                    // Update session variables just in case
                    Session["Username"] = txtUsername.Text; // It didn't change, but good practice
                }
                else
                {
                    ShowError("Failed to update profile. Please try again.");
                }
            }
            catch (Exception ex)
            {
                ShowError("Error saving profile: " + ex.Message);
            }
        }

        private void ShowError(string msg)
        {
            lblError.Text = msg;
            lblError.Visible = true;
        }

        private void ShowSuccess(string msg)
        {
            lblMessage.Text = msg;
            lblMessage.Visible = true;
        }
    }
}
