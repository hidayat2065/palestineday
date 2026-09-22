-- MySQL dump 10.13  Distrib 8.4.11, for Linux (x86_64)
--
-- Host: localhost    Database: palestineday_staging
-- ------------------------------------------------------
-- Server version	8.4.11-0ubuntu0.26.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `m_lokasi`
--

DROP TABLE IF EXISTS `m_lokasi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `m_lokasi` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `lokasi` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `m_lokasi`
--

LOCK TABLES `m_lokasi` WRITE;
/*!40000 ALTER TABLE `m_lokasi` DISABLE KEYS */;
INSERT INTO `m_lokasi` VALUES (1,'Sekolah Demo Bandung',NULL,NULL),(2,'Sekolah Demo Cimahi',NULL,NULL),(3,'Sekolah Demo Sumedang',NULL,NULL);
/*!40000 ALTER TABLE `m_lokasi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `m_siswa_aktif`
--

DROP TABLE IF EXISTS `m_siswa_aktif`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `m_siswa_aktif` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nama_anak` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `sekolah_id` bigint unsigned NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `m_siswa_aktif`
--

LOCK TABLES `m_siswa_aktif` WRITE;
/*!40000 ALTER TABLE `m_siswa_aktif` DISABLE KEYS */;
INSERT INTO `m_siswa_aktif` VALUES (1,'Ahmad Demo',1,NULL,NULL),(2,'Aisyah Demo',1,NULL,NULL),(3,'Fahri Demo',2,NULL,NULL),(4,'Fatimah Demo',2,NULL,NULL),(5,'Rizky Demo',3,NULL,NULL);
/*!40000 ALTER TABLE `m_siswa_aktif` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `m_nominal_donasi`
--

DROP TABLE IF EXISTS `m_nominal_donasi`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `m_nominal_donasi` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nilai` bigint unsigned NOT NULL,
  `nilai_nominal` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `m_nominal_donasi`
--

LOCK TABLES `m_nominal_donasi` WRITE;
/*!40000 ALTER TABLE `m_nominal_donasi` DISABLE KEYS */;
INSERT INTO `m_nominal_donasi` VALUES (1,50000,'Rp 50.000',NULL,NULL),(2,100000,'Rp 100.000',NULL,NULL),(3,250000,'Rp 250.000',NULL,NULL),(4,500000,'Rp 500.000',NULL,NULL);
/*!40000 ALTER TABLE `m_nominal_donasi` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `t_donasi_palestineday`
--

DROP TABLE IF EXISTS `t_donasi_palestineday`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `t_donasi_palestineday` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `nama_ortu` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nama_siswa` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `no_hp` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL,
  `nominal_donasi` bigint unsigned NOT NULL DEFAULT '0',
  `doa` text COLLATE utf8mb4_unicode_ci,
  `lokasi` bigint unsigned DEFAULT NULL,
  `tgl_donasi` datetime DEFAULT NULL,
  `status` tinyint NOT NULL DEFAULT '1',
  `metode_bayar` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `t_donasi_palestineday`
--

LOCK TABLES `t_donasi_palestineday` WRITE;
/*!40000 ALTER TABLE `t_donasi_palestineday` DISABLE KEYS */;
/*!40000 ALTER TABLE `t_donasi_palestineday` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-09-22  1:21:23
