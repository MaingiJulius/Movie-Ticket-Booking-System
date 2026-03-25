using System;
using System.Data;
using System.Data.SqlClient;

namespace MovieTicketBooking.DataAccess
{
    public class UserRepository
    {
        public bool RegisterUser(string username, string password, string email, string fullName)
        {
            string query = "INSERT INTO Users (Username, Password, Email, FullName, Role) VALUES (@user, @pass, @email, @name, 'User')";
            SqlParameter[] paras = {
                new SqlParameter("@user", username),
                new SqlParameter("@pass", password), // Should be hashed in production
                new SqlParameter("@email", email),
                new SqlParameter("@name", fullName)
            };
            return DBHelper.ExecuteNonQuery(query, paras) > 0;
        }

        public DataTable Login(string username, string password)
        {
            string query = "SELECT UserId, Username, Role FROM Users WHERE Username = @user AND Password = @pass";
            SqlParameter[] paras = {
                new SqlParameter("@user", username),
                new SqlParameter("@pass", password)
            };
            return DBHelper.ExecuteQuery(query, paras);
        }
    }
}
