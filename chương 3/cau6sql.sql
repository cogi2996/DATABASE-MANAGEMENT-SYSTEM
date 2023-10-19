
create table NHANVIEN(
	MANV varchar(9) primary key,
	HONV nvarchar(15),
	TENLOT nvarchar(30),
	TENNV nvarchar(30),
	NGSINH smalldatetime,
	DCHI nvarchar(150),
	PHAI nvarchar(3),
	LUONG numeric(18,0),
	MA_NQL varchar(9) references NHANVIEN(MANV),
	PHG varchar(2) 
);

-- Chèn dữ liệu vào bảng NHANVIEN
INSERT INTO NHANVIEN (MANV, HONV, TENLOT, TENNV, NGSINH, DCHI, PHAI, LUONG, MA_NQL, PHG)
VALUES
    ('NV001', N'Nguyen', N'Van A', N'Nam', '1990-01-01', N'123 Duong A, Quan 1, TP HCM', N'Nam', 5000000, NULL, 'P1'),
    ('NV002', N'Tran', N'Thi B', N'Nu', '1992-02-02', N'456 Duong B, Quan 2, TP HCM', N'Nu', 6000000, NULL, 'P2'),
    ('NV003', N'Le', N'Thi C', N'Nam', '1995-03-03', N'789 Duong C, Quan 3, TP HCM', N'Nam', 5500000, 'NV001', 'P1'),
    ('NV004', N'Pham', N'Thi D', N'Nu', '1993-04-04', N'101 Duong D, Quan 4, TP HCM', N'Nu', 7000000, 'NV002', 'P2'),
    ('NV005', N'Truong', N'Thi E', N'Nam', '1991-05-05', N'202 Duong E, Quan 5, TP HCM', N'Nam', 6000000, 'NV003', 'P1'),
    ('NV006', N'Vo', N'Thi F', N'Nu', '1989-06-06', N'303 Duong F, Quan 6, TP HCM', N'Nu', 7500000, 'NV004', 'P3'),
    ('NV007', N'Dang', N'Thi G', N'Nam', '1990-07-07', N'404 Duong G, Quan 7, TP HCM', N'Nam', 6500000, 'NV005', 'P4'),
    ('NV008', N'Ho', N'Van H', N'Nam', '1992-08-08', N'505 Duong H, Quan 8, TP HCM', N'Nam', 5500000, 'NV006', 'P1'),
    ('NV009', N'Nguyen', N'Van I', N'Nam', '1994-09-09', N'606 Duong I, Quan 9, TP HCM', N'Nam', 5800000, 'NV007', 'P2'),
    ('NV010', N'Mai', N'Thi K', N'Nu', '1993-10-10', N'707 Duong K, Quan 10, TP HCM', N'Nu', 6200000, 'NV008', 'P3');

create table THANNHAN (
	MA_NVIEN varchar(9) references NHANVIEN(MANV),
	TENTN varchar(20),
	NGSINH smalldatetime,
	PHAI varchar(3),
	QUANHE varchar(15),
	primary key (MA_NVIEN, TENTN)
);

-- Chèn dữ liệu vào bảng THANNHAN
INSERT INTO THANNHAN (MA_NVIEN, TENTN, NGSINH, PHAI, QUANHE)
VALUES
    ('NV001', N'Nguyen Van D', '1965-01-01', N'Nam', N'Cha'),
    ('NV001', N'Nguyen Thi E', '1967-02-02', N'Nu', N'Me'),
    ('NV002', N'Tran Van F', '1970-03-03', N'Nam', N'Cha'),
    ('NV002', N'Tran Thi G', '1972-04-04', N'Nu', N'Me'),
    ('NV003', N'Le Van H', '1968-05-05', N'Nam', N'Cha'),
    ('NV003', N'Le Thi I', '1975-06-06', N'Nu', N'Me'),
    ('NV004', N'Pham Van J', '1978-07-07', N'Nam', N'Cha'),
    ('NV004', N'Pham Thi K', '1980-08-08', N'Nu', N'Me'),
    ('NV005', N'Truong Van L', '1979-09-09', N'Nam', N'Cha'),
    ('NV005', N'Truong Thi M', '1982-10-10', N'Nu', N'Me');

create table DEAN (
	MADA varchar(2) primary key,
	TENDA nvarchar(50),
	DDIEM_DA varchar(20),
	PHONG varchar(2)
);

create table PHANCONG (
	MA_NVIEN varchar(9) references NHANVIEN(MANV),
	SODA varchar(2) references DEAN(MADA),
	THOIGIAN numeric(18,0),
	primary key (MA_NVIEN, SODA)
);


create table PHONGBAN (
	MAPHG varchar(2) primary key,
	TENPHG nvarchar(20),
	TRPHG varchar(9) references NHANVIEN(MANV),
	NG_NHANCHUC smalldatetime
);

go


create table DIADIEM_PHG (
	MAPHG varchar(2) references PHONGBAN(MAPHG),
	DIADIEM varchar(20),
	primary key (MAPHG, DIADIEM)
);




-- Chèn dữ liệu vào bảng DEAN
-- Chèn dữ liệu vào bảng PHONGBAN
INSERT INTO PHONGBAN (MAPHG, TENPHG, TRPHG, NG_NHANCHUC)
VALUES
    ('P1', 'Bo phan Ke toan', 'NV001', '2022-01-01'),
    ('P2', 'Bo phan Ky thuat', 'NV002', '2022-02-02'),
    ('P3', 'Bo phan Nhan su', 'NV003', '2022-03-03'),
    ('P4', 'Bo phan Marketing', 'NV004', '2022-04-04'),
    ('P5', 'Bo phan IT', 'NV005', '2022-05-05'),
    ('P6', 'Bo phan Quan ly', 'NV006', '2022-06-06'),
    ('P7', 'Bo phan Kinh doanh', 'NV007', '2022-07-07'),
    ('P8', 'Bo phan Tai chinh', 'NV008', '2022-08-08'),
    ('P9', 'Bo phan Hanh chinh', 'NV009', '2022-09-09');

	ALTER TABLE NHANVIEN ADD FOREIGN KEY (PHG) REFERENCES PHONGBAN(MAPHG);
go
-- Chèn dữ liệu vào bảng DIADIEM_PHG
INSERT INTO DIADIEM_PHG (MAPHG, DIADIEM)
VALUES
    ('P1', N'Chi nhanh A, TP HCM'),
    ('P2', N'Chi nhanh B, TP HCM'),
    ('P3', N'Chi nhanh C, TP HCM'),
    ('P4', N'Chi nhanh D, TP HCM');


-- Chèn dữ liệu vào bảng DEAN
INSERT INTO DEAN (MADA, TENDA, DDIEM_DA, PHONG)
VALUES
    ('D1', N'Phong A', N'Dia diem A', 'P1'),
    ('D2', N'Phong B', N'Dia diem B', 'P2'),
    ('D3', N'Phong C', N'Dia diem C', 'P3'),
    ('D4', N'Phong D', N'Dia diem D', 'P4'),
    ('D5', N'Phong E', N'Dia diem E', 'P1'),
    ('D6', N'Phong F', N'Dia diem F', 'P2'),
    ('D7', N'Phong G', N'Dia diem G', 'P3'),
    ('D8', N'Phong H', N'Dia diem H', 'P4'),
    ('D9', N'Phong I', N'Dia diem I', 'P1');

-- Chèn dữ liệu vào bảng PHANCONG
INSERT INTO PHANCONG (MA_NVIEN, SODA, THOIGIAN)
VALUES
    ('NV001', 'D1', 40),
    ('NV001', 'D2', 30),
    ('NV002', 'D3', 35),
    ('NV002', 'D4', 45),
    ('NV003', 'D5', 50),
    ('NV003', 'D6', 25),
    ('NV004', 'D7', 40),
    ('NV004', 'D8', 30),
    ('NV005', 'D9', 35);


create function TongLuongPhongBan ( @MaPB varchar(2)) 
returns int
as
begin
	declare @TongLuong int;
	set @TongLuong = 0;
	select @TongLuong = sum(NHANVIEN.LUONG)
	from PHONGBAN 
	inner join NHANVIEN on PHONGBAN.MAPHG = NHANVIEN.PHG
	where PHONGBAN.MAPHG = @MaPB
	
return @TongLuong;
end

print(dbo.TongLuongPhongBan('P1'))
CREATE FUNCTION dbo.LuongTrungBinhTungPhongBan()
RETURNS TABLE
AS
RETURN (
    SELECT PHONGBAN.MAPHG AS PhongBan, AVG(NHANVIEN.LUONG) AS luongtrungbinh
    FROM PHONGBAN
    INNER JOIN NHANVIEN ON PHONGBAN.MAPHG = NHANVIEN.PHG
    GROUP BY PHONGBAN.MAPHG
);


create function LuongTrungBinhTungPhongBan ()
returns  table
as 
	return (select PHONGBAN.MAPHG PhongBan,AVG(NHANVIEN.LUONG) luongtrungbinh
	from PHONGBAN
	inner join NHANVIEN on PHONGBAN.MAPHG = NHANVIEN.PHG
	group by PHONGBAN.MAPHG)
go
select * from LuongTrungBinhTungPhongBan()

CREATE FUNCTION dbo.LuongThuong()
RETURNS TABLE
AS
RETURN (
    SELECT NHANVIEN.MANV,
           CASE 
                WHEN SUM(PHANCONG.THOIGIAN) >= 30 AND SUM(PHANCONG.THOIGIAN) <= 60 THEN 500
                WHEN SUM(PHANCONG.THOIGIAN) > 60 AND SUM(PHANCONG.THOIGIAN) < 100 THEN 1000
                WHEN SUM(PHANCONG.THOIGIAN) >= 100 AND SUM(PHANCONG.THOIGIAN) < 150 THEN 1200
                WHEN SUM(PHANCONG.THOIGIAN) >= 150 THEN 1600
                ELSE 0 -- Bạn có thể thiết lập giá trị mặc định nếu cần
           END AS TongTienThuong
    FROM NHANVIEN
    INNER JOIN PHANCONG ON NHANVIEN.MANV = PHANCONG.MA_NVIEN
    GROUP BY NHANVIEN.MANV
);



create function SoDuAnMoiPhong()
returns table as
return (
    select DEAN.PHONG, count(DEAN.MADA) as SoDuAnMoi
    from DEAN
    group by DEAN.PHONG
);


select * from dbo.SoDuAnMoiPhong()

drop function TB_LuongNV
create function TB_LuongNV1()
returns 
	@table table ( MaVN varchar(9) null, tenNV nvarchar(30),ngaysinh smalldatetime null,tenNT nvarchar(30) null,thuong int null)
as 
begin
	
	-- tạo bảng lương thưởng
	declare @luongthuong table (MaNV varchar(9),thuong int);
	insert @luongthuong
	select MaNV, TongTienThuong from dbo.LuongThuong();

	insert @table 
	select NHANVIEN.MANV,NHANVIEN.TENNV, NHANVIEN.NGSINH, 
	THANNHAN.TENTN, LT.thuong
	from NHANVIEN
	inner join THANNHAN on NHANVIEN.MANV = THANNHAN.MA_NVIEN
	inner join @luongthuong LT on LT.MaNV = NHANVIEN.MANV;
	return 
end



select * from dbo.TB_LuongNV1();

create function TB_LuongNV4()
returns @table table (MaVN varchar(9) null, tenNV nvarchar(30), ngaysinh smalldatetime null, tenNT nvarchar(30) null, TongLuong int null)
as 
begin
    declare @luongthuong table (MaNV varchar(9), tienthuong int);
    
    insert @luongthuong (MaNV, tienthuong)
    select MaNV, TongTienThuong from dbo.LuongThuong();

    insert into @table (MaVN, tenNV, ngaysinh, tenNT, TongLuong)
    select NHANVIEN.MANV, NHANVIEN.TENNV, NHANVIEN.NGSINH, THANNHAN.TENTN, sum(NHANVIEN.LUONG+ LT.tienthuong)
    from NHANVIEN
    inner join THANNHAN on NHANVIEN.MANV = THANNHAN.MA_NVIEN
    inner join @luongthuong LT on LT.MaNV = NHANVIEN.MANV
	group by NHANVIEN.MANV,NHANVIEN.TENNV, NHANVIEN.NGSINH, THANNHAN.TENTN

    return;
end


select * from dbo.TB_LuongNV4();