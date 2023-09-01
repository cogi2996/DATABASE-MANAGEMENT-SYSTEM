--------------------------------------Chuc Nang-------------------------------------------
use [NLBank]
GO

-- 1. Cap nhap ho so 

--Thêm khách hàng
CREATE OR ALTER PROCEDURE sp_ThemKhachHang(
    @Ten nvarchar(50) = NULL ,
    @Dia_chi nvarchar(50) = NULL ,
    @Email char(50) = NULL,
    @Sdt char(11) = NULL,
	@RoleID tinyint = 0,
	@PassWd nchar(38),
--CaNhan roleID = 0
	@NgaySinh date NULL,
	@CCCD char(12) NULL,
--Doanh Nghiep roleID = 1
	@MaDN char(50)
)
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			INSERT INTO KHACHHANG
				(Ten, Dia_chi, Email, Sdt, RoleID)
			VALUES
				(@Ten, @Dia_chi, @Email, @Sdt, @RoleID)
	
			INSERT INTO Authenciation
				(Email, Passwd, RoleID)
			VALUES 
				(@Email, @PassWd, @RoleID)
			
			DECLARE @MaKH int
			SET @MaKH = (SELECT MAX(MaKH) FROM KHACHHANG)

			IF @RoleID = 0 
				INSERT INTO CANHAN
					(MaKH, NgaySinh, CCCD)
				VALUES 
					(@MaKH, @NgaySinh, @CCCD);

			IF @RoleID = 1
				INSERT INTO DOANHNGHIEP
					(MaKH, MADN)
				VALUES
					(@MaKH, @MaDN)
			COMMIT TRANSACTION
		END TRY
		BEGIN CATCH
			PRINT N'Có lỗi dữ liệu'
			ROLLBACK TRANSACTION
			RETURN 0
		END CATCH
END
GO

--Xóa khách hàng
CREATE OR ALTER PROCEDURE sp_XoaKhachHang(
    @MaKH int
)
AS
BEGIN
    DELETE FROM KHACHHANG WHERE MaKH = @MaKH
END
GO

-- Chỉnh sửa khách hàng
CREATE OR ALTER PROCEDURE sp_SuaKhachHang(
    @MaKH int,
    @Ten nvarchar(50) = NULL ,
    @Dia_chi nvarchar(50) = NULL ,
    @Email char(50) = NULL,
    @Sdt char(11) = NULL
)
AS
BEGIN	
	BEGIN TRAN
		BEGIN TRY
			DECLARE @OldEmail char(50) = (SELECT Email FROM KHACHHANG WHERE MaKH = @MaKH)
			IF @Email <> @OldEmail
				BEGIN
					DECLARE @Valid bit
					SET @Valid = (SELECT dbo.f_TonTaiEmail(@Email)) 
					IF @Valid = 1
						RETURN -- Tồn tại email
				END
			UPDATE KHACHHANG SET
				Ten = @Ten,
				Dia_chi = @Dia_chi,
				Email = @Email,
				Sdt = @Sdt
			WHERE MaKH = @MaKH

			DECLARE @AuthID int = (SELECT id FROM Authenciation WHERE Email = @OldEmail)

			UPDATE Authenciation
			SET
				Email = @Email
			WHERE @AuthID = ID

			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
		END CATCH
END
GO

CREATE OR ALTER PROC sp_SuaCaNhan(@MaKH int, @NgaySinh date, @CCCD char(12), @FICO_score int)
AS
BEGIN
	UPDATE CANHAN
	SET
		NgaySinh = @NgaySinh,
		CCCD = @CCCD,
		FICO_score = @FICO_score
	WHERE @MaKH = MaKH
END
GO

CREATE OR ALTER PROC sp_SuaDoanhNghiep(@MaKH int, @MaDN char(50), @DnB_rating int)
AS
BEGIN
	UPDATE DOANHNGHIEP
	SET
		MADN = @MaDN,
		DnB_rating = @DnB_rating
	WHERE 
		MaKH = @MaKH
END
GO

-- 2. Quan ly khoan vay : KHOANVAY(MaKV, MaKH, SoHDTD, MaLoaiKV, SoTienVay, LoaiTien)
-- a. Cap nhap khoan vay 

-- Tao khoan vay 
CREATE OR ALTER PROCEDURE sp_ThemKhoanVay(
    @MaKH int = NULL, 
	@MaTSDB int = NULL,
    @MaLoaiKV int = NULL ,
	@MucDich nvarchar(38) = NULL,
    @SoTienVay int = NULL,
    @LoaiTien char(4) = NULL 
)
AS
BEGIN
    INSERT INTO KHOANVAY
        (MaKH ,MaTSDB , MaLoaiKV, MucDich , SoTienVay, LoaiTien)
    VALUES(@MaKH , @MaTSDB , @MaLoaiKV , @MucDich, @SoTienVay, @LoaiTien)
END
GO

-- Xoa khoan vay 
CREATE OR ALTER PROCEDURE sp_XoaKhoanVay(
    @MaKV int
)
AS
BEGIN
    DELETE FROM KHOANVAY WHERE MaKV = @MaKV
END 
GO

-- Chinh sua khoan vay 
CREATE OR ALTER PROCEDURE sp_SuaKhoanVay(
    @MaKV int ,
    @MaKH int = NULL ,
	@MaTSDB int = NULL,
    @MaLoaiKV int  = NULL ,
	@MucDich nvarchar(38) = NULL,
    @SoTienVay int = NULL,
    @LoaiTien char(4) = NULL 
)
AS
BEGIN
    UPDATE  KHOANVAY SET 
                MaKH = @MaKH,
				MaTSDB = @MaTSDB,
                MaLoaiKV =  @MaLoaiKV , 
				MucDich = @MucDich,
                SoTienVay = @SoTienVay,
				LoaiTien = @LoaiTien 
            WHERE MaKV = @MaKV
END
GO

-- Tạo loại khoản vay
CREATE OR ALTER PROC sp_ThemLoaiKhoanVay(@TenKV nvarchar(MAX))
AS
BEGIN
	INSERT INTO LOAIKV(TenKV)
	VALUES (@TenKV)
END
GO

-- Cập nhật loại khoản vay
CREATE OR ALTER PROC sp_ThemLoaiKhoanVay(@TenLoaiKV int, @MaLoaiKV int)
AS
BEGIN
	UPDATE LOAIKV
	SET
		TenKV = @TenLoaiKV
	WHERE MaLoaiKV = @MaLoaiKV
END
GO

-- Xóa loại khoản vay
CREATE OR ALTER PROC sp_ThemLoaiKhoanVay(@MaLoaiKV int)
AS
BEGIN
	DELETE LOAIKV
	WHERE MaLoaiKV = @MaLoaiKV
END
GO

--Thêm giấy nhận nợ
CREATE OR ALTER PROC sp_ThemGiayNhanNo
	@HDTDCode int,
	@guestCode int,
	@signDate datetime,
	@branchCode int,
	@creditLimit int,
	@promiseDate datetime,
	@overTimeRate decimal,
	@originRate decimal
AS
BEGIN
INSERT INTO GIAYNHANNO(SoHDTD, MaKH, NgayKyGNN, MaCN, HanMucTinDung, HanTraNo, LaiQuaHan, LaiSuat)
	VALUES (@HDTDCode, @guestCode, @signDate, @branchCode, @creditLimit, @promiseDate, @overTimeRate, @originRate)
END
GO

--Chỉnh sửa giấy nhân nợ
CREATE OR ALTER PROC sp_CapNhatGiayNhanNo (
	@DebtCode int,
	@HDTDCode int,
	@guestCode int,
	@signDate datetime,
	@branchCode int,
	@creditLimit int,
	@promiseDate datetime,
	@overTimeRate decimal,
	@originRate decimal
)
AS
BEGIN
UPDATE GIAYNHANNO
SET
	MaKH = @guestCode,
	NgayKyGNN = @signDate,
	MaCN = @branchCode,
	HanMucTinDung = @creditLimit,
	HanTraNo = @promiseDate,
	LaiQuaHan = @overTimeRate,
	LaiSuat = @originRate
WHERE SoGNN = @DebtCode and SoHDTD = @HDTDCode
END
GO

--Xóa giấy nhận nợ
CREATE OR ALTER PROC sp_XoaGiayNhanNo (@SoGNN int, @SoHDTD int)
AS
BEGIN
	DELETE FROM GIAYNHANNO
	WHERE SoGNN = @SoGNN and SoHDTD = @SoHDTD
END
GO

-- b. Quan ly tai san dam bao  
-- TAISANDAMBAO(MaTSDB, MaKH, SoHDTD, MaLoaiTSDB, TenTSDB, TriGiaTS, HinhThucDB)

-- Them TSDB
CREATE OR ALTER PROCEDURE sp_ThemTaiSanDamBao(
    @MaLoaiTSDB int = NULL,
    @TenTSDB nvarchar(50) = NULL,
    @MaKH int = NULL,
    @TriGiaTS int = NULL,
    @HinhThucDB nvarchar(50) = NULL
)
AS
BEGIN
    INSERT INTO TAISANDAMBAO
        (MaLoaiTSDB , TenTSDB , MaKH , TrigiaTS , HinhThucDB)
    VALUES(@MaLoaiTSDB , @TenTSDB , @MaKH , @TrigiaTS , @HinhThucDB)
END 
GO

-- Xoa TSDB
CREATE OR ALTER PROCEDURE sp_XoaTaiSanDamBao(
    @MaTSDB int
)
AS
BEGIN
    DELETE FROM TAISANDAMBAO WHERE MaTSDB = @MaTSDB
END 
GO

-- Chinh sua TSDB
CREATE OR ALTER PROCEDURE sp_SuaTaiSanDamBao(
    @MaTSDB int,
    @MaLoaiTSDB int  = NULL,
    @TenTSDB nvarchar(50)  = NULL,
    @MaKH int = NULL,
    @TriGiaTS int = NULL,
    @HinhThucDB nvarchar(50) = NULL
)
AS
BEGIN
    UPDATE  TAISANDAMBAO SET 
                MaLoaiTSDB = @MaLoaiTSDB ,
                TenTSDB = @TenTSDB ,
                MaKH = @MaKH  , 
                TriGiaTS = @TriGiaTS  , 
                HinhThucDB = @HinhThucDB 
            WHERE MaTSDB = @MaTSDB
END 
GO

--Đối với loại tài sản đảm bảo

--Thêm loại tài sản
CREATE OR ALTER PROC sp_themLoaiTaiSan(
	@TenLoaiTS nvarchar(MAX)
)
AS
	INSERT INTO LOAITSDB VALUES (@TenLoaiTS)
GO

--Xóa loại tài sản
CREATE OR ALTER PROC sp_xoaLoaiTaiSan(
	@MaLoaiTS int
)
AS
	DELETE LOAITSDB WHERE MaLoaiTSDB = @MaLoaiTS
GO

--Cập nhật loại tài sản
CREATE OR ALTER PROC sp_capNhatLoaiTaiSan(
	@MaLoaiTS int,
	@TenLoaiTS nvarchar(MAX)
)
AS
	UPDATE LOAITSDB
	SET
		TenLoaiTSDB = @TenLoaiTS
	WHERE MaLoaiTSDB = @MaLoaiTS
GO

-- c . Hợp đồng tín dụng 

-- Them HDTD
CREATE OR ALTER PROCEDURE sp_ThemHopDongTinDung(
    @MaKH int = NULL,
    @MaKV int = NULL,
    @Muc_dich nvarchar(MAX)  = NULL,
    @LaiSuat decimal(4,2)  = NULL,
    @LaiQuaHan decimal(4,2)  = NULL,
    @ThoiHanVay int  = NULL,
    @PhuongThucTra char(50) = NULL,
    @MucPhi int = NULL,
    @TGGiaiNgan DATE = NULL,
    @LoaiTien char(4) = NULL,
    @NgayKi DATE = NULL
)
AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			DECLARE @Valid bit = (SELECT dbo.f_TonTaiKV(@MaKV))
			IF @Valid = 1
				RETURN 'Khoản vay này đã được sử dụng'

			INSERT INTO HDTD
				(MaKH, MaKV, Muc_dich, LaiSuat, LaiQuaHan, ThoiHanVay, PhuongThucTra, MucPhi, TGGiaiNgan, LoaiTien, NgayKi)
			VALUES
				(@MaKH, @MaKV, @Muc_dich, @LaiSuat, @LaiQuaHan, @ThoiHanVay, @PhuongThucTra, @MucPhi, @TGGiaiNgan, @LoaiTien, @NgayKi)
		
			DECLARE @SoHDTD int
			SET @SoHDTD = (SELECT MAX(SoHDTD) FROM HDTD)

			DECLARE @MaChiNhanh int = (SELECT TOP 1 MaCN FROM CHINHANH),
					@SoTienVay BIGINT = (SELECT SoTienVay FROM KHOANVAY WHERE MaKV = @MaKV),
					@NgayThuNoGoc date = @NgayKi,
					@NgayThuNoLai date = @NgayKi
	
			DECLARE @SoDuNo BIGINT = (SELECT MucPhi + @SoTienVay FROM HDTD WHERE SoHDTD = @SoHDTD)
			
			EXEC sp_ThemCTGN @SoHDTD, @MaChiNhanh, @SoTienVay
			EXEC sp_ThemCTTN @SoHDTD, @MaChiNhanh, @NgayThuNoGoc, @NgayThuNoLai, @SoDuNo, 0, @SoTienVay, @NgayThuNoGoc

			COMMIT TRAN
		END TRY
		BEGIN CATCH
			PRINT 'Có lỗi xảy ra'
			ROLLBACK TRAN
		END CATCH
END 
GO

-- Xoa HDTD 
CREATE OR ALTER PROCEDURE sp_XoaHopDongTinDung(
    @SoHDTD int
)
AS
BEGIN
    DELETE FROM HDTD WHERE SoHDTD = @SoHDTD
END 
GO

-- Chinh sua HDTD
CREATE OR ALTER PROCEDURE sp_SuaHopDongTinDung(
    @SoHDTD int ,
    @MaKH int = NULL,
    @MaKV int = NULL,
    @Muc_dich nvarchar(MAX)  = NULL,
    @LaiSuat decimal(4,2)  = NULL,
    @LaiQuaHan decimal(4,2) = NULL ,
    @ThoiHanVay int  = NULL ,
    @PhuongThucTra char(50) = NULL ,
    @MucPhi int = NULL,
    @TGGiaiNgan DATE = NULL,
    @LoaiTien char(4) = NULL,
    @NgayKi DATE = NULL
)
AS
BEGIN
    UPDATE HDTD SET   
		MaKH = @MaKH, 
		MaKV = @MaKH, 
		Muc_dich = @Muc_dich  ,
		LaiSuat  = @LaiSuat,
		LaiQuaHan = @LaiQuaHan,
		ThoiHanVay = @ThoiHanVay,
		PhuongThucTra = @PhuongThucTra,
		MucPhi = @MucPhi, 
		TGGiaiNgan = @TGGiaiNgan, 
		LoaiTien = @LoaiTien, 
		NgayKi = @NgayKi  
	WHERE SoHDTD = @SoHDTD
END 
GO 

CREATE OR ALTER FUNCTION f_HDTDQuaHanBaoLau(@SoHDTD int) RETURNS INT
AS
BEGIN
	IF (SELECT dbo.f_LaHDTDQuaHan(@SoHDTD)) = 0
		RETURN 0
	
	DECLARE @Result INT,
			@NgayCuoi DATE,
			@ThoiHanVay INT,
			@NgayKy DATE

	SELECT 
		@ThoiHanVay = ThoiHanVay,
		@NgayKy = NgayKi
	FROM HDTD hd WHERE hd.SoHDTD = @SoHDTD

	SET @NgayCuoi = DATEADD(DAY, @ThoiHanVay, @NgayKy)

	SET @Result = DATEDIFF(month, @NgayCuoi, GETDATE())

	RETURN @Result
END
GO

-- d. Cac chung tu
-- Chung tu thu no

--Thêm chứng từ thu nợ
CREATE OR ALTER PROC sp_ThemCTTN
	@SoHDTD int,
	@MaCN int,
	@SoTienTra BIGINT
AS
BEGIN
--INSERT INTO CHUNGTUTHUNO(SoHDTD, MaCN, KyThuNoGoc, KyThuNoLai, SoDuNo, SoTienTra, SoDuNoGoc, NgayThuNo)
--VALUES (@SoHDTD, @branchCode, @originalSign, @raisedSign, @leftMoney, @payBackMoney, @leftDebt, @payBackDate)
	BEGIN TRAN
		BEGIN TRY
			DECLARE
					@SoDuNo BIGINT,
					@SoDuNoGoc BIGINT,
					@KyThuNoGoc DATE,
					@KyThuNoLai DATE,
					@NgayThuNo DATE,
					@SoTienLai float,
					@SoNgayDaVay BIGINT,
					@LaiSuat decimal(5, 2),
					@LaiQuaHan decimal(5, 2)

			SELECT TOP 1  @SoDuNo = SoDuNo,  @KyThuNoGoc = NgayThuNo, @SoDuNoGoc = SoDuNoGoc 
			FROM CHUNGTUTHUNO 
			WHERE SoHDTD = @SoHDTD 
			ORDER BY SoCTThuNo DESC


			SET @KyThuNoLai = @KyThuNoGoc
			SET @NgayThuNo = GETDATE()

			SELECT @LaiSuat = LaiSuat, @LaiQuaHan = LaiQuaHan FROM HDTD WHERE @SoHDTD = SoHDTD
	
			DECLARE @MonthDiff int = (SELECT DATEDIFF(month, @KyThuNoLai, @NgayThuNo)),
					@MonthDiffQuaHan int = (SELECT dbo.f_HDTDQuaHanBaoLau(@SoHDTD))

			IF (SELECT dbo.f_LaHDTDQuaHan(@SoHDTD)) = 1
				SET @MonthDiff = @MonthDiff - @MonthDiffQuaHan

			SET @SoTienLai = @SoDuNoGoc*(((@LaiSuat/(12*100))*@MonthDiff + (@LaiQuaHan/(12*100))*@MonthDiffQuaHan))

			SET @SoDuNo = @SoTienLai + @SoDuNo - @SoTienTra
			SET @SoDuNo = (SELECT IIF(@SoDuNo >= 0, @SoDuNo, 0))
			SET	@SoDuNoGoc = (SELECT IIF(@SoTienTra > @SoTienLai, @SoDuNoGoc - (@SoTienTra - @SoTienLai), @SoDuNoGoc))
			SET @SoDuNoGoc = (SELECT IIF(@SoDuNoGoc >= 0, @SoDuNoGoc, 0))

			INSERT INTO CHUNGTUTHUNO(SoHDTD, MaCN, KyThuNoGoc, KyThuNoLai, SoDuNo, SoTienTra, SoDuNoGoc, NgayThuNo)
				VALUES (@SoHDTD, @MaCN, @KyThuNoGoc, @KyThuNoLai, @SoDuNo, @SoTienTra, @SoDuNoGoc, @NgayThuNo)
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			ROLLBACK TRAN
 		END CATCH
END
GO

--Sửa chứng từ thu nợ
CREATE OR ALTER PROC sp_CapNhatCTTN (
	@payBackCode int,
	@HDTDCode int,
	@branchCode int,
	@originalSign date,
	@raisedSign date,
	@leftMoney int,
	@payBackMoney int,
	@leftDebt int,
	@payBackDate date)
AS
BEGIN
	UPDATE CHUNGTUTHUNO
	SET
		MaCN = @branchCode,
		KyThuNoGoc = @originalSign,
		KyThuNoLai = @raisedSign,
		SoDuNo = @leftMoney,
		SoTienTra = @payBackMoney,
		SoDuNoGoc = @leftDebt,
		NgayThuNo = @payBackDate
	WHERE SoCTThuNo = @payBackCode AND SoHDTD = @HDTDCode
	END
go

--Xóa chứng từ thu nợ
CREATE OR ALTER PROC sp_XoaCTTN (@SoCTTN int, @SoHDTD int)
AS
BEGIN
	DELETE FROM CHUNGTUTHUNO
	WHERE SoCTThuNo = @SoCTTN AND SoHDTD = @SoHDTD
	END
GO

-- Chung tu giai ngan

--Thêm chứng từ giải ngân
CREATE OR ALTER PROC sp_ThemCTGN
	@HDTDCode int,
	@branchCode int,
	@moneyDisbursement int
AS
BEGIN
	INSERT INTO CHUNGTUGIAINGAN(SoHDTD, MaCN, SoTienGiaiNgan)
		VALUES (@HDTDCode, @branchCode, @moneyDisbursement)
END
GO

--Sửa chứng từ giải ngân
CREATE OR ALTER PROC sp_CapNhatCTGN (
	@disbursementCode int, 
	@HDTDCode char(36), 
	@branchCode char(36), 
	@moneyDisbursement int
)
AS
BEGIN
	UPDATE CHUNGTUGIAINGAN
	SET
		MaCN = @branchCode, 
		SoTienGiaiNgan = @moneyDisbursement,
		SoHDTD = @HDTDCode
	WHERE 
		SoCTGN = @disbursementCode
END
GO

--Xóa chứng từ giải ngân
CREATE OR ALTER PROC sp_deleteDisbursementPaper (
	@disbursementCode int
)
AS
BEGIN
	DELETE FROM CHUNGTUGIAINGAN
	WHERE SoCTGN = @disbursementCode
END
GO

--5. Quản lý nhân viên - chức vụ

-- a. Thêm
CREATE OR ALTER PROCEDURE sp_themNhanVien(
	@CCCD char(12),
	@Ten nvarchar(50),
	@DiaChi nvarchar(50),
	@Email char(50),
	@Sdt char(11),
	@MaCV int,
	@PassWd nchar(38)
) AS
BEGIN
	BEGIN TRAN
		BEGIN TRY
			INSERT INTO NHANVIEN( CCCD, Ten, Dia_chi, Email, Sdt, MaCV) 
			VALUES (@CCCD, @Ten, @DiaChi, @Email, @Sdt, @MaCV)

			INSERT INTO Authenciation(Email, Passwd, RoleID)
			VALUES (@Email, @PassWd, 2)

			COMMIT TRAN
		END TRY
		BEGIN CATCH
			Print N'Có lỗi dữ liệu'
			ROLLBACK TRANSACTION
			RETURN 0
		END CATCH 
END
GO

-- b. Xóa Nhân viên
CREATE OR ALTER PROCEDURE sp_XoaNhanVien(
	@MaNV int
) AS
BEGIN
	BEGIN TRAN 
		BEGIN TRY
			DELETE FROM NHANVIEN WHERE MaNV = @MaNV 
			DELETE FROM Authenciation WHERE Email = (select email FROM NHANVIEN WHERE MaNV = @MaNV)
			
			COMMIT TRAN
		END TRY
		BEGIN CATCH
			PRINT 'Xóa bị lỗi'
			ROLLBACK TRAN
			RETURN 0
		END CATCH
END
GO

-- c.Cập nhật nhân viên
CREATE OR ALTER PROCEDURE sp_CapNhatNhanVien(
	@MaNV int,
	@CCCD char(12),
	@Ten nvarchar(50),
	@DiaChi nvarchar(50),
	@Email char(50),
	@Sdt char(11),
	@MaCV int
) AS
BEGIN
	UPDATE NHANVIEN SET 
		CCCD = @CCCD,
		Ten = @Ten,
		Dia_chi = @DiaChi,
		Sdt = @Sdt,
		MaCV = @MaCV
	WHERE MaNV = @MaNV
END
GO

-- d. Thêm chức vụ
CREATE OR ALTER PROC sp_themChucVu(
	@TenCV nvarchar(50),
	@HSLuong decimal(4,2)
) AS
BEGIN
	INSERT INTO CHUCVU(TenCV, HSLuong)
	VALUES (@TenCV, @HSLuong)
END
GO

-- e. Xóa chức vụ
CREATE OR ALTER PROC sp_xoaChucVu(
	@MaCV int
) AS
BEGIN
	DELETE FROM CHUCVU WHERE MaCV = @MaCV
END
GO

-- f. Sửa chức vụ
CREATE OR ALTER PROC sp_suaChucVu(
	@MaCV int,
	@TenCV nvarchar(50),
	@HSLuong decimal(4,2)
) AS
BEGIN
	UPDATE CHUCVU
	SET 
		TenCV = @TenCV, 
		HSLuong = @HSLuong
	WHERE MaCV = @MaCV
END
GO

-- 6.	Chi nhánh

-- a. Thêm
CREATE OR ALTER PROC sp_themChiNhanh(
	@TenChiNhanh nvarchar(MAX),
	@DiaChi nvarchar(MAX)
)
AS
BEGIN
	INSERT INTO CHINHANH(Chi_nhanh, Dia_chi)
	VALUES (@TenChiNhanh, @DiaChi)
END
GO

-- b. Xoá
CREATE OR ALTER PROC sp_xoaChiNhanh(
	@MaCN int
)
AS
BEGIN
	DELETE FROM CHINHANH WHERE MaCN = @MaCN
END
GO

-- c. Sửa
CREATE OR ALTER PROC sp_suaChiNhanh(
	@MaCN int,
	@TenChiNhanh nvarchar(MAX),
	@DiaChi nvarchar(MAX)
)
AS
BEGIN
	UPDATE CHINHANH 
	SET 
		Chi_nhanh = @TenChiNhanh,
		Dia_chi = @DiaChi
	WHERE MaCN = @MaCN
END
GO

-- 7.Điều khoản

-- a. Thêm
CREATE OR ALTER PROC sp_themDieuKhoan(
	@NoiDung nvarchar(max), 
	@pct decimal(5, 2), 
	@phi int
)
AS
BEGIN
	INSERT INTO DIEUKHOAN(NoiDung, Pct_lai, phi)
	VALUES (@NoiDung, @pct, @phi)
END
GO

-- b. Xoá
CREATE OR ALTER PROC sp_xoaDieuKhoan(
	@MaDK int
)
AS
BEGIN
	DELETE FROM DIEUKHOAN WHERE MaDK = @MaDK
END
GO

-- c. Sửa
CREATE OR ALTER PROC sp_suaDieuKhoan(
	@MaDK int,
	@NoiDung nvarchar(max),
	@pct decimal(5,2),
	@phi int
)
AS
BEGIN
	UPDATE DIEUKHOAN SET 
		NoiDung = @NoiDung,
		Pct_lai = @pct,
		Phi = @phi
	WHERE @MaDK = MaDK
END
GO

