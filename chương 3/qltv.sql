-- Tạo cơ sở dữ liệu
CREATE DATABASE ThuVien;

-- Sử dụng cơ sở dữ liệu mới tạo
USE ThuVien;

-- Tạo bảng DocGia
CREATE TABLE DocGia (
    ma_DocGia INT PRIMARY KEY,
    ho NVARCHAR(50),
    tenlot NVARCHAR(50),
    ten NVARCHAR(50),
    ngaysinh DATE
);


-- Tạo bảng Nguoilon
CREATE TABLE Nguoilon (
    ma_DocGia INT PRIMARY KEY,
    sonha NVARCHAR(50),
    duong NVARCHAR(50),
    quan NVARCHAR(50),
    dienthoai NVARCHAR(20),
    han_sd DATE,
	FOREIGN KEY (ma_DocGia) REFERENCES DocGia(ma_DocGia)
);


-- Tạo bảng Treem
CREATE TABLE Treem (
    ma_DocGia INT PRIMARY KEY,
    ma_DocGia_nguoilon INT,
	FOREIGN KEY (ma_DocGia) REFERENCES DocGia(ma_DocGia),
    FOREIGN KEY (ma_DocGia_nguoilon) REFERENCES Nguoilon(ma_DocGia)
);

-- Tạo bảng Tuasach
CREATE TABLE Tuasach (
    ma_tuasach INT PRIMARY KEY,
    tuasach NVARCHAR(100),
    tacgia NVARCHAR(100),
    tomtat NVARCHAR(MAX)
);

-- Tạo bảng Dausach
CREATE TABLE Dausach (
    isbn INT PRIMARY KEY,
    ma_tuasach INT,
    ngonngu NVARCHAR(50),
    bia NVARCHAR(100),
    trangthai NVARCHAR(50),
    FOREIGN KEY (ma_tuasach) REFERENCES Tuasach(ma_tuasach)
);

-- Tạo bảng Cuonsach
CREATE TABLE Cuonsach (
    isbn INT,
    ma_cuonsach INT PRIMARY KEY,
    tinhtrang NVARCHAR(50),
    FOREIGN KEY (isbn) REFERENCES Dausach(isbn)
);

-- Tạo bảng DangKy
CREATE TABLE DangKy (
    isbn INT,
    ma_DocGia INT,
    ngay_dk DATE,
    ghichu NVARCHAR(MAX),
    PRIMARY KEY (isbn, ma_DocGia),
    FOREIGN KEY (isbn) REFERENCES Dausach(isbn),
    FOREIGN KEY (ma_DocGia) REFERENCES DocGia(ma_DocGia)
);

-- Tạo bảng Muon
CREATE TABLE Muon (
    isbn INT,
    ma_cuonsach INT,
    ma_DocGia INT,
    ngay_muon DATE,
    ngay_hethan DATE,
    PRIMARY KEY (isbn, ma_cuonsach, ma_DocGia),
    FOREIGN KEY (isbn) REFERENCES Dausach(isbn),
    FOREIGN KEY (ma_cuonsach) REFERENCES Cuonsach(ma_cuonsach),
    FOREIGN KEY (ma_DocGia) REFERENCES DocGia(ma_DocGia)
);

-- Tạo bảng QuaTrinhMuon
CREATE TABLE QuaTrinhMuon (
    isbn INT,
    ma_cuonsach INT,
    ngay_muon DATE,
    ma_DocGia INT,
    ngay_hethan DATE,
    ngay_tra DATE,
    tien_muon DECIMAL(10, 2),
    tien_datra DECIMAL(10, 2),
    tien_datcoc DECIMAL(10, 2),
    ghichu NVARCHAR(MAX),
    PRIMARY KEY (isbn, ma_cuonsach, ngay_muon, ma_DocGia),
    FOREIGN KEY (isbn) REFERENCES Dausach(isbn),
    FOREIGN KEY (ma_cuonsach) REFERENCES Cuonsach(ma_cuonsach),
    FOREIGN KEY (ma_DocGia) REFERENCES DocGia(ma_DocGia)
);


-- Chèn dữ liệu cho bảng DocGia
INSERT INTO DocGia (ma_DocGia, ho, tenlot, ten, ngaysinh)
VALUES
    (1, 'Nguyen', 'Van', 'A', '1990-01-01'),
    (2, 'Tran', 'Thi', 'B', '1995-02-15'),
    (3, 'Le', 'Van', 'C', '1985-05-20'),
    (4, 'Pham', 'Thi', 'D', '2000-03-10'),
    (5, 'Hoang', 'Van', 'E', '1992-12-05'),
    (6, 'Vo', 'Thi', 'F', '1998-06-18'),
    (7, 'Dang', 'Van', 'G', '1993-08-22'),
    (8, 'Do', 'Van', 'H', '1988-04-30'),
    (9, 'Nguyen', 'Thi', 'I', '1997-07-12'),
    (10, 'Tran', 'Van', 'J', '2002-09-25');


-- Chèn dữ liệu cho bảng Nguoilon
INSERT INTO Nguoilon (ma_DocGia, sonha, duong, quan, dienthoai, han_sd)
VALUES
    (1, '123', 'Duong A', 'Quan 1', '0123456789', '2023-12-31'),
    (2, '456', 'Duong B', 'Quan 2', '0987654321', '2024-06-30'),
    (3, '789', 'Duong C', 'Quan 3', '0123456789', '2023-10-31'),
    (4, '101', 'Duong D', 'Quan 4', '0987654321', '2024-02-28');
 

-- Chèn dữ liệu cho bảng Treem
INSERT INTO Treem (ma_DocGia, ma_DocGia_nguoilon)
VALUES

    (5, 1),
    (6, 2),
    (7, 1),
    (8, 3),
    (9, 4),
    (10, 1);

-- Chèn dữ liệu cho bảng Tuasach
INSERT INTO Tuasach (ma_tuasach, tuasach, tacgia, tomtat)
VALUES
    (101, 'Sach 1', 'Tac Gia 1', 'Tom Tat Sach 1'),
    (102, 'Sach 2', 'Tac Gia 2', 'Tom Tat Sach 2'),
    (103, 'Sach 3', 'Tac Gia 3', 'Tom Tat Sach 3'),
    (104, 'Sach 4', 'Tac Gia 4', 'Tom Tat Sach 4'),
    (105, 'Sach 5', 'Tac Gia 5', 'Tom Tat Sach 5'),
    (106, 'Sach 6', 'Tac Gia 6', 'Tom Tat Sach 6'),
    (107, 'Sach 7', 'Tac Gia 7', 'Tom Tat Sach 7'),
    (108, 'Sach 8', 'Tac Gia 8', 'Tom Tat Sach 8'),
    (109, 'Sach 9', 'Tac Gia 9', 'Tom Tat Sach 9'),
    (110, 'Sach 10', 'Tac Gia 10', 'Tom Tat Sach 10');

-- Chèn dữ liệu cho bảng Dausach
INSERT INTO Dausach (isbn, ma_tuasach, ngonngu, bia, trangthai)
VALUES
    (1001, 101, 'Tieng Viet', 'Bia Sach 1', 'Da muon'),
    (1002, 102, 'Tieng Anh', 'Bia Sach 2', 'Chua duoc muon'),
    (1003, 103, 'Tieng Viet', 'Bia Sach 3', 'Da muon'),
    (1004, 104, 'Tieng Anh', 'Bia Sach 4', 'Da muon'),
    (1005, 105, 'Tieng Viet', 'Bia Sach 5', 'Da muon'),
    (1006, 106, 'Tieng Anh', 'Bia Sach 6', 'Chua duoc muon'),
    (1007, 107, 'Tieng Viet', 'Bia Sach 7', 'Da muon'),
    (1008, 108, 'Tieng Anh', 'Bia Sach 8', 'Chua duoc muon'),
    (1009, 109, 'Tieng Viet', 'Bia Sach 9', 'Da muon'),
    (1010, 110, 'Tieng Anh', 'Bia Sach 10', 'Chua duoc muon');

-- Chèn dữ liệu cho bảng Cuonsach

INSERT INTO Cuonsach (isbn, ma_cuonsach, tinhtrang)
VALUES
    (1001, 1, 'Da muon'),
    (1001, 2, 'Chua duoc muon'),
    (1001, 3, 'Chua duoc muon'),
    (1002, 4, 'Da muon'),
    (1002, 5, 'Chua duoc muon'),
    (1003, 6, 'Chua duoc muon'),
    (1004, 7, 'Da muon'),
    (1004, 8, 'Chua duoc muon'),
    (1005, 9, 'Da muon'),
    (1006, 10, 'Chua duoc muon');


-- Chèn dữ liệu cho bảng DangKy
INSERT INTO DangKy (isbn, ma_DocGia, ngay_dk, ghichu)
VALUES
    (1001, 1, '2023-01-15', 'Ghi chu 1'),
    (1001, 2, '2023-02-20', 'Ghi chu 2'),
    (1002, 3, '2023-03-25', 'Ghi chu 3'),
    (1002, 4, '2023-04-30', 'Ghi chu 4'),
    (1003, 5, '2023-05-05', 'Ghi chu 5'),
    (1003, 6, '2023-06-10', 'Ghi chu 6'),
    (1004, 7, '2023-07-15', 'Ghi chu 7'),
    (1004, 8, '2023-08-20', 'Ghi chu 8'),
    (1005, 9, '2023-09-25', 'Ghi chu 9'),
    (1005, 10, '2023-10-30', 'Ghi chu 10');

-- Chèn dữ liệu cho bảng Muon
INSERT INTO Muon (isbn, ma_cuonsach, ma_DocGia, ngay_muon, ngay_hethan)
VALUES
    (1001, 1, 1, '2023-01-16', '2023-02-15'),
    (1001, 2, 2, '2023-02-21', '2023-03-20'),
    (1002, 3, 3, '2023-03-26', '2023-04-25'),
    (1002, 4, 4, '2023-04-30', '2023-05-29'),
    (1003, 5, 5, '2023-05-06', '2023-06-05'),
    (1003, 6, 6, '2023-06-11', '2023-07-10'),
    (1004, 7, 7, '2023-07-16', '2023-08-15'),
    (1004, 8, 8, '2023-08-21', '2023-09-20'),
    (1005, 9, 9, '2023-09-26', '2023-10-25'),
    (1005, 10, 10, '2023-10-31', '2023-11-30');

-- Chèn dữ liệu cho bảng QuaTrinhMuon
INSERT INTO QuaTrinhMuon (isbn, ma_cuonsach, ngay_muon, ma_DocGia, ngay_hethan, ngay_tra, tien_muon, tien_datra, tien_datcoc, ghichu)
VALUES
    (1001, 1, '2023-01-16', 1, '2023-02-15', null, null, null, null, 'Ghi chu muon 1'),
    (1001, 2, '2023-02-21', 2, '2023-03-20', '2023-03-18', 25.0, 25.0, 5.0, 'Ghi chu muon 2'),
    (1002, 3, '2023-03-26', 3, '2023-04-25', '2023-04-20', 30.0, 30.0, 0, 'Ghi chu muon 3'),
    (1002, 4, '2023-04-30', 4, '2023-05-29', null, null, null, null, 'Ghi chu muon 4'),
    (1003, 5, '2023-05-06', 5, '2023-06-05', '2023-06-02', 40.0, 40.0, 0, 'Ghi chu muon 5'),
    (1003, 6, '2023-06-11', 6, '2023-07-10', '2023-07-05', 45.0, 45.0, 0, 'Ghi chu muon 6'),
    (1004, 7, '2023-07-16', 7, '2023-08-15', '2023-08-10', 50.0, 50.0, 0, 'Ghi chu muon 7'),
    (1004, 8, '2023-08-21', 8, '2023-09-20', '2023-09-15', 55.0, 55.0, 0, 'Ghi chu muon 8'),
    (1005, 9, '2023-09-26', 9, '2023-10-25', '2023-10-20', 60.0, 60.0, 0, 'Ghi chu muon 9'),
    (1005, 10, '2023-10-31', 10, '2023-11-30', '2023-11-25', 65.0, 65.0, 0, 'Ghi chu muon 10');

create proc	sp_ThongtinDocGia
	@DocGia int
as
begin
	if exists (select * from Nguoilon where Nguoilon.ma_DocGia = @DocGia)
	begin
		-- in thông tin người lớn
		select DocGia.ma_DocGia ma_DocGiaNguoiLon,DocGia.ho,DocGia.ten,DocGia.ngaysinh, Nguoilon.sonha,Nguoilon.duong,Nguoilon.quan,Nguoilon.dienthoai,Nguoilon.han_sd
		from DocGia
		inner join Nguoilon on DocGia.ma_DocGia =Nguoilon.ma_DocGia
		where DocGia.ma_DocGia = @DocGia
	end
	else if exists (select * from Treem where Treem.ma_DocGia = @DocGia)
	begin
		-- in thông tin người lớn
		select DocGia.ma_DocGia ma_DocGiaTreEm,DocGia.ho,DocGia.ten,DocGia.ngaysinh,Nguoilon.ma_DocGia ma_PhuHuynh
		from DocGia
		inner join Treem on DocGia.ma_DocGia =Treem.ma_DocGia
		inner join Nguoilon on Treem.ma_DocGia_nguoilon = Nguoilon.ma_DocGia
		where DocGia.ma_DocGia = @DocGia ;
	end
	else 
		print 'not available madogia'
end;

execute sp_ThongtinDocGia 5

create proc sp_ThongtinDausach
	@maDauSach int
as
begin
	select Dausach.isbn madausach, Dausach.bia bia,Dausach.ma_tuasach ma_tuasach
	,Dausach.ngonngu ngonngu,Dausach.trangthai trangthai4
	,tuasach.tuasach tuasach, tuasach.tacgia tacgia,tuasach.tomtat tomtat 
	,count(Cuonsach.ma_cuonsach)
	from Dausach
	inner join Tuasach on Dausach.ma_tuasach = tuasach.ma_tuasach
	inner join Cuonsach on Dausach.isbn = Cuonsach.isbn
	where Dausach.isbn= @maDauSach and Cuonsach.tinhtrang = 'Chua duoc muon' 
	group by Dausach.isbn, Dausach.bia,Dausach.ma_tuasach,Dausach.ngonngu,Dausach.trangthai,tuasach.tuasach, tuasach.tacgia,tuasach.tomtat
end
execute sp_ThongtinDausach 1005

create proc sp_ThongtinNguoilonDangmuon
as 
begin
	select DocGia.ma_DocGia maDocGia, DocGia.ho ho,DocGia.tenlot tenlot,DocGia.ten ten, DocGia.ngaysinh ngaysinh
	,Nguoilon.sonha sonha, Nguoilon.duong duong,Nguoilon.quan quan, Nguoilon.dienthoai dienthoai, Nguoilon.han_sd hansd
	from Nguoilon
	inner join DangKy on Nguoilon.ma_DocGia = DangKy.ma_DocGia
	inner join DocGia on Nguoilon.ma_DocGia = DocGia.ma_DocGia
end;

execute sp_ThongtinNguoilonDangmuon

create proc sp_ThongtinNguoilonQuahan
as
begin
-- Tạo bảng tạm thời để lưu kết quả từ stored procedure sp_ThongtinNguoilonDangmuon
    CREATE TABLE #NguoiLonDangMuon (
        maDocGia INT,
        ho NVARCHAR(50),
        tenlot NVARCHAR(50),
        ten NVARCHAR(50),
        ngaysinh DATE,
        sonha NVARCHAR(50),
        duong NVARCHAR(50),
        quan NVARCHAR(50),
        dienthoai NVARCHAR(15),
        hansd DATE
    );
	insert into #NguoiLonDangMuon
	exec sp_ThongtinNguoilonDangmuon; 

	-- tìm ra các người lớn đang mượn quá hạn
	select *
	from #NguoiLonDangMuon
	inner join QuaTrinhMuon on #NguoiLonDangMuon.maDocGia = QuaTrinhMuon.ma_DocGia
	where QuaTrinhMuon.ngay_tra is null and DATEDIFF(DAY,QuaTrinhMuon.ngay_hethan,GETDATE())>=14 ; 
	
	-- drop temp table
	drop table #NguoiLonDangMuon
end;

exec sp_ThongtinNguoilonQuahan
drop proc NguoiLonVaTreEmDangMuon
create proc NguoiLonVaTreEmDangMuon
as
begin
-- Tạo bảng tạm thời để lưu kết quả từ stored procedure sp_ThongtinNguoilonDangmuon
    CREATE TABLE #NguoiLonDangMuon (
        maDocGia INT,
        ho NVARCHAR(50),
        tenlot NVARCHAR(50),
        ten NVARCHAR(50),
        ngaysinh DATE,
        sonha NVARCHAR(50),
        duong NVARCHAR(50),
        quan NVARCHAR(50),
        dienthoai NVARCHAR(15),
        hansd DATE
    );
	insert into #NguoiLonDangMuon
	exec sp_ThongtinNguoilonDangmuon; 

	-- tìm ra các người lớn đang mượn quá hạn
	select #NguoiLonDangMuon.maDocGia maDocGiaNguoiLon,#NguoiLonDangMuon.ten tenNguoiLon,Treem.ma_DocGia maDocGiaTreEm , DocGia.ten TenTreEm
	from #NguoiLonDangMuon
	inner join Treem on #NguoiLonDangMuon.maDocGia =Treem.ma_DocGia_nguoilon
	inner join Muon on Treem.ma_DocGia = Muon.ma_DocGia
	inner join DocGia on Treem.ma_DocGia = DocGia.ma_DocGia
	order by maDocGiaNguoiLon
	
	-- drop temp table
	drop table #NguoiLonDangMuon

end;
exec NguoiLonVaTreEmDangMuon