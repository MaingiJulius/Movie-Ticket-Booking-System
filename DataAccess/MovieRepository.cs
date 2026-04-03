using System;
using System.Data;
using System.Data.SqlClient;

namespace MovieTicketBooking.DataAccess
{
    public class MovieRepository
    {
        public DataTable GetAllMovies()
        {
            string query = @"SELECT M.*, 
                             (SELECT TOP 1 (TheaterName + ' @ ' + LTRIM(RIGHT(CONVERT(VARCHAR(20), StartTime, 100), 7))) 
                               FROM Showtimes S WITH (NOLOCK)
                               WHERE S.MovieId = M.MovieId AND S.StartTime > GETDATE() 
                               ORDER BY S.StartTime ASC) as NextShow
                             FROM Movies M WITH (NOLOCK)
                             WHERE M.IsActive = 1 
                             ORDER BY M.MovieId DESC";
            return DBHelper.ExecuteQuery(query);
        }

        public DataTable GetAllMoviesForAdmin()
        {
            string query = @"SELECT M.*, 
                             (SELECT TOP 1 (TheaterName + ' @ ' + LTRIM(RIGHT(CONVERT(VARCHAR(20), StartTime, 100), 7))) 
                               FROM Showtimes S WITH (NOLOCK)
                               WHERE S.MovieId = M.MovieId AND S.StartTime > GETDATE() 
                               ORDER BY S.StartTime ASC) as NextShow
                             FROM Movies M WITH (NOLOCK)
                             ORDER BY M.MovieId DESC";
            return DBHelper.ExecuteQuery(query);
        }

        public DataTable SearchMovies(string title, string genre)
        {
            string query = @"SELECT M.*, 
                             (SELECT TOP 1 (TheaterName + ' @ ' + LTRIM(RIGHT(CONVERT(VARCHAR(20), StartTime, 100), 7))) 
                               FROM Showtimes S WITH (NOLOCK)
                               WHERE S.MovieId = M.MovieId AND S.StartTime > GETDATE() 
                               ORDER BY S.StartTime ASC) as NextShow
                             FROM Movies M WITH (NOLOCK)
                             WHERE M.IsActive = 1";
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
                             WHERE S.MovieId = @id AND CAST(S.StartTime AS DATE) >= CAST(GETDATE() AS DATE)
                             ORDER BY S.StartTime ASC";
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
            string query = $@"SELECT TOP {count} m.*, ISNULL(r.AvgScore, 0) as AvgScore
                              FROM Movies m WITH (NOLOCK)
                              LEFT JOIN (
                                  SELECT MovieId, AVG(CAST(Score as float)) as AvgScore
                                  FROM Ratings WITH (NOLOCK)
                                  GROUP BY MovieId
                              ) r ON m.MovieId = r.MovieId
                              WHERE m.IsActive = 1
                              ORDER BY r.AvgScore DESC, m.MovieId DESC";
            return DBHelper.ExecuteQuery(query);
        }
    }
}
