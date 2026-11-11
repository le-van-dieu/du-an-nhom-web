using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;

namespace N9_QLCAFE
{
    internal static class CafeData
    {
        internal static SqlConnection Open()
        {
            var connection = new SqlConnection(ConfigurationManager.ConnectionStrings["quanlyquancafeConnectionString"].ConnectionString);
            connection.Open();
            return connection;
        }

        internal static SqlParameter Arg(string name, object value)
        {
            return new SqlParameter(name, value ?? DBNull.Value);
        }

        internal static DataTable Query(string sql, params SqlParameter[] parameters)
        {
            using (var connection = Open())
            using (var command = new SqlCommand(sql, connection))
            using (var adapter = new SqlDataAdapter(command))
            {
                command.Parameters.AddRange(parameters);
                var rows = new DataTable();
                adapter.Fill(rows);
                return rows;
            }
        }

        internal static int Execute(string sql, params SqlParameter[] parameters)
        {
            using (var connection = Open())
            using (var command = new SqlCommand(sql, connection))
            {
                command.Parameters.AddRange(parameters);
                return command.ExecuteNonQuery();
            }
        }

        internal static string HashPassword(string password)
        {
            using (var key = new Rfc2898DeriveBytes(password, 16, 210000, HashAlgorithmName.SHA256))
                return "pbkdf2$" + Convert.ToBase64String(key.Salt) + "$" + Convert.ToBase64String(key.GetBytes(32));
        }

        internal static string OpenTableOrder(int table, string employee)
        {
            string id = "DH" + Guid.NewGuid().ToString("N").Substring(0, 28);
            using (var connection = Open())
            using (var command = new SqlCommand(@"SET XACT_ABORT ON; BEGIN TRAN;
                DECLARE @state varchar(30),@existing varchar(30);
                SELECT @state=TrangThai FROM banan WITH (UPDLOCK,HOLDLOCK) WHERE MaBan=@table;
                IF @state IS NULL THROW 50001,N'Không tìm thấy bàn.',1;
                SELECT @existing=MaDonHang FROM donhang WITH (UPDLOCK,HOLDLOCK)
                    WHERE MaBan=@table AND TrangThaiDon='DangPhucVu';
                IF @existing IS NOT NULL BEGIN
                    COMMIT; SELECT @existing; RETURN;
                END;
                IF @state NOT IN ('Trong','DangPhucVu')
                    THROW 50001,N'Bàn đã đặt trước. Hãy nhận bàn trong Lịch đặt bàn.',1;
                IF @state='Trong' AND EXISTS (SELECT 1 FROM datban WHERE MaBan=@table AND TrangThaiDat='DaXacNhan'
                    AND NgayGioDenDuKien BETWEEN GETDATE() AND DATEADD(hour,2,GETDATE()))
                    THROW 50001,N'Bàn sắp có khách đặt. Hãy chọn bàn khác hoặc nhận bàn trong Lịch đặt bàn.',1;
                INSERT donhang (MaDonHang,ThoiGianTao,LoaiDon,TrangThaiDon,MaBan,MaNhanVienTao)
                    VALUES (@id,GETDATE(),'TaiCho','DangPhucVu',@table,@employee);
                UPDATE banan SET TrangThai='DangPhucVu' WHERE MaBan=@table;
                COMMIT; SELECT @id;", connection))
            {
                command.Parameters.AddRange(new[] { Arg("@table", table), Arg("@employee", employee), Arg("@id", id) });
                return (string)command.ExecuteScalar();
            }
        }

        internal static bool VerifyPassword(string password, string stored)
        {
            if (password.Length > 256)
                return false;

            var parts = stored.Split('$');
            if (parts.Length == 3 && parts[0] == "pbkdf2")
            {
                try
                {
                    using (var key = new Rfc2898DeriveBytes(password, Convert.FromBase64String(parts[1]), 210000, HashAlgorithmName.SHA256))
                        return Equal(key.GetBytes(32), Convert.FromBase64String(parts[2]));
                }
                catch (FormatException)
                {
                    return false;
                }
            }

            using (var sha = SHA256.Create())
            {
                var hash = BitConverter.ToString(sha.ComputeHash(Encoding.UTF8.GetBytes(password))).Replace("-", "");
                return Equal(Encoding.ASCII.GetBytes(hash), Encoding.ASCII.GetBytes(stored.ToUpperInvariant()));
            }
        }

        private static bool Equal(byte[] expected, byte[] actual)
        {
            if (expected.Length != actual.Length)
                return false;
            int difference = 0;
            for (int i = 0; i < expected.Length; i++)
                difference |= expected[i] ^ actual[i];
            return difference == 0;
        }
    }
}
