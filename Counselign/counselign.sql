-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 03, 2025 at 01:33 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `counselign`
--
CREATE DATABASE IF NOT EXISTS `counselign` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
USE `counselign`;

-- --------------------------------------------------------

--
-- Table structure for table `announcements`
--

CREATE TABLE `announcements` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `id` int(11) NOT NULL,
  `student_id` varchar(10) NOT NULL,
  `preferred_date` date NOT NULL,
  `preferred_time` varchar(50) NOT NULL,
  `consultation_type` varchar(50) DEFAULT NULL,
  `method_type` varchar(50) NOT NULL,
  `purpose` text DEFAULT NULL,
  `counselor_preference` varchar(100) DEFAULT 'No preference',
  `description` text DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `status` enum('pending','approved','rejected','completed','cancelled') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`id`, `student_id`, `preferred_date`, `preferred_time`, `consultation_type`, `method_type`, `purpose`, `counselor_preference`, `description`, `reason`, `status`, `created_at`, `updated_at`) VALUES
(1, '2022311680', '2025-10-31', '10:00 AM - 11:00 AM', 'Individual Consultation', 'In-person', 'Counseling', '1234567890', 'blahblahblah', NULL, 'completed', '2025-10-29 13:07:40', '2025-11-01 07:28:34'),
(3, '2023123456', '2025-10-31', '10:00 AM - 11:00 AM', 'Individual Consultation', 'In-person', 'Counseling', '1234567890', 'blahblahblahblahblha', NULL, 'completed', '2025-10-29 13:44:09', '2025-11-01 07:28:34'),
(4, '2022123456', '2025-10-31', '1:00 PM - 2:00 PM', 'Individual Consultation', 'In-person', 'Psycho-Social Support', '0987654321', 'baskcbsudgfjhsdvb', NULL, 'completed', '2025-10-29 13:49:57', '2025-11-01 07:28:34'),
(6, '2020123456', '2025-10-31', '3:00 PM - 4:00 PM', 'Individual Consultation', 'In-person', 'Counseling', '0987654321', 'gcusgdsdbcusf', NULL, 'completed', '2025-10-29 14:02:03', '2025-11-01 07:28:34'),
(7, '2022311680', '2025-10-31', '11:00 AM - 11:30 AM', 'Individual Consultation', 'In-person', 'Initial Interview', '1234567890', 'dgfjhrwgfd vjfg', NULL, 'completed', '2025-10-29 14:12:29', '2025-11-01 07:28:34'),
(8, '2025123456', '2025-12-01', '1:00 PM - 1:30 PM', 'Individual Consultation', 'In-person', 'Psycho-Social Support', '1234567890', 'asbdjgahdsdv', NULL, 'completed', '2025-10-29 14:31:40', '2025-11-01 07:28:34'),
(9, '2025123456', '2025-12-01', '1:00 PM - 1:30 PM', 'Individual Consultation', 'In-person', 'Counseling', '1234567890', 'jfdsfdghsfdw', NULL, 'completed', '2025-10-29 14:51:14', '2025-11-01 07:28:34'),
(10, '2022311680', '2025-12-01', '1:30 PM - 2:00 PM', 'Individual Consultation', 'In-person', 'Counseling', '1234567890', 'sdhjcvsdcgsvc hcgsuyf', 'Reason from Counselor: Already booked the Follow-Up Session', 'cancelled', '2025-10-29 14:52:32', '2025-11-01 07:28:34'),
(11, '2023123456', '2025-12-01', '2:00 PM - 2:30 PM', 'Individual Consultation', 'In-person', 'Counseling', '1234567890', 'ifgusgcdsvf bsdjhfus', NULL, 'completed', '2025-10-29 14:59:52', '2025-11-01 07:28:34'),
(12, '2022123456', '2025-12-01', '2:30 PM - 3:00 PM', 'Individual Consultation', 'In-person', 'Initial Interview', '1234567890', 'a  fbuefg fje fbirgfrh', 'Reason from Counselor: iihb ghj', 'cancelled', '2025-10-29 15:04:50', '2025-11-01 07:28:34'),
(14, '2020123456', '2025-12-01', '3:30 PM - 4:00 PM', 'Individual Consultation', 'In-person', 'Counseling', '1234567890', 'ekdhsi wgruwef erjg ufy f', NULL, 'completed', '2025-10-29 15:07:59', '2025-11-01 07:28:34'),
(15, '2025123456', '2025-10-31', '10:30 AM - 11:00 AM', 'Individual Consultation', 'In-person', 'Counseling', '1234567890', 'mnx c fbsb f vcv  jfv vsv jhcvj v ccv svf cvjh vjs', 'Reason from Counselor: b v vgvvc svs vsh test lang', 'rejected', '2025-10-30 03:20:53', '2025-11-01 07:28:34'),
(16, '2025123456', '2025-10-31', '10:30 AM - 11:00 AM', 'Individual Consultation', 'In-person', 'Counseling', '1234567890', 'yigf gfsg c vfsv fvsjdf svvjsvj', 'Reason from Counselor: jhvvcvfhc', 'cancelled', '2025-10-30 03:22:14', '2025-11-01 07:28:34'),
(18, '2024123456', '2025-11-21', '10:30 AM - 11:00 AM', 'Individual Consultation', 'In-person', 'Counseling', '1234567890', 'fgsg bhsfv r', NULL, 'completed', '2025-10-30 09:00:52', '2025-11-01 07:28:34'),
(19, '2022311680', '2025-11-21', '10:00 AM - 10:30 AM', 'Individual Consultation', 'In-person', 'Counseling', '1234567890', 'hdsbfhjb ddf', 'Reason from Counselor: basta', 'rejected', '2025-10-30 09:36:45', '2025-11-01 07:28:34'),
(20, '2022311680', '2026-01-16', '10:00 AM - 10:30 AM', 'Individual Consultation', 'In-person', 'Counseling', '1234567890', 'nfsjnj befb sdf', NULL, 'approved', '2025-10-30 09:39:37', '2025-11-01 07:28:34'),
(21, '2024123456', '2025-11-14', '10:30 AM - 11:00 AM', 'Individual Consultation', 'In-person', 'Counseling', '1234567890', 'djfsdbfsbvdcv', 'Reason from Counselor: gfghc v ghv', 'cancelled', '2025-10-30 11:08:54', '2025-11-01 07:28:34'),
(22, '2020123456', '2025-11-07', '10:00 AM - 10:30 AM', 'Individual Consultation', 'In-person', 'Group Counseling', '1234567890', 'fhbh bdbscdf bvhb fhdbv', 'Reason from Counselor: hg gh vgfgf', 'rejected', '2025-10-31 12:01:14', '2025-11-01 07:28:34'),
(23, '2020123456', '2025-11-14', '10:00 AM - 10:30 AM', 'Individual Consultation', 'In-person', 'Initial Interview', '1234567890', 'ggvvvyfc gc', 'Reason from Counselor: hfdhvb f', 'rejected', '2025-10-31 13:22:28', '2025-11-01 07:28:34'),
(24, '2020123456', '2025-11-14', '10:00 AM - 10:30 AM', 'Individual Consultation', 'In-person', 'Group Counseling', '1234567890', 'cv  cvdvc dc', 'Reason from Counselor: gbj nfnvj nf', 'cancelled', '2025-10-31 13:44:13', '2025-11-01 07:28:34'),
(27, '2021123456', '2025-11-07', '7:00 AM - 7:30 AM', 'Individual Consultation', 'In-person', 'Counseling', '1234509876', 'gv dbcsdc dc', NULL, 'completed', '2025-10-31 17:42:19', '2025-11-01 07:28:34'),
(28, '2024123456', '2025-11-28', '8:30 AM - 9:00 AM', 'Group Consultation', 'In-person', 'Psycho-Social Support', '1234509876', 'jhsxc sdv sdghc', 'Reason from Student: need to change schedule\n', 'cancelled', '2025-11-01 07:32:51', '2025-11-01 08:03:37'),
(29, '2024123456', '2025-11-28', '8:30 AM - 9:00 AM', 'Individual Consultation', 'In-person', 'Initial Interview', '1234509876', 'dcdhc sdchjds c', NULL, 'approved', '2025-11-01 08:04:43', '2025-11-01 08:59:07'),
(30, '2020123456', '2025-11-28', '7:30 AM - 8:00 AM', 'Group Consultation', 'In-person', 'Counseling', '1234509876', 'cb  cvdc  dcdvc', NULL, 'approved', '2025-11-01 08:26:21', '2025-11-01 09:31:51'),
(31, '2025123456', '2025-11-28', '7:30 AM - 8:00 AM', 'Group Consultation', 'In-person', 'Psycho-Social Support', '1234509876', 'hvzcv vdcg dc', NULL, 'approved', '2025-11-01 09:30:29', '2025-11-01 09:31:37'),
(32, '2022123456', '2025-11-28', '7:30 AM - 8:00 AM', 'Group Consultation', 'In-person', 'Counseling', '1234509876', 'gjxc dgcv dghdhgcv', NULL, 'completed', '2025-11-01 09:34:16', '2025-11-01 18:42:18'),
(33, '2023303640', '2025-11-28', '7:30 AM - 8:00 AM', 'Group Consultation', 'In-person', 'Counseling', '1234509876', 'd dghc gdc', NULL, 'approved', '2025-11-01 14:52:10', '2025-11-01 14:52:47'),
(34, '2023303630', '2025-11-28', '7:00 AM - 7:30 AM', 'Group Consultation', 'In-person', 'Psycho-Social Support', '1234509876', 'dfh dhf dc', NULL, 'completed', '2025-11-01 14:54:18', '2025-11-01 18:41:30'),
(35, '2022123456', '2025-11-28', '7:30 AM - 8:00 AM', 'Group Consultation', 'In-person', 'Counseling', '1234509876', 'dsg df jdfv df', NULL, 'pending', '2025-11-01 18:42:47', NULL);

--
-- Triggers `appointments`
--
DELIMITER $$
CREATE TRIGGER `prevent_double_booking` BEFORE INSERT ON `appointments` FOR EACH ROW BEGIN
    DECLARE conflict_count INT DEFAULT 0;
    DECLARE individual_count INT DEFAULT 0;
    DECLARE group_count INT DEFAULT 0;
    
    IF NEW.consultation_type = 'Individual Consultation' THEN
        SELECT COUNT(*) INTO conflict_count
        FROM appointments 
        WHERE counselor_preference = NEW.counselor_preference 
        AND preferred_date = NEW.preferred_date 
        AND preferred_time = NEW.preferred_time 
        AND status IN ('pending', 'approved')
        AND counselor_preference != 'No preference'
        AND id != NEW.id;
        
        IF conflict_count > 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'This time slot is already booked. Individual consultations require exclusive time slots.';
        END IF;
    
    ELSEIF NEW.consultation_type = 'Group Consultation' THEN
        SELECT COUNT(*) INTO individual_count
        FROM appointments 
        WHERE counselor_preference = NEW.counselor_preference 
        AND preferred_date = NEW.preferred_date 
        AND preferred_time = NEW.preferred_time 
        AND status IN ('pending', 'approved')
        AND consultation_type = 'Individual Consultation'
        AND counselor_preference != 'No preference'
        AND id != NEW.id;
        
        IF individual_count > 0 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'This time slot is already booked for individual consultation. Group consultations cannot share time slots with individual consultations.';
        END IF;
        
        SELECT COUNT(*) INTO group_count
        FROM appointments 
        WHERE counselor_preference = NEW.counselor_preference 
        AND preferred_date = NEW.preferred_date 
        AND preferred_time = NEW.preferred_time 
        AND status IN ('pending', 'approved')
        AND consultation_type = 'Group Consultation'
        AND counselor_preference != 'No preference'
        AND id != NEW.id;
        
        IF group_count >= 5 THEN
            SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Group consultation slots are full for this time slot (maximum 5 participants).';
        END IF;
    END IF;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `prevent_double_booking_update` BEFORE UPDATE ON `appointments` FOR EACH ROW BEGIN
    DECLARE conflict_count INT DEFAULT 0;
    DECLARE individual_count INT DEFAULT 0;
    DECLARE group_count INT DEFAULT 0;
    
    IF (NEW.counselor_preference != OLD.counselor_preference 
        OR NEW.preferred_date != OLD.preferred_date 
        OR NEW.preferred_time != OLD.preferred_time
        OR NEW.consultation_type != OLD.consultation_type) THEN
        
        IF NEW.consultation_type = 'Individual Consultation' THEN
            SELECT COUNT(*) INTO conflict_count
            FROM appointments 
            WHERE counselor_preference = NEW.counselor_preference 
            AND preferred_date = NEW.preferred_date 
            AND preferred_time = NEW.preferred_time 
            AND status IN ('pending', 'approved')
            AND counselor_preference != 'No preference'
            AND id != NEW.id;
            
            IF conflict_count > 0 THEN
                SIGNAL SQLSTATE '45000' 
                SET MESSAGE_TEXT = 'This time slot is already booked. Individual consultations require exclusive time slots.';
            END IF;
        
        ELSEIF NEW.consultation_type = 'Group Consultation' THEN
            SELECT COUNT(*) INTO individual_count
            FROM appointments 
            WHERE counselor_preference = NEW.counselor_preference 
            AND preferred_date = NEW.preferred_date 
            AND preferred_time = NEW.preferred_time 
            AND status IN ('pending', 'approved')
            AND consultation_type = 'Individual Consultation'
            AND counselor_preference != 'No preference'
            AND id != NEW.id;
            
            IF individual_count > 0 THEN
                SIGNAL SQLSTATE '45000' 
                SET MESSAGE_TEXT = 'This time slot is already booked for individual consultation. Group consultations cannot share time slots with individual consultations.';
            END IF;
            
            SELECT COUNT(*) INTO group_count
            FROM appointments 
            WHERE counselor_preference = NEW.counselor_preference 
            AND preferred_date = NEW.preferred_date 
            AND preferred_time = NEW.preferred_time 
            AND status IN ('pending', 'approved')
            AND consultation_type = 'Group Consultation'
            AND counselor_preference != 'No preference'
            AND id != NEW.id;
            
            IF group_count >= 5 THEN
                SIGNAL SQLSTATE '45000' 
                SET MESSAGE_TEXT = 'Group consultation slots are full for this time slot (maximum 5 participants).';
            END IF;
        END IF;
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `ci_sessions`
--

CREATE TABLE `ci_sessions` (
  `id` varchar(128) NOT NULL,
  `ip_address` varchar(45) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp(),
  `data` blob NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `counselors`
--

CREATE TABLE `counselors` (
  `id` int(11) NOT NULL,
  `counselor_id` varchar(20) NOT NULL,
  `name` varchar(100) NOT NULL,
  `degree` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `contact_number` varchar(20) NOT NULL,
  `address` text NOT NULL,
  `profile_picture` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `civil_status` varchar(20) DEFAULT NULL,
  `sex` varchar(10) DEFAULT NULL,
  `birthdate` date DEFAULT NULL,
  `time_scheduled` varchar(50) DEFAULT NULL,
  `available_days` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `counselors`
--

INSERT INTO `counselors` (`id`, `counselor_id`, `name`, `degree`, `email`, `contact_number`, `address`, `profile_picture`, `created_at`, `updated_at`, `civil_status`, `sex`, `birthdate`, `time_scheduled`, `available_days`) VALUES
(1, '1234567890', 'Freynsis Greys', 'Bachelor of Science in Information Technology', 'esangairemgrace@gmail.com', '09923757753', 'Sitio Migbanday, Poblacion, Claveria, Misamis Oriental', NULL, '2025-10-29 12:54:19', '2025-10-29 12:54:19', 'Single', 'Female', '2003-12-09', NULL, NULL),
(2, '0987654321', 'Princess Grace Marie Z. Sitoy', 'BSIT', 'impactog0903@gmail.com', '09908765432', 'Migbanday, Claveria, Misamis Oriental', NULL, '2025-10-29 13:38:13', '2025-10-29 13:38:13', 'Single', 'Female', '2003-12-08', NULL, NULL),
(5, '1234509876', 'Methyl Salicylate', 'Philippine HDIP', 'katkatluvie@gmail.com', '09786534211', 'Tingub, Mandaue City, Cebu, Philippines', 'Photos/profile_pictures/counselor_1234509876_1761931662.jpg', '2025-10-31 09:25:49', '2025-10-31 17:27:42', 'Legally Separated', 'Female', '1997-06-18', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `counselor_availability`
--

CREATE TABLE `counselor_availability` (
  `id` int(11) NOT NULL,
  `counselor_id` varchar(10) NOT NULL,
  `available_days` enum('Monday','Tuesday','Wednesday','Thursday','Friday') NOT NULL,
  `time_scheduled` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `counselor_availability`
--

INSERT INTO `counselor_availability` (`id`, `counselor_id`, `available_days`, `time_scheduled`, `created_at`) VALUES
(2, '1234567890', 'Friday', '10:00 AM-11:30 AM', '2025-10-29 13:05:03'),
(3, '1234567890', 'Monday', '1:00 PM-4:00 PM', '2025-10-29 13:12:25'),
(4, '0987654321', 'Tuesday', '10:00 AM-4:00 PM', '2025-10-29 13:39:15'),
(5, '0987654321', 'Friday', '1:00 PM-4:00 PM', '2025-10-29 13:39:15'),
(6, '0987654321', 'Wednesday', '7:00 AM-10:00 AM', '2025-10-29 15:28:07'),
(7, '0987654321', 'Thursday', '8:00 AM-11:30 AM', '2025-10-29 15:36:05'),
(8, '1234567890', 'Tuesday', '7:00 AM-9:30 AM', '2025-10-30 11:10:56'),
(10, '1234509876', 'Friday', '7:00 AM-9:00 AM', '2025-10-31 17:29:30'),
(11, '1234509876', 'Wednesday', '1:00 PM-4:00 PM', '2025-10-31 17:30:46');

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `location` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `follow_up_appointments`
--

CREATE TABLE `follow_up_appointments` (
  `id` int(11) NOT NULL,
  `counselor_id` varchar(10) NOT NULL,
  `student_id` varchar(100) NOT NULL,
  `parent_appointment_id` int(11) DEFAULT NULL COMMENT 'References the initial appointment or previous follow-up',
  `preferred_date` date NOT NULL,
  `preferred_time` varchar(50) NOT NULL,
  `consultation_type` varchar(50) NOT NULL,
  `follow_up_sequence` int(11) NOT NULL DEFAULT 1 COMMENT 'Track the sequence: 1st follow-up, 2nd follow-up, etc.',
  `description` text DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `status` enum('pending','rejected','completed','cancelled') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `follow_up_appointments`
--

INSERT INTO `follow_up_appointments` (`id`, `counselor_id`, `student_id`, `parent_appointment_id`, `preferred_date`, `preferred_time`, `consultation_type`, `follow_up_sequence`, `description`, `reason`, `status`, `created_at`, `updated_at`) VALUES
(34, '1234567890', '2020123456', 14, '2025-12-19', '11:00 AM - 11:30 AM', 'Individual Counseling', 3, 'ef f ', ' fef  fef ', 'completed', '2025-10-30 12:32:21', '2025-10-30 13:24:13'),
(39, '1234567890', '2023123456', 11, '2025-12-26', '10:30 AM - 11:00 AM', 'Individual Counseling', 1, 'dgfgfsbf vds fsdj jh ', 'fsdfvv svf fvshgfv f gsdfv', 'completed', '2025-10-30 13:23:11', '2025-10-30 13:38:18'),
(40, '1234567890', '2023123456', 11, '2026-01-16', '10:30 AM - 11:00 AM', 'Individual Counseling', 2, 'dsakjbs bsdf', 'fsdfgsdfgsfb hj ', 'completed', '2025-10-30 13:39:52', '2025-10-30 13:54:53'),
(42, '1234567890', '2023123456', 11, '2026-02-20', '10:00 AM - 10:30 AM', 'Individual Counseling', 3, 'kxbvkxcvhj nv kv bgvf', 'sfugu jsbjb sdv jhsd', 'completed', '2025-10-30 13:59:26', '2025-10-30 16:27:39'),
(43, '1234567890', '2023123456', 11, '2025-11-21', '10:00 AM - 10:30 AM', 'Individual Counseling', 4, 'fd ', 'eehfsb sdgbs', 'cancelled', '2025-10-30 16:41:49', '2025-10-31 09:23:37'),
(44, '1234567890', '2020123456', 14, '2025-10-31', '10:00 AM - 10:30 AM', 'Individual Counseling', 4, 'ghf hhggngh ', 'hjghgnfg ', 'completed', '2025-10-30 17:59:59', '2025-10-31 09:24:14'),
(45, '1234567890', '2020123456', 14, '2025-11-07', '10:00 AM - 10:30 AM', 'Individual Counseling', 5, 'fdlsb dfvbdfkv ', 'bbc bvvb', 'cancelled', '2025-10-31 09:25:54', '2025-10-31 09:26:25'),
(46, '1234567890', '2020123456', 14, '2025-11-14', '10:00 AM - 10:30 AM', 'Individual Counseling', 6, 'gfd g g', 'fjd gf', 'cancelled', '2025-10-31 09:27:38', '2025-10-31 09:32:46'),
(47, '1234509876', '2021123456', 27, '2025-11-21', '8:30 AM - 9:00 AM', 'Individual Counseling', 1, 'dsfbhdb dfbefdv vd ', 'gfsv sfvsv ', 'completed', '2025-10-31 17:45:32', '2025-10-31 17:57:34'),
(48, '1234509876', '2021123456', 27, '2025-11-28', '8:00 AM - 8:30 AM', 'Individual Counseling', 2, 'fsd ', 'df sd', 'completed', '2025-10-31 17:58:00', '2025-11-01 15:58:42'),
(49, '1234509876', '2021123456', 27, '2025-11-28', '8:00 AM - 8:30 AM', 'Individual Counseling', 3, 'v svdc ', ' dc d cd', 'completed', '2025-11-01 16:03:32', '2025-11-01 17:16:11'),
(50, '1234567890', '2020123456', 14, '2025-11-14', '10:00 AM - 10:30 AM', 'Individual Counseling', 7, 'gdh hdg ', 'fef d ', 'completed', '2025-11-01 16:54:30', '2025-11-01 17:11:57');

--
-- Triggers `follow_up_appointments`
--
DELIMITER $$
CREATE TRIGGER `maintain_followup_sequence` BEFORE INSERT ON `follow_up_appointments` FOR EACH ROW BEGIN
                IF NEW.parent_appointment_id IS NOT NULL THEN
                    SET NEW.follow_up_sequence = (
                        SELECT COALESCE(MAX(follow_up_sequence), 0) + 1 
                        FROM follow_up_appointments 
                        WHERE parent_appointment_id = NEW.parent_appointment_id
                    );
                END IF;
            END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `message_id` int(11) NOT NULL,
  `sender_id` varchar(10) DEFAULT NULL,
  `receiver_id` varchar(10) DEFAULT NULL,
  `message_text` text NOT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `version` varchar(255) NOT NULL,
  `class` varchar(255) NOT NULL,
  `group` varchar(255) NOT NULL,
  `namespace` varchar(255) NOT NULL,
  `time` int(11) NOT NULL,
  `batch` int(11) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` varchar(50) DEFAULT NULL,
  `type` varchar(50) NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `related_id` int(11) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `event_date` datetime DEFAULT NULL,
  `appointment_date` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `id` int(11) NOT NULL,
  `user_id` varchar(10) NOT NULL,
  `reset_code` varchar(10) NOT NULL,
  `reset_expires_at` datetime NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `student_academic_info`
--

CREATE TABLE `student_academic_info` (
  `id` int(11) NOT NULL,
  `student_id` varchar(10) NOT NULL,
  `course` varchar(50) NOT NULL,
  `year_level` varchar(10) NOT NULL,
  `academic_status` varchar(50) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_academic_info`
--

INSERT INTO `student_academic_info` (`id`, `student_id`, `course`, `year_level`, `academic_status`, `created_at`, `updated_at`) VALUES
(1, '2022311680', 'BSIT', 'III', 'Continuing/Old', '2025-10-29 03:17:08', '2025-10-29 03:17:08'),
(2, '2021123456', 'BSIT', 'I', 'New Student', '2025-10-29 06:37:59', '2025-10-29 06:37:59'),
(3, '2020123456', 'BSIT', 'I', 'Continuing/Old', '2025-10-29 19:27:55', '2025-10-29 19:27:55'),
(4, '2023123456', 'BSHM', 'III', 'Continuing/Old', '2025-10-31 19:58:36', '2025-10-31 19:58:36'),
(5, '2022123456', 'BSIT', 'I', 'Continuing/Old', '2025-10-31 20:05:00', '2025-10-31 20:05:00'),
(6, '2025123456', 'BSSW', 'I', 'Continuing/Old', '2025-10-31 20:22:47', '2025-10-31 20:22:47'),
(7, '2024123456', 'BSIT', 'III', 'Continuing/Old', '2025-10-31 20:26:31', '2025-10-31 20:26:31'),
(8, '2023303610', 'BSIT', 'I', 'Continuing/Old', '2025-11-01 01:45:59', '2025-11-01 01:45:59'),
(9, '2023303620', 'BSIT', 'I', 'Continuing/Old', '2025-11-01 01:47:20', '2025-11-01 01:47:20'),
(10, '2023303630', 'BSIT', 'I', 'Continuing/Old', '2025-11-01 01:49:01', '2025-11-01 01:49:01'),
(11, '2023303640', 'BSIT', 'I', 'Continuing/Old', '2025-11-01 01:51:02', '2025-11-01 01:51:02');

-- --------------------------------------------------------

--
-- Table structure for table `student_address_info`
--

CREATE TABLE `student_address_info` (
  `id` int(11) NOT NULL,
  `student_id` varchar(10) NOT NULL,
  `permanent_zone` varchar(50) DEFAULT NULL,
  `permanent_barangay` varchar(100) DEFAULT NULL,
  `permanent_city` varchar(100) DEFAULT NULL,
  `permanent_province` varchar(100) DEFAULT NULL,
  `present_zone` varchar(50) DEFAULT NULL,
  `present_barangay` varchar(100) DEFAULT NULL,
  `present_city` varchar(100) DEFAULT NULL,
  `present_province` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_address_info`
--

INSERT INTO `student_address_info` (`id`, `student_id`, `permanent_zone`, `permanent_barangay`, `permanent_city`, `permanent_province`, `present_zone`, `present_barangay`, `present_city`, `present_province`, `created_at`, `updated_at`) VALUES
(1, '2022311680', 'Sitio Migbanday', 'Poblacion', 'Claveria', 'Misamis Oriental', 'Sitio Migbanday', 'Poblacion', 'Claveria', 'Misamis Oriental', '2025-10-29 03:17:08', '2025-10-29 03:17:08'),
(2, '2021123456', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', '2025-10-29 06:37:59', '2025-10-29 06:37:59'),
(3, '2020123456', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', '2025-10-29 19:27:55', '2025-10-29 19:27:55'),
(4, '2023123456', '1', 'Hairlastic', 'Bench', 'Fix', '3', 'Poblacion', 'Claveria', 'Misamis Oriental', '2025-10-31 19:58:36', '2025-10-31 19:58:36'),
(5, '2022123456', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', '2025-10-31 20:05:00', '2025-10-31 20:05:00'),
(6, '2025123456', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', '2025-10-31 20:22:47', '2025-10-31 20:22:47'),
(7, '2024123456', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', '2025-10-31 20:26:31', '2025-10-31 20:26:31'),
(8, '2023303610', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', '2025-11-01 01:45:59', '2025-11-01 01:45:59'),
(9, '2023303620', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', '2025-11-01 01:47:20', '2025-11-01 01:47:20'),
(10, '2023303630', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', '2025-11-01 01:49:01', '2025-11-01 01:49:01'),
(11, '2023303640', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', 'N/A', '2025-11-01 01:51:02', '2025-11-01 01:51:02');

-- --------------------------------------------------------

--
-- Table structure for table `student_family_info`
--

CREATE TABLE `student_family_info` (
  `id` int(11) NOT NULL,
  `student_id` varchar(10) NOT NULL,
  `father_name` varchar(255) DEFAULT NULL,
  `father_occupation` varchar(100) DEFAULT NULL,
  `mother_name` varchar(255) DEFAULT NULL,
  `mother_occupation` varchar(100) DEFAULT NULL,
  `spouse` varchar(255) DEFAULT NULL,
  `guardian_contact_number` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_family_info`
--

INSERT INTO `student_family_info` (`id`, `student_id`, `father_name`, `father_occupation`, `mother_name`, `mother_occupation`, `spouse`, `guardian_contact_number`, `created_at`, `updated_at`) VALUES
(1, '2022311680', 'Fidelino S. Sitoy', 'None', 'Melchora Z. Sitoy', 'Barangay Health Worker', 'N/A', '09876543212', '2025-10-29 03:17:08', '2025-10-29 03:17:08'),
(2, '2023123456', 'Tecno ', '70W', 'Fantech', 'Suyen Corporation', 'N/A', '09878787877', '2025-10-31 19:58:36', '2025-10-31 19:58:36');

-- --------------------------------------------------------

--
-- Table structure for table `student_personal_info`
--

CREATE TABLE `student_personal_info` (
  `id` int(11) NOT NULL,
  `student_id` varchar(10) NOT NULL,
  `last_name` varchar(100) DEFAULT NULL,
  `first_name` varchar(100) DEFAULT NULL,
  `middle_name` varchar(100) DEFAULT NULL,
  `date_of_birth` date DEFAULT NULL,
  `age` int(3) DEFAULT NULL,
  `sex` enum('Male','Female') DEFAULT NULL,
  `civil_status` enum('Single','Married','Widowed','Legally Separated','Annulled') DEFAULT NULL,
  `contact_number` varchar(20) DEFAULT NULL,
  `fb_account_name` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_personal_info`
--

INSERT INTO `student_personal_info` (`id`, `student_id`, `last_name`, `first_name`, `middle_name`, `date_of_birth`, `age`, `sex`, `civil_status`, `contact_number`, `fb_account_name`, `created_at`, `updated_at`) VALUES
(1, '2022311680', 'Sitoy', 'Princess Grace Marie', 'Zalameda', '2003-12-09', 21, 'Female', 'Single', '09923757753', 'Freynsis Greys', '2025-10-29 03:17:08', '2025-10-29 03:17:08'),
(2, '2021123456', 'churva', 'Churba', 'Curba', '2007-06-12', 18, 'Male', 'Single', '09890988732', 'Churba Ka Teh', '2025-10-29 06:37:59', '2025-10-29 06:37:59'),
(3, '2020123456', 'Phenylpropanolamine', 'Chlorphenamine', 'Maleate', '2003-10-14', 22, 'Male', 'Single', '09899765212', 'Karma', '2025-10-29 19:27:55', '2025-10-29 19:27:55'),
(4, '2023123456', 'Lenovo', 'Tab', 'M', '2005-10-12', 20, 'Male', 'Single', '09787878787', 'Lenovo Tab M10 HD', '2025-10-31 19:58:36', '2025-10-31 19:58:36'),
(5, '2022123456', 'Hygienix', 'Hand Spray', 'Germkil', '2008-06-10', 17, 'Female', 'Single', '09345656560', 'N/A', '2025-10-31 20:05:00', '2025-10-31 20:05:00'),
(6, '2025123456', 'Toshiba', 'Portable Storage', 'G', '2006-02-06', 19, 'Female', 'Single', '09076565654', 'N/A', '2025-10-31 20:22:47', '2025-10-31 20:22:47'),
(7, '2024123456', 'Camphor', 'Balsem Lang Oil', 'P', '2005-08-24', 20, 'Male', 'Single', '09123456675', 'N/A', '2025-10-31 20:26:31', '2025-10-31 20:26:31'),
(8, '2023303610', 'Techno', 'Rex', 'Bro', NULL, NULL, 'Male', 'Single', '', 'N/A', '2025-11-01 01:45:59', '2025-11-01 01:45:59'),
(9, '2023303620', 'Exodus', 'Rex', 'N/A', NULL, NULL, 'Male', 'Single', '', 'N/A', '2025-11-01 01:47:20', '2025-11-01 01:47:20'),
(10, '2023303630', 'Sy', 'Rex', 'N/A', NULL, NULL, 'Male', 'Single', '', 'N/A', '2025-11-01 01:49:01', '2025-11-01 01:49:01'),
(11, '2023303640', 'Sihay', 'Dominic', 'N/A', NULL, NULL, 'Male', 'Single', '', 'N/A', '2025-11-01 01:51:02', '2025-11-01 01:51:02');

-- --------------------------------------------------------

--
-- Table structure for table `student_residence_info`
--

CREATE TABLE `student_residence_info` (
  `id` int(11) NOT NULL,
  `student_id` varchar(10) NOT NULL,
  `residence_type` enum('at home','boarding house','USTP-Claveria Dormitory','relatives','friends','other') DEFAULT NULL,
  `residence_other_specify` varchar(255) DEFAULT NULL,
  `has_consent` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_residence_info`
--

INSERT INTO `student_residence_info` (`id`, `student_id`, `residence_type`, `residence_other_specify`, `has_consent`, `created_at`, `updated_at`) VALUES
(1, '2022311680', 'at home', 'N/A', 1, '2025-10-29 03:17:08', '2025-10-29 03:17:08'),
(2, '2021123456', 'USTP-Claveria Dormitory', 'N/A', 1, '2025-10-29 06:37:59', '2025-10-29 06:37:59'),
(3, '2020123456', 'relatives', 'N/A', 1, '2025-10-29 19:27:55', '2025-10-29 19:27:55'),
(4, '2023123456', 'boarding house', 'N/A', 1, '2025-10-31 19:58:36', '2025-10-31 19:58:36'),
(5, '2022123456', 'USTP-Claveria Dormitory', 'N/A', 1, '2025-10-31 20:05:00', '2025-10-31 20:05:00'),
(6, '2025123456', 'boarding house', 'N/A', 1, '2025-10-31 20:22:47', '2025-10-31 20:22:47'),
(7, '2024123456', 'relatives', 'N/A', 1, '2025-10-31 20:26:31', '2025-10-31 20:26:31'),
(8, '2023303610', 'at home', 'N/A', 1, '2025-11-01 01:45:59', '2025-11-01 01:45:59'),
(9, '2023303620', 'at home', 'N/A', 1, '2025-11-01 01:47:20', '2025-11-01 01:47:20'),
(10, '2023303630', 'at home', 'N/A', 1, '2025-11-01 01:49:01', '2025-11-01 01:49:01'),
(11, '2023303640', 'at home', 'N/A', 1, '2025-11-01 01:51:02', '2025-11-01 01:51:02');

-- --------------------------------------------------------

--
-- Table structure for table `student_services_availed`
--

CREATE TABLE `student_services_availed` (
  `id` int(11) NOT NULL,
  `student_id` varchar(10) NOT NULL,
  `service_type` enum('counseling','insurance','special_lanes','safe_learning','equal_access','other') NOT NULL,
  `other_specify` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_services_availed`
--

INSERT INTO `student_services_availed` (`id`, `student_id`, `service_type`, `other_specify`, `created_at`) VALUES
(1, '2022311680', 'counseling', NULL, '2025-10-29 11:17:08'),
(2, '2022311680', 'safe_learning', NULL, '2025-10-29 11:17:08'),
(3, '2022311680', 'equal_access', NULL, '2025-10-29 11:17:08'),
(4, '2021123456', 'counseling', NULL, '2025-10-29 14:37:59'),
(5, '2021123456', 'safe_learning', NULL, '2025-10-29 14:37:59'),
(6, '2021123456', 'equal_access', NULL, '2025-10-29 14:37:59'),
(7, '2020123456', 'counseling', NULL, '2025-10-30 03:27:55'),
(8, '2020123456', 'special_lanes', NULL, '2025-10-30 03:27:55'),
(9, '2020123456', 'safe_learning', NULL, '2025-10-30 03:27:55'),
(10, '2020123456', 'equal_access', NULL, '2025-10-30 03:27:55'),
(11, '2023123456', 'counseling', NULL, '2025-11-01 03:58:36'),
(12, '2023123456', 'special_lanes', NULL, '2025-11-01 03:58:36'),
(13, '2023123456', 'safe_learning', NULL, '2025-11-01 03:58:36'),
(14, '2023123456', 'equal_access', NULL, '2025-11-01 03:58:36'),
(15, '2022123456', 'counseling', NULL, '2025-11-01 04:05:00'),
(16, '2022123456', 'safe_learning', NULL, '2025-11-01 04:05:00'),
(17, '2022123456', 'equal_access', NULL, '2025-11-01 04:05:00'),
(18, '2025123456', 'counseling', NULL, '2025-11-01 04:22:47'),
(19, '2025123456', 'safe_learning', NULL, '2025-11-01 04:22:47'),
(20, '2025123456', 'equal_access', NULL, '2025-11-01 04:22:47'),
(21, '2024123456', 'counseling', NULL, '2025-11-01 04:26:31'),
(22, '2024123456', 'safe_learning', NULL, '2025-11-01 04:26:31'),
(23, '2024123456', 'equal_access', NULL, '2025-11-01 04:26:31');

-- --------------------------------------------------------

--
-- Table structure for table `student_services_needed`
--

CREATE TABLE `student_services_needed` (
  `id` int(11) NOT NULL,
  `student_id` varchar(10) NOT NULL,
  `service_type` enum('counseling','insurance','special_lanes','safe_learning','equal_access','other') NOT NULL,
  `other_specify` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_services_needed`
--

INSERT INTO `student_services_needed` (`id`, `student_id`, `service_type`, `other_specify`, `created_at`) VALUES
(1, '2022311680', 'counseling', NULL, '2025-10-29 11:17:08'),
(2, '2022311680', 'insurance', NULL, '2025-10-29 11:17:08'),
(3, '2022311680', 'safe_learning', NULL, '2025-10-29 11:17:08'),
(4, '2022311680', 'equal_access', NULL, '2025-10-29 11:17:08'),
(5, '2021123456', 'counseling', NULL, '2025-10-29 14:37:59'),
(6, '2021123456', 'insurance', NULL, '2025-10-29 14:37:59'),
(7, '2021123456', 'special_lanes', NULL, '2025-10-29 14:37:59'),
(8, '2021123456', 'safe_learning', NULL, '2025-10-29 14:37:59'),
(9, '2021123456', 'equal_access', NULL, '2025-10-29 14:37:59'),
(10, '2020123456', 'counseling', NULL, '2025-10-30 03:27:55'),
(11, '2020123456', 'insurance', NULL, '2025-10-30 03:27:55'),
(12, '2020123456', 'special_lanes', NULL, '2025-10-30 03:27:55'),
(13, '2020123456', 'safe_learning', NULL, '2025-10-30 03:27:55'),
(14, '2020123456', 'equal_access', NULL, '2025-10-30 03:27:55'),
(15, '2023123456', 'counseling', NULL, '2025-11-01 03:58:36'),
(16, '2023123456', 'insurance', NULL, '2025-11-01 03:58:36'),
(17, '2023123456', 'safe_learning', NULL, '2025-11-01 03:58:36'),
(18, '2023123456', 'equal_access', NULL, '2025-11-01 03:58:36'),
(19, '2025123456', 'counseling', NULL, '2025-11-01 04:22:47'),
(20, '2025123456', 'insurance', NULL, '2025-11-01 04:22:47'),
(21, '2025123456', 'safe_learning', NULL, '2025-11-01 04:22:47'),
(22, '2025123456', 'equal_access', NULL, '2025-11-01 04:22:47'),
(23, '2024123456', 'insurance', NULL, '2025-11-01 04:26:31'),
(24, '2024123456', 'safe_learning', NULL, '2025-11-01 04:26:31'),
(25, '2024123456', 'equal_access', NULL, '2025-11-01 04:26:31');

-- --------------------------------------------------------

--
-- Table structure for table `student_special_circumstances`
--

CREATE TABLE `student_special_circumstances` (
  `id` int(11) NOT NULL,
  `student_id` varchar(10) NOT NULL,
  `is_solo_parent` enum('Yes','No') DEFAULT NULL,
  `is_indigenous` enum('Yes','No') DEFAULT NULL,
  `is_breastfeeding` enum('Yes','No','N/A') DEFAULT NULL,
  `is_pwd` enum('Yes','No','Other') DEFAULT NULL,
  `pwd_disability_type` varchar(255) DEFAULT NULL,
  `pwd_proof_file` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `student_special_circumstances`
--

INSERT INTO `student_special_circumstances` (`id`, `student_id`, `is_solo_parent`, `is_indigenous`, `is_breastfeeding`, `is_pwd`, `pwd_disability_type`, `pwd_proof_file`, `created_at`, `updated_at`) VALUES
(1, '2022311680', 'No', 'Yes', 'No', 'No', 'N/A', 'N/A', '2025-10-29 03:17:08', '2025-10-29 03:17:08'),
(2, '2021123456', 'No', 'No', 'N/A', 'No', 'N/A', 'N/A', '2025-10-29 06:37:59', '2025-10-29 06:37:59'),
(3, '2020123456', 'No', 'No', 'N/A', 'Yes', 'Deaf', 'N/A', '2025-10-29 19:27:55', '2025-10-29 19:27:55'),
(4, '2023123456', 'No', 'No', 'N/A', 'No', 'N/A', 'N/A', '2025-10-31 19:58:36', '2025-10-31 19:58:36'),
(5, '2022123456', 'No', 'Yes', 'No', 'No', 'N/A', 'N/A', '2025-10-31 20:05:00', '2025-10-31 20:05:00'),
(6, '2025123456', 'No', 'No', 'No', 'No', 'N/A', 'N/A', '2025-10-31 20:22:47', '2025-10-31 20:22:47'),
(7, '2024123456', 'No', 'No', 'N/A', 'No', 'N/A', 'N/A', '2025-10-31 20:26:31', '2025-10-31 20:26:31'),
(8, '2023303610', 'No', 'No', 'N/A', 'No', 'N/A', 'N/A', '2025-11-01 01:45:59', '2025-11-01 01:45:59'),
(9, '2023303620', 'No', 'No', 'N/A', 'No', 'N/A', 'N/A', '2025-11-01 01:47:20', '2025-11-01 01:47:20'),
(10, '2023303630', 'No', 'No', 'N/A', 'No', 'N/A', 'N/A', '2025-11-01 01:49:01', '2025-11-01 01:49:01'),
(11, '2023303640', 'No', 'No', 'N/A', 'No', 'N/A', 'N/A', '2025-11-01 01:51:02', '2025-11-01 01:51:02');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `user_id` varchar(10) NOT NULL,
  `username` varchar(100) DEFAULT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `verification_token` varchar(6) DEFAULT NULL,
  `reset_expires_at` datetime DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT 0,
  `role` enum('student','admin','counselor') NOT NULL DEFAULT 'student',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `profile_picture` varchar(255) DEFAULT NULL,
  `last_login` timestamp NULL DEFAULT NULL,
  `logout_time` timestamp NULL DEFAULT NULL,
  `last_activity` timestamp NULL DEFAULT NULL,
  `last_active_at` timestamp NULL DEFAULT NULL,
  `last_inactive_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `user_id`, `username`, `email`, `password`, `verification_token`, `reset_expires_at`, `is_verified`, `role`, `created_at`, `profile_picture`, `last_login`, `logout_time`, `last_activity`, `last_active_at`, `last_inactive_at`) VALUES
(1, '0000000001', 'admin', 'counselign2025@gmail.com', '$2y$10$2jykmDFwEGmiVEUUCLAyRegtOl70cFFvJfasXK0bRHPiwtmJDX6XG', NULL, NULL, 1, 'admin', '2025-10-29 11:01:58', 'Photos/profile_pictures/admin_1_1761736180.png', '2025-11-03 11:35:06', '2025-10-31 17:26:36', '2025-11-03 11:35:06', '2025-11-03 11:35:06', '2025-10-31 17:26:36'),
(2, '2022311680', 'Freynsis Greys', 'sitoyprincessgrace09@gmail.com', '$2y$10$isXMDU7/42b3W8zjmZBFOO3DLwXRCxeWIEZOA3EIY5m7qD63Gy0m6', NULL, NULL, 1, 'student', '2025-10-29 11:12:19', 'http://localhost/Counselign/public/Photos/profile.png', '2025-11-01 14:24:16', '2025-10-30 03:31:21', '2025-11-01 16:41:04', '2025-11-01 16:41:04', '2025-10-30 03:31:21'),
(3, '1234567890', 'shizcess', 'esangairemgrace@gmail.com', '$2y$10$RX.SgQdb3o6BlBW1Y0AnF.4CYgLOGyTUdsNV28Tu8/TW4jvn7wWWG', NULL, NULL, 1, 'counselor', '2025-10-29 11:52:55', 'Photos/profile_pictures/counselor_1234567890_1761738972.jpg', '2025-11-03 11:05:10', '2025-11-01 18:41:01', '2025-11-03 11:05:12', '2025-11-03 11:05:12', '2025-11-01 18:41:01'),
(4, '0987654321', 'freynsis', 'impactog0903@gmail.com', '$2y$10$jfqc573Mf.HVGA1GpprlQei4GOFcv5jTxy5QU/JmwKprtHIMp90EW', NULL, NULL, 1, 'counselor', '2025-10-29 13:35:23', 'Photos/profile_pictures/counselor_0987654321_1761745010.jpg', '2025-11-01 17:15:24', '2025-11-01 17:15:39', '2025-11-01 17:15:39', '2025-11-01 17:15:39', '2025-11-01 17:15:39'),
(5, '2023123456', 'printit', 'unique.corn254@gmail.com', '$2y$10$BZ/xh83xueyjsw1ZFvoMcOsUwektV.3yYTmaG199eocRfKkhcLdxi', NULL, NULL, 1, 'student', '2025-10-29 13:41:44', 'Photos/profile_pictures/student_2023123456_1761969611.png', '2025-11-01 03:52:46', '2025-11-01 04:02:16', '2025-11-01 04:02:17', '2025-11-01 04:02:17', '2025-11-01 04:02:16'),
(6, '2022123456', 'Sharlang', 'katkat.luvie@gmail.com', '$2y$10$DjtsxYwpuJTAo6o0ASggZ.5tK10UEC4/IlxeywrbVB0EVz/5AqOeK', NULL, NULL, 1, 'student', '2025-10-29 13:48:27', 'http://localhost/Counselign/public/Photos/profile.png', '2025-11-01 18:40:39', '2025-11-01 17:10:45', '2025-11-01 18:43:04', '2025-11-01 18:43:04', '2025-11-01 17:10:45'),
(7, '2021123456', 'Churba', 'pa12a.cursor@gmail.com', '$2y$10$V.pqqlHXTT2vMOgV7AVYYewb7ItCY1F6ptmauhGu6vBKM/TgiblR2', NULL, NULL, 1, 'student', '2025-10-29 13:56:36', 'http://localhost/Counselign/public/Photos/profile.png', '2025-11-03 11:05:51', '2025-10-29 15:06:49', '2025-11-03 11:51:08', '2025-11-03 11:51:08', '2025-10-29 15:06:49'),
(8, '2020123456', 'Karma', 'xtracursor@gmail.com', '$2y$10$KN76abjRM8ZkmtnFZNoqC.m7gL3J67KKGtBGR4Zk3qugYp6ysqOky', NULL, NULL, 1, 'student', '2025-10-29 14:00:00', 'http://localhost/Counselign/public/Photos/profile.png', '2025-11-01 14:37:44', '2025-11-01 09:35:51', '2025-11-01 17:12:03', '2025-11-01 17:12:03', '2025-11-01 09:35:51'),
(9, '2025123456', 'Chuyy', 'osmont.infinity@gmail.com', '$2y$10$/rfM3eTO1WrCF89PzDuAGOu0wa0WLXz9bY2O2gNgo.exOIPGgm7N.', NULL, NULL, 1, 'student', '2025-10-29 14:20:34', 'http://localhost/Counselign/public/Photos/profile.png', '2025-11-01 08:25:37', '2025-11-01 09:35:57', '2025-11-01 09:35:57', '2025-11-01 09:35:57', '2025-11-01 09:35:57'),
(10, '2024123456', 'Sheeesh', 'noah.tyranny@gmail.com', '$2y$10$m5ePXOmAC5bDQI3TXJcnpOXzy1Ua8JmAiHbwwe3ep2OMgYra6XnAe', NULL, NULL, 1, 'student', '2025-10-29 15:20:14', 'http://localhost/Counselign/public/Photos/profile.png', '2025-11-01 18:41:50', '2025-11-01 09:33:30', '2025-11-01 18:41:50', '2025-11-01 18:41:50', '2025-11-01 09:33:30'),
(13, '1234509876', 'Shixcess', 'katkatluvie@gmail.com', '$2y$10$Nu1kSjAZdmqHw0O5Xm6QvOllPvHBglqSkL7GrekeJvcou1h0Z.6Pa', NULL, NULL, 1, 'counselor', '2025-10-31 17:23:01', 'Photos/profile_pictures/counselor_1234509876_1761931662.jpg', '2025-11-01 18:41:17', '2025-11-01 17:17:27', '2025-11-01 18:43:08', '2025-11-01 18:43:08', '2025-11-01 17:17:27'),
(15, '2023303610', 'techy_rex', 'technorex13@gmail.com', '$2y$10$oyavlh5BHb6Ywm1Wv8Ibg.ap0kM9H0gjmgrnuF/X6n7glgVPS41kS', NULL, NULL, 1, 'student', '2025-11-01 09:44:45', 'http://localhost/Counselign/public/Photos/profile.png', '2025-11-01 09:45:24', '2025-11-01 09:46:10', '2025-11-01 09:46:10', '2025-11-01 09:46:10', '2025-11-01 09:46:10'),
(16, '2023303620', 'exo_rex', 'exodusrex13@gmail.com', '$2y$10$04pWVjvcvfCeeIJXoiDmdOa40Px383T2mSfqtxtQGPkPSlKv4UIa.', NULL, NULL, 1, 'student', '2025-11-01 09:46:39', 'http://localhost/Counselign/public/Photos/profile.png', '2025-11-01 09:46:55', '2025-11-01 09:47:33', '2025-11-01 09:47:33', '2025-11-01 09:47:33', '2025-11-01 09:47:33'),
(17, '2023303630', 'sy_rex', 'sihay.rexdominic13@gmail.com', '$2y$10$jeiPj0lPbzZZvQRzkoafXOn633mXn4.PN//fvdJbF6jeAvPFd8Whu', NULL, NULL, 1, 'student', '2025-11-01 09:48:21', 'http://localhost/Counselign/public/Photos/profile.png', '2025-11-01 14:53:44', '2025-11-01 09:49:09', '2025-11-01 18:43:13', '2025-11-01 18:43:13', '2025-11-01 09:49:09'),
(18, '2023303640', 'rexd', 'rexsihay@gmail.com', '$2y$10$u/t6RWBd63TOezdDnYEuWeR6KlKmy6SMgnl.BdYLch9zIDBa4h8jq', NULL, NULL, 1, 'student', '2025-11-01 09:49:57', 'http://localhost/Counselign/public/Photos/profile.png', '2025-11-01 14:39:05', '2025-11-01 14:53:18', '2025-11-01 14:53:18', '2025-11-01 14:53:18', '2025-11-01 14:53:18');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `announcements`
--
ALTER TABLE `announcements`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `appointments_ibfk_1` (`student_id`) USING BTREE,
  ADD KEY `idx_appointment_counselor_date_status` (`counselor_preference`,`preferred_date`,`status`),
  ADD KEY `idx_appointment_student_status` (`student_id`,`status`);

--
-- Indexes for table `ci_sessions`
--
ALTER TABLE `ci_sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `timestamp` (`timestamp`);

--
-- Indexes for table `counselors`
--
ALTER TABLE `counselors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `counselor_ibfk_1` (`counselor_id`);

--
-- Indexes for table `counselor_availability`
--
ALTER TABLE `counselor_availability`
  ADD PRIMARY KEY (`id`),
  ADD KEY `counselor_id` (`counselor_id`),
  ADD KEY `idx_counselor_availability_day` (`counselor_id`,`available_days`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `follow_up_appointments`
--
ALTER TABLE `follow_up_appointments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_counselor` (`counselor_id`),
  ADD KEY `idx_student` (`student_id`),
  ADD KEY `idx_parent_appointment` (`parent_appointment_id`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_followup_parent_sequence` (`parent_appointment_id`,`follow_up_sequence`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `idx_created_at` (`created_at`),
  ADD KEY `messages_ibfk_1` (`sender_id`),
  ADD KEY `messages_ibfk_2` (`receiver_id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_user_id` (`user_id`),
  ADD KEY `idx_is_read` (`is_read`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_reset_code` (`reset_code`),
  ADD KEY `password_resets_fk2` (`user_id`);

--
-- Indexes for table `student_academic_info`
--
ALTER TABLE `student_academic_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_id` (`student_id`),
  ADD KEY `idx_academic_course` (`course`,`year_level`);

--
-- Indexes for table `student_address_info`
--
ALTER TABLE `student_address_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_id` (`student_id`);

--
-- Indexes for table `student_family_info`
--
ALTER TABLE `student_family_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_id` (`student_id`);

--
-- Indexes for table `student_personal_info`
--
ALTER TABLE `student_personal_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_id` (`student_id`);

--
-- Indexes for table `student_residence_info`
--
ALTER TABLE `student_residence_info`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_id` (`student_id`);

--
-- Indexes for table `student_services_availed`
--
ALTER TABLE `student_services_availed`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_student_service_type` (`student_id`,`service_type`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `idx_user_services_availed` (`student_id`,`service_type`);

--
-- Indexes for table `student_services_needed`
--
ALTER TABLE `student_services_needed`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uk_student_service_needed_type` (`student_id`,`service_type`),
  ADD KEY `student_id` (`student_id`),
  ADD KEY `idx_user_services_needed` (`student_id`,`service_type`);

--
-- Indexes for table `student_special_circumstances`
--
ALTER TABLE `student_special_circumstances`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `student_id` (`student_id`),
  ADD KEY `idx_pwd_status` (`is_pwd`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user_id` (`user_id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `announcements`
--
ALTER TABLE `announcements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `counselors`
--
ALTER TABLE `counselors`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `counselor_availability`
--
ALTER TABLE `counselor_availability`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `follow_up_appointments`
--
ALTER TABLE `follow_up_appointments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=51;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `password_resets`
--
ALTER TABLE `password_resets`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `student_academic_info`
--
ALTER TABLE `student_academic_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `student_address_info`
--
ALTER TABLE `student_address_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `student_family_info`
--
ALTER TABLE `student_family_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `student_personal_info`
--
ALTER TABLE `student_personal_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `student_residence_info`
--
ALTER TABLE `student_residence_info`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `student_services_availed`
--
ALTER TABLE `student_services_availed`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT for table `student_services_needed`
--
ALTER TABLE `student_services_needed`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `student_special_circumstances`
--
ALTER TABLE `student_special_circumstances`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `appointments_fk2` FOREIGN KEY (`counselor_preference`) REFERENCES `counselors` (`counselor_id`),
  ADD CONSTRAINT `appointments_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `counselors`
--
ALTER TABLE `counselors`
  ADD CONSTRAINT `counselor_ibfk_1` FOREIGN KEY (`counselor_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `counselor_availability`
--
ALTER TABLE `counselor_availability`
  ADD CONSTRAINT `counselor_availability_ibfk_1` FOREIGN KEY (`counselor_id`) REFERENCES `counselors` (`counselor_id`) ON DELETE CASCADE;

--
-- Constraints for table `follow_up_appointments`
--
ALTER TABLE `follow_up_appointments`
  ADD CONSTRAINT `fk_parent_appointment` FOREIGN KEY (`parent_appointment_id`) REFERENCES `appointments` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_student` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `follow_up_appointments_ibfk_1` FOREIGN KEY (`counselor_id`) REFERENCES `counselors` (`counselor_id`) ON DELETE CASCADE;

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD CONSTRAINT `password_resets_fk2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `student_academic_info`
--
ALTER TABLE `student_academic_info`
  ADD CONSTRAINT `student_academic_info_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `student_address_info`
--
ALTER TABLE `student_address_info`
  ADD CONSTRAINT `student_address_info_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `student_family_info`
--
ALTER TABLE `student_family_info`
  ADD CONSTRAINT `student_family_info_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `student_personal_info`
--
ALTER TABLE `student_personal_info`
  ADD CONSTRAINT `student_personal_info_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `student_residence_info`
--
ALTER TABLE `student_residence_info`
  ADD CONSTRAINT `student_residence_info_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `student_services_availed`
--
ALTER TABLE `student_services_availed`
  ADD CONSTRAINT `student_services_availed_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `student_services_needed`
--
ALTER TABLE `student_services_needed`
  ADD CONSTRAINT `student_services_needed_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `student_special_circumstances`
--
ALTER TABLE `student_special_circumstances`
  ADD CONSTRAINT `student_special_circumstances_ibfk_1` FOREIGN KEY (`student_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
