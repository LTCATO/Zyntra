-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 24, 2025 at 12:30 PM
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
(3, 29, '2F C', '07', '0761', '076104', '076104012', 'N/A', '', '2025-11-24 02:50:39', '2025-11-24 02:50:39');

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
(9, 27, 'Aedrian Dave Anounevo', 'adi@gmail.com', '09876543213', 'motorcycle', '123456', 'Region IV-A (CALABARZON)', 'Laguna', 'City Of Santa Rosa', 'Kanluran (Pob.)', '12', 'static/uploads/delivery_documents\\789152144340050.webp', 'static/uploads/delivery_documents\\435655022415638.pdf', '2025-11-20 18:54:15', '2025-11-20 18:54:15', 0),
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
(1, 5, 3, 'New order placed', 'Xarco Batumbakal placed order ED0ih9c6fx containing 1 item(s): HUAWEI Band 10 | Smartwatch | Ultra light and Slim | Enriching workouts | Pro-Level Sleep Analysis', 'order', 1, '2025-11-24 14:37:00', '2025-11-24 02:50:59'),
(2, 24, 4, 'New order placed', 'Xarco Batumbakal placed order EKUrD50Nz6 containing 1 item(s): Airpods', 'order', 1, '2025-11-24 11:23:14', '2025-11-24 03:00:54'),
(3, 5, 7, 'New order placed', 'User User placed order rU4Tj8lMls (Sub-order rU4Tj8lMls-01) containing 1 item(s): HUAWEI Band 10 | Smartwatch | Ultra light and Slim | Enriching workouts | Pro-Level Sleep Analysis', 'order', 0, NULL, '2025-11-24 10:36:34'),
(4, 24, 7, 'New order placed', 'User User placed order rU4Tj8lMls (Sub-order rU4Tj8lMls-02) containing 1 item(s): Airpods', 'order', 0, NULL, '2025-11-24 10:36:34');

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
(1, 26, 'ZkmzOyHemD', 1799.00, 79.00, 18.78, '1896.78', 'cod', '2025-11-19 16:43:34', '2025-11-20 12:06:36', 1),
(2, 26, 'zgWtKcTkg8', 82989.00, 0.00, 829.89, '83818.89', 'cod', '2025-11-20 04:07:17', '2025-11-20 12:07:17', 1),
(3, 29, 'ED0ih9c6fx', 1799.00, 79.00, 18.78, '1896.78', 'cod', '2025-11-24 02:50:59', '2025-11-24 10:50:59', 1),
(4, 29, 'EKUrD50Nz6', 1999.00, 79.00, 20.78, '2098.78', 'cod', '2025-11-24 03:00:54', '2025-11-24 11:00:54', 1),
(5, 26, 'cXZzDIpKC3', 5597.00, 0.00, 55.97, '5652.97', 'cod', '2025-11-24 10:31:29', '2025-11-24 18:31:29', 1),
(6, 26, 'EHtkkZdukO', 7396.00, 0.00, 73.96, '7469.96', 'cod', '2025-11-24 10:32:27', '2025-11-24 18:32:27', 1),
(7, 26, 'rU4Tj8lMls', 7396.00, 0.00, 73.96, '7469.96', 'cod', '2025-11-24 10:36:34', '2025-11-24 18:36:34', 1);

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
(11, 33, 26, 2, 3, 'rU4Tj8lMls', 2),
(13, 31, 26, 3, 1, 'rU4Tj8lMls', 2),
(15, 33, 29, NULL, 1, 'ED0ih9c6fx', 1);

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
(2, 7, 5, 'rU4Tj8lMls-01', 2, 5397.00, 0.00, 53.97, 5450.97, '2025-11-24 10:36:34', '2025-11-24 10:36:34'),
(3, 7, 24, 'rU4Tj8lMls-02', 2, 1999.00, 79.00, 20.78, 2098.78, '2025-11-24 10:36:34', '2025-11-24 10:36:34');

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
(33, 5, 6, 'HUAWEI Band 10 | Smartwatch | Ultra light and Slim | Enriching workouts | Pro-Level Sleep Analysis', '<h2><span style=\"background-color: rgb(255, 255, 255); color: rgb(46, 51, 70);\">Product Details</span></h2><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/180d07baab061e3a618fa3ae56589e2a.png_2200x2200q80.png_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/59b44a898dbb3b0af01d49f560a3ca0d.jpg_2200x2200q80.jpg_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/0e8a018f295e1fd70595ade134f895e2.jpg_2200x2200q80.jpg_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/77dc90c4a06aca4096cecf94f0e869ee.jpg_2200x2200q80.jpg_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/7f9858b7418b0276a916faf7da109f20.jpg_2200x2200q80.jpg_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/9bdb2cac2a6a5d6a65fdf8d34dc1981f.jpg_2200x2200q80.jpg_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/54e821b1a2ee073fa3973d759e6b5074.jpg_2200x2200q80.jpg_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/d8e3d1b14ed28fd074b7c29be11a8c7c.jpg_2200x2200q80.jpg_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/ee8cac57021f87448f2f9a136e4d36ec.jpg_2200x2200q80.jpg_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/56b04e4fccf192c4d0ad8feae5fe7dd8.jpg_2200x2200q80.jpg_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/07238d8ff4d6429b2df00cb90cf5188e.jpg_2200x2200q80.jpg_.webp\"></span></p><p><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\"><img src=\"https://img.lazcdn.com/g/p/17de151539a588c4de3fa9a189f99b22.jpg_2200x2200q80.jpg_.webp\"></span></p><p><br></p><h2><span style=\"background-color: rgb(255, 255, 255); color: rgb(46, 51, 70);\">Specifications of HUAWEI Band 10 | Smartwatch | Ultra light and Slim | Enriching workouts | Pro-Level Sleep Analysis</span></h2><ol><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(117, 117, 117);\">Brand</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\">HUAWEI</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(117, 117, 117);\">SKU</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\">4933455199_PH-28749283909</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(117, 117, 117);\">Activity Type</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\">health</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"background-color: rgb(255, 255, 255); color: rgb(117, 117, 117);\">Function</span></li><li data-list=\"bullet\"><span class=\"ql-ui\" contenteditable=\"false\"></span><span style=\"color: rgb(0, 0, 0); background-color: rgb(255, 255, 255);\">Heart Rate Tracking</span></li></ol><p><br></p>', 1799.00, 45, '2025-11-19 11:10:09', '2025-11-19 19:10:09', 1);

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
(56, 33, 'uploads/products/0e4d2beee2764729b5ab353392fc4660.webp', '2025-11-19 11:10:09', '2025-11-19 19:10:09', 1);

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
(9, 24, 'Seller', 'imissher', 'Region XII (SOCCSKSARGEN)', 'Cotabato (North Cotabato)', 'Pigkawayan', 'Lower Pangangkalan', 'qwe', 'static/uploads/seller_documents\\465302976581719.pdf', 'static/uploads/seller_documents\\612746791708541.pdf', '2025-11-15 11:18:25', '2025-11-23 15:18:31', 1),
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
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `status` int(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `role_id`, `firstname`, `lastname`, `email`, `password`, `phone`, `created_at`, `updated_at`, `status`) VALUES
(5, 3, 'Arce', 'LC', 'arcelc@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', '09876543215', '2025-10-10 18:10:13', '2025-11-14 17:55:44', 1),
(8, 1, 'Admin', 'Risu', 'admin@gmail.com', '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', '09876543217', '2025-10-12 14:03:40', '2025-10-12 22:14:28', 1),
(24, 3, 'Seller', '', 'Seller@gmail.com', '81954b0388567d0ef7ab6185715f02967dcb6ad8bba755b43207f7c2da065649', '09692991918', '2025-11-15 11:18:25', '2025-11-15 19:19:56', 1),
(25, 4, 'Delivery', '', 'driver@gmail.com', '81954b0388567d0ef7ab6185715f02967dcb6ad8bba755b43207f7c2da065649', '09692991918', '2025-11-15 11:19:04', '2025-11-21 20:45:48', 1),
(26, 2, 'User', 'User', 'User@gmail.com', '81954b0388567d0ef7ab6185715f02967dcb6ad8bba755b43207f7c2da065649', '09692991918', '2025-11-16 16:45:05', '2025-11-17 00:45:05', 1),
(27, 4, 'Aedrian', 'Dave Anounevo', 'adi@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', '09876543213', '2025-11-20 18:54:15', '2025-11-21 14:54:18', 1),
(28, 3, 'Aaron', 'Karl De La Cruz', 'aron@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', '098765432123', '2025-11-21 06:02:49', '2025-11-21 14:33:32', 1),
(29, 2, 'Xarco', 'Batumbakal', 'xarco@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', '09876543215', '2025-11-21 06:04:38', '2025-11-21 14:04:38', 1),
(30, 3, 'Sam', 'Luansing', 'oyencelis@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', '09632123445', '2025-11-21 06:55:47', '2025-11-21 14:55:47', 2),
(31, 4, 'Lawrence', 'Celis', 'serisuaruse@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', '09876543212', '2025-11-21 07:27:00', '2025-11-21 20:46:28', 1),
(32, 3, 'Cedrick', 'Gayoso', 'sedo@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', '09876543218', '2025-11-21 07:58:55', '2025-11-21 18:50:21', 1),
(33, 3, 'Arce', 'LC', '123456@gmail.com', 'ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f', '09876543212', '2025-11-23 15:18:13', '2025-11-23 23:18:13', 2);

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
  ADD KEY `suborder_id` (`suborder_id`);

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
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `address_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

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
  MODIFY `notification_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `order_items_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `order_suborders`
--
ALTER TABLE `order_suborders`
  MODIFY `suborder_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(10) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

--
-- AUTO_INCREMENT for table `product_attachments`
--
ALTER TABLE `product_attachments`
  MODIFY `product_attachment_id` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=57;

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
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=34;

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
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
