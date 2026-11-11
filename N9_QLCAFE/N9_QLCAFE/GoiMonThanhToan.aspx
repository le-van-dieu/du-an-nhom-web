<%@ Page Title="Bán hàng" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="GoiMonThanhToan.aspx.cs" Inherits="N9_QLCAFE.GoiMonThanhToan" %>
<asp:Content runat="server" ContentPlaceHolderID="HeadContent">
    <style>
        .pos-menu { display:grid; grid-template-columns:repeat(auto-fill,minmax(140px,1fr)); gap:12px; }
        .pos-product { color:#172b4d; text-decoration:none; background:white; border:1px solid #e2e8f0; border-radius:12px; padding:12px; display:flex; flex-direction:column; gap:6px; text-align:left; height:100%; }
        .pos-product:hover { border-color:#3c83f6; box-shadow:0 4px 16px #2563eb18; }
        .pos-product img { width:100%; height:100px; object-fit:cover; border-radius:8px; background:#eff6ff; }
        .pos-product:focus-visible { outline:3px solid #2563eb; outline-offset:2px; }
        .pos-bill { border-top:4px solid #3c83f6; }
        .pos-bill input[type=number] { min-width:64px; max-width:85px; }
        .pos-bill table { font-size:.85rem; }
        .pos-bill td { vertical-align:middle; }
        .pos-bill td input[type=text] { min-width:100px; }
        @media print {
            body * { visibility:hidden; }
            #receipt, #receipt * { visibility:visible; }
            #receipt { position:absolute; inset:0 auto auto 0; width:100%; }
            #receipt .print-hide { display:none; }
        }
    </style>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="MainContent">
    <asp:Label ID="message" runat="server" CssClass="alert alert-info d-block" Visible="false" role="status" />
    <asp:Panel ID="orderPanel" runat="server">
        <div class="d-flex flex-wrap justify-content-between gap-3 align-items-center mb-3">
            <h1 class="h3 mb-0">Bán hàng</h1>
            <div class="d-flex gap-2">
                <a class="btn btn-outline-primary" href="BanVaDatBan.aspx">Sơ đồ bàn &amp; Đặt chỗ</a>
                <a class="btn btn-outline-secondary" href="#invoiceHistory">Lịch sử hóa đơn</a>
            </div>
        </div>
        <div class="card card-body mb-3">
            <div class="row align-items-center g-3">
                <div class="col-md-6">
                    <asp:Label runat="server" AssociatedControlID="tables" CssClass="form-label fw-semibold" Text="Chọn bàn để bán hàng" />
                    <asp:DropDownList ID="tables" runat="server" CssClass="form-select" AutoPostBack="true" OnSelectedIndexChanged="CreateOrder" />
                    <asp:Button ID="openSelected" runat="server" CssClass="btn btn-primary mt-2" Visible="false" Text="Mở bàn này" OnClick="CreateOrder" />
                </div>
                <div class="col-md-6">
                    <p class="text-muted small mb-0">Chọn bàn trống để mở đơn. Chọn bàn đang phục vụ để gọi thêm món hoặc thanh toán.</p>
                </div>
            </div>
            <div style="display:none" aria-hidden="true">
                <asp:DropDownList ID="orders" runat="server" />
                <asp:DropDownList ID="drinks" runat="server" />
            </div>
        </div>
        <asp:Panel ID="emptyOrder" runat="server" CssClass="card card-body text-center py-5">
            <h2 class="h5">Chọn bàn để bắt đầu</h2>
            <p class="text-muted mb-0">Bạn cũng có thể mở bàn trực tiếp từ sơ đồ bàn.</p>
        </asp:Panel>
        <asp:Panel ID="servicePanel" runat="server" Visible="false">
            <div class="row g-3">
                <section class="col-xl-5 col-lg-5">
                    <div class="card card-body">
                        <h2 class="h5">Chọn món</h2>
                        <label class="visually-hidden" for="menuSearch">Tìm món hoặc danh mục</label>
                        <input id="menuSearch" type="search" class="form-control mb-3" placeholder="Tìm món hoặc danh mục..." oninput="filterMenu(this.value)" />
                        <div class="pos-menu">
                            <asp:Repeater ID="menu" runat="server" OnItemCommand="ChooseProduct">
                                <ItemTemplate>
                                    <div class="pos-menu-item" data-search='<%#: Eval("TenDoUong") + " " + Eval("TenDanhMuc") %>'>
                                        <asp:LinkButton runat="server" CssClass="pos-product w-100" CommandArgument='<%# Eval("MaDoUong") %>'>
                                            <img src='<%# ProductImage(Eval("HinhAnh")) %>' alt="" loading="lazy" onerror="this.onerror=null;this.src='Content/moon-logo.svg'" />
                                            <span class="small text-muted"><%#: Eval("TenDanhMuc") %></span>
                                            <strong><%#: Eval("TenDoUong") %></strong>
                                            <span class="text-primary fw-semibold"><%#: string.Format("{0:N0} đ",Eval("GiaBanHienTai")) %></span>
                                            <span class="small text-muted">+ Thêm 1 ly</span>
                                        </asp:LinkButton>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>
                        </div>
                        <p id="menuEmpty" class="text-muted mt-3 mb-0" hidden>Không tìm thấy món phù hợp.</p>
                    </div>
                </section>
                <section class="col-xl-7 col-lg-7">
                    <div class="card card-body pos-bill">
                        <div class="d-flex align-items-start justify-content-between gap-2 mb-3">
                            <div>
                                <h2 class="h5 mb-1"><asp:Label ID="tableTitle" runat="server" /></h2>
                                <asp:Label ID="orderCaption" runat="server" CssClass="small text-muted" />
                            </div>
                            <asp:Button ID="cancelEmpty" runat="server" CssClass="btn btn-sm btn-outline-secondary" Text="Đóng bàn trống" OnClick="CancelEmptyOrder" OnClientClick="return confirm('Đóng đơn chưa có món và trả bàn về trống?')" />
                        </div>
                        <div class="table-responsive">
                            <asp:GridView ID="lines" runat="server" AutoGenerateColumns="false" DataKeyNames="MaDoUong,SoLuong,GhiChuMon" CssClass="table align-middle"
                                EmptyDataText="Chạm vào món bên trái để thêm vào đơn." OnRowCommand="ChangeLine">
                                <Columns>
                                    <asp:BoundField DataField="TenDoUong" HeaderText="Món" />
                                    <asp:TemplateField HeaderText="SL">
                                        <ItemTemplate><asp:TextBox ID="lineQuantity" runat="server" Text='<%# Bind("SoLuong") %>' CssClass="form-control form-control-sm" TextMode="Number" min="1" max="999" aria-label="Số lượng" /></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField HeaderText="Ghi chú">
                                        <ItemTemplate><asp:TextBox ID="lineNote" runat="server" Text='<%# Bind("GhiChuMon") %>' CssClass="form-control form-control-sm" MaxLength="255" placeholder="Ít đá..." aria-label="Ghi chú món" /></ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ThanhTien" HeaderText="Tiền món" DataFormatString="{0:N0} đ" />
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:LinkButton runat="server" CommandName="SaveLine" CssClass="btn btn-sm btn-outline-primary">Lưu</asp:LinkButton>
                                            <asp:LinkButton runat="server" CommandName="RemoveLine" CssClass="btn btn-sm btn-outline-danger" OnClientClick="return confirm('Xóa món này khỏi đơn?')">Xóa</asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </div>
                        <p class="d-flex justify-content-between fw-bold fs-5"><span>Tạm tính</span><asp:Label ID="total" runat="server" /></p>
                        <div class="row g-2 border-top pt-3">
                            <div class="col-sm-6">
                                <label for="memberPhone" class="form-label">SĐT thành viên</label>
                                <input id="memberPhone" name="memberPhone" class="form-control" maxlength="15" placeholder="Khách lẻ để trống" value="<%: Request.Form["memberPhone"] %>" />
                            </div>
                            <% if (CanDiscount) { %>
                            <div class="col-sm-6">
                                <label for="discount" class="form-label">Giảm thêm (đ)</label>
                                <input id="discount" name="discount" class="form-control" type="number" min="0" step="1" value="<%: Request.Form["discount"] ?? "0" %>" />
                            </div>
                            <% } %>
                            <div class="col-12">
                                <label for="method" class="form-label">Phương thức thanh toán</label>
                                <select id="method" name="method" class="form-select">
                                    <option value="TienMat">Tiền mặt</option>
                                    <option value="ChuyenKhoan" <%: Request.Form["method"] == "ChuyenKhoan" ? "selected" : "" %>>Chuyển khoản</option>
                                </select>
                            </div>
                            <div class="col-12 mt-3">
                                <asp:Button ID="checkout" runat="server" CssClass="btn btn-primary btn-lg w-100" Text="Thanh toán" OnClick="PreviewPayment" />
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </asp:Panel>
        <section id="invoiceHistory" class="card card-body mt-4">
            <h2 class="h5">Lịch sử hóa đơn</h2>
            <div class="row g-2 align-items-end mb-3">
                <div class="col-md-4">
                    <label for="invoiceCode" class="form-label">Mã hóa đơn</label>
                    <input id="invoiceCode" name="invoiceCode" class="form-control" maxlength="30" value="<%: Request.Form["invoiceCode"] %>" />
                </div>
                <div class="col-md-4">
                    <label for="invoiceDate" class="form-label">Ngày thanh toán</label>
                    <input id="invoiceDate" name="invoiceDate" class="form-control" type="date" value="<%: Request.Form["invoiceDate"] %>" />
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
        <div class="modal fade" id="paymentModal" tabindex="-1" aria-labelledby="paymentHeading" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header"><h2 id="paymentHeading" class="h5 modal-title">Kiểm tra thanh toán</h2><button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Đóng"></button></div>
                    <div class="modal-body">
                        <asp:Label ID="paymentSummary" runat="server" />
                        <div id="cashTender">
                        <label for="received" class="form-label mt-3">Tiền khách đưa (đ, tùy chọn)</label>
                        <input id="received" name="received" type="number" min="0" step="1" class="form-control" oninput="showChange(this.value)" />
                        <p class="mt-2 mb-0" id="cashChange" role="status"></p>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Quay lại</button>
                        <asp:Button ID="confirmPayment" runat="server" CssClass="btn btn-success" Text="Đã nhận tiền · Hoàn tất" OnClick="Pay" />
                    </div>
                </div>
            </div>
        </div>
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
    <script>
        function filterMenu(value) {
            const normalize = text => text.toLocaleLowerCase('vi').normalize('NFD').replace(/[\u0300-\u036f]/g, '').replace(/đ/g, 'd');
            const query = normalize(value.trim());
            let count = 0;
            document.querySelectorAll('.pos-menu-item').forEach(item => {
                item.hidden = !normalize(item.dataset.search).includes(query);
                if (!item.hidden) count++;
            });
            document.getElementById('menuEmpty').hidden = count > 0;
        }
        function showChange(value) {
            const total = Number(document.getElementById('paymentAmount').dataset.amount);
            const received = Number(value);
            const line = document.getElementById('cashChange');
            line.textContent = value === '' ? '' : received < total
                ? 'Còn thiếu ' + (total-received).toLocaleString('vi-VN') + ' đ'
                : 'Tiền thối ' + (received-total).toLocaleString('vi-VN') + ' đ';
        }
    </script>
</asp:Content>
