-- use test 
-- go 
-- create PROCEDURE dbo.TinhTongHaiSoNguyen @a int , @b int  
-- AS 
-- Print concat('Tong hai so nguyen la ',@a + @b) 
-- go 
-- execute dbo.TinhTongHaiSoNguyen 2 ,3 
-- go 
-- create PROCEDURE dbo.TinhNamSinh @a int 
-- AS 
-- Print concat('Tuoi cua nguoi do la ',2022 - @a ) 
-- go 
-- execute dbo.TinhNamSinh 2002
-- go 

CREATE FUNCTION AverageSalaryOfDept(@MAPB varchar(2)) Returns money 
AS
	BEGIN 
		DECLARE @averageSalary money 
		SELECT @averageSalary = avg(LUONG)
        FROM NHANVIEN 
        WHERE PHG = @MAPB 
		RETURN @averageSalary 
	END 
go 
select dbo.AverageSalaryOfDept('12')
go 

CREATE FUNCTION SalaryOfCustomerWithProject(@MANV varchar(9) ,@MADA varchar(2)) Returns money 
AS
	BEGIN 
		DECLARE @salary money 
		SELECT @salary = LUONG *(
            SELECT SUM (THOIGIAN)
            FROM PHANCONG pc 
            WHERE MA_NVIEN = @MANV and SODA = @MADA
        )
        FROM NHANVIEN 
        WHERE MANV = @MANV 
		RETURN @salary 
	END 
go 
select dbo.SalaryOfCustomerWithProject('123456789','12')
go
CREATE FUNCTION AVGSalaryDept() RETURNS TABLE
AS
return 
    select  pb.TENPHG , avg(nv.LUONG) 
    from NHANVIEN nv
    inner join PHONGBAN pb on pb.MAPHG = nv.PHG 
    group by (PHG)
go 

select * from SalaryOfCustomerWithProject()
go 

select dbo.SalaryOfCustomerWithProject('123456789','12')
go
CREATE FUNCTION CountBonus() RETURNS TABLE
AS
    return select  
        CASE 
	        WHEN sum(pcTHOIGIAN)>=30 and sum(pcTHOIGIAN) <=60  THEN 500
	        WHEN sum(pcTHOIGIAN)>60 and sum(pcTHOIGIAN) <100  THEN 1000
            WHEN sum(pcTHOIGIAN)>=100 and sum(pcTHOIGIAN) <150  THEN 1200
            WHEN sum(pcTHOIGIAN)>=150   THEN 1600
	        ELSE 0
        END as Bonus
    from PHANCONG pc
    inner join NHANVIEN nv on pc.MA_NVIEN = nv.MANV 
    group by (pc.MA_NVIEN)
go 

select * from CountBonus()
go 

CREATE FUNCTION CountProjectInDept() RETURNS TABLE
AS
   return select  pb.TENPHG , count(da.MADA)
    from DUAN da
    inner join PHONGBAN pb on pb.MAPHG = da.PHONG 
    group by (PHONG)
go 

select * from CountProjectInDept()
go 



-- MaNV, HoTen, NgaySinh, NguoiThan, TongLuongTB.
