using System;
using System.Web.Security;
using System.Web.UI;

namespace N9_QLCAFE
{
    public partial class Login : Page
    {
        protected void SignIn(object sender, EventArgs e)
        {
            var name = username.Text.Trim();
            var account = CafeData.Query(@"SELECT t.MatKhauHash, t.VaiTro
                FROM taikhoan t JOIN nhanvien n ON n.MaNhanVien=t.MaNhanVien
                WHERE t.TenDangNhap=@name AND t.TrangThaiKhoa=0 AND n.TrangThaiLamViec=N'DangLamViec'",
                CafeData.Arg("@name", name));
            if (account.Rows.Count != 1 || !CafeData.VerifyPassword(password.Text, (string)account.Rows[0]["MatKhauHash"]))
            {
                loginError.Text = "Tên đăng nhập hoặc mật khẩu không hợp lệ, hoặc tài khoản đã bị khóa.";
                loginError.Visible = true;
                return;
            }

            Session.Clear();
            FormsAuthentication.SetAuthCookie(name, false);
            Response.Redirect(SiteMaster.HomeFor((string)account.Rows[0]["VaiTro"]));
        }
    }
}
