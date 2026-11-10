<%@ Page Title="Gọi món & Thanh toán" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="GoiMonThanhToan.aspx.cs" Inherits="N9_QLCAFE.GoiMonThanhToan" %>
<asp:Content ContentPlaceHolderID="HeadContent" runat="server"><style>
.pos-menu{display:grid;grid-template-columns:repeat(auto-fill,minmax(160px,1fr));gap:12px}.pos-menu a{white-space:normal;padding:18px}.pos-note{max-width:180px}
@media print{body *{visibility:hidden}#posReceipt,#posReceipt *{visibility:visible}#posReceipt{position:absolute;left:0;top:0;width:100%}.no-print{display:none}}
</style></asp:Content>
<asp:Content ContentPlaceHolderID="MainContent" runat="server">
<div class="mb-4"><span class="badge badge-soft-blue">F27–F44 • Lê Văn Điều</span><h4>Gọi món, đơn hàng & thanh toán</h4></div>
<asp:Label ID="Message" runat="server" CssClass="d-block mb-3" role="alert" />
<div class="row g-4"><div class="col-lg-6"><div class="card-custom p-3">
<h5>Thực đơn</h5><div class="d-flex gap-2 mb-3"><asp:TextBox ID="Search" runat="server" CssClass="form-control" placeholder="Tên hoặc mã đồ uống" MaxLength="100" /><asp:DropDownList ID="Category" runat="server" CssClass="form-select" /><asp:Button runat="server" Text="Tìm" OnClick="Filter" CssClass="btn btn-primary" /></div>
<div class="pos-menu"><asp:Repeater ID="Menu" runat="server" OnItemCommand="AddDrink"><ItemTemplate><asp:LinkButton runat="server" CssClass="btn btn-outline-primary" CommandArgument='<%# Eval("MaDoUong") %>'><%#: Eval("TenDoUong") %><br/><%#: string.Format("{0:N0} đ", Eval("GiaBanHienTai")) %></asp:LinkButton></ItemTemplate></asp:Repeater></div>
<asp:Label ID="EmptyMenu" runat="server" /></div></div>
<div class="col-lg-6"><div class="card-custom p-3"><h5>Đơn hiện tại: <asp:Label ID="OrderLabel" runat="server" /></h5>
<label>Nhân viên thực hiện</label><asp:DropDownList ID="Staff" runat="server" CssClass="form-select mb-2" />
<label>Bàn / hình thức</label><asp:DropDownList ID="TableChoice" runat="server" CssClass="form-select mb-3" />
<asp:GridView ID="Cart" runat="server" AutoGenerateColumns="false" CssClass="table" DataKeyNames="MaDoUong" OnRowCommand="CartCommand" EmptyDataText="Chọn món từ thực đơn để bắt đầu."><Columns>
<asp:BoundField DataField="TenDoUong" HeaderText="Món" HtmlEncode="true" />
<asp:TemplateField HeaderText="SL"><ItemTemplate><asp:TextBox ID="Quantity" runat="server" Text='<%# Eval("SoLuong") %>' TextMode="Number" Width="65" min="1" max="999" /></ItemTemplate></asp:TemplateField>
<asp:TemplateField HeaderText="Ghi chú"><ItemTemplate><asp:TextBox ID="Note" runat="server" Text='<%# Eval("GhiChuMon") %>' MaxLength="255" CssClass="form-control pos-note" /></ItemTemplate></asp:TemplateField>
<asp:BoundField DataField="ThanhTien" HeaderText="Tiền" DataFormatString="{0:N0}" />
<asp:TemplateField><ItemTemplate><asp:LinkButton runat="server" Text="Xóa" CommandName="RemoveDrink" CommandArgument='<%# Eval("MaDoUong") %>' /></ItemTemplate></asp:TemplateField>
</Columns></asp:GridView>
<asp:Button runat="server" Text="Cập nhật số lượng / ghi chú" OnClick="UpdateCart" CssClass="btn btn-outline-primary mb-3" />
<p>Tạm tính: <strong><asp:Label ID="Subtotal" runat="server" /></strong></p>
<label>Giảm giá (đ, chỉ Admin / Quản lý đã đăng nhập)</label><asp:TextBox ID="Discount" runat="server" Text="0" TextMode="Number" CssClass="form-control mb-2" min="0" step="0.01" />
<asp:RadioButtonList ID="Payment" runat="server" RepeatDirection="Horizontal"><asp:ListItem Value="TienMat" Selected="True">Tiền mặt</asp:ListItem><asp:ListItem Value="ChuyenKhoan">Chuyển khoản</asp:ListItem></asp:RadioButtonList>
<asp:CheckBox ID="TransferConfirmed" runat="server" Text=" Đã kiểm tra nhận đủ tiền chuyển khoản" /><br/>
<asp:Button runat="server" Text="Lưu đơn / chuyển bàn" OnClick="Save" CssClass="btn btn-outline-primary mt-3" />
<asp:Button runat="server" Text="Xem trước thanh toán" OnClick="Preview" CssClass="btn btn-primary mt-3" />
<asp:Button runat="server" Text="Đơn mới" OnClick="NewOrder" CssClass="btn btn-secondary mt-3" OnClientClick="return confirm('Bỏ các thay đổi chưa lưu để tạo đơn mới?');" />
<asp:Panel ID="ConfirmPanel" runat="server" Visible="false" CssClass="border rounded p-3 mt-3"><asp:Label ID="PaymentSummary" runat="server" /><br/><asp:Button runat="server" Text="Xác nhận hoàn tất thanh toán" OnClick="Checkout" CssClass="btn btn-success mt-2" OnClientClick="return confirm('Xác nhận đã nhận đủ tiền?');" /></asp:Panel>
</div></div></div>
<div class="card-custom p-3 mt-4"><h5>Theo dõi đơn & lịch sử hóa đơn</h5><div class="d-flex gap-2 mb-3"><asp:TextBox ID="HistorySearch" runat="server" CssClass="form-control" placeholder="Mã đơn hoặc mã hóa đơn" MaxLength="100" /><asp:TextBox ID="HistoryDate" runat="server" TextMode="Date" CssClass="form-control" /><asp:Button runat="server" Text="Tra cứu" OnClick="Filter" CssClass="btn btn-primary" /></div>
<asp:GridView ID="History" runat="server" AutoGenerateColumns="false" CssClass="table" OnRowCommand="OpenOrder" EmptyDataText="Không có đơn phù hợp."><Columns><asp:BoundField DataField="MaDonHang" HeaderText="Đơn"/><asp:BoundField DataField="TenBan" HeaderText="Bàn"/><asp:BoundField DataField="TrangThaiDon" HeaderText="Trạng thái"/><asp:BoundField DataField="MaHoaDon" HeaderText="Hóa đơn"/><asp:BoundField DataField="NgayGioThanhToan" HeaderText="Thanh toán" DataFormatString="{0:dd/MM/yyyy HH:mm}"/><asp:BoundField DataField="TienPhaiTra" HeaderText="Thực thu" DataFormatString="{0:N0}"/><asp:BoundField DataField="PhuongThucThanhToan" HeaderText="Phương thức"/><asp:TemplateField><ItemTemplate><asp:LinkButton runat="server" Text="Mở / xem hóa đơn" CommandName="Open" CommandArgument='<%# Eval("MaDonHang") %>' /></ItemTemplate></asp:TemplateField></Columns></asp:GridView></div>
<asp:Panel ID="ReceiptPanel" runat="server" Visible="false" CssClass="card-custom p-4 mt-4"><div id="posReceipt"><h4>MOON CAFÉ — HÓA ĐƠN</h4><asp:Literal ID="Receipt" runat="server" /></div><button type="button" class="btn btn-outline-primary no-print" onclick="window.print()">In / lưu PDF hóa đơn</button></asp:Panel>
</asp:Content>
