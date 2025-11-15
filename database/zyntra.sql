-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 13, 2025 at 02:23 PM
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
-- Database: `zyntra`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `category_id` int(10) NOT NULL,
  `category_name` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` int(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`, `created_at`, `updated_at`, `status`) VALUES
(1, 'Mobile Phones & Accessories', '2025-10-10 13:09:17', '2025-10-10 21:09:17', 1),
(2, 'Laptops, Desktops & Monitors', '2025-10-10 13:09:17', '2025-10-10 21:09:17', 1),
(3, 'Audio & Video Equipment', '2025-10-10 13:09:17', '2025-10-10 21:09:17', 1),
(4, 'Smart Home Devices', '2025-10-10 13:09:17', '2025-10-10 21:09:17', 1),
(5, 'Cameras & Photography', '2025-10-10 13:09:17', '2025-10-10 21:09:17', 1),
(6, 'Wearable Technology', '2025-10-10 13:09:17', '2025-10-10 21:09:17', 1);

-- --------------------------------------------------------

--
-- Table structure for table `delivery_partners`
--

CREATE TABLE `delivery_partners` (
  `partner_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `full_name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `vehicle_type` varchar(50) NOT NULL COMMENT 'motorcycle, car',
  `plate_number` varchar(50) NOT NULL,
  `region` varchar(100) NOT NULL,
  `province` varchar(100) NOT NULL,
  `city` varchar(100) NOT NULL,
  `barangay` varchar(100) NOT NULL,
  `street` varchar(255) NOT NULL,
  `drivers_license_path` varchar(255) NOT NULL,
  `gov_id_path` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '0=pending, 1=approved, 2=rejected, 3=active, 4=inactive'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `delivery_partners`
--

INSERT INTO `delivery_partners` (`partner_id`, `user_id`, `full_name`, `email`, `phone`, `vehicle_type`, `plate_number`, `region`, `province`, `city`, `barangay`, `street`, `drivers_license_path`, `gov_id_path`, `created_at`, `updated_at`, `status`) VALUES
(1, NULL, 'ASD ASD', 'asd@gmail.com', '09876543216', 'car', 'WEC 321', 'Region VIII (Eastern Visayas)', 'Eastern Samar', 'Llorente', 'Barangay 5 (Pob.)', '12', 'static/uploads/delivery_documents\\954826743318621.png', 'static/uploads/delivery_documents\\233030358315315.png', '2025-10-12 06:17:39', '2025-10-12 06:17:39', 0),
(2, 6, 'Arce LC', 'ventre@gmail.com', '09876543217', 'motorcycle', 'WEC 321', 'Region V (Bicol Region)', 'Camarines Sur', 'Canaman', 'San Francisco', '12', 'static/uploads/delivery_documents\\678678243999425.JPG', 'static/uploads/delivery_documents\\564670080972360.png', '2025-10-12 06:25:02', '2025-10-12 06:25:02', 0),
(3, 11, 'Juan Dela Cruz', 'your112323@gmail.com', '+639123423442', 'motorcycle', '1234fdfsd', 'MIMAROPA', 'Oriental Mindoro', 'San Teodoro', 'Caagutayan', 'awdasd', 'static/uploads/delivery_documents\\606158676669815.jpg', 'static/uploads/delivery_documents\\948829948130404.jpg', '2025-10-19 12:16:14', '2025-10-19 12:16:14', 0),
(4, 15, 'John Lloyd J. Bustria', 'lloydbustqweqweqria9@gmail.com', '+639692991918', 'motorcycle', 'qweqwe', 'National Capital Region (NCR)', 'Ncr, City Of Manila, First District', 'Santa Ana', 'Barangay 760', 'qwe', 'static/uploads/delivery_documents\\858699063267528.jpg', 'static/uploads/delivery_documents\\800479614633300.jpg', '2025-10-21 06:14:32', '2025-10-21 06:14:32', 0),
(5, 18, 'Lloyd', 'leloyd@gmail.com', '092939872939', 'motorcycle', '123', 'National Capital Region (NCR)', 'Ncr, City Of Manila, First District', 'Santa Ana', 'Barangay 761', '123', 'static/uploads/delivery_documents\\704485561520456.jpg', 'static/uploads/delivery_documents\\825082006708596.jpg', '2025-10-21 14:08:56', '2025-10-21 14:08:56', 0),
(6, 20, 'qwe', 'qweasd@gmail.com', '09592882817', 'motorcycle', 'qwe', 'Cordillera Administrative Region (CAR)', 'Apayao', 'Luna', 'San Isidro Sur', 'qwe', 'static/uploads/delivery_documents\\460881311677105.jpg', 'static/uploads/delivery_documents\\939714424737417.jpg', '2025-10-22 16:39:00', '2025-10-22 16:39:00', 0),
(7, 22, 'John Kaith', 'pogese@gmail.com', '09876543218', 'car', 'WEC 327', 'Region VII (Central Visayas)', 'Cebu', 'Borbon', 'Poblacion', 'N/A', 'static/uploads/delivery_documents\\873519154793761.jpg', 'static/uploads/delivery_documents\\777731177533426.jpg', '2025-10-25 15:32:36', '2025-10-25 15:32:36', 0);

-- --------------------------------------------------------

--
-- Table structure for table `products`
--

CREATE TABLE `products` (
  `product_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `category_id` int(10) DEFAULT NULL,
  `product_name` varchar(255) DEFAULT NULL,
  `description` longtext DEFAULT NULL,
  `price` decimal(10,2) DEFAULT NULL,
  `qty` int(10) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` int(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `products`
--

INSERT INTO `products` (`product_id`, `user_id`, `category_id`, `product_name`, `description`, `price`, `qty`, `created_at`, `updated_at`, `status`) VALUES
(19, 5, 3, 'Apple Sony WH-CH520 / WH CH520 Wireless Bluetooth Headphones', 'hehe', 1299.00, 31, '2025-10-29 04:17:39', '2025-10-29 12:17:39', 1),
(20, 5, 2, 'try', '<p>34142414</p>', 4324.00, 232, '2025-11-11 11:23:51', '2025-11-11 19:23:51', 1),
(21, 5, 2, 'try1', '<p>ehds</p>', 3211.00, 5432, '2025-11-11 11:31:35', '2025-11-11 19:31:35', 1),
(22, 5, 4, 'try2', '<p>34234rdfvx</p>', 3414.00, 21, '2025-11-11 11:33:04', '2025-11-11 20:54:00', 2),
(23, 5, 4, 'try3', '<p>qwertyu</p>', 123.00, 3, '2025-11-11 11:37:12', '2025-11-11 19:37:12', 1),
(24, 5, 6, 'try 4', '<p>asfffafw</p>', 213.00, 3321, '2025-11-11 12:23:22', '2025-11-11 20:23:22', 1),
(25, 5, 5, 'dasdadaetfef', '<p>da3udb</p>', 312.00, 43, '2025-11-11 12:25:40', '2025-11-11 21:04:26', 1),
(26, 5, 5, 'try 5', '<p>dwdwff</p>', 32134.00, 5453, '2025-11-11 12:28:16', '2025-11-11 20:28:16', 1),
(27, 5, 2, 'dah', '<p>sdfghjk</p>', 23.00, 231, '2025-11-11 12:42:30', '2025-11-11 20:42:30', 1),
(28, 5, 5, '324567yuh', '<p>fhdsjdk</p>', 321.00, 321, '2025-11-11 12:54:55', '2025-11-11 20:54:55', 1),
(29, 5, 5, 'ewdsa', '<p>2ewqdsaxz</p>', 3211.00, 5432, '2025-11-12 18:26:13', '2025-11-13 02:26:13', 1),
(30, 5, 6, 'rewfdscxz', '<p>43421</p>', 1234567.00, 21, '2025-11-12 18:27:03', '2025-11-13 02:27:03', 1);

-- --------------------------------------------------------

--
-- Table structure for table `product_attachments`
--

CREATE TABLE `product_attachments` (
  `product_attachment_id` int(10) NOT NULL,
  `product_id` int(10) DEFAULT NULL,
  `attachment` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` int(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_attachments`
--

INSERT INTO `product_attachments` (`product_attachment_id`, `product_id`, `attachment`, `created_at`, `updated_at`, `status`) VALUES
(29, 19, 'uploads/products/253e71dee4774d55bb6c185792e1c47c.jpg', '2025-10-29 04:17:39', '2025-10-29 12:17:39', 1),
(30, 20, '855819602542095.jpg', '2025-11-11 11:23:51', '2025-11-11 19:23:51', 1),
(31, 20, '150655075328264.jpg', '2025-11-11 11:23:51', '2025-11-11 19:23:51', 1),
(32, 21, '165864936332008.jpg', '2025-11-11 11:31:35', '2025-11-11 19:31:35', 1),
(33, 21, '383498243744478.jpg', '2025-11-11 11:31:35', '2025-11-11 19:31:35', 1),
(34, 22, 'uploads\\products\\931997964362045.jpg', '2025-11-11 11:33:04', '2025-11-11 19:33:04', 1),
(35, 22, 'uploads\\products\\541704121245382.jpg', '2025-11-11 11:33:04', '2025-11-11 19:33:04', 1),
(36, 23, 'uploads/products/171564239077704.jpg', '2025-11-11 11:37:12', '2025-11-11 19:37:12', 1),
(37, 23, 'uploads/products/490158832658656.jpg', '2025-11-11 11:37:12', '2025-11-11 19:37:12', 1),
(38, 24, '379459495907866.jpg', '2025-11-11 12:23:22', '2025-11-11 20:23:22', 1),
(39, 24, '888149959210108.jpg', '2025-11-11 12:23:22', '2025-11-11 20:23:22', 1),
(40, 25, '765125431974366.png', '2025-11-11 12:25:40', '2025-11-11 20:25:40', 1),
(41, 25, '289533426071179.png', '2025-11-11 12:25:40', '2025-11-11 20:25:40', 1),
(42, 26, '263776708625893.jpg', '2025-11-11 12:28:16', '2025-11-11 20:28:16', 1),
(43, 26, '557086373548063.jpg', '2025-11-11 12:28:16', '2025-11-11 20:28:16', 1),
(44, 27, '926615091866739.jpg', '2025-11-11 12:42:30', '2025-11-11 20:42:30', 1),
(45, 27, '661399817065362.jpg', '2025-11-11 12:42:30', '2025-11-11 20:42:30', 1),
(46, 28, 'uploads/products/9d3d2dea9b524a2c9a07d9a3fca22edd.jpg', '2025-11-11 12:54:55', '2025-11-11 20:54:55', 1),
(47, 28, 'uploads/products/12f0dfac6acf453cba57bc1e5791b66a.jpg', '2025-11-11 12:54:55', '2025-11-11 20:54:55', 1),
(48, 29, 'uploads/products/355016ccb9a34ed9a9123d3205cf87a4.jpg', '2025-11-12 18:26:13', '2025-11-13 02:26:13', 1),
(49, 29, 'uploads/products/2833e9363d984056bcec816825b649bb.png', '2025-11-12 18:26:13', '2025-11-13 02:26:13', 1),
(50, 30, 'uploads/products/137244d4195542e382ef22c4e277ab75.jpg', '2025-11-12 18:27:03', '2025-11-13 02:27:03', 1),
(51, 30, 'uploads/products/366604ee0475482e8d47f6e254099fb5.png', '2025-11-12 18:27:03', '2025-11-13 02:27:03', 1),
(52, 30, 'uploads/products/a52fe32e9d3c4a65a7223a239465e1a3.png', '2025-11-12 18:27:03', '2025-11-13 02:27:03', 1);

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `role_id` int(10) NOT NULL,
  `name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`role_id`, `name`) VALUES
(1, 'Admin'),
(2, 'Buyer'),
(3, 'Seller'),
(4, 'Rider');

-- --------------------------------------------------------

--
-- Table structure for table `seller_details`
--

CREATE TABLE `seller_details` (
  `seller_detail_id` int(11) NOT NULL,
  `user_id` int(10) NOT NULL,
  `store_name` varchar(255) NOT NULL,
  `description` longtext DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `barangay` varchar(100) DEFAULT NULL,
  `street` varchar(255) DEFAULT NULL,
  `gov_id_path` varchar(255) DEFAULT NULL,
  `business_permit_path` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` int(1) NOT NULL DEFAULT 0 COMMENT '0=pending, 1=approved, 2=rejected'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `seller_details`
--

INSERT INTO `seller_details` (`seller_detail_id`, `user_id`, `store_name`, `description`, `region`, `province`, `city`, `barangay`, `street`, `gov_id_path`, `business_permit_path`, `created_at`, `updated_at`, `status`) VALUES
(1, 5, 'Techonologia', NULL, 'Cordillera Administrative Region (CAR)', 'Ifugao', 'Mayoyao', 'Guinihon', '12', 'static/uploads/seller_documents\\770661652449458.jpg', NULL, '2025-10-10 18:10:13', '2025-10-10 18:10:13', 0),
(2, 7, 'PATheTECH', NULL, 'Region I (Ilocos Region)', 'Pangasinan', 'Bugallon', 'Magtaking', '12', 'static/uploads/seller_documents\\452817055855753.JPG', 'static/uploads/seller_documents\\603101768859766.pdf', '2025-10-12 06:38:23', '2025-10-12 06:38:23', 0),
(3, 10, 'TechHub PH', NULL, 'Region IV-A (CALABARZON)', 'Laguna', 'Nagcarlan', 'Labangan', 'awdasd', 'static/uploads/seller_documents\\377705370899734.jpg', 'static/uploads/seller_documents\\609123171640162.jpg', '2025-10-19 12:13:56', '2025-10-19 12:13:56', 0),
(4, 12, 'Lloyd Store', NULL, 'Region XII (SOCCSKSARGEN)', 'Cotabato City', 'Cotabato City', 'Poblacion VII', 'Brgy.', 'static/uploads/seller_documents\\665100862423891.jpg', 'static/uploads/seller_documents\\146813614756320.jpg', '2025-10-21 02:39:35', '2025-10-21 02:39:35', 0),
(5, 14, 'qweqwe', NULL, 'Region II (Cagayan Valley)', 'Isabela', 'Benito Soliven', 'Balliao', 'qwe', 'static/uploads/seller_documents\\676887450916208.jpg', 'static/uploads/seller_documents\\393220925025124.jpg', '2025-10-21 06:14:05', '2025-10-21 06:14:05', 0),
(6, 16, 'qwe', NULL, 'Region II (Cagayan Valley)', 'Cagayan', 'Enrile', 'Liwan Norte', 'qwe', 'static/uploads/seller_documents\\262530876034798.jpg', 'static/uploads/seller_documents\\752463259528736.jpg', '2025-10-21 06:15:54', '2025-10-21 06:15:54', 0),
(7, 19, '123', NULL, 'National Capital Region (NCR)', 'Ncr, Fourth District', 'Pasay City', 'Barangay 112', 'qwe', 'static/uploads/seller_documents\\303962223639699.jpg', 'static/uploads/seller_documents\\899347496867168.jpg', '2025-10-22 16:38:15', '2025-10-22 16:38:15', 0),
(8, 23, 'Techonologia', NULL, 'Region XII (SOCCSKSARGEN)', 'Cotabato City', 'Cotabato City', 'Poblacion V', 'N/A', 'static/uploads/seller_documents\\305843389661724.jpg', 'static/uploads/seller_documents\\648361036578343.png', '2025-10-29 04:15:36', '2025-10-29 04:15:36', 0);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `role_id` int(10) DEFAULT 2,
  `firstname` varchar(255) DEFAULT NULL,
  `lastname` varchar(255) DEFAULT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` int(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `role_id`, `firstname`, `lastname`, `email`, `password`, `phone`, `created_at`, `updated_at`, `status`) VALUES
(1, 2, 'Lawrence', 'Celis', 'serisuaruse@gmail.com', '96fe0b44f128aa191ed0e7fd7af9f8f37541f96098f9e242f3f042aee465c6c8', '09876543211', '2025-10-10 14:40:42', '2025-10-10 22:40:42', 1),
(2, 2, 'Risu', 'Ame', 'oyencelis@gmail.com', '96fe0b44f128aa191ed0e7fd7af9f8f37541f96098f9e242f3f042aee465c6c8', '09876543212', '2025-10-10 14:45:45', '2025-10-10 22:45:45', 1),
(3, 2, 'Risu', 'Ame', 'potanginanoellenanaman@gmail.com', '96fe0b44f128aa191ed0e7fd7af9f8f37541f96098f9e242f3f042aee465c6c8', '09876543213', '2025-10-10 15:13:39', '2025-10-10 23:13:39', 1),
(4, 2, 'Xarco', 'Batumbakal', 'resu0510@gmail.com', '96fe0b44f128aa191ed0e7fd7af9f8f37541f96098f9e242f3f042aee465c6c8', '09876543214', '2025-10-10 17:00:16', '2025-10-11 01:00:16', 1),
(5, 3, 'Arce', 'LC', 'arcelc@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', '09876543215', '2025-10-10 18:10:13', '2025-10-23 00:13:59', 1),
(6, 4, 'Arce', 'LC', 'ventre@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', '09876543217', '2025-10-12 06:25:02', '2025-10-22 03:06:20', 2),
(7, 3, 'Lawrence', 'Celis', 'asdfghj@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', '09876543218', '2025-10-12 06:38:23', '2025-10-23 00:10:06', 1),
(8, 1, 'Admin', 'Risu', 'admin@gmail.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', '09876543217', '2025-10-12 14:03:40', '2025-10-12 22:14:28', 1),
(9, 2, 'Juan', 'Dela Cruz', 'your@gmail.com', '9ab41da41b65eaea50b7323660b760b93bda7fe3aff8a6f8d54bb998b0342c85', '09123423442', '2025-10-19 12:10:07', '2025-10-19 20:10:07', 1),
(10, 3, 'Juan', 'Dela Cruz', 'your123@gmail.com', '9ab41da41b65eaea50b7323660b760b93bda7fe3aff8a6f8d54bb998b0342c85', '+639123423442', '2025-10-19 12:13:56', '2025-10-23 00:35:38', 3),
(11, 4, 'Juan', 'Dela Cruz', 'your112323@gmail.com', '932f3c1b56257ce8539ac269d7aab42550dacf8818d075f0bdf1990562aae3ef', '+639123423442', '2025-10-19 12:16:14', '2025-10-22 03:06:20', 2),
(12, 3, 'John', 'Lloyd J. Bustria', 'lloydbustria9@gmail.com', '81954b0388567d0ef7ab6185715f02967dcb6ad8bba755b43207f7c2da065649', '09692991918', '2025-10-21 02:39:35', '2025-10-22 03:07:08', 1),
(13, 2, 'Lloyd', 'Bustria', 'your123123123@gmail.com', '81954b0388567d0ef7ab6185715f02967dcb6ad8bba755b43207f7c2da065649', '09123423442', '2025-10-21 02:45:40', '2025-10-21 10:45:40', 1),
(14, 3, 'qwe', '', 'qweqweqweqwe@gmail.com', '0d1ea4c256cd50a2a7ccbfd22b3d9959f6fd30bd840b9ff3c7c65ee4e21df06d', '+6392938472726', '2025-10-21 06:14:05', '2025-10-23 00:35:34', 1),
(15, 4, 'John', 'Lloyd J. Bustria', 'lloydbustqweqweqria9@gmail.com', '0d1ea4c256cd50a2a7ccbfd22b3d9959f6fd30bd840b9ff3c7c65ee4e21df06d', '+639692991918', '2025-10-21 06:14:32', '2025-10-22 03:06:20', 2),
(16, 3, 'qwe', '', 'qweqwe@gmail.com', '0d1ea4c256cd50a2a7ccbfd22b3d9959f6fd30bd840b9ff3c7c65ee4e21df06d', '+6392938472726', '2025-10-21 06:15:54', '2025-10-23 00:32:42', 1),
(17, 2, 'Lloyd', 'Bustria', 'lloyd@gmail.com', '81954b0388567d0ef7ab6185715f02967dcb6ad8bba755b43207f7c2da065649', '09692991918', '2025-10-21 12:55:11', '2025-11-13 20:58:03', 2),
(18, 4, 'Lloyd', '', 'leloyd@gmail.com', '81954b0388567d0ef7ab6185715f02967dcb6ad8bba755b43207f7c2da065649', '092939872939', '2025-10-21 14:08:56', '2025-10-22 03:06:52', 1),
(19, 3, 'wert', '', 'wer@gmail.com', '81954b0388567d0ef7ab6185715f02967dcb6ad8bba755b43207f7c2da065649', '0929983745674', '2025-10-22 16:38:15', '2025-10-23 00:38:15', 2),
(20, 4, 'qwe', '', 'qweasd@gmail.com', '81954b0388567d0ef7ab6185715f02967dcb6ad8bba755b43207f7c2da065649', '09592882817', '2025-10-22 16:39:00', '2025-10-23 00:39:00', 2),
(21, 2, 'qwe', 'qwe', 'qwesdafa@gmail.com', '81954b0388567d0ef7ab6185715f02967dcb6ad8bba755b43207f7c2da065649', '09692991918', '2025-10-22 16:39:23', '2025-10-23 00:39:23', 1),
(22, 4, 'John', 'Kaith', 'pogese@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', '09876543218', '2025-10-25 15:32:36', '2025-10-25 23:32:36', 2),
(23, 3, 'Lawrence', 'Celis', 'lc@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', '09876543218', '2025-10-29 04:15:36', '2025-10-29 12:15:36', 2);

--
-- Triggers `users`
--
DELIMITER $$
CREATE TRIGGER `set_default_status` BEFORE INSERT ON `users` FOR EACH ROW BEGIN
    IF NEW.role_id = 2 THEN
        SET NEW.status = 1; -- Buyer = Active
    ELSEIF NEW.role_id = 3 OR NEW.role_id = 4 THEN
        SET NEW.status = 2; -- Seller or Rider = Pending
    ELSE
        SET NEW.status = 1; -- Admin or any other role = Active
    END IF;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`);

--
-- Indexes for table `delivery_partners`
--
ALTER TABLE `delivery_partners`
  ADD PRIMARY KEY (`partner_id`),
  ADD UNIQUE KEY `uniq_partner_email` (`email`),
  ADD KEY `delivery_partners_user_id` (`user_id`);

--
-- Indexes for table `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD KEY `FK_products_category` (`category_id`),
  ADD KEY `FK_products_user` (`user_id`);

--
-- Indexes for table `product_attachments`
--
ALTER TABLE `product_attachments`
  ADD PRIMARY KEY (`product_attachment_id`),
  ADD KEY `FK_product_attachments` (`product_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`role_id`);

--
-- Indexes for table `seller_details`
--
ALTER TABLE `seller_details`
  ADD PRIMARY KEY (`seller_detail_id`),
  ADD KEY `seller_details_user_id` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `uniq_users_email` (`email`),
  ADD KEY `FK_users` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `delivery_partners`
--
ALTER TABLE `delivery_partners`
  MODIFY `partner_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `product_attachments`
--
ALTER TABLE `product_attachments`
  MODIFY `product_attachment_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `role_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `seller_details`
--
ALTER TABLE `seller_details`
  MODIFY `seller_detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `delivery_partners`
--
ALTER TABLE `delivery_partners`
  ADD CONSTRAINT `delivery_partners_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `FK_products_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`),
  ADD CONSTRAINT `FK_products_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `product_attachments`
--
ALTER TABLE `product_attachments`
  ADD CONSTRAINT `FK_product_attachments` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Constraints for table `seller_details`
--
ALTER TABLE `seller_details`
  ADD CONSTRAINT `seller_details_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `FK_users` FOREIGN KEY (`role_id`) REFERENCES `roles` (`role_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
