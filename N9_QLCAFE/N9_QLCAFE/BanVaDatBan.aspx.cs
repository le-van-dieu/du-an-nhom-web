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
        private string strConn = ConfigurationManager.ConnectionStrings["quanlyquancafeConnectionString"].ConnectionString;

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtNgayXemLich.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtNgayDenDat.Text = DateTime.Now.ToString("yyyy-MM-dd");
                txtGioDenDat.Text = DateTime.Now.AddHours(1).ToString("HH:mm");

                int reservation;
                if (int.TryParse(Request.QueryString["datban"], out reservation))
                {
                    using (SqlConnection conn = new SqlConnection(strConn))
                    {
                        using (SqlCommand cmd = new SqlCommand("SELECT NgayGioDenDuKien FROM datban WHERE MaDatBan = @id", conn))
                        {
                            cmd.Parameters.AddWithValue("@id", reservation);
                            conn.Open();
                            object objDate = cmd.ExecuteScalar();
                            if (objDate != null)
                            {
                                txtNgayXemLich.Text = Convert.ToDateTime(objDate).ToString("yyyy-MM-dd");
                            }
                        }
                    }
                    ShowReservationTab();
                }

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

        // 1. THỐNG KÊ KPI TOÀN BỘ HỆ THỐNG
        private void CapNhatThongKeKPI()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    conn.Open();

                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM banan", conn))
                    {
                        object objTongBan = cmd.ExecuteScalar();
                        litTongBan.Text = (objTongBan != null) ? objTongBan.ToString() : "0";
                    }

                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM khuvuc", conn))
                    {
                        object objTongKV = cmd.ExecuteScalar();
                        litTongKhuVuc.Text = (objTongKV != null) ? objTongKV.ToString() : "0";
                    }

                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM banan WHERE TrangThai = 'Trong'", conn))
                    {
                        object objBanTrong = cmd.ExecuteScalar();
                        litBanTrong.Text = (objBanTrong != null) ? objBanTrong.ToString() : "0";
                    }

                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM banan WHERE TrangThai = 'DangPhucVu'", conn))
                    {
                        object objBanDung = cmd.ExecuteScalar();
                        litBanDangDung.Text = (objBanDung != null) ? objBanDung.ToString() : "0";
                    }

                    string sqlDat = "SELECT COUNT(*) FROM datban WHERE CONVERT(date, NgayGioDenDuKien) = CONVERT(date, GETDATE()) AND TrangThaiDat IN ('DaXacNhan', 'ChoNhanBan')";
                    using (SqlCommand cmd = new SqlCommand(sqlDat, conn))
                    {
                        object objLichDat = cmd.ExecuteScalar();
                        litLichDatHomNay.Text = (objLichDat != null) ? objLichDat.ToString() : "0";
                    }
                }
            }
            catch (Exception ex)
            {
                HienThongBao("Lỗi thống kê: " + ex.Message, false);
            }
        }

        // 2. TẢI SƠ ĐỒ 2 CẤP VỚI THỐNG KÊ TỪNG KHU VỰC
        private void TaiDanhSachKhuVucVaBan()
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    string sqlKV = "SELECT k.MaKhuVuc, k.TenKhuVuc, ISNULL(k.GhiChu, N'Khu vực phục vụ') AS GhiChu, " +
                                   "(SELECT COUNT(*) FROM banan b WHERE b.MaKhuVuc = k.MaKhuVuc) AS TongSoBan, " +
                                   "(SELECT COUNT(*) FROM banan b WHERE b.MaKhuVuc = k.MaKhuVuc AND b.TrangThai = 'Trong') AS SoBanTrong, " +
                                   "(SELECT COUNT(*) FROM banan b WHERE b.MaKhuVuc = k.MaKhuVuc AND b.TrangThai = 'DangPhucVu') AS SoBanDangDung, " +
                                   "(SELECT COUNT(*) FROM banan b WHERE b.MaKhuVuc = k.MaKhuVuc AND b.TrangThai = 'DaDat') AS SoBanDaDat " +
                                   "FROM khuvuc k";

                    if (!string.IsNullOrEmpty(ddlLocKhuVuc.SelectedValue))
                    {
                        sqlKV = sqlKV + " WHERE k.MaKhuVuc = " + ddlLocKhuVuc.SelectedValue;
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

        // NẠP CHI TIẾT ĐƠN HÀNG VÀ LỊCH ĐẶT VÀO TỪNG CARD BÀN
        protected void rptKhuVuc_ItemDataBound(object sender, RepeaterItemEventArgs e)
        {
            if (e.Item.ItemType == ListItemType.Item || e.Item.ItemType == ListItemType.AlternatingItem)
            {
                HiddenField hfMaKV = (HiddenField)e.Item.FindControl("hfMaKhuVuc");
                Repeater rptBanAn = (Repeater)e.Item.FindControl("rptBanAn");

                if (hfMaKV != null && rptBanAn != null)
                {
                    string maKV = hfMaKV.Value;
                    string sqlBan = "SELECT b.MaBan, b.TenBan, b.SoGhe, b.TrangThai, " +
                                    "d.MaDonHang, d.ThoiGianTao, DATEDIFF(minute, d.ThoiGianTao, GETDATE()) AS SoPhutNgoi, " +
                                    "ISNULL((SELECT SUM(c.ThanhTien) FROM chitietdonhang c WHERE c.MaDonHang = d.MaDonHang), 0) AS TienTamTinh, " +
                                    "r.MaDatBan, r.SoLuongKhach, r.NgayGioDenDuKien, kh.TenKhachHang, kh.SoDienThoai " +
                                    "FROM banan b " +
                                    "LEFT JOIN donhang d ON b.MaBan = d.MaBan AND d.TrangThaiDon = 'DangPhucVu' " +
                                    "LEFT JOIN (SELECT TOP 1 * FROM datban WHERE TrangThaiDat IN ('DaXacNhan', 'ChoNhanBan') ORDER BY NgayGioDenDuKien ASC) r ON b.MaBan = r.MaBan " +
                                    "LEFT JOIN khachhang kh ON r.MaKhachHang = kh.MaKhachHang " +
                                    "WHERE b.MaKhuVuc = @MaKhuVuc";

                    if (!string.IsNullOrEmpty(ddlLocTrangThai.SelectedValue))
                    {
                        sqlBan = sqlBan + " AND b.TrangThai = '" + ddlLocTrangThai.SelectedValue + "'";
                    }

                    if (!string.IsNullOrEmpty(txtTimKiem.Text.Trim()))
                    {
                        sqlBan = sqlBan + " AND (b.TenBan LIKE N'%" + txtTimKiem.Text.Trim() + "%' OR b.MaBan LIKE '%" + txtTimKiem.Text.Trim() + "%')";
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

        // 3. DANH SÁCH LỊCH ĐẶT BÀN
        private void TaiDanhSachLichDatBan()
        {
            try
            {
                string search = (txtSearchDatBan.Text ?? "").Trim();
                string sql = "SELECT d.MaDatBan, k.TenKhachHang, k.SoDienThoai, d.NgayGioDenDuKien, d.SoLuongKhach, " +
                             "b.TenBan, ISNULL(d.GhiChu, N'Không') AS GhiChu, d.TrangThaiDat " +
                             "FROM datban d " +
                             "INNER JOIN khachhang k ON d.MaKhachHang = k.MaKhachHang " +
                             "INNER JOIN banan b ON d.MaBan = b.MaBan " +
                             "WHERE ((@Search = '' AND CONVERT(date, d.NgayGioDenDuKien) = @Ngay) " +
                             "OR (@Search <> '' AND (CONVERT(varchar(12), d.MaDatBan) = @Search OR k.TenKhachHang LIKE N'%' + @Search + N'%' OR k.SoDienThoai LIKE '%' + @Search + '%'))) " +
                             "ORDER BY d.NgayGioDenDuKien ASC";

                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Ngay", txtNgayXemLich.Text);
                        cmd.Parameters.AddWithValue("@Search", search);
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

        // MỞ BÀN GỌI MÓN HOẶC XEM ĐƠN
        protected void OpenTable(object sender, EventArgs e)
        {
            int maBan = int.Parse(((LinkButton)sender).CommandArgument);
            string maNV = (Session["MaNhanVien"] != null) ? Session["MaNhanVien"].ToString() : "NV001";
            string maDonHang = "";

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                using (SqlCommand cmdCheck = new SqlCommand("SELECT MaDonHang FROM donhang WHERE MaBan = @MaBan AND TrangThaiDon = 'DangPhucVu'", conn))
                {
                    cmdCheck.Parameters.AddWithValue("@MaBan", maBan);
                    object objDon = cmdCheck.ExecuteScalar();
                    if (objDon != null)
                    {
                        maDonHang = objDon.ToString();
                    }
                }

                if (string.IsNullOrEmpty(maDonHang))
                {
                    maDonHang = string.Format("DH{0}", DateTime.Now.ToString("yyyyMMddHHmmss"));
                    using (SqlTransaction trans = conn.BeginTransaction())
                    {
                        try
                        {
                            string sqlTaoDon = "INSERT INTO donhang (MaDonHang, ThoiGianTao, LoaiDon, TrangThaiDon, MaBan, MaNhanVienTao) " +
                                               "VALUES (@MaDH, GETDATE(), 'TaiCho', 'DangPhucVu', @MaBan, @MaNV)";
                            using (SqlCommand cmdTao = new SqlCommand(sqlTaoDon, conn, trans))
                            {
                                cmdTao.Parameters.AddWithValue("@MaDH", maDonHang);
                                cmdTao.Parameters.AddWithValue("@MaBan", maBan);
                                cmdTao.Parameters.AddWithValue("@MaNV", maNV);
                                cmdTao.ExecuteNonQuery();
                            }

                            using (SqlCommand cmdCapNhatBan = new SqlCommand("UPDATE banan SET TrangThai = 'DangPhucVu' WHERE MaBan = @MaBan", conn, trans))
                            {
                                cmdCapNhatBan.Parameters.AddWithValue("@MaBan", maBan);
                                cmdCapNhatBan.ExecuteNonQuery();
                            }

                            trans.Commit();
                        }
                        catch (Exception ex)
                        {
                            trans.Rollback();
                            HienThongBao("Lỗi mở đơn bàn: " + ex.Message, false);
                            return;
                        }
                    }
                }
            }

            Response.Redirect("GoiMonThanhToan.aspx?don=" + maDonHang);
        }

        // LƯU BÀN MỚI HOẶC CẬP NHẬT
        protected void btnLuuBanMoi_Click(object sender, EventArgs e)
        {
            string tenBan = txtTenBanMoi.Text.Trim();
            string maKV = ddlKhuVucThemBan.SelectedValue;
            int soGhe;

            if (string.IsNullOrEmpty(tenBan) || !int.TryParse(txtSoGheMoi.Text, out soGhe) || soGhe <= 0)
            {
                HienThongBao("Vui lòng nhập tên bàn hợp lệ và số ghế > 0!", false);
                return;
            }

            int editId = (ViewState["EditTable"] != null) ? Convert.ToInt32(ViewState["EditTable"]) : 0;

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = editId == 0
                    ? "INSERT INTO banan (TenBan, SoGhe, TrangThai, MaKhuVuc) VALUES (@TenBan, @SoGhe, 'Trong', @MaKhuVuc)"
                    : "UPDATE banan SET TenBan = @TenBan, SoGhe = @SoGhe, MaKhuVuc = @MaKhuVuc WHERE MaBan = @editId";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@TenBan", tenBan);
                    cmd.Parameters.AddWithValue("@SoGhe", soGhe);
                    cmd.Parameters.AddWithValue("@MaKhuVuc", maKV);
                    if (editId > 0)
                    {
                        cmd.Parameters.AddWithValue("@editId", editId);
                    }

                    conn.Open();
                    int kq = cmd.ExecuteNonQuery();
                    if (kq > 0)
                    {
                        ViewState.Remove("EditTable");
                        HienThongBao(editId == 0 ? "Thêm bàn mới thành công!" : "Cập nhật thông tin bàn thành công!", true);
                        txtTenBanMoi.Text = "";
                        TaiDuLieuTrang();
                    }
                }
            }
        }

        protected void EditTable(object sender, EventArgs e)
        {
            int id = int.Parse(((LinkButton)sender).CommandArgument);
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                using (SqlCommand cmd = new SqlCommand("SELECT TenBan, SoGhe, MaKhuVuc FROM banan WHERE MaBan = @id", conn))
                {
                    cmd.Parameters.AddWithValue("@id", id);
                    conn.Open();
                    using (SqlDataReader rd = cmd.ExecuteReader())
                    {
                        if (rd.Read())
                        {
                            ViewState["EditTable"] = id;
                            btnLuuBanMoi.Text = "Lưu thay đổi";
                            txtTenBanMoi.Text = rd["TenBan"].ToString();
                            txtSoGheMoi.Text = rd["SoGhe"].ToString();
                            ddlKhuVucThemBan.SelectedValue = rd["MaKhuVuc"].ToString();
                            OpenModal("modalThemBan");
                        }
                    }
                }
            }
        }

        protected void NewTable(object sender, EventArgs e)
        {
            ViewState.Remove("EditTable");
            btnLuuBanMoi.Text = "Lưu Bàn Mới";
            txtTenBanMoi.Text = "";
            txtSoGheMoi.Text = "4";
            OpenModal("modalThemBan");
        }

        protected void btnXoaBan_Click(object sender, EventArgs e)
        {
            LinkButton btn = (LinkButton)sender;
            string maBan = btn.CommandArgument;

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                using (SqlCommand cmdCheck = new SqlCommand("SELECT COUNT(*) FROM donhang WHERE MaBan = @MaBan", conn))
                {
                    cmdCheck.Parameters.AddWithValue("@MaBan", maBan);
                    object count = cmdCheck.ExecuteScalar();
                    if (count != null && Convert.ToInt32(count) > 0)
                    {
                        HienThongBao("Bàn này đã có lịch sử đơn hàng, không thể xóa để bảo toàn dữ liệu kế toán!", false);
                        return;
                    }
                }

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

        // CHUYỂN BÀN
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
                    using (SqlCommand cmd1 = new SqlCommand("UPDATE banan SET TrangThai = 'Trong' WHERE MaBan = @MaCu", conn, trans))
                    {
                        cmd1.Parameters.AddWithValue("@MaCu", maBanCu);
                        cmd1.ExecuteNonQuery();
                    }

                    using (SqlCommand cmd2 = new SqlCommand("UPDATE banan SET TrangThai = 'DangPhucVu' WHERE MaBan = @MaMoi", conn, trans))
                    {
                        cmd2.Parameters.AddWithValue("@MaMoi", maBanMoi);
                        cmd2.ExecuteNonQuery();
                    }

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

        // TẠO HOẶC CẬP NHẬT ĐẶT BÀN
        protected void btnLuuDatBan_Click(object sender, EventArgs e)
        {
            string name = txtTenKhachDat.Text.Trim();
            string phone = txtSDTKhachDat.Text.Trim();
            string note = txtGhiChuDat.Text.Trim();
            int guests, table;
            DateTime arrival;

            if (string.IsNullOrEmpty(name) || string.IsNullOrEmpty(phone) ||
                !int.TryParse(txtSoLuongKhachDat.Text, out guests) || guests <= 0 ||
                !int.TryParse(ddlBanDatTruoc.SelectedValue, out table) ||
                !DateTime.TryParseExact(string.Format("{0} {1}", txtNgayDenDat.Text, txtGioDenDat.Text), "yyyy-MM-dd HH:mm",
                    System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out arrival))
            {
                HienThongBao("Vui lòng kiểm tra lại thông tin khách, số lượng và thời gian hẹn hợp lệ!", false);
                return;
            }

            int id = (ViewState["EditReservation"] != null) ? Convert.ToInt32(ViewState["EditReservation"]) : 0;
            string maNV = (Session["MaNhanVien"] != null) ? Session["MaNhanVien"].ToString() : "NV001";

            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction();
                try
                {
                    // 1. Thêm hoặc lấy khách hàng
                    string sqlKhach = "IF NOT EXISTS (SELECT 1 FROM khachhang WHERE SoDienThoai = @phone) " +
                                      "BEGIN " +
                                      "   INSERT INTO khachhang (TenKhachHang, SoDienThoai) VALUES (@name, @phone); " +
                                      "END; " +
                                      "SELECT MaKhachHang FROM khachhang WHERE SoDienThoai = @phone;";

                    int customerId;
                    using (SqlCommand cmdKhach = new SqlCommand(sqlKhach, conn, trans))
                    {
                        cmdKhach.Parameters.AddWithValue("@name", name);
                        cmdKhach.Parameters.AddWithValue("@phone", phone);
                        customerId = Convert.ToInt32(cmdKhach.ExecuteScalar());
                    }

                    // 2. Thêm hoặc sửa bảng datban
                    if (id == 0)
                    {
                        string sqlDat = "INSERT INTO datban (SoLuongKhach, NgayGioDenDuKien, GhiChu, TrangThaiDat, MaKhachHang, MaBan, MaNhanVienTiepNhan) " +
                                        "VALUES (@guests, @arrival, @note, 'DaXacNhan', @customer, @table, @employee)";
                        using (SqlCommand cmdDat = new SqlCommand(sqlDat, conn, trans))
                        {
                            cmdDat.Parameters.AddWithValue("@guests", guests);
                            cmdDat.Parameters.AddWithValue("@arrival", arrival);
                            cmdDat.Parameters.AddWithValue("@note", note);
                            cmdDat.Parameters.AddWithValue("@customer", customerId);
                            cmdDat.Parameters.AddWithValue("@table", table);
                            cmdDat.Parameters.AddWithValue("@employee", maNV);
                            cmdDat.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        string sqlUpdate = "UPDATE datban SET SoLuongKhach = @guests, NgayGioDenDuKien = @arrival, GhiChu = @note, " +
                                           "MaKhachHang = @customer, MaBan = @table WHERE MaDatBan = @id";
                        using (SqlCommand cmdUp = new SqlCommand(sqlUpdate, conn, trans))
                        {
                            cmdUp.Parameters.AddWithValue("@guests", guests);
                            cmdUp.Parameters.AddWithValue("@arrival", arrival);
                            cmdUp.Parameters.AddWithValue("@note", note);
                            cmdUp.Parameters.AddWithValue("@customer", customerId);
                            cmdUp.Parameters.AddWithValue("@table", table);
                            cmdUp.Parameters.AddWithValue("@id", id);
                            cmdUp.ExecuteNonQuery();
                        }
                    }

                    // 3. Đổi trạng thái bàn thành DaDat
                    using (SqlCommand cmdBan = new SqlCommand("UPDATE banan SET TrangThai = 'DaDat' WHERE MaBan = @table", conn, trans))
                    {
                        cmdBan.Parameters.AddWithValue("@table", table);
                        cmdBan.ExecuteNonQuery();
                    }

                    trans.Commit();
                    ViewState.Remove("EditReservation");
                    HienThongBao("Đã lưu thông tin lịch đặt bàn thành công!", true);
                    TaiDuLieuTrang();
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    HienThongBao("Lỗi lưu đặt bàn: " + ex.Message, false);
                }
            }
        }

        protected void NewReservation(object sender, EventArgs e)
        {
            ViewState.Remove("EditReservation");
            txtTenKhachDat.Text = "";
            txtSDTKhachDat.Text = "";
            txtGhiChuDat.Text = "";
            txtSoLuongKhachDat.Text = "4";
            txtNgayDenDat.Text = DateTime.Now.ToString("yyyy-MM-dd");
            txtGioDenDat.Text = DateTime.Now.AddHours(1).ToString("HH:mm");
            NapDropdownModal();
            OpenModal("modalTaoDatBan");
        }

        protected void EditReservation(object sender, EventArgs e)
        {
            int id = int.Parse(((LinkButton)sender).CommandArgument);
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                string sql = "SELECT d.*, k.TenKhachHang, k.SoDienThoai, b.TenBan FROM datban d " +
                             "JOIN khachhang k ON k.MaKhachHang = d.MaKhachHang JOIN banan b ON b.MaBan = d.MaBan " +
                             "WHERE d.MaDatBan = @id";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@id", id);
                    conn.Open();
                    using (SqlDataReader rd = cmd.ExecuteReader())
                    {
                        if (rd.Read())
                        {
                            ViewState["EditReservation"] = id;
                            txtTenKhachDat.Text = rd["TenKhachHang"].ToString();
                            txtSDTKhachDat.Text = rd["SoDienThoai"].ToString();
                            txtNgayDenDat.Text = Convert.ToDateTime(rd["NgayGioDenDuKien"]).ToString("yyyy-MM-dd");
                            txtGioDenDat.Text = Convert.ToDateTime(rd["NgayGioDenDuKien"]).ToString("HH:mm");
                            txtSoLuongKhachDat.Text = rd["SoLuongKhach"].ToString();
                            txtGhiChuDat.Text = rd["GhiChu"].ToString();

                            string tableVal = rd["MaBan"].ToString();
                            if (ddlBanDatTruoc.Items.FindByValue(tableVal) == null)
                            {
                                ddlBanDatTruoc.Items.Add(new ListItem(rd["TenBan"].ToString(), tableVal));
                            }
                            ddlBanDatTruoc.SelectedValue = tableVal;
                            OpenModal("modalTaoDatBan");
                        }
                    }
                }
            }
        }

        // CÁC HÀM ĐỔI TRẠNG THÁI LỊCH ĐẶT
        protected void ConfirmReservation(object sender, EventArgs e)
        {
            ChangeReservationState((LinkButton)sender, "DaXacNhan");
        }

        protected void btnNhanBan_Click(object sender, EventArgs e)
        {
            ChangeReservationState((LinkButton)sender, "DaNhanBan");
        }

        protected void btnHuyDatBan_Click(object sender, EventArgs e)
        {
            ChangeReservationState((LinkButton)sender, "DaHuy");
        }

        private void ChangeReservationState(LinkButton button, string state)
        {
            int id = int.Parse(button.CommandArgument);
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();
                SqlTransaction trans = conn.BeginTransaction();
                try
                {
                    int maBan = 0;
                    using (SqlCommand cmdGet = new SqlCommand("SELECT MaBan FROM datban WHERE MaDatBan = @id", conn, trans))
                    {
                        cmdGet.Parameters.AddWithValue("@id", id);
                        object obj = cmdGet.ExecuteScalar();
                        if (obj != null) maBan = Convert.ToInt32(obj);
                    }

                    using (SqlCommand cmdUp = new SqlCommand("UPDATE datban SET TrangThaiDat = @state WHERE MaDatBan = @id", conn, trans))
                    {
                        cmdUp.Parameters.AddWithValue("@state", state);
                        cmdUp.Parameters.AddWithValue("@id", id);
                        cmdUp.ExecuteNonQuery();
                    }

                    if (state == "DaNhanBan")
                    {
                        using (SqlCommand cmdBan = new SqlCommand("UPDATE banan SET TrangThai = 'DangPhucVu' WHERE MaBan = @MaBan", conn, trans))
                        {
                            cmdBan.Parameters.AddWithValue("@MaBan", maBan);
                            cmdBan.ExecuteNonQuery();
                        }
                    }
                    else if (state == "DaHuy")
                    {
                        using (SqlCommand cmdBan = new SqlCommand("UPDATE banan SET TrangThai = 'Trong' WHERE MaBan = @MaBan", conn, trans))
                        {
                            cmdBan.Parameters.AddWithValue("@MaBan", maBan);
                            cmdBan.ExecuteNonQuery();
                        }
                    }

                    trans.Commit();
                    HienThongBao("Đã cập nhật trạng thái lịch đặt thành công!", true);
                    TaiDuLieuTrang();
                }
                catch (Exception ex)
                {
                    trans.Rollback();
                    HienThongBao("Lỗi cập nhật: " + ex.Message, false);
                }
            }
        }

        // THÊM KHU VỰC
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
                    cmd.ExecuteNonQuery();
                    HienThongBao("Thêm khu vực mới thành công!", true);
                    txtTenKhuVucMoi.Text = "";
                    txtGhiChuKhuVuc.Text = "";
                    NapDuLieuLocVaDropdown();
                    TaiDuLieuTrang();
                }
            }
        }

        // HELPER FUNCTIONS
        public string ReservationStatus(object value)
        {
            string st = Convert.ToString(value);
            if (st == "ChoNhanBan") return "Chờ xác nhận";
            if (st == "DaXacNhan") return "Đã xác nhận";
            if (st == "DaNhanBan") return "Đã nhận bàn";
            if (st == "DaHuy") return "Đã hủy";
            return "Chờ xử lý";
        }

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
            lblThongBao.Text = Server.HtmlEncode(thongBao);
            pnlThongBao.CssClass = laThanhCong ? "alert alert-success alert-dismissible fade show" : "alert alert-danger alert-dismissible fade show";
        }

        private void ShowReservationTab()
        {
            ClientScript.RegisterStartupScript(GetType(), "reservations",
                "bootstrap.Tab.getOrCreateInstance(document.querySelector('[data-bs-target=\"#tabLichDatBan\"]')).show();", true);
        }

        private void OpenModal(string id)
        {
            ClientScript.RegisterStartupScript(GetType(), id, "new bootstrap.Modal(document.getElementById('" + id + "')).show();", true);
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
            ShowReservationTab();
        }
    }
}
