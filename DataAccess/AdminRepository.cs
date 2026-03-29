using System;
using System.Data;
using System.Data.SqlClient;

namespace MovieTicketBooking.DataAccess
{
    public class AdminRepository
    {
        public DataTable GetDashboardStats()
        {
            string query = @"SELECT 
                             (SELECT COUNT(*) FROM Movies WHERE IsActive = 1) as TotalMovies,
                             (SELECT COUNT(*) FROM Users) as TotalUsers,
                             (SELECT COUNT(*) FROM Bookings) as ActiveBookings,
                             (SELECT ISNULL(SUM(TotalAmount), 0) FROM Bookings WHERE Status = 'Confirmed') as TotalRevenue";
            return DBHelper.ExecuteQuery(query);
        }

        public bool AddMovie(string title, string desc, string genre, int duration, string lang, string rating, string poster)
        {
            string query = "INSERT INTO Movies (Title, Description, Genre, Duration, Language, Rating, PosterUrl) VALUES (@t, @d, @g, @dur, @l, @r, @p)";
            SqlParameter[] paras = {
                new SqlParameter("@t", title),
                new SqlParameter("@d", desc),
                new SqlParameter("@g", genre),
                new SqlParameter("@dur", duration),
                new SqlParameter("@l", lang),
                new SqlParameter("@r", rating),
                new SqlParameter("@p", poster)
            };
            return DBHelper.ExecuteNonQuery(query, paras) > 0;
        }

        public bool UpdateMovie(int movieId, string title, string genre, string lang, string poster)
        {
            string query = "UPDATE Movies SET Title = @t, Genre = @g, Language = @l, PosterUrl = @p WHERE MovieId = @id";
            SqlParameter[] paras = {
                new SqlParameter("@id", movieId),
                new SqlParameter("@t", title),
                new SqlParameter("@g", genre),
                new SqlParameter("@l", lang),
                new SqlParameter("@p", poster)
            };
            return DBHelper.ExecuteNonQuery(query, paras) > 0;
        }

        public bool DeleteMovie(int movieId)
        {
            string query = "UPDATE Movies SET IsActive = 0 WHERE MovieId = @id";
            SqlParameter[] paras = { new SqlParameter("@id", movieId) };
            return DBHelper.ExecuteNonQuery(query, paras) > 0;
        }

        public bool CancelBooking(int bookingId)
        {
            string query = "UPDATE Bookings SET Status = 'Canceled' WHERE BookingId = @id";
            SqlParameter[] paras = { new SqlParameter("@id", bookingId) };
            return DBHelper.ExecuteNonQuery(query, paras) > 0;
        }

        public bool DeleteBooking(int bookingId)
        {
            string query = "DELETE FROM Bookings WHERE BookingId = @id";
            SqlParameter[] paras = { new SqlParameter("@id", bookingId) };
            return DBHelper.ExecuteNonQuery(query, paras) > 0;
        }

        public bool AddShowtime(int movieId, string theaterName, DateTime startTime, decimal price)
        {
            string query = "INSERT INTO Showtimes (MovieId, TheaterName, StartTime, Price) VALUES (@mid, @th, @st, @p)";
            SqlParameter[] paras = {
                new SqlParameter("@mid", movieId),
                new SqlParameter("@th", theaterName),
                new SqlParameter("@st", startTime),
                new SqlParameter("@p", price)
            };
            return DBHelper.ExecuteNonQuery(query, paras) > 0;
        }

        public bool UpdateShowtime(int showtimeId, string theaterName, DateTime startTime, decimal price)
        {
            string query = "UPDATE Showtimes SET TheaterName = @th, StartTime = @st, Price = @p WHERE ShowtimeId = @id";
            SqlParameter[] paras = {
                new SqlParameter("@id", showtimeId),
                new SqlParameter("@th", theaterName),
                new SqlParameter("@st", startTime),
                new SqlParameter("@p", price)
            };
            return DBHelper.ExecuteNonQuery(query, paras) > 0;
        }

        public bool DeleteShowtime(int showtimeId)
        {
            string query = "DELETE FROM Showtimes WHERE ShowtimeId = @id";
            SqlParameter[] paras = { new SqlParameter("@id", showtimeId) };
            return DBHelper.ExecuteNonQuery(query, paras) > 0;
        }

        public DataTable GetAllShowtimes()
        {
            string query = @"SELECT S.ShowtimeId, M.Title, S.TheaterName, S.StartTime, S.Price
                             FROM Showtimes S
                             INNER JOIN Movies M ON S.MovieId = M.MovieId
                             ORDER BY S.ShowtimeId DESC";
            return DBHelper.ExecuteQuery(query);
        }



        public DataTable GetAllBookings()
        {
            string query = @"SELECT B.BookingId, U.Username, U.FullName, M.Title, S.TheaterName, S.StartTime, B.TotalAmount, B.Status,
                             (SELECT STRING_AGG(SeatNumber, ', ') FROM BookingDetails WHERE BookingId = B.BookingId) as Seats
                             FROM Bookings B
                             INNER JOIN Users U ON B.UserId = U.UserId
                             INNER JOIN Showtimes S ON B.ShowtimeId = S.ShowtimeId
                             INNER JOIN Movies M ON S.MovieId = M.MovieId
                             ORDER BY B.BookingId DESC";
            return DBHelper.ExecuteQuery(query);
        }

        public DataTable GetFeedback()
        {
            string query = @"SELECT R.RatingId, M.Title as MovieTitle, U.Username, R.Score, R.Comment, R.CreatedAt
                             FROM Ratings R
                             INNER JOIN Movies M ON R.MovieId = M.MovieId
                             INNER JOIN Users U ON R.UserId = U.UserId
                             ORDER BY R.RatingId DESC";
            return DBHelper.ExecuteQuery(query);
        }

        public bool DeleteFeedback(int ratingId)
        {
            string query = "DELETE FROM Ratings WHERE RatingId = @id";
            SqlParameter[] paras = { new SqlParameter("@id", ratingId) };
            return DBHelper.ExecuteNonQuery(query, paras) > 0;
        }

        public void FixDatabaseIdentities()
        {
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                conn.Open();
                
                // 1. Snapshot all data
                DataTable dtUsers = DBHelper.ExecuteQuery("SELECT * FROM Users ORDER BY UserId");
                DataTable dtBookings = DBHelper.ExecuteQuery("SELECT * FROM Bookings ORDER BY BookingId");
                DataTable dtDetails = DBHelper.ExecuteQuery("SELECT * FROM BookingDetails");
                DataTable dtRatings = DBHelper.ExecuteQuery("SELECT * FROM Ratings");

                using (SqlTransaction trans = conn.BeginTransaction())
                {
                    try
                    {
                        // 2. Maps for re-indexing
                        var userMap = new System.Collections.Generic.Dictionary<int, int>();
                        var bookingMap = new System.Collections.Generic.Dictionary<int, int>();

                        // 3. Clear existing data
                        new SqlCommand("DELETE FROM Ratings", conn, trans).ExecuteNonQuery();
                        new SqlCommand("DELETE FROM BookingDetails", conn, trans).ExecuteNonQuery();
                        new SqlCommand("DELETE FROM Bookings", conn, trans).ExecuteNonQuery();
                        new SqlCommand("DELETE FROM Users", conn, trans).ExecuteNonQuery();

                        // 4. Re-insert Users
                        int nextUserId = 1;
                        new SqlCommand("SET IDENTITY_INSERT Users ON", conn, trans).ExecuteNonQuery();
                        foreach (DataRow row in dtUsers.Rows)
                        {
                            int oldId = (int)row["UserId"];
                            int newId = nextUserId++;
                            userMap[oldId] = newId;
                            
                            var cmd = new SqlCommand("INSERT INTO Users (UserId, Username, Password, Email, FullName, Role) VALUES (@id, @u, @p, @e, @f, @r)", conn, trans);
                            cmd.Parameters.AddWithValue("@id", newId);
                            cmd.Parameters.AddWithValue("@u", row["Username"]);
                            cmd.Parameters.AddWithValue("@p", row["Password"]);
                            cmd.Parameters.AddWithValue("@e", row["Email"]);
                            cmd.Parameters.AddWithValue("@f", row["FullName"]);
                            cmd.Parameters.AddWithValue("@r", row["Role"]);
                            cmd.ExecuteNonQuery();
                        }
                        new SqlCommand("SET IDENTITY_INSERT Users OFF", conn, trans).ExecuteNonQuery();

                        // 5. Re-insert Bookings
                        int nextBookingId = 1;
                        new SqlCommand("SET IDENTITY_INSERT Bookings ON", conn, trans).ExecuteNonQuery();
                        foreach (DataRow row in dtBookings.Rows)
                        {
                            int oldId = (int)row["BookingId"];
                            int newId = nextBookingId++;
                            bookingMap[oldId] = newId;

                            int oldUserId = (int)row["UserId"];
                            int newUserId = userMap.ContainsKey(oldUserId) ? userMap[oldUserId] : oldUserId;
                            
                            var cmd = new SqlCommand("INSERT INTO Bookings (BookingId, UserId, ShowtimeId, TotalAmount, Status, BookingDate) VALUES (@bid, @uid, @sid, @amt, @st, @dt)", conn, trans);
                            cmd.Parameters.AddWithValue("@bid", newId);
                            cmd.Parameters.AddWithValue("@uid", newUserId);
                            cmd.Parameters.AddWithValue("@sid", row["ShowtimeId"]);
                            cmd.Parameters.AddWithValue("@amt", row["TotalAmount"]);
                            cmd.Parameters.AddWithValue("@st", row["Status"]);
                            cmd.Parameters.AddWithValue("@dt", row["BookingDate"]);
                            cmd.ExecuteNonQuery();
                        }
                        new SqlCommand("SET IDENTITY_INSERT Bookings OFF", conn, trans).ExecuteNonQuery();

                        // 6. Re-insert Details and Ratings
                        foreach (DataRow row in dtDetails.Rows)
                        {
                            int oldId = (int)row["BookingId"];
                            int newId = bookingMap.ContainsKey(oldId) ? bookingMap[oldId] : oldId;
                            var cmd = new SqlCommand("INSERT INTO BookingDetails (BookingId, SeatNumber) VALUES (@bid, @seat)", conn, trans);
                            cmd.Parameters.AddWithValue("@bid", newId);
                            cmd.Parameters.AddWithValue("@seat", row["SeatNumber"]);
                            cmd.ExecuteNonQuery();
                        }
                        foreach (DataRow row in dtRatings.Rows)
                        {
                            int oldUserId = (int)row["UserId"];
                            int newUserId = userMap.ContainsKey(oldUserId) ? userMap[oldUserId] : oldUserId;
                            var cmd = new SqlCommand("INSERT INTO Ratings (MovieId, UserId, Score, Comment, CreatedAt) VALUES (@mid, @uid, @sc, @cm, @dt)", conn, trans);
                            cmd.Parameters.AddWithValue("@mid", row["MovieId"]);
                            cmd.Parameters.AddWithValue("@uid", newUserId);
                            cmd.Parameters.AddWithValue("@sc", row["Score"]);
                            cmd.Parameters.AddWithValue("@cm", row["Comment"]);
                            cmd.Parameters.AddWithValue("@dt", row["CreatedAt"]);
                            cmd.ExecuteNonQuery();
                        }

                        trans.Commit();
                        
                        // Reseed after commit
                        DBHelper.ExecuteNonQuery("DBCC CHECKIDENT ('Users', RESEED, " + (nextUserId - 1) + ")");
                        DBHelper.ExecuteNonQuery("DBCC CHECKIDENT ('Bookings', RESEED, " + (nextBookingId - 1) + ")");
                    }
                    catch (Exception ex)
                    {
                        trans.Rollback();
                        System.Diagnostics.Debug.WriteLine("REBASE FAILED: " + ex.Message);
                    }
                }
            }
        }
    }
}
