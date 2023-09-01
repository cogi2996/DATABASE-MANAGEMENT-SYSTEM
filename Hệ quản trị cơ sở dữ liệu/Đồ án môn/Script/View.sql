----------------------------------------------VIEW------------------------------------------------------------
use [NLBank]
GO

--Thong tin khach hang ca nhan 1.1
CREATE OR ALTER VIEW [dbo].[ThongTinCaNhan]
AS
    SELECT kh.MaKH, kh.Ten, kh.Dia_chi, kh.Email, kh.Sdt, kh.Email as clientEmail, cn.CCCD, cn.NgaySinh, cn.FICO_score
    FROM KHACHHANG as kh join CANHAN as cn on kh.MaKH = cn.MaKH 
go

--Thong tin khach hang doanh nghiep 1.1
CREATE OR ALTER VIEW [dbo].[ThongTinDoanhNghiep]
AS
    SELECT kh.MaKH, kh.Ten, kh.Dia_chi, kh.Email, kh.Sdt, kh.Email as clientEmail, dn.MADN, dn.DnB_rating
    FROM KHACHHANG as kh join DOANHNGHIEP as dn on kh.MaKH = dn.MaKH 
GO

--Hop dong cho vay 1.2
CREATE OR ALTER view [dbo].[HopDong]
As
	With tsdb_kv AS (
		SELECT 
			MaKV, TenTSDB, TrigiaTS, HinhThucDB, MaLoaiTSDB, SoTienVay, LoaiTien 
		FROM 
			KHOANVAY kv 
		LEFT JOIN 
			TAISANDAMBAO ts ON kv.MaTSDB = ts.MaTSDB
		)
    Select 
		kh.Ten, kh.MaKH,
        HDTD.SoHDTD, HDTD.Muc_dich, HDTD.LaiSuat, HDTD.LaiQuaHan, HDTD.ThoiHanVay, HDTD.PhuongThucTra,
        HDTD.MucPhi, HDTD.TGGiaiNgan, HDTD.NgayKi,
        tsdb_kv.SoTienVay, tsdb_kv.LoaiTien,
        lts.TenLoaiTSDB, tsdb_kv.TenTSDB, tsdb_kv.TrigiaTS, tsdb_kv.HinhThucDB
    From 
		HDTD full join tsdb_kv on HDTD.MAKV = tsdb_kv.MaKV
        join KHACHHANG as kh on HDTD.MaKH = kh.MaKH
        join LOAITSDB as lts ON lts.MaLoaiTSDB = tsdb_kv.MaLoaiTSDB
GO

--Giay no 1.3
CREATE OR ALTER view [dbo].[GiayNo]
As
	With tsdb AS (
		SELECT MaKV, TenTSDB, TrigiaTS, HinhThucDB, MaLoaiTSDB FROM KHOANVAY kv LEFT JOIN TAISANDAMBAO ts ON kv.MaTSDB = ts.MaTSDB
	)
    Select 
		gnn.SoGNN, kh.Ten, kh.MaKH,
        HDTD.SoHDTD, HDTD.LaiSuat, HDTD.LaiQuaHan, HDTD.ThoiHanVay, HDTD.PhuongThucTra, HDTD.LoaiTien,
        HDTD.NgayKi,
        kv.SoTienVay,
        gnn.HanMucTinDung, gnn.NgayKyGNN
    From 
		HDTD join GIAYNHANNO as gnn on gnn.SoHDTD =HDTD.SoHDTD
        join KHACHHANG as kh on HDTD.MaKH = kh.MaKH
        join KHOANVAY as kv on HDTD.MAKV = kv.MaKV
        join tsdb on HDTD.MAKV= tsdb.MaKV
GO

--Giay giai ngan 1.4
CREATE OR ALTER view [dbo].[GiayGiaiNgan]
As
    Select 
		ctgn.SoCTGN, kh.Ten, kh.MaKH,
        HDTD.SoHDTD, HDTD.TGGiaiNgan,
        cn.Chi_nhanh,
        ctgn.SoTienGiaiNgan
    From 
		HDTD join CHUNGTUGIAINGAN as ctgn on ctgn.SoHDTD =HDTD.SoHDTD
        join KHACHHANG as kh on HDTD.MaKH = kh.MaKH
        join CHINHANH as cn on ctgn.MaCN = cn.MaCN
GO

--Giay nhac no 1.5
CREATE OR ALTER VIEW [dbo].[GiayNhacNo]
As
	With tsdb AS (
		SELECT 
			MaKV, TenTSDB, TrigiaTS, HinhThucDB, MaLoaiTSDB 
		FROM KHOANVAY kv LEFT JOIN TAISANDAMBAO ts ON kv.MaTSDB = ts.MaTSDB
		)
    Select 
		gnn.SoGNN, kh.Ten, kh.MaKH,
        HDTD.SoHDTD, HDTD.LaiSuat, HDTD.LaiQuaHan, HDTD.ThoiHanVay, HDTD.PhuongThucTra, HDTD.LoaiTien,
        HDTD.NgayKi,
        kv.SoTienVay,
        gnn.HanMucTinDung, gnn.NgayKyGNN,
        cn.Chi_nhanh,
        gnn.NgayKyGNN as NgayNN
    From 
		HDTD join GIAYNHANNO as gnn on gnn.SoHDTD =HDTD.SoHDTD
        join KHACHHANG as kh on HDTD.MaKH = kh.MaKH
        join KHOANVAY as kv on HDTD.MAKV = kv.MaKV
        join tsdb on HDTD.MAKV = tsdb.MaKV,
        CHINHANH as cn
    Where cn.MaCN = gnn.MaCN
GO

--Giay thu no 1.6
CREATE OR ALTER VIEW [dbo].[payBackPaper]
As
	With cttn_cn AS (
		SELECT cttn.SoCTThuNo, cttn.KyThuNoGoc, cttn.KyThuNoLai, cttn.SoDuNo, cttn.SoTienTra, cttn.SoHDTD , cn.Chi_nhanh, cttn.NgayThuNo FROM CHUNGTUTHUNO cttn INNER JOIN CHINHANH cn ON cttn.MaCN = cn.MaCN 
	)
    Select 
		cttn.SoCTThuNo, kh.Ten, kh.MaKH,
        HDTD.SoHDTD, HDTD.LaiSuat, HDTD.LaiQuaHan, HDTD.ThoiHanVay, HDTD.PhuongThucTra, HDTD.LoaiTien,
        kv.SoTienVay,
        cttn.KyThuNoGoc, cttn.KyThuNoLai, cttn.SoDuNo, cttn.SoTienTra, cttn.Chi_nhanh, cttn.NgayThuNo
    From 
		HDTD join cttn_cn cttn on cttn.SoHDTD = HDTD.SoHDTD
        join KHACHHANG as kh on HDTD.MaKH = kh.MaKH
        join KHOANVAY as kv on HDTD.MAKV = kv.MaKV
GO

--Thong ke lich su giao dich 1.7
CREATE OR ALTER VIEW [dbo].[ThongKeGiaoDich]
As
    Select 
		HDTD.SoHDTD, kh.Ten, kh.MaKH,
        gnn.SoGNN, gnn.HanMucTinDung, gnn.HanTraNo, gnn.NgayKyGNN
    From 
		HDTD join KHACHHANG as kh on HDTD.MaKH = kh.MaKH
        join GIAYNHANNO as gnn on HDTD.SoHDTD = gnn.SoHDTD
GO

--Thong ke lich su giai ngan
CREATE OR ALTER VIEW [dbo].[ThongKeGiaiNgan]
As
    Select 
		HDTD.SoHDTD, kh.Ten, kh.MaKH,
        ctgn.SoCTGN, ctgn.SoTienGiaiNgan, HDTD.TGGiaiNgan
    From 
		HDTD join KHACHHANG as kh on HDTD.MaKH = kh.MaKH
        join CHUNGTUGIAINGAN as ctgn on HDTD.SoHDTD = ctgn.SoHDTD
GO

--Thong ke thu no
CREATE OR ALTER VIEW [dbo].[activationHistory4PayBack]
As
    Select 
		HDTD.SoHDTD, kh.Ten, kh.MaKH,
        cttn.SoCTThuNo, cttn.SoDuNo, cttn.SoTienTra, cttn.NgayThuNo
    From 
		HDTD join KHACHHANG as kh on HDTD.MaKH = kh.MaKH
        join CHUNGTUTHUNO as cttn on HDTD.SoHDTD = cttn.SoHDTD
GO

--Ho so vay von 2.1
--Dieu Khoan 2.2
CREATE OR ALTER VIEW [dbo].[Rules]
As
    Select 
		dk.MaDK, dk.NoiDung, dk.Pct_lai
    From 
		DIEUKHOAN as dk
GO

--Danh sach nhan vien
CREATE OR ALTER VIEW DanhSachNhanVien
AS
    -- body of the view
    SELECT 
		MaNV, CCCD, Ten, Dia_chi, Email, Sdt, NHANVIEN.MaCV as MaCV, tenCV, HSluong
    FROM 
		NHANVIEN JOIN CHUCVU
        ON NHANVIEN.MaCV = CHUCVU.MaCV
GO

-- 3.2. Danh sách chi nhánh
CREATE OR ALTER VIEW DSChiNhanh
AS
    -- body of the view
    SELECT 
        MaCN, Chi_nhanh, Dia_chi
    FROM ChiNhanh
GO

-- 3.3. Danh sách khách hàng
-- Create the view in the specified schema
CREATE OR ALTER VIEW DSKhachHang
AS
    SELECT
        ten, dia_chi, email, sdt, CCCD, FICO_score, NgaySinh, MaDN, DnB_rating
    FROM 
		KHACHHANG LEFT OUTER JOIN CANHAN ON KHACHHANG.MaKH = CANHAN.MaKH
        LEFT OUTER JOIN DOANHNGHIEP ON KHACHHANG.MaKH = DOANHNGHIEP.MaKH 
GO

-- 3.4.	Danh sách TSDB
-- HDTD.MaKH, KHACHHANG.Ten,
-- HDTD.SoHDTD
-- LOAITSDB.TenLoaiTSDB , TAISANDAMBAO.TenTSDB, TAISANDAMBAO.TriGiaTS, TAISANDAMBAO.HinhThucDB

CREATE OR ALTER VIEW DanhSachTSDB
AS
    SELECT kh.MaKH, kh.Ten, LOAITSDB.TenLoaiTSDB , tsdb.TenTSDB, tsdb.TriGiaTS, tsdb.HinhThucDB
    FROM KHACHHANG as kh
        INNER JOIN TAISANDAMBAO as tsdb
        ON kh.MaKH = tsdb.MaKH
        INNER JOIN LOAITSDB
        ON LOAITSDB.MaLoaiTSDB = tsdb.MaLoaiTSDB
GO

CREATE OR ALTER VIEW DanhSachHDTD
AS
    SELECT KHACHHANG.MaKH, KHACHHANG.Ten, HDTD.SoHDTD, KHOANVAY.SoTienVay, KHOANVAY.LoaiTien
    FROM KHACHHANG
        INNER JOIN HDTD
        ON KHACHHANG.MaKH = HDTD.MaKH
        INNER JOIN KHOANVAY
        ON KHOANVAY.MaKV = HDTD.MAKV
GO

-- 3.6.	Thống kê tài chính
-- Lấy theo khoảng thời gian 1 tháng,  1 quý, 1 năm
-- GIAYNHANNO(SoGNN, SoHDTD, MaKH, NgayKyGNN, ChiNhanh, HanMucTinDung, HanTraNo, LaiQuaHan, LaiSuat)
-- CHUNGTUTHUNO(SoCTThuNo, SoHDTD, KyThuNoGoc, KyThuNoLai, SoDuNoGoc, SoDuNo, SotienTra, NgayThuNo)

CREATE OR ALTER VIEW ThongKeThang_GiayNhanNo
AS
    SELECT *
    FROM GIAYNHANNO
    WHERE DATEDIFF(day,CURRENT_TIMESTAMP, NgayKyGNN) <= 30  
GO

CREATE OR ALTER VIEW ThongKeThang_CHUNGTUTHUNO
AS
    SELECT *
    FROM CHUNGTUTHUNO
    WHERE DATEDIFF(day,CURRENT_TIMESTAMP, NgayThuNo) <= 30  
GO

CREATE OR ALTER VIEW ThongKeQuy_GiayNhanNo
AS
    SELECT *
    FROM GIAYNHANNO
    WHERE DATEDIFF(month,CURRENT_TIMESTAMP, NgayKyGNN) <= 3 
GO
CREATE OR ALTER VIEW ThongKeQuy_CHUNGTUTHUNO
AS
    SELECT *
    FROM CHUNGTUTHUNO
    WHERE DATEDIFF(month,CURRENT_TIMESTAMP, NgayThuNo) <= 3
GO

CREATE OR ALTER VIEW ThongKeNam_GiayNhanNo
AS
    SELECT *
    FROM GIAYNHANNO
    WHERE DATEDIFF(year,CURRENT_TIMESTAMP, NgayKyGNN) <= 1
GO

CREATE OR ALTER VIEW ThongKeNam_CHUNGTUTHUNO
AS
    SELECT *
    FROM CHUNGTUTHUNO
    WHERE DATEDIFF(year,CURRENT_TIMESTAMP, NgayThuNo) <= 1
GO

