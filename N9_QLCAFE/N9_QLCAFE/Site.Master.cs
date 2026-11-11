using System;
using System.IO;
using System.Web;
using System.Web.Security;
using System.Web.UI;

namespace N9_QLCAFE
{
    public partial class SiteMaster : MasterPage
    {
        protected string AccountName { get; private set; }
        protected string AccountRole { get; private set; }
        protected string EmployeeName { get; private set; }
        internal bool CanManageBusiness => AccountRole == "Admin" || AccountRole == "QuanLy";

        protected internal static string HomeFor(string role)
        {
            return role == "Admin" || role == "QuanLy" ? "Default.aspx" : "GoiMonThanhToan.aspx";
        }

        protected bool CanAccess(string page)
        {
            switch (page.ToLowerInvariant())
            {
                case "default.aspx": return AccountRole == "Admin" || AccountRole == "QuanLy";
                case "nhanvientaikhoan.aspx":
                case "kiemthunghiemthu.aspx": return AccountRole == "Admin";
                default: return AccountRole == "Admin" || AccountRole == "QuanLy" ||
                    AccountRole == "ThuNgan" || AccountRole == "NhanVien";
            }
        }

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            AccountName = Context.User.Identity.IsAuthenticated ? Context.User.Identity.Name : null;
            var rows = AccountName == null ? null : CafeData.Query(@"SELECT t.VaiTro,t.MaNhanVien,n.HoTen
                FROM taikhoan t JOIN nhanvien n ON n.MaNhanVien=t.MaNhanVien
                WHERE t.TenDangNhap=@name AND t.TrangThaiKhoa=0 AND n.TrangThaiLamViec=N'DangLamViec'",
                CafeData.Arg("@name", AccountName));
            if (rows == null || rows.Rows.Count != 1)
            {
                SignOut(this, EventArgs.Empty);
                return;
            }

            AccountRole = (string)rows.Rows[0]["VaiTro"];
            EmployeeName = (string)rows.Rows[0]["HoTen"];
            Session["MaNhanVien"] = (string)rows.Rows[0]["MaNhanVien"];
            Page.ViewStateUserKey = AccountName + ":" + Session.SessionID;
            Response.Cache.SetCacheability(HttpCacheability.NoCache);
            Response.Cache.SetNoStore();
            if (!CanAccess(Path.GetFileName(Request.AppRelativeCurrentExecutionFilePath)))
                throw new HttpException(403, "Bạn không có quyền truy cập trang này.");
        }

        protected void SignOut(object sender, EventArgs e)
        {
            FormsAuthentication.SignOut();
            Session.Clear();
            Session.Abandon();
            Response.Redirect("Login.aspx");
        }

        protected void ChangePassword(object sender, EventArgs e)
        {
            var current = Request.Form["currentPassword"] ?? "";
            var next = Request.Form["newPassword"] ?? "";
            var confirm = Request.Form["confirmPassword"] ?? "";
            var rows = CafeData.Query("SELECT MatKhauHash FROM taikhoan WHERE TenDangNhap=@name", CafeData.Arg("@name", AccountName));
            if (next.Length < 8 || next.Length > 256 || next != confirm)
            {
                passwordMessage.Text = "Mật khẩu mới cần từ 8 đến 256 ký tự và trùng với phần xác nhận.";
            }
            else if (rows.Rows.Count != 1 || !CafeData.VerifyPassword(current, (string)rows.Rows[0][0]))
            {
                passwordMessage.Text = "Mật khẩu hiện tại không đúng.";
            }
            else
            {
                int updated = CafeData.Execute(@"UPDATE taikhoan SET MatKhauHash=@next,MatKhau=@plain
                    WHERE TenDangNhap=@name AND MatKhauHash=@previous",
                    CafeData.Arg("@next", CafeData.HashPassword(next)), CafeData.Arg("@name", AccountName),
                    CafeData.Arg("@plain", next),
                    CafeData.Arg("@previous", rows.Rows[0][0]));
                passwordMessage.Text = updated == 1 ? "Đã đổi mật khẩu." : "Mật khẩu vừa thay đổi. Vui lòng thử lại.";
            }
            passwordMessage.Visible = true;
        }
    }
}
