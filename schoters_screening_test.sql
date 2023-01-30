SELECT *
FROM schoters_screening.transaksi;

SELECT *
FROM schoters_screening.campaign;

SELECT *
FROM schoters_screening.customer;

-- Tabel transaksi
-- Standarisasi date format
SELECT `Tanggal Transaksi`, CONVERT(`Tanggal Transaksi`, DATE)
FROM schoters_screening.transaksi;

ALTER TABLE schoters_screening.transaksi
ADD TanggalTransaksi DATE;

UPDATE schoters_screening.transaksi
SET TanggalTransaksi = CONVERT(`Tanggal Transaksi`, DATE);

-- Ubah Harga Asli menjadi INT

SELECT `Harga Asli`, CAST(REPLACE(SUBSTRING(`Harga Asli`, 3), ",", "") AS UNSIGNED)
FROM schoters_screening.transaksi;

UPDATE schoters_screening.transaksi
SET `Harga Asli` = CAST(REPLACE(SUBSTRING(`Harga Asli`, 3), ",", "") AS UNSIGNED);

-- Hapus kolom Tanggal Transaksi
ALTER TABLE schoters_screening.transaksi
DROP COLUMN `Tanggal Transaksi`;

-- Tabel Campaign
-- Standarisasi date format
SELECT `Start Date`, `End Date`, CONVERT(`Start Date`, DATE), CONVERT(`End Date`, DATE)
FROM schoters_screening.campaign;

ALTER TABLE schoters_screening.campaign
ADD (StartDate DATE, EndDate DATE);

UPDATE schoters_screening.campaign
SET StartDate = CONVERT(`Start Date`, DATE);

UPDATE schoters_screening.campaign
SET EndDate = CONVERT(`End Date`, DATE);

-- Ubah Budget menjadi INT
SELECT Budget, CAST(REPLACE(SUBSTRING(Budget, 3), ",", "") AS UNSIGNED)
FROM schoters_screening.campaign;

UPDATE schoters_screening.campaign
SET Budget = CAST(REPLACE(SUBSTRING(Budget, 3), ",", "") AS UNSIGNED);

-- Hapus kolom Start Date dan End Date
ALTER TABLE schoters_screening.campaign
DROP COLUMN `Start Date`;

ALTER TABLE schoters_screening.campaign
DROP COLUMN `End Date`;

-- Total transaksi dari masing-masing customer
SELECT Customer, COUNT(*) AS `Jumlah Pembelian`, SUM(`Harga Asli`) AS `Total Transaksi`
FROM schoters_screening.transaksi
GROUP BY Customer;

-- Total transaksi dari masing-masing kota
SELECT c.Domisili, COUNT(*) AS `Jumlah Pembelian`, SUM(t.`Harga Asli`) AS `Total Transaksi`
FROM schoters_screening.transaksi t
JOIN schoters_screening.customer c
	ON t.Customer = c.Name
GROUP BY c.Domisili;

-- Exploratory Data Analysis
-- Total revenue berdasarkan Tipe Produk
SELECT `Tipe Produk`, COUNT(*) AS ProdukTerjual, ROUND(AVG(`Harga Asli`), 2) AS AveragePrice, SUM(`Harga Asli`) AS TotalRevenue
FROM schoters_screening.transaksi
GROUP BY `Tipe Produk`
ORDER BY 4 DESC;

-- Total revenue berdasarkan Nama Sales
SELECT `Nama Sales`, SUM(`Harga Asli`) AS TotalRevenue
FROM schoters_screening.transaksi
GROUP BY `Nama Sales`
ORDER BY 2 DESC;

-- Total revenue per bulan
SELECT  MONTHNAME(t.TanggalTransaksi) AS Bulan,
		SUM(t.`Harga Asli`) AS TotalRevenue,
        c.Name,
        c.Budget
FROM schoters_screening.transaksi t
LEFT JOIN schoters_screening.campaign c
	ON MONTHNAME(t.TanggalTransaksi) = MONTHNAME(c.StartDate)
GROUP BY MONTH(t.TanggalTransaksi);

-- Revenue per bulan berdasarkan sales
SELECT  MONTHNAME(TanggalTransaksi) AS Bulan,
		`Nama Sales`,
		SUM(`Harga Asli`) AS TotalRevenue
FROM schoters_screening.transaksi
GROUP BY MONTH(TanggalTransaksi), `Nama Sales`;

-- Total revenue berdasarkan usia
SELECT c.Name, c.Usia, SUM(t.`Harga Asli`) AS TotalRevenue
FROM schoters_screening.transaksi t
JOIN schoters_screening.customer c
	ON t.Customer = c.Name
GROUP BY c.Name
ORDER BY 3 DESC;
