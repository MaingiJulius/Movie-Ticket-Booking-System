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
                             (SELECT COUNT(*) FROM Movies) as TotalMovies,
                             (SELECT COUNT(*) FROM Users WHERE Role = 'User') as TotalUsers,
                             (SELECT COUNT(*) FROM Bookings WHERE Status = 'Confirmed') as ActiveBookings,
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

        public DataTable GetAllShowtimes()
        {
            string query = @"SELECT S.ShowtimeId, M.Title, S.TheaterName, S.StartTime, S.Price
                             FROM Showtimes S
                             INNER JOIN Movies M ON S.MovieId = M.MovieId
                             ORDER BY S.StartTime DESC";
            return DBHelper.ExecuteQuery(query);
        }

        public bool DeleteShowtime(int showtimeId)
        {
            string query = "DELETE FROM Showtimes WHERE ShowtimeId = @id";
            SqlParameter[] paras = { new SqlParameter("@id", showtimeId) };
            return DBHelper.ExecuteNonQuery(query, paras) > 0;
        }

        public DataTable GetAllBookings()
        {
            string query = @"SELECT B.BookingId, U.Username, M.Title, S.StartTime, B.TotalAmount, B.Status
                             FROM Bookings B
                             INNER JOIN Users U ON B.UserId = U.UserId
                             INNER JOIN Showtimes S ON B.ShowtimeId = S.ShowtimeId
                             INNER JOIN Movies M ON S.MovieId = M.MovieId
                             ORDER BY B.BookingDate DESC";
            return DBHelper.ExecuteQuery(query);
        }
    }
}
