-- phpMyAdmin SQL Dump
-- version 5.1.1deb5ubuntu1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 04-03-2025 a las 09:23:50
-- Versión del servidor: 10.6.18-MariaDB-0ubuntu0.22.04.1
-- Versión de PHP: 8.1.2-1ubuntu2.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";

START TRANSACTION;

SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;

/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;

/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;

/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `loansdb`
--
CREATE USER 'loansu'@'localhost' IDENTIFIED BY 'loansu';
GRANT ALL PRIVILEGES ON loansdb.* TO 'loansu'@'localhost';
FLUSH PRIVILEGES;


-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `users`
--

CREATE TABLE `users` (
  `mail` VARCHAR(60) NOT NULL,
  `pass` VARCHAR(60) NOT NULL,
  `name` VARCHAR(45) NOT NULL
) ENGINE=INNODB DEFAULT CHARSET=UTF8MB4 COLLATE=UTF8MB4_GENERAL_CI;

--
-- Volcado de datos para la tabla `users`
--

INSERT INTO `users` (
  `mail`,
  `pass`,
  `name`
) VALUES (
  'user@domain.ext',
  '$2y$10$xjoMj/Gq6Ea7E.UrgDwma.cvlI/v/Sh2m9WL8amtRlr7xQtY58iV.',
  'Usuario Apellido1 Apellido2'
);

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (
    `mail`
  );

COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;

/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;

/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
