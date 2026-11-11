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
