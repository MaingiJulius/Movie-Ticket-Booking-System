using System;
using System.Data;
using System.Data.SqlClient;

namespace MovieTicketBooking.DataAccess
{
    public class MovieRepository
    {
        public DataTable GetAllMovies()
        {
            string query = "SELECT * FROM Movies WHERE IsActive = 1";
            return DBHelper.ExecuteQuery(query);
        }

        public DataTable GetMovieDetails(int movieId)
        {
            string query = "SELECT * FROM Movies WHERE MovieId = @id";
            SqlParameter[] paras = { new SqlParameter("@id", movieId) };
            return DBHelper.ExecuteQuery(query, paras);
        }

        public DataTable GetShowtimesByMovieId(int movieId)
        {
            string query = @"SELECT S.*, M.Title 
                             FROM Showtimes S 
                             INNER JOIN Movies M ON S.MovieId = M.MovieId 
                             WHERE S.MovieId = @id AND S.StartTime > GETDATE()";
            SqlParameter[] paras = { new SqlParameter("@id", movieId) };
            return DBHelper.ExecuteQuery(query, paras);
        }

        public DataTable GetShowtimeDetails(int showtimeId)
        {
            string query = @"SELECT S.*, M.Title, M.PosterUrl 
                             FROM Showtimes S 
                             INNER JOIN Movies M ON S.MovieId = M.MovieId 
                             WHERE S.ShowtimeId = @id";
            SqlParameter[] paras = { new SqlParameter("@id", showtimeId) };
            return DBHelper.ExecuteQuery(query, paras);
        }
    }
}
