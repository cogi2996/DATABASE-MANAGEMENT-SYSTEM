-------------------------------------------------Constraint----------------------------------------------------------------------
use [NLBank]
GO

ALTER TABLE KHOANVAY
ADD CONSTRAINT FK_KV_LoaiKV
FOREIGN KEY (MaLoaiKV) REFERENCES LOAIKV(MaLoaiKV) ON DELETE SET NULL;
GO

ALTER TABLE TAISANDAMBAO
ADD CONSTRAINT FK_TSDB_LoaiTSDB
FOREIGN KEY (MaLoaiTSDB) REFERENCES LOAITSDB(MaLoaiTSDB) ON DELETE SET NULL;
GO

-- *Chức vụ*
-- -Hệ số lương >= 1
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
ADD CHECK(MucPhi >= 0)
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
-- - pct_lai >= 0%
ALTER TABLE DIEUKHOAN 
ADD CHECK (Pct_lai >= 0)
GO

-- *Giấy nhận nợ* 
-- GIAYNHANNO(SoGNN, SoHDTD, MaKH, NgayKyGNN, ChiNhanh, HanMucTinDung, HanTraNo, LaiQuaHan, LaiSuat)
-- HDTD(SoHDTD, MaKV, MaKH, Muc_dich, LaiSuat, LaiQuaHan, ThoiHanVay, PhuongThucTra, MucPhi, TGGiaiNgan, LoaiTien, NgayKi)

-- - 0 ≤ Lãi suất ≤ Lãi quá hạn
ALTER TABLE GIAYNHANNO
ADD CONSTRAINT Check_Laisuat_Laiquahan CHECK(LaiSuat > 0 AND  LaiSuat < LaiQuaHan);
go

-- *Chứng từ thu nợ*
-- - Số dư nợ > 0
ALTER TABLE CHUNGTUTHUNO
ADD CONSTRAINT Check_Soduno CHECK(SoDuNo > 0  );
go

-- - 0 ≤ Số tiền trả ≤ Số dư nợ
ALTER TABLE CHUNGTUTHUNO
ADD CONSTRAINT Check_Soduno_Sodunogoc CHECK(0 <= SoTienTra AND SoTienTra <= SoDuNo);
go

----------------------------------------------TRIGGER------------------------------------------------------------
-- - Hạn trả nợ ≥ ngày kí giấy nhận nợ
CREATE OR ALTER TRIGGER [dbo].[Check_Ngaynhanno_Trigger] ON [dbo].[GIAYNHANNO]
AFTER INSERT, UPDATE
AS
IF EXISTS (
           SELECT * FROM GIAYNHANNO
	INNER JOIN HDTD AS hdtd
    ON GIAYNHANNO.SoHDTD = hdtd.SoHDTD
        AND GIAYNHANNO.HanTraNo <=  hdtd.NgayKi
          )
BEGIN
    RAISERROR ('Ngay han tra no phai sau ngay ky ', 16, 1);
    ROLLBACK TRANSACTION;
    RETURN
END;
GO

-- *Chứng từ giải ngân*
-- - Số tiền giải ngân = số tiền vay
CREATE OR ALTER TRIGGER Check_Sotiengiaingan_Trigger ON CHUNGTUGIAINGAN
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

CREATE OR ALTER TRIGGER trigger_khoanvay ON KHOANVAY
AFTER UPDATE 
AS 
DECLARE @Diem_tindung int;
DECLARE @MaKh int;

SELECT @MaKh = MaKH
from inserted;

SELECT @Diem_tindung = FICO_score
FROM CANHAN
WHERE MaKH = @MaKh;

BEGIN
    IF @Diem_tindung < 500 
    BEGIN
        PRINT('Chua du diem tinh dung')
        ROLLBACK
    END
END
GO

-- Xóa khách hàng ⇒ xóa các tài sản đảm bảo tương ứng
CREATE OR ALTER TRIGGER Delete_customer_Trigger ON KHACHHANG 
AFTER DELETE 
AS 
BEGIN
    declare 
		@makh int = (select MaKH from deleted),
		@email char(50) = (SELECT Email FROM deleted)

    DELETE from TAISANDAMBAO WHERE MaKH = @makh
	DELETE FROM Authenciation WHERE Email = @email
END
go

--  HDTD(SoHDTD, MaKV, MaKH, Muc_dich, LaiSuat, LaiQuaHan, ThoiHanVay, PhuongThucTra, MucPhi, TGGiaiNgan, LoaiTien, NgayKi) 
-- Hợp đồng tín dụng 
CREATE OR ALTER TRIGGER create_hdtd_Trigger ON HDTD 
AFTER INSERT 
AS 
BEGIN
    declare @sotienvay int  = (select SoTienVay
    from KHOANVAY INNER JOIN inserted on inserted.MaKV = KHOANVAY.MaKV)

    INSERT INTO History
        (MaKH, SoHDTD, SoTienVay, SoTienTra , DaHoanThanh)
    SELECT MaKH, SoHDTD, @sotienvay , 0 , 0
    FROM inserted
END
go

-- Mỗi lần khách hàng trả nợ (thu nợ) ⇒ cập nhật vào lịch sử vay
-- CHUNGTUTHUNO(SoCTThuNo, SoHDTD, KyThuNoGoc, KyThuNoLai, SoDuNoGoc, SoDuNo, SotienTra, NgayThuNo)
CREATE OR ALTER TRIGGER create_CTTN_Trigger ON CHUNGTUTHUNO 
AFTER INSERT 
AS 
BEGIN
    declare @sotientra int  = (select CHUNGTUTHUNO.SoTienTra
    from CHUNGTUTHUNO INNER JOIN inserted on inserted.SoCTThuNo = CHUNGTUTHUNO.SoCTThuNo)
    declare @sotienvay int  = (select History.SoTienVay
    from History INNER JOIN inserted on inserted.SoCTThuNo = History.SoCTThuNo)
    declare @soCTThuNo int  = (select History.SoCTThuNo
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
GO




