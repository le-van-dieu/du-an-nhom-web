using System;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Web.UI;
using System.Xml.Linq;
using static N9_QLCAFE.CafeData;

namespace N9_QLCAFE
{
    public partial class _Default : Page
    {
        protected string Period { get; private set; }
        protected string FromDate { get; private set; }
        protected string ToDate { get; private set; }
        protected string ErrorMessage { get; private set; }
        protected string ReportCaption { get; private set; }
        protected DataTable Report { get; private set; }
        protected DataTable TopDrinks { get; private set; }
        protected decimal Revenue { get; private set; }
        protected decimal Cash { get; private set; }
        protected decimal Transfer { get; private set; }
        protected long OrderCount { get; private set; }
        protected long DrinkCount { get; private set; }
        private decimal maximum;

        protected void Page_Load(object sender, EventArgs e)
        {
            string today = DateTime.Today.ToString("yyyy-MM-dd");
            Period = Request.Form["period"] ?? "month";
            FromDate = Request.Form["fromDate"] ?? today;
            ToDate = Request.Form["toDate"] ?? today;

            DateTime start, end;
            if (!ParseDate(FromDate, out start) || (Period == "range" && !ParseDate(ToDate, out end)))
            {
                ErrorMessage = "Vui lòng chọn ngày hợp lệ.";
                return;
            }
            switch (Period)
            {
                case "day": end = start.AddDays(1); break;
                case "month": start = new DateTime(start.Year, start.Month, 1); end = start.AddMonths(1); break;
                case "year": start = new DateTime(start.Year, 1, 1); end = start.AddYears(1); break;
                case "range": ParseDate(ToDate, out end); end = end.AddDays(1); break;
                default: ErrorMessage = "Kỳ báo cáo không hợp lệ."; return;
            }
            if (start >= end)
            {
                ErrorMessage = "Ngày kết thúc phải từ ngày bắt đầu trở đi.";
                return;
            }

            ReportCaption = string.Format("{0:dd/MM/yyyy} – {1:dd/MM/yyyy}", start, end.AddDays(-1));
            string group = Period == "year" ? "DATEFROMPARTS(YEAR(NgayGioThanhToan),MONTH(NgayGioThanhToan),1)" : "CONVERT(date,NgayGioThanhToan)";
            Report = Query(@"SELECT " + group + @" AS Ngay,SUM(TienPhaiTra) AS DoanhThu,COUNT_BIG(*) AS SoDon,
                SUM(CASE WHEN PhuongThucThanhToan='TienMat' THEN TienPhaiTra ELSE 0 END) AS TienMat,
                SUM(CASE WHEN PhuongThucThanhToan='ChuyenKhoan' THEN TienPhaiTra ELSE 0 END) AS ChuyenKhoan
                FROM hoadon WHERE NgayGioThanhToan>=@start AND NgayGioThanhToan<@end GROUP BY " + group + " ORDER BY Ngay",
                Arg("@start", start), Arg("@end", end));
            var drinks = Query(@"SELECT d.MaDoUong,d.TenDoUong,SUM(CONVERT(bigint,c.SoLuong)) AS SoLuong
                FROM hoadon h JOIN chitietdonhang c ON c.MaDonHang=h.MaDonHang JOIN douong d ON d.MaDoUong=c.MaDoUong
                WHERE h.NgayGioThanhToan>=@start AND h.NgayGioThanhToan<@end
                GROUP BY d.MaDoUong,d.TenDoUong ORDER BY SoLuong DESC,d.MaDoUong",
                Arg("@start", start), Arg("@end", end));

            TopDrinks = drinks.Clone();
            foreach (DataRow row in drinks.Rows.Cast<DataRow>().Take(5))
                TopDrinks.ImportRow(row);
            Revenue = Report.AsEnumerable().Sum(row => row.Field<decimal>("DoanhThu"));
            Cash = Report.AsEnumerable().Sum(row => row.Field<decimal>("TienMat"));
            Transfer = Report.AsEnumerable().Sum(row => row.Field<decimal>("ChuyenKhoan"));
            OrderCount = Report.AsEnumerable().Sum(row => row.Field<long>("SoDon"));
            DrinkCount = drinks.AsEnumerable().Sum(row => row.Field<long>("SoLuong"));
            maximum = Report.AsEnumerable().Select(row => row.Field<decimal>("DoanhThu")).DefaultIfEmpty(0).Max();
        }

        protected int BarWidth(decimal amount)
        {
            return maximum > 0 ? (int)(100m * amount / maximum) : 0;
        }

        private static bool ParseDate(string value, out DateTime date)
        {
            return DateTime.TryParseExact(value, "yyyy-MM-dd", CultureInfo.InvariantCulture, DateTimeStyles.None, out date)
                && date.Year >= 1753 && date.Year <= 9998;
        }

        protected void ExportExcel(object sender, EventArgs e)
        {
            if (Report == null)
                return;

            var summary = new[]
            {
                new object[] { "Kỳ báo cáo", ReportCaption },
                new object[] { "Doanh thu", Revenue, "Đơn đã thanh toán", OrderCount, "Ly đã bán", DrinkCount },
                new object[] { "Kỳ", "Doanh thu", "Đơn", "Tiền mặt", "Chuyển khoản" }
            }.Concat(Report.AsEnumerable().Select(item => new object[] { item.Field<DateTime>("Ngay").ToString("yyyy-MM-dd"),
                item["DoanhThu"], item["SoDon"], item["TienMat"], item["ChuyenKhoan"] }));
            var top = new[] { new object[] { "Món", "Số lượng" } }
                .Concat(TopDrinks.AsEnumerable().Select(item => new[] { item["TenDoUong"], item["SoLuong"] }));

            Response.Clear();
            Response.ContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
            Response.AddHeader("Content-Disposition", "attachment; filename=doanh-thu.xlsx");
            using (var output = new MemoryStream())
            {
                using (var workbook = new ZipArchive(output, ZipArchiveMode.Create, true))
                {
                    XNamespace spreadsheet = "http://schemas.openxmlformats.org/spreadsheetml/2006/main";
                    XNamespace office = "http://schemas.openxmlformats.org/officeDocument/2006/relationships";
                    XNamespace package = "http://schemas.openxmlformats.org/package/2006/relationships";
                    XNamespace types = "http://schemas.openxmlformats.org/package/2006/content-types";
                    Func<string, string, string, XElement> link = (id, kind, target) => new XElement(package + "Relationship",
                        new XAttribute("Id", id), new XAttribute("Type", office.NamespaceName + "/" + kind), new XAttribute("Target", target));
                    Func<string, string, XElement> type = (path, kind) => new XElement(types + "Override",
                        new XAttribute("PartName", path), new XAttribute("ContentType", "application/vnd.openxmlformats-officedocument.spreadsheetml." + kind + "+xml"));

                    WriteEntry(workbook, "[Content_Types].xml", new XElement(types + "Types",
                        new XElement(types + "Default", new XAttribute("Extension", "rels"),
                            new XAttribute("ContentType", "application/vnd.openxmlformats-package.relationships+xml")),
                        type("/xl/workbook.xml", "sheet.main"), type("/xl/worksheets/sheet1.xml", "worksheet"),
                        type("/xl/worksheets/sheet2.xml", "worksheet")));
                    WriteEntry(workbook, "_rels/.rels", new XElement(package + "Relationships", link("rId1", "officeDocument", "xl/workbook.xml")));
                    WriteEntry(workbook, "xl/_rels/workbook.xml.rels", new XElement(package + "Relationships",
                        link("rId1", "worksheet", "worksheets/sheet1.xml"), link("rId2", "worksheet", "worksheets/sheet2.xml")));
                    WriteEntry(workbook, "xl/workbook.xml", new XElement(spreadsheet + "workbook", new XAttribute(XNamespace.Xmlns + "r", office),
                        new XElement(spreadsheet + "sheets",
                            new XElement(spreadsheet + "sheet", new XAttribute("name", "Doanh thu"), new XAttribute("sheetId", 1), new XAttribute(office + "id", "rId1")),
                            new XElement(spreadsheet + "sheet", new XAttribute("name", "Món bán chạy"), new XAttribute("sheetId", 2), new XAttribute(office + "id", "rId2")))));
                    WriteSheet(workbook, "xl/worksheets/sheet1.xml", spreadsheet, summary);
                    WriteSheet(workbook, "xl/worksheets/sheet2.xml", spreadsheet, top);
                }
                output.WriteTo(Response.OutputStream);
            }
            Response.End();
        }

        private static void WriteSheet(ZipArchive workbook, string path, XNamespace ns, IEnumerable<object[]> rows)
        {
            var sheet = new XElement(ns + "worksheet", new XElement(ns + "sheetData",
                rows.Select(row => new XElement(ns + "row", row.Select(value =>
                {
                    string text = Convert.ToString(value, CultureInfo.InvariantCulture);
                    return value is long || value is decimal
                        ? new XElement(ns + "c", new XElement(ns + "v", text))
                        : new XElement(ns + "c", new XAttribute("t", "inlineStr"), new XElement(ns + "is", new XElement(ns + "t", text)));
                })))));
            WriteEntry(workbook, path, sheet);
        }

        private static void WriteEntry(ZipArchive workbook, string path, XElement xml)
        {
            using (var entry = workbook.CreateEntry(path).Open())
                xml.Save(entry);
        }
    }
}
