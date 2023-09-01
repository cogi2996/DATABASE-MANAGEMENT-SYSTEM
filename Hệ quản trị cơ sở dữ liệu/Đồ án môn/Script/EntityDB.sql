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
    MaCV int IDENTITY(1, 1),
    TenCV nvarchar(50),
    HSLuong decimal(4,2),
    PRIMARY KEY (MaCV)
)
go
-- NHANVIEN(MaNV, CCCD, Ten, Dia_chi, Email, Sdt, MaCV)
CREATE TABLE NHANVIEN
(
    MaNV int IDENTITY(1, 1),
    CCCD char (12),
    Ten nvarchar(50),
    Dia_chi nvarchar(50),
    Email char(50),
    Sdt char(11),
    MaCV int,
    PRIMARY KEY (MaNV),
    CONSTRAINT FK_NV_CV FOREIGN KEY (MaCV) REFERENCES CHUCVU(MaCV)
)
go
-- DIEUKHOAN(MaDK, NoiDung, pct_lai)

CREATE TABLE DIEUKHOAN
(
    MaDK int IDENTITY(1, 1),
    NoiDung nvarchar(MAX),
    Pct_lai decimal(5,2),
	Phi int,
    PRIMARY KEY (MaDK),
	CONSTRAINT Phi CHECK(Phi >= 0)
)
go
-- CHINHANH(MaHT, Chi_nhanh, Dia_chi)

CREATE TABLE CHINHANH
(
    MaCN int IDENTITY(1, 1),
    Chi_nhanh nvarchar(MAX),
    Dia_chi nvarchar(MAX),
    PRIMARY KEY (MaCN)
)
go

-- KHACHHANG(MaKH, Ten, Dia_chi, Email, Sdt)
CREATE TABLE KHACHHANG
(
    MaKH int IDENTITY(1, 1),
    Ten nvarchar(50),
    Dia_chi nvarchar(50),
    Email char(50) UNIQUE,
    Sdt char(11),
	RoleID tinyint,
    PRIMARY KEY (MaKH)
)
go

-- CANHAN(MaKH, CCCD, FICO_score, NgaySinh)
CREATE TABLE CANHAN
(
    MaKH int,
    NgaySinh date,
    CCCD char(12) NOT NULL,
    FICO_score int ,
	PRIMARY KEY (MAKH),
	CONSTRAINT FK_CN_KH FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH) ON DELETE CASCADE,
)
go

-- DOANHNGHIEP(MaKH, MaDN, D&B_rating)
CREATE TABLE DOANHNGHIEP
(
    MaKH int,
    MaDN char(50),
    DnB_rating int ,
	PRIMARY KEY (MAKH),
	CONSTRAINT FK_DN_KH FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH) ON DELETE CASCADE,
)
go

-- TAISANDAMBAO(MaTSDB, SoHDTD, MaLoaiTSDB, TenTSDB, MaKH, TriGiaTS, HinhThucDB)

CREATE TABLE TAISANDAMBAO
(
    MaTSDB int IDENTITY(1, 1),
    MaLoaiTSDB int,-- TODO 
    TenTSDB nvarchar(MAX),
    MaKH int,
    TrigiaTS BIGINT,
    HinhThucDB nvarchar(50),

    CONSTRAINT FK_TSDB_KH FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH) ON DELETE CASCADE,
    PRIMARY KEY (MaTSDB)
)
go


-- HDTD(SoHDTD, MaKV, MaKH, Muc_dich, LaiSuat, LaiQuaHan, ThoiHanVay, PhuongThucTra, MucPhi, TGGiaiNgan, LoaiTien, NgayKi) -- Hợp đồng tín dụng 
-- KHOANVAY(MaKV, MaKH, MaTSDB, MaLoaiKV, SoTienVay, LoaiTien)
CREATE TABLE KHOANVAY
(
    MaKV int IDENTITY(1, 1),
    MaKH int,
    MaTSDB int,
    MaLoaiKV int,
	MucDich nvarchar(MAX),
    SoTienVay BIGINT,
	LoaiTien char(4),
    CONSTRAINT FK_KV_KH FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH),
	CONSTRAINT FK_KV_TSDB FOREIGN KEY (MaTSDB) REFERENCES TAISANDAMBAO(MaTSDB),
    --TODO
    PRIMARY KEY (MaKV)
)
go

CREATE TABLE HDTD
(
    SoHDTD int IDENTITY(1, 1),
    MaKH int,
    MAKV int,
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
    MaLoaiKV int IDENTITY(1, 1),
    TenKV nvarchar(MAX),
    PRIMARY KEY (MaLoaiKV)
)
go

-- LOAITSDB(MaLoaiTSDB, TenLoaiTSDB)

CREATE TABLE LOAITSDB
(
    MaLoaiTSDB int IDENTITY(1, 1),
    TenLoaiTSDB nvarchar(MAX),
    PRIMARY KEY (MaLoaiTSDB)
)
go

-- CHUNGTUGIAINGAN(SoCTGN, SoHDTD, MaCN, SoTienGiaiNgan)
CREATE TABLE CHUNGTUGIAINGAN
(
    SoCTGN int IDENTITY(1, 1),
    SoHDTD int,
    MaKH int,
    MaCN int,
    SoTienGiaiNgan int ,

    CONSTRAINT FK_CTGN_KH FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH) ON DELETE CASCADE,
    CONSTRAINT FK_CTGN_SoHDTD FOREIGN KEY (SoHDTD) REFERENCES HDTD(SoHDTD) ON DELETE SET NULL,
    CONSTRAINT FK_CTGN_CN FOREIGN KEY (MaCN) REFERENCES CHINHANH(MaCN) ON DELETE SET NULL,

    PRIMARY KEY (SoCTGN)
)
go
-- GIAYNHANNO(SoGNN, SoHDTD, MaKH, NgayKyGNN, MaCN, HanMucTinDung, HanTraNo, LaiQuaHan, LaiSuat)

CREATE TABLE GIAYNHANNO
(
    SoGNN int IDENTITY(1, 1),
    SoHDTD int,
    MaKH int,
    NgayKyGNN date ,
    MaCN int,
    HanMucTinDung int ,
    HanTraNo date ,
    LaiQuaHan decimal (4,2),
    LaiSuat decimal (4,2),

    CONSTRAINT FK_GNN_KH FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH) ON DELETE CASCADE,
    CONSTRAINT FK_GNN_SoHDTD FOREIGN KEY (SoHDTD) REFERENCES HDTD(SoHDTD) ON DELETE SET NULL,
    CONSTRAINT FK_GNN_CN FOREIGN KEY (MaCN) REFERENCES CHINHANH(MaCN) ON DELETE SET NULL,

    PRIMARY KEY (SoGNN)
)
go

-- CHUNGTUTHUNO(SoCTThuNo, SoHDTD, KyThuNoGoc, KyThuNoLai, SoDuNoGoc, SoDuNo, SotienTra, NgayThuNo)
CREATE TABLE CHUNGTUTHUNO
(
    SoCTThuNo int IDENTITY(1, 1),
    SoHDTD int,
	MaCN int,
	MaKH int,
    KyThuNoGoc date,
    KyThuNoLai date,
    SoDuNo int,
    SoTienTra int,
    SoDuNoGoc int,
    NgayThuNo date,
    CONSTRAINT FK_CTTN_SoHDTD FOREIGN KEY (SoHDTD) REFERENCES HDTD(SoHDTD) ON DELETE CASCADE,
	CONSTRAINT FK_CTTN_CN FOREIGN KEY (MaCN) REFERENCES CHINHANH(MaCN) ON DELETE SET NULL,
	CONSTRAINT FK_CTTN_KH FOREIGN KEY (MaKH) REFERENCES KHACHHANG(MaKH) ON DELETE SET NULL,
    PRIMARY KEY (SoCTThuNo)
)
go

--History(ID, MaKH, SoHDTD, SoCTThuNo, SoTienVay, SoTienTra, DaHoanThanh)
CREATE TABLE History
(
    ID int identity(1,1),
    MaKH int,
    SoHDTD int,
    SoCTThuNo int,
    SoTienVay int,
    SoTienTra int ,
    DaHoanThanh bit,

    PRIMARY KEY (ID)
)
GO

-- Authenciation (Role ID: {0: khach hang, 1: nhan vien, 2: quan tri vien})
CREATE TABLE Authenciation(
	ID int identity(1, 1) PRIMARY KEY,
	Email char(36) UNIQUE,
	Passwd char(38),
	RoleID tinyint
)
GO
