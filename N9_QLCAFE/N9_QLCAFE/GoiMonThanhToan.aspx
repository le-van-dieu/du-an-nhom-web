<%@ Page Title="Gọi món &amp; Thanh toán" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="GoiMonThanhToan.aspx.cs" Inherits="N9_QLCAFE.GoiMonThanhToan" %>
<asp:Content runat="server" ContentPlaceHolderID="HeadContent">
    <style>
        @media print {
            body * { visibility: hidden; }
            #receipt, #receipt * { visibility: visible; }
            #receipt { position: absolute; inset: 0 auto auto 0; width: 100%; }
            #receipt .print-hide { display: none; }
        }
    </style>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="MainContent">
    <asp:Label ID="message" runat="server" CssClass="alert alert-info d-block" Visible="false" role="status" />
    <asp:Panel ID="orderPanel" runat="server">
        <h1 class="h3 mb-3">Gọi món &amp; Thanh toán</h1>
        <div class="card card-body mb-3">
            <div class="row g-3 align-items-end">
                <div class="col-md-4">
                    <asp:Label runat="server" AssociatedControlID="tables" CssClass="form-label" Text="Bàn cho đơn mới" />
                    <asp:DropDownList ID="tables" runat="server" CssClass="form-select" />
                </div>
                <div class="col-md-2">
                    <asp:Button runat="server" CssClass="btn btn-primary" Text="Tạo đơn" OnClick="CreateOrder" />
                </div>
                <div class="col-md-6">
                    <asp:Label runat="server" AssociatedControlID="orders" CssClass="form-label" Text="Đơn đang phục vụ" />
                    <asp:DropDownList ID="orders" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="SelectOrder" />
                </div>
            </div>
        </div>
        <div class="card card-body mb-3">
            <h2 class="h5">Món trong đơn</h2>
            <div class="row g-2 align-items-end mb-3">
                <div class="col-md-5">
                    <asp:Label runat="server" AssociatedControlID="drinks" CssClass="form-label" Text="Đồ uống còn hàng" />
                    <asp:DropDownList ID="drinks" runat="server" CssClass="form-select" />
                </div>
                <div class="col-md-2">
                    <label for="quantity" class="form-label">Số lượng</label>
                    <input id="quantity" name="quantity" class="form-control" type="number" min="1" max="999" value="1" />
                </div>
                <div class="col-md-3">
                    <label for="note" class="form-label">Ghi chú món</label>
                    <input id="note" name="note" class="form-control" maxlength="255" />
                </div>
                <div class="col-md-2">
                    <asp:Button runat="server" CssClass="btn btn-primary" Text="Thêm món" OnClick="AddDrink" />
                </div>
            </div>
            <div class="table-responsive">
                <asp:GridView ID="lines" runat="server" AutoGenerateColumns="false" DataKeyNames="MaDoUong" CssClass="table align-middle"
                    EmptyDataText="Chưa có món trong đơn." OnRowCommand="ChangeLine">
                    <Columns>
                        <asp:BoundField DataField="TenDoUong" HeaderText="Món" />
                        <asp:BoundField DataField="DonGiaTaiThoiDiemGoi" HeaderText="Đơn giá" DataFormatString="{0:N0} đ" />
                        <asp:TemplateField HeaderText="Số lượng">
                            <ItemTemplate><asp:TextBox ID="lineQuantity" runat="server" Text='<%# Bind("SoLuong") %>' CssClass="form-control form-control-sm" TextMode="Number" aria-label="Số lượng" /></ItemTemplate>
                        </asp:TemplateField>
                        <asp:TemplateField HeaderText="Ghi chú">
                            <ItemTemplate><asp:TextBox ID="lineNote" runat="server" Text='<%# Bind("GhiChuMon") %>' CssClass="form-control form-control-sm" MaxLength="255" aria-label="Ghi chú món" /></ItemTemplate>
                        </asp:TemplateField>
                        <asp:BoundField DataField="ThanhTien" HeaderText="Thành tiền" DataFormatString="{0:N0} đ" />
                        <asp:TemplateField>
                            <ItemTemplate>
                                <asp:LinkButton runat="server" CommandName="SaveLine" CssClass="btn btn-sm btn-outline-primary">Lưu</asp:LinkButton>
                                <asp:LinkButton runat="server" CommandName="RemoveLine" CssClass="btn btn-sm btn-outline-danger">Xóa</asp:LinkButton>
                            </ItemTemplate>
                        </asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </div>
            <p class="fw-bold">Tiền món <asp:Label ID="total" runat="server" /></p>
            <div class="row g-2 align-items-end">
                <div class="col-md-3">
                    <label for="memberPhone" class="form-label">SĐT thành viên</label>
                    <input id="memberPhone" name="memberPhone" class="form-control" maxlength="15" />
                </div>
                <% if (CanDiscount) { %><div class="col-md-3">
                    <label for="discount" class="form-label">Giảm thêm (đ)</label>
                    <input id="discount" name="discount" class="form-control" type="number" min="0" value="0" />
                </div><% } %>
                <div class="col-md-3">
                    <label for="method" class="form-label">Phương thức</label>
                    <select id="method" name="method" class="form-select">
                        <option value="TienMat">Tiền mặt</option>
                        <option value="ChuyenKhoan">Chuyển khoản</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <asp:Button runat="server" CssClass="btn btn-success" Text="Xác nhận thanh toán" OnClick="Pay" />
                </div>
            </div>
        </div>
        <section class="card card-body">
            <h2 class="h5">Lịch sử hóa đơn</h2>
            <div class="row g-2 align-items-end mb-3">
                <div class="col-md-4">
                    <label for="invoiceCode" class="form-label">Mã hóa đơn</label>
                    <input id="invoiceCode" name="invoiceCode" class="form-control" maxlength="30" />
                </div>
                <div class="col-md-4">
                    <label for="invoiceDate" class="form-label">Ngày thanh toán</label>
                    <input id="invoiceDate" name="invoiceDate" class="form-control" type="date" />
                </div>
                <div class="col-md-4">
                    <asp:Button runat="server" CssClass="btn btn-outline-primary" Text="Tra cứu" OnClick="SearchInvoices" />
                </div>
            </div>
            <div class="table-responsive">
                <asp:GridView ID="history" runat="server" AutoGenerateColumns="false" CssClass="table" EmptyDataText="Chưa có hóa đơn phù hợp.">
                    <Columns>
                        <asp:HyperLinkField DataTextField="MaHoaDon" DataNavigateUrlFields="MaHoaDon" DataNavigateUrlFormatString="GoiMonThanhToan.aspx?hoaDon={0}" HeaderText="Mã hóa đơn" />
                        <asp:BoundField DataField="NgayGioThanhToan" HeaderText="Thanh toán lúc" DataFormatString="{0:dd/MM/yyyy HH:mm}" />
                        <asp:BoundField DataField="PhuongThuc" HeaderText="Phương thức" />
                        <asp:BoundField DataField="TienPhaiTra" HeaderText="Đã thu" DataFormatString="{0:N0} đ" />
                    </Columns>
                </asp:GridView>
            </div>
        </section>
    </asp:Panel>
    <asp:Panel ID="invoicePanel" runat="server" Visible="false">
        <section id="receipt" class="card card-body">
            <h1 class="h3">Hóa đơn MOON CAFÉ</h1>
            <asp:Label ID="invoiceTitle" runat="server" CssClass="mb-3" />
            <asp:GridView ID="invoiceLines" runat="server" AutoGenerateColumns="false" CssClass="table">
                <Columns>
                    <asp:BoundField DataField="TenDoUong" HeaderText="Món" />
                    <asp:BoundField DataField="SoLuong" HeaderText="Số lượng" />
                    <asp:BoundField DataField="DonGiaTaiThoiDiemGoi" HeaderText="Đơn giá" DataFormatString="{0:N0} đ" />
                    <asp:BoundField DataField="ThanhTien" HeaderText="Thành tiền" DataFormatString="{0:N0} đ" />
                </Columns>
            </asp:GridView>
            <asp:Label ID="invoiceTotal" runat="server" CssClass="fw-bold mb-3" />
            <div class="print-hide">
                <button type="button" class="btn btn-primary" onclick="window.print()">In hóa đơn</button>
                <a href="GoiMonThanhToan.aspx" class="btn btn-outline-primary">Về màn hình bán hàng</a>
            </div>
        </section>
    </asp:Panel>
</asp:Content>
