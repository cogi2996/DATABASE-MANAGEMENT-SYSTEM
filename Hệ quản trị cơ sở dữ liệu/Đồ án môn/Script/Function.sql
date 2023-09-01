--------------------------------------Hàm-------------------------------------------
use [NLBank]
GO
-------1. Khách hàng

--Kiểm tra đã tồn tại Email
CREATE OR ALTER FUNCTION f_TonTaiEmail(@email nchar(50) = NULL) RETURNS BIT
AS
BEGIN
	IF EXISTS (SELECT * FROM Authenciation WHERE Email = @email)
		RETURN 'TRUE' 
	RETURN 'FALSE'
END
GO

--Kiểm tra đã tồn tại CCCD
CREATE OR ALTER FUNCTION f_TonTaiCCCD(@CCCD nchar(36) = NULL) RETURNS BIT
AS
BEGIN
	IF EXISTS (SELECT * FROM CANHAN WHERE CCCD = @CCCD)
		RETURN 'TRUE' 
	RETURN 'FALSE'
END
GO

--Kiểm tra đã tồn tại mã DN
CREATE OR ALTER FUNCTION f_TonTaiMaDN(@MaDN nchar(36) = NULL) RETURNS BIT
AS
BEGIN
	IF EXISTS (SELECT * FROM DOANHNGHIEP WHERE MADN = @MaDN) AND (@MaDN <> NULL)
		RETURN 'TRUE'
	RETURN 'FALSE'
END
GO

--Lấy các khách hàng theo id khách hàng
CREATE OR ALTER FUNCTION f_GetKHByID(@MaKH int) RETURNS TABLE
AS 
RETURN (SELECT *
	FROM KHACHHANG
	WHERE KHACHHANG.MaKH = @MaKH
)
GO

--Lấy khách hàng theo email
CREATE OR ALTER FUNCTION f_GetKHByEmail(@Email char(50)) RETURNS TABLE
AS 
RETURN (SELECT * 
	FROM KHACHHANG 
	WHERE Email = @Email
)
GO

--Lấy các khách hàng theo số điện thoại
CREATE OR ALTER FUNCTION f_GetKHBySDT(@Sdt char(11)) RETURNS TABLE
AS RETURN (SELECT *
	FROM KHACHHANG
	WHERE KHACHHANG.Sdt = @Sdt)
GO

CREATE OR ALTER FUNCTION f_LayCaNhan(@MaKH int) RETURNS TABLE
AS 
	RETURN SELECT * FROM CANHAN WHERE MaKH = @MaKH
GO

CREATE OR ALTER FUNCTION f_LayDoanhNghiep(@MaKH int) RETURNS TABLE
AS 
	RETURN SELECT * FROM DOANHNGHIEP WHERE MaKH = @MaKH
GO

--Lấy cá nhân hoặc doanh nghiệp từ khách hàng
CREATE OR ALTER PROC sp_LayCaNhanHayDoanhNghiep(@MaKH int, @RoleID int)
AS
BEGIN
	IF @RoleID = 0 RETURN SELECT * FROM CANHAN WHERE @MaKH = MaKH
	IF @RoleID = 1 RETURN SELECT * FROM DOANHNGHIEP WHERE @MaKH = MaKH
END
GO

-------2. Khoản vay

-- Lay khoan vay theo MaKV 
CREATE OR ALTER FUNCTION f_GetKVByID(@MaKV int) RETURNS TABLE
AS RETURN (SELECT * FROM KHOANVAY WHERE KHOANVAY.MaKV = @MaKV)	 
GO

-- Lay khoan vay theo MaKH 
CREATE OR ALTER FUNCTION f_GetKVByMaKH(@MaKH int) RETURNS TABLE
AS RETURN (SELECT * FROM KHOANVAY WHERE KHOANVAY.MaKH = @MaKH)
GO

-- Lay khoan vay theo SoHDTD 
CREATE OR ALTER FUNCTION f_GetKVBySoHDTD(@SoHDTD int) RETURNS TABLE
AS 
RETURN 
	SELECT 
		kv.MaKV, kv.MaLoaiKV, kv.MaKH, kv.MaTSDB, kv.SoTienVay, kv.LoaiTien 
	FROM KHOANVAY kv INNER JOIN 
		(SELECT 
			HDTD.MAKV
		FROM HDTD WHERE HDTD.SoHDTD = @SoHDTD) hdtd ON kv.MaKV = hdtd.MAKV
GO

-------3. Tài Sản Đảm Bảo

-- Lay TSDB theo MaKH 
CREATE OR ALTER FUNCTION f_GetTSDBById(@MaTSDB int) RETURNS TABLE
AS RETURN (SELECT * FROM TAISANDAMBAO WHERE TAISANDAMBAO.MaTSDB = @MaTSDB)	 
GO

-- Lay khoan vay theo MaKH 
CREATE OR ALTER FUNCTION f_GetTSDBByMaKH(@MaKH int) RETURNS TABLE
AS RETURN (SELECT * FROM TAISANDAMBAO WHERE TAISANDAMBAO.MaKH = @MaKH)
GO

-- Lay tai san dam bao theo SoHDTD 
CREATE OR ALTER FUNCTION f_GetTSDBBySoHDTD(@SoHDTD int) RETURNS TABLE
AS RETURN (
	WITH Q AS (
		SELECT kv.MaKV, tsdb.MaKH, tsdb.MaTSDB, tsdb.MaLoaiTSDB, tsdb.TenTSDB, tsdb.HinhThucDB, tsdb.TrigiaTS
		FROM KHOANVAY kv INNER JOIN TAISANDAMBAO tsdb ON kv.MaTSDB = tsdb.MaTSDB
	)
	SELECT Q.MaTSDB, Q.MaLoaiTSDB, Q.MaKH, Q.TenTSDB, Q.TrigiaTS, Q.HinhThucDB FROM Q INNER JOIN (SELECT * FROM HDTD WHERE HDTD.SoHDTD = @SoHDTD) hdtd ON Q.MaKV = hdtd.MAKV
)
GO

-------4. Hợp đồng tín dụng

-- Kiểm tra khoản vay đã được sử dụng hay chưa
CREATE OR ALTER FUNCTION f_TonTaiKV(@MaKV int) RETURNS BIT
BEGIN
	IF EXISTS (SELECT * FROM HDTD WHERE MAKV = @MaKV)
		RETURN 'TRUE'
	RETURN 'FALSE'
END
GO

-- Lay HDTD theo SoHDTD 
CREATE OR ALTER FUNCTION f_GetHDTDById(@SoHDTD int) RETURNS TABLE
AS RETURN (SELECT * FROM HDTD WHERE HDTD.SoHDTD = @SoHDTD)
GO

-- Lay HDTD theo MaKH 
CREATE OR ALTER FUNCTION f_GetHDTDByMaKH(@MaKH int) RETURNS TABLE
AS RETURN (SELECT * FROM HDTD WHERE HDTD.MaKH = @MaKH)
GO

-- Lay HDTD theo SoHDTD 
CREATE OR ALTER FUNCTION f_GetHDTDByMaKV(@MaKV int) RETURNS TABLE
AS RETURN (SELECT * FROM HDTD WHERE HDTD.MaKV = @MaKV) 
GO 

-- Lay cac HDTD da qua han vay 
CREATE OR ALTER FUNCTION f_GetHDTDOverDate() RETURNS TABLE
AS RETURN (SELECT 
                kv.SoTienVay , kv.LoaiTien,
                HDTD.NgayKi , HDTD.TGGiaiNgan , HDTD.LaiQuaHan , HDTD.LaiSuat ,
                kh.Ten 
            FROM HDTD  
            JOIN KHOANVAY kv on kv.MaKV = HDTD.MAKV 
            JOIN KHACHHANG kh on kh.MaKH = HDTD.MaKH
            WHERE  DATEADD(day, HDTD.ThoiHanVay, HDTD.TGGiaiNgan) > CURRENT_TIMESTAMP ) 
GO 

-------5. Báo cáo số dư

--Tổng nợ một người
CREATE OR ALTER FUNCTION dbo.f_TongNoCuaKH (@MaKH int) RETURNS BIGINT
AS
BEGIN
	DECLARE @sum bigint = 0;
	SELECT @sum = SUM(KHOANVAY.SoTienVay)
	FROM HDTD JOIN KHOANVAY ON HDTD.MAKV = KHOANVAY.MaKV
	WHERE HDTD.MaKH = @MaKH
	RETURN @sum
END
GO

--Tổng giải ngân một người
CREATE OR ALTER FUNCTION dbo.f_TongGiaiNganCuaKH (@MaKH int) RETURNS BIGINT
AS
BEGIN
	DECLARE @sum bigint = 0;
	SELECT @sum = SUM(CHUNGTUGIAINGAN.SoTienGiaiNgan)
	FROM HDTD JOIN CHUNGTUGIAINGAN ON HDTD.SoHDTD = CHUNGTUGIAINGAN.SoHDTD
	WHERE HDTD.MaKH = @MaKH
	RETURN @sum
END
GO

--Tổng nợ đã trả một người
CREATE OR ALTER FUNCTION dbo.f_TongNoDaTraCuaKH (@MaKH int) RETURNS BIGINT
AS
BEGIN
	DECLARE @sum bigint = 0;
	SELECT @sum = SUM(CHUNGTUTHUNO.SoTienTra)
	FROM HDTD JOIN CHUNGTUTHUNO ON HDTD.SoHDTD = CHUNGTUTHUNO.SoHDTD
	WHERE HDTD.MaKH = @MaKH
	RETURN @sum
END
GO

--Tổng số hợp đồng của một người
CREATE OR ALTER FUNCTION dbo.f_TongSoHopDongCuaKH(@MaKH int) RETURNS INT
AS 
BEGIN
	DECLARE @sum int = 0;
	SELECT @sum = COUNT(*)
	FROM HDTD WHERE MaKH = @MaKH
	RETURN @sum
END
GO

--Thống kê nợ toàn bộ khách hàng
CREATE OR ALTER FUNCTION dbo.f_ThongKeNo() RETURNS TABLE
AS
RETURN 
	SELECT COUNT(kh.MaKH) AS totalUser, SUM(dbo.f_TongNoCuaKH(kh.MaKH)) AS totalDebt, SUM(dbo.f_TongGiaiNganCuaKH(kh.MaKH)) AS totalDisburse,
			SUM (dbo.f_TongNoDaTraCuaKH(kh.MaKH)) AS totalPayBack
	FROM KHACHHANG AS kh
	WHERE EXISTS (SELECT * FROM KHACHHANG JOIN HDTD ON kh.MaKH = hdtd.MaKH)
GO

--Thống kê nợ một khách hàng
CREATE OR ALTER FUNCTION dbo.f_ThongKeNoCuaKH(@MaKH int) RETURNS TABLE 
AS 
RETURN 
	SELECT dbo.f_TongSoHopDongCuaKH(kh.MaKH) AS totalContract ,dbo.f_TongNoCuaKH(kh.MaKH) AS totalDebt, dbo.f_TongGiaiNganCuaKH(kh.MaKH) AS totalDisburse,
			dbo.f_TongNoDaTraCuaKH(kh.MaKH) AS totalPayBack
	FROM KHACHHANG AS kh
	WHERE kh.MaKH = @MaKH
GO

------6. Báo cáo nợ quá hạn

--Kiểm tra quá hạn của một hợp đồng
CREATE OR ALTER FUNCTION dbo.f_LaHDTDQuaHan(@SoHDTD int) RETURNS BIT 
AS
BEGIN
	DECLARE @result int = 0,
			@signDate datetime,
			@numberOfDate int;
		SELECT @signDate = HDTD.NgayKi, @numberOfDate = HDTD.ThoiHanVay
		FROM HDTD 
		WHERE HDTD.SoHDTD = @SoHDTD
		IF(DATEDIFF(day, @signDate, CONVERT(date, GETDATE())) > @numberOfDate)
			SET @result = 1;

	RETURN @result
END
GO

--Kiểm tra số tiền nợ chưa trả của một hợp đồng
CREATE OR ALTER FUNCTION dbo.f_TienChuaTraCuaHDTD(@SoHDTD int) RETURNS BIGINT
AS
BEGIN
DECLARE @remain bigint = 0;
	SELECT @remain = KHOANVAY.SoTienVay - SUM(CHUNGTUTHUNO.SoTienTra)
	FROM HDTD JOIN KHOANVAY ON HDTD.MAKV = KHOANVAY.MaKV
			JOIN CHUNGTUTHUNO ON HDTD.SoHDTD = CHUNGTUTHUNO.SoHDTD
	WHERE HDTD.SoHDTD = @SoHDTD
	GROUP BY HDTD.LaiQuaHan, HDTD.LaiSuat, HDTD.LoaiTien, HDTD.MaKH, HDTD.MaKH, HDTD.MAKV, HDTD.Muc_dich, HDTD.NgayKi, HDTD.PhuongThucTra, HDTD.SoHDTD, HDTD.TGGiaiNgan, HDTD.ThoiHanVay,
	KHOANVAY.MaKH,KHOANVAY.MaKV, KHOANVAY.MaLoaiKV, KHOANVAY.SoTienVay
RETURN @remain
END
GO

--Liệt kê các hợp đồng quá hạn của một người dùng
CREATE OR ALTER FUNCTION dbo.f_HDQuaHanCuaKH(@MaKH int) RETURNS TABLE
AS
RETURN
SELECT kh.MaKH, HDTD.SoHDTD, dbo.f_TienChuaTraCuaHDTD(HDTD.SoHDTD) AS remainMoney
	FROM KHACHHANG AS kh JOIN HDTD ON kh.MaKH = HDTD.MaKH
	WHERE kh.MaKH = @MaKH
	AND EXISTS (SELECT * FROM KHACHHANG JOIN HDTD ON kh.MaKH = hdtd.MaKH) 
	AND dbo.f_LaHDTDQuaHan(HDTD.SoHDTD) = 1
GO

--Thống kê các khoản nợ quá hạn
CREATE OR ALTER FUNCTION dbo.f_ThongKeNoQuaHan() RETURNS TABLE
AS
RETURN
SELECT count(distinct kh.MaKH) AS totalOTuser, count(HDTD.SoHDTD) AS totalOTcontract, sum(dbo.f_TienChuaTraCuaHDTD(HDTD.SoHDTD)) AS remainMoney
	FROM KHACHHANG AS kh JOIN HDTD ON kh.MaKH = HDTD.MaKH
	WHERE EXISTS (SELECT * FROM KHACHHANG JOIN HDTD ON kh.MaKH = hdtd.MaKH) 
	AND dbo.f_LaHDTDQuaHan(HDTD.SoHDTD) = 1
GO

--Thông tin người dùng quá hạn
CREATE OR ALTER FUNCTION dbo.f_ThongTinKHQuaHan(@MaKH int) RETURNS TABLE
AS
RETURN
SELECT kh.MaKH, kh.Ten, kh.Dia_chi, kh.Sdt, kh.Email, dbo.f_TienChuaTraCuaHDTD(HDTD.SoHDTD) AS remainMoney,
		HDTD.SoHDTD, HDTD.ThoiHanVay, HDTD.NgayKi
	FROM KHACHHANG AS kh JOIN HDTD ON kh.MaKH = HDTD.MaKH
	WHERE kh.MaKH = @MaKH
	AND EXISTS (SELECT * FROM KHACHHANG JOIN HDTD ON kh.MaKH = hdtd.MaKH) 
	AND dbo.f_LaHDTDQuaHan(HDTD.SoHDTD) = 1
GO

------7. Nhân viên

--Lấy Nhân viên theo email
CREATE OR ALTER FUNCTION f_GetNVByEmail(@email nchar(50))
RETURNS TABLE
AS
RETURN SELECT * FROM NHANVIEN WHERE Email = @email
GO

-------8. Chức năng đăng nhập

--Tìm role id trong email đăng nhập
CREATE OR ALTER FUNCTION f_login_getRoleID(@email nchar(50), @passwd char(38)) RETURNS int
AS
BEGIN
	DECLARE @temp table(email nchar(50), passwd char(38), roleID int)
	INSERT INTO @temp SELECT Email, Passwd, RoleID FROM Authenciation WHERE email = @email

	IF NOT EXISTS(SELECT * FROM @temp) 
		RETURN -1 --Không tồn tại tài khoản

	IF @passwd <> (SELECT passwd FROM @temp WHERE email = @email)
		RETURN -2 --Mật khẩu không đúng

	DECLARE @RoleID int = (SELECT RoleID FROM @temp WHERE Email = @email)
	--Nếu role ID là 0 và 1 thì đăng nhập vào khách hàng bằng GetKHByEmail
	--Nếu role ID là 2 thì đăng nhập vào nhân viên bằng GetNVByEmail
	RETURN @RoleID
END
GO

--Lấy các khoản vay chưa sử dụng trong hợp đồng tín dụng
CREATE OR ALTER FUNCTION f_KVChuaSuDung() RETURNS TABLE
RETURN
	SELECT * FROM KHOANVAY kv WHERE (NOT EXISTS (SELECT * FROM HDTD WHERE HDTD.MAKV = kv.MaKV)) 
GO

--Lấy các khoản vay đã sử dụng trong hợp đồng tín dụng
CREATE OR ALTER FUNCTION f_KVDaSuDung() RETURNS TABLE
RETURN
	SELECT * FROM KHOANVAY kv WHERE (EXISTS (SELECT * FROM HDTD WHERE HDTD.MAKV = kv.MaKV)) 
GO

--Kiểm tra khoản vay có đang sử dụng
CREATE OR ALTER FUNCTION f_LaKVDangSuDung(@MaKV int) RETURNS BIT
AS
BEGIN
	IF EXISTS(SELECT * FROM HDTD WHERE HDTD.MAKV = @MaKV)
		RETURN 'TRUE'
	RETURN 'FALSE'
END
GO

