using System;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MovieTicketBooking
{
    public partial class Site : System.Web.UI.MasterPage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                ConfigureNavigation();
            }
        }

        private void ConfigureNavigation()
        {
            // Navigation visibility is now handled completely inline with <% if %> blocks in Site.Master
            // to bypass the ASP.NET WebForms HTML parser bug.
        }
    }
}
