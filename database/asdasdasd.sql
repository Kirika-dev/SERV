-- --------------------------------------------------------
-- Хост:                         127.0.0.1
-- Версия сервера:               10.6.17-MariaDB - mariadb.org binary distribution
-- Операционная система:         Win64
-- HeidiSQL Версия:              12.6.0.6765
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Дамп структуры базы данных ra3_main
CREATE DATABASE IF NOT EXISTS `ra3_main` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */;
USE `ra3_main`;

-- Дамп структуры для таблица ra3_main.accounts
CREATE TABLE IF NOT EXISTS `accounts` (
  `login` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(256) NOT NULL,
  `hwid` varchar(256) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `ip` varchar(256) NOT NULL,
  `socialclub` varchar(50) NOT NULL,
  `redbucks` int(11) NOT NULL DEFAULT 0,
  `viplvl` int(11) NOT NULL,
  `vipdate` datetime NOT NULL,
  `promocodes` varchar(256) NOT NULL,
  `bonuscodes` mediumtext NOT NULL,
  `character1` int(11) NOT NULL,
  `character2` int(11) NOT NULL,
  `character3` int(11) NOT NULL,
  `characters` varchar(100) NOT NULL DEFAULT '[-2,-2,-2,-2,-2,-2]',
  `present` tinyint(4) NOT NULL DEFAULT 0,
  `refpresent` tinyint(4) NOT NULL DEFAULT 0,
  `case` varchar(100) NOT NULL DEFAULT '[0,0,0]',
  `RefferalId` int(11) NOT NULL DEFAULT 0,
  `isSubscribe` tinyint(1) NOT NULL DEFAULT 0,
  `SubscribeEndTime` datetime NOT NULL DEFAULT curtime(),
  `SubscribeTime` datetime NOT NULL DEFAULT curtime(),
  `CollectionGifts` varchar(500) NOT NULL DEFAULT '[]',
  `ReceivedAward` varchar(75) NOT NULL DEFAULT '[0,0,0,0,0,0,0,0,1]',
  `ReceivedAwardWeek` int(4) NOT NULL DEFAULT 0,
  `ReceivedAwardDonate` int(7) NOT NULL DEFAULT 0,
  `Unique` varchar(16) NOT NULL DEFAULT '',
  `LastSelectCharUUID` int(11) NOT NULL DEFAULT 0,
  `ExitDate` datetime NOT NULL DEFAULT curtime(),
  `ga` varchar(25) NOT NULL DEFAULT '',
  PRIMARY KEY (`login`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- Дамп данных таблицы ra3_main.accounts: ~1 rows (приблизительно)
REPLACE INTO `accounts` (`login`, `email`, `password`, `hwid`, `ip`, `socialclub`, `redbucks`, `viplvl`, `vipdate`, `promocodes`, `bonuscodes`, `character1`, `character2`, `character3`, `characters`, `present`, `refpresent`, `case`, `RefferalId`, `isSubscribe`, `SubscribeEndTime`, `SubscribeTime`, `CollectionGifts`, `ReceivedAward`, `ReceivedAwardWeek`, `ReceivedAwardDonate`, `Unique`, `LastSelectCharUUID`, `ExitDate`, `ga`) VALUES
	('magicpika', 'iammmatros@gmail.com', 'bf83ee1ecc7405aa8bc51e1374df3b2e63816ca94c3277cac695f5ffff0c487b', 'E1D69468381CC8400EA4C34C707658009900E39447E896404A30D848C2CEEF00CD50604400C647B83CC44878987082E0D992902448C0EF00A9FA2990F2D42840', '127.0.0.1', '114676524', 795000, 10, '2024-05-08 16:30:00', '["Huy"]', '["chlen"]', 1, 2, -2, '[-2,-2,-2,-2,-2,-2]', 0, 0, '[0,0,0]', 0, 0, '2024-04-29 16:22:57', '2024-04-29 16:22:57', '[]', '[0,0,0,0,0,0,0,0,1,0,0,0,0,0,0]', 17, 0, 'cases_5_0', 1, '2024-04-29 16:29:40', '');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
