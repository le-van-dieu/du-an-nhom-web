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
        private bool preserveLineEdits;
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
                {
                    tables.SelectedValue = table.ToString();
                    openSelected.Visible = selected == null;
                }
                SearchInvoices(this, EventArgs.Empty);
            }
        }

        private void LoadOrders(string selected)
        {
            Bind(tables, Query(@"SELECT b.MaBan,k.TenKhuVuc+N' · '+b.TenBan+
                CASE WHEN EXISTS (SELECT 1 FROM donhang d WHERE d.MaBan=b.MaBan AND d.TrangThaiDon='DangPhucVu')
                    OR b.TrangThai='DangPhucVu' THEN N' — Đang phục vụ' ELSE N' — Trống' END AS TenBan
                FROM banan b JOIN khuvuc k ON k.MaKhuVuc=b.MaKhuVuc
                WHERE b.TrangThai IN ('Trong','DangPhucVu')
                AND (b.TrangThai='DangPhucVu' OR NOT EXISTS
                    (SELECT 1 FROM datban r WHERE r.MaBan=b.MaBan AND r.TrangThaiDat='DaXacNhan'
                    AND r.NgayGioDenDuKien BETWEEN GETDATE() AND DATEADD(hour,2,GETDATE())))
                ORDER BY k.TenKhuVuc,b.TenBan"), "MaBan", "TenBan", "Chọn bàn");
            Bind(orders, Query(@"SELECT d.MaDonHang,d.MaDonHang+N' · '+ISNULL(b.TenBan,N'Mang đi') AS TenDon
                FROM donhang d LEFT JOIN banan b ON b.MaBan=d.MaBan WHERE d.TrangThaiDon='DangPhucVu'
                ORDER BY d.ThoiGianTao DESC"), "MaDonHang", "TenDon", "Chọn đơn đang phục vụ");
            Bind(drinks, Query(@"SELECT MaDoUong,TenDoUong+N' · '+FORMAT(GiaBanHienTai,'N0','vi-VN')+N' đ' AS TenMon
                FROM douong WHERE TrangThaiKinhDoanh='ConHang' ORDER BY TenDoUong"), "MaDoUong", "TenMon", "Chọn món");
            if (selected != null && orders.Items.FindByValue(selected) != null)
                orders.SelectedValue = selected;
            menu.DataSource = Query(@"SELECT d.MaDoUong,d.TenDoUong,d.GiaBanHienTai,d.HinhAnh,c.TenDanhMuc
                FROM douong d JOIN danhmuc c ON c.MaDanhMuc=d.MaDanhMuc
                WHERE d.TrangThaiKinhDoanh='ConHang' ORDER BY c.TenDanhMuc,d.TenDoUong");
            menu.DataBind();
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
            var active = Query(@"SELECT d.MaDonHang,d.MaBan,d.ThoiGianTao,ISNULL(b.TenBan,N'Mang đi') AS TenBan
                FROM donhang d LEFT JOIN banan b ON b.MaBan=d.MaBan
                WHERE d.MaDonHang=@id AND d.TrangThaiDon='DangPhucVu'", Arg("@id", orders.SelectedValue));
            bool selected = active.Rows.Count == 1;
            servicePanel.Visible = selected;
            emptyOrder.Visible = !selected;
            if (!selected)
                return;
            openSelected.Visible = false;

            var order = active.Rows[0];
            tableTitle.Text = Server.HtmlEncode((string)order["TenBan"]);
            orderCaption.Text = string.Format("Mở lúc {0:HH:mm dd/MM/yyyy}", order["ThoiGianTao"]);
            string table = Convert.ToString(order["MaBan"]);
            if (tables.Items.FindByValue(table) != null)
                tables.SelectedValue = table;
            var rows = Query(ReadLines, Arg("@id", orders.SelectedValue));
            if (!preserveLineEdits)
            {
                lines.DataSource = rows;
                lines.DataBind();
            }
            total.Text = rows.AsEnumerable().Sum(row => row.Field<decimal>("ThanhTien")).ToString("N0") + " đ";
            checkout.Enabled = rows.Rows.Count > 0;
            cancelEmpty.Visible = rows.Rows.Count == 0;
        }

        protected void CreateOrder(object sender, EventArgs e)
        {
            if (HasPendingLineEdits())
            {
                Show("Nhấn Lưu ở dòng món vừa sửa trước khi chuyển bàn.");
                return;
            }
            int table;
            if (!int.TryParse(tables.SelectedValue, out table))
            {
                Response.Redirect("GoiMonThanhToan.aspx");
                return;
            }
            Run(delegate
            {
                string id = OpenTableOrder(table, (string)Session["MaNhanVien"]);
                Response.Redirect("GoiMonThanhToan.aspx?don=" + id);
            });
        }

        private void SaveDrink(string drink, int quantity, string note)
        {
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
                    COMMIT;", Arg("@id", orders.SelectedValue), Arg("@drink", drink), Arg("@qty", quantity), Arg("@note", note));
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
                    IF @remove=1 DELETE chitietdonhang WHERE MaDonHang=@id AND MaDoUong=@drink
                        AND SoLuong=@oldQty AND ISNULL(GhiChuMon,N'')=@oldNote;
                    ELSE UPDATE chitietdonhang SET SoLuong=@qty,ThanhTien=@qty*DonGiaTaiThoiDiemGoi,GhiChuMon=@note
                        WHERE MaDonHang=@id AND MaDoUong=@drink AND SoLuong=@oldQty AND ISNULL(GhiChuMon,N'')=@oldNote;
                    IF @@ROWCOUNT=0 THROW 50001,N'Món vừa được thay đổi trên thiết bị khác. Hãy tải lại đơn.',1;
                    COMMIT;", Arg("@id", orders.SelectedValue), Arg("@drink", drink), Arg("@remove", remove),
                    Arg("@qty", quantity), Arg("@note", note),
                    Arg("@oldQty", lines.DataKeys[row.RowIndex].Values["SoLuong"]),
                    Arg("@oldNote", Convert.ToString(lines.DataKeys[row.RowIndex].Values["GhiChuMon"])));
                SelectOrder(this, EventArgs.Empty);
            });
        }

        protected void Pay(object sender, EventArgs e)
        {
            string previewOrder = ViewState["PaymentOrder"] as string;
            if (previewOrder == null || previewOrder != orders.SelectedValue)
            {
                Show("Hãy kiểm tra thanh toán trước khi hoàn tất.");
                return;
            }
            string method = (string)ViewState["PaymentMethod"];
            string phone = (string)ViewState["PaymentPhone"];
            decimal discount = (decimal)ViewState["PaymentDiscount"];
            decimal expectedSubtotal = (decimal)ViewState["PaymentSubtotal"];
            decimal expectedSaving = (decimal)ViewState["PaymentSaving"];
            string expectedTable = (string)ViewState["PaymentTable"];
            decimal received;
            string tender = Request.Form["received"] ?? "";
            if (method == "TienMat" && tender != "" &&
                (!decimal.TryParse(tender, NumberStyles.None, CultureInfo.InvariantCulture, out received) ||
                 received < expectedSubtotal - expectedSaving))
            {
                Show("Tiền khách đưa chưa đủ. Hãy kiểm tra thanh toán lại.");
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
                        AND (MaBan=@table OR (MaBan IS NULL AND @table IS NULL))
                        AND ISNULL(CONVERT(varchar(12),MaBan),'')=@expectedTable)
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
                    IF @total<>@expectedSubtotal OR @saving<>@expectedSaving
                        THROW 50001,N'Đơn hoặc ưu đãi vừa thay đổi. Vui lòng kiểm tra thanh toán lại.',1;
                    INSERT hoadon (MaHoaDon,NgayGioThanhToan,TongTienMon,GiamGia,TienPhaiTra,PhuongThucThanhToan,MaDonHang,MaNhanVienThuNgan)
                        VALUES (@invoice,GETDATE(),@total,@saving,@total-@saving,@method,@id,@employee);
                    UPDATE donhang SET TrangThaiDon='DaThanhToan' WHERE MaDonHang=@id;
                    UPDATE banan SET TrangThai='Trong' WHERE MaBan=@table;
                    COMMIT;", Arg("@id", orders.SelectedValue), Arg("@phone", phone), Arg("@discount", discount),
                    Arg("@method", method), Arg("@invoice", invoice), Arg("@employee", Session["MaNhanVien"]),
                    Arg("@expectedSubtotal", expectedSubtotal), Arg("@expectedSaving", expectedSaving),
                    Arg("@expectedTable", expectedTable));
                Response.Redirect("GoiMonThanhToan.aspx?hoaDon=" + invoice);
            });
        }

        protected void SearchInvoices(object sender, EventArgs e)
        {
            if (HasPendingLineEdits())
            {
                Show("Nhấn Lưu ở dòng món vừa sửa trước khi tra cứu hóa đơn.");
                return;
            }
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

        protected void ChooseProduct(object sender, RepeaterCommandEventArgs e)
        {
            if (HasPendingLineEdits())
            {
                Show("Nhấn Lưu ở dòng món vừa sửa trước khi gọi thêm.");
                return;
            }
            string drink = Convert.ToString(e.CommandArgument);
            if (orders.SelectedValue == "" || drinks.Items.FindByValue(drink) == null)
            {
                Show("Hãy chọn bàn và món còn hàng.");
                return;
            }
            drinks.SelectedValue = drink;
            SaveDrink(drink, 1, "");
        }

        protected string ProductImage(object filename)
        {
            string name = System.IO.Path.GetFileName(Convert.ToString(filename));
            return string.IsNullOrWhiteSpace(name) ? ResolveUrl("~/Content/moon-logo.svg")
                : ResolveUrl("~/Hinhanh/") + Uri.EscapeDataString(name);
        }

        protected override void OnPreRender(EventArgs e)
        {
            if (orderPanel.Visible)
                SelectOrder(this, EventArgs.Empty);
            base.OnPreRender(e);
        }

        protected void CancelEmptyOrder(object sender, EventArgs e)
        {
            string selected = orders.SelectedValue;
            Run(delegate
            {
                Execute(@"SET XACT_ABORT ON; BEGIN TRAN;
                    DECLARE @table int;
                    SELECT @table=MaBan FROM donhang WHERE MaDonHang=@id;
                    IF @table IS NOT NULL SELECT MaBan FROM banan WITH (UPDLOCK,HOLDLOCK) WHERE MaBan=@table;
                    IF NOT EXISTS (SELECT 1 FROM donhang WITH (UPDLOCK,HOLDLOCK)
                        WHERE MaDonHang=@id AND TrangThaiDon='DangPhucVu'
                        AND (MaBan=@table OR (MaBan IS NULL AND @table IS NULL)))
                        THROW 50001,N'Đơn đã thay đổi. Hãy tải lại.',1;
                    IF EXISTS (SELECT 1 FROM chitietdonhang WHERE MaDonHang=@id)
                        THROW 50001,N'Đơn đã có món. Hãy kiểm tra lại trước khi đóng bàn.',1;
                    UPDATE donhang SET TrangThaiDon='DaHuy' WHERE MaDonHang=@id;
                    UPDATE banan SET TrangThai='Trong' WHERE MaBan=@table;
                    COMMIT;", Arg("@id", selected));
                Response.Redirect("BanVaDatBan.aspx");
            });
        }

        protected void PreviewPayment(object sender, EventArgs e)
        {
            ViewState.Remove("PaymentOrder");
            string method = Request.Form["method"];
            string phone = (Request.Form["memberPhone"] ?? "").Trim();
            decimal discount;
            string discountInput = Request.Form["discount"];
            if (string.IsNullOrWhiteSpace(discountInput))
                discountInput = "0";
            if (orders.SelectedValue == "" || phone.Length > 15 ||
                !decimal.TryParse(discountInput, NumberStyles.None, CultureInfo.InvariantCulture, out discount) ||
                discount < 0 || discount > 9999999999999999m || (discount > 0 && !CanDiscount) ||
                (method != "TienMat" && method != "ChuyenKhoan"))
            {
                Show("Kiểm tra bàn, mức giảm giá và phương thức thanh toán.");
                return;
            }

            var rows = Query(ReadLines, Arg("@id", orders.SelectedValue));
            if (rows.Rows.Count == 0)
            {
                Show("Hãy thêm ít nhất một món trước khi thanh toán.");
                return;
            }
            if (HasPendingLineEdits())
            {
                Show("Bạn vừa sửa món. Nhấn Lưu ở dòng món trước khi thanh toán.");
                return;
            }

            decimal subtotal = rows.AsEnumerable().Sum(row => row.Field<decimal>("ThanhTien"));
            var active = Query(@"SELECT d.MaBan,ISNULL(b.TenBan,N'Mang đi') AS TenBan
                FROM donhang d LEFT JOIN banan b ON b.MaBan=d.MaBan
                WHERE d.MaDonHang=@id AND d.TrangThaiDon='DangPhucVu'", Arg("@id", orders.SelectedValue));
            if (active.Rows.Count != 1)
            {
                Show("Đơn đã đóng. Hãy chọn bàn khác để tiếp tục.");
                return;
            }
            tableTitle.Text = Server.HtmlEncode((string)active.Rows[0]["TenBan"]);
            decimal rate = 0;
            string customerName = "Khách lẻ";
            if (phone != "")
            {
                var members = Query("SELECT TenKhachHang,HangThanhVien FROM khachhang WHERE SoDienThoai=@phone", Arg("@phone", phone));
                if (members.Rows.Count != 1)
                {
                    Show("Không tìm thấy thành viên. Kiểm tra SĐT hoặc để trống để bán cho khách lẻ.");
                    return;
                }
                customerName = (string)members.Rows[0]["TenKhachHang"];
                if (Convert.ToString(members.Rows[0]["HangThanhVien"]) == "VIP")
                    rate = 0.10m;
            }
            decimal saving = Math.Round(subtotal * rate, 2, MidpointRounding.AwayFromZero) + discount;
            if (saving > subtotal)
            {
                Show("Tổng giảm giá vượt tiền món.");
                return;
            }
            ViewState["PaymentOrder"] = orders.SelectedValue;
            ViewState["PaymentSubtotal"] = subtotal;
            ViewState["PaymentSaving"] = saving;
            ViewState["PaymentPhone"] = phone;
            ViewState["PaymentDiscount"] = discount;
            ViewState["PaymentMethod"] = method;
            ViewState["PaymentTable"] = Convert.ToString(active.Rows[0]["MaBan"]);
            string amount = (subtotal - saving).ToString(CultureInfo.InvariantCulture);
            string methodName = method == "TienMat" ? "Tiền mặt" : "Chuyển khoản";
            paymentSummary.Text = "<p class='fw-bold'>" + Server.HtmlEncode(Server.HtmlDecode(tableTitle.Text)) + "</p>" +
                "<p>" + Server.HtmlEncode(customerName) + " · " + methodName + "</p>" +
                "<p>Tiền món <strong class='float-end'>" + subtotal.ToString("N0") + " đ</strong></p>" +
                "<p>Giảm thành viên <strong class='float-end'>" + (saving-discount).ToString("N0") + " đ</strong></p>" +
                "<p>Giảm thêm <strong class='float-end'>" + discount.ToString("N0") + " đ</strong></p>" +
                "<p id='paymentAmount' data-amount='" + amount + "' class='border-top pt-3 fs-5 fw-bold'>Cần thu " +
                "<span class='float-end'>" + (subtotal-saving).ToString("N0") + " đ</span></p>" +
                "<p class='small text-muted mb-0'>Chỉ hoàn tất sau khi đã nhận đủ tiền " + methodName.ToLowerInvariant() + ".</p>";
            ClientScript.RegisterStartupScript(GetType(), "paymentPreview",
                "document.getElementById('cashTender').hidden=" + (method != "TienMat" ? "true" : "false") +
                ";new bootstrap.Modal(document.getElementById('paymentModal')).show();", true);
        }

        private static bool ValidQuantity(string input, out int quantity)
        {
            return int.TryParse(input, out quantity) && quantity >= 1 && quantity <= 999;
        }

        private bool HasPendingLineEdits()
        {
            foreach (GridViewRow row in lines.Rows)
            {
                int quantity;
                if (!int.TryParse(((TextBox)row.FindControl("lineQuantity")).Text, out quantity) ||
                    quantity != Convert.ToInt32(lines.DataKeys[row.RowIndex].Values["SoLuong"]) ||
                    ((TextBox)row.FindControl("lineNote")).Text != Convert.ToString(lines.DataKeys[row.RowIndex].Values["GhiChuMon"]))
                    return true;
            }
            return false;
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
            preserveLineEdits = true;
            message.Text = Server.HtmlEncode(text);
            message.Visible = true;
        }
    }
}
