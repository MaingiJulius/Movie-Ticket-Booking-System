using System;
using System.Data;
using System.Data.SqlClient;

namespace MovieTicketBooking.DataAccess
{
    public class MovieRepository
    {
        public DataTable GetAllMovies()
        {
            string query = @"SELECT *, 
                             (SELECT TOP 1 (TheaterName + ' @ ' + FORMAT(StartTime, 'h:mm tt')) 
                              FROM Showtimes 
                              WHERE MovieId = M.MovieId AND StartTime > GETDATE() 
                              ORDER BY StartTime ASC) as NextShow
                             FROM Movies M
                             WHERE IsActive = 1 
                             ORDER BY MovieId DESC";
            return DBHelper.ExecuteQuery(query);
        }

        public DataTable SearchMovies(string title, string genre)
        {
            string query = @"SELECT *, 
                             (SELECT TOP 1 (TheaterName + ' @ ' + FORMAT(StartTime, 'h:mm tt')) 
                              FROM Showtimes 
                              WHERE MovieId = M.MovieId AND StartTime > GETDATE() 
                              ORDER BY StartTime ASC) as NextShow
                             FROM Movies M
                             WHERE IsActive = 1";
            System.Collections.Generic.List<SqlParameter> paras = new System.Collections.Generic.List<SqlParameter>();

            if (!string.IsNullOrEmpty(title))
            {
                query += " AND Title LIKE @title";
                paras.Add(new SqlParameter("@title", "%" + title + "%"));
            }

            if (!string.IsNullOrEmpty(genre))
            {
                query += " AND Genre = @genre";
                paras.Add(new SqlParameter("@genre", genre));
            }

            query += " ORDER BY MovieId DESC";
            return DBHelper.ExecuteQuery(query, paras.ToArray());
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

        public DataTable GetRatings(int movieId)
        {
            string query = @"SELECT R.*, U.Username FROM Ratings R 
                             INNER JOIN Users U ON R.UserId = U.UserId 
                             WHERE R.MovieId = @id ORDER BY R.CreatedAt DESC";
            SqlParameter[] paras = { new SqlParameter("@id", movieId) };
            return DBHelper.ExecuteQuery(query, paras);
        }

        public bool AddRating(int movieId, int userId, int score, string comment)
        {
            string query = "INSERT INTO Ratings (MovieId, UserId, Score, Comment) VALUES (@mid, @uid, @s, @c)";
            SqlParameter[] paras = {
                new SqlParameter("@mid", movieId),
                new SqlParameter("@uid", userId),
                new SqlParameter("@s", score),
                new SqlParameter("@c", comment)
            };
            return DBHelper.ExecuteNonQuery(query, paras) > 0;
        }

        public bool IsInWatchlist(int movieId, int userId)
        {
            string query = "SELECT COUNT(*) FROM Watchlist WHERE MovieId = @mid AND UserId = @uid";
            SqlParameter[] paras = {
                new SqlParameter("@mid", movieId),
                new SqlParameter("@uid", userId)
            };
            return (int)DBHelper.ExecuteScalar(query, paras) > 0;
        }

        public bool ToggleWatchlist(int movieId, int userId)
        {
            if (IsInWatchlist(movieId, userId))
            {
                string query = "DELETE FROM Watchlist WHERE MovieId = @mid AND UserId = @uid";
                SqlParameter[] paras = {
                    new SqlParameter("@mid", movieId),
                    new SqlParameter("@uid", userId)
                };
                return DBHelper.ExecuteNonQuery(query, paras) > 0;
            }
            else
            {
                string query = "INSERT INTO Watchlist (MovieId, UserId) VALUES (@mid, @uid)";
                SqlParameter[] paras = {
                    new SqlParameter("@mid", movieId),
                    new SqlParameter("@uid", userId)
                };
                return DBHelper.ExecuteNonQuery(query, paras) > 0;
            }
        }
        public DataTable GetTopRatedMovies(int count)
        {
            string query = $@"SELECT TOP {count} m.*, 
                              (SELECT ISNULL(AVG(CAST(Score as float)), 0) FROM Ratings WHERE MovieId = m.MovieId) as AvgScore
                              FROM Movies m
                              WHERE m.IsActive = 1
                              ORDER BY AvgScore DESC, m.MovieId DESC";
            return DBHelper.ExecuteQuery(query);
        }
    }
}
