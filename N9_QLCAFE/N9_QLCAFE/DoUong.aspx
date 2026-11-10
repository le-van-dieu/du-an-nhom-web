
<%@ Page Title="Quản lý Đồ uống & Menu" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="DoUong.aspx.cs" Inherits="N9_QLCAFE.DoUong" %>

<asp:Content ID="Content1" ContentPlaceHolderID="HeadContent" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <!-- HEADER -->
    <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-3">
        <div>
            <span class="badge badge-soft-blue mb-1">Phân hệ F06 - F13 • Phụ trách: Nguyễn Anh Kỳ</span>
            <h4 class="fw-bold mb-0 text-dark">Quản lý Đồ uống & Danh mục Menu</h4>
        </div>
        <div class="d-flex gap-2">
            <button type="button" class="btn btn-cafe-outline" data-bs-toggle="modal" data-bs-target="#modalDanhMuc">
                <i class="bi bi-folder-plus me-1"></i>Quản lý Danh mục (F10)
            </button>
            <button type="button" class="btn btn-cafe-primary" data-bs-toggle="modal" data-bs-target="#modalThemDoUong" onclick="moFormThemDoUong();">
                <i class="bi bi-plus-lg me-1"></i>Thêm đồ uống mới (F06)
            </button>
        </div>
    </div>

    <!-- DỮ LIỆU DANH MỤC F10 -->
    <asp:SqlDataSource ID="dsDanhMucLoc" runat="server"
        ConnectionString="<%$ ConnectionStrings:quanlyquancafeConnectionString %>"
        SelectCommand="SELECT MaDanhMuc, TenDanhMuc FROM dbo.danhmuc ORDER BY MaDanhMuc">
    </asp:SqlDataSource>

    <!-- THANH TÌM KIẾM VÀ BỘ LỌC -->
    <div class="card-custom p-3 mb-4">
        <div class="row g-3 align-items-center">

            <!-- F09: TÌM KIẾM -->
            <div class="col-12 col-md-4">
                <div class="input-group">
                    <span class="input-group-text bg-light text-primary border-end-0">
                        <i class="bi bi-search"></i>
                    </span>
                    <asp:TextBox ID="txtTimKiem" runat="server"
                        CssClass="form-control border-start-0"
                        placeholder="Tìm theo tên hoặc mã đồ uống (F09)..."
                        AutoPostBack="true"
                        onkeydown="if(event.keyCode==13){event.preventDefault();this.blur();return false;}">
                    </asp:TextBox>
                </div>
            </div>

            <!-- F10: LỌC DANH MỤC -->
            <div class="col-6 col-md-3">
                <asp:DropDownList ID="ddlDanhMucLoc" runat="server"
                    CssClass="form-select"
                    DataSourceID="dsDanhMucLoc"
                    DataTextField="TenDanhMuc"
                    DataValueField="MaDanhMuc"
                    AppendDataBoundItems="true"
                    AutoPostBack="true">
                    <asp:ListItem Text="-- Tất cả danh mục (F10) --" Value="0" />
                </asp:DropDownList>
            </div>

            <!-- F12: LỌC TRẠNG THÁI -->
            <div class="col-6 col-md-3">
                <asp:DropDownList ID="ddlTrangThaiLoc" runat="server"
                    CssClass="form-select"
                    AutoPostBack="true">
                    <asp:ListItem Text="-- Trạng thái kinh doanh (F12) --" Value="TatCa" />
                    <asp:ListItem Text="Còn hàng (Đang bán)" Value="ConHang" />
                    <asp:ListItem Text="Hết hàng tạm thời" Value="HetHang" />
                    <asp:ListItem Text="Ngừng kinh doanh (F08)" Value="NgungKinhDoanh" />
                </asp:DropDownList>
            </div>

            <!-- F13: CHUYỂN KIỂU HIỂN THỊ -->
            <div class="col-12 col-md-2 text-md-end">
                <ul class="nav nav-pills nav-pills-blue justify-content-end" role="tablist">
                    <li class="nav-item" role="presentation">
                        <button class="nav-link active py-1 px-3" data-bs-toggle="tab" data-bs-target="#tabBang" type="button" title="Dạng bảng quản lý">
                            <i class="bi bi-table"></i>
                        </button>
                    </li>
                    <li class="nav-item" role="presentation">
                        <button class="nav-link py-1 px-3 me-0" data-bs-toggle="tab" data-bs-target="#tabLuoiMenu" type="button" title="Hiển thị Menu trực quan (F13)">
                            <i class="bi bi-grid-3x3-gap"></i> Menu (F13)
                        </button>
                    </li>
                </ul>
            </div>
        </div>
    </div>

    <div class="tab-content">

        <!-- TAB 1: BẢNG QUẢN LÝ ĐỒ UỐNG -->
        <div class="tab-pane fade show active" id="tabBang" role="tabpanel">
            <div class="card-custom">

                <!-- DỮ LIỆU ĐỒ UỐNG -->
                <asp:SqlDataSource ID="dsDoUong" runat="server"
                    ConnectionString="<%$ ConnectionStrings:quanlyquancafeConnectionString %>"
                    SelectCommand="
                        SELECT
                            du.MaDoUong,
                            du.TenDoUong,
                            du.GiaBanHienTai,
                            du.HinhAnh,
                            du.MoTa,
                            du.TrangThaiKinhDoanh,
                            dm.TenDanhMuc,

                            CASE
                                WHEN du.TrangThaiKinhDoanh = 'ConHang' THEN N'Còn hàng'
                                WHEN du.TrangThaiKinhDoanh IN ('HetHang', N'Hết hàng tạm thời') THEN N'Hết hàng tạm thời'
                                WHEN du.TrangThaiKinhDoanh IN ('NgungKinhDoanh', N'Ngừng kinh doanh') THEN N'Ngừng kinh doanh'
                                ELSE du.TrangThaiKinhDoanh
                            END AS TrangThaiHienThi,

                            CASE
                                WHEN du.TrangThaiKinhDoanh = 'ConHang' THEN 'badge badge-soft-success'
                                ELSE 'badge badge-soft-blue'
                            END AS TrangThaiCss

                        FROM dbo.douong du
                        INNER JOIN dbo.danhmuc dm ON du.MaDanhMuc = dm.MaDanhMuc

                        WHERE
                            (
                                LEN(LTRIM(RTRIM(ISNULL(@TuKhoa, N'')))) = 0
                                OR du.MaDoUong LIKE N'%' + LTRIM(RTRIM(ISNULL(@TuKhoa, N''))) + N'%'
                                OR du.TenDoUong LIKE N'%' + LTRIM(RTRIM(ISNULL(@TuKhoa, N''))) + N'%'
                            )
                            AND
                            (
                                @MaDanhMuc = 0 OR du.MaDanhMuc = @MaDanhMuc
                            )
                            AND
                            (
                                @TrangThai = 'TatCa'
                                OR (@TrangThai = 'ConHang' AND du.TrangThaiKinhDoanh = 'ConHang')
                                OR (@TrangThai = 'HetHang' AND du.TrangThaiKinhDoanh IN ('HetHang', N'Hết hàng tạm thời'))
                                OR (@TrangThai = 'NgungKinhDoanh' AND du.TrangThaiKinhDoanh IN ('NgungKinhDoanh', N'Ngừng kinh doanh'))
                            )
                        ORDER BY du.MaDoUong">

                    <SelectParameters>
                        <asp:ControlParameter Name="TuKhoa" ControlID="txtTimKiem"
                            PropertyName="Text" Type="String"
                            ConvertEmptyStringToNull="false" DefaultValue="" />

                        <asp:ControlParameter Name="MaDanhMuc" ControlID="ddlDanhMucLoc"
                            PropertyName="SelectedValue" Type="Int32" DefaultValue="0" />

                        <asp:ControlParameter Name="TrangThai" ControlID="ddlTrangThaiLoc"
                            PropertyName="SelectedValue" Type="String" DefaultValue="TatCa" />
                    </SelectParameters>
                </asp:SqlDataSource>

                <!-- ĐẾM TỔNG SẢN PHẨM -->
                <asp:SqlDataSource ID="dsTongDoUong" runat="server"
                    ConnectionString="<%$ ConnectionStrings:quanlyquancafeConnectionString %>"
                    SelectCommand="SELECT COUNT(*) AS TongSo FROM dbo.douong">
                </asp:SqlDataSource>

                <div class="card-header-custom">
                    <div>
                        <h6 class="fw-bold mb-0">Danh sách Đồ uống trong hệ thống</h6>
                        <small class="text-muted">Quy tắc: Mã đồ uống không trùng • Giá bán &gt; 0 • Đồ uống đã có giao dịch chỉ chuyển sang Ngừng kinh doanh</small>
                    </div>
                    <asp:Repeater ID="rpTongDoUong" runat="server" DataSourceID="dsTongDoUong">
                        <ItemTemplate>
                            <span class="badge badge-soft-blue">
                                Tổng: <%# Eval("TongSo") %> sản phẩm
                            </span>
                        </ItemTemplate>
                    </asp:Repeater>
                </div>

                <!-- BẢNG DANH SÁCH ĐỒ UỐNG -->
                <div class="table-responsive">
                    <table class="table table-cafe">
                        <thead>
                            <tr>
                                <th>Mã đồ uống</th>
                                <th>Hình ảnh</th>
                                <th>Tên đồ uống & Mô tả</th>
                                <th>Danh mục</th>
                                <th>Giá bán (F11)</th>
                                <th>Trạng thái (F12)</th>
                                <th class="text-end">Thao tác (F07, F08)</th>
                            </tr>
                        </thead>

                        <tbody>
                            <asp:Repeater ID="rpDoUong" runat="server"
                                DataSourceID="dsDoUong"
                                OnItemCommand="rpDoUong_ItemCommand">

                                <ItemTemplate>
                                    <tr>
                                        <td class="fw-semibold">
                                            <%# Eval("MaDoUong") %>
                                        </td>

                                        <td>
                                            <img src='<%# ResolveUrl("~/HinhAnh/") + Eval("HinhAnh") %>'
                                                alt='<%# Eval("TenDoUong") %>'
                                                style="width:48px;height:48px;object-fit:cover;border-radius:8px;"
                                                onerror="this.style.display='none';this.nextElementSibling.style.display='inline';" />
                                            <span class="small text-muted" style="display:none;">
                                                <%# Eval("HinhAnh") %>
                                            </span>
                                        </td>

                                        <td>
                                            <div class="fw-semibold">
                                                <%# Eval("TenDoUong") %>
                                            </div>
                                            <small class="text-muted">
                                                <%# Eval("MoTa") %>
                                            </small>
                                        </td>

                                        <td><%# Eval("TenDanhMuc") %></td>

                                        <td class="fw-semibold text-primary">
                                            <%# Eval("GiaBanHienTai", "{0:N0}") %> đ
                                        </td>

                                        <td>
                                            <span class='<%# Eval("TrangThaiCss") %>'>
                                                <%# Eval("TrangThaiHienThi") %>
                                            </span>
                                        </td>

                                        <!-- HAI NÚT CHỈNH SỬA VÀ XÓA -->
                                        <td class="text-end">
                                            <asp:LinkButton ID="btnSua" runat="server"
                                                CssClass="btn btn-sm btn-cafe-outline me-1"
                                                CommandName="Sua"
                                                CommandArgument='<%# Eval("MaDoUong") %>'
                                                CausesValidation="false">
                                                <i class="bi bi-pencil-square"></i> Chỉnh sửa
                                            </asp:LinkButton>

                                            <asp:LinkButton ID="btnXoa" runat="server"
                                                CssClass="btn btn-sm btn-outline-danger"
                                                CommandName="Xoa"
                                                CommandArgument='<%# Eval("MaDoUong") %>'
                                                CausesValidation="false"
                                                OnClientClick="return confirm('Bạn có chắc chắn muốn xóa đồ uống này? Nếu đồ uống đã có giao dịch, hệ thống sẽ chuyển sang Ngừng kinh doanh.');">
                                                <i class="bi bi-trash"></i> Xóa
                                            </asp:LinkButton>
                                        </td>
                                    </tr>
                                </ItemTemplate>

                            </asp:Repeater>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- TAB 2: MENU TRỰC QUAN F13 -->
        <div class="tab-pane fade" id="tabLuoiMenu" role="tabpanel">

            <asp:SqlDataSource ID="dsMenuConHang" runat="server"
                ConnectionString="<%$ ConnectionStrings:quanlyquancafeConnectionString %>"
                SelectCommand="
                    SELECT
                        du.MaDoUong,
                        du.TenDoUong,
                        du.GiaBanHienTai,
                        du.HinhAnh,
                        du.MoTa,
                        dm.TenDanhMuc
                    FROM dbo.douong du
                    INNER JOIN dbo.danhmuc dm ON du.MaDanhMuc = dm.MaDanhMuc
                    WHERE
                        du.TrangThaiKinhDoanh = 'ConHang'
                        AND
                        (
                            LEN(LTRIM(RTRIM(ISNULL(@TuKhoa, N'')))) = 0
                            OR du.MaDoUong LIKE N'%' + LTRIM(RTRIM(ISNULL(@TuKhoa, N''))) + N'%'
                            OR du.TenDoUong LIKE N'%' + LTRIM(RTRIM(ISNULL(@TuKhoa, N''))) + N'%'
                        )
                    ORDER BY du.MaDoUong">

                <SelectParameters>
                    <asp:ControlParameter Name="TuKhoa" ControlID="txtTimKiem"
                        PropertyName="Text" Type="String"
                        ConvertEmptyStringToNull="false" DefaultValue="" />
                </SelectParameters>
            </asp:SqlDataSource>

            <div class="card-custom p-3">
                <asp:ListView ID="lvMenuConHang" runat="server" DataSourceID="dsMenuConHang">
                    <LayoutTemplate>
                        <div class="row g-3">
                            <asp:PlaceHolder ID="itemPlaceholder" runat="server" />
                        </div>
                    </LayoutTemplate>

                    <ItemTemplate>
                        <div class="col-12 col-sm-6 col-lg-4">
                            <div class="card h-100 border-0 shadow-sm">
                                <img src='<%# ResolveUrl("~/HinhAnh/") + Eval("HinhAnh") %>'
                                    alt='<%# Eval("TenDoUong") %>'
                                    style="width:100%;height:180px;object-fit:cover;"
                                    onerror="this.style.display='none';this.nextElementSibling.style.display='flex';" />

                                <div class="bg-light text-muted align-items-center justify-content-center"
                                    style="height:180px;display:none;">
                                    <i class="bi bi-cup-hot fs-1"></i>
                                </div>

                                <div class="card-body">
                                    <div class="d-flex justify-content-between align-items-start mb-2">
                                        <span class="badge badge-soft-blue"><%# Eval("MaDoUong") %></span>
                                        <span class="badge badge-soft-success">Còn hàng</span>
                                    </div>

                                    <h6 class="fw-bold text-dark mb-2"><%# Eval("TenDoUong") %></h6>

                                    <div class="small text-muted mb-2">
                                        <i class="bi bi-folder2 me-1"></i><%# Eval("TenDanhMuc") %>
                                    </div>

                                    <p class="small text-muted mb-3"><%# Eval("MoTa") %></p>

                                    <div class="d-flex justify-content-between align-items-center border-top pt-3">
                                        <span class="small text-muted">Giá bán</span>
                                        <span class="fw-bold text-primary fs-5">
                                            <%# Eval("GiaBanHienTai", "{0:N0}") %> đ
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </ItemTemplate>

                    <EmptyDataTemplate>
                        <div class="p-5 text-center text-muted">
                            <i class="bi bi-cup-straw fs-1 d-block text-secondary mb-2 opacity-50"></i>
                            <div class="fw-semibold">Chưa có đồ uống nào còn hàng</div>
                            <small>Các món có trạng thái Còn hàng sẽ hiển thị tại đây.</small>
                        </div>
                    </EmptyDataTemplate>
                </asp:ListView>
            </div>
        </div>
    </div>

    <!-- MODAL THÊM / CHỈNH SỬA ĐỒ UỐNG -->
    <div class="modal fade" id="modalThemDoUong" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-primary text-white">
                    <h6 class="modal-title fw-bold">
                        <i class="bi bi-cup-hot me-2"></i>Thông tin Đồ uống (F06 / F07 / F11)
                    </h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>

                <div class="modal-body p-4">

                    <asp:HiddenField ID="hfCheDo" runat="server" ClientIDMode="Static" Value="Them" />

                    <div class="row g-3">
                        <div class="col-md-4">
                            <label class="form-label small fw-semibold">Mã đồ uống <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtMaDoUong" runat="server" ClientIDMode="Static"
                                CssClass="form-control" placeholder="VD: DU001 (Không trùng)" />
                        </div>

                        <div class="col-md-8">
                            <label class="form-label small fw-semibold">Tên đồ uống <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtTenDoUong" runat="server" ClientIDMode="Static"
                                CssClass="form-control" placeholder="Nhập tên đồ uống..." />
                        </div>

                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Danh mục đồ uống (F10) <span class="text-danger">*</span></label>
                            <asp:DropDownList ID="ddlDanhMucForm" runat="server"
                                ClientIDMode="Static"
                                CssClass="form-select"
                                DataSourceID="dsDanhMucLoc"
                                DataTextField="TenDanhMuc"
                                DataValueField="MaDanhMuc">
                            </asp:DropDownList>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Giá bán (VNĐ - Lớn hơn 0) (F11) <span class="text-danger">*</span></label>
                            <asp:TextBox ID="txtGiaBan" runat="server" ClientIDMode="Static"
                                CssClass="form-control" TextMode="Number" placeholder="VD: 35000" />
                        </div>

                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Hình ảnh minh họa</label>
                            <input type="file" class="form-control" />
                            <small class="text-muted">Khi chỉnh sửa, hình ảnh hiện tại được giữ nguyên.</small>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label small fw-semibold">Trạng thái kinh doanh (F12)</label>
                            <asp:DropDownList ID="ddlTrangThaiForm" runat="server"
                                ClientIDMode="Static" CssClass="form-select">
                                <asp:ListItem Text="Còn hàng (Đang phục vụ)" Value="ConHang" />
                                <asp:ListItem Text="Hết hàng tạm thời" Value="HetHang" />
                                <asp:ListItem Text="Ngừng kinh doanh (F08)" Value="NgungKinhDoanh" />
                            </asp:DropDownList>
                        </div>

                        <div class="col-12">
                            <label class="form-label small fw-semibold">Mô tả công thức / hương vị</label>
                            <asp:TextBox ID="txtMoTa" runat="server" ClientIDMode="Static"
                                CssClass="form-control" TextMode="MultiLine" Rows="3"
                                placeholder="Nhập mô tả chi tiết sản phẩm..." />
                        </div>
                    </div>
                </div>

                <div class="modal-footer bg-light">
                    <button type="button" class="btn btn-sm btn-secondary" data-bs-dismiss="modal">Hủy bỏ</button>

                    <asp:LinkButton ID="btnLuuDoUong" runat="server"
                        CssClass="btn btn-sm btn-cafe-primary"
                        OnClick="btnLuuDoUong_Click"
                        CausesValidation="false">
                        <i class="bi bi-save me-1"></i>Lưu thông tin đồ uống
                    </asp:LinkButton>
                </div>
            </div>
        </div>
    </div>

    <!-- MODAL QUẢN LÝ DANH MỤC -->
    <div class="modal fade" id="modalDanhMuc" tabindex="-1" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered">
            <div class="modal-content border-0 shadow">
                <div class="modal-header bg-primary text-white">
                    <h6 class="modal-title fw-bold">
                        <i class="bi bi-folder2-open me-2"></i>Quản lý Danh mục Đồ uống (F10)
                    </h6>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body p-4">
                    <div class="input-group mb-3">
                        <input type="text" class="form-control" placeholder="Nhập tên danh mục mới..." />
                        <button class="btn btn-cafe-primary" type="button">
                            <i class="bi bi-plus-lg"></i> Thêm
                        </button>
                    </div>

                    <table class="table table-sm table-cafe border">
                        <thead>
                            <tr>
                                <th>Mã DM</th>
                                <th>Tên danh mục</th>
                                <th class="text-center">Số món</th>
                                <th class="text-end">Xử lý</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td colspan="4" class="text-center text-muted py-4">
                                    <small>Chưa có danh mục nào. Hãy nhập tên danh mục và nhấn Thêm.</small>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        function moFormThemDoUong() {
            document.getElementById("hfCheDo").value = "Them";
            document.getElementById("txtMaDoUong").value = "";
            document.getElementById("txtTenDoUong").value = "";
            document.getElementById("txtGiaBan").value = "";
            document.getElementById("txtMoTa").value = "";
            document.getElementById("txtMaDoUong").readOnly = false;
            document.getElementById("ddlDanhMucForm").selectedIndex = 0;
            document.getElementById("ddlTrangThaiForm").value = "ConHang";
        }
    </script>

</asp:Content>
