using System;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using System.Text.RegularExpressions;
using System.Web.Script.Serialization;
using System.Web.UI;
using static N9_QLCAFE.CafeData;

namespace N9_QLCAFE
{
    public partial class KiemThuNghiemThu : Page
    {
        private const string BackupIdPattern = @"\A[0-9]{14}_[a-f0-9]{8}\z";
        private const string BackupLocation = @"DECLARE @folder nvarchar(260)=COALESCE(
                CONVERT(nvarchar(260),SERVERPROPERTY('InstanceDefaultBackupPath')),
                CONVERT(nvarchar(260),SERVERPROPERTY('InstanceDefaultDataPath')));
            IF RIGHT(@folder,1)<>N'\' SET @folder+=N'\';
            DECLARE @backup nvarchar(400)=@folder+N'quanlyquancafe_'+@id+N'.bak';";

        protected void CreateBackup(object sender, EventArgs e)
        {
            string id = DateTime.Now.ToString("yyyyMMddHHmmss") + "_" + Guid.NewGuid().ToString("N").Substring(0, 8);
            try
            {
                Execute(BackupLocation + " BACKUP DATABASE quanlyquancafe TO DISK=@backup WITH COPY_ONLY,CHECKSUM;",
                    Arg("@id", id));
                Show("Đã sao lưu. Mã bản sao lưu " + id + ".");
            }
            catch (SqlException)
            {
                Show("SQL Server không thể tạo bản sao lưu. Kiểm tra quyền BACKUP DATABASE và thư mục lưu.");
            }
        }

        protected void RestoreBackup(object sender, EventArgs e)
        {
            string id = (Request.Form["backupId"] ?? "").Trim();
            if (!Regex.IsMatch(id, BackupIdPattern))
            {
                Show("Nhập mã bản sao lưu được cấp khi tạo backup.");
                return;
            }
            try
            {
                Execute(BackupLocation + @" USE master;
                    DECLARE @target sysname=N'quanlyquancafe_restore_'+@id;
                    IF DB_ID(@target) IS NOT NULL THROW 50001,N'Bản sao đã được phục hồi.',1;
                    DECLARE @dataFolder nvarchar(260)=CONVERT(nvarchar(260),SERVERPROPERTY('InstanceDefaultDataPath'));
                    DECLARE @logFolder nvarchar(260)=CONVERT(nvarchar(260),SERVERPROPERTY('InstanceDefaultLogPath'));
                    IF RIGHT(@dataFolder,1)<>N'\' SET @dataFolder+=N'\';
                    IF RIGHT(@logFolder,1)<>N'\' SET @logFolder+=N'\';
                    DECLARE @data nvarchar(400)=@dataFolder+@target+N'.mdf';
                    DECLARE @log nvarchar(400)=@logFolder+@target+N'.ldf';
                    RESTORE DATABASE @target FROM DISK=@backup WITH CHECKSUM, RECOVERY,
                        MOVE 'quanlyquancafe' TO @data, MOVE 'quanlyquancafe_log' TO @log;", Arg("@id", id));
                Show("Đã phục hồi vào cơ sở dữ liệu quanlyquancafe_restore_" + id + ".");
            }
            catch (SqlException eSql)
            {
                Show(eSql.Number == 50001 ? eSql.Message : "SQL Server không thể phục hồi. Kiểm tra mã backup và quyền RESTORE.");
            }
        }

        protected void SaveIssue(object sender, EventArgs e)
        {
            string area = Request.Form["issueArea"] ?? "";
            string title = (Request.Form["issueTitle"] ?? "").Trim();
            string severity = Request.Form["issueSeverity"] ?? "";
            string details = (Request.Form["issueDetails"] ?? "").Trim();
            if (title.Length == 0 || title.Length > 160 || details.Length > 4000
                || !Regex.IsMatch(area, @"\A(sanpham|datban|pos|hethong)\z") || !Regex.IsMatch(severity, @"\A(cao|trungbinh|thap)\z"))
            {
                Show("Kiểm tra phân hệ, tiêu đề, mức độ và mô tả lỗi.");
                return;
            }
            string id = Guid.NewGuid().ToString("N");
            string folder = Server.MapPath("~/App_Data/Issues");
            try
            {
                Directory.CreateDirectory(folder);
                var serializer = new JavaScriptSerializer();
                File.WriteAllText(Path.Combine(folder, id + ".json"), serializer.Serialize(new
                {
                    Id = id, Area = area, Title = title, Severity = severity, Details = details,
                    CreatedBy = User.Identity.Name, CreatedUtc = DateTime.UtcNow
                }));
                Show("Đã lưu phiếu báo lỗi " + id + ".");
            }
            catch (IOException)
            {
                Show("Không thể lưu phiếu báo lỗi vào thư mục dữ liệu.");
            }
            catch (UnauthorizedAccessException)
            {
                Show("Ứng dụng chưa có quyền ghi phiếu báo lỗi.");
            }
        }

        private void Show(string text)
        {
            issueMessage.Text = Server.HtmlEncode(text);
            issueMessage.Visible = true;
        }
    }
}
