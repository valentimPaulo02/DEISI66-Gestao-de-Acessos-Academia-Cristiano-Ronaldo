CREATE DATABASE  IF NOT EXISTS `academiasporting` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `academiasporting`;
-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: localhost    Database: academiasporting
-- ------------------------------------------------------
-- Server version	8.0.34

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `temporaryrequest`
--

DROP TABLE IF EXISTS `temporaryrequest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `temporaryrequest` (
  `request_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `state` varchar(10) DEFAULT NULL,
  `validated` tinyint(1) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `leave_date` date DEFAULT NULL,
  `leave_time` time DEFAULT NULL,
  `supervisor` varchar(50) DEFAULT NULL,
  `transport_out` varchar(50) DEFAULT NULL,
  `destiny` varchar(50) DEFAULT NULL,
  `arrival_date` date DEFAULT NULL,
  `arrival_time` time DEFAULT NULL,
  `note` varchar(200) DEFAULT NULL,
  `updated_by` int DEFAULT NULL,
  `updated_at` date DEFAULT NULL,
  PRIMARY KEY (`request_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `temporaryrequest_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `temporaryrequest`
--

LOCK TABLES `temporaryrequest` WRITE;
/*!40000 ALTER TABLE `temporaryrequest` DISABLE KEYS */;
/*!40000 ALTER TABLE `temporaryrequest` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `user_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(20) DEFAULT NULL,
  `surname` varchar(20) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `password` text,
  `role` enum('athlete','supervisor','admin') DEFAULT NULL,
  `token` text,
  `category` varchar(7) DEFAULT NULL,
  `room_number` int DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `image_path` varchar(200) DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1, 'admin', 'user', 'admin_user', 'admin123', 'admin', NULL, NULL, NULL, NULL, '');
INSERT INTO `user` VALUES (2, 'supervisor', 'user', 'supervisor_user', 'supervisor123', 'supervisor', NULL, NULL, NULL, NULL, ''); 
INSERT INTO `user` VALUES (3, 'athlete', 'user', 'athlete_user', 'athlete123', 'athlete', NULL, 'under15', 25, '2002-12-15', ''); 
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `weekendrequest`
--

DROP TABLE IF EXISTS `weekendrequest`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `weekendrequest` (
  `request_id` int NOT NULL AUTO_INCREMENT,
  `user_id` int DEFAULT NULL,
  `state` varchar(10) DEFAULT NULL,
  `validated` tinyint(1) DEFAULT NULL,
  `date` date DEFAULT NULL,
  `leave_date` date DEFAULT NULL,
  `leave_time` time DEFAULT NULL,
  `supervisor` varchar(50) DEFAULT NULL,
  `transport_out` varchar(50) DEFAULT NULL,
  `destiny` varchar(50) DEFAULT NULL,
  `arrival_date` date DEFAULT NULL,
  `arrival_time` time DEFAULT NULL,
  `note` varchar(200) DEFAULT NULL,
  `updated_by` int DEFAULT NULL,
  `updated_at` date DEFAULT NULL,
  PRIMARY KEY (`request_id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `weekendrequest_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `weekendrequest`
--

LOCK TABLES `weekendrequest` WRITE;
/*!40000 ALTER TABLE `weekendrequest` DISABLE KEYS */;
/*!40000 ALTER TABLE `weekendrequest` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-11-28 21:39:37
