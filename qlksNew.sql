create database quanlikhachsan
go
use quanlikhachsan
go
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
drop view PhongDuocXacNhan
create view PhongDuocXacNhan
as 
select SoPhong,YeuCauDatPhong.MaDP,YeuCauDatPhong.MaKH, MaHD
from YeuCauDatPhong , XacNhanYeuCauDatPhong, HoaDon
where YeuCauDatPhong.MaDP = XacNhanYeuCauDatPhong.MaDP and YeuCauDatPhong.MaKH = HoaDon.MaKH
go

-- trigger 

drop trigger CapNhatSauKhiTraPhong
--TRIGGER_01 
create trigger CapNhatSauKhiTraPhong
on XacNhanYeuCauDatPhong
after delete
as
begin
-- lấy mã hoá đơn và mã đặt phòng từ bộ có mã hoá đơn lớn nhất ( hoá đơn hiện tại ) 
declare @maHD int,@maDP int;
select top 1 @maDP = old.MaDP, @maHD = PhongDuocXacNhan.MaHD
from deleted old ,PhongDuocXacNhan
where old.MaDP = PhongDuocXacNhan.MaDP
order by PhongDuocXacNhan.MaHD DESC;
--Tong Tien dich vu 
declare @TotalService int;
select @TotalService = sum(DichVu.DonGia)
from DanhSachSuDungDichVu,DichVu
where DanhSachSuDungDichVu.MaHD = @maHD and DanhSachSuDungDichVu.MaDV = DichVu.MaDV
-- Tong tien phong
	-- tạo bảng ảo #PhongDaDat chứa các phòng đã đặt của user
create table #PhongDaDat(
	SoPhong int,
	TienGioDau int,
	TienQuaDem int,
	TienGioTiepTheo int,
	CheckIn DateTime,
);
	-- insert các phòng đã đặt vào #PhongDaDat
insert into #PhongDaDat(SoPhong,TienGioDau,TienQuaDem,TienGioTiepTheo,CheckIn)
select  Phong.SoPhong,TienGioDau,TienQuaDem,TienGioTiepTheo, CheckIn
from XacNhanYeuCauDatPhong,Phong,BangGiaPhong
where XacNhanYeuCauDatPhong.MaDP = @maDP and XacNhanYeuCauDatPhong.SoPhong = Phong.SoPhong and Phong.LoaiPhong = BangGiaPhong.LoaiPhong and Phong.SucChua = BangGiaPhong.SucChua;
	-- Tính giá các phòng đã đặt
DECLARE @SoPhong INT;
DECLARE @TienGioDau INT;
DECLARE @TienQuaDem INT;
DECLARE @TienGioTiepTheo INT;
DECLARE @CheckIn INT;
declare @ToTalPhong int;
set @ToTalPhong = 0;
while exists(select top 1 * from #PhongDaDat)
begin
	select top 1 @SoPhong = SoPhong,@TienGioDau = TienGioDau,@TienQuaDem = TienQuaDem,@TienGioTiepTheo = TienGioTiepTheo, @CheckIn = CheckIn
	from #PhongDaDat;
	set @ToTalPhong = @ToTalPhong +  dbo.TinhGiaPhong(@TienGioDau,@TienQuaDem,@TienGioTiepTheo,@CheckIn);
	--cap nhat tinh trang phong da tra
	update Phong
	set TinhTrang = N'Trống'
	where Phong.SoPhong = @SoPhong;
	-- xoá phòng đã sau khi đã lấy giá 
	delete from #PhongDaDat
	where SoPhong = @SoPhong
end
	-- xoá bảng tạm thời
	drop table #PhongDaDat;

--xoa yeu cau dat phong
delete YeuCauDatPhong
where YeuCauDatPhong.MaDP = @maDP;
-- xoa danh sach su dung dich vu 
delete DanhSachSuDungDichVu
where DanhSachSuDungDichVu.MaHD = @maHD;

end
go


-- TRIGGER 2 - UPDATE
create trigger CapNhatTinhTrangPhong 
on XacNhanYeuCauDatPhong
after insert as
begin 
    -- Tạo một bảng tạm thời để lưu danh sách các phòng mới được đặt
    create table #PhongMoi (SoPhong INT);

    -- Insert các phòng mới vào bảng tạm thời
    insert into #PhongMoi (SoPhong)
    select distinct new.SoPhong
    from inserted new;

	-- chọn ra khách hàng vừa đặt phòng 
    declare @MaKH INT;
	select @maKH = YeuCauDatPhong.MaKH
	from YeuCauDatPhong , inserted new 
	where YeuCauDatPhong.MaDP = new.MaDP;
	
    -- Lặp qua từng phòng và cập nhật tình trạng của chúng
    declare @SoPhong INT;
    while exists (select top 1 * from #PhongMoi)
    begin
        -- Lấy ra một phòng đầu tiên trong list được đặt 
        select top 1 @SoPhong = SoPhong
        from #PhongMoi;

        -- Cập nhật tình trạng của phòng
        update Phong
        set TinhTrang = N'Đã đặt'
        where SoPhong = @SoPhong;

       

        -- Xóa phòng đã được xử lý khỏi bảng tạm thời
        delete from #PhongMoi
        where SoPhong = @SoPhong;
    end;

    -- Xóa bảng tạm thời
    drop table #PhongMoi;
	 -- Tạo hoá đơn cho khách hàng
        insert into HoaDon(MaKH, NgayThanhToan, TongTienThanhToan)
        values (@MaKH, null, 0);
end;


INSERT INTO KhachHang (TenKH, NgaySinh, CCCD, SDT, LoaiKH)
VALUES
    (N'Nguyễn Văn B', '1990-01-01', '123456789000', '0117654321', N'T');
go




INSERT INTO BangGiaPhong (LoaiPhong, SucChua, TienGioDau, TienQuaDem, TienGioTiepTheo)
VALUES	
    (N'T', 2, 100000, 80000, 50000),
    (N'V', 3, 120000, 90000, 60000),
    (N'T', 4, 150000, 100000, 70000);
go

INSERT INTO Phong (SoPhong, LoaiPhong, SucChua, TinhTrang)
VALUES
    (101, N'T', 2, N'Trống'),
    (102, N'T', 4, N'Trống');
go

INSERT INTO YeuCauDatPhong (MaKH)
VALUES
    (2)
go	

INSERT INTO XacNhanYeuCauDatPhong (SoPhong, MaDP, CheckIn, CheckOut)
VALUES
    (101, 4, '2023-10-10 12:00:00', '2023-10-15 12:00:00'),
	(102, 4, '2023-10-10 12:00:00', '2023-10-15 12:00:00')
go


INSERT INTO DichVu (TenDV, DonGia)
VALUES
    (N'Đồ uống', 50000),
    (N'Ăn sáng', 80000),
    (N'Dịch vụ phòng', 100000);
go

INSERT INTO DanhSachSuDungDichVu (MaHD, MaDV, SoLuong, ThoiDiem)
VALUES
    (4, 100, 2, '2023-10-15 08:30:00'),
    (4, 102, 3, '2023-11-07 07:45:00'),
    (4, 101, 4, '2023-12-24 20:15:00');

delete from XacNhanYeuCauDatPhong
where MaDP = 4


-- Tạo một hàm tính tiền dựa trên giờ check-in và check-out

CREATE FUNCTION TinhSoDem
(
    @checkin_str NVARCHAR(50),
    @checkout_str NVARCHAR(50)
)
RETURNS INT
AS
BEGIN
    DECLARE @checkin DATETIME;
    DECLARE @checkout DATETIME;
    DECLARE @so_gio INT;
    DECLARE @so_dem INT;
    
    SET @checkin = CONVERT(DATETIME, @checkin_str, 120);
    SET @checkout = CONVERT(DATETIME, @checkout_str, 120);

    -- Tính số giờ giữa check-in và check-out
    SET @so_gio = DATEDIFF(HOUR, @checkin, @checkout);

	-- so gio ở trong ngày check in 
	declare @so_gio_ngay_checkin int;
	set @so_gio_ngay_checkin = 24 -DATEPART(HOUR, @checkin);

	-- số giờ ở trong ngày check out 
	declare @so_gio_ngay_checkout int;
	set @so_gio_ngay_checkout = DATEPART(HOUR, @checkout);
	
    -- Tính số đêm giữa check-in và check-out
    SET @so_dem = ( @so_gio - @so_gio_ngay_checkin - @so_gio_ngay_checkout ) / 24;

    -- Kiểm tra nếu check-in trước 22:00 và check-out sau 06:00, thêm 1 đêm
    IF DATEPART(HOUR, @checkin) <= 22 AND DATEPART(HOUR, @checkout) >= 6
    BEGIN
        SET @so_dem = @so_dem + 1;
    END

    RETURN @so_dem;
END;







create function TinhGiaPhong
(
	@TienGioDau int,
	@TienQuaDem int,
	@TienGioTiepTheo int,
	@checkin DateTime
)
returns INT
AS 
BEGIN
-- nếu khách trả phòng >=1 giờ 
	if DATEDIFF(HOUR,@checkin,GETDATE()) >=1
	begin
		return @TienGioDau+(DATEDIFF(HOUR,@checkin,GETDATE())-dbo.TinhSoDem(@checkin,GETDATE())*8-1)*@TienGioTiepTheo + dbo.TinhSoDem(@checkin,GETDATE())*@TienQuaDem ;
	end
	return  @TienGioDau;
END;
print(DATEDIFF(HOUR,'2023-10-9 6:00:00',GETDATE()));
print(dbo.TinhSoDem('2023-10-9 6:00:00', GETDATE()));
print(dbo.TinhGiaPhong(200,500,60,'2023-10-9 6:00:00'));