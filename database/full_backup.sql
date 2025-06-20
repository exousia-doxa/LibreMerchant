CREATE DATABASE  IF NOT EXISTS `selltool-test` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `selltool-test`;
-- MySQL dump 10.13  Distrib 8.0.41, for Win64 (x86_64)
--
-- Host: localhost    Database: selltool-test
-- ------------------------------------------------------
-- Server version	9.2.0

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
-- Table structure for table `changes`
--

DROP TABLE IF EXISTS `changes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `changes` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `timestamp` timestamp NOT NULL,
  `log` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `credentails_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `changes_credentials_id` (`credentails_id`),
  CONSTRAINT `changes_credentials_id` FOREIGN KEY (`credentails_id`) REFERENCES `credentials` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `changes`
--

LOCK TABLES `changes` WRITE;
/*!40000 ALTER TABLE `changes` DISABLE KEYS */;
/*!40000 ALTER TABLE `changes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `credentials`
--

DROP TABLE IF EXISTS `credentials`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `credentials` (
  `active` tinyint(1) NOT NULL,
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  `access` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `login` varchar(255) NOT NULL,
  `hashcode` varchar(255) NOT NULL,
  `owner_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `credentials_owner_id` (`owner_id`),
  CONSTRAINT `credentials_owner_id` FOREIGN KEY (`owner_id`) REFERENCES `organisation` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `credentials`
--

LOCK TABLES `credentials` WRITE;
/*!40000 ALTER TABLE `credentials` DISABLE KEYS */;
INSERT INTO `credentials` VALUES (1,1,'DEFAULT','OWNER','DEFAULT','725c7dfc9fbf8fb66ec8b7cf6f807587521a1a376c0cd2db307b699ae17afd7475389f0111d99ab4bcb69fe6a7588df0767d0182041d7f66e031a1f4945ba6f7',1);
/*!40000 ALTER TABLE `credentials` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `good`
--

DROP TABLE IF EXISTS `good`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `good` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `active` tinyint(1) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `code` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `unit` smallint unsigned NOT NULL,
  `ucgfea` bigint unsigned DEFAULT NULL,
  `vac` char(1) NOT NULL,
  `excise` tinyint(1) NOT NULL,
  `group_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `good_group_id` (`group_id`),
  CONSTRAINT `good_group_id` FOREIGN KEY (`group_id`) REFERENCES `group` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `good`
--

LOCK TABLES `good` WRITE;
/*!40000 ALTER TABLE `good` DISABLE KEYS */;
/*!40000 ALTER TABLE `good` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `goodorg`
--

DROP TABLE IF EXISTS `goodorg`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `goodorg` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `good_id` bigint unsigned NOT NULL,
  `organisation_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `goodorg_good_id` (`good_id`) USING BTREE,
  KEY `goodorg_organisation_id` (`organisation_id`),
  CONSTRAINT `goodorg_good_id` FOREIGN KEY (`good_id`) REFERENCES `good` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `goodorg_organisation_id` FOREIGN KEY (`organisation_id`) REFERENCES `organisation` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `goodorg`
--

LOCK TABLES `goodorg` WRITE;
/*!40000 ALTER TABLE `goodorg` DISABLE KEYS */;
/*!40000 ALTER TABLE `goodorg` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `group`
--

DROP TABLE IF EXISTS `group`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `group` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `active` tinyint(1) NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `type` tinyint unsigned NOT NULL,
  `supergroup` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `group_supergroup` (`supergroup`),
  CONSTRAINT `group_supergroup` FOREIGN KEY (`supergroup`) REFERENCES `group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `group`
--

LOCK TABLES `group` WRITE;
/*!40000 ALTER TABLE `group` DISABLE KEYS */;
INSERT INTO `group` VALUES (1,1,'DEFAULT',0,NULL);
INSERT INTO `group` VALUES (2,1,'Unorganised',1,NULL);
INSERT INTO `group` VALUES (3,1,'Unorganised',2,NULL);
INSERT INTO `group` VALUES (4,1,'Unorganised',3,NULL);
/*!40000 ALTER TABLE `group` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `item`
--

DROP TABLE IF EXISTS `item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `item` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `goodorg_id` bigint unsigned NOT NULL,
  `amount` decimal(8,2) NOT NULL,
  `cost` decimal(8,2) NOT NULL,
  `price` decimal(8,2) NOT NULL,
  `excise` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `receipt_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `item_receipt_id` (`receipt_id`),
  CONSTRAINT `item_receipt_id` FOREIGN KEY (`receipt_id`) REFERENCES `receipt` (`id`)
  KEY `item_goodorg_id` (`goodorg_id`),
  CONSTRAINT `item_goodorg_id` FOREIGN KEY (`goodorg_id`) REFERENCES `goodorg` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `item`
--

LOCK TABLES `item` WRITE;
/*!40000 ALTER TABLE `item` DISABLE KEYS */;
/*!40000 ALTER TABLE `item` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `organisation`
--

DROP TABLE IF EXISTS `organisation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `organisation` (
  `active` tinyint(1) NOT NULL,
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `type` tinyint unsigned NOT NULL,
  `vat` tinyint(1) NOT NULL,
  `group_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `organisation_superorganisation` (`group_id`),
  CONSTRAINT `organisation_group_id` FOREIGN KEY (`group_id`) REFERENCES `group` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `organisation`
--

LOCK TABLES `organisation` WRITE;
/*!40000 ALTER TABLE `organisation` DISABLE KEYS */;
INSERT INTO `organisation` VALUES (1,1,'DEFAULT',0,0,1);
/*!40000 ALTER TABLE `organisation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `receipt`
--

DROP TABLE IF EXISTS `receipt`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `receipt` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `timestamp` timestamp NOT NULL,
  `type` tinyint unsigned NOT NULL,
  `credentials_id` bigint unsigned NOT NULL,
  `supplier_id` bigint unsigned DEFAULT NULL,
  `owner_id` bigint NOT NULL,
  `receipt_id` bigint unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `receipt_receipt_id` (`receipt_id`),
  KEY `receipt_credentials_id` (`credentials_id`),
  CONSTRAINT `receipt_credentials_id` FOREIGN KEY (`credentials_id`) REFERENCES `credentials` (`id`),
  CONSTRAINT `receipt_receipt_id` FOREIGN KEY (`receipt_id`) REFERENCES `receipt` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `receipt`
--

LOCK TABLES `receipt` WRITE;
/*!40000 ALTER TABLE `receipt` DISABLE KEYS */;
/*!40000 ALTER TABLE `receipt` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unit`
--

DROP TABLE IF EXISTS `unit`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `unit` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unit`
--

LOCK TABLES `unit` WRITE;
/*!40000 ALTER TABLE `unit` DISABLE KEYS */;
INSERT INTO `unit` VALUES (1,'од');
INSERT INTO `unit` VALUES (2,'кг');
INSERT INTO `unit` VALUES (3,'г');
INSERT INTO `unit` VALUES (4,'л');
INSERT INTO `unit` VALUES (5,'мл');
/*!40000 ALTER TABLE `unit` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `vac`
--

DROP TABLE IF EXISTS `vac`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `vac` (
  `id` bigint unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `multiplier` decimal(8,2) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `vac`
--

LOCK TABLES `vac` WRITE;
/*!40000 ALTER TABLE `vac` DISABLE KEYS */;
INSERT INTO `vac` VALUES (1,'0%', 0.0);
INSERT INTO `vac` VALUES (2,'7%', 0.07);
INSERT INTO `vac` VALUES (3,'14%', 0.14);
INSERT INTO `vac` VALUES (4,'20%', 0.2);
/*!40000 ALTER TABLE `vac` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'selltool-test'
--

--
-- Dumping routines for database 'selltool-test'
--
/*!50003 DROP PROCEDURE IF EXISTS `create_credentials` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_credentials`(
	IN new_name VARCHAR(255),
	IN new_access VARCHAR(255),
	IN new_owner_id BIGINT UNSIGNED,
    IN new_login VARCHAR(255),
    IN new_hashcode VARCHAR(255),
    OUT status_code TINYINT UNSIGNED
)
BEGIN
	-- Code 0 - procedure is succesfull.
	-- Code 1 - selected id does not exist.
	-- Code 2 - selected data is occupied.
	-- Code 3 - selected instance have dependecies in other tables.
	
	IF EXISTS (
		SELECT 1
		FROM `credentials`
		WHERE `name` = new_name
		AND `login` = new_login
		AND `owner_id` = new_owner_id
	) THEN
		SET status_code = 2;
	ELSE
		INSERT INTO `credentials` (`active`, `name`, `access`, `owner_id`, `login`, `hashcode`)
		VALUES (1, new_name, new_access, new_owner_id, new_login, new_hashcode);
		
		SET status_code = 0;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_good` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_good`(
	IN new_name VARCHAR(255),
	IN new_code VARCHAR(255),
	IN new_unit SMALLINT UNSIGNED,
	IN new_ucgfea BIGINT UNSIGNED,
	IN new_vac CHAR(1),
	IN new_excise TINYINT(1),
	IN new_group_id BIGINT UNSIGNED,
	OUT status_code TINYINT UNSIGNED
)
BEGIN
	-- Code 0 - procedure is succesfull.
	-- Code 1 - selected id does not exist.
	-- Code 2 - selected data is occupied.
	-- Code 3 - selected instance have dependecies in other tables.
	
	IF EXISTS (
		SELECT 1
		FROM `good`
		WHERE `name` = new_name
		
		UNION ALL
		
		SELECT 1
		FROM `good`
		WHERE `code` = new_code
	) THEN
		SET status_code = 2;
	ELSE
		INSERT INTO `good` (`active`, `name`, `code`, `unit`, `ucgfea`, `vac`, `excise`, `group_id`)
		VALUES (1, new_name, new_code, new_unit, new_ucgfea, new_vac, new_excise, new_group_id);

		SET status_code = 0;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_goodorg` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_goodorg`(
	IN new_good_id BIGINT UNSIGNED,
	IN new_organisation_id BIGINT UNSIGNED,
	OUT status_code TINYINT UNSIGNED
)
BEGIN
	-- Code 0 - procedure is succesfull.
	-- Code 1 - selected id does not exist.
	-- Code 2 - selected data is occupied.
	-- Code 3 - selected instance have dependecies in other tables.
	
	IF EXISTS (
		SELECT 1
		FROM `goodorg`
		WHERE `good_id` = new_good_id
		AND `organisation_id` = new_organisation_id
	) THEN
		SET status_code = 2;
	ELSE
		IF NOT EXISTS (
			SELECT 1
			FROM `good`
			WHERE `id` = new_good_id
			
			UNION ALL
			
			SELECT 1
			FROM `organisation`
			WHERE `id` = new_organisation_id
		) THEN
			SET status_code = 1;
		ELSE
			INSERT INTO `goodorg` (`good_id`, `organisation_id`)
			VALUES (new_good_id, new_organisation_id);

			SET status_code = 0;
		END IF;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_group` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_group`(
    IN new_name VARCHAR(255),
    IN new_type TINYINT UNSIGNED,
    IN new_supergroup BIGINT UNSIGNED,
    OUT status_code TINYINT UNSIGNED
)
BEGIN
	-- Code 0 - procedure is succesfull.
	-- Code 1 - selected id does not exist.
	-- Code 2 - selected data is occupied.
	-- Code 3 - selected instance have dependecies in other tables.
	
	IF EXISTS (
		SELECT 1
		FROM `group`
		WHERE `name` = new_name
		AND `type` = new_type
		AND (
            (`supergroup` = new_supergroup) OR (supergroup IS NULL AND new_supergroup IS NULL)
        )
	) THEN
		SET status_code = 2;
	ELSE
		INSERT INTO `group` (`active`, `name`, `type`, `supergroup`)
		VALUES (1, new_name, new_type, new_supergroup);
		
		SET status_code = 0;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_organisation` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_organisation`(
	IN new_name VARCHAR(255),
	IN new_type TINYINT UNSIGNED,
	IN new_vat TINYINT(1),
	IN new_group_id BIGINT UNSIGNED,
	OUT status_code TINYINT UNSIGNED
)
BEGIN
	-- Code 0 - procedure is succesfull.
	-- Code 1 - selected id does not exist.
	-- Code 2 - selected data is occupied.
	-- Code 3 - selected instance have dependecies in other tables.
	
	IF EXISTS (
		SELECT 1
		FROM `organisation`
		WHERE `name` = new_name
		AND `type` = new_type
		AND `group_id` = new_group_id
        )
	THEN
		SET status_code = 2;
	ELSE
		INSERT INTO `organisation` (`active`, `name`, `type`, `vat`, `group_id`)
		VALUES (1, new_name, new_type, new_vat, new_group_id);
		
		SET status_code = 0;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_permission` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_permission`(
	IN new_name VARCHAR(255),
	IN new_access VARCHAR(255),
	IN new_organisation BIGINT UNSIGNED,
    OUT status_code TINYINT UNSIGNED
)
BEGIN
	-- Code 0 - procedure is succesfull.
	-- Code 1 - selected id does not exist.
	-- Code 2 - selected data is occupied.
	-- Code 3 - selected instance have dependecies in other tables.
	
	IF EXISTS (
		SELECT 1
		FROM `permission`
		WHERE `name` = new_name
		AND `access` = new_access
		AND `organisation_id` = new_organisation
	) THEN
		SET status_code = 2;
	ELSE
		INSERT INTO `permission` (`active`, `name`, `access`, `organisation_id`)
		VALUES (1, new_name, new_access, new_organisation);
		
		SET status_code = 0;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `create_receipt` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_receipt`(
	IN new_timestamp TIMESTAMP,
    IN new_type TINYINT UNSIGNED,
    IN new_permission BIGINT UNSIGNED,
    IN new_organisation BIGINT UNSIGNED,
    IN new_receipt BIGINT UNSIGNED,
    OUT status_code TINYINT UNSIGNED
)
BEGIN
	-- Code 0 - procedure is succesfull.
	-- Code 1 - selected id does not exist.
	-- Code 2 - selected data is occupied.
	-- Code 3 - selected instance have dependecies in other tables.
	
	INSERT INTO `receipt` (`timestamp`, `type`, `permission_id`, `organisation_id`, `receipt_id`)
	VALUES (new_timestamp, new_type, new_permission, new_organisation, new_receipt);
		
	SET status_code = 0;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_credentials` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_credentials`(
    IN selected_id BIGINT UNSIGNED,
    OUT status_code TINYINT UNSIGNED
)
BEGIN
	-- Code 0 - procedure is succesfull.
	-- Code 1 - selected id does not exist.
	-- Code 2 - selected data is occupied.
	-- Code 3 - selected instance have dependecies in other tables.
	
	IF NOT EXISTS (
		SELECT 1
		FROM `credentials`
		WHERE `id` = selected_id
	) THEN
		SET status_code = 1;
	ELSE
		IF EXISTS (
			SELECT 1
			FROM `receipt`
			WHERE `credentials_id` = selected_id
			
			UNION ALL
			
			SELECT 1
			FROM `changes`
			WHERE `credentials_id` = selected_id
		) THEN
			SET status_code = 3;
		ELSE
			DELETE FROM `credentials`
			WHERE `id` = selected_id;
            
			SET status_code = 0;
		END IF;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_good` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_good`(
	IN selected_id BIGINT UNSIGNED,
    OUT status_code TINYINT UNSIGNED
)
BEGIN
	-- Code 0 - procedure is succesfull.
	-- Code 1 - selected id does not exist.
	-- Code 2 - selected data is occupied.
	-- Code 3 - selected instance have dependecies in other tables.
	
	IF NOT EXISTS (
		SELECT 1
		FROM `good`
		WHERE `id` = selected_id
	) THEN
		SET status_code = 1;
	ELSE
		IF EXISTS (
			SELECT 1
			FROM `item`
			JOIN `goodorg` ON `item`.goodorg_id = `goodorg`.id
			WHERE `goodorg`.good_id = selected_id
		) THEN
			SET status_code = 3;
		ELSE
			DELETE FROM `good`
			WHERE `id` = selected_id;
            
			SET status_code = 0;
		END IF;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_goodorg` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_goodorg`(
	IN selected_id BIGINT UNSIGNED,
    OUT status_code TINYINT UNSIGNED
)
BEGIN
	-- Code 0 - procedure is succesfull.
	-- Code 1 - selected id does not exist.
	-- Code 2 - selected data is occupied.
	-- Code 3 - selected instance have dependecies in other tables.
	
	IF NOT EXISTS (
		SELECT 1
		FROM `goodorg`
		WHERE `id` = selected_id
	) THEN
		SET status_code = 1;
	ELSE
		IF EXISTS (
			SELECT 1
			FROM `item`
			WHERE `goodorg_id` = selected_id
		) THEN
			SET status_code = 3;
		ELSE
			DELETE FROM `goodorg`
			WHERE `id` = selected_id;
            
			SET status_code = 0;
		END IF;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_group` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_group`(
    IN selected_id BIGINT UNSIGNED,
    OUT status_code TINYINT UNSIGNED
)
BEGIN
	-- Code 0 - procedure is succesfull.
	-- Code 1 - selected id does not exist.
	-- Code 2 - selected data is occupied.
	-- Code 3 - selected instance have dependecies in other tables.
	
	IF NOT EXISTS (
		SELECT 1
		FROM `group`
		WHERE `id` = selected_id
	) THEN
		SET status_code = 1;
	ELSE
		IF EXISTS (
			SELECT 1
			FROM `group`
			WHERE `supergroup` = selected_id
			
			UNION ALL
			
			SELECT 1
			FROM `good`
			WHERE `group_id` = selected_id
			
			UNION ALL
			
			SELECT 1
			FROM `organisation`
			WHERE `group_id` = selected_id
		) THEN
			SET status_code = 3;
		ELSE
			DELETE FROM `group`
			WHERE `id` = selected_id;
            
			SET status_code = 0;
		END IF;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_organisation` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_organisation`(
	IN selected_id BIGINT UNSIGNED,
	OUT status_code TINYINT UNSIGNED
)
BEGIN
	-- Code 0 - procedure is succesfull.
	-- Code 1 - selected id does not exist.
	-- Code 2 - selected data is occupied.
	-- Code 3 - selected instance have dependecies in other tables.
	
	IF NOT EXISTS (
		SELECT 1
		FROM `organisation`
		WHERE `id` = selected_id
	) THEN
		SET status_code = 1;
	ELSE
		IF EXISTS (
			SELECT 1
			FROM `item`
			JOIN `goodorg` ON `item`.goodorg_id = `goodorg`.id
			WHERE `goodorg`.organisation_id = selected_id

			UNION ALL

			SELECT 1
			FROM `credentials`
			WHERE `credentials`.owner_id = selected_id

			UNION ALL

			SELECT 1
			FROM `receipt`
			WHERE `receipt`.owner_id = selected_id OR `receipt`.supplier_id = selected_id
		) THEN
    		SET status_code = 3;
		ELSE
    		DELETE FROM `organisation`
    		WHERE `id` = selected_id;

    		SET status_code = 0;
		END IF;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_permission` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_permission`(
    IN selected_id BIGINT UNSIGNED,
    OUT status_code TINYINT UNSIGNED
)
BEGIN
	-- Code 0 - procedure is succesfull.
	-- Code 1 - selected id does not exist.
	-- Code 2 - selected data is occupied.
	-- Code 3 - selected instance have dependecies in other tables.
	
	IF NOT EXISTS (
		SELECT 1
		FROM `permission`
		WHERE `id` = selected_id
	) THEN
		SET status_code = 1;
	ELSE
		IF EXISTS (
			SELECT 1
			FROM `receipt`
			WHERE `permission_id` = selected_id
			
			UNION ALL
			
			SELECT 1
			FROM `changes`
			WHERE `permission_id` = selected_id
		) THEN
			SET status_code = 3;
		ELSE
			DELETE FROM `permission`
			WHERE `id` = selected_id;
            
			SET status_code = 0;
		END IF;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `delete_receipt` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_receipt`(
	IN selected_id BIGINT UNSIGNED,
    OUT status_code TINYINT UNSIGNED
)
BEGIN
	-- Code 0 - procedure is succesfull.
	-- Code 1 - selected id does not exist.
	-- Code 2 - selected data is occupied.
	-- Code 3 - selected instance have dependecies in other tables.
	
	IF EXISTS (
		SELECT 1
		FROM `item`
		WHERE `receipt_id` = selected_id
	) THEN
		SET status_code = 3;
	ELSE
		DELETE FROM `receipt`
		WHERE `id` = selected_id;
            
		SET status_code = 0;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_credentials` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_credentials`(
	IN selected_id BIGINT UNSIGNED,
	IN new_status TINYINT(1),
	IN new_access VARCHAR(255),
	IN new_owner_id BIGINT UNSIGNED,
    IN new_login VARCHAR(255),
    IN new_hashcode VARCHAR(255),
    OUT status_code TINYINT UNSIGNED
)
BEGIN
	-- Code 0 - procedure is succesfull.
	-- Code 1 - selected id does not exist.
	-- Code 2 - selected data is occupied.
	-- Code 3 - selected instance have dependecies in other tables.

	IF NOT EXISTS (
		SELECT 1
		FROM `credentials`
		WHERE `id` = selected_id
	) THEN
		SET status_code = 1;
	ELSE
		IF EXISTS (
			SELECT 1
			FROM `credentials`
			WHERE `name` = new_name
			AND `login` = new_login
			AND `owner_id` = new_owner_id
		) THEN
			SET status_code = 2;
		ELSE
			UPDATE `credentials`
			SET `active` = new_status,
				`name` = new_name,
				`access` = new_access,
				`owner_id` = new_owner_id,
                `login` = new_login,
                `hashocde` = new_hashcode
			WHERE `id` = selected_id;

            SET status_code = 0;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_good` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_good`(
	IN selected_id BIGINT UNSIGNED,
	IN new_status TINYINT(1),
	IN new_name VARCHAR(255),
	IN new_code VARCHAR(255),
	IN new_unit SMALLINT UNSIGNED,
	IN new_ucgfea BIGINT UNSIGNED,
	IN new_vac CHAR(1),
	IN new_excise TINYINT(1),
	IN new_group_id BIGINT UNSIGNED,
	OUT status_code TINYINT UNSIGNED
)
BEGIN
	-- Code 0 - procedure is succesfull.
	-- Code 1 - selected id does not exist.
	-- Code 2 - selected data is occupied.
	-- Code 3 - selected instance have dependecies in other tables.
	
	IF NOT EXISTS (
		SELECT 1
		FROM `good`
		WHERE `id` = selected_id
	) THEN
		SET status_code = 1;
	ELSE
		IF EXISTS (
			SELECT 1
			FROM `good`
			WHERE `name` = new_name
			AND `id` <> selected_id
			
			UNION ALL
			
			SELECT 1
			FROM `good`
			WHERE `code` = new_code
			AND `id` <> selected_id
		) THEN
			SET status_code = 2;
		ELSE
			UPDATE `good`
			SET `active` = new_status,
				`name` = new_name,
				`code` = new_code,
				`unit` = new_unit,
				`ucgfea` = new_ucgfea,
				`vac` = new_vac,
				`excise` = new_excise,
				`group_id` = new_group_id
			WHERE `id` = selected_id;

            SET status_code = 0;
		END IF;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_group` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_group`(
	IN selected_id BIGINT UNSIGNED,
	IN new_status TINYINT(1),
	IN new_name VARCHAR(255),
	IN new_supergroup BIGINT UNSIGNED,
	OUT status_code TINYINT UNSIGNED
)
BEGIN
	-- Code 0 - procedure is succesfull.
	-- Code 1 - selected id does not exist.
	-- Code 2 - selected data is occupied.
	-- Code 3 - selected instance have dependecies in other tables.
	
	DECLARE selected_type TINYINT UNSIGNED;
	
	IF NOT EXISTS (
		SELECT 1
		FROM `group`
		WHERE `id` = selected_id
	) THEN
		SET status_code = 1;
	ELSE
		SELECT `type` INTO selected_type
		FROM `group`
		WHERE `id` = selected_id;

		IF EXISTS (
			SELECT 1
			FROM `group`
			WHERE `id` <> selected_id
			AND `name` = new_name
			AND `type` = selected_type
			AND (
            (`supergroup` = new_supergroup) OR (supergroup IS NULL AND new_supergroup IS NULL)
        	)
		) THEN
			SET status_code = 2;
		ELSE
			UPDATE `group`
			SET `active` = new_status,
				`name` = new_name,
				`supergroup` = new_supergroup
			WHERE `id` = selected_id;

            SET status_code = 0;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_organisation` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_organisation`(
	IN selected_id BIGINT UNSIGNED,
	IN new_status TINYINT(1),
	IN new_name VARCHAR(255),
	IN new_vat TINYINT(1),
	IN new_group_id BIGINT UNSIGNED,
	OUT status_code TINYINT UNSIGNED
)
BEGIN
	-- Code 0 - procedure is succesfull.
	-- Code 1 - selected id does not exist.
	-- Code 2 - selected data is occupied.
	-- Code 3 - selected instance have dependecies in other tables.
	
	IF NOT EXISTS (
		SELECT 1
		FROM `organisation`
		WHERE `id` = selected_id
	) THEN
		SET status_code = 1;
	ELSE
		IF EXISTS (
			SELECT 1
			FROM `organisation`
			WHERE `name` = new_name
			AND `type` = new_type
            AND `group_id` = new_group_id
		) THEN
			SET status_code = 2;
		ELSE
			UPDATE `organisation`
			SET `active` = new_status,
				`name` = new_name,
				`vat` = new_vat,
				`group_id` = new_group_id
			WHERE `id` = selected_id;
		
			SET status_code = 0;
    	END IF;
	END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `update_permission` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_permission`(
	IN selected_id BIGINT UNSIGNED,
	IN new_status TINYINT(1),
	IN new_access VARCHAR(255),
	IN new_organisation BIGINT UNSIGNED,
    OUT status_code TINYINT UNSIGNED
)
BEGIN
	-- Code 0 - procedure is succesfull.
	-- Code 1 - selected id does not exist.
	-- Code 2 - selected data is occupied.
	-- Code 3 - selected instance have dependecies in other tables.

	IF NOT EXISTS (
		SELECT 1
		FROM `permission`
		WHERE `id` = selected_id
	) THEN
		SET status_code = 1;
	ELSE
		IF EXISTS (
			SELECT 1
			FROM `permission`
			WHERE `name` = new_name
			AND `access` = new_access
			AND `organisation_id` = new_organisation
		) THEN
			SET status_code = 2;
		ELSE
			UPDATE `permission`
			SET `active` = new_status,
				`name` = new_name,
				`access` = new_access,
				`organisation_id` = new_organisation
			WHERE `id` = selected_id;

            SET status_code = 0;
        END IF;
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-04-02 23:15:28
