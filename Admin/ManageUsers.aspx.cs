using System;
using System.Data;
using System.Web.UI;
using System.Web.UI.WebControls;
using MovieTicketBooking.DataAccess;

namespace MovieTicketBooking.Admin
{
    public partial class ManageUsers : Page
    {
        UserRepository _userRepo = new UserRepository();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Check if user is admin (security)
                if (Session["UserRole"] == null || Session["UserRole"].ToString() != "Admin")
                {
                    Response.Redirect("~/Login.aspx");
                    return;
                }
                LoadUsers();
            }
        }

        private void LoadUsers()
        {
            gvUsers.DataSource = _userRepo.GetAllUsers();
            gvUsers.DataBind();
        }

        protected void gvUsers_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName == "DeleteUser")
            {
                int userId = Convert.ToInt32(e.CommandArgument);
                if (_userRepo.DeleteUser(userId))
                {
                    ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('User deleted successfully!');", true);
                    LoadUsers();
                }
            }
            else if (e.CommandName == "ResetPassword")
            {
                string[] args = e.CommandArgument.ToString().Split('|');
                if (args.Length == 2)
                {
                    int userId = Convert.ToInt32(args[0]);
                    string username = args[1];
                    
                    if (_userRepo.ResetPassword(userId, username))
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "alert", $"alert('Password for {username} has been reset to {username}123');", true);
                    }
                }
            }
        }

        protected void btnSaveUser_Click(object sender, EventArgs e)
        {
            string username = txtUsername.Text.Trim();
            string password = txtPassword.Text.Trim();
            string email = txtEmail.Text.Trim();
            string name = txtFullName.Text.Trim();
            string role = ddlRole.SelectedValue;

            if (_userRepo.AddUser(username, password, email, name, role))
            {
                // Clear fields
                txtUsername.Text = "";
                txtPassword.Text = "";
                txtEmail.Text = "";
                txtFullName.Text = "";
                
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('User added successfully!');", true);
                LoadUsers();
            }
            else
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Error adding user. Username might exist.');", true);
            }
        }

        public string GetInitials(object username)
        {
            if (username == null || username == DBNull.Value || string.IsNullOrEmpty(username.ToString())) return "?";
            return username.ToString().Substring(0, 1).ToUpper();
        }
    }
}
