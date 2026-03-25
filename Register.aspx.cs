using System;
using System.Web.UI;
using MovieTicketBooking.DataAccess;

namespace MovieTicketBooking
{
    public partial class Register : Page
    {
        UserRepository _userRepo = new UserRepository();

        protected void btnRegister_Click(object sender, EventArgs e)
        {
            if (Page.IsValid)
            {
                bool success = _userRepo.RegisterUser(txtUsername.Text, txtPassword.Text, txtEmail.Text, txtFullName.Text);
                if (success)
                {
                    lblMsg.Text = "Registration successful! Loading login...";
                    lblMsg.CssClass = "text-success";
                    Response.AddHeader("REFRESH", "2;URL=Login.aspx");
                }
                else
                {
                    lblMsg.Text = "Error: Username might already exist.";
                    lblMsg.CssClass = "text-danger";
                }
            }
        }
    }
}
