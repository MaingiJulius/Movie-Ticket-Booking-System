using System;
using System.Data;
using System.Data.SqlClient;

namespace MovieTicketBooking.DataAccess
{
    public class AdminRepository
    {
        public DataTable GetDashboardStats()
        {
            try { FixDatabaseIdentities(); } catch { }

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

        public bool UpdateMovie(int movieId, string title, string desc, string genre, int duration, string lang, string rating, string poster, bool isActive)
        {
            string query = "UPDATE Movies SET Title = @t, Description = @d, Genre = @g, Duration = @dur, Language = @l, Rating = @r, PosterUrl = @p, IsActive = @a WHERE MovieId = @id";
            SqlParameter[] paras = {
                new SqlParameter("@id", movieId),
                new SqlParameter("@t", title),
                new SqlParameter("@d", desc),
                new SqlParameter("@g", genre),
                new SqlParameter("@dur", duration),
                new SqlParameter("@l", lang),
                new SqlParameter("@r", rating),
                new SqlParameter("@p", poster),
                new SqlParameter("@a", isActive)
            };
            return DBHelper.ExecuteNonQuery(query, paras) > 0;
        }

        public bool DeleteMovie(int movieId)
        {
            // Cascading delete to handle foreign key constraints
            string sql = @"
                DELETE FROM Watchlist WHERE MovieId = @id;
                DELETE FROM Ratings WHERE MovieId = @id;
                DELETE FROM BookingDetails WHERE BookingId IN (SELECT BookingId FROM Bookings WHERE ShowtimeId IN (SELECT ShowtimeId FROM Showtimes WHERE MovieId = @id));
                DELETE FROM Bookings WHERE ShowtimeId IN (SELECT ShowtimeId FROM Showtimes WHERE MovieId = @id);
                DELETE FROM Showtimes WHERE MovieId = @id;
                DELETE FROM Movies WHERE MovieId = @id;
            ";
            SqlParameter[] paras = { new SqlParameter("@id", movieId) };
            return DBHelper.ExecuteNonQuery(sql, paras) > 0;
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

        public DataTable GetFeedback(string sortBy = "Newest")
        {
            string orderBy = "F.CreatedAt DESC";
            switch (sortBy)
            {
                case "Oldest": orderBy = "F.CreatedAt ASC"; break;
                case "Highest": orderBy = "F.Score DESC"; break;
                case "Lowest": orderBy = "F.Score ASC"; break;
            }

            string query = $@"SELECT F.RatingId, U.Username, M.Title as MovieTitle, F.Score, F.Comment, F.CreatedAt
                             FROM Ratings F
                             INNER JOIN Users U ON F.UserId = U.UserId
                             INNER JOIN Movies M ON F.MovieId = M.MovieId
                             ORDER BY {orderBy}";
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
            string[] tables = { "Users", "Movies", "Showtimes", "Bookings", "Ratings" };
            foreach (var table in tables)
            {
                try
                {
                    string sql = $"DECLARE @maxid INT = (SELECT ISNULL(MAX({table.TrimEnd('s')}Id), 0) FROM {table}); DBCC CHECKIDENT ('{table}', RESEED, @maxid);";
                    DBHelper.ExecuteNonQuery(sql);
                }
                catch { }
            }
        }
    }
}
