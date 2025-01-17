-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Anamakine: localhost
-- Üretim Zamanı: 17 Oca 2025, 18:27:50
-- Sunucu sürümü: 10.4.28-MariaDB
-- PHP Sürümü: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `guven_bank`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `Kredi`
--

CREATE TABLE `Kredi` (
  `kredi_id` int(11) NOT NULL,
  `kullanici_id` int(11) DEFAULT NULL,
  `miktar` decimal(10,2) DEFAULT NULL,
  `vade` int(11) DEFAULT NULL,
  `toplam_odeme` decimal(10,2) DEFAULT NULL,
  `durum` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

--
-- Tablo döküm verisi `Kredi`
--

INSERT INTO `Kredi` (`kredi_id`, `kullanici_id`, `miktar`, `vade`, `toplam_odeme`, `durum`) VALUES
(24, 5, 3000.00, 3, 3090.00, 'onaylı');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `kullanicilar`
--

CREATE TABLE `kullanicilar` (
  `kullanici_id` int(11) NOT NULL,
  `tc_no` varchar(11) NOT NULL,
  `tel_no` varchar(11) NOT NULL,
  `guvenlik_sorusu` varchar(75) NOT NULL,
  `guvenlik_cevap` varchar(75) NOT NULL,
  `musteri_no` varchar(20) NOT NULL,
  `sifre` varchar(50) NOT NULL,
  `ad_soyad` varchar(50) DEFAULT 'Bilinmiyor'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

--
-- Tablo döküm verisi `kullanicilar`
--

INSERT INTO `kullanicilar` (`kullanici_id`, `tc_no`, `tel_no`, `guvenlik_sorusu`, `guvenlik_cevap`, `musteri_no`, `sifre`, `ad_soyad`) VALUES
(5, '11111111111', '22222222222', 'En sevdiğiniz nesne nedir?', 'Bilgisayar', '3018324', '3444', 'Görkem Güven'),
(6, '22222222222', '44444444444', 'En sevdiğiniz nesne nedir?', 'Kitap', '7008552', '3892', 'Kartal Güven'),
(7, '33333333333', '66666666666', 'Evcil hayvanınızın adı nedir?', 'Ruby', '1469870', '1735', 'Kemal Yeşilyurt');

--
-- Tetikleyiciler `kullanicilar`
--
DELIMITER $$
CREATE TRIGGER `bakiye_ekle` AFTER INSERT ON `kullanicilar` FOR EACH ROW INSERT INTO kullanici_bakiye(kullanici_id,bakiye,musteri_no)VALUES(NEW.kullanici_id,0,NEW.musteri_no)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `bakiye_sil` AFTER DELETE ON `kullanicilar` FOR EACH ROW DELETE FROM kullanici_bakiye 
WHERE kullanici_id = OLD.kullanici_id
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `fatura_ekle` AFTER INSERT ON `kullanicilar` FOR EACH ROW INSERT INTO kullanici_faturalar(kullanici_id,elektrik,su,dogalgaz,internet)
VALUES(
	NEW.kullanici_id,
    35 + RAND() * 465,
    35 + RAND() * 465,
    35 + RAND() * 465,
    35 + RAND() * 465
)
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `fatura_sil` AFTER DELETE ON `kullanicilar` FOR EACH ROW DELETE FROM kullanici_faturalar
WHERE kullanici_id = OLD.kullanici_id
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `kullanici_bakiye`
--

CREATE TABLE `kullanici_bakiye` (
  `id` int(11) NOT NULL,
  `kullanici_id` int(11) NOT NULL,
  `bakiye` decimal(10,2) NOT NULL,
  `musteri_no` varchar(20) NOT NULL,
  `ad_soyad` varchar(50) DEFAULT 'Bilinmiyor'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

--
-- Tablo döküm verisi `kullanici_bakiye`
--

INSERT INTO `kullanici_bakiye` (`id`, `kullanici_id`, `bakiye`, `musteri_no`, `ad_soyad`) VALUES
(3, 5, 52140.90, '3018324', 'Görkem Güven'),
(4, 6, 29484.67, '7008552', 'Kartal Güven'),
(5, 7, 3000.00, '1469870', 'Kemal Yeşilyurt');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `kullanici_faturalar`
--

CREATE TABLE `kullanici_faturalar` (
  `id` int(11) NOT NULL,
  `kullanici_id` int(11) NOT NULL,
  `elektrik` decimal(10,2) NOT NULL,
  `su` decimal(10,2) NOT NULL,
  `dogalgaz` decimal(10,2) NOT NULL,
  `internet` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

--
-- Tablo döküm verisi `kullanici_faturalar`
--

INSERT INTO `kullanici_faturalar` (`id`, `kullanici_id`, `elektrik`, `su`, `dogalgaz`, `internet`) VALUES
(2, 5, 180.00, 200.00, 500.00, 470.00),
(3, 6, 320.00, 280.00, 675.00, 349.00),
(80, 83, 471.61, 149.00, 225.18, 178.88);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `OdemePlani`
--

CREATE TABLE `OdemePlani` (
  `odeme_id` int(11) NOT NULL,
  `kredi_id` int(11) DEFAULT NULL,
  `vade_ay` int(11) DEFAULT NULL,
  `odeme_tutari` decimal(10,2) DEFAULT NULL,
  `odendi` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_turkish_ci;

--
-- Tablo döküm verisi `OdemePlani`
--

INSERT INTO `OdemePlani` (`odeme_id`, `kredi_id`, `vade_ay`, `odeme_tutari`, `odendi`) VALUES
(40, 24, 1, 1030.00, 1),
(41, 24, 2, 1030.00, 1),
(42, 24, 3, 1030.00, 1);

--
-- Dökümü yapılmış tablolar için indeksler
--

--
-- Tablo için indeksler `Kredi`
--
ALTER TABLE `Kredi`
  ADD PRIMARY KEY (`kredi_id`),
  ADD UNIQUE KEY `kullanici_id` (`kullanici_id`);

--
-- Tablo için indeksler `kullanicilar`
--
ALTER TABLE `kullanicilar`
  ADD PRIMARY KEY (`kullanici_id`),
  ADD UNIQUE KEY `tc_no` (`tc_no`),
  ADD UNIQUE KEY `musteri_no` (`musteri_no`);

--
-- Tablo için indeksler `kullanici_bakiye`
--
ALTER TABLE `kullanici_bakiye`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kullanici_id` (`kullanici_id`),
  ADD UNIQUE KEY `musteri_no` (`musteri_no`);

--
-- Tablo için indeksler `kullanici_faturalar`
--
ALTER TABLE `kullanici_faturalar`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `kullanici_id` (`kullanici_id`);

--
-- Tablo için indeksler `OdemePlani`
--
ALTER TABLE `OdemePlani`
  ADD PRIMARY KEY (`odeme_id`),
  ADD KEY `kredi_id` (`kredi_id`) USING BTREE;

--
-- Dökümü yapılmış tablolar için AUTO_INCREMENT değeri
--

--
-- Tablo için AUTO_INCREMENT değeri `Kredi`
--
ALTER TABLE `Kredi`
  MODIFY `kredi_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- Tablo için AUTO_INCREMENT değeri `kullanicilar`
--
ALTER TABLE `kullanicilar`
  MODIFY `kullanici_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

--
-- Tablo için AUTO_INCREMENT değeri `kullanici_bakiye`
--
ALTER TABLE `kullanici_bakiye`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Tablo için AUTO_INCREMENT değeri `kullanici_faturalar`
--
ALTER TABLE `kullanici_faturalar`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=81;

--
-- Tablo için AUTO_INCREMENT değeri `OdemePlani`
--
ALTER TABLE `OdemePlani`
  MODIFY `odeme_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=43;

--
-- Dökümü yapılmış tablolar için kısıtlamalar
--

--
-- Tablo kısıtlamaları `Kredi`
--
ALTER TABLE `Kredi`
  ADD CONSTRAINT `kredi_ibfk_1` FOREIGN KEY (`kullanici_id`) REFERENCES `kullanicilar` (`kullanici_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
