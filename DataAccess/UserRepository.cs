using System;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace MovieTicketBooking.DataAccess
{
    public class UserRepository
    {
        private string HashPassword(string password)
        {
            using (SHA256 sha256Hash = SHA256.Create())
            {
                byte[] bytes = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(password));
                StringBuilder builder = new StringBuilder();
                for (int i = 0; i < bytes.Length; i++)
                {
                    builder.Append(bytes[i].ToString("x2"));
                }
                return builder.ToString();
            }
        }

        public bool RegisterUser(string username, string password, string email, string fullName)
        {
            string query = "INSERT INTO Users (Username, Password, Email, FullName, Role) VALUES (@user, @pass, @email, @name, 'User')";
            SqlParameter[] paras = {
                new SqlParameter("@user", username),
                new SqlParameter("@pass", HashPassword(password)), // Secure hashing
                new SqlParameter("@email", email),
                new SqlParameter("@name", fullName)
            };
            return DBHelper.ExecuteNonQuery(query, paras) > 0;
        }

        public DataTable Login(string username, string password)
        {
            string hashedPass = HashPassword(password);
            
            // 1. Try login with hashed password (for newer/migrated users)
            string query = "SELECT UserId, Username, Role FROM Users WHERE Username = @user AND Password = @pass";
            SqlParameter[] paras = {
                new SqlParameter("@user", username),
                new SqlParameter("@pass", hashedPass)
            };
            DataTable dt = DBHelper.ExecuteQuery(query, paras);
            
            if (dt.Rows.Count > 0) return dt;

            // 2. Try login with plain-text password (for legacy users)
            SqlParameter[] legacyParas = {
                new SqlParameter("@user", username),
                new SqlParameter("@pass", password)
            };
            dt = DBHelper.ExecuteQuery(query, legacyParas);

            if (dt.Rows.Count > 0)
            {
                // 3. Automatic Migration: Update the plain-text password to a hashed one
                int userId = Convert.ToInt32(dt.Rows[0]["UserId"]);
                string updateQuery = "UPDATE Users SET Password = @newPass WHERE UserId = @id";
                SqlParameter[] updateParas = {
                    new SqlParameter("@newPass", hashedPass),
                    new SqlParameter("@id", userId)
                };
                DBHelper.ExecuteNonQuery(updateQuery, updateParas);
                
                return dt; // Return the user info
            }

            return dt; // Will be empty if both failed
        }

        public DataTable GetAllUsers()
        {
            string query = "SELECT UserId, Username, Email, FullName, Role FROM Users ORDER BY CASE WHEN Role = 'Admin' THEN 0 ELSE 1 END, UserId DESC";
            return DBHelper.ExecuteQuery(query);
        }

        public bool DeleteUser(int userId)
        {
            // First check if user has bookings, they might need to be deleted or handled
            // For now, let's just delete the user (assuming ON DELETE CASCADE or manual handling)
            string query = "DELETE FROM Users WHERE UserId = @id AND Role != 'Admin'"; // Protect admin
            SqlParameter[] paras = { new SqlParameter("@id", userId) };
            return DBHelper.ExecuteNonQuery(query, paras) > 0;
        }

        public bool ResetPassword(int userId, string username)
        {
            string newPassword = username + "123";
            string query = "UPDATE Users SET Password = @pass WHERE UserId = @id";
            SqlParameter[] paras = {
                new SqlParameter("@pass", HashPassword(newPassword)),
                new SqlParameter("@id", userId)
            };
            return DBHelper.ExecuteNonQuery(query, paras) > 0;
        }

        public bool AddUser(string username, string password, string email, string fullName, string role)
        {
            string query = "INSERT INTO Users (Username, Password, Email, FullName, Role) VALUES (@user, @pass, @email, @name, @role)";
            SqlParameter[] paras = {
                new SqlParameter("@user", username),
                new SqlParameter("@pass", HashPassword(password)),
                new SqlParameter("@email", email),
                new SqlParameter("@name", fullName),
                new SqlParameter("@role", role)
            };
            return DBHelper.ExecuteNonQuery(query, paras) > 0;
        }

        public DataTable GetUserById(int userId)
        {
            string query = "SELECT UserId, Username, Password, Email, FullName, Role FROM Users WHERE UserId = @id";
            SqlParameter[] paras = { new SqlParameter("@id", userId) };
            return DBHelper.ExecuteQuery(query, paras);
        }

        public bool UpdateUser(int userId, string email, string fullName, string password = null)
        {
            if (!string.IsNullOrEmpty(password))
            {
                string query = "UPDATE Users SET Email = @email, FullName = @name, Password = @pass WHERE UserId = @id";
                SqlParameter[] paras = {
                    new SqlParameter("@id", userId),
                    new SqlParameter("@email", email),
                    new SqlParameter("@name", fullName),
                    new SqlParameter("@pass", HashPassword(password))
                };
                return DBHelper.ExecuteNonQuery(query, paras) > 0;
            }
            else
            {
                string query = "UPDATE Users SET Email = @email, FullName = @name WHERE UserId = @id";
                SqlParameter[] paras = {
                    new SqlParameter("@id", userId),
                    new SqlParameter("@email", email),
                    new SqlParameter("@name", fullName)
                };
                return DBHelper.ExecuteNonQuery(query, paras) > 0;
            }
        }
    }
}
