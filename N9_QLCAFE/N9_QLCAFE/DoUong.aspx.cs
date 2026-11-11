
using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.IO;
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

        protected void Page_Init(object sender, EventArgs e)
        {
            string danhMucLoc = Request.Form[ddlDanhMucLoc.UniqueID];
            string danhMucForm = Request.Form[ddlDanhMucForm.UniqueID];

            NapDanhMucDropdowns(danhMucLoc, danhMucForm);
        }

        private void NapDanhMucDropdowns(string danhMucLoc, string danhMucForm)
        {
            ddlDanhMucLoc.Items.Clear();
            ddlDanhMucForm.Items.Clear();

            ddlDanhMucLoc.Items.Add(new ListItem("-- Tất cả danh mục (F10) --", "0"));
            ddlDanhMucForm.Items.Add(new ListItem("-- Chọn danh mục --", ""));

            using (SqlConnection conn = new SqlConnection(ChuoiKetNoi))
            {
                string sql = "SELECT MaDanhMuc, TenDanhMuc FROM dbo.danhmuc ORDER BY MaDanhMuc";

                using (SqlCommand cmd = new SqlCommand(sql, conn))
                {
                    conn.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            string ma = reader["MaDanhMuc"].ToString();
                            string ten = reader["TenDanhMuc"].ToString();

                            ddlDanhMucLoc.Items.Add(new ListItem(ten, ma));
                            ddlDanhMucForm.Items.Add(new ListItem(ten, ma));
                        }
                    }
                }
            }

            if (!string.IsNullOrEmpty(danhMucLoc) &&
                ddlDanhMucLoc.Items.FindByValue(danhMucLoc) != null)
            {
                ddlDanhMucLoc.SelectedValue = danhMucLoc;
            }

            if (!string.IsNullOrEmpty(danhMucForm) &&
                ddlDanhMucForm.Items.FindByValue(danhMucForm) != null)
            {
                ddlDanhMucForm.SelectedValue = danhMucForm;
            }
        }

        protected void btnLuuDoUong_Click(object sender, EventArgs e)
        {
            string maDoUong = txtMaDoUong.Text.Trim();
            string tenDoUong = txtTenDoUong.Text.Trim();
            string maDanhMuc = ddlDanhMucForm.SelectedValue;
            string trangThai = ddlTrangThaiForm.SelectedValue;
            string moTa = txtMoTa.Text.Trim();
            string giaText = txtGiaBan.Text.Trim();

            bool dangSua = hfCheDo.Value == "Sua";
            decimal giaBan;

            if (maDoUong == "")
            {
                ThongBaoVaMoModal("Vui lòng nhập mã đồ uống!", "modalThemDoUong");
                return;
            }

            if (maDoUong.Length > 20)
            {
                ThongBaoVaMoModal("Mã đồ uống không được vượt quá 20 ký tự!", "modalThemDoUong");
                return;
            }

            if (tenDoUong == "")
            {
                ThongBaoVaMoModal("Vui lòng nhập tên đồ uống!", "modalThemDoUong");
                return;
            }

            if (tenDoUong.Length > 100)
            {
                ThongBaoVaMoModal("Tên đồ uống không được vượt quá 100 ký tự!", "modalThemDoUong");
                return;
            }

            if (maDanhMuc == "" || ddlDanhMucForm.Items.FindByValue(maDanhMuc) == null)
            {
                ThongBaoVaMoModal("Vui lòng chọn danh mục đồ uống!", "modalThemDoUong");
                return;
            }

            if (!decimal.TryParse(giaText, NumberStyles.Number, CultureInfo.InvariantCulture, out giaBan))
            {
                if (!decimal.TryParse(giaText, NumberStyles.Number, CultureInfo.CurrentCulture, out giaBan))
                {
                    ThongBaoVaMoModal("Giá bán không hợp lệ!", "modalThemDoUong");
                    return;
                }
            }

            if (giaBan <= 0)
            {
                ThongBaoVaMoModal("Giá bán phải lớn hơn 0!", "modalThemDoUong");
                return;
            }

            if (trangThai == "")
            {
                ThongBaoVaMoModal("Vui lòng chọn trạng thái kinh doanh!", "modalThemDoUong");
                return;
            }

            string tenFileMoi = null;

            try
            {
                using (SqlConnection conn = new SqlConnection(ChuoiKetNoi))
                {
                    conn.Open();

                    if (dangSua)
                    {
                        string hinhAnhCu = null;

                        string sqlLayAnh = "SELECT HinhAnh FROM dbo.douong WHERE MaDoUong = @MaDoUong";

                        using (SqlCommand cmdAnh = new SqlCommand(sqlLayAnh, conn))
                        {
                            cmdAnh.Parameters.Add("@MaDoUong", SqlDbType.VarChar, 20).Value = maDoUong;

                            object ketQua = cmdAnh.ExecuteScalar();

                            if (ketQua == null)
                            {
                                ThongBaoVaMoModal("Không tìm thấy đồ uống cần chỉnh sửa!", "modalThemDoUong");
                                return;
                            }

                            if (ketQua != DBNull.Value)
                                hinhAnhCu = ketQua.ToString();
                        }

                        string tenHinhAnh = hinhAnhCu;

                        if (fuHinhAnh.HasFile)
                        {
                            tenFileMoi = LuuFileHinhAnh();
                            tenHinhAnh = tenFileMoi;
                        }

                        string sql = @"
                            UPDATE dbo.douong
                            SET
                                TenDoUong = @TenDoUong,
                                GiaBanHienTai = @GiaBan,
                                HinhAnh = @HinhAnh,
                                MoTa = @MoTa,
                                TrangThaiKinhDoanh = @TrangThai,
                                MaDanhMuc = @MaDanhMuc
                            WHERE MaDoUong = @MaDoUong";

                        using (SqlCommand cmd = new SqlCommand(sql, conn))
                        {
                            ThemThamSoDoUong(cmd, maDoUong, tenDoUong, giaBan,
                                tenHinhAnh, moTa, trangThai, maDanhMuc);

                            cmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        string sqlKiemTra = "SELECT COUNT(*) FROM dbo.douong WHERE MaDoUong = @MaDoUong";

                        using (SqlCommand cmdKiemTra = new SqlCommand(sqlKiemTra, conn))
                        {
                            cmdKiemTra.Parameters.Add("@MaDoUong", SqlDbType.VarChar, 20).Value = maDoUong;

                            int soLuong = Convert.ToInt32(cmdKiemTra.ExecuteScalar());

                            if (soLuong > 0)
                            {
                                ThongBaoVaMoModal("Mã đồ uống đã tồn tại, vui lòng nhập mã khác!", "modalThemDoUong");
                                return;
                            }
                        }

                        string tenHinhAnh = null;

                        if (fuHinhAnh.HasFile)
                        {
                            tenFileMoi = LuuFileHinhAnh();
                            tenHinhAnh = tenFileMoi;
                        }

                        string sql = @"
                            INSERT INTO dbo.douong
                            (
                                MaDoUong,
                                TenDoUong,
                                GiaBanHienTai,
                                HinhAnh,
                                MoTa,
                                TrangThaiKinhDoanh,
                                MaDanhMuc
                            )
                            VALUES
                            (
                                @MaDoUong,
                                @TenDoUong,
                                @GiaBan,
                                @HinhAnh,
                                @MoTa,
                                @TrangThai,
                                @MaDanhMuc
                            )";

                        using (SqlCommand cmd = new SqlCommand(sql, conn))
                        {
                            ThemThamSoDoUong(cmd, maDoUong, tenDoUong, giaBan,
                                tenHinhAnh, moTa, trangThai, maDanhMuc);

                            cmd.ExecuteNonQuery();
                        }
                    }
                }

                LamMoiDanhSach();

                if (dangSua)
                    ThongBaoVaDongModal("Cập nhật đồ uống thành công!", "modalThemDoUong");
                else
                    ThongBaoVaDongModal("Thêm đồ uống thành công!", "modalThemDoUong");

                ResetFormDoUong();
            }
            catch (Exception ex)
            {
                XoaFileVuaTai(tenFileMoi);

                ThongBaoVaMoModal("Không thể lưu đồ uống: " + ex.Message, "modalThemDoUong");
            }
        }

        private void ThemThamSoDoUong(
            SqlCommand cmd,
            string maDoUong,
            string tenDoUong,
            decimal giaBan,
            string hinhAnh,
            string moTa,
            string trangThai,
            string maDanhMuc)
        {
            cmd.Parameters.Add("@MaDoUong", SqlDbType.VarChar, 20).Value = maDoUong;
            cmd.Parameters.Add("@TenDoUong", SqlDbType.NVarChar, 100).Value = tenDoUong;

            SqlParameter gia = cmd.Parameters.Add("@GiaBan", SqlDbType.Decimal);
            gia.Precision = 18;
            gia.Scale = 2;
            gia.Value = giaBan;

            cmd.Parameters.Add("@HinhAnh", SqlDbType.VarChar, 255).Value =
                string.IsNullOrEmpty(hinhAnh) ? (object)DBNull.Value : hinhAnh;

            cmd.Parameters.Add("@MoTa", SqlDbType.NVarChar, -1).Value =
                string.IsNullOrEmpty(moTa) ? (object)DBNull.Value : moTa;

            cmd.Parameters.Add("@TrangThai", SqlDbType.VarChar, 30).Value = trangThai;
            cmd.Parameters.Add("@MaDanhMuc", SqlDbType.Int).Value = Convert.ToInt32(maDanhMuc);
        }

        private string LuuFileHinhAnh()
        {
            if (!fuHinhAnh.HasFile)
                return null;

            if (fuHinhAnh.PostedFile.ContentLength <= 0)
                throw new Exception("File hình ảnh không hợp lệ!");

            if (fuHinhAnh.PostedFile.ContentLength > 5 * 1024 * 1024)
                throw new Exception("Dung lượng hình ảnh không được vượt quá 5 MB!");

            string tenFileGoc = Path.GetFileName(fuHinhAnh.FileName);
            string duoiFile = Path.GetExtension(tenFileGoc).ToLowerInvariant();

            string[] dinhDangChoPhep = { ".jpg", ".jpeg", ".png", ".gif", ".webp" };

            if (Array.IndexOf(dinhDangChoPhep, duoiFile) < 0)
                throw new Exception("Chỉ cho phép ảnh JPG, JPEG, PNG, GIF hoặc WEBP!");

            string tenGoc = Path.GetFileNameWithoutExtension(tenFileGoc);

            foreach (char kyTu in Path.GetInvalidFileNameChars())
                tenGoc = tenGoc.Replace(kyTu, '_');

            if (string.IsNullOrWhiteSpace(tenGoc))
                tenGoc = "HinhAnh";

            if (tenGoc.Length > 100)
                tenGoc = tenGoc.Substring(0, 100);

            string tenFileLuu = tenGoc + duoiFile;
            string thuMuc = Server.MapPath("~/HinhAnh/");

            if (!Directory.Exists(thuMuc))
                Directory.CreateDirectory(thuMuc);

            string duongDan = Path.Combine(thuMuc, tenFileLuu);

            if (File.Exists(duongDan))
            {
                tenFileLuu = tenGoc + "_" + Guid.NewGuid().ToString("N") + duoiFile;
                duongDan = Path.Combine(thuMuc, tenFileLuu);
            }

            fuHinhAnh.SaveAs(duongDan);

            return tenFileLuu;
        }

        private void XoaFileVuaTai(string tenFile)
        {
            if (string.IsNullOrEmpty(tenFile))
                return;

            try
            {
                string duongDan = Server.MapPath("~/HinhAnh/" + tenFile);

                if (File.Exists(duongDan))
                    File.Delete(duongDan);
            }
            catch
            {
            }
        }

        private void ResetFormDoUong()
        {
            hfCheDo.Value = "Them";
            txtMaDoUong.Text = "";
            txtTenDoUong.Text = "";
            txtGiaBan.Text = "";
            txtMoTa.Text = "";
            txtMaDoUong.ReadOnly = false;

            if (ddlTrangThaiForm.Items.FindByValue("ConHang") != null)
                ddlTrangThaiForm.SelectedValue = "ConHang";

            if (ddlDanhMucForm.Items.Count > 0)
                ddlDanhMucForm.SelectedIndex = 0;
        }

        protected void rpDoUong_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string maDoUong = e.CommandArgument.ToString();

            if (e.CommandName == "Sua")
            {
                LoadDoUong(maDoUong);
            }
            else if (e.CommandName == "Xoa")
            {
                XoaDoUong(maDoUong);
            }
        }

        private void LoadDoUong(string maDoUong)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ChuoiKetNoi))
                {
                    string sql = @"
                        SELECT *
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
                                hfCheDo.Value = "Sua";

                                txtMaDoUong.Text = reader["MaDoUong"].ToString();
                                txtMaDoUong.ReadOnly = true;

                                txtTenDoUong.Text = reader["TenDoUong"].ToString();

                                txtGiaBan.Text = Convert.ToDecimal(reader["GiaBanHienTai"])
                                    .ToString("0.##", CultureInfo.InvariantCulture);

                                txtMoTa.Text = reader["MoTa"] == DBNull.Value
                                    ? ""
                                    : reader["MoTa"].ToString();

                                string maDanhMuc = reader["MaDanhMuc"].ToString();

                                if (ddlDanhMucForm.Items.FindByValue(maDanhMuc) != null)
                                    ddlDanhMucForm.SelectedValue = maDanhMuc;

                                string trangThai = reader["TrangThaiKinhDoanh"].ToString();

                                if (ddlTrangThaiForm.Items.FindByValue(trangThai) == null)
                                    ddlTrangThaiForm.Items.Add(new ListItem(trangThai, trangThai));

                                ddlTrangThaiForm.SelectedValue = trangThai;
                            }
                            else
                            {
                                ThongBao("Không tìm thấy đồ uống!");
                                return;
                            }
                        }
                    }
                }

                MoModal("modalThemDoUong");
            }
            catch (Exception ex)
            {
                ThongBao("Lỗi khi tải đồ uống: " + ex.Message);
            }
        }

        private void XoaDoUong(string maDoUong)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ChuoiKetNoi))
                {
                    conn.Open();

                    using (SqlTransaction tran = conn.BeginTransaction())
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

                            if (soGiaoDich > 0)
                            {
                                string sqlCapNhat = @"
                                    UPDATE dbo.douong
                                    SET TrangThaiKinhDoanh = 'NgungKinhDoanh'
                                    WHERE MaDoUong = @MaDoUong";

                                using (SqlCommand cmd = new SqlCommand(sqlCapNhat, conn, tran))
                                {
                                    cmd.Parameters.Add("@MaDoUong", SqlDbType.VarChar, 20).Value = maDoUong;
                                    cmd.ExecuteNonQuery();
                                }
                            }
                            else
                            {
                                string sqlXoa = "DELETE FROM dbo.douong WHERE MaDoUong = @MaDoUong";

                                using (SqlCommand cmd = new SqlCommand(sqlXoa, conn, tran))
                                {
                                    cmd.Parameters.Add("@MaDoUong", SqlDbType.VarChar, 20).Value = maDoUong;
                                    cmd.ExecuteNonQuery();
                                }
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

                ThongBao("Xử lý đồ uống thành công!");
            }
            catch (Exception ex)
            {
                ThongBao("Không thể xóa đồ uống: " + ex.Message);
            }
        }

        protected void rpDanhMuc_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            int maDanhMuc = Convert.ToInt32(e.CommandArgument);

            if (e.CommandName == "SuaDanhMuc")
            {
                LoadDanhMuc(maDanhMuc);
            }
            else if (e.CommandName == "XoaDanhMuc")
            {
                XoaDanhMuc(maDanhMuc);
            }
        }

        private void LoadDanhMuc(int maDanhMuc)
        {
            try
            {
                using (SqlConnection conn = new SqlConnection(ChuoiKetNoi))
                {
                    string sql = "SELECT TenDanhMuc FROM dbo.danhmuc WHERE MaDanhMuc = @MaDanhMuc";

                    using (SqlCommand cmd = new SqlCommand(sql, conn))
                    {
                        cmd.Parameters.Add("@MaDanhMuc", SqlDbType.Int).Value = maDanhMuc;

                        conn.Open();

                        object ketQua = cmd.ExecuteScalar();

                        if (ketQua == null)
                        {
                            ThongBao("Không tìm thấy danh mục!");
                            return;
                        }

                        hfMaDanhMuc.Value = maDanhMuc.ToString();
                        txtTenDanhMuc.Text = ketQua.ToString();
                        btnLuuDanhMuc.Text = "Cập nhật";
                    }
                }

                MoModal("modalDanhMuc");
            }
            catch (Exception ex)
            {
                ThongBao("Lỗi khi tải danh mục: " + ex.Message);
            }
        }

        protected void btnLuuDanhMuc_Click(object sender, EventArgs e)
        {
            string tenDanhMuc = txtTenDanhMuc.Text.Trim();

            if (tenDanhMuc == "")
            {
                ThongBaoVaMoModal("Vui lòng nhập tên danh mục!", "modalDanhMuc");
                return;
            }

            if (tenDanhMuc.Length > 100)
            {
                ThongBaoVaMoModal("Tên danh mục không được vượt quá 100 ký tự!", "modalDanhMuc");
                return;
            }

            try
            {
                using (SqlConnection conn = new SqlConnection(ChuoiKetNoi))
                {
                    conn.Open();

                    string maDanhMuc = hfMaDanhMuc.Value;

                    string sqlKiemTra = @"
                        SELECT COUNT(*)
                        FROM dbo.danhmuc
                        WHERE TenDanhMuc = @TenDanhMuc
                        AND (@MaDanhMuc = 0 OR MaDanhMuc <> @MaDanhMuc)";

                    using (SqlCommand cmd = new SqlCommand(sqlKiemTra, conn))
                    {
                        cmd.Parameters.Add("@TenDanhMuc", SqlDbType.NVarChar, 100).Value = tenDanhMuc;
                        cmd.Parameters.Add("@MaDanhMuc", SqlDbType.Int).Value =
                            string.IsNullOrEmpty(maDanhMuc) ? 0 : Convert.ToInt32(maDanhMuc);

                        int soLuong = Convert.ToInt32(cmd.ExecuteScalar());

                        if (soLuong > 0)
                        {
                            ThongBaoVaMoModal("Tên danh mục đã tồn tại!", "modalDanhMuc");
                            return;
                        }
                    }

                    if (string.IsNullOrEmpty(maDanhMuc))
                    {
                        string sqlThem = @"
                            INSERT INTO dbo.danhmuc (TenDanhMuc, MoTa)
                            VALUES (@TenDanhMuc, NULL)";

                        using (SqlCommand cmd = new SqlCommand(sqlThem, conn))
                        {
                            cmd.Parameters.Add("@TenDanhMuc", SqlDbType.NVarChar, 100).Value = tenDanhMuc;
                            cmd.ExecuteNonQuery();
                        }
                    }
                    else
                    {
                        string sqlSua = @"
                            UPDATE dbo.danhmuc
                            SET TenDanhMuc = @TenDanhMuc
                            WHERE MaDanhMuc = @MaDanhMuc";

                        using (SqlCommand cmd = new SqlCommand(sqlSua, conn))
                        {
                            cmd.Parameters.Add("@TenDanhMuc", SqlDbType.NVarChar, 100).Value = tenDanhMuc;
                            cmd.Parameters.Add("@MaDanhMuc", SqlDbType.Int).Value = Convert.ToInt32(maDanhMuc);
                            cmd.ExecuteNonQuery();
                        }
                    }
                }

                ResetFormDanhMuc();
                LamMoiDanhMuc();

                ThongBaoVaMoModal("Lưu danh mục thành công!", "modalDanhMuc");
            }
            catch (Exception ex)
            {
                ThongBaoVaMoModal("Không thể lưu danh mục: " + ex.Message, "modalDanhMuc");
            }
        }

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
                            string sqlDem = @"
                                SELECT COUNT(*)
                                FROM dbo.douong
                                WHERE MaDanhMuc = @MaDanhMuc";

                            int soMon;

                            using (SqlCommand cmd = new SqlCommand(sqlDem, conn, tran))
                            {
                                cmd.Parameters.Add("@MaDanhMuc", SqlDbType.Int).Value = maDanhMuc;
                                soMon = Convert.ToInt32(cmd.ExecuteScalar());
                            }

                            if (soMon > 0)
                            {
                                tran.Commit();

                                ThongBaoVaMoModal(
                                    "Không thể xóa danh mục vì bên trong vẫn còn " + soMon + " đồ uống!",
                                    "modalDanhMuc");

                                return;
                            }

                            string sqlXoa = "DELETE FROM dbo.danhmuc WHERE MaDanhMuc = @MaDanhMuc";

                            using (SqlCommand cmd = new SqlCommand(sqlXoa, conn, tran))
                            {
                                cmd.Parameters.Add("@MaDanhMuc", SqlDbType.Int).Value = maDanhMuc;
                                cmd.ExecuteNonQuery();
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

                LamMoiDanhMuc();

                ThongBaoVaMoModal("Xóa danh mục thành công!", "modalDanhMuc");
            }
            catch (Exception ex)
            {
                ThongBaoVaMoModal("Không thể xóa danh mục: " + ex.Message, "modalDanhMuc");
            }
        }

        private void ResetFormDanhMuc()
        {
            hfMaDanhMuc.Value = "";
            txtTenDanhMuc.Text = "";
            btnLuuDanhMuc.Text = "Thêm";
        }

        private void LamMoiDanhMuc()
        {
            string danhMucLoc = ddlDanhMucLoc.SelectedValue;
            string danhMucForm = ddlDanhMucForm.SelectedValue;

            NapDanhMucDropdowns(danhMucLoc, danhMucForm);

            LamMoiDanhSach();
        }

        private void LamMoiDanhSach()
        {
            rpDoUong.DataBind();
            rpTongDoUong.DataBind();
            lvMenuConHang.DataBind();
            rpDanhMuc.DataBind();
        }

        private void ThongBao(string noiDung)
        {
            string script = "alert('" + HttpUtility.JavaScriptStringEncode(noiDung) + "');";

            ClientScript.RegisterStartupScript(
                GetType(),
                Guid.NewGuid().ToString(),
                script,
                true);
        }

        private void ThongBaoVaMoModal(string noiDung, string idModal)
        {
            string thongBao = HttpUtility.JavaScriptStringEncode(noiDung);

            string script = @"
                alert('" + thongBao + @"');
                window.addEventListener('load', function () {
                    var modal = document.getElementById('" + idModal + @"');
                    if (modal && window.bootstrap) {
                        bootstrap.Modal.getOrCreateInstance(modal).show();
                    }
                });";

            ClientScript.RegisterStartupScript(
                GetType(),
                Guid.NewGuid().ToString(),
                script,
                true);
        }

        private void ThongBaoVaDongModal(string noiDung, string idModal)
        {
            string thongBao = HttpUtility.JavaScriptStringEncode(noiDung);

            string script = @"
                alert('" + thongBao + @"');
                window.addEventListener('load', function () {
                    var modal = document.getElementById('" + idModal + @"');
                    if (modal && window.bootstrap) {
                        bootstrap.Modal.getOrCreateInstance(modal).hide();
                    }
                });";

            ClientScript.RegisterStartupScript(
                GetType(),
                Guid.NewGuid().ToString(),
                script,
                true);
        }

        private void MoModal(string idModal)
        {
            string script = @"
                window.addEventListener('load', function () {
                    var modal = document.getElementById('" + idModal + @"');
                    if (modal && window.bootstrap) {
                        bootstrap.Modal.getOrCreateInstance(modal).show();
                    }
                });";

            ClientScript.RegisterStartupScript(
                GetType(),
                Guid.NewGuid().ToString(),
                script,
                true);
        }
    }
}
