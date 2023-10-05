﻿CREATE DATABASE QuanLyKhachSan5;
GO

USE QuanLyKhachSan5;
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
-- Loại phòng được tham 
    LoaiPhong NVARCHAR(1) NOT NULL, 
    SucChua INT NOT NULL,
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
	-- tham chiếu theo bộ
	FOREIGN KEY (LoaiPhong,SucChua) REFERENCES BangGiaPhong(LoaiPhong,SucChua),
    --FOREIGN KEY (SucChua) REFERENCES BangGiaPhong(SucChua)
);


-- auto increment yeucaudatphong
CREATE TABLE YeuCauDatPhong 
(
    MaDP INT PRIMARY KEY IDENTITY(1,1),
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

CREATE TABLE HoaDon (
    MaKH INT NOT NULL,
    MaHD INT PRIMARY KEY IDENTITY(1,1),
    NgayThanhToan DATE,
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


-- view
--VIEW_01
create view PhongDuocXacNhan
as 
select SoPhong,YeuCauDatPhong.MaDP,MaKH
from YeuCauDatPhong , XacNhanYeuCauDatPhong
where YeuCauDatPhong.MaDP = XacNhanYeuCauDatPhong.MaDP
go

-- trigger 


--TRIGGER_01 
create trigger CapNhatSauKhiTraPhong
on XacNhanYeuCauDatPhong
after delete
as
begin
-- select madaphong,sophong from deleted room 
declare @maDatPhong int, @soPhong int,@maHoaDon int;
select @maDatPhong = old.MaDP , @soPhong = old.SoPhong, @maHoaDon = max(HoaDon.MaHD)
from deleted old , YeuCauDatPhong, HoaDon
where old.MaDP = YeuCauDatPhong.MaDP and HoaDon.MaKH = YeuCauDatPhong.MaKH;
print(@maHoaDon)
-- delete yeucaudatphong from madatphong
delete from YeuCauDatPhong
where MaDP = @maDatPhong;

-- update tinhtrang from sophong
update Phong
set TinhTrang = N'Trống'
where SoPhong = @soPhong;


--delete danh sach dịch vụ
delete from DanhSachSuDungDichVu
where @maHoaDon = DanhSachSuDungDichVu.MaHD;

end

--TRIGGER_02

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
set TinhTrang = N'Đã đặt'
where SoPhong = @Room
declare @maKH int;

select @maKH = phong.MaKH
from PhongDuocXacNhan phong
where phong.SoPhong = @Room 
insert into HoaDon(MaKH, NgayThanhToan, TongTienThanhToan) values 
(@maKH,null,0)
end




--INSERT
INSERT INTO KhachHang (TenKH, NgaySinh, CCCD, SDT, LoaiKH)
VALUES
    (N'Nguyễn Văn A', '1990-01-01', '123456789012', '0987654321', N'T'),
    (N'Trần Thị B', '1995-05-15', '987654321012', '0123456789', N'V'),
    (N'Lê Văn C', '1985-12-10', '567890123456', '0912345678', N'T');

go
INSERT INTO BangGiaPhong (LoaiPhong, SucChua, TienGioDau, TienQuaDem, TienGioTiepTheo)
VALUES
    (N'T', 2, 100000, 80000, 50000),
    (N'V', 3, 120000, 90000, 60000),
    (N'T', 4, 150000, 100000, 70000);
go
-- Vui lòng thay đổi giá trị của SoPhong theo thực tế, và chắc chắn rằng các giá trị SoPhong là duy nhất.
INSERT INTO Phong (SoPhong, LoaiPhong, SucChua, TinhTrang)
VALUES
    (101, N'T', 2, N'Trống'),
    (102, N'T', 4, N'Trống');
go
-- Vui lòng thay đổi giá trị của MaDP và MaKH theo thực tế.
INSERT INTO YeuCauDatPhong (MaKH)
VALUES
    (1)
go
-- Vui lòng thay đổi giá trị của SoPhong và MaDP theo thực tế.
INSERT INTO XacNhanYeuCauDatPhong (SoPhong, MaDP, CheckIn, CheckOut)
VALUES
    (101, 1, '2023-10-10 12:00:00', '2023-10-15 12:00:00')
go
-- Vui lòng thay đổi giá trị của MaKH theo thực tế.
INSERT INTO HoaDon (MaKH, NgayThanhToan, TongTienThanhToan)
VALUES
    (1, '2023-10-15', 600000);

go
INSERT INTO DichVu (TenDV, DonGia)
VALUES
    (N'Đồ uống', 50000),
    (N'Ăn sáng', 80000),
    (N'Dịch vụ phòng', 100000);
go

INSERT INTO DanhSachSuDungDichVu (MaHD, MaDV, SoLuong, ThoiDiem)
VALUES
    (1, 100, 2, '2023-10-15 08:30:00'),
    (1, 102, 3, '2023-11-07 07:45:00'),
    (1, 101, 4, '2023-12-24 20:15:00');


delete from XacNhanYeuCauDatPhong
where SoPhong = 101