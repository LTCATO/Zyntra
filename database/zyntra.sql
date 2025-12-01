-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 01, 2025 at 04:23 PM
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
-- Table structure for table `addresses`
--

CREATE TABLE `addresses` (
  `address_id` int(11) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `floor_unit_number` varchar(50) DEFAULT NULL,
  `region` varchar(100) DEFAULT NULL,
  `province` varchar(100) DEFAULT NULL,
  `city_municipality` varchar(100) DEFAULT NULL,
  `barangay` varchar(100) DEFAULT NULL,
  `street` varchar(255) DEFAULT NULL,
  `other_notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `addresses`
--

INSERT INTO `addresses` (`address_id`, `user_id`, `floor_unit_number`, `region`, `province`, `city_municipality`, `barangay`, `street`, `other_notes`, `created_at`, `updated_at`) VALUES
(1, 26, 'N/A', '04', '0434', '043408', '043408007', 'lilian st.', 'paglagpas ng tulay', '2025-11-19 13:40:30', '2025-11-23 01:20:16'),
(2, 26, 'N/A', '04', '0434', '043408', '043408007', 'lilian st.', 'paglagpas ng tulay', '2025-11-19 13:57:01', '2025-11-23 01:20:16'),
(3, 29, '2F C', '07', '0761', '076104', '076104012', 'N/A', '', '2025-11-24 02:50:39', '2025-11-24 02:50:39'),
(4, 52, 'N/A', '17', '1751', '175110', '175110011', 'N/A', 'sa likod ng sementeryo', '2025-11-29 03:38:39', '2025-11-29 03:38:39');

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
(8, 25, 'Delivery', 'driver@gmail.com', '09692991918', 'motorcycle', 'qweqwe', 'National Capital Region (NCR)', 'City Of Manila', 'San Nicolas', 'Barangay 285', 'qwe', 'static/uploads/delivery_documents\\826498360863382.pdf', 'static/uploads/delivery_documents\\361721546715047.pdf', '2025-11-15 11:19:04', '2025-11-21 12:45:48', 1),
(9, 27, 'Aedrian Dave Anounevo', 'adi@gmail.com', '09876543213', 'motorcycle', '123456', 'Region IV-A (CALABARZON)', 'Laguna', 'City Of Santa Rosa', 'Kanluran (Pob.)', '12', 'static/uploads/delivery_documents\\789152144340050.webp', 'static/uploads/delivery_documents\\435655022415638.pdf', '2025-11-20 18:54:15', '2025-11-29 03:46:45', 1),
(10, 31, 'Lawrence Celis', 'serisuaruse@gmail.com', '09876543212', 'motorcycle', 'WEC 322', 'Region X (Northern Mindanao)', 'Bukidnon', 'San Fernando', 'Magkalungay', 'N/A', 'static/uploads/delivery_documents\\456823856940413.jpg', 'static/uploads/delivery_documents\\580315944908889.jpg', '2025-11-21 07:27:00', '2025-11-21 12:46:28', 1);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `order_id` int(10) DEFAULT NULL,
  `title` varchar(150) NOT NULL,
  `message` text NOT NULL,
  `notification_type` enum('order','system','promo') NOT NULL DEFAULT 'order',
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `read_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`notification_id`, `user_id`, `order_id`, `title`, `message`, `notification_type`, `is_read`, `read_at`, `created_at`) VALUES
(1, 5, NULL, 'New order placed', 'Xarco Batumbakal placed order ED0ih9c6fx containing 1 item(s): HUAWEI Band 10 | Smartwatch | Ultra light and Slim | Enriching workouts | Pro-Level Sleep Analysis', 'order', 1, '2025-11-24 14:37:00', '2025-11-24 02:50:59'),
(2, 24, NULL, 'New order placed', 'Xarco Batumbakal placed order EKUrD50Nz6 containing 1 item(s): Airpods', 'order', 1, '2025-11-24 11:23:14', '2025-11-24 03:00:54'),
(3, 5, NULL, 'New order placed', 'User User placed order rU4Tj8lMls (Sub-order rU4Tj8lMls-01) containing 1 item(s): HUAWEI Band 10 | Smartwatch | Ultra light and Slim | Enriching workouts | Pro-Level Sleep Analysis', 'order', 1, '2025-11-26 21:38:32', '2025-11-24 10:36:34'),
(4, 24, NULL, 'New order placed', 'User User placed order rU4Tj8lMls (Sub-order rU4Tj8lMls-02) containing 1 item(s): Airpods', 'order', 1, '2025-11-26 21:36:48', '2025-11-24 10:36:34'),
(5, 5, NULL, 'New order placed', 'User User placed order dHF9HABLTJ (Sub-order dHF9HABLTJ-01) containing 1 item(s): HUAWEI Band 10 | Smartwatch | Ultra light and Slim | Enriching workouts | Pro-Level Sleep Analysis', 'order', 1, '2025-11-26 21:38:29', '2025-11-25 03:28:13'),
(6, 24, NULL, 'New order placed', 'User User placed order dHF9HABLTJ (Sub-order dHF9HABLTJ-02) containing 1 item(s): Acer SB220Q bi 21.5 inches Full HD (1920 x 1080) IPS Ultra-Thin', 'order', 1, '2025-11-26 21:36:48', '2025-11-25 03:28:13'),
(7, 24, NULL, 'New order placed', 'User User placed order sIJc8va31v (Sub-order sIJc8va31v-01) containing 1 item(s): WD 2TB Elements Portable External Hard Drive - USB 3.0 ', 'order', 1, '2025-11-26 21:36:48', '2025-11-25 03:31:18'),
(8, 5, 10, 'New order placed', 'User User placed order uRy6D0gi1m (Sub-order uRy6D0gi1m-01) containing 1 item(s): HUAWEI Band 10 | Smartwatch | Ultra light and Slim | Enriching workouts | Pro-Level Sleep Analysis', 'order', 1, '2025-11-29 11:41:54', '2025-11-26 14:28:26'),
(9, 24, 10, 'New order placed', 'User User placed order uRy6D0gi1m (Sub-order uRy6D0gi1m-02) containing 1 item(s): Apple iPhone 17 Pro Max', 'order', 1, '2025-11-27 01:03:22', '2025-11-26 14:28:26'),
(10, 24, 11, 'New order placed', 'Czeanne  Barado placed order 5p9rgSYrk6 (Sub-order 5p9rgSYrk6-01) containing 1 item(s): Apple iPhone 17 Pro Max', 'order', 0, NULL, '2025-11-29 03:39:59');

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `order_id` int(10) NOT NULL,
  `user_id` int(10) DEFAULT NULL,
  `reference` varchar(20) DEFAULT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `shipping_fee` decimal(10,2) NOT NULL,
  `tax_amount` decimal(10,2) NOT NULL,
  `total_amount` varchar(100) DEFAULT NULL,
  `cash_type` varchar(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` int(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`order_id`, `user_id`, `reference`, `subtotal`, `shipping_fee`, `tax_amount`, `total_amount`, `cash_type`, `created_at`, `updated_at`, `status`) VALUES
(10, 26, 'uRy6D0gi1m', 82789.00, 0.00, 827.89, '83616.89', 'cod', '2025-11-26 14:28:26', '2025-11-26 22:28:26', 1),
(11, 52, '5p9rgSYrk6', 80990.00, 0.00, 809.90, '81799.90', 'cod', '2025-11-29 03:39:59', '2025-11-29 11:39:59', 1);

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `order_items_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `suborder_id` int(11) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `reference` varchar(255) NOT NULL,
  `status` int(11) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`order_items_id`, `product_id`, `user_id`, `suborder_id`, `quantity`, `reference`, `status`) VALUES
(25, 32, 26, 8, 1, 'uRy6D0gi1m', 2),
(26, 33, 26, 7, 1, 'uRy6D0gi1m', 2),
(27, 32, 52, 9, 1, '5p9rgSYrk6', 2);

-- --------------------------------------------------------

--
-- Table structure for table `order_suborders`
--

CREATE TABLE `order_suborders` (
  `suborder_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `seller_id` int(11) NOT NULL,
  `reference` varchar(255) NOT NULL,
  `status` int(11) NOT NULL DEFAULT 1,
  `subtotal` decimal(10,2) NOT NULL DEFAULT 0.00,
  `shipping_fee` decimal(10,2) NOT NULL DEFAULT 0.00,
  `tax_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `total_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `order_suborders`
--

INSERT INTO `order_suborders` (`suborder_id`, `order_id`, `seller_id`, `reference`, `status`, `subtotal`, `shipping_fee`, `tax_amount`, `total_amount`, `created_at`, `updated_at`) VALUES
(7, 10, 5, 'uRy6D0gi1m-01', 2, 1799.00, 79.00, 18.78, 1896.78, '2025-11-26 14:28:26', '2025-11-29 03:42:46'),
(8, 10, 24, 'uRy6D0gi1m-02', 2, 80990.00, 0.00, 809.90, 81799.90, '2025-11-26 14:28:26', '2025-11-29 02:40:52'),
(9, 11, 24, '5p9rgSYrk6-01', 2, 80990.00, 0.00, 809.90, 81799.90, '2025-11-29 03:39:59', '2025-11-29 03:43:32');

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` int(10) NOT NULL,
  `order_id` int(10) DEFAULT NULL,
  `payment_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `payment_amount` int(10) DEFAULT NULL,
  `status` int(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(31, 24, 3, 'Airpods', '<p>White Airpods</p>', 1999.00, 2, '2025-11-16 18:30:13', '2025-11-17 02:30:54', 1),
(32, 24, 1, 'Apple iPhone 17 Pro Max', '<h2><span style=\"color: rgb(46, 51, 70);\">Product Details</span></h2><p><br></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/80cd44831a19253c14f6eb830a1b26e4.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/1dbc9b2ef7c52352408e3c0beae31df1.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/8c42cef9c30446124509669d948b90af.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/64a001478f5cd9065fb5a6c4a71fd15e.png_2200x2200q80.png_.webp\"></span></p><p><br></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/c0b4efd0f3ce1da650422899ffbe0b1b.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/76de24d2ff93f12e9f941e846fada57c.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/73a7f1256278c34439951a3c54e0edd4.jpg_2200x2200q80.jpg_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/50e473eb89cca70d6ec3e4df0e27af3e.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/87e7620216c15f9f32b55d5731435d9f.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/c204fbe19fbbb63b1b8021103e49887d.png_2200x2200q80.png_.webp\"></span></p><p><br></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/e97527268995294d6daa6f8770901767.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/7cfba9a4754b3f581af287915427652b.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/3e24b76cee8aaed81f5c2d58e96b099e.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/b1c8997c6cfc747aa954aa432911b435.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/b050366f1a96f33b5f65c0fc9d4c35e1.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/c7f89cc62c4dbb91a9b939c21713290e.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/880aadadf89019cca70000e57f130950.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/24d2aefe15e95a43ea2d149e1beb0887.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/8ea36614a94011741a1fb958711b793e.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/da9b8f3be3ef0b12cbbb07550ae5f4d8.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/ccfb20cadbf5da035ea5d7b2fb9866af.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/21f559c2569f3eddb9b346669f16a18e.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/c4bf697f0edfb379181a997496265fcf.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/979035c76489749bef93199110f652ad.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/93c9f5bf387d6953cca1f1a08b868291.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/81feb19f29430f960f40b2e3e9b5bcec.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/a9a4f5faa4bfb4ea30bd09b4dac3bbbb.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/f127c2aa195bd036efb8fe7a8111581a.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/e8c5ecca99f756b72e7854c9e4d38bb1.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/0deaadf6fa752bec2c9fcc64756482ed.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/0c4f25ca7628b53233a9f6e781330f21.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/870d578f10702ee762ff522810eb496e.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/a520fa4c12c5be0881e52bdd6858b447.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/866fa2c461a654a3db922b009e61ee9d.png_2200x2200q80.png_.webp\"></span></p><p><br></p><h2><span style=\"background-color: rgb(255, 255, 255); color: rgb(46, 51, 70);\">Specifications of Apple iPhone 17 Pro Max</span></h2><ol><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(117, 117, 117);\">Brand</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\">Apple</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(117, 117, 117);\">SKU</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\">5260093111_PH-31227369038</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(117, 117, 117);\">Model</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\">Apple iPhone 17 Pro Max</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(117, 117, 117);\">Warranty Type</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\">International Manufacturer Warranty</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(117, 117, 117);\">Warranty</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\">1 Year</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(117, 117, 117);\">Delivery Option Instant</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\">Yes</span></li></ol><p><span style=\"background-color: rgb(255, 255, 255); color: rgb(117, 117, 117);\">What’s in the box</span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\">iPhone with iOS&nbsp;26,USB-C Charge Cable (1m),Documentation</span></p><p class=\"ql-align-center\"><br></p><p><br></p>', 80990.00, 31, '2025-11-18 15:09:27', '2025-11-18 23:09:27', 1),
(33, 5, 6, 'HUAWEI Band 10 | Smartwatch | Ultra light and Slim | Enriching workouts | Pro-Level Sleep Analysis', '<h2><span style=\"background-color: rgb(255, 255, 255); color: rgb(46, 51, 70);\">Product Details</span></h2><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/180d07baab061e3a618fa3ae56589e2a.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/59b44a898dbb3b0af01d49f560a3ca0d.jpg_2200x2200q80.jpg_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/0e8a018f295e1fd70595ade134f895e2.jpg_2200x2200q80.jpg_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/77dc90c4a06aca4096cecf94f0e869ee.jpg_2200x2200q80.jpg_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/7f9858b7418b0276a916faf7da109f20.jpg_2200x2200q80.jpg_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/9bdb2cac2a6a5d6a65fdf8d34dc1981f.jpg_2200x2200q80.jpg_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/54e821b1a2ee073fa3973d759e6b5074.jpg_2200x2200q80.jpg_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/d8e3d1b14ed28fd074b7c29be11a8c7c.jpg_2200x2200q80.jpg_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/ee8cac57021f87448f2f9a136e4d36ec.jpg_2200x2200q80.jpg_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/56b04e4fccf192c4d0ad8feae5fe7dd8.jpg_2200x2200q80.jpg_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/07238d8ff4d6429b2df00cb90cf5188e.jpg_2200x2200q80.jpg_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/17de151539a588c4de3fa9a189f99b22.jpg_2200x2200q80.jpg_.webp\"></span></p><p><br></p><h2><span style=\"background-color: rgb(255, 255, 255); color: rgb(46, 51, 70);\">Specifications of HUAWEI Band 10 | Smartwatch | Ultra light and Slim | Enriching workouts | Pro-Level Sleep Analysis</span></h2><ol><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(117, 117, 117);\">Brand</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\">HUAWEI</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(117, 117, 117);\">SKU</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\">4933455199_PH-28749283909</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(117, 117, 117);\">Activity Type</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\">health</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(117, 117, 117);\">Function</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\">Heart Rate Tracking</span></li></ol><p><br></p>', 1799.00, 45, '2025-11-19 11:10:09', '2025-11-19 19:10:09', 1),
(34, 24, 1, 'Acer SB220Q bi 21.5 inches Full HD (1920 x 1080) IPS Ultra-Thin', '<p>21. 5 inches Full HD (1920 x 1080) widescreen IPS display And Radeon free Sync technology. No compatibility for VESA Mount Refresh Rate: 75Hz - Using HDMI port Zero-frame design | ultra-thin | 4ms response time | IPS panel Aspect ratio - 16: 9. Color Supported - 16. 7 million colors. Brightness - 250 nit Tilt angle -5 degree to 15 degree. Horizontal viewing angle-178 degree. Vertical viewing angle-178 degree 75 hertz</p>', 599.00, 29, '2025-11-24 13:31:26', '2025-11-24 21:31:26', 1),
(35, 24, 2, 'WD 2TB Elements Portable External Hard Drive - USB 3.0 ', '<p>USB 3.0 and USB 2.0 Compatibility Fast data transfers Improve PC Performance High Capacity; Compatibility Formatted NTFS for Windows 10, Windows 8.1, Windows 7; Reformatting may be required for other operating systems; Compatibility may vary depending on user’s hardware configuration and operating system</p>', 64.00, 8, '2025-11-24 13:31:29', '2025-11-24 21:31:29', 1),
(36, 24, 2, 'SanDisk SSD PLUS 1TB Internal SSD - SATA III 6 Gb/s', '<p>Easy upgrade for faster boot up, shutdown, application load and response (As compared to 5400 RPM SATA 2.5” hard drive; Based on published specifications and internal benchmarking tests using PCMark vantage scores) Boosts burst write performance, making it ideal for typical PC workloads The perfect balance of performance and reliability Read/write speeds of up to 535MB/s/450MB/s (Based on internal testing; Performance may vary depending upon drive capacity, host device, OS and application.)</p>', 109.00, 13, '2025-11-24 13:31:32', '2025-11-24 21:31:32', 1),
(37, 24, 2, 'Samsung 49-Inch CHG90 144Hz Curved Gaming Monitor (LC49HG90DMNXZA) – Super Ultrawide Screen QLED ', '<p>49 INCH SUPER ULTRAWIDE 32:9 CURVED GAMING MONITOR with dual 27 inch screen side by side QUANTUM DOT (QLED) TECHNOLOGY, HDR support and factory calibration provides stunningly realistic and accurate color and contrast 144HZ HIGH REFRESH RATE and 1ms ultra fast response time work to eliminate motion blur, ghosting, and reduce input lag</p>', 999.99, 19, '2025-11-24 13:31:36', '2025-11-24 21:31:36', 1),
(38, 24, 2, 'WD 4TB Gaming Drive Works with Playstation 4 Portable External Hard Drive', '<p>Expand your PS4 gaming experience, Play anywhere Fast and easy, setup Sleek design with high capacity, 3-year manufacturer\'s limited warranty</p>', 114.00, 44, '2025-11-24 13:31:39', '2025-11-24 21:31:39', 1),
(39, 24, 2, 'Silicon Power 256GB SSD 3D NAND A55 SLC Cache Performance Boost SATA III 2.5', '<p>3D NAND flash are applied to deliver high transfer speeds Remarkable transfer speeds that enable faster bootup and improved overall system performance. The advanced SLC Cache Technology allows performance boost and longer lifespan 7mm slim design suitable for Ultrabooks and Ultra-slim notebooks. Supports TRIM command, Garbage Collection technology, RAID, and ECC (Error Checking & Correction) to provide the optimized performance and enhanced reliability.</p>', 109.00, 6, '2025-11-24 13:31:42', '2025-11-24 21:31:42', 1),
(40, 24, 3, 'Oppo K1', '<p>The Oppo K1 series offers a range of smartphones with various features and specifications. Known for their stylish design and reliable performance, the Oppo K1 series caters to diverse user preferences.</p>', 299.99, 31, '2025-11-24 13:37:46', '2025-11-24 21:37:46', 1),
(41, 24, 5, 'Selfie Stick Monopod', '<p>The Selfie Stick Monopod is a extendable and foldable device for capturing the perfect selfie or group photo. Compatible with smartphones and cameras.</p>', 12.99, 21, '2025-11-24 13:37:48', '2025-11-24 21:37:48', 1),
(42, 24, 2, 'SanDisk SSD PLUS 1TB Internal SSD - SATA III 6 Gb/s', '<p>Easy upgrade for faster boot up, shutdown, application load and response (As compared to 5400 RPM SATA 2.5” hard drive; Based on published specifications and internal benchmarking tests using PCMark vantage scores) Boosts burst write performance, making it ideal for typical PC workloads The perfect balance of performance and reliability Read/write speeds of up to 535MB/s/450MB/s (Based on internal testing; Performance may vary depending upon drive capacity, host device, OS and application.)</p>', 109.00, 26, '2025-11-24 13:37:50', '2025-11-24 21:37:50', 1),
(43, 24, 6, 'Lenovo Yoga 920', '<p>The Lenovo Yoga 920 is a 2-in-1 convertible laptop with a flexible hinge, allowing you to use it as a laptop or tablet, offering versatility and portability.</p>', 1099.99, 38, '2025-11-24 13:37:52', '2025-11-24 21:37:52', 1),
(44, 24, 2, 'Asus Zenbook Pro Dual Screen Laptop', '<p>The Asus Zenbook Pro Dual Screen Laptop is a high-performance device with dual screens, providing productivity and versatility for creative professionals.</p>', 1799.99, 12, '2025-11-24 13:37:53', '2025-11-24 21:37:53', 1),
(45, 24, 2, 'WD 2TB Elements Portable External Hard Drive - USB 3.0 ', '<p>USB 3.0 and USB 2.0 Compatibility Fast data transfers Improve PC Performance High Capacity; Compatibility Formatted NTFS for Windows 10, Windows 8.1, Windows 7; Reformatting may be required for other operating systems; Compatibility may vary depending on user’s hardware configuration and operating system</p>', 64.00, 21, '2025-11-24 13:37:55', '2025-11-24 21:37:55', 1),
(46, 24, 2, 'Vivo V9', '<p>The Vivo V9 is a smartphone known for its sleek design and emphasis on capturing high-quality selfies. It features a notch display, dual-camera setup, and a modern design.</p>', 299.99, 48, '2025-11-24 13:37:57', '2025-11-24 21:37:57', 1),
(47, 24, 1, 'iPhone 13 Pro', '<p>The iPhone 13 Pro is a cutting-edge smartphone with a powerful camera system, high-performance chip, and stunning display. It offers advanced features for users who demand top-notch technology.</p>', 1099.99, 8, '2025-11-24 13:37:58', '2025-11-24 21:37:58', 1),
(48, 24, 5, 'TV Studio Camera Pedestal', '<p>The TV Studio Camera Pedestal is a professional-grade camera support system for smooth and precise camera movements in a studio setting. Ideal for broadcast and production.</p>', 499.99, 46, '2025-11-24 13:38:00', '2025-11-24 21:38:00', 1),
(49, 24, 3, 'Realme X', '<p>The Realme X is a mid-range smartphone known for its sleek design and impressive display. It offers a good balance of performance and camera capabilities for users seeking a quality device.</p>', 299.99, 40, '2025-11-24 13:38:02', '2025-11-24 21:38:02', 1),
(50, 24, 1, 'Huawei Matebook X Pro', '<p>The Huawei Matebook X Pro is a slim and stylish laptop with a high-resolution touchscreen display, offering a premium experience for users on the go.</p>', 1399.99, 48, '2025-11-24 13:38:03', '2025-11-24 21:38:03', 1),
(51, 24, 1, 'iPhone 6', '<p>The iPhone 6 is a stylish and capable smartphone with a larger display and improved performance. It introduced new features and design elements, making it a popular choice in its time.</p>', 299.99, 15, '2025-11-24 13:38:05', '2025-11-24 21:38:05', 1),
(52, 24, 1, 'Beats Flex Wireless Earphones', '<p>The Beats Flex Wireless Earphones offer a comfortable and versatile audio experience. With magnetic earbuds and up to 12 hours of battery life, they are ideal for everyday use.</p>', 49.99, 34, '2025-11-24 13:38:07', '2025-11-24 21:38:07', 1),
(53, 24, 6, 'Amazon Echo Plus', '<p>The Amazon Echo Plus is a smart speaker with built-in Alexa voice control. It features premium sound quality and serves as a hub for controlling smart home devices.</p>', 99.99, 32, '2025-11-24 13:38:08', '2025-11-24 21:38:08', 1),
(54, 24, 1, 'iPhone 5s', '<p>The iPhone 5s is a classic smartphone known for its compact design and advanced features during its release. While it\'s an older model, it still provides a reliable user experience.</p>', 199.99, 30, '2025-11-24 13:38:10', '2025-11-24 21:38:10', 1),
(55, 24, 1, 'Apple iPhone Charger', '<p>The Apple iPhone Charger is a high-quality charger designed for fast and efficient charging of your iPhone. Ensure your device stays powered up and ready to go.</p>', 19.99, 49, '2025-11-24 13:38:12', '2025-11-24 21:38:12', 1),
(56, 24, 1, 'Samsung Galaxy S8', '<p>The Samsung Galaxy S8 is a premium smartphone with an Infinity Display, offering a stunning visual experience. It boasts advanced camera capabilities and cutting-edge technology.</p>', 499.99, 37, '2025-11-24 13:38:14', '2025-11-24 21:38:14', 1),
(57, 24, 2, 'Apple MacBook Pro 14 Inch Space Grey', '<p>The MacBook Pro 14 Inch in Space Grey is a powerful and sleek laptop, featuring Apple\'s M1 Pro chip for exceptional performance and a stunning Retina display.</p>', 1999.99, 23, '2025-11-24 13:38:15', '2025-11-24 21:38:15', 1),
(58, 24, 1, 'Oppo A57', '<p>The Oppo A57 is a mid-range smartphone known for its sleek design and capable features. It offers a balance of performance and affordability, making it a popular choice.</p>', 249.99, 33, '2025-11-24 13:38:16', '2025-11-24 21:38:16', 1),
(59, 24, 2, 'WD 4TB Gaming Drive Works with Playstation 4 Portable External Hard Drive', '<p>Expand your PS4 gaming experience, Play anywhere Fast and easy, setup Sleek design with high capacity, 3-year manufacturer\'s limited warranty</p>', 114.00, 47, '2025-11-24 13:38:19', '2025-11-24 21:38:19', 1),
(60, 24, 4, 'Apple HomePod Mini Cosmic Grey', '<p>The Apple HomePod Mini in Cosmic Grey is a compact smart speaker that delivers impressive audio and integrates seamlessly with the Apple ecosystem for a smart home experience.</p>', 99.99, 40, '2025-11-24 13:38:20', '2025-11-24 21:38:20', 1),
(61, 24, 1, 'iPhone 12 Silicone Case with MagSafe Plum', '<p>The iPhone 12 Silicone Case with MagSafe in Plum is a stylish and protective case designed for the iPhone 12. It features MagSafe technology for easy attachment of accessories.</p>', 29.99, 14, '2025-11-24 13:38:23', '2025-11-24 21:38:23', 1),
(62, 24, 4, 'Realme C35', '<p>The Realme C35 is a budget-friendly smartphone with a focus on providing essential features for everyday use. It offers a reliable performance and user-friendly experience.</p>', 149.99, 13, '2025-11-24 13:38:25', '2025-11-24 21:38:25', 1),
(63, 24, 5, 'iPad Mini 2021 Starlight', '<p>The iPad Mini 2021 in Starlight is a compact and powerful tablet from Apple. Featuring a stunning Retina display, powerful A-series chip, and a sleek design, it offers a premium tablet experience.</p>', 499.99, 39, '2025-11-24 13:38:27', '2025-11-24 21:38:27', 1),
(64, 24, 1, 'Acer SB220Q bi 21.5 inches Full HD (1920 x 1080) IPS Ultra-Thin', '<p>21. 5 inches Full HD (1920 x 1080) widescreen IPS display And Radeon free Sync technology. No compatibility for VESA Mount Refresh Rate: 75Hz - Using HDMI port Zero-frame design | ultra-thin | 4ms response time | IPS panel Aspect ratio - 16: 9. Color Supported - 16. 7 million colors. Brightness - 250 nit Tilt angle -5 degree to 15 degree. Horizontal viewing angle-178 degree. Vertical viewing angle-178 degree 75 hertz</p>', 599.00, 22, '2025-11-24 13:38:29', '2025-11-24 21:38:29', 1),
(65, 24, 6, 'Apple Watch Series 4 Gold', '<p>The Apple Watch Series 4 in Gold is a stylish and advanced smartwatch with features like heart rate monitoring, fitness tracking, and a beautiful Retina display.</p>', 349.99, 29, '2025-11-24 13:38:30', '2025-11-24 21:38:30', 1),
(66, 24, 1, 'Samsung Galaxy S10', '<p>The Samsung Galaxy S10 is a flagship device featuring a dynamic AMOLED display, versatile camera system, and powerful performance. It represents innovation and excellence in smartphone technology.</p>', 699.99, 27, '2025-11-24 13:38:32', '2025-11-24 21:38:32', 1),
(67, 24, 3, 'Apple Airpods', '<p>The Apple Airpods offer a seamless wireless audio experience. With easy pairing, high-quality sound, and Siri integration, they are perfect for on-the-go listening.</p>', 129.99, 44, '2025-11-24 13:38:33', '2025-11-24 21:38:33', 1),
(68, 24, 2, 'Silicon Power 256GB SSD 3D NAND A55 SLC Cache Performance Boost SATA III 2.5', '<p>3D NAND flash are applied to deliver high transfer speeds Remarkable transfer speeds that enable faster bootup and improved overall system performance. The advanced SLC Cache Technology allows performance boost and longer lifespan 7mm slim design suitable for Ultrabooks and Ultra-slim notebooks. Supports TRIM command, Garbage Collection technology, RAID, and ECC (Error Checking & Correction) to provide the optimized performance and enhanced reliability.</p>', 109.00, 36, '2025-11-24 13:38:35', '2025-11-24 21:38:35', 1),
(69, 24, 1, 'Apple Airpower Wireless Charger', '<p>The Apple AirPower Wireless Charger provides a convenient way to charge your compatible Apple devices wirelessly. Simply place your devices on the charging mat for effortless charging.</p>', 79.99, 39, '2025-11-24 13:38:37', '2025-11-24 21:38:37', 1),
(70, 24, 1, 'iPhone X', '<p>The iPhone X is a flagship smartphone featuring a bezel-less OLED display, facial recognition technology (Face ID), and impressive performance. It represents a milestone in iPhone design and innovation.</p>', 899.99, 38, '2025-11-24 13:38:38', '2025-11-24 21:38:38', 1),
(71, 24, 1, 'Samsung Galaxy Tab White', '<p>The Samsung Galaxy Tab in White is a sleek and versatile Android tablet. With a vibrant display, long-lasting battery, and a range of features, it offers a great user experience for various tasks.</p>', 349.99, 22, '2025-11-24 13:38:40', '2025-11-24 21:38:40', 1),
(72, 24, 2, 'Oppo F19 Pro Plus', '<p>The Oppo F19 Pro Plus is a feature-rich smartphone with a focus on camera capabilities. It boasts advanced photography features and a powerful performance for a premium user experience.</p>', 399.99, 46, '2025-11-24 13:38:41', '2025-11-24 21:38:41', 1),
(73, 24, 2, 'New DELL XPS 13 9300 Laptop', '<p>The New DELL XPS 13 9300 Laptop is a compact and powerful device, featuring a virtually borderless InfinityEdge display and high-end performance for various tasks.</p>', 1499.99, 47, '2025-11-24 13:38:43', '2025-11-24 21:38:43', 1),
(74, 24, 3, 'Apple MagSafe Battery Pack', '<p>The Apple MagSafe Battery Pack is a portable and convenient way to add extra battery life to your MagSafe-compatible iPhone. Attach it magnetically for a secure connection.</p>', 99.99, 11, '2025-11-24 13:38:45', '2025-11-24 21:38:45', 1),
(75, 24, 1, 'Samsung Galaxy Tab S8 Plus Grey', '<p>The Samsung Galaxy Tab S8 Plus in Grey is a high-performance Android tablet by Samsung. With a large AMOLED display, powerful processor, and S Pen support, it\'s ideal for productivity and entertainment.</p>', 599.99, 24, '2025-11-24 13:38:46', '2025-11-24 21:38:46', 1),
(76, 24, 4, 'Realme XT', '<p>The Realme XT is a feature-rich smartphone with a focus on camera technology. It comes equipped with advanced camera sensors, delivering high-quality photos and videos for photography enthusiasts.</p>', 349.99, 40, '2025-11-24 13:38:47', '2025-11-24 21:38:47', 1),
(77, 24, 3, 'Monopod', '<p>The Monopod is a versatile camera accessory for stable and adjustable shooting. Perfect for capturing selfies, group photos, and videos with ease.</p>', 19.99, 20, '2025-11-24 13:38:49', '2025-11-24 21:38:49', 1),
(78, 24, 1, 'Apple AirPods Max Silver', '<p>The Apple AirPods Max in Silver are premium over-ear headphones with high-fidelity audio, adaptive EQ, and active noise cancellation. Experience immersive sound in style.</p>', 549.99, 9, '2025-11-24 13:38:51', '2025-11-24 21:38:51', 1),
(79, 24, 1, 'Vivo X21', '<p>The Vivo X21 is a premium smartphone with a focus on cutting-edge technology. It features an in-display fingerprint sensor, a high-resolution display, and advanced camera capabilities.</p>', 499.99, 18, '2025-11-24 13:38:52', '2025-11-24 21:38:52', 1),
(80, 24, 3, 'Vivo S1', '<p>The Vivo S1 is a stylish and mid-range smartphone offering a blend of design and performance. It features a vibrant display, capable camera system, and reliable functionality.</p>', 249.99, 33, '2025-11-24 13:38:54', '2025-11-24 21:38:54', 1),
(81, 24, 2, 'Samsung 49-Inch CHG90 144Hz Curved Gaming Monitor (LC49HG90DMNXZA) – Super Ultrawide Screen QLED ', '<p>49 INCH SUPER ULTRAWIDE 32:9 CURVED GAMING MONITOR with dual 27 inch screen side by side QUANTUM DOT (QLED) TECHNOLOGY, HDR support and factory calibration provides stunningly realistic and accurate color and contrast 144HZ HIGH REFRESH RATE and 1ms ultra fast response time work to eliminate motion blur, ghosting, and reduce input lag</p>', 999.99, 35, '2025-11-24 13:38:56', '2025-11-24 21:38:56', 1),
(82, 24, 1, 'Selfie Lamp with iPhone', '<p>The Selfie Lamp with iPhone is a portable and adjustable LED light designed to enhance your selfies and video calls. Attach it to your iPhone for well-lit photos.</p>', 14.99, 10, '2025-11-24 13:38:58', '2025-11-24 21:38:58', 1),
(83, 24, 1, 'Samsung Galaxy S7', '<p>The Samsung Galaxy S7 is a flagship smartphone known for its sleek design and advanced features. It features a high-resolution display, powerful camera, and robust performance.</p>', 299.99, 36, '2025-11-24 13:38:59', '2025-11-24 21:38:59', 1);

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
(53, 31, 'uploads/products/e9a073ad152f4726a5f296fccc44091f.jpg', '2025-11-16 18:30:13', '2025-11-17 02:30:13', 1),
(54, 32, 'uploads/products/100d52bcd5c043d5a2bdb444c1b923c1.webp', '2025-11-18 15:09:27', '2025-11-18 23:09:27', 1),
(55, 33, 'uploads/products/73f9622d96a54d1c8f4a9bad2000368f.webp', '2025-11-19 11:10:09', '2025-11-19 19:10:09', 1),
(56, 33, 'uploads/products/0e4d2beee2764729b5ab353392fc4660.webp', '2025-11-19 11:10:09', '2025-11-19 19:10:09', 1),
(57, 34, 'uploads/products/c973f485dd4e494f873c95015e98bf85.jpg', '2025-11-24 13:31:26', '2025-11-24 21:31:26', 1),
(58, 35, 'uploads/products/e606c0235f5846d5b4cd5afae48467e5.jpg', '2025-11-24 13:31:29', '2025-11-24 21:31:29', 1),
(59, 36, 'uploads/products/4a9cb82058094bc88a43685f1d568e68.jpg', '2025-11-24 13:31:32', '2025-11-24 21:31:32', 1),
(60, 37, 'uploads/products/f82693fa2b1c45f98ce370c081008f15.jpg', '2025-11-24 13:31:36', '2025-11-24 21:31:36', 1),
(61, 38, 'uploads/products/f3d831340df54cc4bf9e0606d35e0184.jpg', '2025-11-24 13:31:39', '2025-11-24 21:31:39', 1),
(62, 39, 'uploads/products/a0e03fc16f9d47e8b8e5572f8f84354a.jpg', '2025-11-24 13:31:42', '2025-11-24 21:31:42', 1),
(63, 40, 'uploads/products/f642aecf5f3249f2aae7ca0d54e5b52f.jpg', '2025-11-24 13:37:46', '2025-11-24 21:37:46', 1),
(64, 41, 'uploads/products/a950c86145de4443917ec75aeefa8336.jpg', '2025-11-24 13:37:48', '2025-11-24 21:37:48', 1),
(65, 42, 'uploads/products/3e76a4dc58884556ac539eed00836df4.jpg', '2025-11-24 13:37:50', '2025-11-24 21:37:50', 1),
(66, 43, 'uploads/products/e306e85f9bec4ed7b69e2521adc3705d.jpg', '2025-11-24 13:37:52', '2025-11-24 21:37:52', 1),
(67, 44, 'uploads/products/9ec517842694450fa1f232b4dd02b96f.jpg', '2025-11-24 13:37:53', '2025-11-24 21:37:53', 1),
(68, 45, 'uploads/products/b9c71a6491894f228589d64819ed4867.jpg', '2025-11-24 13:37:55', '2025-11-24 21:37:55', 1),
(69, 46, 'uploads/products/626f8dd565664aed95cecbc617aedd04.jpg', '2025-11-24 13:37:57', '2025-11-24 21:37:57', 1),
(70, 47, 'uploads/products/1b3337ad4c5340d1b0fa085740d069d1.jpg', '2025-11-24 13:37:58', '2025-11-24 21:37:58', 1),
(71, 48, 'uploads/products/5500228f52144eba8a6d4b231f7a4c0a.jpg', '2025-11-24 13:38:00', '2025-11-24 21:38:00', 1),
(72, 49, 'uploads/products/69e1938a4fd547d19b1f6af1a4089313.jpg', '2025-11-24 13:38:02', '2025-11-24 21:38:02', 1),
(73, 50, 'uploads/products/f2174f4dc3054642aec97fb3958a04fa.jpg', '2025-11-24 13:38:03', '2025-11-24 21:38:03', 1),
(74, 51, 'uploads/products/2c753f12c90a44d98962a48c2a9fdee0.jpg', '2025-11-24 13:38:05', '2025-11-24 21:38:05', 1),
(75, 52, 'uploads/products/76894abd62124c1ba74cff8ebe89460e.jpg', '2025-11-24 13:38:07', '2025-11-24 21:38:07', 1),
(76, 53, 'uploads/products/8dab46ee9d9044918969478c454b691b.jpg', '2025-11-24 13:38:08', '2025-11-24 21:38:08', 1),
(77, 54, 'uploads/products/5b459799f83347f5ab063644ecdf880d.jpg', '2025-11-24 13:38:10', '2025-11-24 21:38:10', 1),
(78, 55, 'uploads/products/3ac9f89ba91f45a8af3ca69ba814ba57.jpg', '2025-11-24 13:38:12', '2025-11-24 21:38:12', 1),
(79, 56, 'uploads/products/de7ae09de7994d4b800082d3b2b3333c.jpg', '2025-11-24 13:38:14', '2025-11-24 21:38:14', 1),
(80, 57, 'uploads/products/c697ebdedd68449ba2b4178c2569854e.jpg', '2025-11-24 13:38:15', '2025-11-24 21:38:15', 1),
(81, 58, 'uploads/products/8e4cae9b2f4540409ee2f2bb150f9a5d.jpg', '2025-11-24 13:38:16', '2025-11-24 21:38:16', 1),
(82, 59, 'uploads/products/ae24ef06e3ec4a4aa4d963f23f16ca15.jpg', '2025-11-24 13:38:19', '2025-11-24 21:38:19', 1),
(83, 60, 'uploads/products/26a9056d046a4803b91c8defc52fe11e.jpg', '2025-11-24 13:38:20', '2025-11-24 21:38:20', 1),
(84, 61, 'uploads/products/a59c054cf83d4330a20e96373402a1da.jpg', '2025-11-24 13:38:23', '2025-11-24 21:38:23', 1),
(85, 62, 'uploads/products/66e663a9ab4043ea80e6cce6c36c4c5f.jpg', '2025-11-24 13:38:25', '2025-11-24 21:38:25', 1),
(86, 63, 'uploads/products/0f021630023940529d433d5c3ce809e3.jpg', '2025-11-24 13:38:27', '2025-11-24 21:38:27', 1),
(87, 64, 'uploads/products/2ebc8f877b5243c29cb0d75306895ae3.jpg', '2025-11-24 13:38:29', '2025-11-24 21:38:29', 1),
(88, 65, 'uploads/products/2292fd5affb4459ea94d4b831843de17.jpg', '2025-11-24 13:38:30', '2025-11-24 21:38:30', 1),
(89, 66, 'uploads/products/c65edea507e548ccb398551f3e7b2fd1.jpg', '2025-11-24 13:38:32', '2025-11-24 21:38:32', 1),
(90, 67, 'uploads/products/b8a39085881849c99219b7594ef076f8.jpg', '2025-11-24 13:38:33', '2025-11-24 21:38:33', 1),
(91, 68, 'uploads/products/62400d3dea804511ae7225a3eebfe416.jpg', '2025-11-24 13:38:35', '2025-11-24 21:38:35', 1),
(92, 69, 'uploads/products/29d4a90371da46b99b6960f06eee2510.jpg', '2025-11-24 13:38:37', '2025-11-24 21:38:37', 1),
(93, 70, 'uploads/products/e147c2c23c4a40b2b452fe467e968c06.jpg', '2025-11-24 13:38:38', '2025-11-24 21:38:38', 1),
(94, 71, 'uploads/products/c25764a287a0466ead30324d302360bd.jpg', '2025-11-24 13:38:40', '2025-11-24 21:38:40', 1),
(95, 72, 'uploads/products/11a197d6ad36458d8e2824ac3138c508.jpg', '2025-11-24 13:38:41', '2025-11-24 21:38:41', 1),
(96, 73, 'uploads/products/bc6974708d8b4b8abb4633db30d1d6a4.jpg', '2025-11-24 13:38:43', '2025-11-24 21:38:43', 1),
(97, 74, 'uploads/products/20091e710cf44d33bd5fe914c9b7ca8d.jpg', '2025-11-24 13:38:45', '2025-11-24 21:38:45', 1),
(98, 75, 'uploads/products/9fb8661e663845a6a22091eda6bc147f.jpg', '2025-11-24 13:38:46', '2025-11-24 21:38:46', 1),
(99, 76, 'uploads/products/95342b3cc81246768f5d09c7f2ea2198.jpg', '2025-11-24 13:38:47', '2025-11-24 21:38:47', 1),
(100, 77, 'uploads/products/7180da0ec09a421e8641fba9697f47a0.jpg', '2025-11-24 13:38:49', '2025-11-24 21:38:49', 1),
(101, 78, 'uploads/products/1b3dcf2f078d49568432f62ba8720f1e.jpg', '2025-11-24 13:38:51', '2025-11-24 21:38:51', 1),
(102, 79, 'uploads/products/e2ead3c9a7514f3cbf6e7feab1d32f41.jpg', '2025-11-24 13:38:52', '2025-11-24 21:38:52', 1),
(103, 80, 'uploads/products/f9025a77a2184551a498d9765e449a66.jpg', '2025-11-24 13:38:54', '2025-11-24 21:38:54', 1),
(104, 81, 'uploads/products/73fe6780a6ab46699bb55210074c64f5.jpg', '2025-11-24 13:38:56', '2025-11-24 21:38:56', 1),
(105, 82, 'uploads/products/76baf06ff1c946dcb98f76b535ae74b8.jpg', '2025-11-24 13:38:58', '2025-11-24 21:38:58', 1),
(106, 83, 'uploads/products/5bd3dec9add4454eb63bb9b36f360136.jpg', '2025-11-24 13:38:59', '2025-11-24 21:38:59', 1);

-- --------------------------------------------------------

--
-- Table structure for table `reviews`
--

CREATE TABLE `reviews` (
  `review_id` int(11) NOT NULL,
  `order_id` int(10) NOT NULL,
  `product_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `rating` tinyint(1) NOT NULL CHECK (`rating` between 1 and 5),
  `comment` text DEFAULT NULL,
  `status` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
(1, 5, 'Techonologia', NULL, 'Cordillera Administrative Region (CAR)', 'Ifugao', 'Mayoyao', 'Guinihon', '12', 'static/uploads/seller_documents\\770661652449458.jpg', NULL, '2025-10-10 18:10:13', '2025-11-14 09:55:44', 1),
(9, 24, 'Seller', 'imissher', 'Region XII (SOCCSKSARGEN)', 'Cotabato (North Cotabato)', 'Pigkawayan', 'Lower Pangangkalan', 'qwe', 'static/uploads/seller_documents\\465302976581719.pdf', 'static/uploads/seller_documents\\612746791708541.pdf', '2025-11-15 11:18:25', '2025-11-29 03:47:04', 2),
(10, 28, 'TiTECH', NULL, 'Region XI (Davao Region)', 'Davao Del Sur', 'Santa Cruz', 'Tibolo', 'N/A', 'static/uploads/seller_documents\\914265887858780.jpg', 'static/uploads/seller_documents\\769676331233912.jpg', '2025-11-21 06:02:49', '2025-11-21 06:33:32', 1),
(11, 32, 'myTech', NULL, 'Region VI (Western Visayas)', 'Capiz', 'Pontevedra', 'Binuntucan', '12', 'static/uploads/seller_documents\\509090198778154.png', NULL, '2025-11-21 07:58:55', '2025-11-21 10:50:21', 1),
(12, 33, 'iTech', 'ble ble ble', 'Region II (Cagayan Valley)', 'Quirino', 'Diffun', 'Campamento', 'N/A', 'static/uploads/seller_documents\\670659047964883.webp', NULL, '2025-11-23 15:18:13', '2025-11-23 15:18:13', 0);

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
  `email_verified` tinyint(1) DEFAULT 0,
  `email_verified_at` datetime DEFAULT NULL,
  `email_code_hash` varchar(255) DEFAULT NULL,
  `email_code_expires_at` datetime DEFAULT NULL,
  `email_code_attempts` tinyint(4) DEFAULT 0,
  `email_code_last_sent_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` int(1) DEFAULT 1,
  `otp_last_sent_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `role_id`, `firstname`, `lastname`, `email`, `password`, `phone`, `email_verified`, `email_verified_at`, `email_code_hash`, `email_code_expires_at`, `email_code_attempts`, `email_code_last_sent_at`, `created_at`, `updated_at`, `status`, `otp_last_sent_at`) VALUES
(5, 3, 'Arce', 'LC', 'arcelc@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', '09876543215', 1, NULL, NULL, NULL, 0, NULL, '2025-10-10 18:10:13', '2025-11-29 11:40:52', 1, NULL),
(8, 1, 'Admin', 'Risu', 'admin@gmail.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', '09876543217', 1, NULL, NULL, NULL, 0, NULL, '2025-10-12 14:03:40', '2025-11-29 01:11:28', 1, NULL),
(24, 3, 'Seller', '', 'Seller@gmail.com', '81954b0388567d0ef7ab6185715f02967dcb6ad8bba755b43207f7c2da065649', '09692991918', 1, NULL, NULL, NULL, 0, NULL, '2025-11-15 11:18:25', '2025-11-29 11:47:04', 2, NULL),
(25, 4, 'Delivery', '', 'driver@gmail.com', '81954b0388567d0ef7ab6185715f02967dcb6ad8bba755b43207f7c2da065649', '09692991918', 1, NULL, NULL, NULL, 0, NULL, '2025-11-15 11:19:04', '2025-11-29 10:39:58', 1, NULL),
(26, 2, 'User', 'User', 'User@gmail.com', '81954b0388567d0ef7ab6185715f02967dcb6ad8bba755b43207f7c2da065649', '09692991918', 1, NULL, NULL, NULL, 0, NULL, '2025-11-16 16:45:05', '2025-11-29 10:40:10', 1, NULL),
(27, 4, 'Aedrian', 'Dave Anounevo', 'adi@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', '09876543213', 0, NULL, NULL, NULL, 0, NULL, '2025-11-20 18:54:15', '2025-11-29 11:46:45', 1, NULL),
(28, 3, 'Aaron', 'Karl De La Cruz', 'aron@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', '098765432123', 0, NULL, NULL, NULL, 0, NULL, '2025-11-21 06:02:49', '2025-11-21 14:33:32', 1, NULL),
(29, 2, 'Xarco', 'Batumbakal', 'xarco@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', '09876543215', 0, NULL, NULL, NULL, 0, NULL, '2025-11-21 06:04:38', '2025-11-21 14:04:38', 1, NULL),
(31, 4, 'Lawrence', 'Celis', 'serisuaruse@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', '09876543212', 0, NULL, NULL, NULL, 0, NULL, '2025-11-21 07:27:00', '2025-11-21 20:46:28', 1, NULL),
(32, 3, 'Cedrick', 'Gayoso', 'sedo@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', '09876543218', 0, NULL, NULL, NULL, 0, NULL, '2025-11-21 07:58:55', '2025-11-21 18:50:21', 1, NULL),
(33, 3, 'Arce', 'LC', '123456@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', '09876543212', 0, NULL, NULL, NULL, 0, NULL, '2025-11-23 15:18:13', '2025-11-23 23:18:13', 2, NULL),
(35, 2, 'Dennrick', 'Agustin', 'denn@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', '09876543213', 0, NULL, NULL, NULL, 0, NULL, '2025-11-24 15:11:02', '2025-11-24 23:11:02', 1, NULL),
(51, 2, 'Lawrence', 'Ame', 'oyencelis@gmail.com', '15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225', '09641334934', 1, '2025-11-28 20:03:20', NULL, NULL, 0, NULL, '2025-11-28 20:02:47', '2025-11-29 04:03:20', 1, NULL),
(52, 2, 'Czeanne ', 'Barado', 'cznn.parado@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', '09876543211', 1, '2025-11-29 03:35:05', NULL, NULL, 0, NULL, '2025-11-29 03:34:41', '2025-11-29 11:35:05', 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `wishlists`
--

CREATE TABLE `wishlists` (
  `wishlist_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `wishlists`
--

-- --------------------------------------------------------

--
-- Table structure for table `conversations`
--

CREATE TABLE `conversations` (
  `conversation_id` int(11) NOT NULL,
  `buyer_id` int(11) NOT NULL,
  `seller_id` int(11) NOT NULL,
  `order_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `conversations`
--

-- --------------------------------------------------------

--
-- Table structure for table `conversation_messages`
--

CREATE TABLE `conversation_messages` (
  `message_id` int(11) NOT NULL,
  `conversation_id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `message_text` text NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `read_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `conversation_messages`
--

--
-- Indexes for dumped tables
--

--
-- Indexes for table `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`address_id`),
  ADD KEY `user_id` (`user_id`);

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
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `notifications_user_id` (`user_id`),
  ADD KEY `notifications_order_id` (`order_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`order_items_id`),
  ADD KEY `product_id` (`product_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `suborder_id` (`suborder_id`),
  ADD KEY `idx_order_items_wishlist` (`user_id`);

--
-- Indexes for table `order_suborders`
--
ALTER TABLE `order_suborders`
  ADD PRIMARY KEY (`suborder_id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `seller_id` (`seller_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `order_id` (`order_id`);

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
-- Indexes for table `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`review_id`),
  ADD KEY `reviews_order_id` (`order_id`),
  ADD KEY `reviews_product_id` (`product_id`),
  ADD KEY `reviews_user_id` (`user_id`);

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
-- Indexes for table `wishlists`
--
ALTER TABLE `wishlists`
  ADD PRIMARY KEY (`wishlist_id`),
  ADD UNIQUE KEY `uq_user_product` (`user_id`,`product_id`),
  ADD KEY `idx_wishlists_user` (`user_id`),
  ADD KEY `idx_wishlists_product` (`product_id`);

--
-- Indexes for table `conversations`
--

ALTER TABLE `conversations`
  ADD PRIMARY KEY (`conversation_id`),
  ADD UNIQUE KEY `uq_conversation_pair` (`buyer_id`,`seller_id`),
  ADD KEY `idx_conversations_buyer` (`buyer_id`),
  ADD KEY `idx_conversations_seller` (`seller_id`),
  ADD KEY `idx_conversations_order` (`order_id`);

--
-- Indexes for table `conversation_messages`
--

ALTER TABLE `conversation_messages`
  ADD PRIMARY KEY (`message_id`),
  ADD KEY `idx_conv_messages_conversation` (`conversation_id`),
  ADD KEY `idx_conv_messages_sender` (`sender_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `address_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `delivery_partners`
--
ALTER TABLE `delivery_partners`
  MODIFY `partner_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `order_items_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT for table `order_suborders`
--
ALTER TABLE `order_suborders`
  MODIFY `suborder_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

--
-- AUTO_INCREMENT for table `product_attachments`
--
ALTER TABLE `product_attachments`
  MODIFY `product_attachment_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=107;

--
-- AUTO_INCREMENT for table `reviews`
--
ALTER TABLE `reviews`
  MODIFY `review_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `role_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `seller_details`
--
ALTER TABLE `seller_details`
  MODIFY `seller_detail_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `wishlists`
--
ALTER TABLE `wishlists`
  MODIFY `wishlist_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `conversations`
--
ALTER TABLE `conversations`
  MODIFY `conversation_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `conversation_messages`
--
ALTER TABLE `conversation_messages`
  MODIFY `message_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `addresses`
--
ALTER TABLE `addresses`
  ADD CONSTRAINT `addresses_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `delivery_partners`
--
ALTER TABLE `delivery_partners`
  ADD CONSTRAINT `delivery_partners_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_order_fk` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE SET NULL,
  ADD CONSTRAINT `notifications_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `payments`
--
ALTER TABLE `payments`
  ADD CONSTRAINT `payments_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`);

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
-- Constraints for table `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_order_fk` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_product_fk` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_user_fk` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

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

--
-- Constraints for table `wishlists`
--
ALTER TABLE `wishlists`
  ADD CONSTRAINT `fk_wishlists_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_wishlists_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Constraints for table `conversations`
--

ALTER TABLE `conversations`
  ADD CONSTRAINT `fk_conversations_buyer` FOREIGN KEY (`buyer_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_conversations_seller` FOREIGN KEY (`seller_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_conversations_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE SET NULL;

--
-- Constraints for table `conversation_messages`
--

ALTER TABLE `conversation_messages`
  ADD CONSTRAINT `fk_conv_messages_conversation` FOREIGN KEY (`conversation_id`) REFERENCES `conversations` (`conversation_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_conv_messages_sender` FOREIGN KEY (`sender_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
