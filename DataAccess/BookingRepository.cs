using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

namespace MovieTicketBooking.DataAccess
{
    public class BookingRepository
    {
        public bool IsSeatAvailable(int showtimeId, string seatNumber)
        {
            string query = @"SELECT COUNT(*) FROM BookingDetails BD
                             INNER JOIN Bookings B ON BD.BookingId = B.BookingId
                             WHERE B.ShowtimeId = @showId AND BD.SeatNumber = @seat AND B.Status = 'Confirmed'";
            SqlParameter[] paras = {
                new SqlParameter("@showId", showtimeId),
                new SqlParameter("@seat", seatNumber)
            };
            return (int)DBHelper.ExecuteScalar(query, paras) == 0;
        }

        public int CreateBooking(int userId, int showtimeId, decimal totalAmount, List<string> selectedSeats)
        {
            using (SqlConnection conn = DBHelper.GetConnection())
            {
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction();

                try
                {
                    // 1. Insert Booking Header
                    string bookQuery = "INSERT INTO Bookings (UserId, ShowtimeId, TotalAmount, Status) OUTPUT INSERTED.BookingId VALUES (@uid, @sid, @amt, 'Confirmed')";
                    SqlCommand cmd = new SqlCommand(bookQuery, conn, trans);
                    cmd.Parameters.AddWithValue("@uid", userId);
                    cmd.Parameters.AddWithValue("@sid", showtimeId);
                    cmd.Parameters.AddWithValue("@amt", totalAmount);

                    int bookingId = (int)cmd.ExecuteScalar();

                    // 2. Insert Booking Details (Seats)
                    foreach (string seat in selectedSeats)
                    {
                        string detailQuery = "INSERT INTO BookingDetails (BookingId, SeatNumber) VALUES (@bid, @seat)";
                        SqlCommand detailCmd = new SqlCommand(detailQuery, conn, trans);
                        detailCmd.Parameters.AddWithValue("@bid", bookingId);
                        detailCmd.Parameters.AddWithValue("@seat", seat);
                        detailCmd.ExecuteNonQuery();
                    }

                    trans.Commit();
                    return bookingId;
                }
                catch
                {
                    trans.Rollback();
                    return -1;
                }
            }
        }

        public DataTable GetUserBookings(int userId)
        {
            string query = @"SELECT B.BookingId, U.FullName, M.Title, S.TheaterName, S.StartTime, B.TotalAmount, B.Status, B.BookingDate,
                             (SELECT STRING_AGG(SeatNumber, ', ') FROM BookingDetails WHERE BookingId = B.BookingId) as Seats
                             FROM Bookings B
                             INNER JOIN Users U ON B.UserId = U.UserId
                             INNER JOIN Showtimes S ON B.ShowtimeId = S.ShowtimeId
                             INNER JOIN Movies M ON S.MovieId = M.MovieId
                             WHERE B.UserId = @uid
                             ORDER BY B.BookingDate DESC";
            SqlParameter[] paras = { new SqlParameter("@uid", userId) };
            return DBHelper.ExecuteQuery(query, paras);
        }

        public bool CancelBooking(int bookingId)
        {
            string query = "UPDATE Bookings SET Status = 'Cancelled' WHERE BookingId = @id";
            SqlParameter[] paras = { new SqlParameter("@id", bookingId) };
            return DBHelper.ExecuteNonQuery(query, paras) > 0;
        }

        public DataTable GetOccupiedSeats(int showtimeId)
        {
            string query = @"SELECT SeatNumber FROM BookingDetails BD
                             INNER JOIN Bookings B ON BD.BookingId = B.BookingId
                             WHERE B.ShowtimeId = @sid AND B.Status = 'Confirmed'";
            SqlParameter[] paras = { new SqlParameter("@sid", showtimeId) };
            return DBHelper.ExecuteQuery(query, paras);
        }
    }
}
