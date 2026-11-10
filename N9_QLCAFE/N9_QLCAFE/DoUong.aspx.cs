
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

        protected void Page_Load(object sender, EventArgs e)
        {
        }

        // Xử lý nút Chỉnh sửa và Xóa trong bảng
        protected void rpDoUong_ItemCommand(object source, RepeaterCommandEventArgs e)
        {
            string maDoUong = Convert.ToString(e.CommandArgument);

            if (string.IsNullOrWhiteSpace(maDoUong))
                return;

            if (e.CommandName == "Sua")
            {
                LoadDoUong(maDoUong);
            }
            else if (e.CommandName == "Xoa")
            {
                XoaDoUong(maDoUong);
            }
        }

        // Lấy thông tin đồ uống để đưa vào Modal chỉnh sửa
        private void LoadDoUong(string maDoUong)
        {
            ddlDanhMucForm.DataBind();

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

                            decimal gia = Convert.ToDecimal(reader["GiaBanHienTai"]);
                            txtGiaBan.Text = gia.ToString(CultureInfo.InvariantCulture);

                            txtMoTa.Text = reader["MoTa"] == DBNull.Value
                                ? ""
                                : reader["MoTa"].ToString();

                            string maDanhMuc = reader["MaDanhMuc"].ToString();
                            string trangThai = reader["TrangThaiKinhDoanh"].ToString();

                            if (ddlDanhMucForm.Items.FindByValue(maDanhMuc) != null)
                                ddlDanhMucForm.SelectedValue = maDanhMuc;

                            if (ddlTrangThaiForm.Items.FindByValue(trangThai) == null)
                                ddlTrangThaiForm.Items.Add(new ListItem(trangThai, trangThai));

                            ddlTrangThaiForm.SelectedValue = trangThai;

                            hfCheDo.Value = "Sua";
                            txtMaDoUong.ReadOnly = true;

                            MoModal();
                        }
                        else
                        {
                            ThongBao("Không tìm thấy đồ uống cần chỉnh sửa.");
                        }
                    }
                }
            }
        }

        // Lưu thông tin thêm mới hoặc chỉnh sửa đồ uống
        protected void btnLuuDoUong_Click(object sender, EventArgs e)
        {
            string maDoUong = txtMaDoUong.Text.Trim();
            string tenDoUong = txtTenDoUong.Text.Trim();
            string moTa = txtMoTa.Text.Trim();

            decimal giaBan;
            int maDanhMuc;

            if (string.IsNullOrWhiteSpace(maDoUong) ||
                string.IsNullOrWhiteSpace(tenDoUong))
            {
                ThongBao("Vui lòng nhập mã và tên đồ uống.");
                MoModal();
                return;
            }

            if (!decimal.TryParse(txtGiaBan.Text.Trim(),
                NumberStyles.Number, CultureInfo.InvariantCulture, out giaBan)
                || giaBan <= 0)
            {
                ThongBao("Giá bán phải là số lớn hơn 0.");
                MoModal();
                return;
            }

            if (!int.TryParse(ddlDanhMucForm.SelectedValue, out maDanhMuc))
            {
                ThongBao("Vui lòng chọn danh mục đồ uống.");
                MoModal();
                return;
            }

            string trangThai = ddlTrangThaiForm.SelectedValue;

            try
            {
                using (SqlConnection conn = new SqlConnection(ChuoiKetNoi))
                {
                    conn.Open();

                    string sql;

                    if (hfCheDo.Value == "Sua")
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
                        cmd.Parameters.Add("@MaDoUong", SqlDbType.VarChar, 20).Value = maDoUong;

                        cmd.Parameters.Add("@TenDoUong", SqlDbType.NVarChar, 100).Value = tenDoUong;

                        SqlParameter pGia = cmd.Parameters.Add("@GiaBan", SqlDbType.Decimal);
                        pGia.Precision = 18;
                        pGia.Scale = 2;
                        pGia.Value = giaBan;

                        cmd.Parameters.Add("@MoTa", SqlDbType.NVarChar, -1).Value =
                            string.IsNullOrWhiteSpace(moTa) ? (object)DBNull.Value : moTa;

                        cmd.Parameters.Add("@TrangThai", SqlDbType.VarChar, 30).Value = trangThai;

                        cmd.Parameters.Add("@MaDanhMuc", SqlDbType.Int).Value = maDanhMuc;

                        int ketQua = cmd.ExecuteNonQuery();

                        if (ketQua == 0)
                        {
                            ThongBao("Không tìm thấy đồ uống cần cập nhật.");
                            return;
                        }
                    }
                }

                bool dangSua = hfCheDo.Value == "Sua";

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
                    ThongBao("Mã đồ uống đã tồn tại. Vui lòng sử dụng mã khác.");
                else
                    ThongBao("Không thể lưu đồ uống. Lỗi: " + ex.Message);
            }
            catch (Exception ex)
            {
                ThongBao("Có lỗi khi lưu đồ uống: " + ex.Message);
            }
        }

        // Xóa đồ uống hoặc chuyển sang Ngừng kinh doanh nếu đã có giao dịch
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

                            string sqlXuLy;

                            if (soGiaoDich > 0)
                            {
                                sqlXuLy = @"
                                    UPDATE dbo.douong
                                    SET TrangThaiKinhDoanh = 'NgungKinhDoanh'
                                    WHERE MaDoUong = @MaDoUong";

                                thongBao = "Đồ uống đã có giao dịch nên không thể xóa hoàn toàn. Hệ thống đã chuyển sang Ngừng kinh doanh.";
                            }
                            else
                            {
                                sqlXuLy = @"
                                    DELETE FROM dbo.douong
                                    WHERE MaDoUong = @MaDoUong";

                                thongBao = "Xóa đồ uống thành công.";
                            }

                            using (SqlCommand cmd = new SqlCommand(sqlXuLy, conn, tran))
                            {
                                cmd.Parameters.Add("@MaDoUong", SqlDbType.VarChar, 20).Value = maDoUong;

                                if (cmd.ExecuteNonQuery() == 0)
                                    throw new Exception("Không tìm thấy đồ uống cần xóa.");
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
                ThongBao("Không thể xóa đồ uống. Lỗi: " + ex.Message);
            }
        }

        // Tải lại bảng, tổng số sản phẩm và Menu
        private void LamMoiDanhSach()
        {
            rpDoUong.DataBind();
            rpTongDoUong.DataBind();
            lvMenuConHang.DataBind();
        }

        // Mở lại Modal sau khi chọn chỉnh sửa hoặc có lỗi nhập liệu
        private void MoModal()
        {
            string script = @"
                window.addEventListener('load', function () {
                    var modalElement = document.getElementById('modalThemDoUong');
                    if (modalElement && window.bootstrap) {
                        bootstrap.Modal.getOrCreateInstance(modalElement).show();
                    }
                });";

            Page.ClientScript.RegisterStartupScript(
                GetType(), "MoModalDoUong", script, true);
        }

        // Hiển thị thông báo
        private void ThongBao(string noiDung)
        {
            string noiDungAnToan = HttpUtility.JavaScriptStringEncode(noiDung);

            string script = "alert('" + noiDungAnToan + "');";

            Page.ClientScript.RegisterStartupScript(
                GetType(),
                "ThongBao" + Guid.NewGuid().ToString("N"),
                script,
                true);
        }
    }
}
