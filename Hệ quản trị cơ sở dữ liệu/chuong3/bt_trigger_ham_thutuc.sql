use test 
go 


-- 1.Stored-procedure tính tổng của 2 số nguyên.

CREATE PROC dbo.Tong2SoNguyen @a int = 0  , @b int = 0 
AS
    PRINT N' Tổng 2 số là: ' + CAST(@a + @b AS CHAR(10)) 
go 

Execute dbo.Tong2SoNguyen 7 , 3
go

-- 2.Stored procedure liệt kê những thông tin của đầu sách, thông tin tựa sách và số lượng sách hiện chưa được mượn của một đầu sách cụ thể (ISBN).
--         Với        Tuasach (ma_tuasach, tuasach, tacgia, tomtat)
--                       Dausach (isbn, ma_tuasach, ngonngu, bia, trangthai)
--            Cuonsach (isbn, ma_cuonsach, tinhtrang)


-- 3.Viết hàm tính tuổi của người có năm sinh được nhập vào như một tham số của hàm.
CREATE PROC dbo.TinhSoTuoi @namsinh int 
AS
    PRINT N' Hien nay nguoi do co so tuoi la :' + CAST(2022 - @namsinh   AS CHAR(10)) 
go 

Execute dbo.TinhSoTuoi 2002
go
-- 6 . 
-- 6.1. Viết hàm trả về tổng tiền lương trung bình của một phòng ban tùy ý (truyền vào MaPB)
CREATE FUNCTION AverageSalary(@MaPB varchar(2)) Returns money 
AS
	BEGIN 
		DECLARE @averageMoney money 
		SELECT @averageMoney = avg(nv.Luong)
			FROM NHANVIEN nv 
			WHERE nv.PHG = pb.MAPHG 

		RETURN @averageMoney 
	END 
go 
select dbo.AverageSalary('12')
go 
-- 6.2. Viết hàm trả về tổng lương nhận được của nhân viên theo dự án (truyền vào MaNV và MaDA)
CREATE FUNCTION TotalSalaryOfEmpWithProject(@MaNV varchar(9) , @MaDA varchar(2)) Returns money 
AS
	BEGIN 
		DECLARE @totalSalary money 
		SELECT @totalSalary = Luong *
                    (SELECT  sum(THOIGIAN)
                    FROM  PHANCONG pc
                    WHERE pc.MA_NVien = @MaNV 
                    AND pc.MADA = @MaDa ) 
            FROM NHANVIEN nv
            WHERE nv.MANV = @MaNV 

		RETURN @totalSalary 
	END 
go 
select dbo.TotalSalaryOfEmpWithProject('123456789','23')
go 

-- 6.3. Viết hàm trả về tổng tiền lương trung bình của các phòng ban

CREATE FUNCTION AverageSalaryDepartment() 
RETURNS @table table(Description varchar(50) null , Price money null)
AS
	BEGIN 
		DECLARE @totalSalary money 
		SELECT @totalSalary = Luong *
                    (SELECT  sum(THOIGIAN)
                    FROM  PHANCONG pc
                    WHERE pc.MA_NVien = @MaNV 
                    AND pc.MADA = @MaDa ) 
            FROM NHANVIEN nv
            WHERE nv.MANV = @MaNV 

		RETURN @totalSalary 
	END 
go 
select * from dbo.AverageSalaryDepartment()
go 
-- 6.4. Viết hàm trả về tổng tiền thưởng cho nhân viên dựa vào tổng số giờ tham gia dự án(Time_Total) như sau:
-- - Nếu Time_Total >=30 và <=60 thì tổng tiền thưởng = 500 ($)
-- - Nếu Time_Total >60 và <100 thì tổng tiền thưởng = 1000 ($)
-- - Nếu Time_Total >=100 và <150 thì tổng tiền thưởng =1200($)
-- - Nếu Time_Total >=150 thì tổng tiền thưởng = 1600 ($)
-- 6.5. Viết hàm trả ra tổng số dự án theo mỗi phòng ban.
-- 6.6. Viết hàm trả về kết quả là một bảng (Table), viết bằng hai cách: Inline Table-Valued Functions và Multistatement Table-Valued. Thông tin gồm: MaNV, HoTen, NgaySinh, NguoiThan, TongLuongTB.