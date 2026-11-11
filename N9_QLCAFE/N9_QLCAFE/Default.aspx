<%@ Page Title="Thống kê doanh thu" Language="C#" MasterPageFile="~/Site.Master" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="N9_QLCAFE._Default" %>
<asp:Content runat="server" ContentPlaceHolderID="HeadContent">
    <style>
        @media print { .app-sidebar, .app-topbar, footer, .report-actions { display: none !important; } .app-main { margin: 0 !important; } }
    </style>
</asp:Content>
<asp:Content runat="server" ContentPlaceHolderID="MainContent">
    <h1 class="h3">Thống kê doanh thu</h1>
    <div class="card card-body mb-3 report-actions">
        <div class="row g-2 align-items-end">
            <div class="col-md-2">
                <label class="form-label" for="period">Kỳ báo cáo</label>
                <select class="form-select" id="period" name="period">
                    <option value="day" <%: Period == "day" ? "selected" : "" %>>Ngày</option>
                    <option value="month" <%: Period == "month" ? "selected" : "" %>>Tháng</option>
                    <option value="year" <%: Period == "year" ? "selected" : "" %>>Năm</option>
                    <option value="range" <%: Period == "range" ? "selected" : "" %>>Khoảng ngày</option>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label" for="fromDate">Ngày tham chiếu / Từ ngày</label>
                <input type="date" class="form-control" id="fromDate" name="fromDate" value="<%: FromDate %>" />
            </div>
            <div class="col-md-2">
                <label class="form-label" for="toDate">Đến ngày</label>
                <input type="date" class="form-control" id="toDate" name="toDate" value="<%: ToDate %>" />
            </div>
            <div class="col-md-5 d-flex flex-wrap gap-2">
                <asp:Button runat="server" Text="Xem báo cáo" CssClass="btn btn-primary" />
                <asp:Button runat="server" Text="Tải Excel" CssClass="btn btn-outline-primary" OnClick="ExportExcel" />
                <button type="button" class="btn btn-outline-primary" onclick="window.print()">In / Lưu PDF</button>
            </div>
        </div>
    </div>
    <% if (ErrorMessage != null) { %><p class="alert alert-danger"><%: ErrorMessage %></p><% } %>
    <% if (Report != null) { %>
        <p><%: ReportCaption %></p>
        <div class="row g-3 mb-3">
            <div class="col-md-4"><div class="card card-body"><span>Doanh thu</span><strong class="fs-4"><%: Revenue.ToString("N0") %> đ</strong></div></div>
            <div class="col-md-4"><div class="card card-body"><span>Đơn đã thanh toán</span><strong class="fs-4"><%: OrderCount %></strong></div></div>
            <div class="col-md-4"><div class="card card-body"><span>Ly đã bán</span><strong class="fs-4"><%: DrinkCount %></strong></div></div>
        </div>
        <div class="row g-3">
            <section class="col-lg-7"><div class="card card-body">
                <h2 class="h5">Biểu đồ doanh thu</h2>
                <% if (Report.Rows.Count == 0) { %><p class="text-muted mb-0">Chưa có hóa đơn trong kỳ.</p><% } %>
                <% foreach (System.Data.DataRow row in Report.Rows) { %>
                    <div class="mb-2">
                        <div class="d-flex justify-content-between"><span><%: ((DateTime)row["Ngay"]).ToString(Period == "year" ? "MM/yyyy" : "dd/MM/yyyy") %></span><span><%: ((decimal)row["DoanhThu"]).ToString("N0") %> đ</span></div>
                        <div class="progress" style="height:8px"><div class="progress-bar" style="width:<%: BarWidth((decimal)row["DoanhThu"]) %>%"></div></div>
                    </div>
                <% } %>
            </div></section>
            <section class="col-lg-5"><div class="card card-body">
                <h2 class="h5">5 món bán chạy</h2>
                <% if (TopDrinks.Rows.Count == 0) { %><p class="text-muted mb-0">Chưa có món được bán trong kỳ.</p><% } %>
                <ol class="list-group list-group-numbered list-group-flush">
                    <% foreach (System.Data.DataRow row in TopDrinks.Rows) { %>
                        <li class="list-group-item"><%: row["TenDoUong"] %><span class="float-end"><%: row["SoLuong"] %> ly</span></li>
                    <% } %>
                </ol>
                <hr />
                <p class="mb-1">Tiền mặt <strong><%: Cash.ToString("N0") %> đ</strong></p>
                <p class="mb-0">Chuyển khoản <strong><%: Transfer.ToString("N0") %> đ</strong></p>
            </div></section>
        </div>
    <% } %>
</asp:Content>
