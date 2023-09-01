use master 
go

DROP DATABASE NLBank 
go

CREATE DATABASE NLBank 
go

use NLBank
go
-- Mô hình quan hệ dữ liệu 

-- CHUCVU(MaCV, tenCV, HSluong)
CREATE TABLE CHUCVU
(
    MaCV char(36),
    TenCV nvarchar(50),
    HSLuong decimal(4,2),
    PRIMARY KEY (MaCV)
)
go
-- NHANVIEN(MaNV, CCCD, Ten, Dia_chi, Email, Sdt, MaCV)
CREATE TABLE NHANVIEN
(
    MaNV char(36),
    CCCD char (12),
    Ten nvarchar(50),
    Dia_chi nvarchar(50),
    Email char(50),
    Sdt char(11),
    MaCV char(36),
    PRIMARY KEY (MaNV),
    CONSTRAINT FK_NV_CV FOREIGN KEY (MaCV) REFERENCES CHUCVU(MaCV)
)
go
-- DIEUKHOAN(MaDK, NoiDung, pct_lai)

CREATE TABLE DIEUKHOAN
(
    MaDK char(36),
    NoiDung nvarchar(MAX),
    Pct_lai decimal(4,2),
    PRIMARY KEY (MaDK)
)
go
-- CHINHANH(MaHT, Chi_nhanh, Dia_chi)

CREATE TABLE CHINHANH
(
    MaCN char(36),
    Chi_nhanh char(50),
    Dia_chi nvarchar(50),
    PRIMARY KEY (MaCN)
)
go

-- KHACHHANG(MaKH, Ten, Dia_chi, Email, Sdt)
CREATE TABLE KHACHHANG
(
    MaKH char(38),
    Ten nvarchar(50),
    Dia_chi nvarchar(50),
    Email char(50),
    Sdt char(11),
	RoleID tinyint,
    PRIMARY KEY (MaKH)
)
go

-- CANHAN(MaKH, CCCD, FICO_score, NgaySinh)
CREATE TABLE CANHAN
(
    MaKH char(38),
    NgaySinh date,
    CCCD char(12),
    FICO_score int ,
	PRIMARY KEY (MAKH),
	CONSTRAINT FK_CN_KH FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH),
)
go

-- DOANHNGHIEP(MaKH, MaDN, D&B_rating)
CREATE TABLE DOANHNGHIEP
(
    MaKH char(38),
    MADN char(50),
    DnB_rating int ,
	PRIMARY KEY (MAKH),
	CONSTRAINT FK_DN_KH FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH),
)
go



-- TAISANDAMBAO(MaTSDB, SoHDTD, MaLoaiTSDB, TenTSDB, MaKH, TriGiaTS, HinhThucDB)

CREATE TABLE TAISANDAMBAO
(
    MaTSDB char(36),
    MaLoaiTSDB char(6),-- TODO 
    TenTSDB nvarchar(50),
    MaKH char(38),
    TrigiaTS int ,
    HinhThucDB nvarchar(50),

    CONSTRAINT FK_TSDB_KH FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH),
    PRIMARY KEY (MaTSDB)
)
go


-- HDTD(SoHDTD, MaKV, MaKH, Muc_dich, LaiSuat, LaiQuaHan, ThoiHanVay, PhuongThucTra, MucPhi, TGGiaiNgan, LoaiTien, NgayKi) -- Hợp đồng tín dụng 
-- KHOANVAY(MaKV, MaKH, MaHDTD, MaLoaiKV, SoTienVay, LoaiTien)
CREATE TABLE KHOANVAY
(
    MaKV char(36),
    MaKH char(38),
    MaTSDB char(36),
    MaLoaiKV char(6),
	MucDich nvarchar(38),
    SoTienVay int ,
	LoaiTien char(4),
    CONSTRAINT FK_KV_KH FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH),
	CONSTRAINT FK_KV_TSDB FOREIGN KEY (MaTSDB) REFERENCES TAISANDAMBAO(MaTSDB),
    --TODO
    PRIMARY KEY (MaKV)
)
go

CREATE TABLE HDTD
(
    SoHDTD char(36),
    MaKH char(38),
    MAKV char(36),
    Muc_dich nvarchar(MAX),
    LaiSuat decimal(4,2),
    LaiQuaHan decimal(4,2),
    ThoiHanVay int ,
    -- so ngay vay
    PhuongThucTra char(50),
    MucPhi int ,
    TGGiaiNgan date ,
    LoaiTien char(4) ,
    NgayKi date ,

    CONSTRAINT FK_HDTD_KH FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH),
    CONSTRAINT FK_HDTD_KV FOREIGN KEY (MaKV) REFERENCES KHOANVAY(MaKV),
    PRIMARY KEY (SoHDTD)
)
go

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Biểu diễn các mối quan hệ VAY, TRA, DAMBAO và chuẩn hóa quan hệ:

-- LOAIKV(MaLoaiKV, TenKV)
CREATE TABLE LOAIKV
(
    MaLoaiKV char(6),
    TenKV nvarchar(50),
    PRIMARY KEY (MaLoaiKV)

)
go

-- LOAITSDB(MaLoaiTSDB, TenLoaiTSDB)

CREATE TABLE LOAITSDB
(
    MaLoaiTSDB char(6),
    TenLoaiTSDB nvarchar(50),
    PRIMARY KEY (MaLoaiTSDB)
)
go

-- CHUNGTUGIAINGAN(SoCTGN, SoHDTD, MaKH, MaCN, SoTienGiaiNgan)
CREATE TABLE CHUNGTUGIAINGAN
(
    SoCTGN char(36),
    SoHDTD char(36),
    MaKH char(38),
    MaCN char(36),
    SoTienGiaiNgan int ,

    CONSTRAINT FK_CTGN_KH FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH),
    CONSTRAINT FK_CTGN_SoHDTD FOREIGN KEY (SoHDTD) REFERENCES HDTD(SoHDTD),
    CONSTRAINT FK_CTGN_CN FOREIGN KEY (MaCN) REFERENCES CHINHANH(MaCN),

    PRIMARY KEY (SoCTGN)
)
go
-- GIAYNHANNO(SoGNN, SoHDTD, MaKH, NgayKyGNN, MaCN, HanMucTinDung, HanTraNo, LaiQuaHan, LaiSuat)

CREATE TABLE GIAYNHANNO
(
    SoGNN char(36),
    SoHDTD char(36),
    MaKH char(38),
    NgayKyGNN date ,
    MaCN char(36),
    HanMucTinDung int ,
    HanTraNo date ,
    LaiQuaHan decimal (4,2),
    LaiSuat decimal (4,2),

    CONSTRAINT FK_GNN_KH FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH),
    CONSTRAINT FK_GNN_SoHDTD FOREIGN KEY (SoHDTD) REFERENCES HDTD(SoHDTD),
    CONSTRAINT FK_GNN_CN FOREIGN KEY (MaCN) REFERENCES CHINHANH(MaCN),

    PRIMARY KEY (SoGNN)
)
go

-- CHUNGTUTHUNO(SoCTThuNo, SoHDTD, KyThuNoGoc, KyThuNoLai, SoDuNoGoc, SoDuNo, SotienTra, NgayThuNo)
CREATE TABLE CHUNGTUTHUNO
(
    SoCTThuNo char(36),
    SoHDTD char(36),
	MaCN char(36),
    KyThuNoGoc date ,
    KyThuNoLai date ,
    SoDuNo int ,
    SoTienTra int ,
    SoDuNoGoc int ,
    NgayThuNo date,
    CONSTRAINT FK_CTTN_SoHDTD FOREIGN KEY (SoHDTD) REFERENCES HDTD(SoHDTD),
	CONSTRAINT FK_CTTN_CN FOREIGN KEY (MaCN) REFERENCES CHINHANH(MaCN),
    PRIMARY KEY (SoCTThuNo)
)
go


--History(ID, MaKH, MaHDTD, SoCTThuNo, SoTienVay, SoTienTra, DaHoanThanh)
CREATE TABLE History
(
    ID int identity(1,1),
    MaKH char(38),
    MaHDTD char(36),
    SoCTThuNo char(36),
    SoTienVay int,
    SoTienTra int ,
    DaHoanThanh bit ,
    CONSTRAINT FK_History_SoHDTD FOREIGN KEY (MaHDTD) REFERENCES HDTD(SoHDTD),
    CONSTRAINT FK_History_KH FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH),
    CONSTRAINT FK_History_CTTN FOREIGN KEY (SoCTThuNo) REFERENCES CHUNGTUTHUNO(SoCTThuNo),

    PRIMARY KEY (ID)
)
GO

-- Authenciation (Role ID: {0: khach hang, 1: nhan vien, 2: quan tri vien})
CREATE TABLE Authenciation(
	ID int identity(1, 1) PRIMARY KEY,
	Email char(36),
	Passwd char(38),
	RoleID tinyint
)
GO


----------------
ALTER TABLE KHOANVAY
ADD CONSTRAINT FK_KV_LoaiKV
FOREIGN KEY (MaLoaiKV) REFERENCES LOAIKV(MaLoaiKV);
go

ALTER TABLE TAISANDAMBAO
ADD CONSTRAINT FK_TSDB_LoaiTSDB
FOREIGN KEY (MaLoaiTSDB) REFERENCES LOAITSDB(MaLoaiTSDB);
go
-------------------- fetch data ------------------------

INSERT INTO KHACHHANG
    (MaKH, Ten, Dia_chi, Email, Sdt)
VALUES
    ('9ada93f7-1a5a-4f87-8be6-dd8e732e2b95CN', 'Trần Diệp Phương Vy', '45 lý thường kiệt ', 'andreatran2002@gmail.com', '0788892441');
go

INSERT INTO CANHAN
    (MaKH, CCCD, NgaySinh, FICO_score)
VALUES
    ('9ada93f7-1a5a-4f87-8be6-dd8e732e2b95CN', '371891940', '2002-10-20', 600);
go
-------------------------------------------------Constraint----------------------------------------------------------------------


-- *Nhân viên*

-- - Phải có CCCD
ALTER TABLE NHANVIEN
ALTER COLUMN CCCD CHAR(12) NOT NULL
GO

-- *Chức vụ*

-- - 1 ≤ Hệ số lương
ALTER TABLE CHUCVU
ADD CHECK (HSLuong >= 1)
GO

-- *Khách hàng*

-- - Khách hàng phải 18 tuổi trở lên
-- - Phải có CCCD (đối với cá nhân) hoặc MaDN (đối với doanh nghiệp)
-- - FICO_score mặc định 600
-- - D&B rating mặc định 2
ALTER TABLE CANHAN 
ADD CHECK (DATEDIFF(year,NgaySinh,GETDATE()) >= 18)
GO

ALTER TABLE CANHAN 
ALTER COLUMN CCCD CHAR(12) NOT NULL
GO

ALTER TABLE DOANHNGHIEP 
ALTER COLUMN MADN CHAR(50) NOT NULL
GO

ALTER TABLE CANHAN 
ADD CONSTRAINT df_FICO
DEFAULT 600 FOR FICO_score
GO

ALTER TABLE DOANHNGHIEP 
ADD CONSTRAINT df_Rating
DEFAULT 2 FOR DnB_rating 
GO

-- *Hợp đồng tín dụng*

-- - Phải có mục đích vay
ALTER TABLE HDTD
ALTER COLUMN Muc_dich NVARCHAR(max) not null;
GO

-- - Lãi quá hạn mặc định là NULL
ALTER TABLE HDTD
ADD CONSTRAINT df_quahan
DEFAULT NULL for LaiQuaHan
GO

-- - Thời hạn vay > 30 (1 tháng)
ALTER TABLE HDTD
ADD CHECK(ThoiHanVay > 30)
GO

-- - mức phí ≥ 0
ALTER TABLE HDTD
ADD CHECK(MucPhi > 30)
GO

-- - TG giải ngân (≥ ngày đăng kí)
ALTER TABLE HDTD
ADD CHECK(TGGiaiNgan > NgayKi)
GO
-- - Loại tiền (USD, vnđ, EUR)
ALTER TABLE HDTD
ADD CHECK (LoaiTien IN('USD', 'vnđ', 'UER'));
GO

-- *Khoản vay*

-- - Số tiền vay ≥ 1 triệu
ALTER TABLE KHOANVAY
ADD CHECK (SoTienVay > 1000000)
GO

-- - Loại tiền (USD, VNĐ, EUR)
ALTER TABLE KHOANVAY
ADD CHECK (LoaiTien IN('USD', 'VND', 'UER'));
GO

-- *Tài sản đảm bảo*

-- - Trị giá tài sản > 0
ALTER TABLE TAISANDAMBAO
ADD CHECK (TriGiaTS > 0)
GO
-- Điều khoản
-- - pct_lai > 0%
ALTER TABLE DIEUKHOAN 
ADD CHECK (Pct_lai > 0)
GO



----------------------- **Đối với đa quan hệ** ----------------------

-- *Chứng từ giải ngân*

-- - Số tiền giải ngân = số tiền vay

CREATE TRIGGER Check_Sotiengiaingan_Trigger ON CHUNGTUGIAINGAN
AFTER INSERT, UPDATE
AS
IF EXISTS ( 
	SELECT * FROM CHUNGTUGIAINGAN AS ct
	INNER JOIN (
		SELECT KHOANVAY.SoTienVay , HDTD.SoHDTD
		FROM HDTD INNER JOIN KHOANVAY 
		ON KHOANVAY.MaKV = HDTD.MAKV
    ) AS hdtd 
	ON ct.SoHDTD = hdtd.SoHDTD AND ct.SoTienGiaiNgan <> hdtd.SoTienVay
)
BEGIN
    RAISERROR ('So tien giai ngan phai bang voi so tien vay', 16, 1);
    ROLLBACK TRANSACTION;
    RETURN
END;
go


-- *Giấy nhận nợ* 
-- GIAYNHANNO(SoGNN, SoHDTD, MaKH, NgayKyGNN, ChiNhanh, HanMucTinDung, HanTraNo, LaiQuaHan, LaiSuat)
-- HDTD(SoHDTD, MaKV, MaKH, Muc_dich, LaiSuat, LaiQuaHan, ThoiHanVay, PhuongThucTra, MucPhi, TGGiaiNgan, LoaiTien, NgayKi)

-- - 0 ≤ Lãi suất ≤ Lãi quá hạn
ALTER TABLE GIAYNHANNO
ADD CONSTRAINT Check_Laisuat_Laiquahan CHECK(LaiSuat > 0 AND  LaiSuat < LaiQuaHan);
go
-- - Hạn trả nợ ≥ ngày kí giấy nhận nợ
CREATE TRIGGER [dbo].[Check_Ngaynhanno_Trigger] ON [dbo].[GIAYNHANNO]
AFTER INSERT, UPDATE
AS
IF EXISTS (
           SELECT * FROM GIAYNHANNOw
	INNER JOIN HDTD AS hdtd
    ON GIAYNHANNO.SoHDTD = hdtd.SoHDTD
        AND GIAYNHANNO.HanTraNo <  hdtd.NgayKi
          )
BEGIN
    RAISERROR ('Ngay han tra no phai sau ngay ky ', 16, 1);
    ROLLBACK TRANSACTION;
    RETURN
END;
GO

-- *Chứng từ thu nợ*
-- - Số dư nợ > 0
ALTER TABLE CHUNGTUTHUNO
ADD CONSTRAINT Check_Soduno CHECK(SoDuNo > 0  );
go

-- - 0 ≤ Số tiền trả ≤ Số dư nợ gốc
ALTER TABLE CHUNGTUTHUNO
ADD CONSTRAINT Check_Soduno_Sodunogoc CHECK(SoDuNo >= 0 AND SoDuNoGoc >= SoDuNo );
go


----------------------------------------------TRIGGER------------------------------------------------------------


-- Cập nhật khoản vay ⇒ kiểm tra hồ sơ khách hàng (tuổi, điểm tín dụng, …)
CREATE TRIGGER trigger_khoanvay ON KHOANVAY
AFTER UPDATE 
AS 
DECLARE @Diem_tindung int;
DECLARE @MaKhMoi char(38);

SELECT @MaKhMoi = MaKH
from inserted;

SELECT @Diem_tindung = FICO_score
FROM CANHAN
WHERE MaKH = @MaKhMoi;

BEGIN
    IF @Diem_tindung < 500 
    BEGIN
        PRINT('Chua du diem tinh dung')
        ROLLBACK
    END
END
GO
-- Giấy nhận nợ có tài sản đảm bảo ⇒ tài sản đảm bảo (cập nhật thêm)




-- Xóa khách hàng ⇒ xóa các tài sản đảm bảo tương ứng
CREATE TRIGGER Delete_customer_Trigger ON KHACHHANG 
AFTER DELETE 
AS 
BEGIN
    declare @makh int = (select MaKH
    from deleted)
    delete from TAISANDAMBAO WHERE MaKH = @makh
END
go

-- Mỗi lần có một hợp đồng tín dụng ⇒ thêm vào lịch sử vay

--  HDTD(SoHDTD, MaKV, MaKH, Muc_dich, LaiSuat, LaiQuaHan, ThoiHanVay, PhuongThucTra, MucPhi, TGGiaiNgan, LoaiTien, NgayKi) -- Hợp đồng tín dụng 

CREATE TRIGGER create_hdtd_Trigger ON HDTD 
AFTER INSERT 
AS 
BEGIN
    declare @sotienvay int  = (select SoTienVay
    from KHOANVAY INNER JOIN inserted on inserted.MaKV = KHOANVAY.MaKV)

    INSERT INTO History
        ( MaKH , MaHDTD,SoTienVay, SoTienTra , DaHoanThanh)
    SELECT MaKH , SoHDTD, @sotienvay , 0 , 0
    FROM inserted
END
go


-- Mỗi lần khách hàng trả nợ (thu nợ) ⇒ cập nhật vào lịch sử vay
-- CHUNGTUTHUNO(SoCTThuNo, SoHDTD, KyThuNoGoc, KyThuNoLai, SoDuNoGoc, SoDuNo, SotienTra, NgayThuNo)
CREATE TRIGGER create_cttn_Trigger ON CHUNGTUTHUNO 
AFTER INSERT 
AS 
BEGIN
    declare @sotientra int  = (select CHUNGTUTHUNO.SoTienTra
    from CHUNGTUTHUNO INNER JOIN inserted on inserted.SoCTThuNo = CHUNGTUTHUNO.SoCTThuNo)
    declare @sotienvay int  = (select History.SoTienVay
    from History INNER JOIN inserted on inserted.SoCTThuNo = History.SoCTThuNo)
    declare @soCTThuNo nvarchar(36)  = (select History.SoCTThuNo
    from History INNER JOIN inserted on inserted.SoCTThuNo = History.SoCTThuNo)
    declare @dahoanthanh bit = 'FALSE'
    if @sotienvay < @sotientra 
    BEGIN
        SET  @dahoanthanh = 'TRUE'
    END

    UPDATE History SET SoTienTra = @sotientra , 
                    DaHoanThanh = @dahoanthanh
                    
        WHERE History.SoCTThuNo = @soCTThuNo
END
go


----------------------------------------------VIEW------------------------------------------------------------

--Thong tin khach hang ca nhan 1.1
CREATE VIEW [dbo].[personalClientInfo]
AS
    SELECT kh.MaKH, kh.Ten, kh.Dia_chi, kh.Email, kh.Sdt, kh.Email as clientEmail, cn.CCCD, cn.NgaySinh, cn.FICO_score
    FROM KHACHHANG as kh join CANHAN as cn on kh.MaKH = cn.MaKH 
go

--Thong tin khach hang doanh nghiep 1.1
CREATE VIEW [dbo].[interpriseClientInfo]
AS
    SELECT kh.MaKH, kh.Ten, kh.Dia_chi, kh.Email, kh.Sdt, kh.Email as clientEmail, dn.MADN, dn.DnB_rating
    FROM KHACHHANG as kh join DOANHNGHIEP as dn on kh.MaKH = dn.MaKH 
go

--Hop dong cho vay 1.2
Create view [dbo].[contract]
As
	With tsdb AS (
		SELECT MaKV, TenTSDB, TrigiaTS, HinhThucDB, MaLoaiTSDB FROM KHOANVAY kv LEFT JOIN TAISANDAMBAO ts ON kv.MaTSDB = ts.MaTSDB
		)
    Select kh.Ten, kh.MaKH,
        HDTD.SoHDTD, HDTD.Muc_dich, HDTD.LaiSuat, HDTD.LaiQuaHan, HDTD.ThoiHanVay, HDTD.PhuongThucTra,
        HDTD.MucPhi, HDTD.TGGiaiNgan, HDTD.NgayKi,
        kv.SoTienVay, HDTD.LoaiTien,
        lts.TenLoaiTSDB, tsdb.TenTSDB, tsdb.TrigiaTS, tsdb.HinhThucDB
    From HDTD full join tsdb on HDTD.MAKV = tsdb.MaKV
        join KHOANVAY as kv on HDTD.MAKV = kv.MaKV
        join KHACHHANG as kh on HDTD.MaKH = kh.MaKH,
        LOAITSDB as lts
    Where lts.MaLoaiTSDB = tsdb.MaLoaiTSDB
go

--Giay no 1.3
Create view [dbo].[rentPaper]
As
	With tsdb AS (
		SELECT MaKV, TenTSDB, TrigiaTS, HinhThucDB, MaLoaiTSDB FROM KHOANVAY kv LEFT JOIN TAISANDAMBAO ts ON kv.MaTSDB = ts.MaTSDB
	)
    Select gnn.SoGNN, kh.Ten, kh.MaKH,
        HDTD.SoHDTD, HDTD.LaiSuat, HDTD.LaiQuaHan, HDTD.ThoiHanVay, HDTD.PhuongThucTra, HDTD.LoaiTien,
        HDTD.NgayKi,
        kv.SoTienVay,
        gnn.HanMucTinDung, gnn.NgayKyGNN
    From HDTD join GIAYNHANNO as gnn on gnn.SoHDTD =HDTD.SoHDTD
        join KHACHHANG as kh on HDTD.MaKH = kh.MaKH
        join KHOANVAY as kv on HDTD.MAKV = kv.MaKV
        join tsdb on HDTD.MAKV= tsdb.MaKV
go

--Giay giai ngan 1.4
Create view [dbo].[disbursementPaper]
As
    Select ctgn.SoCTGN, kh.Ten, kh.MaKH,
        HDTD.SoHDTD,
        cn.Chi_nhanh,
        ctgn.SoTienGiaiNgan
    From HDTD join CHUNGTUGIAINGAN as ctgn on ctgn.SoHDTD =HDTD.SoHDTD
        join KHACHHANG as kh on HDTD.MaKH = kh.MaKH
        join CHINHANH as cn on ctgn.MaCN = cn.MaCN
	--thieu thoi gian giai ngan
go

--Giay nhac no 1.5
Create view [dbo].[rentReminderPaper]
As
	With tsdb AS (
		SELECT MaKV, TenTSDB, TrigiaTS, HinhThucDB, MaLoaiTSDB FROM KHOANVAY kv LEFT JOIN TAISANDAMBAO ts ON kv.MaTSDB = ts.MaTSDB
		)
    Select gnn.SoGNN, kh.Ten, kh.MaKH,
        HDTD.SoHDTD, HDTD.LaiSuat, HDTD.LaiQuaHan, HDTD.ThoiHanVay, HDTD.PhuongThucTra, HDTD.LoaiTien,
        HDTD.NgayKi,
        kv.SoTienVay,
        gnn.HanMucTinDung, gnn.NgayKyGNN,
        cn.Chi_nhanh,
        gnn.NgayKyGNN as NgayNN
    From HDTD join GIAYNHANNO as gnn on gnn.SoHDTD =HDTD.SoHDTD
        join KHACHHANG as kh on HDTD.MaKH = kh.MaKH
        join KHOANVAY as kv on HDTD.MAKV = kv.MaKV
        join tsdb on HDTD.MAKV = tsdb.MaKV,
        CHINHANH as cn
    Where cn.MaCN = gnn.MaCN
go

--Giay thu no 1.6
Create view [dbo].[payBackPaper]
As
	With cttn_cn AS (
		SELECT cttn.SoCTThuNo, cttn.KyThuNoGoc, cttn.KyThuNoLai, cttn.SoDuNo, cttn.SoTienTra, cttn.SoHDTD , cn.Chi_nhanh FROM CHUNGTUTHUNO cttn INNER JOIN CHINHANH cn ON cttn.MaCN = cn.MaCN 
	)
    Select cttn.SoCTThuNo, kh.Ten, kh.MaKH,
        HDTD.SoHDTD, HDTD.LaiSuat, HDTD.LaiQuaHan, HDTD.ThoiHanVay, HDTD.PhuongThucTra, HDTD.LoaiTien,
        kv.SoTienVay,
        cttn.KyThuNoGoc, cttn.KyThuNoLai, cttn.SoDuNo, cttn.SoTienTra
    From HDTD join cttn_cn cttn on cttn.SoHDTD =HDTD.SoHDTD
        join KHACHHANG as kh on HDTD.MaKH = kh.MaKH
        join KHOANVAY as kv on HDTD.MAKV = kv.MaKV
	-- thieu cn, ngay tn
go

--Thong ke lich su giao dich 1.7
Create view [dbo].[activationHistory4Rent]
As
    Select HDTD.SoHDTD, kh.Ten, kh.MaKH,
        gnn.SoGNN, gnn.HanMucTinDung, gnn.HanTraNo, gnn.NgayKyGNN
    From HDTD join KHACHHANG as kh on HDTD.MaKH = kh.MaKH
        join GIAYNHANNO as gnn on HDTD.SoHDTD = gnn.SoHDTD
go

Create view [dbo].[activationHistory4Disbursement]
As
    Select HDTD.SoHDTD, kh.Ten, kh.MaKH,
        ctgn.SoCTGN, ctgn.SoTienGiaiNgan
    From HDTD join KHACHHANG as kh on HDTD.MaKH = kh.MaKH
        join CHUNGTUGIAINGAN as ctgn on HDTD.SoHDTD = ctgn.SoHDTD
	-- thieu ngay giai ngan
go

Create view [dbo].[activationHistory4PayBack]
As
    Select HDTD.SoHDTD, kh.Ten, kh.MaKH,
        cttn.SoCTThuNo, cttn.SoDuNo, cttn.SoTienTra
    From HDTD join KHACHHANG as kh on HDTD.MaKH = kh.MaKH
        join CHUNGTUTHUNO as cttn on HDTD.SoHDTD = cttn.SoHDTD
	-- thieu ngay thu no
go

--Ho so vay von 2.1
--doi dieu chinh db rui tui lam nhe

--Dieu Khoan 2.2
Create view [dbo].[rules]
As
    Select dk.MaDK, dk.NoiDung, dk.Pct_lai
    From DIEUKHOAN as dk
go

-- 3. Ban lanh dao 
-- 1.1.Hợp đồng cho vay 
-- (1.1)Thêm field KHACHHANG.MaKH
-- 1.2.Thống kê lịch sử giao dịch (giải ngân, nhận nợ, thu nợ)
-- (1.7) 	Thêm field KHACHHANG.MaKH
--HDTD(SoHDTD, MaKV, MaKH, Muc_dich, LaiSuat, LaiQuaHan, ThoiHanVay, PhuongThucTra, MucPhi, TGGiaiNgan, LoaiTien, NgayKi)
-- 2.2.	Mức lãi suất
-- 	(2.2) giữ nguyên
CREATE VIEW BanLanhDao_DanhSachNhanVien
AS
    -- body of the view
    SELECT MaNV,
        CCCD,
        Ten,
        Dia_chi,
        Email,
        Sdt,
        NHANVIEN.MaCV as MaCV,
        tenCV,
        HSluong
    from NHANVIEN JOIN CHUCVU
        ON NHANVIEN.MaCV = CHUCVU.MaCV
GO
-- NHANVIEN.MaNV, NHANVIEN.CCCD, NHANVIEN.Ten, NHANVIEN.Dia_chi, NHANVIEN.Email, NHANVIEN.Sdt,

-- chucvu.MaCV, CHUCVU.tenCV, CHUCVU.HSluong

-- 3.2. Danh sách chi nhánh
CREATE VIEW DSChiNhanh
AS
    -- body of the view
    SELECT
        MaCN,
        Chi_nhanh,
        Dia_chi
    FROM ChiNhanh
GO
-- ChiNhanh.MaHT, ChiNhanh.Chi_nhanh, ChiNhanh.Dia_chi

-- 3.3. Danh sách khách hàng
-- Create the view in the specified schema
CREATE VIEW DSKhachHang
AS
    SELECT
        ten,
        dia_chi,
        email,
        sdt,
        CCCD,
        FICO_score,
        NgaySinh,
        MaDN,
        DnB_rating
    FROM KHACHHANG
        LEFT OUTER JOIN CANHAN
        ON KHACHHANG.MaKH = CANHAN.MaKH
        LEFT OUTER JOIN DOANHNGHIEP
        ON KHACHHANG.MaKH = DOANHNGHIEP.MaKH 
GO

-- khachhang.ten, khachhang.dia_chi, khachhang.email, khachhang.sdt,

-- (CANHAN.CCCD, CANHAN.FICO_score , CANHAN.NgaySinh / DOANHNGHIEP.MaDN, DOANHNGHIEP .D&B_rating)

-- 3.4.	Danh sách TSDB
-- HDTD.MaKH, KHACHHANG.Ten,
-- HDTD.SoHDTD
-- LOAITSDB.TenLoaiTSDB , TAISANDAMBAO.TenTSDB, TAISANDAMBAO.TriGiaTS, TAISANDAMBAO.HinhThucDB

CREATE VIEW DanhSachTSDB
AS
    SELECT kh.MaKH, kh.Ten, LOAITSDB.TenLoaiTSDB , tsdb.TenTSDB, tsdb.TriGiaTS, tsdb.HinhThucDB
    FROM KHACHHANG as kh
        INNER JOIN TAISANDAMBAO as tsdb
        ON kh.MaKH = tsdb.MaKH
        INNER JOIN LOAITSDB
        ON LOAITSDB.MaLoaiTSDB = tsdb.MaLoaiTSDB
go
-- 3.5.	Danh sách HDTD
-- KHACHHANG.MaKH, KHACHHANG.Ten,
-- HDTD.SoHDTD, KHOANVAY.SoTienVay, KHOANVAY.LoaiTien
CREATE VIEW DanhSachHDTD
AS
    SELECT KHACHHANG.MaKH, KHACHHANG.Ten, HDTD.SoHDTD, KHOANVAY.SoTienVay, KHOANVAY.LoaiTien
    FROM KHACHHANG
        INNER JOIN HDTD
        ON KHACHHANG.MaKH = HDTD.MaKH
        INNER JOIN KHOANVAY
        ON KHOANVAY.MaKV = HDTD.MAKV
go
-- 3.6.	Thống kê tài chính
-- Lấy theo khoảng thời gian 1 tháng,  1 quý, 1 năm
-- GIAYNHANNO(SoGNN, SoHDTD, MaKH, NgayKyGNN, ChiNhanh, HanMucTinDung, HanTraNo, LaiQuaHan, LaiSuat)
-- CHUNGTUTHUNO(SoCTThuNo, SoHDTD, KyThuNoGoc, KyThuNoLai, SoDuNoGoc, SoDuNo, SotienTra, NgayThuNo)

CREATE VIEW ThongKeThang_GiayNhanNo
AS
    SELECT *
    FROM GIAYNHANNO
    WHERE DATEDIFF(day,CURRENT_TIMESTAMP, NgayKyGNN) <= 30  
go
CREATE VIEW ThongKeThang_CHUNGTUTHUNO
AS
    SELECT *
    FROM CHUNGTUTHUNO
    WHERE DATEDIFF(day,CURRENT_TIMESTAMP, NgayThuNo) <= 30  
go

CREATE VIEW ThongKeQuy_GiayNhanNo
AS
    SELECT *
    FROM GIAYNHANNO
    WHERE DATEDIFF(month,CURRENT_TIMESTAMP, NgayKyGNN) <= 3 
go
CREATE VIEW ThongKeQuy_CHUNGTUTHUNO
AS
    SELECT *
    FROM CHUNGTUTHUNO
    WHERE DATEDIFF(month,CURRENT_TIMESTAMP, NgayThuNo) <= 3
go

CREATE VIEW ThongKeNam_GiayNhanNo
AS
    SELECT *
    FROM GIAYNHANNO
    WHERE DATEDIFF(year,CURRENT_TIMESTAMP, NgayKyGNN) <= 1
go
CREATE VIEW ThongKeNam_CHUNGTUTHUNO
AS
    SELECT *
    FROM CHUNGTUTHUNO
    WHERE DATEDIFF(year,CURRENT_TIMESTAMP, NgayThuNo) <= 1
go


----------------------------------------------CHUCNANG------------------------------------------------------------
-- 1. Cap nhap ho so 
--Thêm khách hàng
--Đăng ký
CREATE PROCEDURE [dbo].[ThemKhachHang](
    @MaKH char(38) ,
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
    INSERT INTO KHACHHANG
        (MaKH,Ten,Dia_chi,Email,Sdt)
    VALUES(@MaKH, @Ten, @Dia_chi, @Email, @Sdt)
	
	INSERT INTO Authenciation(Email, Passwd, RoleID)
	VALUES (@Email, @PassWd, @RoleID)
	
	IF @RoleID = 0 
		INSERT INTO CANHAN(MaKH, NgaySinh, CCCD)
		VALUES (@MaKH, @NgaySinh, @CCCD);
	IF @RoleID = 1
		INSERT INTO DOANHNGHIEP(MaKH, MADN)
		VALUES (@MaKH, @MaDN)
END
GO

--Xóa khách hàng
CREATE PROCEDURE XoaKhachHang(
    @MaKH char(38)
)
AS
BEGIN
    DELETE FROM KHACHHANG WHERE MaKH = @MaKH
	DELETE FROM Authenciation WHERE Email = (Select email FROM KHACHHANG where MaKH = @MaKH)
END
GO

-- Chỉnh sửa khách hàng
CREATE PROCEDURE SuaKhachHang(
    @MaKH char(38) ,
    @Ten nvarchar(50) = NULL ,
    @Dia_chi nvarchar(50) = NULL ,
    @Email char(50) = NULL,
    @Sdt char(11) = NULL
)
AS
BEGIN
    UPDATE KHACHHANG SET
		MaKH = @MaKH,
		Ten = @Ten,
		Dia_chi = @Dia_chi,
		Email = @Email,
		Sdt = @Sdt
	WHERE MaKH = @MaKH
END
GO

--Lấy các khách hàng theo id khách hàng
CREATE FUNCTION GetKHByID(@MaKH char(38)) Returns table
AS RETURN (SELECT *
	FROM KHACHHANG
	WHERE KHACHHANG.MaKH = @MaKH
)
GO

--Lấy các khách hàng theo số điện thoại
CREATE FUNCTION GetKHBySDT(@Sdt char(11)) Returns table
AS RETURN (SELECT *
	FROM KHACHHANG
	WHERE KHACHHANG.Sdt = @Sdt)
GO

-- 2. Quan ly khoan vay : KHOANVAY(MaKV, MaKH, MaHDTD, MaLoaiKV, SoTienVay, LoaiTien)
-- a. Cap nhap khoan vay 
-- Tao khoan vay 
CREATE PROCEDURE [dbo].[ThemKhoanVay](
    @MaKV char(36) ,
    @MaKH char(38)  = NULL ,
	@MaTSDB char(36) = NULL,
    @MaLoaiKV char(6)  = NULL ,
	@MucDich nvarchar(38) = NULL,
    @SoTienVay int = NULL,
    @LoaiTien char(4) = NULL 
)
AS
BEGIN
    INSERT INTO KHOANVAY
        (MaKV , MaKH ,MaTSDB , MaLoaiKV, MucDich , SoTienVay, LoaiTien)
    VALUES(@MaKV , @MaKH , @MaTSDB , @MaLoaiKV , @MucDich, @SoTienVay, @LoaiTien)
END
GO

-- Xoa khoan vay 
CREATE PROCEDURE XoaKhoanVay(
    @MaKV char(36)
)
AS
BEGIN
    DELETE FROM KHOANVAY WHERE MaKV = @MaKV
END 
go

-- Chinh sua khoan vay 
CREATE PROCEDURE [dbo].[SuaKhoanVay](
    @MaKV char(36) ,
    @MaKH char(38)  = NULL ,
	@MaTSDB char(36) = NULL,
    @MaLoaiKV char(6)  = NULL ,
	@MucDich nvarchar(38) = NULL,
    @SoTienVay int = NULL,
    @LoaiTien char(4) = NULL 
)
AS
BEGIN
    UPDATE  KHOANVAY SET 
                MaKH = @MaKH ,
				MaTSDB = @MaTSDB,
                MaLoaiKV =  @MaLoaiKV , 
				MucDich = @MucDich,
                SoTienVay = @SoTienVay,
				LoaiTien = @LoaiTien 
            WHERE MaKV = @MaKV
END

--Thêm giấy nhận nợ
CREATE PROC sp_addDebtPaper
	@DebtCode char(36),
	@HDTDCode char(36),
	@guestCode char(36),
	@signDate datetime,
	@branchCode char(36),
	@creditLimit int,
	@promiseDate datetime,
	@overTimeRate decimal,
	@originRate decimal
as
begin
insert into GIAYNHANNO(SoGNN, SoHDTD, MaKH, NgayKyGNN, MaCN, HanMucTinDung, HanTraNo, LaiQuaHan, LaiSuat)
	values (@DebtCode, @HDTDCode, @guestCode, @signDate, @branchCode, @creditLimit, @promiseDate, @overTimeRate, @originRate)
end
go

--Chỉnh sửa giấy nhân nợ
CREATE PROC sp_updateDebtPaper (
	@DebtCode char(36),
	@HDTDCode char(36),
	@guestCode char(36),
	@signDate datetime,
	@branchCode char(36),
	@creditLimit int,
	@promiseDate datetime,
	@overTimeRate decimal,
	@originRate decimal
)
as
begin
update GIAYNHANNO
set
	MaKH = @guestCode,
	NgayKyGNN = @signDate,
	MaCN = @branchCode,
	HanMucTinDung = @creditLimit,
	HanTraNo = @promiseDate,
	LaiQuaHan = @overTimeRate,
	LaiSuat = @originRate
where SoGNN = @DebtCode and SoHDTD = @HDTDCode
end
go

--Xóa giấy nhận nợ
CREATE PROC sp_deleteDebtPaper (@DebtCode char(36), @HDTDCode char(36))
as
begin
delete from GIAYNHANNO
where SoGNN = @DebtCode and SoHDTD = @HDTDCode
end
go

-- Lay khoan vay theo MaKV 
CREATE FUNCTION GetKVByID(@MaKV char(36)) Returns table
AS RETURN (SELECT * FROM KHOANVAY WHERE KHOANVAY.MaKV = @MaKV)
	 
go
-- Lay khoan vay theo MaKH 
CREATE FUNCTION GetKVByMaKH(@MaKH char(38)) Returns table
AS RETURN (SELECT * FROM KHOANVAY WHERE KHOANVAY.MaKH = @MaKH)
	 
go  

-- Lay khoan vay theo MaHDTD 
CREATE FUNCTION GetKVByMaHDTD(@MaHDTD char(36)) Returns table
AS RETURN SELECT kv.MaKV, kv.MaLoaiKV, kv.MaKH, kv.MaTSDB, kv.SoTienVay, kv.LoaiTien FROM KHOANVAY kv INNER JOIN 
		(SELECT HDTD.MAKV id FROM HDTD WHERE HDTD.SoHDTD = @MaHDTD) hdtd ON kv.MaKV = hdtd.id
go 


-- b. Quan ly tai san dam bao  
-- TAISANDAMBAO(MaTSDB, MaKH, SoHDTD, MaLoaiTSDB, TenTSDB, TriGiaTS, HinhThucDB)
-- Them TSDB
CREATE PROCEDURE ThemTaiSanDamBao(
    @MaTSDB char(36) ,
    @MaLoaiTSDB char(6)  = NULL ,
    @TenTSDB nvarchar(50)  = NULL ,
    @MaKH char(38) = NULL  ,
    @TriGiaTS int = NULL  ,
    @HinhThucDB nvarchar(50) = NULL
)
AS
BEGIN
    INSERT INTO TAISANDAMBAO
        (MaTSDB , MaLoaiTSDB , TenTSDB , MaKH , TrigiaTS , HinhThucDB)
    VALUES(@MaTSDB, @MaLoaiTSDB , @TenTSDB , @MaKH , @TrigiaTS , @HinhThucDB)
END 
go
-- Xoa TSDB
CREATE PROCEDURE XoaTaiSanDamBao(
    @MaTSDB char(36)
)
AS
BEGIN
    DELETE FROM TAISANDAMBAO WHERE MaTSDB = @MaTSDB
END 
go
-- Chinh sua TSDB

CREATE PROCEDURE SuaTaiSanDamBao(
    @MaTSDB char(36) ,
    @MaLoaiTSDB char(6)  = NULL ,
    @TenTSDB nvarchar(50)  = NULL ,
    @MaKH char(38) = NULL  ,
    @TriGiaTS int = NULL  ,
    @HinhThucDB nvarchar(50) = NULL
)
AS
BEGIN
    UPDATE  TAISANDAMBAO SET 
                MaTSDB  = @MaTSDB,
                MaLoaiTSDB = @MaLoaiTSDB ,
                TenTSDB = @TenTSDB ,
                MaKH = @MaKH  , 
                TriGiaTS = @TriGiaTS  , 
                HinhThucDB = @HinhThucDB 
            WHERE MaTSDB = @MaTSDB
END 
go
-- Lay TSDB theo MaKH 
CREATE FUNCTION GetTSDBById(@MaTSDB char(36)) Returns table
AS RETURN (SELECT * FROM TAISANDAMBAO WHERE TAISANDAMBAO.MaTSDB = @MaTSDB)
	 
go

-- Lay khoan vay theo MaKH 
CREATE FUNCTION GetTSDBByMaKH(@MaKH char(38)) Returns table
AS RETURN (SELECT * FROM TAISANDAMBAO WHERE TAISANDAMBAO.MaKH = @MaKH)
	 
GO

-- Lay tai san dam bao theo MaHDTD 
CREATE FUNCTION GetTSDBByMaHDTD(@MaHDTD char(36)) Returns table
AS RETURN (
	WITH Q AS (
		SELECT kv.MaKV, tsdb.MaKH, tsdb.MaTSDB, tsdb.MaLoaiTSDB, tsdb.TenTSDB, tsdb.HinhThucDB, tsdb.TrigiaTS
		FROM KHOANVAY kv INNER JOIN TAISANDAMBAO tsdb ON kv.MaTSDB = tsdb.MaTSDB
	)
	SELECT Q.MaTSDB, Q.MaLoaiTSDB, Q.MaKH, Q.TenTSDB, Q.TrigiaTS, Q.HinhThucDB FROM Q INNER JOIN (SELECT * FROM HDTD WHERE HDTD.SoHDTD = @MaHDTD) hdtd ON Q.MaKV = hdtd.MAKV
)
go 


-- c . Hợp đồng tín dụng 
-- HDTD(SoHDTD, MaKV, MaKH, Muc_dich, LaiSuat, LaiQuaHan, ThoiHanVay, PhuongThucTra, MucPhi, TGGiaiNgan, LoaiTien, NgayKi)
-- Them HDTD
CREATE PROCEDURE ThemHopDongTinDung(
    @SoHDTD char(36) ,
    @MaKH char(38) = NULL  ,
    @MaKV char(36) = NULL  ,
    @Muc_dich nvarchar(MAX)  = NULL ,
    @LaiSuat decimal(4,2)  = NULL ,
    @LaiQuaHan decimal(4,2)  = NULL ,
    @ThoiHanVay int  = NULL ,
    @PhuongThucTra char(50)  = NULL ,
    @MucPhi int = NULL ,
    @TGGiaiNgan DATE = NULL ,
    @LoaiTien char(4) = NULL ,
    @NgayKi DATE = NULL
)
AS
BEGIN
    INSERT INTO HDTD
        (
        SoHDTD ,
        MaKH ,
        MaKV ,
        Muc_dich ,
        LaiSuat ,
        LaiQuaHan ,
        ThoiHanVay ,
        PhuongThucTra ,
        MucPhi ,
        TGGiaiNgan ,
        LoaiTien ,
        NgayKi )
    VALUES
        (
            @SoHDTD ,
            @MaKH ,
            @MaKV  ,
            @Muc_dich  ,
            @LaiSuat ,
            @LaiQuaHan  ,
            @ThoiHanVay ,
            @PhuongThucTra  ,
            @MucPhi  ,
            @TGGiaiNgan  ,
            @LoaiTien  ,
            @NgayKi  )
END 
go
-- Xoa HDTD 
CREATE PROCEDURE XoaHopDongTinDung(
    @MaHDTD char(36)
)
AS
BEGIN
    DELETE FROM HDTD WHERE SoHDTD = @MaHDTD
END 
go
-- Chinh sua HDTD

CREATE PROCEDURE SuaHopDongTinDung(
    @SoHDTD char(36) ,
    @MaKH char(38) = NULL  ,
    @MaKV char(36) = NULL  ,
    @Muc_dich nvarchar(MAX)  = NULL ,
    @LaiSuat decimal(4,2)  = NULL ,
    @LaiQuaHan decimal(4,2)  = NULL ,
    @ThoiHanVay int  = NULL ,
    @PhuongThucTra char(50)  = NULL ,
    @MucPhi int = NULL ,
    @TGGiaiNgan DATE = NULL ,
    @LoaiTien char(4) = NULL ,
    @NgayKi DATE = NULL
)
AS
BEGIN
    UPDATE HDTD SET   
                        MaKH = @MaKH, 
                        MaKV = @MaKH, 
                        Muc_dich = @Muc_dich  ,
                        LaiSuat  = @LaiSuat,
                        LaiQuaHan  = @LaiQuaHan,
                        ThoiHanVay =@ThoiHanVay,
                        PhuongThucTra = @PhuongThucTra,
                        MucPhi  = @MucPhi, 
                        TGGiaiNgan  = @TGGiaiNgan, 
                        LoaiTien  = @LoaiTien, 
                        NgayKi = @NgayKi  
            WHERE SoHDTD = @SoHDTD
END 
go 
-- Lay HDTD theo MaHDTD 
CREATE FUNCTION GetHDTDById(@MaHDTD char(36)) Returns table
AS RETURN (SELECT * FROM HDTD WHERE HDTD.SoHDTD = @MaHDTD)
	 
go
-- Lay HDTD theo MaKH 
CREATE FUNCTION GetHDTDByMaKH(@MaKH char(38)) Returns table
AS RETURN (SELECT * FROM HDTD WHERE HDTD.MaKH = @MaKH)
	 
go  

-- Lay HDTD theo MaHDTD 
CREATE FUNCTION GetHDTDByMaKV(@MaKV char(36)) Returns table
AS RETURN (SELECT * FROM HDTD WHERE HDTD.MaKV = @MaKV) 
go 
-- Lay cac HDTD da qua han vay 
CREATE FUNCTION GetHDTDOverDate() Returns table
AS RETURN (SELECT 
                kv.SoTienVay , kv.LoaiTien,
                HDTD.NgayKi , HDTD.TGGiaiNgan , HDTD.LaiQuaHan , HDTD.LaiSuat ,
                kh.Ten 
            FROM HDTD  
            JOIN KHOANVAY kv on kv.MaKV = HDTD.MAKV 
            JOIN KHACHHANG kh on kh.MaKH = HDTD.MaKH
            WHERE  DATEADD(day, HDTD.ThoiHanVay, HDTD.TGGiaiNgan) > CURRENT_TIMESTAMP ) 
go 

-- d. Cac chung tu
-- Chung tu thu no
--Thêm chứng từ thu nợ
CREATE PROC [dbo].[sp_addPayBackPaper]
	@payBackCode char(36),
	@HDTDCode char(36),
	@branchCode char(36),
	@originalSign date,
	@raisedSign date,
	@leftMoney int,
	@payBackMoney int,
	@leftDebt int,
	@payBackDate date
AS
BEGIN
INSERT INTO CHUNGTUTHUNO(SoCTThuNo, SoHDTD, MaCN, KyThuNoGoc, KyThuNoLai,SoDuNo, SoTienTra, SoDuNoGoc, NgayThuNo)
	VALUES (@payBackCode, @HDTDCode,@branchCode, @originalSign, @raisedSign, @leftMoney, @payBackMoney, @leftDebt, @payBackDate)
END
go

--Sửa chứng từ thu nợ
CREATE PROC [dbo].[sp_updatePayBackPaper] (
	@payBackCode char(36),
	@HDTDCode char(36),
	@branchCode char(36),
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
CREATE PROC sp_deletePayBackPaper (@payBackCode char(36), @HDTDCode char(36))
AS
BEGIN
	DELETE FROM CHUNGTUTHUNO
	WHERE SoCTThuNo = @payBackCode AND SoHDTD = @HDTDCode
	END
GO

-- Chung tu giai ngan
--Thêm chứng từ giải ngân
CREATE PROC sp_addDisbursementPaper
	@disbursementCode char(36),
	@HDTDCode char(36),
	@branchCode char(36),
	@moneyDisbursement int
AS
BEGIN
	INSERT INTO CHUNGTUGIAINGAN(SoCTGN, SoHDTD, MaCN, SoTienGiaiNgan)
		VALUES (@disbursementCode, @HDTDCode, @branchCode, @moneyDisbursement)
END
GO

--Sửa chứng từ giải ngân
CREATE PROC sp_UPDATEDisbursementPaper (
	@disbursementCode char(36), 
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
	WHERE SoCTGN = @disbursementCode
END
GO

--Xóa chứng từ giải ngân
CREATE PROC sp_deleteDisbursementPaper (
	@disbursementCode char(36)
)
AS
BEGIN
	DELETE FROM CHUNGTUGIAINGAN
	WHERE SoCTGN = @disbursementCode
END
GO

-- 3. Bao cao so du 
--Tổng nợ một người
CREATE FUNCTION dbo.f_sumDebt (@id char(38))
RETURNS bigint
AS
BEGIN
	DECLARE @sum bigint = 0;
	SELECT @sum = SUM(KHOANVAY.SoTienVay)
	FROM HDTD JOIN KHOANVAY ON HDTD.MAKV = KHOANVAY.MaKV
	WHERE HDTD.MaKH = @id
	RETURN @sum
END
GO

--Tổng giải ngân một người
CREATE FUNCTION dbo.f_sumDisburse (@id char(38))
RETURNS bigint
AS
BEGIN
	DECLARE @sum bigint = 0;
	SELECT @sum = SUM(CHUNGTUGIAINGAN.SoTienGiaiNgan)
	FROM HDTD JOIN CHUNGTUGIAINGAN ON HDTD.SoHDTD = CHUNGTUGIAINGAN.SoHDTD
	WHERE HDTD.MaKH = @id
	RETURN @sum
END
GO


--Tổng nợ đã trả một người
CREATE FUNCTION dbo.f_sumPayBack (@id char(38))
RETURNS bigint
AS
BEGIN
	DECLARE @sum bigint = 0;
	SELECT @sum = SUM(CHUNGTUTHUNO.SoTienTra)
	FROM HDTD JOIN CHUNGTUTHUNO ON HDTD.SoHDTD = CHUNGTUTHUNO.SoHDTD
	WHERE HDTD.MaKH = @id
	RETURN @sum
END
GO


--Tổng số hợp đồng của một người
CREATE FUNCTION dbo.f_countContract(@id char(38))
RETURNS int
AS 
BEGIN
DECLARE @sum int = 0;
	SELECT @sum = COUNT(*)
	FROM HDTD WHERE MaKH = @id
	RETURN @sum
END
GO


--Thống kê nợ toàn bộ khách hàng
CREATE FUNCTION dbo.f_debtRevenue()
RETURNS table
AS
RETURN 
	SELECT COUNT(kh.MaKH) AS totalUser, SUM(dbo.f_sumDebt(kh.MaKH)) AS totalDebt, SUM(dbo.f_sumDisburse(kh.MaKH)) AS totalDisburse,
			SUM (dbo.f_sumPayBack(kh.MaKH)) AS totalPayBack
	FROM KHACHHANG AS kh
	WHERE EXISTS (SELECT * FROM KHACHHANG JOIN HDTD ON kh.MaKH = hdtd.MaKH)
GO


--Thống kê nợ một khách hàng
CREATE FUNCTION dbo.f_debtRevenueUser(@id char(38))
RETURNS table 
AS 
RETURN 
	SELECT dbo.f_countContract(kh.MaKH) AS totalContract ,dbo.f_sumDebt(kh.MaKH) AS totalDebt, dbo.f_sumDisburse(kh.MaKH) AS totalDisburse,
			dbo.f_sumPayBack(kh.MaKH) AS totalPayBack
	FROM KHACHHANG AS kh
	WHERE kh.MaKH = @id 
GO

--4. Báo cáo nợ quá hạn

--Kiểm tra quá hạn của một hợp đồng
CREATE FUNCTION dbo.f_isOvertime(@id char(36))
RETURNS int 
AS
BEGIN
DECLARE @result int = 0,
		@signDate datetime,
		@numberOfDate int;
	SELECT @signDate = HDTD.NgayKi, @numberOfDate = HDTD.ThoiHanVay
	FROM HDTD 
	WHERE HDTD.SoHDTD = @id
IF(DATEDIFF(day, @signDate, CONVERT(date, GETDATE())) > @numberOfDate)
	set @result = 1;
RETURN @result
END
GO


--Kiểm tra số tiền nợ chưa trả của một hợp đồng
CREATE FUNCTION dbo.f_remainMoneyDebt(@id char(36))
RETURNS bigint
AS
BEGIN
DECLARE @remain bigint = 0;
	SELECT @remain = KHOANVAY.SoTienVay - SUM(CHUNGTUTHUNO.SoTienTra)
	FROM HDTD JOIN KHOANVAY ON HDTD.MAKV = KHOANVAY.MaKV
			JOIN CHUNGTUTHUNO ON HDTD.SoHDTD = CHUNGTUTHUNO.SoHDTD
	WHERE HDTD.SoHDTD = @id
	GROUP BY HDTD.LaiQuaHan, HDTD.LaiSuat, HDTD.LoaiTien, HDTD.MaKH, HDTD.MaKH, HDTD.MAKV, HDTD.Muc_dich, HDTD.NgayKi, HDTD.PhuongThucTra, HDTD.SoHDTD, HDTD.TGGiaiNgan, HDTD.ThoiHanVay,
	KHOANVAY.MaKH,KHOANVAY.MaKV, KHOANVAY.MaLoaiKV, KHOANVAY.SoTienVay
RETURN @remain
END
GO


--Liệt kê các hợp đồng quá hạn của một người dùng
CREATE FUNCTION dbo.f_debtOverTimeUser(@id char(38))
RETURNS table
AS
RETURN
SELECT kh.MaKH, HDTD.SoHDTD, dbo.f_remainMoneyDebt(HDTD.SoHDTD) AS remainMoney
	FROM KHACHHANG AS kh JOIN HDTD ON kh.MaKH = HDTD.MaKH
	WHERE kh.MaKH = @id
	AND EXISTS (SELECT * FROM KHACHHANG JOIN HDTD ON kh.MaKH = hdtd.MaKH) 
	AND dbo.f_isOvertime(HDTD.SoHDTD) = 1
GO


--Thống kê các khoản nợ quá hạn
CREATE FUNCTION dbo.f_debtOverTimeRevenue()
RETURNS table
AS
RETURN
SELECT count(distinct kh.MaKH) AS totalOTuser, count(HDTD.SoHDTD) AS totalOTcontract, sum(dbo.f_remainMoneyDebt(HDTD.SoHDTD)) AS remainMoney
	FROM KHACHHANG AS kh JOIN HDTD ON kh.MaKH = HDTD.MaKH
	WHERE EXISTS (SELECT * FROM KHACHHANG JOIN HDTD ON kh.MaKH = hdtd.MaKH) 
	AND dbo.f_isOvertime(HDTD.SoHDTD) = 1
GO


--Thông tin người dùng quá hạn
CREATE FUNCTION dbo.f_OTUserInfor(@id char(38))
RETURNS table
AS
RETURN
SELECT kh.MaKH, kh.Ten, kh.Dia_chi, kh.Sdt, kh.Email, dbo.f_remainMoneyDebt(HDTD.SoHDTD) AS remainMoney,
		HDTD.SoHDTD, HDTD.ThoiHanVay, HDTD.NgayKi
	FROM KHACHHANG AS kh JOIN HDTD ON kh.MaKH = HDTD.MaKH
	WHERE kh.MaKH = @id
	AND EXISTS (SELECT * FROM KHACHHANG JOIN HDTD ON kh.MaKH = hdtd.MaKH) 
	AND dbo.f_isOvertime(HDTD.SoHDTD) = 1
GO

--5. Quản lý nhân viên - chức vụ
-- a. Thêm
DROP PROC IF EXISTS dbo.proc_ThemNhanVien;
GO

CREATE PROCEDURE [dbo].[proc_themNhanVien](
	@MaNV char(36),
	@CCCD char(12),
	@Ten nvarchar(50),
	@DiaChi nvarchar(50),
	@Email char(50),
	@Sdt char(11),
	@MaCV char(36),
	@PassWd nchar(38)
) AS
BEGIN
	INSERT INTO NHANVIEN(MaNV, CCCD, Ten, Dia_chi, Email, Sdt, MaCV) 
	VALUES (@MaNV, @CCCD, @Ten, @DiaChi, @Email, @Sdt, @MaCV)

	INSERT INTO Authenciation(Email, Passwd, RoleID)
	VALUES (@Email, @PassWd, 2)
END
GO

-- b. Xóa
DROP PROC IF EXISTS dbo.proc_XoaNhanVien;
GO

CREATE PROCEDURE proc_XoaNhanVien(
	@MaNV char(36)
) AS
BEGIN
	DELETE FROM NHANVIEN WHERE MaNV = @MaNV 
	DELETE FROM Authenciation WHERE Email = (select email FROM NHANVIEN WHERE MaNV = @MaNV)
END
GO

-- c. Sửa
DROP PROC IF EXISTS dbo.proc_SuaNhanVien;
GO

CREATE PROCEDURE proc_SuaNhanVien(
	@MaNV char(36),
	@CCCD char(12),
	@Ten nvarchar(50),
	@DiaChi nvarchar(50),
	@Email char(50),
	@Sdt char(11),
	@MaCV char(36)
) AS
BEGIN
	UPDATE NHANVIEN SET 
		CCCD = @CCCD,
		Ten = @Ten,
		Dia_chi = @DiaChi,
		email = @Email,
		Sdt = @Sdt,
		MaCV = @MaCV
	WHERE MaNV = @MaNV
END
GO

-- d. Thêm chức vụ
DROP PROC IF EXISTS dbo.proc_themChucVu;
GO

CREATE PROC proc_themChucVu(
	@MaCV char(36),
	@TenCV nvarchar(50),
	@HSLuong decimal(4,2)
) AS
BEGIN
	INSERT INTO CHUCVU(MaCV, TenCV, HSLuong)
	VALUES (@MaCV, @TenCV, @HSLuong)
END
GO

-- e. Xóa chức vụ 
DROP PROC IF EXISTS dbo.proc_xoaChucVu;
GO

CREATE PROC proc_xoaChucVu(
	@MaCV char(36)
) AS
BEGIN
	DELETE FROM CHUCVU WHERE MaCV = @MaCV
END
GO

-- f. Sửa chức vụ
DROP PROC IF EXISTS dbo.proc_suaChucVu;
GO

CREATE PROC proc_suaChucVu(
	@MaCV char(36),
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
DROP PROC IF EXISTS dbo.proc_themChiNhanh;
GO

CREATE PROC proc_themChiNhanh(
	@MaCN char(36),
	@TenChiNhanh nvarchar(50),
	@DiaChi nvarchar(50)
)
AS
BEGIN
	INSERT INTO CHINHANH(MaCN, Chi_nhanh, Dia_chi)
	VALUES (@MaCN, @TenChiNhanh, @DiaChi)
END
GO

-- b. Xoá
DROP PROC IF EXISTS dbo.proc_xoaChiNhanh;
GO

CREATE PROC proc_xoaChiNhanh(
	@MaCN char(36)
)
AS
BEGIN
	DELETE FROM CHINHANH WHERE MaCN = @MaCN
END
GO

-- c. Sửa
DROP PROC IF EXISTS dbo.proc_suaDieuKhoan;
GO

CREATE PROC proc_suaDieuKhoan(
	@MaCN char(36),
	@TenChiNhanh nvarchar(50),
	@DiaChi nvarchar(50)
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
DROP PROC IF EXISTS dbo.proc_themDieuKhoan;
GO

CREATE PROC proc_themDieuKhoan(
	@MaDK char(36), 
	@NoiDung nvarchar(max), 
	@pct decimal(4, 2), 
	@phi int
)
AS
BEGIN
	INSERT INTO DIEUKHOAN(MaDK, NoiDung, Pct_lai)
	VALUES (@MaDK, @NoiDung, @pct)
END
GO

-- b. Xoá
DROP PROC IF EXISTS dbo.proc_xoaDieuKhoan;
GO

CREATE PROC proc_xoaDieuKhoan(
	@MaDK char(36)
)
AS
BEGIN
	DELETE FROM DIEUKHOAN WHERE MaDK = @MaDK
END
GO

-- c. Sửa
DROP PROC IF EXISTS dbo.proc_suaDieuKhoan;
GO

CREATE PROC proc_suaDieuKhoan(
	@MaDK char(36),
	@NoiDung nvarchar(max),
	@pct decimal(4,2),
	@phi int
)
AS
BEGIN
	UPDATE DIEUKHOAN SET 
		NoiDung = @NoiDung,
		Pct_lai = @pct
	WHERE @MaDK = MaDK
END
GO

--GetRoleID
CREATE FUNCTION func_LayRoleID(@email char(36))
RETURNS int
AS
BEGIN
    DECLARE @RoleID int = (SELECT RoleID FROM Authenciation WHERE Email = @email)
    RETURN @RoleID
END
GO

CREATE PROC LayCaNhanTuKhachHang(@MaKH char(36), @RoleID int)
AS
BEGIN
    IF @RoleID = 0 RETURN SELECT * FROM CANHAN WHERE MaKH = @MaKH
    IF @RoleID = 1 RETURN SELECT * FROM DOANHNGHIEP WHERE MaKH = @MaKH
END
GO

--Đăng nhập
CREATE PROC proc_DangNhap(@email char(36), @passwd char(38))
AS
BEGIN
    IF EXISTS (SELECT * FROM Authenciation WHERE Email = @email) 
        IF @passwd = (select passwd FROM Authenciation WHERE Email = @email)
            BEGIN
                DECLARE @RoleID int = func_LayRoleID(@email)
                IF @RoleID = 0 OR @RoleID = 1 
                    RETURN SELECT * FROM KHACHHANG WHERE Email = @email
                IF @RoleID = 2 
                    RETURN SELECT * FROM NHANVIEN WHERE Email = @email
                IF @RoleID = 3
                    RETURN 'admin'
            END
END