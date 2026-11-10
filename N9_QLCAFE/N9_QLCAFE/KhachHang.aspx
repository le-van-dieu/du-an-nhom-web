using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace N9_QLCAFE
{
    public partial class KhachHang : Page
    {
        // Chuỗi kết nối từ Web.config
        string connString = ConfigurationManager.ConnectionStrings["quanlyquancafeConnectionString"]?.ConnectionString
                            ?? "Data Source=.\\SQLEXPRESS;Initial Catalog=quanlyquancafe;Integrated Security=True";

        // Lưu giữ mã khách hàng đang chỉnh sửa
        private int EditingMaKH
        {
            get { return ViewState["EditingMaKH"] != null ? (int)ViewState["EditingMaKH"] : 0; }
            set { ViewState["EditingMaKH"] = value; }
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
            LoadDanhSachKhachHang();
            LoadThongKe();
        }

        // ==========================================
        // 1. TẢI DANH SÁCH & THỐNG KÊ KHÁCH HÀNG
        // ==========================================
        private void LoadDanhSachKhachHang(string keyword = "", string hangTV = "0")
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                // Câu lệnh truy vấn kết hợp tổng hợp số lần đến và tổng chi tiêu từ hóa đơn/đặt bàn
                string query = @"SELECT kh.MaKhachHang, kh.TenKhachHang, kh.SoDienThoai, kh.NgayTao,
                                 ISNULL(kh.HangThanhVien, 'Moi') AS HangThanhVien,
                                 COUNT(DISTINCT dh.MaDonHang) AS SoLanDen,
                                 ISNULL(SUM(hd.TienPhaiTra), 0) AS TongChiTieu
                          FROM khachhang kh
                          LEFT JOIN datban db ON kh.MaKhachHang = db.MaKhachHang
                          LEFT JOIN donhang dh ON db.MaBan = dh.MaBan
                          LEFT JOIN hoadon hd ON dh.MaDonHang = hd.MaDonHang
                          WHERE (@Keyword = '' OR kh.TenKhachHang LIKE N'%' + @Keyword + '%' 
                                              OR kh.SoDienThoai LIKE '%' + @Keyword + '%' 
                                              OR CAST(kh.MaKhachHang AS VARCHAR) LIKE '%' + @Keyword + '%')
                            AND (@HangTV = '0' OR kh.HangThanhVien = @HangTV)
                          GROUP BY kh.MaKhachHang, kh.TenKhachHang, kh.SoDienThoai, kh.NgayTao, kh.HangThanhVien
                          ORDER BY kh.NgayTao DESC";

                using (SqlCommand cmd = new SqlCommand(query, conn))
                {
                    cmd.Parameters.AddWithValue("@Keyword", keyword.Trim());
                    cmd.Parameters.AddWithValue("@HangTV", hangTV);

                    using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                    {
                        DataTable dt = new DataTable();
                        da.Fill(dt);
                        rptKhachHang.DataSource = dt;
                        rptKhachHang.DataBind();
                        lblHienThi.Text = $"Hiển thị: {dt.Rows.Count} khách hàng";
                    }
                }
            }
        }

        private void LoadThongKe()
        {
            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                // 1. Tổng khách hàng
                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM khachhang", conn))
                {
                    int total = (int)cmd.ExecuteScalar();
                    litTongKhach.Text = $"<h3 class='fw-bold my-1'>{total} khách</h3>";
                }

                // 2. Khách VIP
                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM khachhang WHERE HangThanhVien = 'VIP'", conn))
                {
                    int vip = (int)cmd.ExecuteScalar();
                    litKhachVIP.Text = $"<h3 class='fw-bold my-1 text-primary'>{vip} khách</h3>";
                }

                // 3. Đặt bàn hôm nay
                using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM datban WHERE CAST(NgayGioDat AS DATE) = CAST(GETDATE() AS DATE)", conn))
                {
                    int bookingToday = (int)cmd.ExecuteScalar();
                    litDatBanHomNay.Text = $"<h3 class='fw-bold my-1 text-dark'>{bookingToday} lượt</h3>";
                }

                // 4. Tổng chi tiêu toàn hệ thống
                using (SqlCommand cmd = new SqlCommand("SELECT ISNULL(SUM(TienPhaiTra), 0) FROM hoadon", conn))
                {
                    decimal totalRevenue = Convert.ToDecimal(cmd.ExecuteScalar());
                    litTongChiTieu.Text = $"<h3 class='fw-bold my-1 text-primary'>{totalRevenue:N0} đ</h3>";
                }
            }
        }

        // ==========================================
        // 2. THÊM & SỬA KHÁCH HÀNG
        // ==========================================
        protected void btnMoModalThem_Click(object sender, EventArgs e)
        {
            EditingMaKH = 0;
            txtMaKhachHang.Text = "Tự sinh";
            txtTenKhachHang.Text = "";
            txtSoDienThoai.Text = "";
            ddlHangThanhVien.SelectedValue = "Moi";
            txtGhiChu.Text = "";

            ScriptManager.RegisterStartupScript(this, GetType(), "showModalThem",
                "var myModal = new bootstrap.Modal(document.getElementById('modalThemKhachHang')); myModal.show();", true);
        }

        protected void btnEditKhachHang_Command(object sender, CommandEventArgs e)
        {
            if (e.CommandName == "EditKH")
            {
                int maKH = int.Parse(e.CommandArgument.ToString());
                EditingMaKH = maKH;

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    string query = "SELECT * FROM khachhang WHERE MaKhachHang = @MaKH";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@MaKH", maKH);
                        conn.Open();
                        using (SqlDataReader reader = cmd.ExecuteReader())
                        {
                            if (reader.Read())
                            {
                                txtMaKhachHang.Text = "KH" + reader["MaKhachHang"].ToString();
                                txtTenKhachHang.Text = reader["TenKhachHang"].ToString();
                                txtSoDienThoai.Text = reader["SoDienThoai"].ToString();
                                ddlHangThanhVien.SelectedValue = reader["HangThanhVien"] != DBNull.Value ? reader["HangThanhVien"].ToString() : "Moi";
                                txtGhiChu.Text = reader["GhiChu"] != DBNull.Value ? reader["GhiChu"].ToString() : "";
                            }
                        }
                    }
                }

                ScriptManager.RegisterStartupScript(this, GetType(), "showModalSua",
                    "var myModal = new bootstrap.Modal(document.getElementById('modalThemKhachHang')); myModal.show();", true);
            }
        }

        protected void btnSaveKhachHang_Click(object sender, EventArgs e)
        {
            string tenKH = txtTenKhachHang.Text.Trim();
            string sdt = txtSoDienThoai.Text.Trim();
            string hangTV = ddlHangThanhVien.SelectedValue;
            string ghiChu = txtGhiChu.Text.Trim();

            if (string.IsNullOrEmpty(tenKH) || string.IsNullOrEmpty(sdt))
            {
                ScriptManager.RegisterStartupScript(this, GetType(), "alertErr", "alert('Vui lòng nhập đầy đủ Tên khách hàng và Số điện thoại!');", true);
                return;
            }

            using (SqlConnection conn = new SqlConnection(connString))
            {
                conn.Open();
                if (EditingMaKH == 0)
                {
                    // Thêm mới (Kiểm tra cột GhiChu có tồn tại hay không, nếu bảng chưa có cột GhiChu có thể lược bỏ)
                    string query = "INSERT INTO khachhang (TenKhachHang, SoDienThoai, NgayTao, HangThanhVien) VALUES (@TenKH, @SDT, GETDATE(), @HangTV)";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@TenKH", tenKH);
                        cmd.Parameters.AddWithValue("@SDT", sdt);
                        cmd.Parameters.AddWithValue("@HangTV", hangTV);
                        cmd.ExecuteNonQuery();
                    }
                }
                else
                {
                    // Cập nhật
                    string query = "UPDATE khachhang SET TenKhachHang = @TenKH, SoDienThoai = @SDT, HangThanhVien = @HangTV WHERE MaKhachHang = @MaKH";
                    using (SqlCommand cmd = new SqlCommand(query, conn))
                    {
                        cmd.Parameters.AddWithValue("@TenKH", tenKH);
                        cmd.Parameters.AddWithValue("@SDT", sdt);
                        cmd.Parameters.AddWithValue("@HangTV", hangTV);
                        cmd.Parameters.AddWithValue("@MaKH", EditingMaKH);
                        cmd.ExecuteNonQuery();
                    }
                    EditingMaKH = 0;
                }
            }

            LoadData();
            ScriptManager.RegisterStartupScript(this, GetType(), "hideModal",
                "var myModalEl = document.getElementById('modalThemKhachHang'); var modal = bootstrap.Modal.getInstance(myModalEl); if (modal) modal.hide();", true);
        }

        // ==========================================
        // 3. XÓA KHÁCH HÀNG
        // ==========================================
        protected void btnDeleteKhachHang_Command(object sender, CommandEventArgs e)
        {
            if (e.CommandName == "DeleteKH")
            {
                int maKH = int.Parse(e.CommandArgument.ToString());

                using (SqlConnection conn = new SqlConnection(connString))
                {
                    conn.Open();
                    // Kiểm tra xem khách hàng có lịch sử đặt bàn không
                    string checkQuery = "SELECT COUNT(*) FROM datban WHERE MaKhachHang = @MaKH";
                    int bookingCount = 0;
                    using (SqlCommand checkCmd = new SqlCommand(checkQuery, conn))
                    {
                        checkCmd.Parameters.AddWithValue("@MaKH", maKH);
                        bookingCount = (int)checkCmd.ExecuteScalar();
                    }

                    if (bookingCount > 0)
                    {
                        ScriptManager.RegisterStartupScript(this, GetType(), "alertDelErr", "alert('Không thể xóa khách hàng này vì đã có lịch sử đặt bàn liên kết trong hệ thống!');", true);
                    }
                    else
                    {
                        string delQuery = "DELETE FROM khachhang WHERE MaKhachHang = @MaKH";
                        using (SqlCommand cmd = new SqlCommand(delQuery, conn))
                        {
                            cmd.Parameters.AddWithValue("@MaKH", maKH);
                            cmd.ExecuteNonQuery();
                        }
                        ScriptManager.RegisterStartupScript(this, GetType(), "alertDelOk", "alert('Xóa khách hàng thành công!');", true);
                    }
                }
                LoadData();
            }
        }

        // ==========================================
        // 4. TÌM KIẾM & LỌC
        // ==========================================
        protected void btnTimKiem_Click(object sender, EventArgs e)
        {
            string keyword = txtTimKiem.Text.Trim();
            string hangTV = ddlLocHang.SelectedValue;
            LoadDanhSachKhachHang(keyword, hangTV);
        }
    }
}
