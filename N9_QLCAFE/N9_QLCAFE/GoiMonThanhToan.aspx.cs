using System;
using System.Data;
using System.Data.SqlClient;
using System.Globalization;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using static N9_QLCAFE.CafeData;

namespace N9_QLCAFE
{
    public partial class GoiMonThanhToan : Page
    {
        protected bool CanDiscount => ((SiteMaster)Master).CanManageBusiness;

        private const string ReadLines = @"SELECT c.MaDoUong,d.TenDoUong,c.SoLuong,c.DonGiaTaiThoiDiemGoi,
            c.GhiChuMon,c.ThanhTien FROM chitietdonhang c JOIN douong d ON d.MaDoUong=c.MaDoUong
            WHERE c.MaDonHang=@id ORDER BY d.TenDoUong";

        protected void Page_Load(object sender, EventArgs e)
        {
            if (IsPostBack)
                return;
            string invoice = Request.QueryString["hoaDon"];
            if (!string.IsNullOrEmpty(invoice))
                LoadInvoice(invoice);
            else
            {
                string selected = Request.QueryString["don"];
                int table;
                if (int.TryParse(Request.QueryString["maban"], out table))
                {
                    var matches = Query("SELECT MaDonHang FROM donhang WHERE MaBan=@table AND TrangThaiDon='DangPhucVu'", Arg("@table", table));
                    if (matches.Rows.Count > 0)
                        selected = (string)matches.Rows[0][0];
                }
                LoadOrders(selected);
                if (table > 0 && tables.Items.FindByValue(table.ToString()) != null)
                    tables.SelectedValue = table.ToString();
                SearchInvoices(this, EventArgs.Empty);
            }
        }

        private void LoadOrders(string selected)
        {
            Bind(tables, Query(@"SELECT b.MaBan,k.TenKhuVuc+N' · '+b.TenBan AS TenBan
                FROM banan b JOIN khuvuc k ON k.MaKhuVuc=b.MaKhuVuc
                WHERE b.TrangThai IN ('Trong','DangPhucVu')
                AND NOT EXISTS (SELECT 1 FROM datban r WHERE r.MaBan=b.MaBan AND r.TrangThaiDat='DaXacNhan'
                    AND r.NgayGioDenDuKien BETWEEN GETDATE() AND DATEADD(hour,2,GETDATE()))
                AND NOT EXISTS (SELECT 1 FROM donhang d WHERE d.MaBan=b.MaBan AND d.TrangThaiDon='DangPhucVu')
                ORDER BY k.TenKhuVuc,b.TenBan"), "MaBan", "TenBan", "Chọn bàn");
            Bind(orders, Query(@"SELECT d.MaDonHang,d.MaDonHang+N' · '+ISNULL(b.TenBan,N'Mang đi') AS TenDon
                FROM donhang d LEFT JOIN banan b ON b.MaBan=d.MaBan WHERE d.TrangThaiDon='DangPhucVu'
                ORDER BY d.ThoiGianTao DESC"), "MaDonHang", "TenDon", "Chọn đơn đang phục vụ");
            Bind(drinks, Query(@"SELECT MaDoUong,TenDoUong+N' · '+FORMAT(GiaBanHienTai,'N0','vi-VN')+N' đ' AS TenMon
                FROM douong WHERE TrangThaiKinhDoanh='ConHang' ORDER BY TenDoUong"), "MaDoUong", "TenMon", "Chọn món");
            if (selected != null && orders.Items.FindByValue(selected) != null)
                orders.SelectedValue = selected;
            SelectOrder(this, EventArgs.Empty);
        }

        private static void Bind(DropDownList list, DataTable rows, string value, string label, string placeholder)
        {
            list.DataValueField = value;
            list.DataTextField = label;
            list.DataSource = rows;
            list.DataBind();
            list.Items.Insert(0, new ListItem(placeholder, ""));
        }

        protected void SelectOrder(object sender, EventArgs e)
        {
            var rows = Query(ReadLines, Arg("@id", orders.SelectedValue));
            lines.DataSource = rows;
            lines.DataBind();
            total.Text = rows.AsEnumerable().Sum(row => row.Field<decimal>("ThanhTien")).ToString("N0") + " đ";
        }

        protected void CreateOrder(object sender, EventArgs e)
        {
            int table;
            if (!int.TryParse(tables.SelectedValue, out table))
            {
                Show("Hãy chọn bàn.");
                return;
            }
            string id = NewCode("DH");
            Run(delegate
            {
                Execute(@"SET XACT_ABORT ON; BEGIN TRAN;
                    IF NOT EXISTS (SELECT 1 FROM banan WITH (UPDLOCK,HOLDLOCK)
                        WHERE MaBan=@table AND TrangThai IN ('Trong','DangPhucVu'))
                        THROW 50001,N'Bàn không còn khả dụng.',1;
                    IF EXISTS (SELECT 1 FROM datban WHERE MaBan=@table AND TrangThaiDat='DaXacNhan'
                        AND NgayGioDenDuKien BETWEEN GETDATE() AND DATEADD(hour,2,GETDATE()))
                        THROW 50001,N'Bàn sắp có khách đặt.',1;
                    IF EXISTS (SELECT 1 FROM donhang WITH (UPDLOCK,HOLDLOCK)
                        WHERE MaBan=@table AND TrangThaiDon='DangPhucVu')
                        THROW 50001,N'Bàn đã có đơn đang phục vụ.',1;
                    INSERT donhang (MaDonHang,ThoiGianTao,LoaiDon,TrangThaiDon,MaBan,MaNhanVienTao)
                    VALUES (@id,GETDATE(),'TaiCho','DangPhucVu',@table,@employee);
                    UPDATE banan SET TrangThai='DangPhucVu' WHERE MaBan=@table;
                    COMMIT;", Arg("@table", table), Arg("@id", id), Arg("@employee", Session["MaNhanVien"]));
                Response.Redirect("GoiMonThanhToan.aspx?don=" + id);
            });
        }

        protected void AddDrink(object sender, EventArgs e)
        {
            int quantity;
            string note = Request.Form["note"] ?? "";
            if (orders.SelectedValue == "" || drinks.SelectedValue == "" || !ValidQuantity(Request.Form["quantity"], out quantity) || note.Length > 255)
            {
                Show("Chọn đơn và món. Số lượng phải từ 1 đến 999.");
                return;
            }
            Run(delegate
            {
                Execute(@"SET XACT_ABORT ON; BEGIN TRAN;
                    IF NOT EXISTS (SELECT 1 FROM donhang WITH (UPDLOCK,HOLDLOCK) WHERE MaDonHang=@id AND TrangThaiDon='DangPhucVu')
                        THROW 50001,N'Đơn đã đóng hoặc không còn tồn tại.',1;
                    DECLARE @price decimal(18,2);
                    SELECT @price=GiaBanHienTai FROM douong WITH (HOLDLOCK) WHERE MaDoUong=@drink AND TrangThaiKinhDoanh='ConHang';
                    IF @price IS NULL THROW 50001,N'Món không còn hàng.',1;
                    IF EXISTS (SELECT 1 FROM chitietdonhang WHERE MaDonHang=@id AND MaDoUong=@drink AND SoLuong+@qty>999)
                        THROW 50001,N'Số lượng tối đa là 999.',1;
                    UPDATE chitietdonhang SET SoLuong=SoLuong+@qty,ThanhTien=(SoLuong+@qty)*DonGiaTaiThoiDiemGoi,
                        GhiChuMon=COALESCE(NULLIF(@note,N''),GhiChuMon) WHERE MaDonHang=@id AND MaDoUong=@drink;
                    IF @@ROWCOUNT=0 INSERT chitietdonhang (MaDonHang,MaDoUong,SoLuong,DonGiaTaiThoiDiemGoi,GhiChuMon,ThanhTien)
                        VALUES (@id,@drink,@qty,@price,@note,@price*@qty);
                    COMMIT;", Arg("@id", orders.SelectedValue), Arg("@drink", drinks.SelectedValue), Arg("@qty", quantity), Arg("@note", note));
                SelectOrder(this, EventArgs.Empty);
            });
        }

        protected void ChangeLine(object sender, GridViewCommandEventArgs e)
        {
            var row = (GridViewRow)((Control)e.CommandSource).NamingContainer;
            string drink = (string)lines.DataKeys[row.RowIndex].Value;
            int quantity = 0;
            string note = ((TextBox)row.FindControl("lineNote")).Text;
            bool remove = e.CommandName == "RemoveLine";
            if (!remove && (!ValidQuantity(((TextBox)row.FindControl("lineQuantity")).Text, out quantity) || note.Length > 255))
            {
                Show("Số lượng phải từ 1 đến 999 và ghi chú tối đa 255 ký tự.");
                return;
            }

            Run(delegate
            {
                Execute(@"SET XACT_ABORT ON; BEGIN TRAN;
                    IF NOT EXISTS (SELECT 1 FROM donhang WITH (UPDLOCK,HOLDLOCK) WHERE MaDonHang=@id AND TrangThaiDon='DangPhucVu')
                        THROW 50001,N'Đơn đã đóng hoặc không còn tồn tại.',1;
                    IF @remove=1 DELETE chitietdonhang WHERE MaDonHang=@id AND MaDoUong=@drink;
                    ELSE UPDATE chitietdonhang SET SoLuong=@qty,ThanhTien=@qty*DonGiaTaiThoiDiemGoi,GhiChuMon=@note
                        WHERE MaDonHang=@id AND MaDoUong=@drink;
                    COMMIT;", Arg("@id", orders.SelectedValue), Arg("@drink", drink), Arg("@remove", remove),
                    Arg("@qty", quantity), Arg("@note", note));
                SelectOrder(this, EventArgs.Empty);
            });
        }

        protected void Pay(object sender, EventArgs e)
        {
            string method = Request.Form["method"];
            string phone = (Request.Form["memberPhone"] ?? "").Trim();
            decimal discount;
            if (orders.SelectedValue == "" || phone.Length > 15 ||
                !decimal.TryParse(Request.Form["discount"] ?? "0", NumberStyles.None, CultureInfo.InvariantCulture, out discount) ||
                discount < 0 || discount > 9999999999999999m || (discount > 0 && !CanDiscount) || (method != "TienMat" && method != "ChuyenKhoan"))
            {
                Show("Kiểm tra đơn, mức giảm giá và phương thức thanh toán.");
                return;
            }
            string invoice = NewCode("HD");
            Run(delegate
            {
                Execute(@"SET XACT_ABORT ON; BEGIN TRAN;
                    DECLARE @table int,@total decimal(18,2),@rate decimal(4,2)=0;
                    SELECT @table=MaBan FROM donhang WHERE MaDonHang=@id;
                    IF @table IS NOT NULL SELECT MaBan FROM banan WITH (UPDLOCK,HOLDLOCK) WHERE MaBan=@table;
                    IF NOT EXISTS (SELECT 1 FROM donhang WITH (UPDLOCK,HOLDLOCK) WHERE MaDonHang=@id AND TrangThaiDon='DangPhucVu'
                        AND (MaBan=@table OR (MaBan IS NULL AND @table IS NULL)))
                        THROW 50001,N'Đơn đã đóng hoặc vừa chuyển bàn. Hãy tải lại.',1;
                    SELECT @total=SUM(ThanhTien) FROM chitietdonhang WHERE MaDonHang=@id;
                    IF @total IS NULL THROW 50001,N'Đơn chưa có món.',1;
                    IF @phone<>'' BEGIN
                        SELECT @rate=CASE HangThanhVien WHEN 'VIP' THEN 0.10 ELSE 0 END
                        FROM khachhang WHERE SoDienThoai=@phone;
                        IF @@ROWCOUNT=0 THROW 50001,N'Không tìm thấy thành viên theo số điện thoại.',1;
                    END;
                    DECLARE @saving decimal(18,2)=ROUND(@total*@rate,2)+@discount;
                    IF @saving>@total THROW 50001,N'Giảm giá vượt tiền món.',1;
                    INSERT hoadon (MaHoaDon,NgayGioThanhToan,TongTienMon,GiamGia,TienPhaiTra,PhuongThucThanhToan,MaDonHang,MaNhanVienThuNgan)
                        VALUES (@invoice,GETDATE(),@total,@saving,@total-@saving,@method,@id,@employee);
                    UPDATE donhang SET TrangThaiDon='DaThanhToan' WHERE MaDonHang=@id;
                    UPDATE banan SET TrangThai='Trong' WHERE MaBan=@table;
                    COMMIT;", Arg("@id", orders.SelectedValue), Arg("@phone", phone), Arg("@discount", discount),
                    Arg("@method", method), Arg("@invoice", invoice), Arg("@employee", Session["MaNhanVien"]));
                Response.Redirect("GoiMonThanhToan.aspx?hoaDon=" + invoice);
            });
        }

        protected void SearchInvoices(object sender, EventArgs e)
        {
            string code = (Request.Form["invoiceCode"] ?? "").Trim();
            string dateInput = Request.Form["invoiceDate"] ?? "";
            DateTime date;
            bool validDate = DateTime.TryParseExact(dateInput, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out date);
            if (dateInput.Length > 0 && (!validDate || date.Year < 1753 || date.Year > 9998))
            {
                Show("Ngày tra cứu không hợp lệ.");
                return;
            }
            history.DataSource = Query(@"SELECT TOP 200 MaHoaDon,NgayGioThanhToan,TienPhaiTra,
                CASE PhuongThucThanhToan WHEN 'TienMat' THEN N'Tiền mặt' WHEN 'ChuyenKhoan' THEN N'Chuyển khoản' END AS PhuongThuc
                FROM hoadon WHERE (@code='' OR MaHoaDon=@code)
                AND (@date IS NULL OR (NgayGioThanhToan>=@date AND NgayGioThanhToan<DATEADD(day,1,@date)))
                ORDER BY NgayGioThanhToan DESC", Arg("@code", code),
                new SqlParameter("@date", SqlDbType.Date) { Value = dateInput.Length == 0 ? (object)DBNull.Value : date });
            history.DataBind();
        }

        private void LoadInvoice(string code)
        {
            var rows = Query(@"SELECT h.*,n.HoTen FROM hoadon h JOIN nhanvien n ON n.MaNhanVien=h.MaNhanVienThuNgan
                WHERE h.MaHoaDon=@code", Arg("@code", code));
            orderPanel.Visible = false;
            if (rows.Rows.Count == 0)
            {
                Response.StatusCode = 404;
                Show("Không tìm thấy hóa đơn.");
                return;
            }
            var invoice = rows.Rows[0];
            invoicePanel.Visible = true;
            invoiceTitle.Text = Server.HtmlEncode(string.Format("{0} · {1:dd/MM/yyyy HH:mm} · {2} · {3}", invoice["MaHoaDon"],
                invoice["NgayGioThanhToan"], invoice["HoTen"], (string)invoice["PhuongThucThanhToan"] == "TienMat" ? "Tiền mặt" : "Chuyển khoản"));
            invoiceLines.DataSource = Query(ReadLines, Arg("@id", invoice["MaDonHang"]));
            invoiceLines.DataBind();
            invoiceTotal.Text = string.Format("Tiền món {0:N0} đ · Giảm {1:N0} đ · Đã thu {2:N0} đ",
                invoice["TongTienMon"], invoice["GiamGia"], invoice["TienPhaiTra"]);
        }

        private static bool ValidQuantity(string input, out int quantity)
        {
            return int.TryParse(input, out quantity) && quantity >= 1 && quantity <= 999;
        }

        private static string NewCode(string prefix)
        {
            return prefix + Guid.NewGuid().ToString("N").Substring(0, 28);
        }

        private void Run(Action action)
        {
            try
            {
                action();
            }
            catch (SqlException e) when (e.Number == 50001 || e.Number == 1205)
            {
                Show(e.Number == 1205 ? "Dữ liệu đang được cập nhật. Vui lòng thử lại." : e.Message);
            }
        }

        private void Show(string text)
        {
            message.Text = Server.HtmlEncode(text);
            message.Visible = true;
        }
    }
}
