
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace N9_QLCAFE
{
    public partial class DoUong : System.Web.UI.Page
    {
        private string ChuoiKetNoi
        {
            get
            {
                return ConfigurationManager.ConnectionStrings["quanlyquancafeConnectionString"].ConnectionString;
            }
        }

        // Nạp danh mục trước khi ASP.NET nhận dữ liệu PostBack
        protected void Page_Init(object sender, EventArgs e)
        {
            NapDanhMucDropdowns("0");
        }

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        // ========================================
        // NẠP DANH MỤC VÀO CÁC DROPDOWNLIST
        // ========================================

        private void NapDanhMucDropdowns(string maDanhMucDangChon)
        {
            DataTable dt = new DataTable();

            using (SqlConnection conn = new SqlConnection(ChuoiKetNoi))
            {
                string sql = @"
                    SELECT MaDanhMuc, TenDanhMuc
                    FROM dbo.danhmuc
                    ORDER BY MaDanhMuc";

                using (SqlDataAdapter da = new SqlDataAdapter(sql, conn))
                {
                    da.Fill(dt);
                }
            }

            ddlDanhMucLoc.Items.Clear();
            ddlDanhMucLoc.Items.Add(
                new ListItem("-- Tất cả danh mục (F10) --", "0"));

            ddlDanhMucForm.Items.Clear();

            foreach (DataRow row in dt.Rows)
            {
                string ma = row["MaDanhMuc"].ToString();
                string ten = row["TenDanhMuc"].ToString();

                ddlDanhMucLoc.Items.Add(new ListItem(ten, ma));
                ddlDanhMucForm.Items.Add(new ListItem(ten, ma));
            }

            if (ddlDanhMucLoc.Items.FindByValue(maDanhMucDangChon) != null)
                ddlDanhMucLoc.SelectedValue = maDanhMucDangChon;
            else
                ddlDanhMucLoc.SelectedValue = "0";
        }

        // ========================================
        // QUẢN LÝ ĐỒ UỐNG
        // ========================================

        protected void rpDoUong_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string maDoUong = Convert.ToString(e.CommandArgument);

            if (string.IsNullOrWhiteSpace(maDoUong))
                return;

            if (e.CommandName == "Sua")
                LoadDoUong(maDoUong);

            if (e.CommandName == "Xoa")
                XoaDoUong(maDoUong);
        }

        private void LoadDoUong(string maDoUong)
        {
            using (SqlConnection conn = new SqlConnection(ChuoiKetNoi))
            {
                string sql = @"
                    SELECT MaDoUong, TenDoUong, GiaBanHienTai,
                           MoTa, TrangThaiKinhDoanh, MaDanhMuc
                    FROM dbo.douong
                    WHERE MaDoUong = @MaDoUong";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.Add("@MaDoUong", SqlDbType.VarChar, 20).Value = maDoUong;

                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            txtMaDoUong.Text = reader["MaDoUong"].ToString();
                            txtTenDoUong.Text = reader["TenDoUong"].ToString();

                            txtGiaBan.Text = Convert.ToDecimal(
                                reader["GiaBanHienTai"]
                            ).ToString(CultureInfo.InvariantCulture);

                            txtMoTa.Text = reader["MoTa"] == DBNull.Value
                                ? ""
                                : reader["MoTa"].ToString();

                            string maDanhMuc = reader["MaDanhMuc"].ToString();
                            string trangThai = reader["TrangThaiKinhDoanh"].ToString();

                            if (ddlDanhMucForm.Items.FindByValue(maDanhMuc) != null)
                                ddlDanhMucForm.SelectedValue = maDanhMuc;

                            if (ddlTrangThaiForm.Items.FindByValue(trangThai) == null)
                                ddlTrangThaiForm.Items.Add(
                                    new ListItem(trangThai, trangThai));

                            ddlTrangThaiForm.SelectedValue = trangThai;

                            hfCheDo.Value = "Sua";
                            txtMaDoUong.ReadOnly = true;

                            MoModalDoUong();
                        }
                        else
                        {
                            ThongBao("Không tìm thấy đồ uống cần chỉnh sửa.");
                        }
                    }
                }
            }
        }

        // Thêm mới hoặc cập nhật đồ uống
        protected void btnLuuDoUong_Click(object sender, EventArgs e)
        {
            string ma = txtMaDoUong.Text.Trim();
            string ten = txtTenDoUong.Text.Trim();
            string moTa = txtMoTa.Text.Trim();

            decimal gia;
            int maDanhMuc;

            bool dangSua = hfCheDo.Value == "Sua";

            if (string.IsNullOrWhiteSpace(ma) ||
                string.IsNullOrWhiteSpace(ten))
            {
                ThongBaoMoDoUong("Vui lòng nhập mã và tên đồ uống.");
                return;
            }

            if (!decimal.TryParse(txtGiaBan.Text.Trim(),
                NumberStyles.Number, CultureInfo.InvariantCulture, out gia)
                || gia <= 0)
            {
                ThongBaoMoDoUong("Giá bán phải lớn hơn 0.");
                return;
            }

            if (!int.TryParse(ddlDanhMucForm.SelectedValue, out maDanhMuc))
            {
                ThongBaoMoDoUong("Vui lòng chọn danh mục đồ uống.");
                return;
            }

            string trangThai = ddlTrangThaiForm.SelectedValue;

            try
            {
                using (SqlConnection conn = new SqlConnection(ChuoiKetNoi))
                {
                    conn.Open();

                    string sql;

                    if (dangSua)
                    {
                        sql = @"
                            UPDATE dbo.douong
                            SET TenDoUong = @TenDoUong,
                                GiaBanHienTai = @GiaBan,
                                MoTa = @MoTa,
                                TrangThaiKinhDoanh = @TrangThai,
                                MaDanhMuc = @MaDanhMuc
                            WHERE MaDoUong = @MaDoUong";
                    }
                    else
                    {
                        sql = @"
                            INSERT INTO dbo.douong
                            (
                                MaDoUong, TenDoUong, GiaBanHienTai,
                                HinhAnh, MoTa, TrangThaiKinhDoanh, MaDanhMuc
                            )
                            VALUES
                            (
                                @MaDoUong, @TenDoUong, @GiaBan,
                                NULL, @MoTa, @TrangThai, @MaDanhMuc
                            )";
                    }

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.Add("@MaDoUong", SqlDbType.VarChar, 20).Value = ma;

                        cmd.Parameters.Add("@TenDoUong", SqlDbType.NVarChar, 100).Value = ten;

                        SqlParameter pGia = cmd.Parameters.Add("@GiaBan", SqlDbType.Decimal);
                        pGia.Precision = 18;
                        pGia.Scale = 2;
                        pGia.Value = gia;

                        cmd.Parameters.Add("@MoTa", SqlDbType.NVarChar, -1).Value =
                            string.IsNullOrWhiteSpace(moTa)
                                ? (object)DBNull.Value
                                : moTa;

                        cmd.Parameters.Add("@TrangThai", SqlDbType.VarChar, 30).Value = trangThai;

                        cmd.Parameters.Add("@MaDanhMuc", SqlDbType.Int).Value = maDanhMuc;

                        int ketQua = cmd.ExecuteNonQuery();

                        if (ketQua == 0)
                        {
                            ThongBaoMoDoUong("Không tìm thấy đồ uống cần cập nhật.");
                            return;
                        }
                    }
                }

                hfCheDo.Value = "Them";
                txtMaDoUong.ReadOnly = false;

                LamMoiDanhSach();

                ThongBao(dangSua
                    ? "Cập nhật đồ uống thành công."
                    : "Thêm đồ uống mới thành công.");
            }
            catch (SqlException ex)
            {
                if (ex.Number == 2627 || ex.Number == 2601)
                    ThongBaoMoDoUong("Mã đồ uống đã tồn tại.");
                else
                    ThongBaoMoDoUong("Lỗi SQL: " + ex.Message);
            }
            catch (Exception ex)
            {
                ThongBaoMoDoUong("Có lỗi khi lưu đồ uống: " + ex.Message);
            }
        }

        // Xóa đồ uống hoặc chuyển sang ngừng kinh doanh
        private void XoaDoUong(string maDoUong)
        {
            try
            {
                string thongBao;

                using (SqlConnection conn = new SqlConnection(ChuoiKetNoi))
                {
                    conn.Open();

                    using (SqlTransaction tran = conn.BeginTransaction(IsolationLevel.Serializable))
                    {
                        try
                        {
                            string sqlKiemTra = @"
                                SELECT COUNT(*)
                                FROM dbo.chitietdonhang
                                WHERE MaDoUong = @MaDoUong";

                            int soGiaoDich;

                            using (SqlCommand cmd = new SqlCommand(sqlKiemTra, conn, tran))
                            {
                                cmd.Parameters.Add("@MaDoUong", SqlDbType.VarChar, 20).Value = maDoUong;
                                soGiaoDich = Convert.ToInt32(cmd.ExecuteScalar());
                            }

                            string sql;

                            if (soGiaoDich > 0)
                            {
                                sql = @"
                                    UPDATE dbo.douong
                                    SET TrangThaiKinhDoanh = 'NgungKinhDoanh'
                                    WHERE MaDoUong = @MaDoUong";

                                thongBao = "Đồ uống đã có giao dịch nên được chuyển sang Ngừng kinh doanh.";
                            }
                            else
                            {
                                sql = "DELETE FROM dbo.douong WHERE MaDoUong = @MaDoUong";
                                thongBao = "Xóa đồ uống thành công.";
                            }

                            using (SqlCommand cmd = new SqlCommand(sql, conn, tran))
                            {
                                cmd.Parameters.Add("@MaDoUong", SqlDbType.VarChar, 20).Value = maDoUong;

                                if (cmd.ExecuteNonQuery() == 0)
                                    throw new Exception("Không tìm thấy đồ uống.");
                            }

                            tran.Commit();
                        }
                        catch
                        {
                            tran.Rollback();
                            throw;
                        }
                    }
                }

                LamMoiDanhSach();
                ThongBao(thongBao);
            }
            catch (Exception ex)
            {
                ThongBao("Không thể xử lý đồ uống: " + ex.Message);
            }
        }

        // ========================================
        // QUẢN LÝ DANH MỤC F10
        // ========================================

        protected void rpDanhMuc_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int maDanhMuc;

            if (!int.TryParse(Convert.ToString(e.CommandArgument), out maDanhMuc))
                return;

            if (e.CommandName == "SuaDanhMuc")
                LoadDanhMuc(maDanhMuc);

            if (e.CommandName == "XoaDanhMuc")
                XoaDanhMuc(maDanhMuc);
        }

        // Lấy danh mục cần chỉnh sửa
        private void LoadDanhMuc(int maDanhMuc)
        {
            using (SqlConnection conn = new SqlConnection(ChuoiKetNoi))
            {
                string sql = @"
                    SELECT TenDanhMuc
                    FROM dbo.danhmuc
                    WHERE MaDanhMuc = @MaDanhMuc";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    cmd.Parameters.Add("@MaDanhMuc", SqlDbType.Int).Value = maDanhMuc;

                    conn.Open();

                    object ketQua = cmd.ExecuteScalar();

                    if (ketQua == null || ketQua == DBNull.Value)
                    {
                        ThongBaoMoDanhMuc("Không tìm thấy danh mục.");
                        return;
                    }

                    hfMaDanhMuc.Value = maDanhMuc.ToString();
                    txtTenDanhMuc.Text = ketQua.ToString();
                    btnLuuDanhMuc.Text = "Cập nhật";

                    MoModalDanhMuc();
                }
            }
        }

        // Thêm mới hoặc sửa danh mục
        protected void btnLuuDanhMuc_Click(object sender, EventArgs e)
        {
            string tenDanhMuc = txtTenDanhMuc.Text.Trim();

            int maDanhMuc = 0;

            bool dangSua = int.TryParse(hfMaDanhMuc.Value, out maDanhMuc)
                && maDanhMuc > 0;

            if (string.IsNullOrWhiteSpace(tenDanhMuc))
            {
                ThongBaoMoDanhMuc("Vui lòng nhập tên danh mục.");
                return;
            }

            if (tenDanhMuc.Length > 100)
            {
                ThongBaoMoDanhMuc("Tên danh mục không được vượt quá 100 ký tự.");
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(ChuoiKetNoi))
                {
                    conn.Open();

                    // Kiểm tra danh mục trùng tên
                    string sqlTrung = @"
                        SELECT COUNT(*)
                        FROM dbo.danhmuc
                        WHERE TenDanhMuc = @TenDanhMuc
                        AND (@MaDanhMuc = 0 OR MaDanhMuc <> @MaDanhMuc)";

                    using (SqlCommand cmd = new SqlCommand(sqlTrung, conn))
                    {
                        cmd.Parameters.Add("@TenDanhMuc", SqlDbType.NVarChar, 100).Value = tenDanhMuc;
                        cmd.Parameters.Add("@MaDanhMuc", SqlDbType.Int).Value = dangSua ? maDanhMuc : 0;

                        if (Convert.ToInt32(cmd.ExecuteScalar()) > 0)
                        {
                            ThongBaoMoDanhMuc("Tên danh mục đã tồn tại.");
                            return;
                        }
                    }

                    string sql;

                    if (dangSua)
                    {
                        sql = @"
                            UPDATE dbo.danhmuc
                            SET TenDanhMuc = @TenDanhMuc
                            WHERE MaDanhMuc = @MaDanhMuc";
                    }
                    else
                    {
                        sql = @"
                            INSERT INTO dbo.danhmuc (TenDanhMuc, MoTa)
                            VALUES (@TenDanhMuc, NULL)";
                    }

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.Add("@TenDanhMuc", SqlDbType.NVarChar, 100).Value = tenDanhMuc;

                        if (dangSua)
                            cmd.Parameters.Add("@MaDanhMuc", SqlDbType.Int).Value = maDanhMuc;

                        int ketQua = cmd.ExecuteNonQuery();

                        if (dangSua && ketQua == 0)
                        {
                            ThongBaoMoDanhMuc("Không tìm thấy danh mục cần cập nhật.");
                            return;
                        }
                    }
                }

                ResetFormDanhMuc();
                LamMoiDanhMuc();

                ThongBaoMoDanhMuc(dangSua
                    ? "Cập nhật danh mục thành công."
                    : "Thêm danh mục thành công.");
            }
            catch (Exception ex)
            {
                ThongBaoMoDanhMuc("Không thể lưu danh mục: " + ex.Message);
            }
        }

        // Xóa danh mục nếu chưa có đồ uống sử dụng
        private void XoaDanhMuc(int maDanhMuc)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ChuoiKetNoi))
                {
                    conn.Open();

                    using (SqlTransaction tran = conn.BeginTransaction(IsolationLevel.Serializable))
                    {
                        try
                        {
                            string sqlKiemTra = @"
                                SELECT COUNT(*)
                                FROM dbo.douong WITH (UPDLOCK, HOLDLOCK)
                                WHERE MaDanhMuc = @MaDanhMuc";

                            int soMon;

                            using (SqlCommand cmd = new SqlCommand(sqlKiemTra, conn, tran))
                            {
                                cmd.Parameters.Add("@MaDanhMuc", SqlDbType.Int).Value = maDanhMuc;
                                soMon = Convert.ToInt32(cmd.ExecuteScalar());
                            }

                            if (soMon > 0)
                            {
                                tran.Rollback();

                                ThongBaoMoDanhMuc(
                                    "Không thể xóa danh mục vì đang có "
                                    + soMon
                                    + " đồ uống sử dụng. Vui lòng chuyển đồ uống sang danh mục khác trước.");

                                return;
                            }

                            string sqlXoa = @"
                                DELETE FROM dbo.danhmuc
                                WHERE MaDanhMuc = @MaDanhMuc";

                            using (SqlCommand cmd = new SqlCommand(sqlXoa, conn, tran))
                            {
                                cmd.Parameters.Add("@MaDanhMuc", SqlDbType.Int).Value = maDanhMuc;

                                if (cmd.ExecuteNonQuery() == 0)
                                    throw new Exception("Không tìm thấy danh mục cần xóa.");
                            }

                            tran.Commit();
                        }
                        catch
                        {
                            if (tran.Connection != null)
                                tran.Rollback();

                            throw;
                        }
                    }
                }

                ResetFormDanhMuc();
                LamMoiDanhMuc();

                ThongBaoMoDanhMuc("Xóa danh mục thành công.");
            }
            catch (SqlException ex)
            {
                if (ex.Number == 547)
                    ThongBaoMoDanhMuc("Không thể xóa danh mục vì đang được dữ liệu khác sử dụng.");
                else
                    ThongBaoMoDanhMuc("Lỗi SQL: " + ex.Message);
            }
            catch (Exception ex)
            {
                ThongBaoMoDanhMuc("Không thể xóa danh mục: " + ex.Message);
            }
        }

        // ========================================
        // LÀM MỚI DỮ LIỆU SAU KHI THAO TÁC
        // ========================================

        private void LamMoiDanhMuc()
        {
            string danhMucDangChon = ddlDanhMucLoc.SelectedValue;

            NapDanhMucDropdowns(danhMucDangChon);

            LamMoiDanhSach();
        }

        private void LamMoiDanhSach()
        {
            rpDanhMuc.DataBind();
            rpDoUong.DataBind();
            rpTongDoUong.DataBind();
            lvMenuConHang.DataBind();
        }

        private void ResetFormDanhMuc()
        {
            hfMaDanhMuc.Value = "";
            txtTenDanhMuc.Text = "";
            btnLuuDanhMuc.Text = "Thêm";
        }

        // ========================================
        // MODAL VÀ THÔNG BÁO
        // ========================================

        private void MoModalDanhMuc()
        {
            string script = @"
                window.addEventListener('load', function () {
                    var modalElement = document.getElementById('modalDanhMuc');

                    if (modalElement && window.bootstrap) {
                        bootstrap.Modal.getOrCreateInstance(modalElement).show();
                    }
                });";

            Page.ClientScript.RegisterStartupScript(
                GetType(),
                "MoModalDanhMuc" + Guid.NewGuid().ToString("N"),
                script,
                true);
        }

        private void ThongBaoMoDanhMuc(string noiDung)
        {
            string safe = HttpUtility.JavaScriptStringEncode(noiDung);

            string script = @"
                alert('" + safe + @"');

                var modalElement = document.getElementById('modalDanhMuc');

                if (modalElement && window.bootstrap) {
                    bootstrap.Modal.getOrCreateInstance(modalElement).show();
                }";

            Page.ClientScript.RegisterStartupScript(
                GetType(),
                "ThongBaoDanhMuc" + Guid.NewGuid().ToString("N"),
                script,
                true);
        }

        private void MoModalDoUong()
        {
            string script = @"
                window.addEventListener('load', function () {
                    var modalElement = document.getElementById('modalThemDoUong');

                    if (modalElement && window.bootstrap) {
                        bootstrap.Modal.getOrCreateInstance(modalElement).show();
                    }
                });";

            Page.ClientScript.RegisterStartupScript(
                GetType(),
                "MoModalDoUong" + Guid.NewGuid().ToString("N"),
                script,
                true);
        }

        private void ThongBaoMoDoUong(string noiDung)
        {
            string safe = HttpUtility.JavaScriptStringEncode(noiDung);

            string script = @"
                alert('" + safe + @"');

                var modalElement = document.getElementById('modalThemDoUong');

                if (modalElement && window.bootstrap) {
                    bootstrap.Modal.getOrCreateInstance(modalElement).show();
                }";

            Page.ClientScript.RegisterStartupScript(
                GetType(),
                "ThongBaoDoUong" + Guid.NewGuid().ToString("N"),
                script,
                true);
        }

        private void ThongBao(string noiDung)
        {
            string safe = HttpUtility.JavaScriptStringEncode(noiDung);

            string script = "alert('" + safe + "');";

            Page.ClientScript.RegisterStartupScript(
                GetType(),
                "ThongBao" + Guid.NewGuid().ToString("N"),
                script,
                true);
        }
    }
}
