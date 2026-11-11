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
                int reservation;
                if (int.TryParse(Request.QueryString["datban"], out reservation))
                {
                    var dates = CafeData.Query("SELECT NgayGioDenDuKien FROM datban WHERE MaDatBan=@id",CafeData.Arg("@id",reservation));
                    if (dates.Rows.Count > 0)
                        txtNgayXemLich.Text = ((DateTime)dates.Rows[0][0]).ToString("yyyy-MM-dd");
                    ShowReservationTab();
                }
                txtNgayDenDat.Text = DateTime.Now.AddHours(1).ToString("yyyy-MM-dd");
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
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM banan b WHERE b.TrangThai='Trong' AND NOT EXISTS (SELECT 1 FROM donhang d WHERE d.MaBan=b.MaBan AND d.TrangThaiDon='DangPhucVu') AND NOT EXISTS (SELECT 1 FROM datban r WHERE r.MaBan=b.MaBan AND r.TrangThaiDat='DaXacNhan' AND r.NgayGioDenDuKien BETWEEN GETDATE() AND DATEADD(hour,2,GETDATE()))", conn))
                    {
                        object objBanTrong = cmd.ExecuteScalar();
                        litBanTrong.Text = (objBanTrong != null) ? objBanTrong.ToString() : "0";
                    }

                    // Bàn đang phục vụ
                    using (SqlCommand cmd = new SqlCommand("SELECT COUNT(*) FROM banan b WHERE b.TrangThai='DangPhucVu' OR EXISTS (SELECT 1 FROM donhang d WHERE d.MaBan=b.MaBan AND d.TrangThaiDon='DangPhucVu')", conn))
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
                    string sqlKV = "SELECT MaKhuVuc, TenKhuVuc, ISNULL(GhiChu, N'Khu vực phục vụ') AS GhiChu FROM khuvuc WHERE (@area IS NULL OR MaKhuVuc=@area)";

                    using (SqlDataAdapter da = new SqlDataAdapter(sqlKV, conn))
                    {
                        int area;
                        da.SelectCommand.Parameters.Add("@area", SqlDbType.Int).Value =
                            int.TryParse(ddlLocKhuVuc.SelectedValue, out area) ? (object)area : DBNull.Value;
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
                    string sqlBan = @"SELECT * FROM (
                        SELECT b.MaBan,b.TenBan,b.SoGhe,
                        CASE WHEN EXISTS (SELECT 1 FROM donhang d WHERE d.MaBan=b.MaBan AND d.TrangThaiDon='DangPhucVu')
                            THEN 'DangPhucVu'
                            WHEN EXISTS (SELECT 1 FROM datban r WHERE r.MaBan=b.MaBan AND r.TrangThaiDat='DaXacNhan'
                                AND r.NgayGioDenDuKien BETWEEN GETDATE() AND DATEADD(hour,2,GETDATE()))
                            THEN 'DaDat' ELSE b.TrangThai END AS TrangThai,
                        ISNULL((SELECT SUM(c.ThanhTien) FROM donhang d JOIN chitietdonhang c ON c.MaDonHang=d.MaDonHang
                            WHERE d.MaBan=b.MaBan AND d.TrangThaiDon='DangPhucVu'),0) AS TienTamTinh,
                        (SELECT TOP 1 r.MaDatBan FROM datban r WHERE r.MaBan=b.MaBan
                            AND r.TrangThaiDat IN ('ChoNhanBan','DaXacNhan') ORDER BY r.NgayGioDenDuKien) AS MaDatBan
                        FROM banan b WHERE b.MaKhuVuc=@MaKhuVuc) AS available WHERE 1=1";

                    sqlBan += @" AND (@state='' OR TrangThai=@state)
                        AND (@keyword='' OR TenBan LIKE N'%'+@keyword+N'%'
                        OR CONVERT(varchar(12),MaBan)=@keyword OR 'B'+CONVERT(varchar(12),MaBan)=@keyword)";
                                        using (SqlConnection conn = new SqlConnection(strConn))
                    {
                        using (SqlCommand cmd = new SqlCommand(sqlBan, conn))
                        {
                            cmd.Parameters.AddWithValue("@MaKhuVuc", maKV);
                            cmd.Parameters.AddWithValue("@state", ddlLocTrangThai.SelectedValue);
                            cmd.Parameters.AddWithValue("@keyword", txtTimKiem.Text.Trim());
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
                             "WHERE ((@Search='' AND CONVERT(date, d.NgayGioDenDuKien) = @Ngay) OR (@Search<>'' AND (CONVERT(varchar(12),d.MaDatBan)=@Search OR k.TenKhachHang LIKE N'%'+@Search+N'%' OR k.SoDienThoai LIKE '%'+@Search+'%'))) " +
                             "ORDER BY d.NgayGioDenDuKien ASC";

                using (SqlConnection conn = new SqlConnection(strConn))
                {
                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.AddWithValue("@Ngay", txtNgayXemLich.Text);
                        cmd.Parameters.AddWithValue("@Search", (Request.Form["reservationSearch"] ?? Request.QueryString["datban"] ?? "").Trim());
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
                int editId = (int?)ViewState["EditTable"] ?? 0;
                    string sql = editId == 0
                        ? "INSERT INTO banan (TenBan,SoGhe,TrangThai,MaKhuVuc) VALUES (@TenBan,@SoGhe,'Trong',@MaKhuVuc)"
                        : "UPDATE banan SET TenBan=@TenBan,SoGhe=@SoGhe,MaKhuVuc=@MaKhuVuc WHERE MaBan=@editId";
                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.AddWithValue("@TenBan", tenBan);
                        cmd.Parameters.AddWithValue("@editId", editId);
                    cmd.Parameters.AddWithValue("@SoGhe", soGhe);
                    cmd.Parameters.AddWithValue("@MaKhuVuc", maKV);
                            cmd.Parameters.AddWithValue("@state", ddlLocTrangThai.SelectedValue);
                            cmd.Parameters.AddWithValue("@keyword", txtTimKiem.Text.Trim());

                    conn.Open();
                    int kq = cmd.ExecuteNonQuery();
                    if (kq > 0)
                    {
                        ViewState.Remove("EditTable");
                        HienThongBao("Đã lưu thông tin bàn.", true);
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
                    using (SqlCommand cmd1 = new SqlCommand("UPDATE banan SET TrangThai = 'Trong' WHERE MaBan = @MaCu AND TrangThai='DangPhucVu'", conn, trans))
                    {
                        cmd1.Parameters.AddWithValue("@MaCu", maBanCu);
                        if (cmd1.ExecuteNonQuery() != 1) throw new InvalidOperationException("Bàn nguồn không còn phục vụ.");
                    }

                    // Chuyển bàn mới thành DangPhucVu
                    using (SqlCommand cmd2 = new SqlCommand("UPDATE banan SET TrangThai = 'DangPhucVu' WHERE MaBan = @MaMoi AND TrangThai='Trong' AND NOT EXISTS (SELECT 1 FROM datban WHERE MaBan=@MaMoi AND TrangThaiDat='DaXacNhan' AND NgayGioDenDuKien BETWEEN GETDATE() AND DATEADD(hour,2,GETDATE()))", conn, trans))
                    {
                        cmd2.Parameters.AddWithValue("@MaMoi", maBanMoi);
                        if (cmd2.ExecuteNonQuery() != 1) throw new InvalidOperationException("Bàn đích không còn trống hoặc sắp có khách đặt.");
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

        protected void btnLuuDatBan_Click(object sender, EventArgs e)
        {
            string name = txtTenKhachDat.Text.Trim(), phone = txtSDTKhachDat.Text.Trim(), note = txtGhiChuDat.Text.Trim();
            int guests, table;
            DateTime arrival;
            if (name.Length == 0 || name.Length > 100 || phone.Length == 0 || phone.Length > 15 || note.Length > 255
                || !int.TryParse(txtSoLuongKhachDat.Text, out guests) || guests <= 0
                || !int.TryParse(ddlBanDatTruoc.SelectedValue, out table)
                || !DateTime.TryParseExact(txtNgayDenDat.Text + " " + txtGioDenDat.Text, "yyyy-MM-dd HH:mm",
                    System.Globalization.CultureInfo.InvariantCulture, System.Globalization.DateTimeStyles.None, out arrival)
                || arrival <= DateTime.Now || arrival.Year > 9998)
            {
                HienThongBao("Kiểm tra thông tin khách, bàn và giờ đến trong tương lai.", false);
                return;
            }
            int id = (int?)ViewState["EditReservation"] ?? 0;
            try
            {
                CafeData.Execute(@"SET XACT_ABORT ON; BEGIN TRAN;
                    IF NOT EXISTS (SELECT 1 FROM banan WITH (UPDLOCK,HOLDLOCK)
                        WHERE MaBan=@table AND TrangThai IN ('Trong','DaDat') AND SoGhe>=@guests)
                        THROW 50001,N'Bàn đang phục vụ hoặc không đủ chỗ.',1;
                    IF EXISTS (SELECT 1 FROM datban WHERE MaBan=@table AND MaDatBan<>@id
                        AND TrangThaiDat IN ('ChoNhanBan','DaXacNhan') AND NgayGioDenDuKien>DATEADD(hour,-2,@arrival)
                        AND NgayGioDenDuKien<DATEADD(hour,2,@arrival))
                        THROW 50001,N'Bàn đã có lịch hẹn trong khung giờ này.',1;
                    DECLARE @customer int,@previousTable int;
                    IF @id<>0 BEGIN
                        SELECT @previousTable=MaBan FROM datban WITH (UPDLOCK,HOLDLOCK)
                        WHERE MaDatBan=@id AND TrangThaiDat IN ('ChoNhanBan','DaXacNhan');
                        IF @previousTable IS NULL THROW 50001,N'Lịch đặt đã được xử lý.',1;
                    END;
                    SELECT @customer=MaKhachHang FROM khachhang WITH (UPDLOCK,HOLDLOCK) WHERE SoDienThoai=@phone;
                    IF @customer IS NULL BEGIN
                        INSERT khachhang (TenKhachHang,SoDienThoai) VALUES (@name,@phone);
                        SET @customer=CONVERT(int,SCOPE_IDENTITY());
                    END;
                    IF @id=0
                        INSERT datban (SoLuongKhach,NgayGioDenDuKien,GhiChu,TrangThaiDat,MaKhachHang,MaBan,MaNhanVienTiepNhan)
                        VALUES (@guests,@arrival,@note,'ChoNhanBan',@customer,@table,@employee);
                    ELSE BEGIN
                        UPDATE datban SET SoLuongKhach=@guests,NgayGioDenDuKien=@arrival,GhiChu=@note,
                            MaKhachHang=@customer,MaBan=@table WHERE MaDatBan=@id;
                        IF @previousTable<>@table AND NOT EXISTS (SELECT 1 FROM datban WHERE MaBan=@previousTable AND TrangThaiDat='DaXacNhan')
                            UPDATE banan SET TrangThai='Trong' WHERE MaBan=@previousTable AND TrangThai='DaDat';
                    END;
                    COMMIT;", CafeData.Arg("@id",id), CafeData.Arg("@table",table), CafeData.Arg("@guests",guests),
                    CafeData.Arg("@arrival",arrival), CafeData.Arg("@name",name), CafeData.Arg("@phone",phone),
                    CafeData.Arg("@note",note), CafeData.Arg("@employee",Session["MaNhanVien"]));
                ViewState.Remove("EditReservation");
                txtNgayXemLich.Text = arrival.ToString("yyyy-MM-dd");
                HienThongBao("Đã lưu lịch đặt bàn.", true);
                ShowReservationTab();
                TaiDuLieuTrang();
            }
            catch (SqlException ex) when (ex.Number == 50001 || ex.Number == 1205)
            {
                HienThongBao(ex.Number == 1205 ? "Vui lòng thử lại." : ex.Message, false);
            }
        }

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
            try
            {
                CafeData.Execute(@"SET XACT_ABORT ON; BEGIN TRAN;
                    DECLARE @table int,@tableState varchar(30),@previous varchar(30);
                    SELECT @table=MaBan FROM datban WHERE MaDatBan=@id;
                    SELECT @tableState=TrangThai FROM banan WITH (UPDLOCK,HOLDLOCK) WHERE MaBan=@table;
                    SELECT @previous=TrangThaiDat FROM datban WITH (UPDLOCK,HOLDLOCK) WHERE MaDatBan=@id AND MaBan=@table;
                    IF @previous IS NULL OR (@state='DaXacNhan' AND @previous<>'ChoNhanBan')
                        OR (@state='DaNhanBan' AND (@previous<>'DaXacNhan' OR @tableState NOT IN ('Trong','DaDat')))
                        OR (@state='DaHuy' AND @previous NOT IN ('ChoNhanBan','DaXacNhan'))
                        THROW 50001,N'Lịch hẹn hoặc trạng thái bàn vừa thay đổi.',1;
                    UPDATE datban SET TrangThaiDat=@state WHERE MaDatBan=@id;
                    IF @state='DaNhanBan' UPDATE banan SET TrangThai='DangPhucVu' WHERE MaBan=@table;
                    IF @state='DaHuy' AND @tableState='DaDat' AND NOT EXISTS
                        (SELECT 1 FROM datban WHERE MaBan=@table AND TrangThaiDat='DaXacNhan')
                        UPDATE banan SET TrangThai='Trong' WHERE MaBan=@table;
                    COMMIT;", CafeData.Arg("@id",int.Parse(button.CommandArgument)), CafeData.Arg("@state",state));
                HienThongBao("Đã cập nhật lịch đặt bàn.", true);
                ShowReservationTab();
                TaiDuLieuTrang();
            }
            catch (SqlException ex) when (ex.Number == 50001 || ex.Number == 1205)
            {
                HienThongBao(ex.Number == 1205 ? "Vui lòng thử lại." : ex.Message, false);
            }
        }

        protected void OpenTable(object sender, EventArgs e)
        {
            int table = int.Parse(((LinkButton)sender).CommandArgument);
            try
            {
                string order = CafeData.OpenTableOrder(table, (string)Session["MaNhanVien"]);
                Response.Redirect("GoiMonThanhToan.aspx?don=" + order);
            }
            catch (SqlException ex) when (ex.Number == 50001 || ex.Number == 1205)
            {
                HienThongBao(ex.Number == 1205 ? "Bàn đang được cập nhật. Vui lòng thử lại." : ex.Message, false);
                TaiDuLieuTrang();
            }
        }
        protected void NewReservation(object sender, EventArgs e)
        {
            ViewState.Remove("EditReservation");
            txtTenKhachDat.Text = txtSDTKhachDat.Text = txtGhiChuDat.Text = txtSoLuongKhachDat.Text = "";
            var arrival = DateTime.Now.AddHours(1);
            txtNgayDenDat.Text = arrival.ToString("yyyy-MM-dd");
            txtGioDenDat.Text = arrival.ToString("HH:mm");
            NapDropdownModal();
            OpenModal("modalTaoDatBan");
        }

        protected void NewTable(object sender, EventArgs e)
        {
            ViewState.Remove("EditTable");
            btnLuuBanMoi.Text = "Thêm bàn";
            txtTenBanMoi.Text = txtSoGheMoi.Text = "";
            OpenModal("modalThemBan");
        }

        protected void EditReservation(object sender, EventArgs e)
        {
            int id = int.Parse(((LinkButton)sender).CommandArgument);
            var rows = CafeData.Query(@"SELECT d.*,k.TenKhachHang,k.SoDienThoai,b.TenBan FROM datban d
                JOIN khachhang k ON k.MaKhachHang=d.MaKhachHang JOIN banan b ON b.MaBan=d.MaBan
                WHERE d.MaDatBan=@id AND d.TrangThaiDat IN ('ChoNhanBan','DaXacNhan')", CafeData.Arg("@id",id));
            if (rows.Rows.Count == 0)
                return;
            var row = rows.Rows[0];
            ViewState["EditReservation"] = id;
            txtTenKhachDat.Text = (string)row["TenKhachHang"];
            txtSDTKhachDat.Text = (string)row["SoDienThoai"];
            txtNgayDenDat.Text = ((DateTime)row["NgayGioDenDuKien"]).ToString("yyyy-MM-dd");
            txtGioDenDat.Text = ((DateTime)row["NgayGioDenDuKien"]).ToString("HH:mm");
            txtSoLuongKhachDat.Text = row["SoLuongKhach"].ToString();
            txtGhiChuDat.Text = row["GhiChu"].ToString();
            string table = row["MaBan"].ToString();
            if (ddlBanDatTruoc.Items.FindByValue(table) == null)
                ddlBanDatTruoc.Items.Add(new ListItem((string)row["TenBan"],table));
            ddlBanDatTruoc.SelectedValue = table;
            OpenModal("modalTaoDatBan");
        }

        protected void EditTable(object sender, EventArgs e)
        {
            int id = int.Parse(((LinkButton)sender).CommandArgument);
            var rows = CafeData.Query("SELECT TenBan,SoGhe,MaKhuVuc FROM banan WHERE MaBan=@id",CafeData.Arg("@id",id));
            if (rows.Rows.Count == 0)
                return;
            ViewState["EditTable"] = id;
            btnLuuBanMoi.Text = "Lưu thay đổi";
            txtTenBanMoi.Text = (string)rows.Rows[0]["TenBan"];
            txtSoGheMoi.Text = rows.Rows[0]["SoGhe"].ToString();
            ddlKhuVucThemBan.SelectedValue = rows.Rows[0]["MaKhuVuc"].ToString();
            OpenModal("modalThemBan");
        }

        private void ShowReservationTab()
        {
            ClientScript.RegisterStartupScript(GetType(), "reservations",
                "bootstrap.Tab.getOrCreateInstance(document.querySelector('[data-bs-target=\"#tabLichDatBan\"]')).show();", true);
        }

        private void OpenModal(string id)
        {
            ClientScript.RegisterStartupScript(GetType(),id,"new bootstrap.Modal(document.getElementById('" + id + "')).show();",true);
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
        public string ReservationStatus(object value)
        {
            switch (Convert.ToString(value))
            {
                case "ChoNhanBan": return "Chờ xác nhận";
                case "DaXacNhan": return "Đã xác nhận";
                case "DaNhanBan": return "Đã nhận bàn";
                case "DaHuy": return "Đã hủy";
                default: return "Chờ xử lý";
            }
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
