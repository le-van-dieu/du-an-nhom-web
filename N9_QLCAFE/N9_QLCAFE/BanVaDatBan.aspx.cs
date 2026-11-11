using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace N9_QLCAFE
{
    public partial class BanVaDatBan : Page
    {
        // 1. Lấy trực tiếp chuỗi kết nối từ Web.config không qua lớp trung gian
        private string strConn = ConfigurationManager.ConnectionStrings["quanlyquancafeConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtNgayXemLich.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtNgayDenDat.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtGioDenDat.Text = DateTime.Now.AddHours(1).ToString("HH:mm");

                NapDuLieuLocVaDropdown();
                TaiDuLieuTrang();
            }
        }

        private void TaiDuLieuTrang()
        {
            CapNhatThongKeKPI();
            TaiDanhSachKhuVucVaBan();
            TaiDanhSachLichDatBan();
            NapDropdownModal();
        }

        // 2. THỐNG KÊ KPI TRỰC TIẾP TỪ SQL SERVER
        private void CapNhatThongKeKPI()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    conn.Open();

                    // Tổng số bàn
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM banan", conn))
                    {
                        object objTongBan = cmd.ExecuteScalar();
                        litTongBan.Text = (objTongBan != null) ? objTongBan.ToString() : "0";
                    }

                    // Tổng số khu vực
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM khuvuc", conn))
                    {
                        object objTongKV = cmd.ExecuteScalar();
                        litTongKhuVuc.Text = (objTongKV != null) ? objTongKV.ToString() : "0";
                    }

                    // Bàn trống
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM banan WHERE TrangThai = 'Trong'", conn))
                    {
                        object objBanTrong = cmd.ExecuteScalar();
                        litBanTrong.Text = (objBanTrong != null) ? objBanTrong.ToString() : "0";
                    }

                    // Bàn đang phục vụ
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM banan WHERE TrangThai = 'DangPhucVu'", conn))
                    {
                        object objBanDung = cmd.ExecuteScalar();
                        litBanDangDung.Text = (objBanDung != null) ? objBanDung.ToString() : "0";
                    }

                    // Lịch đặt trước trong ngày
                    string sqlDat = "SELECT COUNT(*) FROM datban WHERE CONVERT(date, NgayGioDenDuKien) = CONVERT(date, GETDATE()) AND TrangThaiDat = 'DaXacNhan'";
                    using (SqlCommand cmd = new SqlCommand(sqlDat, conn))
                    {
                        object objLichDat = cmd.ExecuteScalar();
                        litLichDatHomNay.Text = (objLichDat != null) ? objLichDat.ToString() : "0";
                    }
                }
            }
            catch (Exception ex)
            {
                HienThongBao("Lỗi thống kê KPI: " + ex.Message, false);
            }
        }

        // 3. TẢI SƠ ĐỒ 2 CẤP: KHU VỰC VÀ BÀN TRỰC THUỘC
        private void TaiDanhSachKhuVucVaBan()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    string sqlKV = "SELECT MaKhuVuc, TenKhuVuc, ISNULL(GhiChu, N'Khu vực phục vụ') AS GhiChu FROM khuvuc";

                    if (!string.IsNullOrEmpty(ddlLocKhuVuc.SelectedValue))
                    {
                        sqlKV = string.Format("SELECT MaKhuVuc, TenKhuVuc, ISNULL(GhiChu, N'Khu vực phục vụ') AS GhiChu FROM khuvuc WHERE MaKhuVuc = {0}", ddlLocKhuVuc.SelectedValue);
                    }

                    using (SqlDataAdapter da = new SqlDataAdapter(sqlKV, conn))
                    {
                        DataTable dtKV = new DataTable();
                        da.Fill(dtKV);
                        rptKhuVuc.DataSource = dtKV;
                        rptKhuVuc.DataBind();
                    }
                }
            }
            catch (Exception ex)
            {
                HienThongBao("Lỗi tải khu vực: " + ex.Message, false);
            }
        }

        // Nạp bàn tương ứng vào từng khu vực (Cấp 2)
        protected void rptKhuVuc_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                HiddenField hfMaKV = (HiddenField)e.Item.FindControl("hfMaKhuVuc");
                Repeater rptBanAn = (Repeater)e.Item.FindControl("rptBanAn");

                if (hfMaKV != null && rptBanAn != null)
                {
                    string maKV = hfMaKV.Value;
                    string sqlBan = "SELECT MaBan, TenBan, SoGhe, TrangThai FROM banan WHERE MaKhuVuc = @MaKhuVuc";

                    if (!string.IsNullOrEmpty(ddlLocTrangThai.SelectedValue))
                    {
                        sqlBan = sqlBan + " AND TrangThai = '" + ddlLocTrangThai.SelectedValue + "'";
                    }

                    if (!string.IsNullOrEmpty(txtTimKiem.Text.Trim()))
                    {
                        sqlBan = sqlBan + " AND TenBan LIKE N'%" + txtTimKiem.Text.Trim() + "%'";
                    }

                    using (SqlConnection conn = new SqlConnection(strConn))
                    {
                        using (SqlCommand cmd = new SqlCommand(sqlBan, conn))
                        {
                            cmd.Parameters.AddWithValue("@MaKhuVuc", maKV);
                            using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                            {
                                DataTable dtBan = new DataTable();
                                da.Fill(dtBan);
                                rptBanAn.DataSource = dtBan;
                                rptBanAn.DataBind();
                            }
                        }
                    }
                }
            }
        }

        // 4. DANH SÁCH LỊCH ĐẶT BÀN (TAB 2)
        private void TaiDanhSachLichDatBan()
        {
            try
            {
                string sql = "SELECT d.MaDatBan, k.TenKhachHang, k.SoDienThoai, d.NgayGioDenDuKien, d.SoLuongKhach, " +
                             "b.TenBan, ISNULL(d.GhiChu, N'Không') AS GhiChu, d.TrangThaiDat " +
                             "FROM datban d " +
                             "INNER JOIN khachhang k ON d.MaKhachHang = k.MaKhachHang " +
                             "INNER JOIN banan b ON d.MaBan = b.MaBan " +
                             "WHERE CONVERT(date, d.NgayGioDenDuKien) = @Ngay " +
                             "ORDER BY d.NgayGioDenDuKien ASC";

                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Ngay", txtNgayXemLich.Text);
                        using (SqlDataAdapter da = new SqlDataAdapter(cmd))
                        {
                            DataTable dt = new DataTable();
                            da.Fill(dt);
                            gvLichDatBan.DataSource = dt;
                            gvLichDatBan.DataBind();
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                HienThongBao("Lỗi tải lịch đặt bàn: " + ex.Message, false);
            }
        }

        // 5. NẠP DỮ LIỆU BỘ LỌC VÀ DROPDOWN
        private void NapDuLieuLocVaDropdown()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                using (SqlDataAdapter da = new SqlDataAdapter("SELECT MaKhuVuc, TenKhuVuc FROM khuvuc", conn))
                {
                    DataTable dtKV = new DataTable();
                    da.Fill(dtKV);

                    ddlLocKhuVuc.Items.Clear();
                    ddlLocKhuVuc.Items.Add(new ListItem("-- Tất cả khu vực --", ""));
                    ddlKhuVucThemBan.Items.Clear();

                    foreach (DataRow r in dtKV.Rows)
                    {
                        ListItem item = new ListItem(r["TenKhuVuc"].ToString(), r["MaKhuVuc"].ToString());
                        ddlLocKhuVuc.Items.Add(item);
                        ddlKhuVucThemBan.Items.Add(item);
                    }
                }
            }
        }

        private void NapDropdownModal()
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();

                // Nạp bàn đang phục vụ vào dropdown chuyển bàn
                using (SqlCommand cmd = new SqlCommand("SELECT MaBan, TenBan FROM banan WHERE TrangThai = 'DangPhucVu'", conn))
                {
                    using (SqlDataReader rd = cmd.ExecuteReader())
                    {
                        ddlBanChuyenDi.Items.Clear();
                        while (rd.Read())
                        {
                            ddlBanChuyenDi.Items.Add(new ListItem(rd["TenBan"].ToString(), rd["MaBan"].ToString()));
                        }
                    }
                }

                // Nạp bàn trống vào dropdown chuyển bàn và đặt trước
                using (SqlCommand cmd = new SqlCommand("SELECT MaBan, TenBan + ' (' + CAST(SoGhe AS VARCHAR) + ' ghế)' AS ThongTinBan FROM banan WHERE TrangThai = 'Trong'", conn))
                {
                    using (SqlDataReader rd = cmd.ExecuteReader())
                    {
                        ddlBanChuyenDen.Items.Clear();
                        ddlBanDatTruoc.Items.Clear();
                        while (rd.Read())
                        {
                            ListItem it = new ListItem(rd["ThongTinBan"].ToString(), rd["MaBan"].ToString());
                            ddlBanChuyenDen.Items.Add(it);
                            ddlBanDatTruoc.Items.Add(it);
                        }
                    }
                }
            }
        }

        // 6. THỰC HIỆN THÊM BÀN MỚI (F14)
        protected void btnLuuBanMoi_Click(object sender, EventArgs e)
        {
            string tenBan = txtTenBanMoi.Text.Trim();
            string maKV = ddlKhuVucThemBan.SelectedValue;
            int soGhe;

            if (string.IsNullOrEmpty(tenBan) || !int.TryParse(txtSoGheMoi.Text, out soGhe) || soGhe <= 0)
            {
                HienThongBao("Vui lòng nhập tên bàn hợp lệ và số ghế phải lớn hơn 0!", false);
                return;
            }

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = "INSERT INTO banan (TenBan, SoGhe, TrangThai, MaKhuVuc) VALUES (@TenBan, @SoGhe, 'Trong', @MaKhuVuc)";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@TenBan", tenBan);
                    cmd.Parameters.AddWithValue("@SoGhe", soGhe);
                    cmd.Parameters.AddWithValue("@MaKhuVuc", maKV);

                    conn.Open();
                    int kq = cmd.ExecuteNonQuery();
                    if (kq > 0)
                    {
                        HienThongBao("Thêm bàn mới thành công!", true);
                        txtTenBanMoi.Text = "";
                        TaiDuLieuTrang();
                    }
                }
            }
        }

        // 7. XÓA BÀN ĂN (F16)
        protected void btnXoaBan_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string maBan = btn.CommandArgument;

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();

                // Kiểm tra ràng buộc đơn hàng
                using (SqlCommand cmdCheck = new SqlCommand("SELECT COUNT(*) FROM donhang WHERE MaBan = @MaBan", conn))
                {
                    cmdCheck.Parameters.AddWithValue("@MaBan", maBan);
                    object count = cmdCheck.ExecuteScalar();
                    if (count != null && Convert.ToInt32(count) > 0)
                    {
                        HienThongBao("Bàn này đã từng phát sinh đơn hàng, không thể xóa!", false);
                        return;
                    }
                }

                // Thực hiện xóa khi bàn trống
                using (SqlCommand cmdXoa = new SqlCommand("DELETE FROM banan WHERE MaBan = @MaBan AND TrangThai = 'Trong'", conn))
                {
                    cmdXoa.Parameters.AddWithValue("@MaBan", maBan);
                    int kq = cmdXoa.ExecuteNonQuery();
                    if (kq > 0)
                    {
                        HienThongBao("Xóa bàn thành công!", true);
                        TaiDuLieuTrang();
                    }
                }
            }
        }

        // 8. ĐIỀU PHỐI CHUYỂN BÀN (F19)
        protected void btnXacNhanChuyenBan_Click(object sender, EventArgs e)
        {
            if (ddlBanChuyenDi.Items.Count == 0 || ddlBanChuyenDen.Items.Count == 0)
            {
                HienThongBao("Cần có ít nhất 1 bàn đang phục vụ và 1 bàn trống để chuyển!", false);
                return;
            }

            int maBanCu = Convert.ToInt32(ddlBanChuyenDi.SelectedValue);
            int maBanMoi = Convert.ToInt32(ddlBanChuyenDen.SelectedValue);

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction();
                try
                {
                    // Chuyển bàn cũ về Trống
                    using (SqlCommand cmd1 = new SqlCommand("UPDATE banan SET TrangThai = 'Trong' WHERE MaBan = @MaCu", conn, trans))
                    {
                        cmd1.Parameters.AddWithValue("@MaCu", maBanCu);
                        cmd1.ExecuteNonQuery();
                    }

                    // Chuyển bàn mới thành DangPhucVu
                    using (SqlCommand cmd2 = new SqlCommand("UPDATE banan SET TrangThai = 'DangPhucVu' WHERE MaBan = @MaMoi", conn, trans))
                    {
                        cmd2.Parameters.AddWithValue("@MaMoi", maBanMoi);
                        cmd2.ExecuteNonQuery();
                    }

                    // Đổi mã bàn trong đơn hàng đang phục vụ
                    using (SqlCommand cmd3 = new SqlCommand("UPDATE donhang SET MaBan = @MaMoi WHERE MaBan = @MaCu AND TrangThaiDon = 'DangPhucVu'", conn, trans))
                    {
                        cmd3.Parameters.AddWithValue("@MaMoi", maBanMoi);
                        cmd3.Parameters.AddWithValue("@MaCu", maBanCu);
                        cmd3.ExecuteNonQuery();
                    }

                    trans.Commit();
                    HienThongBao("Chuyển bàn thành công!", true);
                    TaiDuLieuTrang();
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    HienThongBao("Lỗi chuyển bàn: " + ex.Message, false);
                }
            }
        }

        // 9. LẬP PHIẾU ĐẶT BÀN TRƯỚC (F21)
        protected void btnLuuDatBan_Click(object sender, EventArgs e)
        {
            string tenKhach = txtTenKhachDat.Text.Trim();
            string sdt = txtSDTKhachDat.Text.Trim();
            string ngay = txtNgayDenDat.Text;
            string gio = txtGioDenDat.Text;
            int soKhach;

            if (string.IsNullOrEmpty(tenKhach) || string.IsNullOrEmpty(sdt) || !int.TryParse(txtSoLuongKhachDat.Text, out soKhach) || soKhach <= 0)
            {
                HienThongBao("Vui lòng điền đầy đủ tên khách, số điện thoại và số lượng khách hợp lệ!", false);
                return;
            }

            if (ddlBanDatTruoc.Items.Count == 0)
            {
                HienThongBao("Không còn bàn trống để đặt trước!", false);
                return;
            }

            int maBan = Convert.ToInt32(ddlBanDatTruoc.SelectedValue);
            string ngayGioHen = string.Format("{0} {1}:00", ngay, gio);
            string maNV = (Session["MaNhanVien"] != null) ? Session["MaNhanVien"].ToString() : "NV001";

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction();
                try
                {
                    // 1. Thêm hoặc lấy khách hàng
                    string sqlKhach = "IF NOT EXISTS (SELECT 1 FROM khachhang WHERE SoDienThoai = @SDT) " +
                                      "BEGIN " +
                                      "   INSERT INTO khachhang (TenKhachHang, SoDienThoai) VALUES (@Ten, @SDT); " +
                                      "END; " +
                                      "SELECT MaKhachHang FROM khachhang WHERE SoDienThoai = @SDT;";
                    int maKhach;
                    using (SqlCommand cmdKhach = new SqlCommand(sqlKhach, conn, trans))
                    {
                        cmdKhach.Parameters.AddWithValue("@Ten", tenKhach);
                        cmdKhach.Parameters.AddWithValue("@SDT", sdt);
                        maKhach = Convert.ToInt32(cmdKhach.ExecuteScalar());
                    }

                    // 2. Thêm phiếu đặt bàn
                    string sqlDat = "INSERT INTO datban (SoLuongKhach, NgayGioDenDuKien, GhiChu, TrangThaiDat, MaKhachHang, MaBan, MaNhanVienTiepNhan) " +
                                    "VALUES (@SoLuong, @NgayGio, @GhiChu, 'DaXacNhan', @MaKhach, @MaBan, @MaNV)";
                    using (SqlCommand cmdDat = new SqlCommand(sqlDat, conn, trans))
                    {
                        cmdDat.Parameters.AddWithValue("@SoLuong", soKhach);
                        cmdDat.Parameters.AddWithValue("@NgayGio", ngayGioHen);
                        cmdDat.Parameters.AddWithValue("@GhiChu", txtGhiChuDat.Text.Trim());
                        cmdDat.Parameters.AddWithValue("@MaKhach", maKhach);
                        cmdDat.Parameters.AddWithValue("@MaBan", maBan);
                        cmdDat.Parameters.AddWithValue("@MaNV", maNV);
                        cmdDat.ExecuteNonQuery();
                    }

                    // 3. Đổi trạng thái bàn thành DaDat
                    using (SqlCommand cmdBan = new SqlCommand("UPDATE banan SET TrangThai = 'DaDat' WHERE MaBan = @MaBan", conn, trans))
                    {
                        cmdBan.Parameters.AddWithValue("@MaBan", maBan);
                        cmdBan.ExecuteNonQuery();
                    }

                    trans.Commit();
                    HienThongBao("Lập phiếu đặt bàn trước thành công!", true);

                    txtTenKhachDat.Text = "";
                    txtSDTKhachDat.Text = "";
                    txtGhiChuDat.Text = "";
                    TaiDuLieuTrang();
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    HienThongBao("Lỗi đặt bàn: " + ex.Message, false);
                }
            }
        }

        // 10. NHẬN BÀN TỪ LỊCH ĐẶT (F22)
        protected void btnNhanBan_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string maDatBan = btn.CommandArgument;

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction();
                try
                {
                    int maBan = 0;
                    using (SqlCommand cmdGet = new SqlCommand("SELECT MaBan FROM datban WHERE MaDatBan = @MaDat", conn, trans))
                    {
                        cmdGet.Parameters.AddWithValue("@MaDat", maDatBan);
                        object obj = cmdGet.ExecuteScalar();
                        if (obj != null) maBan = Convert.ToInt32(obj);
                    }

                    if (maBan > 0)
                    {
                        using (SqlCommand cmd1 = new SqlCommand("UPDATE datban SET TrangThaiDat = 'DaNhanBan' WHERE MaDatBan = @MaDat", conn, trans))
                        {
                            cmd1.Parameters.AddWithValue("@MaDat", maDatBan);
                            cmd1.ExecuteNonQuery();
                        }

                        using (SqlCommand cmd2 = new SqlCommand("UPDATE banan SET TrangThai = 'DangPhucVu' WHERE MaBan = @MaBan", conn, trans))
                        {
                            cmd2.Parameters.AddWithValue("@MaBan", maBan);
                            cmd2.ExecuteNonQuery();
                        }

                        trans.Commit();
                        HienThongBao("Đã tiếp nhận khách vào bàn thành công!", true);
                        TaiDuLieuTrang();
                    }
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    HienThongBao("Lỗi tiếp nhận bàn: " + ex.Message, false);
                }
            }
        }

        // 11. HỦY ĐẶT BÀN (F23)
        protected void btnHuyDatBan_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string maDatBan = btn.CommandArgument;

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction();
                try
                {
                    int maBan = 0;
                    using (SqlCommand cmdGet = new SqlCommand("SELECT MaBan FROM datban WHERE MaDatBan = @MaDat", conn, trans))
                    {
                        cmdGet.Parameters.AddWithValue("@MaDat", maDatBan);
                        object obj = cmdGet.ExecuteScalar();
                        if (obj != null) maBan = Convert.ToInt32(obj);
                    }

                    if (maBan > 0)
                    {
                        using (SqlCommand cmd1 = new SqlCommand("UPDATE datban SET TrangThaiDat = 'DaHuy' WHERE MaDatBan = @MaDat", conn, trans))
                        {
                            cmd1.Parameters.AddWithValue("@MaDat", maDatBan);
                            cmd1.ExecuteNonQuery();
                        }

                        using (SqlCommand cmd2 = new SqlCommand("UPDATE banan SET TrangThai = 'Trong' WHERE MaBan = @MaBan", conn, trans))
                        {
                            cmd2.Parameters.AddWithValue("@MaBan", maBan);
                            cmd2.ExecuteNonQuery();
                        }

                        trans.Commit();
                        HienThongBao("Đã hủy lịch đặt bàn thành công!", true);
                        TaiDuLieuTrang();
                    }
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    HienThongBao("Lỗi hủy lịch: " + ex.Message, false);
                }
            }
        }

        // 12. THÊM KHU VỰC MỚI (F17)
        protected void btnLuuKhuVucMoi_Click(object sender, EventArgs e)
        {
            string tenKV = txtTenKhuVucMoi.Text.Trim();
            if (string.IsNullOrEmpty(tenKV))
            {
                HienThongBao("Tên khu vực không được để trống!", false);
                return;
            }

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = "INSERT INTO khuvuc (TenKhuVuc, GhiChu) VALUES (@Ten, @GhiChu)";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@Ten", tenKV);
                    cmd.Parameters.AddWithValue("@GhiChu", txtGhiChuKhuVuc.Text.Trim());

                    conn.Open();
                    int kq = cmd.ExecuteNonQuery();
                    if (kq > 0)
                    {
                        HienThongBao("Thêm khu vực mới thành công!", true);
                        txtTenKhuVucMoi.Text = "";
                        txtGhiChuKhuVuc.Text = "";
                        NapDuLieuLocVaDropdown();
                        TaiDuLieuTrang();
                    }
                }
            }
        }

        // 13. TIỆN ÍCH ĐỊNH DẠNG TRẠNG THÁI HIỂN THỊ
        public string LayClassTrangThai(string trangThai)
        {
            if (trangThai == "DangPhucVu") return "table-state-occupied";
            if (trangThai == "DaDat") return "table-state-reserved";
            return "table-state-empty";
        }

        public string LayBadgeClass(string trangThai)
        {
            if (trangThai == "DangPhucVu") return "badge-soft-occupied";
            if (trangThai == "DaDat") return "badge-soft-reserved";
            return "badge-soft-empty";
        }

        public string LayTenTrangThai(string trangThai)
        {
            if (trangThai == "DangPhucVu") return "Đang phục vụ";
            if (trangThai == "DaDat") return "Đã đặt trước";
            return "Trống";
        }

        private void HienThongBao(string thongBao, bool laThanhCong)
        {
            pnlThongBao.Visible = true;
            lblThongBao.Text = thongBao;
            pnlThongBao.CssClass = laThanhCong ? "alert alert-success alert-dismissible fade show" : "alert alert-danger alert-dismissible fade show";
        }

        protected void ddlLoc_SelectedIndexChanged(object sender, EventArgs e)
        {
            TaiDanhSachKhuVucVaBan();
        }

        protected void btnTimKiem_Click(object sender, EventArgs e)
        {
            TaiDanhSachKhuVucVaBan();
        }

        protected void txtNgayXemLich_TextChanged(object sender, EventArgs e)
        {
            TaiDanhSachLichDatBan();
        }
    }
}
