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
    CONSTRAINT FK_CN_KH FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH)
)
go

-- DOANHNGHIEP(MaKH, MaDN, D&B_rating)
CREATE TABLE DOANHNGHIEP
(
    MaKH char(38),
    MADN char(50),
    DnB_rating int ,

    CONSTRAINT FK_DN_KH FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH)
)
go



-- HDTD(SoHDTD, MaKV, MaKH, Muc_dich, LaiSuat, LaiQuaHan, ThoiHanVay, PhuongThucTra, MucPhi, TGGiaiNgan, LoaiTien, NgayKi) -- Hợp đồng tín dụng 
-- KHOANVAY(MaKV, MaKH, MaHDTD, MaLoaiKV, SoTienVay, LoaiTien)
CREATE TABLE KHOANVAY
(
    MaKV char(36),
    MaKH char(38),
    MaHDTD char(36),
    LoaiTien char(4),
    MaLoaiKV char(6),
    SoTienVay int ,
    CONSTRAINT FK_KV_KH FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH),
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



-- TAISANDAMBAO(MaTSDB, SoHDTD, MaLoaiTSDB, TenTSDB, MaKH, TriGiaTS, HinhThucDB)

CREATE TABLE TAISANDAMBAO
(
    MaTSDB char(36),
    SoHDTD char(36),
    MaLoaiTSDB char(6),-- TODO 
    TenTSDB nvarchar(50),
    MaKH char(38),
    TrigiaTS int ,
    HinhThucDB nvarchar(50),

    CONSTRAINT FK_TSDB_KH FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH),
    CONSTRAINT FK_TSDB_SoHDTD FOREIGN KEY (SoHDTD) REFERENCES HDTD(SoHDTD),
    PRIMARY KEY (MaTSDB)
)
go

---------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Biểu diễn các mối quan hệ VAY, TRA, DAMBAO và chuẩn hóa quan hệ:

-- LOAIKV(MaLoaiKV, TenKV)
CREATE TABLE LOAIKV
(
    MaLoaiKV char(6),
    TenKV char(50),
    PRIMARY KEY (MaLoaiKV)

)
go

-- LOAITSDB(MaLoaiTSDB, TenLoaiTSDB)

CREATE TABLE LOAITSDB
(
    MaLoaiTSDB char(6),
    TenLoaiTSDB char(50),
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
    KyThuNoGoc date ,
    KyThuNoLai date ,
    SoDuNo int ,
    SoTienTra int ,
    SoDuNoGoc int ,
    NgayThuNo date,
    CONSTRAINT FK_CTTN_SoHDTD FOREIGN KEY (SoHDTD) REFERENCES HDTD(SoHDTD),

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
go


----------------

ALTER TABLE KHOANVAY
ADD CONSTRAINT FK_KV_LoaiKV
FOREIGN KEY (MaLoaiKV) REFERENCES LOAIKV(MaLoaiKV);
go
ALTER TABLE KHOANVAY
ADD CONSTRAINT FK_KV_HDTD
FOREIGN KEY (MaHDTD) REFERENCES HDTD(SoHDTD)
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
ADD CHECK (HSLuong <= 1)
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
           SELECT *
FROM CHUNGTUGIAINGAN AS ct
    INNER JOIN (
                              SELECT KHOANVAY.SoTienVay , HDTD.SoHDTD
    FROM HDTD
        INNER JOIN KHOANVAY ON KHOANVAY.MaKV = HDTD.MAKV
                                
                             ) AS hdtd
    ON ct.SoHDTD = hdtd.SoHDTD
        AND ct.SoTienGiaiNgan <> hdtd.SoTienVay
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
CREATE TRIGGER Check_Ngaynhanno_Trigger ON GIAYNHANNO
AFTER INSERT, UPDATE
AS
IF EXISTS (
           SELECT *
FROM GIAYNHANNO
    INNER JOIN HDTD AS hdtd
    ON GIAYNHANNO.SoHDTD = hdtd.SoHDTD
        AND GIAYNHANNO.HanTraNo >  hdtd.NgayKi
          )
BEGIN
    RAISERROR ('Ngay han tra no phai sau ngay ky ', 16, 1);
    ROLLBACK TRANSACTION;
    RETURN
END;
go

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
    Select kh.Ten, kh.MaKH,
        HDTD.SoHDTD, HDTD.Muc_dich, HDTD.LaiSuat, HDTD.LaiQuaHan, HDTD.ThoiHanVay, HDTD.PhuongThucTra,
        HDTD.MucPhi, HDTD.TGGiaiNgan, HDTD.NgayKi,
        kv.SoTienVay, HDTD.LoaiTien,
        lts.TenLoaiTSDB, tsdb.TenTSDB, tsdb.TrigiaTS, tsdb.HinhThucDB
    From HDTD full join TAISANDAMBAO as tsdb on HDTD.SoHDTD = tsdb.SoHDTD
        join KHOANVAY as kv on HDTD.MAKV = kv.MaKV
        join KHACHHANG as kh on HDTD.MaKH = kh.MaKH,
        LOAITSDB as lts
    Where lts.MaLoaiTSDB = tsdb.MaLoaiTSDB
go

--Giay no 1.3
Create view [dbo].[rentPaper]
As
    Select gnn.SoGNN, kh.Ten, kh.MaKH,
        HDTD.SoHDTD, HDTD.LaiSuat, HDTD.LaiQuaHan, HDTD.ThoiHanVay, HDTD.PhuongThucTra, HDTD.LoaiTien,
        HDTD.NgayKi,
        kv.SoTienVay,
        gnn.HanMucTinDung, gnn.NgayKyGNN
    From HDTD join GIAYNHANNO as gnn on gnn.SoHDTD =HDTD.SoHDTD
        join KHACHHANG as kh on HDTD.MaKH = kh.MaKH
        join KHOANVAY as kv on HDTD.MAKV = kv.MaKV
        join TAISANDAMBAO as tsdb on HDTD.SoHDTD = tsdb.SoHDTD
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
        join TAISANDAMBAO as tsdb on HDTD.SoHDTD = tsdb.SoHDTD,
        CHINHANH as cn
    Where cn.MaCN = gnn.MaCN
go

--Giay thu no 1.6
Create view [dbo].[payBackPaper]
As
    Select cttn.SoCTThuNo, kh.Ten, kh.MaKH,
        HDTD.SoHDTD, HDTD.LaiSuat, HDTD.LaiQuaHan, HDTD.ThoiHanVay, HDTD.PhuongThucTra, HDTD.LoaiTien,
        kv.SoTienVay,
        cttn.KyThuNoGoc, cttn.KyThuNoLai, cttn.SoDuNo, cttn.SoTienTra
    From HDTD join CHUNGTUTHUNO as cttn on cttn.SoHDTD =HDTD.SoHDTD
        join KHACHHANG as kh on HDTD.MaKH = kh.MaKH
        join KHOANVAY as kv on HDTD.MAKV = kv.MaKV
        join TAISANDAMBAO as tsdb on HDTD.SoHDTD = tsdb.SoHDTD,
        CHINHANH as cn
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
    SELECT HDTD.MaKH, kh.Ten, HDTD.SoHDTD , LOAITSDB.TenLoaiTSDB , tsdb.TenTSDB, tsdb.TriGiaTS, tsdb.HinhThucDB
    FROM KHACHHANG as kh
        INNER JOIN TAISANDAMBAO as tsdb
        ON kh.MaKH = tsdb.MaKH
        INNER JOIN HDTD
        ON HDTD.SoHDTD = tsdb.SoHDTD
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
-- 2. Quan ly khoan vay : KHOANVAY(MaKV, MaKH, MaHDTD, MaLoaiKV, SoTienVay, LoaiTien)
-- a. Cap nhap khoan vay 
-- Tao khoan vay 
CREATE PROCEDURE ThemKhoanVay(
    @MaKV char(36) ,
    @MaKH char(38)  = NULL ,
    @MaLoaiKV char(6)  = NULL ,
    @LoaiTien char(4) = NULL  ,
    @SoTienVay int = NULL
)
AS
BEGIN
    INSERT INTO KHOANVAY
        (MaKV , MaKH , LoaiTien , MaLoaiKV , SoTienVay)
    VALUES(@MaKV , @MaKH , @LoaiTien , @MaLoaiKV , @SoTienVay)
END 
go
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

CREATE PROCEDURE SuaKhoanVay(
    @MaKV char(36) ,
    @MaKH char(38)  = NULL ,
    @MaLoaiKV char(6)  = NULL ,
    @LoaiTien char(4) = NULL  ,
    @SoTienVay int = NULL
)
AS
BEGIN
    UPDATE  KHOANVAY SET 
                MaKH = @MaKH ,
                LoaiTien = @LoaiTien ,
                MaLoaiKV =  @MaLoaiKV , 
                SoTienVay = @SoTienVay 
            WHERE MaKV = @MaKV
END 
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
AS RETURN (SELECT * FROM KHOANVAY WHERE KHOANVAY.MaHDTD = @MaHDTD) 
go 



-- b. Quan ly tai san dam bao  
-- TAISANDAMBAO(MaTSDB, MaKH, SoHDTD, MaLoaiTSDB, TenTSDB, TriGiaTS, HinhThucDB)
CREATE PROCEDURE ThemTaiSanDamBao(
    @MaTSDB char(36) ,
    @SoHDTD char(36)  = NULL ,
    @MaLoaiTSDB char(6)  = NULL ,
    @TenTSDB nvarchar(50)  = NULL ,
    @MaKH char(38) = NULL  ,
    @TriGiaTS int = NULL  ,
    @HinhThucDB nvarchar(50) = NULL
)
AS
BEGIN
    INSERT INTO TAISANDAMBAO
        (MaTSDB , SoHDTD , MaLoaiTSDB , TenTSDB , MaKH , TrigiaTS , HinhThucDB)
    VALUES(@MaTSDB , @SoHDTD , @MaLoaiTSDB , @TenTSDB , @MaKH , @TrigiaTS , @HinhThucDB)
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
    @SoHDTD char(36)  = NULL ,
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
                SoHDTD = @SoHDTD,
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
	 
go  

-- Lay khoan vay theo MaHDTD 
CREATE FUNCTION GetTSDBByMaHDTD(@MaHDTD char(36)) Returns table
AS RETURN (SELECT * FROM TAISANDAMBAO WHERE TAISANDAMBAO.SoHDTD = @MaHDTD) 
go 



-- c . Hợp đồng tín dụng 
-- HDTD(SoHDTD, MaKV, MaKH, Muc_dich, LaiSuat, LaiQuaHan, ThoiHanVay, PhuongThucTra, MucPhi, TGGiaiNgan, LoaiTien, NgayKi)
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





-- 3. Bao cao so du 
