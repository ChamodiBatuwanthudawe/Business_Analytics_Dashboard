-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 01, 2025 at 12:44 PM
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
-- Database: `inventory_management_system`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `AddUser` (IN `p_username` VARCHAR(100), IN `p_password` VARCHAR(255), IN `p_role` ENUM('Admin','User'), IN `p_email` VARCHAR(100), IN `p_full_name` VARCHAR(150), IN `p_department_id` INT(11), IN `p_status` ENUM('ACTIVE','INACTIVE'))   BEGIN
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
        BEGIN
            -- Rollback in case of an error
            ROLLBACK;
        END;
        
    -- Start transaction
    START TRANSACTION;

    -- Check if the username already exists
    IF EXISTS (SELECT 1 FROM users WHERE username = p_username) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Username already exists';
    END IF;

    -- Insert the new user into the users table
    INSERT INTO users (username, password, role, email, full_name, department_id, status)
    VALUES (p_username, p_password, IFNULL(p_role, 'User'), p_email, p_full_name, p_department_id, IFNULL(p_status, 'ACTIVE'));
    
    -- Commit transaction
    COMMIT;
    
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `auditlogs`
--

CREATE TABLE `auditlogs` (
  `id` int(11) NOT NULL,
  `table_name` varchar(50) NOT NULL,
  `operation` enum('CREATE','READ','UPDATE','DELETE') NOT NULL,
  `changed_data` text DEFAULT NULL,
  `user_id` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `departments`
--

CREATE TABLE `departments` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `departments`
--

INSERT INTO `departments` (`id`, `name`) VALUES
(2, 'Finance'),
(1, 'HR'),
(5, 'IT Support'),
(4, 'Marketing'),
(3, 'Sales');

-- --------------------------------------------------------

--
-- Table structure for table `inventory`
--

CREATE TABLE `inventory` (
  `id` int(11) NOT NULL,
  `item_name` varchar(150) NOT NULL,
  `description` varchar(100) DEFAULT NULL,
  `quantity` int(11) NOT NULL,
  `img_path` varchar(2048) DEFAULT NULL,
  `status` enum('IN STOCK','OUT OF STOCK') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventory`
--

INSERT INTO `inventory` (`id`, `item_name`, `description`, `quantity`, `img_path`, `status`, `created_at`, `updated_at`) VALUES
(1, 'test', 'test item', 10, NULL, 'IN STOCK', '2024-12-11 14:50:20', '2025-04-01 10:10:00'),
(2, 'test2', 'test2', 19, NULL, 'IN STOCK', '2024-12-11 17:43:00', '2025-04-01 09:22:55'),
(3, 'test3', 'aserarr', 12, NULL, 'IN STOCK', '2024-12-11 18:39:51', '2024-12-15 12:16:18'),
(6, 'ytjynhbg', 'wrfferw', 232, NULL, 'IN STOCK', '2024-12-15 07:34:19', '2024-12-15 12:16:21'),
(12, 'Quentin Cobb', 'Quo sit dolore simi', 97, NULL, 'IN STOCK', '2025-04-01 10:26:25', '2025-04-01 10:26:25');

--
-- Triggers `inventory`
--
DELIMITER $$
CREATE TRIGGER `update_inventory_status` BEFORE UPDATE ON `inventory` FOR EACH ROW BEGIN
    
    IF NEW.quantity = 0 THEN
        SET NEW.status = 'OUT OF STOCK';
   
    ELSEIF NEW.quantity > 0 THEN
        SET NEW.status = 'IN STOCK';
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `inventoryhistory`
--

CREATE TABLE `inventoryhistory` (
  `id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `change_type` enum('ADDED','UPDATED','REMOVED') NOT NULL,
  `old_quantity` int(11) DEFAULT NULL,
  `new_quantity` int(11) NOT NULL,
  `changed_by` int(11) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `inventoryhistory`
--

INSERT INTO `inventoryhistory` (`id`, `item_id`, `change_type`, `old_quantity`, `new_quantity`, `changed_by`, `timestamp`) VALUES
(19, 3, 'REMOVED', 10, 9, 9, '2024-12-12 11:23:51'),
(20, 3, 'ADDED', 9, 10, 9, '2024-12-12 11:41:41'),
(21, 3, 'ADDED', 10, 11, 9, '2024-12-12 11:42:16'),
(22, 3, 'ADDED', 11, 12, 9, '2024-12-12 11:51:11'),
(23, 3, 'REMOVED', 12, 10, 9, '2024-12-12 11:58:16'),
(24, 3, 'ADDED', 10, 12, 9, '2024-12-12 11:58:25'),
(25, 3, 'REMOVED', 12, 10, 9, '2024-12-12 11:58:38'),
(26, 3, 'ADDED', 10, 12, 9, '2024-12-12 11:58:47'),
(27, 1, 'REMOVED', 10, 9, 9, '2024-12-12 18:04:10'),
(28, 1, 'ADDED', 9, 10, 9, '2024-12-12 18:04:21'),
(29, 1, 'REMOVED', 10, 9, 5, '2024-12-12 18:59:16'),
(30, 1, 'ADDED', 9, 10, 5, '2024-12-12 18:59:27'),
(31, 1, 'REMOVED', 10, 9, 5, '2024-12-13 09:04:08'),
(32, 1, 'ADDED', 9, 10, 5, '2024-12-13 09:04:16'),
(33, 1, 'REMOVED', 10, 5, 5, '2024-12-13 09:04:26'),
(34, 1, 'ADDED', 5, 10, 5, '2024-12-13 09:04:44'),
(35, 2, 'REMOVED', 20, 9, 5, '2024-12-13 10:10:18'),
(36, 2, 'ADDED', 9, 20, 5, '2024-12-13 19:09:31'),
(37, 2, 'REMOVED', 20, 1, 5, '2024-12-13 19:50:19'),
(38, 2, 'REMOVED', 1, 0, 5, '2024-12-13 19:51:39'),
(39, 2, 'REMOVED', 5, 0, 5, '2024-12-13 19:58:23'),
(40, 2, 'ADDED', 0, 19, 5, '2024-12-13 19:58:34'),
(41, 2, 'ADDED', 19, 20, 5, '2024-12-13 19:58:36'),
(42, 2, 'ADDED', 20, 25, 5, '2024-12-13 19:58:38'),
(43, 3, 'REMOVED', 12, 0, 5, '2024-12-13 20:01:07'),
(44, 3, 'ADDED', 0, 12, 5, '2024-12-13 20:01:19'),
(45, 1, 'REMOVED', 10, 1, 9, '2024-12-14 06:07:00'),
(46, 1, 'REMOVED', 1, 0, 9, '2024-12-14 06:07:11'),
(47, 1, 'ADDED', 0, 9, 9, '2024-12-14 06:07:20'),
(48, 1, 'ADDED', 9, 10, 9, '2024-12-14 06:07:22'),
(49, 1, 'REMOVED', 10, 9, 5, '2024-12-14 06:08:41'),
(50, 1, 'ADDED', 9, 10, 5, '2024-12-14 06:10:09'),
(51, 3, 'REMOVED', 12, 0, 5, '2024-12-14 12:43:04'),
(52, 3, 'ADDED', 0, 12, 5, '2024-12-14 12:43:31'),
(53, 3, 'REMOVED', 12, 0, 5, '2024-12-15 09:12:08'),
(54, 6, 'REMOVED', 232, 202, 5, '2024-12-15 12:16:10'),
(55, 3, 'ADDED', 0, 12, 5, '2024-12-15 12:16:18'),
(56, 6, 'ADDED', 202, 232, 5, '2024-12-15 12:16:21'),
(57, 2, 'REMOVED', 25, 24, 26, '2025-04-01 04:36:48'),
(58, 2, 'REMOVED', 24, 19, 1, '2025-04-01 09:22:55'),
(59, 1, 'REMOVED', 10, 9, 26, '2025-04-01 09:53:06');

-- --------------------------------------------------------

--
-- Table structure for table `issued_items`
--

CREATE TABLE `issued_items` (
  `id` int(11) NOT NULL,
  `item_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL,
  `status` enum('Brought','Returned') NOT NULL DEFAULT 'Brought',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `issued_items`
--

INSERT INTO `issued_items` (`id`, `item_id`, `user_id`, `quantity`, `status`, `created_at`, `updated_at`) VALUES
(6, 3, 9, 1, 'Returned', '2024-12-12 11:23:51', '2024-12-12 11:23:51'),
(7, 3, 9, 2, 'Returned', '2024-12-12 11:58:16', '2024-12-12 11:58:16'),
(8, 3, 9, 2, 'Returned', '2024-12-12 11:58:38', '2024-12-12 11:58:38'),
(9, 1, 9, 1, 'Returned', '2024-12-12 18:04:10', '2024-12-12 18:04:10'),
(10, 1, 5, 1, 'Returned', '2024-12-12 18:59:16', '2024-12-12 18:59:16'),
(11, 1, 5, 1, 'Returned', '2024-12-13 09:04:08', '2024-12-13 09:04:08'),
(12, 1, 5, 5, 'Returned', '2024-12-13 09:04:26', '2024-12-13 09:04:26'),
(13, 2, 5, 11, 'Returned', '2024-12-13 10:10:18', '2024-12-13 10:10:18'),
(14, 2, 5, 19, 'Returned', '2024-12-13 19:50:19', '2024-12-13 19:50:19'),
(15, 2, 5, 1, 'Returned', '2024-12-13 19:51:39', '2024-12-13 19:51:39'),
(16, 2, 5, 5, 'Returned', '2024-12-13 19:58:23', '2024-12-13 19:58:23'),
(17, 3, 5, 12, 'Returned', '2024-12-13 20:01:07', '2024-12-13 20:01:07'),
(18, 1, 9, 9, 'Returned', '2024-12-14 06:07:00', '2024-12-14 06:07:00'),
(19, 1, 9, 1, 'Returned', '2024-12-14 06:07:11', '2024-12-14 06:07:11'),
(20, 1, 5, 1, 'Returned', '2024-12-14 06:08:41', '2024-12-14 06:08:41'),
(21, 3, 5, 12, 'Returned', '2024-12-14 12:43:04', '2024-12-14 12:43:04'),
(22, 3, 5, 12, 'Returned', '2024-12-15 09:12:08', '2024-12-15 09:12:08'),
(23, 6, 5, 30, 'Returned', '2024-12-15 12:16:10', '2024-12-15 12:16:10'),
(24, 2, 26, 1, 'Brought', '2025-04-01 04:36:48', '2025-04-01 04:36:48'),
(25, 2, 1, 5, 'Brought', '2025-04-01 09:22:55', '2025-04-01 09:22:55'),
(26, 1, 26, 1, 'Brought', '2025-04-01 09:53:06', '2025-04-01 09:53:06');

-- --------------------------------------------------------

--
-- Stand-in structure for view `issued_items_view`
-- (See below for the actual view)
--
CREATE TABLE `issued_items_view` (
`status` enum('Brought','Returned')
,`quantity` int(11)
,`created_at` date
,`item_name` varchar(150)
,`full_name` varchar(150)
);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('Admin','User') NOT NULL DEFAULT 'User',
  `email` varchar(100) NOT NULL,
  `full_name` varchar(150) NOT NULL,
  `img_path` varchar(2048) DEFAULT NULL,
  `department_id` int(11) NOT NULL,
  `status` enum('ACTIVE','INACTIVE') DEFAULT 'ACTIVE',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `role`, `email`, `full_name`, `img_path`, `department_id`, `status`, `created_at`, `updated_at`) VALUES
(1, 'user', '123123', 'User', 'user@gmail.com', 'user', NULL, 1, 'ACTIVE', '2024-12-11 07:20:48', '2025-04-01 03:37:36'),
(5, 'test1', '12345678', 'Admin', 'qwerfhgh@gmail.com', 'test', NULL, 2, 'ACTIVE', '2024-12-11 08:11:15', '2025-04-01 10:34:04'),
(9, 'kamal', '12345', 'User', 'admin@gmail.com', 'kaml', 'img/9_1734368354811_ER2.jpg', 1, 'ACTIVE', '2024-12-11 08:22:20', '2025-04-01 03:37:58'),
(26, 'admin', '123123', 'Admin', 'admin1@gmail.com', 'admin', NULL, 1, 'ACTIVE', '2024-12-15 06:43:40', '2025-04-01 04:11:42');

-- --------------------------------------------------------

--
-- Structure for view `issued_items_view`
--
DROP TABLE IF EXISTS `issued_items_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `issued_items_view`  AS SELECT `ii`.`status` AS `status`, `ii`.`quantity` AS `quantity`, cast(`ii`.`created_at` as date) AS `created_at`, `inv`.`item_name` AS `item_name`, `usr`.`full_name` AS `full_name` FROM ((`issued_items` `ii` join `inventory` `inv` on(`ii`.`item_id` = `inv`.`id`)) join `users` `usr` on(`ii`.`user_id` = `usr`.`id`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `auditlogs`
--
ALTER TABLE `auditlogs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `departments`
--
ALTER TABLE `departments`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `inventory`
--
ALTER TABLE `inventory`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `inventoryhistory`
--
ALTER TABLE `inventoryhistory`
  ADD PRIMARY KEY (`id`),
  ADD KEY `item_id` (`item_id`),
  ADD KEY `changed_by` (`changed_by`);

--
-- Indexes for table `issued_items`
--
ALTER TABLE `issued_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `forign key to inventory` (`item_id`),
  ADD KEY `forign key to users` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `department_id` (`department_id`),
  ADD KEY `idx_username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `auditlogs`
--
ALTER TABLE `auditlogs`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `departments`
--
ALTER TABLE `departments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `inventory`
--
ALTER TABLE `inventory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `inventoryhistory`
--
ALTER TABLE `inventoryhistory`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT for table `issued_items`
--
ALTER TABLE `issued_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `auditlogs`
--
ALTER TABLE `auditlogs`
  ADD CONSTRAINT `auditlogs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `inventoryhistory`
--
ALTER TABLE `inventoryhistory`
  ADD CONSTRAINT `inventoryhistory_ibfk_1` FOREIGN KEY (`item_id`) REFERENCES `inventory` (`id`),
  ADD CONSTRAINT `inventoryhistory_ibfk_2` FOREIGN KEY (`changed_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `issued_items`
--
ALTER TABLE `issued_items`
  ADD CONSTRAINT `forign key to inventory` FOREIGN KEY (`item_id`) REFERENCES `inventory` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `forign key to users` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_ibfk_1` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
