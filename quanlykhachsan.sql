CREATE DATABASE QuanLyKhachSan;
GO

USE QuanLyKhachSan;
GO

CREATE TABLE KhachHang(
    MaKH INT PRIMARY KEY IDENTITY(1,1),
    TenKH NVARCHAR(50) NOT NULL,
    NgaySinh DATE NOT NULL,
    CCCD NVARCHAR(12) NOT NULL UNIQUE CHECK (LEN(CCCD) = 12),
    SDT NVARCHAR(10) NOT NULL UNIQUE CHECK (LEN(SDT) = 10),
    LoaiKH NVARCHAR(1) NOT NULL
);


CREATE TABLE BangGiaPhong (
    LoaiPhong NVARCHAR(1) UNIQUE NOT NULL,
    SucChua INT UNIQUE NOT NULL,
    TienGioDau INT CHECK (TienGioDau > 0),
    TienQuaDem INT CHECK (TienQuaDem > 0),
    TienGioTiepTheo INT CHECK (TienGioTiepTheo > 0),
    PRIMARY KEY (LoaiPhong, SucChua)
);

CREATE TABLE Phong (
    SoPhong INT PRIMARY KEY ,
    LoaiPhong NVARCHAR(1) NOT NULL,
    SucChua INT NOT NULL,
    TinhTrang NVARCHAR(10) NOT NULL,
	FOREIGN KEY (LoaiPhong) REFERENCES BangGiaPhong(LoaiPhong),
    FOREIGN KEY (SucChua) REFERENCES BangGiaPhong(SucChua)
);

CREATE TABLE YeuCauDatPhong 
(
    MaDP INT PRIMARY KEY,
    MaKH INT,
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

CREATE TABLE XacNhanYeuCauDatPhong (
    SoPhong INT PRIMARY KEY,
    MaDP INT,
    CheckIn DATETIME NOT NULL,
    CheckOut DATETIME NOT NULL,
    FOREIGN KEY (MaDP) REFERENCES YeuCauDatPhong(MaDP),
	FOREIGN KEY (SoPhong) REFERENCES Phong(SoPhong)
);
-- ngaythanhtoan Không có not null
CREATE TABLE HoaDon (
    MaKH INT NOT NULL,
    MaHD INT PRIMARY KEY IDENTITY(1,1),
    NgayThanhToan DATE NOT NULL,
    TongTienThanhToan INT CHECK (TongTienThanhToan >= 0),
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

CREATE TABLE DichVu (
    MaDV INT PRIMARY KEY IDENTITY(100,1),
    TenDV NVARCHAR(50) NOT NULL,
    DonGia INT CHECK (DonGia > 0)
);

CREATE TABLE DanhSachSuDungDichVu (
    MaHD INT,
    MaDV INT,
    SoLuong INT CHECK (SoLuong > 0),
    ThoiDiem DATETIME NOT NULL,
    PRIMARY KEY (MaHD, MaDV),
    FOREIGN KEY (MaHD) REFERENCES HoaDon(MaHD),
    FOREIGN KEY (MaDV) REFERENCES DichVu(MaDV)
);



INSERT INTO KhachHang (TenKH, NgaySinh, CCCD, SDT, LoaiKH)
VALUES
    (N'Nguyễn Văn A', '1990-01-01', '123456789012', '0987654321', N'A'),
    (N'Trần Thị B', '1995-05-15', '987654321012', '0123456789', N'B'),
    (N'Lê Văn C', '1985-12-10', '567890123456', '0912345678', N'C');

go
INSERT INTO BangGiaPhong (LoaiPhong, SucChua, TienGioDau, TienQuaDem, TienGioTiepTheo)
VALUES
    (N'A', 2, 100000, 80000, 50000),
    (N'B', 3, 120000, 90000, 60000),
    (N'C', 4, 150000, 100000, 70000);
go
-- Vui lòng thay đổi giá trị của SoPhong theo thực tế, và chắc chắn rằng các giá trị SoPhong là duy nhất.
INSERT INTO Phong (SoPhong, LoaiPhong, SucChua, TinhTrang)
VALUES
    (101, N'A', 2, N'Trống'),
    (102, N'A', 2, N'Trống'),
    (201, N'B', 3, N'Trống'),
    (202, N'B', 3, N'Trống'),
    (301, N'C', 4, N'Trống'),
    (302, N'C', 4, N'Trống');

go
-- Vui lòng thay đổi giá trị của MaDP và MaKH theo thực tế.
INSERT INTO YeuCauDatPhong (MaDP, MaKH)
VALUES
    (1, 1),
    (2, 2),
    (3, 3);

go
-- Vui lòng thay đổi giá trị của SoPhong và MaDP theo thực tế.
INSERT INTO XacNhanYeuCauDatPhong (SoPhong, MaDP, CheckIn, CheckOut)
VALUES
    (101, 1, '2023-10-10 12:00:00', '2023-10-15 12:00:00'),
    (201, 2, '2023-11-05 14:00:00', '2023-11-10 12:00:00'),
    (301, 3, '2023-12-20 10:00:00', '2023-12-25 12:00:00');
go
-- Vui lòng thay đổi giá trị của MaKH theo thực tế.
INSERT INTO HoaDon (MaKH, NgayThanhToan, TongTienThanhToan)
VALUES
    (1, '2023-10-15', 600000),
    (2, '2023-11-10', 720000),
    (3, '2023-12-25', 900000);
go
INSERT INTO DichVu (TenDV, DonGia)
VALUES
    (N'Đồ uống', 50000),
    (N'Ăn sáng', 80000),
    (N'Dịch vụ phòng', 100000);
go

drop trigger CapNhatTinhTrangPhong;

-- xíu sữa tên phòng
create trigger CapNhatTinhTrangPhong 
on XacNhanYeuCauDatPhong
after insert as
begin 
-- select new room 
declare @Room int;
select @Room = new.SoPhong
from inserted new

-- update room
update Phong
set TinhTrang = 'Da Dat'
where SoPhong = @Room
declare @maKH int;

select @maKH = phong.MaKH
from PhongDuocXacNhan phong
where phong.SoPhong = @Room 
insert into HoaDon(MaKH, NgayThanhToan, TongTienThanhToan) values 
(@maKH,'2023-10-10 12:00:00',0)

end







INSERT INTO KhachHang (TenKH, NgaySinh, CCCD, SDT, LoaiKH)
VALUES
    (N'Khanh hang test', '1990-01-01', '127776789012', '0987654421', N'A')
go

-- Vui lòng thay đổi giá trị của MaDP và MaKH theo thực tế.
INSERT INTO YeuCauDatPhong (MaDP, MaKH)
VALUES
    (5, 5)
go
-- Vui lòng thay đổi giá trị của SoPhong và MaDP theo thực tế.
INSERT INTO XacNhanYeuCauDatPhong (SoPhong, MaDP, CheckIn, CheckOut)
VALUES
    (302, 5, '2023-10-10 12:00:00', '2023-10-15 12:00:00')
go

-- Vui lòng thay đổi giá trị của MaKH theo thực tế.
INSERT INTO HoaDon (MaKH, NgayThanhToan, TongTienThanhToan)
VALUES
    (5, '2023-10-15', 600000)
go

INSERT INTO DanhSachSuDungDichVu (MaHD, MaDV, SoLuong, ThoiDiem)
VALUES
    (5, 100, 2, '2023-10-15 08:30:00'),
    (5, 102, 3, '2023-11-07 07:45:00'),
    (5, 101, 4, '2023-12-24 20:15:00');
drop trigger CapNhatPhongSauKhiTra
go
create trigger CapNhatSauKhiTraPhong
on XacNhanYeuCauDatPhong
after delete
as
begin
-- select madaphong,sophong from deleted room 
declare @maDatPhong int, @soPhong int,@maHoaDon int;
select @maDatPhong = old.MaDP , @soPhong = old.SoPhong, @maHoaDon = HoaDon.MaHD
from deleted old , YeuCauDatPhong, HoaDon
where old.MaDP = YeuCauDatPhong.MaDP and HoaDon.MaKH = YeuCauDatPhong.MaKH;
print(@maHoaDon)
-- delete yeucaudatphong from madatphong
delete from YeuCauDatPhong
where MaDP = @maDatPhong;

-- update tinhtrang from sophong
update Phong
set TinhTrang = 'Trống'
where SoPhong = @soPhong;

--delete danh sach dịch vụ
delete from DanhSachSuDungDichVu
where @maHoaDon = DanhSachSuDungDichVu.MaHD;

end

delete from XacNhanYeuCauDatPhong 
where SoPhong = 302;
go

create view PhongDuocXacNhan
as 
select SoPhong,YeuCauDatPhong.MaDP,MaKH
from YeuCauDatPhong , XacNhanYeuCauDatPhong
where YeuCauDatPhong.MaDP = XacNhanYeuCauDatPhong.MaDP
go