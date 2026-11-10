using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Security.Cryptography;
using System.Text;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace N9_QLCAFE
{
    public partial class NhanVienTaiKhoan : Page
    {
        // Lấy chuỗi kết nối từ Web.config
        string connString = ConfigurationManager.ConnectionStrings["quanlyquancafeConnectionString"]?.ConnectionString
                            ?? "Data Source=.\\SQLEXPRESS;Initial Catalog=quanlyquancafe;Integrated Security=True";

        // Biến lưu trữ mã nhân viên đang sửa
        private string EditingMaNV
        {
            get { return ViewState["EditingMaNV"] as string; }
            set { ViewState["EditingMaNV"] = value; }
        }

        // Biến lưu trữ mã chức vụ đang sửa
        private int EditingMaCV
        {
            get { return ViewState["EditingMaCV"] != null ? (int)ViewState["EditingMaCV"] : 0; }
            set { ViewState["EditingMaCV"] = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                LoadData();
            }
        }

        private void LoadData()
        {
            LoadDanhSachNhanVien();
            LoadDanhSachTaiKhoan();
            LoadDanhSachChucVu();
            LoadDropdowns();
        }

        // ==========================================
        // 1. QUẢN LÝ NHÂN VIÊN (THÊM - SỬA - XÓA)
        // ==========================================
        private void LoadDanhSachNhanVien(string keyword = "", int maChucVu = 0)
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"SELECT nv.MaNhanVien, nv.HoTen, nv.NgaySinh, nv.GioiTinh, 
                                nv.SoDienThoai, nv.DiaChi, nv.Email, nv.NgayVaoLam, 
                                nv.TrangThaiLamViec, cv.TenChucVu, tk.TenDangNhap 
                         FROM nhanvien nv 
                         INNER JOIN chucvu cv ON nv.MaChucVu = cv.MaChucVu 
                         LEFT JOIN taikhoan tk ON nv.MaNhanVien = tk.MaNhanVien
                         WHERE (@Keyword = '' OR nv.MaNhanVien LIKE '%' + @Keyword + '%' 
                                              OR nv.HoTen LIKE N'%' + @Keyword + '%' 
                                              OR nv.SoDienThoai LIKE '%' + @Keyword + '%')
                           AND (@MaChucVu = 0 OR nv.MaChucVu = @MaChucVu)
                         ORDER BY nv.NgayVaoLam DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Keyword", keyword.Trim());
                    cmd.Parameters.AddWithValue("@MaChucVu", maChucVu);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);

                        rptNhanVien.DataSource = dt;
                        rptNhanVien.DataBind();

                        lblTongNhanSu.Text = $"Tổng: {dt.Rows.Count} nhân sự";
                    }
                }
            }
        }

        private string TaoMaNhanVienMoi()
        {
            string newMa = "NV001";
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT TOP 1 MaNhanVien FROM nhanvien WHERE MaNhanVien LIKE 'NV%' ORDER BY MaNhanVien DESC";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    conn.Open();
                    object result = cmd.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                    {
                        string maxMa = result.ToString();
                        if (int.TryParse(maxMa.Replace("NV", ""), out int num))
                        {
                            newMa = "NV" + (num + 1).ToString("D3");
                        }
                    }
                }
            }
            return newMa;
        }

        protected void btnMoModalThem_Click(object sender, EventArgs e)
        {
            EditingMaNV = null;
            txtMaNhanVien.Text = TaoMaNhanVienMoi();
            txtMaNhanVien.ReadOnly = false;
            txtHoTenNhanVien.Text = "";
            txtNgaySinh.Text = DateTime.Now.ToString("yyyy-MM-dd");
            txtSoDienThoai.Text = "";
            txtEmail.Text = "";
            txtDiaChi.Text = "";
            txtNgayVaoLam.Text = DateTime.Now.ToString("yyyy-MM-dd");

            // Kích hoạt Modal theo chuẩn Bootstrap 5 JS
            ScriptManager.RegisterStartupScript(this, GetType(), "showModalThem",
                "var myModal = new bootstrap.Modal(document.getElementById('modalThemNhanVien')); myModal.show();", true);
        }

        protected void btnEditNhanVien_Command(object sender, CommandEventArgs e)
        {
            if (e.CommandName == "EditNhanVien")
            {
                string maNV = e.CommandArgument.ToString();
                EditingMaNV = maNV;

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string query = "SELECT * FROM nhanvien WHERE MaNhanVien = @MaNhanVien";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@MaNhanVien", maNV);
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                txtMaNhanVien.Text = reader["MaNhanVien"].ToString();
                                txtMaNhanVien.ReadOnly = true;
                                txtHoTenNhanVien.Text = reader["HoTen"].ToString();
                                ddlGioiTinh.SelectedValue = reader["GioiTinh"] != DBNull.Value ? reader["GioiTinh"].ToString() : "Nam";

                                if (reader["NgaySinh"] != DBNull.Value)
                                    txtNgaySinh.Text = Convert.ToDateTime(reader["NgaySinh"]).ToString("yyyy-MM-dd");

                                txtSoDienThoai.Text = reader["SoDienThoai"].ToString();
                                txtEmail.Text = reader["Email"] != DBNull.Value ? reader["Email"].ToString() : "";
                                ddlChucVuModal.SelectedValue = reader["MaChucVu"].ToString();

                                if (reader["NgayVaoLam"] != DBNull.Value)
                                    txtNgayVaoLam.Text = Convert.ToDateTime(reader["NgayVaoLam"]).ToString("yyyy-MM-dd");

                                ddlTrangThaiLamViec.SelectedValue = reader["TrangThaiLamViec"].ToString();
                                txtDiaChi.Text = reader["DiaChi"] != DBNull.Value ? reader["DiaChi"].ToString() : "";
                            }
                        }
                    }
                }

                // Kích hoạt Modal theo chuẩn Bootstrap 5 JS
                ScriptManager.RegisterStartupScript(this, GetType(), "showModalSua",
                    "var myModal = new bootstrap.Modal(document.getElementById('modalThemNhanVien')); myModal.show();", true);
            }
        }

        protected void btnDeleteNhanVien_Command(object sender, CommandEventArgs e)
        {
            if (e.CommandName == "DeleteNhanVien")
            {
                string maNV = e.CommandArgument.ToString();

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();
                    string checkSql = @"SELECT 
                        (SELECT COUNT(*) FROM donhang WHERE MaNhanVienTao = @MaNV) +
                        (SELECT COUNT(*) FROM datban WHERE MaNhanVienTiepNhan = @MaNV) +
                        (SELECT COUNT(*) FROM hoadon WHERE MaNhanVienThuNgan = @MaNV)";

                    int transactionCount = 0;
                    using (SqlCommand checkCmd = new SqlCommand(checkSql, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@MaNV", maNV);
                        transactionCount = (int)checkCmd.ExecuteScalar();
                    }

                    if (transactionCount > 0)
                    {
                        string updateNv = "UPDATE nhanvien SET TrangThaiLamViec = N'DaNghiViec' WHERE MaNhanVien = @MaNV";
                        using (SqlCommand cmd = new SqlCommand(updateNv, conn))
                        {
                            cmd.Parameters.AddWithValue("@MaNV", maNV);
                            cmd.ExecuteNonQuery();
                        }

                        string updateTk = "UPDATE taikhoan SET TrangThaiKhoa = 1 WHERE MaNhanVien = @MaNV";
                        using (SqlCommand cmd = new SqlCommand(updateTk, conn))
                        {
                            cmd.Parameters.AddWithValue("@MaNV", maNV);
                            cmd.ExecuteNonQuery();
                        }

                        ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Nhân viên đã có lịch sử giao dịch nên hệ thống đã tự động chuyển trạng thái thành [Đã nghỉ việc] và khóa tài khoản liên kết.');", true);
                    }
                    else
                    {
                        string delTk = "DELETE FROM taikhoan WHERE MaNhanVien = @MaNV";
                        using (SqlCommand cmd = new SqlCommand(delTk, conn))
                        {
                            cmd.Parameters.AddWithValue("@MaNV", maNV);
                            cmd.ExecuteNonQuery();
                        }

                        string delNv = "DELETE FROM nhanvien WHERE MaNhanVien = @MaNV";
                        using (SqlCommand cmd = new SqlCommand(delNv, conn))
                        {
                            cmd.Parameters.AddWithValue("@MaNV", maNV);
                            cmd.ExecuteNonQuery();
                        }

                        ScriptManager.RegisterStartupScript(this, GetType(), "alert", "alert('Đã xóa vĩnh viễn hồ sơ nhân viên thành công!');", true);
                    }
                }
                LoadData();
            }
        }

        protected void btnSaveNhanVien_Click(object sender, EventArgs e)
        {
            string maNV = txtMaNhanVien.Text.Trim();
            if (string.IsNullOrEmpty(maNV))
            {
                maNV = TaoMaNhanVienMoi();
            }

            string hoTen = txtHoTenNhanVien.Text.Trim();
            string gioiTinh = ddlGioiTinh.SelectedValue;
            DateTime ngaySinh = string.IsNullOrEmpty(txtNgaySinh.Text) ? DateTime.Now : DateTime.Parse(txtNgaySinh.Text);
            string sdt = txtSoDienThoai.Text.Trim();
            string email = txtEmail.Text.Trim();
            int maChucVu = int.Parse(ddlChucVuModal.SelectedValue);
            DateTime ngayVaoLam = string.IsNullOrEmpty(txtNgayVaoLam.Text) ? DateTime.Now : DateTime.Parse(txtNgayVaoLam.Text);
            string trangThai = ddlTrangThaiLamViec.SelectedValue;
            string diaChi = txtDiaChi.Text.Trim();

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                if (string.IsNullOrEmpty(EditingMaNV))
                {
                    string query = @"INSERT INTO nhanvien (MaNhanVien, HoTen, NgaySinh, GioiTinh, SoDienThoai, DiaChi, Email, NgayVaoLam, TrangThaiLamViec, MaChucVu) 
                                     VALUES (@MaNhanVien, @HoTen, @NgaySinh, @GioiTinh, @SoDienThoai, @DiaChi, @Email, @NgayVaoLam, @TrangThaiLamViec, @MaChucVu)";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@MaNhanVien", maNV);
                        cmd.Parameters.AddWithValue("@HoTen", hoTen);
                        cmd.Parameters.AddWithValue("@NgaySinh", ngaySinh);
                        cmd.Parameters.AddWithValue("@GioiTinh", gioiTinh);
                        cmd.Parameters.AddWithValue("@SoDienThoai", sdt);
                        cmd.Parameters.AddWithValue("@DiaChi", diaChi);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@NgayVaoLam", ngayVaoLam);
                        cmd.Parameters.AddWithValue("@TrangThaiLamViec", trangThai);
                        cmd.Parameters.AddWithValue("@MaChucVu", maChucVu);
                        cmd.ExecuteNonQuery();
                    }
                }
                else
                {
                    string query = @"UPDATE nhanvien 
                                     SET HoTen = @HoTen, NgaySinh = @NgaySinh, GioiTinh = @GioiTinh, 
                                         SoDienThoai = @SoDienThoai, DiaChi = @DiaChi, Email = @Email, 
                                         NgayVaoLam = @NgayVaoLam, TrangThaiLamViec = @TrangThaiLamViec, MaChucVu = @MaChucVu 
                                     WHERE MaNhanVien = @MaNhanVien";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@MaNhanVien", EditingMaNV);
                        cmd.Parameters.AddWithValue("@HoTen", hoTen);
                        cmd.Parameters.AddWithValue("@NgaySinh", ngaySinh);
                        cmd.Parameters.AddWithValue("@GioiTinh", gioiTinh);
                        cmd.Parameters.AddWithValue("@SoDienThoai", sdt);
                        cmd.Parameters.AddWithValue("@DiaChi", diaChi);
                        cmd.Parameters.AddWithValue("@Email", email);
                        cmd.Parameters.AddWithValue("@NgayVaoLam", ngayVaoLam);
                        cmd.Parameters.AddWithValue("@TrangThaiLamViec", trangThai);
                        cmd.Parameters.AddWithValue("@MaChucVu", maChucVu);
                        cmd.ExecuteNonQuery();
                    }
                    EditingMaNV = null;
                }
            }

            txtMaNhanVien.ReadOnly = false;
            LoadData();
            // Đóng Modal an toàn bằng Bootstrap 5 JS
            ScriptManager.RegisterStartupScript(this, GetType(), "hideModal",
                "var myModalEl = document.getElementById('modalThemNhanVien'); var modal = bootstrap.Modal.getInstance(myModalEl); if (modal) modal.hide();", true);
        }

        // ==========================================
        // 2. QUẢN LÝ TÀI KHOẢN & KHÓA/MỞ KHÓA
        // ==========================================
        private void LoadDanhSachTaiKhoan()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"SELECT tk.*, nv.HoTen 
                                 FROM taikhoan tk 
                                 JOIN nhanvien nv ON tk.MaNhanVien = nv.MaNhanVien";
                using (SqlDataAdapter da = new SqlDataAdapter(query, conn))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    rptTaiKhoan.DataSource = dt;
                    rptTaiKhoan.DataBind();
                }
            }
        }

        protected void btnSaveTaiKhoan_Click(object sender, EventArgs e)
        {
            string maNV = ddlNhanVienTaiKhoan.SelectedValue;
            string username = txtTenDangNhap.Text.Trim();
            string password = txtMatKhau.Text.Trim();
            string vaiTro = ddlVaiTro.SelectedValue;
            byte trangThaiKhoa = byte.Parse(ddlTrangThaiKhoa.SelectedValue);

            string matKhauHash = HashSHA256(password);

            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = @"INSERT INTO taikhoan (TenDangNhap, MatKhauHash, VaiTro, TrangThaiKhoa, NgayTao, MaNhanVien) 
                                 VALUES (@TenDangNhap, @MatKhauHash, @VaiTro, @TrangThaiKhoa, GETDATE(), @MaNhanVien)";
                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@TenDangNhap", username);
                    cmd.Parameters.AddWithValue("@MatKhauHash", matKhauHash);
                    cmd.Parameters.AddWithValue("@VaiTro", vaiTro);
                    cmd.Parameters.AddWithValue("@TrangThaiKhoa", trangThaiKhoa);
                    cmd.Parameters.AddWithValue("@MaNhanVien", maNV);

                    conn.Open();
                    cmd.ExecuteNonQuery();
                }
            }
            LoadDanhSachTaiKhoan();
            ScriptManager.RegisterStartupScript(this, GetType(), "hideModalTK",
                "var myModalEl = document.getElementById('modalTaiKhoan'); var modal = bootstrap.Modal.getInstance(myModalEl); if (modal) modal.hide();", true);
        }

        protected void btnToggleLock_Command(object sender, CommandEventArgs e)
        {
            if (e.CommandName == "ToggleLock")
            {
                string tenDangNhap = e.CommandArgument.ToString();
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string query = "UPDATE taikhoan SET TrangThaiKhoa = CASE WHEN TrangThaiKhoa = 0 THEN 1 ELSE 0 END WHERE TenDangNhap = @TenDangNhap";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@TenDangNhap", tenDangNhap);
                        conn.Open();
                        cmd.ExecuteNonQuery();
                    }
                }
                LoadDanhSachTaiKhoan();
                ScriptManager.RegisterStartupScript(this, GetType(), "keepModalTK",
                    "var myModal = new bootstrap.Modal(document.getElementById('modalTaiKhoan')); myModal.show();", true);
            }
        }

        // ==========================================
        // 3. QUẢN LÝ CHỨC VỤ (THÊM & SỬA)
        // ==========================================
        private void LoadDanhSachChucVu()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                string query = "SELECT * FROM chucvu";
                using (SqlDataAdapter da = new SqlDataAdapter(query, conn))
                {
                    DataTable dt = new DataTable();
                    da.Fill(dt);
                    rptChucVu.DataSource = dt;
                    rptChucVu.DataBind();
                }
            }
        }

        protected void btnSaveChucVu_Click(object sender, EventArgs e)
        {
            string tenChucVu = txtTenChucVuMoi.Text.Trim();
            if (!string.IsNullOrEmpty(tenChucVu))
            {
                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();
                    if (EditingMaCV == 0)
                    {
                        string query = "INSERT INTO chucvu (TenChucVu, MoTa) VALUES (@TenChucVu, @MoTa)";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@TenChucVu", tenChucVu);
                            cmd.Parameters.AddWithValue("@MoTa", DBNull.Value);
                            cmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        string query = "UPDATE chucvu SET TenChucVu = @TenChucVu WHERE MaChucVu = @MaChucVu";
                        using (SqlCommand cmd = new SqlCommand(query, conn))
                        {
                            cmd.Parameters.AddWithValue("@TenChucVu", tenChucVu);
                            cmd.Parameters.AddWithValue("@MaChucVu", EditingMaCV);
                            cmd.ExecuteNonQuery();
                        }
                        EditingMaCV = 0;
                        btnThemChucVu.Text = "Thêm";
                    }
                }
                txtTenChucVuMoi.Text = "";
                LoadDanhSachChucVu();
                LoadDropdowns();
                ScriptManager.RegisterStartupScript(this, GetType(), "keepModalCV",
                    "var myModal = new bootstrap.Modal(document.getElementById('modalChucVu')); myModal.show();", true);
            }
        }

        protected void btnEditChucVu_Command(object sender, CommandEventArgs e)
        {
            if (e.CommandName == "EditChucVu")
            {
                int maCV = int.Parse(e.CommandArgument.ToString());
                EditingMaCV = maCV;

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string query = "SELECT TenChucVu FROM chucvu WHERE MaChucVu = @MaChucVu";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@MaChucVu", maCV);
                        conn.Open();
                        object result = cmd.ExecuteScalar();
                        if (result != null)
                        {
                            txtTenChucVuMoi.Text = result.ToString();
                            btnThemChucVu.Text = "Cập nhật";
                        }
                    }
                }
                ScriptManager.RegisterStartupScript(this, GetType(), "keepModalCV",
                    "var myModal = new bootstrap.Modal(document.getElementById('modalChucVu')); myModal.show();", true);
            }
        }

        // ==========================================
        // 4. BỔ TRỢ (DROPDOWN & HASHING)
        // ==========================================
        private void LoadDropdowns()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                using (SqlCommand cmd = new SqlCommand("SELECT MaChucVu, TenChucVu FROM chucvu", conn))
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlChucVuModal.DataSource = dt;
                    ddlChucVuModal.DataTextField = "TenChucVu";
                    ddlChucVuModal.DataValueField = "MaChucVu";
                    ddlChucVuModal.DataBind();

                    ddlBoLocChucVu.DataSource = dt;
                    ddlBoLocChucVu.DataTextField = "TenChucVu";
                    ddlBoLocChucVu.DataValueField = "MaChucVu";
                    ddlBoLocChucVu.DataBind();
                    ddlBoLocChucVu.Items.Insert(0, new ListItem("-- Tất cả chức vụ (F49) --", "0"));
                }

                using (SqlCommand cmd = new SqlCommand("SELECT MaNhanVien, HoTen FROM nhanvien", conn))
                {
                    SqlDataAdapter da = new SqlDataAdapter(cmd);
                    DataTable dt = new DataTable();
                    da.Fill(dt);

                    ddlNhanVienTaiKhoan.DataSource = dt;
                    ddlNhanVienTaiKhoan.DataTextField = "HoTen";
                    ddlNhanVienTaiKhoan.DataValueField = "MaNhanVien";
                    ddlNhanVienTaiKhoan.DataBind();
                }
            }
        }

        protected void btnTimKiem_Click(object sender, EventArgs e)
        {
            string keyword = txtTimKiem.Text.Trim();
            int maCV = int.Parse(ddlBoLocChucVu.SelectedValue);
            LoadDanhSachNhanVien(keyword, maCV);
        }

        private string HashSHA256(string rawData)
        {
            using (SHA256 sha256Hash = SHA256.Create())
            {
                byte[] bytes = sha256Hash.ComputeHash(Encoding.UTF8.GetBytes(rawData));
                StringBuilder builder = new StringBuilder();
                for (int i = 0; i < bytes.Length; i++)
                {
                    builder.Append(bytes[i].ToString("x2"));
                }
                return builder.ToString();
            }
        }
    }
}
