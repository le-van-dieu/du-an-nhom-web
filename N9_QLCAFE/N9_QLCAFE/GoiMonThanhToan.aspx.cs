using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace N9_QLCAFE
{
    public partial class GoiMonThanhToan : Page
    {
        private string DraftId { get { if (ViewState["DraftId"] == null) ViewState["DraftId"] = "DH" + Guid.NewGuid().ToString("N").Substring(0,28); return (string)ViewState["DraftId"]; } }
        private string OrderId { get { return ViewState["OrderId"] as string; } set { ViewState["OrderId"] = value; } }
        private DataTable Basket {
            get {
                var table = ViewState["Basket"] as DataTable;
                if (table == null) {
                    table = new DataTable();
                    table.Columns.Add("MaDoUong"); table.Columns.Add("TenDoUong");
                    table.Columns.Add("SoLuong", typeof(int)); table.Columns.Add("DonGiaTaiThoiDiemGoi", typeof(decimal));
                    table.Columns.Add("GhiChuMon"); table.Columns.Add("ThanhTien", typeof(decimal));
                    ViewState["Basket"] = table;
                }
                return table;
            }
        }
        private SqlConnection Connect() {
            var setting = ConfigurationManager.ConnectionStrings["quanlyquancafeConnectionString"];
            if (setting == null) throw new InvalidOperationException("Thiếu cấu hình kết nối quanlyquancafeConnectionString.");
            var c = new SqlConnection(setting.ConnectionString); c.Open(); return c;
        }
        private static SqlCommand Command(SqlConnection c, SqlTransaction tx, string sql, params object[] args) {
            var cmd = new SqlCommand(sql, c, tx);
            for (int i = 0; i < args.Length; i++) cmd.Parameters.AddWithValue("@p" + i, args[i] ?? DBNull.Value);
            return cmd;
        }
        private DataTable Query(string sql, params object[] args) {
            using (var c = Connect()) using (var cmd = Command(c, null, sql, args)) {
                var dt = new DataTable(); using (var reader = cmd.ExecuteReader()) dt.Load(reader); return dt;
            }
        }
        private void Run(Action action) {
            try { action(); }
            catch (InvalidOperationException ex) { Message.Text = HttpUtility.HtmlEncode(ex.Message); Message.CssClass = "alert alert-warning d-block"; }
            catch (SqlException ex) { Trace.Warn("POS", "SQL operation failed", ex); Message.Text = "Không thể hoàn tất giao dịch. Vui lòng kiểm tra kết nối CSDL và tải lại đơn trước khi thử lại."; Message.CssClass = "alert alert-danger d-block"; }
        }
        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            // Persist a session value so ASP.NET issues the session cookie on the first GET.
            // An empty session may get a different SessionID on the next postback.
            const string key = "POS.ViewStateKey";
            if (Session[key] == null) Session[key] = Guid.NewGuid().ToString("N");
            ViewStateUserKey = (string)Session[key];
        }
        protected void Page_Load(object sender, EventArgs e) {
            if (!IsPostBack) Run(delegate {
                Staff.DataSource = Query("SELECT MaNhanVien,HoTen FROM nhanvien WHERE TrangThaiLamViec='DangLamViec' ORDER BY HoTen");
                Staff.DataValueField = "MaNhanVien"; Staff.DataTextField = "HoTen"; Staff.DataBind(); Staff.Items.Insert(0, new ListItem("-- Chọn nhân viên --", ""));
                TableChoice.DataSource = Query("SELECT MaBan,TenBan + N' (' + TrangThai + N')' AS TenBan FROM banan ORDER BY MaBan");
                TableChoice.DataValueField = "MaBan"; TableChoice.DataTextField = "TenBan"; TableChoice.DataBind(); TableChoice.Items.Insert(0, new ListItem("-- Chọn bàn --", "")); TableChoice.Items.Insert(1, new ListItem("Mang đi", "takeaway"));
                Category.DataSource = Query("SELECT MaDanhMuc,TenDanhMuc FROM danhmuc ORDER BY TenDanhMuc"); Category.DataValueField = "MaDanhMuc"; Category.DataTextField = "TenDanhMuc"; Category.DataBind(); Category.Items.Insert(0, new ListItem("Tất cả danh mục", ""));
                BindMenu(); BindHistory(); BindCart();
            });
        }
        private void BindMenu() {
            var dt = Query("SELECT MaDoUong,TenDoUong,GiaBanHienTai FROM douong WHERE TrangThaiKinhDoanh='ConHang' AND (@p0='' OR TenDoUong LIKE N'%' + @p0 + '%' OR MaDoUong LIKE '%' + @p0 + '%') AND (@p1='' OR CONVERT(varchar,MaDanhMuc)=@p1) ORDER BY TenDoUong", Search.Text.Trim(), Category.SelectedValue);
            Menu.DataSource = dt; Menu.DataBind(); EmptyMenu.Text = dt.Rows.Count == 0 ? "Không có đồ uống còn hàng phù hợp." : "";
        }
        private void BindHistory() {
            DateTime day; object date = null;
            if (!string.IsNullOrEmpty(HistoryDate.Text)) { if (!DateTime.TryParseExact(HistoryDate.Text, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out day)) throw new InvalidOperationException("Ngày tra cứu không hợp lệ."); date = day; }
            History.DataSource = Query("SELECT TOP (200) d.MaDonHang,COALESCE(b.TenBan,N'Mang đi') TenBan,d.TrangThaiDon,h.MaHoaDon,h.NgayGioThanhToan,h.TienPhaiTra,h.PhuongThucThanhToan FROM donhang d LEFT JOIN banan b ON b.MaBan=d.MaBan LEFT JOIN hoadon h ON h.MaDonHang=d.MaDonHang WHERE (@p0='' OR d.MaDonHang LIKE '%' + @p0 + '%' OR h.MaHoaDon LIKE '%' + @p0 + '%') AND (@p1 IS NULL OR COALESCE(h.NgayGioThanhToan,d.ThoiGianTao)>=@p1 AND COALESCE(h.NgayGioThanhToan,d.ThoiGianTao)<DATEADD(day,1,@p1)) ORDER BY d.ThoiGianTao DESC", HistorySearch.Text.Trim(), date); History.DataBind();
        }
        private decimal Total { get { return Basket.AsEnumerable().Sum(r => r.Field<decimal>("ThanhTien")); } }
        private void BindCart() { Cart.DataSource = Basket; Cart.DataBind(); Subtotal.Text = Total.ToString("N0") + " đ"; OrderLabel.Text = HttpUtility.HtmlEncode(OrderId ?? "Chưa lưu"); var draft = DraftId; ConfirmPanel.Visible = false; }
        private void Capture() {
            for (int i = 0; i < Cart.Rows.Count; i++) {
                int quantity; var row = Cart.Rows[i];
                if (!int.TryParse(((TextBox)row.FindControl("Quantity")).Text, out quantity) || quantity < 1 || quantity > 999) throw new InvalidOperationException("Số lượng phải từ 1 đến 999.");
                string note = ((TextBox)row.FindControl("Note")).Text.Trim(); if (note.Length > 255) throw new InvalidOperationException("Ghi chú tối đa 255 ký tự.");
            }
            for (int i = 0; i < Cart.Rows.Count; i++) { var r = Basket.Rows[i]; r["SoLuong"] = int.Parse(((TextBox)Cart.Rows[i].FindControl("Quantity")).Text); r["GhiChuMon"] = ((TextBox)Cart.Rows[i].FindControl("Note")).Text.Trim(); r["ThanhTien"] = (int)r["SoLuong"] * (decimal)r["DonGiaTaiThoiDiemGoi"]; }
        }
        protected void Filter(object sender, EventArgs e) { Run(delegate { Capture(); BindMenu(); BindHistory(); BindCart(); }); }
        protected void AddDrink(object sender, RepeaterCommandEventArgs e) { Run(delegate {
            Capture(); var dt = Query("SELECT MaDoUong,TenDoUong,GiaBanHienTai FROM douong WHERE MaDoUong=@p0 AND TrangThaiKinhDoanh='ConHang'", e.CommandArgument.ToString());
            if (dt.Rows.Count != 1) throw new InvalidOperationException("Món đã hết hàng hoặc ngừng kinh doanh.");
            var found = Basket.AsEnumerable().FirstOrDefault(r => (string)r["MaDoUong"] == e.CommandArgument.ToString());
            if (found == null) { var d = dt.Rows[0]; Basket.Rows.Add(d["MaDoUong"], d["TenDoUong"], 1, d["GiaBanHienTai"], "", d["GiaBanHienTai"]); }
            else { if ((int)found["SoLuong"] >= 999) throw new InvalidOperationException("Số lượng tối đa 999."); found["SoLuong"] = (int)found["SoLuong"] + 1; found["ThanhTien"] = (int)found["SoLuong"] * (decimal)found["DonGiaTaiThoiDiemGoi"]; }
            BindCart();
        }); }
        protected void CartCommand(object sender, GridViewCommandEventArgs e) { if (e.CommandName == "RemoveDrink") Run(delegate { Capture(); var row = Basket.AsEnumerable().First(r => (string)r["MaDoUong"] == e.CommandArgument.ToString()); Basket.Rows.Remove(row); BindCart(); }); }
        protected void UpdateCart(object sender, EventArgs e) { Run(delegate { Capture(); BindCart(); }); }
        protected void NewOrder(object sender, EventArgs e) { OrderId = null; ViewState["DraftId"] = null; ViewState["Basket"] = null; TableChoice.SelectedIndex = 0; Discount.Text = "0"; TransferConfirmed.Checked = false; ReceiptPanel.Visible = false; BindCart(); }
        private string Actor(SqlConnection c, SqlTransaction tx) {
            string id = Session["MaNhanVien"] as string;
            if (string.IsNullOrEmpty(id)) id = Staff.SelectedValue;
            if (string.IsNullOrEmpty(id) || Convert.ToInt32(Command(c, tx, "SELECT COUNT(*) FROM nhanvien WHERE MaNhanVien=@p0 AND TrangThaiLamViec='DangLamViec'", id).ExecuteScalar()) != 1) throw new InvalidOperationException("Chọn nhân viên đang làm việc để ghi nhận giao dịch.");
            return id;
        }
        private string Snapshot(SqlConnection c, SqlTransaction tx, string id) { return Convert.ToString(Command(c, tx, "SELECT d.MaBan,d.TrangThaiDon,c.MaDoUong,c.SoLuong,c.DonGiaTaiThoiDiemGoi,c.GhiChuMon,c.ThanhTien FROM donhang d LEFT JOIN chitietdonhang c ON c.MaDonHang=d.MaDonHang WHERE d.MaDonHang=@p0 ORDER BY c.MaDoUong FOR XML PATH('r'),ROOT('order')", id).ExecuteScalar()); }
        private void LockOrder(SqlConnection c, SqlTransaction tx, string id) {
            object status = Command(c, tx, "SELECT TrangThaiDon FROM donhang WITH (UPDLOCK,HOLDLOCK) WHERE MaDonHang=@p0", id).ExecuteScalar();
            if (status == null || Convert.ToString(status) != "DangPhucVu" || Convert.ToInt32(Command(c, tx, "SELECT COUNT(*) FROM hoadon WHERE MaDonHang=@p0", id).ExecuteScalar()) != 0) throw new InvalidOperationException("Đơn không tồn tại hoặc đã hoàn tất. Không được sửa hay thanh toán lại.");
        }
        private void ReleaseTable(SqlConnection c, SqlTransaction tx, object id) {
            if (id == null || id == DBNull.Value) return;
            Command(c, tx, "UPDATE banan SET TrangThai='Trong' WHERE MaBan=@p0 AND TrangThai='DangPhucVu' AND NOT EXISTS(SELECT 1 FROM donhang WHERE MaBan=@p0 AND TrangThaiDon='DangPhucVu')", id).ExecuteNonQuery();
        }
        private string Persist(SqlConnection c, SqlTransaction tx) {
            string actor = Actor(c, tx);
            if (Basket.Rows.Count == 0) throw new InvalidOperationException("Đơn phải có ít nhất một món.");
            int number; object table = null;
            if (TableChoice.SelectedValue != "takeaway") { if (!int.TryParse(TableChoice.SelectedValue, out number)) throw new InvalidOperationException("Chọn bàn phục vụ hoặc mang đi."); table = number; }
            string id = OrderId ?? DraftId; object oldTable = null;
            if (OrderId == null && Command(c, tx, "SELECT MaDonHang FROM donhang WITH(UPDLOCK,HOLDLOCK) WHERE MaDonHang=@p0", id).ExecuteScalar() != null) throw new InvalidOperationException("Yêu cầu này đã được lưu. Hãy mở lại đơn từ lịch sử.");
            if (OrderId != null) { LockOrder(c, tx, id); if ((string)ViewState["Snapshot"] != Snapshot(c, tx, id)) throw new InvalidOperationException("Đơn đã được cập nhật ở nơi khác. Mở lại đơn để tránh ghi đè."); oldTable = Command(c, tx, "SELECT MaBan FROM donhang WHERE MaDonHang=@p0", id).ExecuteScalar(); }
            if (table != null) {
                object state = Command(c, tx, "SELECT TrangThai FROM banan WITH(UPDLOCK,HOLDLOCK) WHERE MaBan=@p0", table).ExecuteScalar();
                bool same = oldTable != null && oldTable != DBNull.Value && Convert.ToInt32(oldTable) == (int)table;
                if (state == null || (!same && Convert.ToString(state) != "Trong")) throw new InvalidOperationException("Bàn không trống hoặc đang được đặt trước. Chọn bàn khác.");
                if (Convert.ToInt32(Command(c, tx, "SELECT COUNT(*) FROM donhang WHERE MaBan=@p0 AND TrangThaiDon='DangPhucVu' AND MaDonHang<>@p1", table, id).ExecuteScalar()) > 0) throw new InvalidOperationException("Bàn đã có đơn đang phục vụ. Mở đơn đó để tiếp tục.");
            }
            var existing = new DataTable();
            if (OrderId != null) using (var reader = Command(c, tx, "SELECT MaDoUong,SoLuong,DonGiaTaiThoiDiemGoi FROM chitietdonhang WHERE MaDonHang=@p0", id).ExecuteReader()) existing.Load(reader);
            foreach (DataRow r in Basket.Rows) {
                var previous = existing.AsEnumerable().FirstOrDefault(x => (string)x["MaDoUong"] == (string)r["MaDoUong"]);
                if (previous == null || (int)r["SoLuong"] > (int)previous["SoLuong"]) {
                    if (Convert.ToInt32(Command(c, tx, "SELECT COUNT(*) FROM douong WITH(HOLDLOCK) WHERE MaDoUong=@p0 AND TrangThaiKinhDoanh='ConHang'", r["MaDoUong"]).ExecuteScalar()) != 1) throw new InvalidOperationException("Món " + r["TenDoUong"] + " đã hết hàng hoặc ngừng kinh doanh.");
                }
                if (previous != null) r["DonGiaTaiThoiDiemGoi"] = previous["DonGiaTaiThoiDiemGoi"];
                r["ThanhTien"] = (int)r["SoLuong"] * (decimal)r["DonGiaTaiThoiDiemGoi"];
            }
            if (OrderId == null) Command(c, tx, "INSERT donhang(MaDonHang,LoaiDon,TrangThaiDon,MaBan,MaNhanVienTao) VALUES(@p0,@p1,'DangPhucVu',@p2,@p3)", id, table == null ? "MangDi" : "TaiCho", table, actor).ExecuteNonQuery();
            else Command(c, tx, "UPDATE donhang SET MaBan=@p0,LoaiDon=@p1 WHERE MaDonHang=@p2", table, table == null ? "MangDi" : "TaiCho", id).ExecuteNonQuery();
            Command(c, tx, "DELETE chitietdonhang WHERE MaDonHang=@p0", id).ExecuteNonQuery();
            foreach (DataRow r in Basket.Rows) Command(c, tx, "INSERT chitietdonhang(MaDonHang,MaDoUong,SoLuong,DonGiaTaiThoiDiemGoi,GhiChuMon,ThanhTien) VALUES(@p0,@p1,@p2,@p3,@p4,@p5)", id, r["MaDoUong"], r["SoLuong"], r["DonGiaTaiThoiDiemGoi"], r["GhiChuMon"], r["ThanhTien"]).ExecuteNonQuery();
            if (table != null) Command(c, tx, "UPDATE banan SET TrangThai='DangPhucVu' WHERE MaBan=@p0", table).ExecuteNonQuery();
            if (!object.Equals(oldTable, table)) ReleaseTable(c, tx, oldTable);
            return id;
        }
        protected void Save(object sender, EventArgs e) { Run(delegate { Capture(); using (var c = Connect()) using (var tx = c.BeginTransaction(IsolationLevel.Serializable)) { string id = Persist(c, tx); string snapshot = Snapshot(c, tx, id); tx.Commit(); OrderId = id; ViewState["Snapshot"] = snapshot; } BindCart(); BindHistory(); Message.Text = "Đã lưu đơn và cập nhật bàn."; }); }
        private decimal ValidDiscount(SqlConnection c, SqlTransaction tx) {
            decimal value; if (!decimal.TryParse(Discount.Text, NumberStyles.AllowDecimalPoint, CultureInfo.InvariantCulture, out value) || value < 0 || value > Total || decimal.Round(value, 2) != value) throw new InvalidOperationException("Giảm giá phải từ 0 đến tổng tiền, tối đa 2 chữ số thập phân.");
            if (value > 0) {
                string user = Session["MaNhanVien"] as string;
                if (string.IsNullOrEmpty(user) || Convert.ToInt32(Command(c, tx, "SELECT COUNT(*) FROM taikhoan WHERE MaNhanVien=@p0 AND TrangThaiKhoa=0 AND VaiTro IN ('Admin','QuanLy')", user).ExecuteScalar()) == 0) throw new InvalidOperationException("Chỉ Admin / Quản lý đã đăng nhập mới được giảm giá. Trang đăng nhập hiện chưa tích hợp: để giảm giá bằng 0.");
            }
            return value;
        }
        protected void Preview(object sender, EventArgs e) { Run(delegate { Capture(); if (Basket.Rows.Count == 0) throw new InvalidOperationException("Chưa có món để thanh toán."); using (var c = Connect()) { decimal discount = ValidDiscount(c, null); BindCart(); PaymentSummary.Text = "Tổng tiền: " + Total.ToString("N0") + " đ; giảm: " + discount.ToString("N0") + " đ; phải thu: " + (Total-discount).ToString("N0") + " đ."; ConfirmPanel.Visible = true; } }); }
        protected void Checkout(object sender, EventArgs e) { Run(delegate {
            Capture(); if (Payment.SelectedValue != "TienMat" && Payment.SelectedValue != "ChuyenKhoan") throw new InvalidOperationException("Phương thức thanh toán không hợp lệ.");
            if (Payment.SelectedValue == "ChuyenKhoan" && !TransferConfirmed.Checked) throw new InvalidOperationException("Cần xác nhận đã nhận đủ tiền chuyển khoản.");
            string id;
            using (var c = Connect()) using (var tx = c.BeginTransaction(IsolationLevel.Serializable)) {
                // Saving and payment share one transaction; the order lock prevents double payment.
                id = Persist(c, tx); decimal discount = ValidDiscount(c, tx); string actor = Actor(c, tx);
                Command(c, tx, "INSERT hoadon(MaHoaDon,TongTienMon,GiamGia,TienPhaiTra,PhuongThucThanhToan,MaDonHang,MaNhanVienThuNgan) VALUES(@p0,@p1,@p2,@p3,@p4,@p5,@p6)", "HD" + Guid.NewGuid().ToString("N").Substring(0,28), Total, discount, Total-discount, Payment.SelectedValue, id, actor).ExecuteNonQuery();
                Command(c, tx, "UPDATE donhang SET TrangThaiDon='DaThanhToan' WHERE MaDonHang=@p0", id).ExecuteNonQuery();
                ReleaseTable(c, tx, Command(c, tx, "SELECT MaBan FROM donhang WHERE MaDonHang=@p0", id).ExecuteScalar()); tx.Commit();
            }
            OrderId = id; ViewState["Basket"] = null; BindCart(); BindHistory(); ShowReceipt(id); Message.Text = "Đã thanh toán thành công. Hóa đơn được lưu và đơn đã khóa.";
        }); }
        protected void OpenOrder(object sender, GridViewCommandEventArgs e) { if (e.CommandName != "Open") return; Run(delegate {
            string id = e.CommandArgument.ToString();
            using (var c = Connect()) using (var tx = c.BeginTransaction(IsolationLevel.Serializable)) {
                var orders = new DataTable();
                using (var reader = Command(c, tx, "SELECT * FROM donhang WITH(UPDLOCK,HOLDLOCK) WHERE MaDonHang=@p0", id).ExecuteReader()) orders.Load(reader);
                if (orders.Rows.Count != 1) throw new InvalidOperationException("Đơn không tồn tại.");
                if (Convert.ToString(orders.Rows[0]["TrangThaiDon"]) != "DangPhucVu") { tx.Commit(); ShowReceipt(id); return; }
                LockOrder(c, tx, id);
                var basket = new DataTable();
                using (var reader = Command(c, tx, "SELECT ct.MaDoUong,du.TenDoUong,ct.SoLuong,ct.DonGiaTaiThoiDiemGoi,COALESCE(ct.GhiChuMon,N'') GhiChuMon,ct.ThanhTien FROM chitietdonhang ct JOIN douong du ON du.MaDoUong=ct.MaDoUong WHERE ct.MaDonHang=@p0 ORDER BY ct.MaDoUong", id).ExecuteReader()) basket.Load(reader);
                string snapshot = Snapshot(c, tx, id); tx.Commit();
                var d = orders.Rows[0]; OrderId = id; ViewState["Snapshot"] = snapshot; ViewState["Basket"] = basket;
                TableChoice.SelectedValue = d["MaBan"] == DBNull.Value ? "takeaway" : Convert.ToString(d["MaBan"]);
            }
            Discount.Text = "0"; TransferConfirmed.Checked = false; ReceiptPanel.Visible = false; BindCart();
        }); }
        private void ShowReceipt(string id) {
            var headers = Query("SELECT h.*,COALESCE(b.TenBan,N'Mang đi') TenBan,n.HoTen FROM hoadon h JOIN donhang d ON d.MaDonHang=h.MaDonHang LEFT JOIN banan b ON b.MaBan=d.MaBan JOIN nhanvien n ON n.MaNhanVien=h.MaNhanVienThuNgan WHERE h.MaDonHang=@p0", id);
            if (headers.Rows.Count == 0) throw new InvalidOperationException("Đơn chưa có hóa đơn thanh toán.");
            var h = headers.Rows[0]; var sb = new StringBuilder();
            sb.Append("<p>Hóa đơn: " + HttpUtility.HtmlEncode(h["MaHoaDon"]) + "<br/>Đơn: " + HttpUtility.HtmlEncode(id) + "<br/>Bàn: " + HttpUtility.HtmlEncode(h["TenBan"]) + "<br/>Thu ngân: " + HttpUtility.HtmlEncode(h["HoTen"]) + "<br/>Thời gian: " + ((DateTime)h["NgayGioThanhToan"]).ToString("dd/MM/yyyy HH:mm") + "</p><table class='table'><tr><th>Món</th><th>SL</th><th>Đơn giá</th><th>Thành tiền</th></tr>");
            foreach (DataRow r in Query("SELECT d.TenDoUong,c.* FROM chitietdonhang c JOIN douong d ON d.MaDoUong=c.MaDoUong WHERE c.MaDonHang=@p0", id).Rows) sb.Append("<tr><td>" + HttpUtility.HtmlEncode(r["TenDoUong"]) + "<br/>" + HttpUtility.HtmlEncode(r["GhiChuMon"]) + "</td><td>" + r["SoLuong"] + "</td><td>" + ((decimal)r["DonGiaTaiThoiDiemGoi"]).ToString("N0") + "</td><td>" + ((decimal)r["ThanhTien"]).ToString("N0") + "</td></tr>");
            sb.Append("</table><p>Tổng món: " + ((decimal)h["TongTienMon"]).ToString("N0") + " đ<br/>Giảm giá: " + ((decimal)h["GiamGia"]).ToString("N0") + " đ<br/><strong>Phải thu: " + ((decimal)h["TienPhaiTra"]).ToString("N0") + " đ</strong><br/>Phương thức: " + HttpUtility.HtmlEncode(h["PhuongThucThanhToan"]) + "</p>"); Receipt.Text = sb.ToString(); ReceiptPanel.Visible = true;
        }
    }
}
