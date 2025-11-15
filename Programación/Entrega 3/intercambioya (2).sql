-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: 127.0.0.1:3306
-- Tiempo de generación: 09-11-2025 a las 15:11:59
-- Versión del servidor: 8.0.43
-- Versión de PHP: 8.3.14

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `intercambioya`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `categoria`
--

DROP TABLE IF EXISTS `categoria`;
CREATE TABLE IF NOT EXISTS `categoria` (
  `id_categoria` int NOT NULL AUTO_INCREMENT,
  `nombre` varchar(50) NOT NULL,
  PRIMARY KEY (`id_categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `categoria`
--

INSERT INTO `categoria` (`id_categoria`, `nombre`) VALUES
(1, 'Electrónica'),
(2, 'Ropa'),
(3, 'Hogar'),
(4, 'Herramientas'),
(5, 'Deportes'),
(6, 'Juguetes'),
(7, 'Libros'),
(8, 'Otros');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `chat`
--

DROP TABLE IF EXISTS `chat`;
CREATE TABLE IF NOT EXISTS `chat` (
  `id_chat` int NOT NULL AUTO_INCREMENT,
  `id_trueque` int NOT NULL,
  `id_usuario1` int NOT NULL,
  `id_usuario2` int NOT NULL,
  `oculto_usuario1` enum('0','1') DEFAULT '0',
  `oculto_usuario2` enum('0','1') DEFAULT '0',
  `fecha_inicio` datetime DEFAULT CURRENT_TIMESTAMP,
  `visible_para_usuario1` tinyint(1) DEFAULT '1',
  `visible_para_usuario2` tinyint(1) DEFAULT '1',
  `oculto` enum('0','1') DEFAULT '0',
  PRIMARY KEY (`id_chat`),
  KEY `id_trueque` (`id_trueque`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `confirmacion_trueque`
--

DROP TABLE IF EXISTS `confirmacion_trueque`;
CREATE TABLE IF NOT EXISTS `confirmacion_trueque` (
  `id_confirmacion` int NOT NULL AUTO_INCREMENT,
  `id_trueque` int NOT NULL,
  `id_usuario` int NOT NULL,
  `fecha` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_confirmacion`),
  KEY `id_trueque` (`id_trueque`),
  KEY `id_usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `detalle_trueque`
--

DROP TABLE IF EXISTS `detalle_trueque`;
CREATE TABLE IF NOT EXISTS `detalle_trueque` (
  `id_detalle` int NOT NULL AUTO_INCREMENT,
  `id_trueque` int NOT NULL,
  `id_producto_ofrecido` int NOT NULL,
  `id_producto_objetivo` int NOT NULL,
  `condiciones` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id_detalle`),
  KEY `fk_detalle_trueque` (`id_trueque`),
  KEY `fk_detalle_producto_ofrecido` (`id_producto_ofrecido`),
  KEY `fk_detalle_producto_objetivo` (`id_producto_objetivo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `genera`
--

DROP TABLE IF EXISTS `genera`;
CREATE TABLE IF NOT EXISTS `genera` (
  `id_trueque` int NOT NULL,
  `id_chat` int NOT NULL,
  PRIMARY KEY (`id_trueque`,`id_chat`),
  KEY `id_chat` (`id_chat`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `mensaje`
--

DROP TABLE IF EXISTS `mensaje`;
CREATE TABLE IF NOT EXISTS `mensaje` (
  `id_mensaje` int NOT NULL AUTO_INCREMENT,
  `id_chat` int NOT NULL,
  `id_usuario` int NOT NULL,
  `contenido` text NOT NULL,
  `fecha_envio` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_mensaje`),
  KEY `id_chat` (`id_chat`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

DROP TABLE IF EXISTS `producto`;
CREATE TABLE IF NOT EXISTS `producto` (
  `id_producto` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int DEFAULT NULL,
  `id_categoria` int DEFAULT NULL,
  `nombre` varchar(100) NOT NULL,
  `estado` enum('Disponible','Intercambiado') DEFAULT 'Disponible',
  `condicion` varchar(50) DEFAULT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `descripcion` text,
  PRIMARY KEY (`id_producto`),
  KEY `id_usuario` (`id_usuario`),
  KEY `id_categoria` (`id_categoria`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `reporte`
--

DROP TABLE IF EXISTS `reporte`;
CREATE TABLE IF NOT EXISTS `reporte` (
  `id_reporte` int NOT NULL AUTO_INCREMENT,
  `id_reportante` int NOT NULL,
  `id_reportado` int NOT NULL,
  `motivo` varchar(255) NOT NULL,
  `descripcion` text,
  `fecha_reporte` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_reporte`),
  KEY `id_reportante` (`id_reportante`),
  KEY `reporte_ibfk_2` (`id_reportado`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `telefono_usuario`
--

DROP TABLE IF EXISTS `telefono_usuario`;
CREATE TABLE IF NOT EXISTS `telefono_usuario` (
  `id_tel` int NOT NULL AUTO_INCREMENT,
  `id_usuario` int NOT NULL,
  `numero` varchar(20) NOT NULL,
  PRIMARY KEY (`id_tel`),
  KEY `id_usuario` (`id_usuario`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `trueque`
--

DROP TABLE IF EXISTS `trueque`;
CREATE TABLE IF NOT EXISTS `trueque` (
  `id_trueque` int NOT NULL AUTO_INCREMENT,
  `estado` enum('Pendiente','Aceptado','Rechazado','Cancelado','Finalizado') NOT NULL DEFAULT 'Pendiente',
  `fecha_creacion` datetime DEFAULT CURRENT_TIMESTAMP,
  `id_usuario1` int NOT NULL,
  `id_usuario2` int NOT NULL,
  `id_producto_ofrecido` int NOT NULL,
  `id_producto_objetivo` int NOT NULL,
  `confirmaciones` int DEFAULT '0',
  PRIMARY KEY (`id_trueque`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `trueque`
--

INSERT INTO `trueque` (`id_trueque`, `estado`, `fecha_creacion`, `id_usuario1`, `id_usuario2`, `id_producto_ofrecido`, `id_producto_objetivo`, `confirmaciones`) VALUES
(5, 'Finalizado', '2025-11-04 23:30:53', 9, 8, 10, 9, 2);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuario`
--

DROP TABLE IF EXISTS `usuario`;
CREATE TABLE IF NOT EXISTS `usuario` (
  `id_usuario` int NOT NULL AUTO_INCREMENT,
  `primer_nombre` varchar(50) NOT NULL,
  `primer_apellido` varchar(50) NOT NULL,
  `email` varchar(100) NOT NULL,
  `contraseña` varchar(100) NOT NULL,
  `descripcion` text,
  `foto_perfil` varchar(255) DEFAULT NULL,
  `fecha_registro` date DEFAULT NULL,
  `rol` enum('Registrado','Administrador') DEFAULT 'Registrado',
  PRIMARY KEY (`id_usuario`),
  UNIQUE KEY `email` (`email`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Volcado de datos para la tabla `usuario`
--

INSERT INTO `usuario` (`id_usuario`, `primer_nombre`, `primer_apellido`, `email`, `contraseña`, `descripcion`, `foto_perfil`, `fecha_registro`, `rol`) VALUES
(10, 'Santiago', 'Quirque', 'rngs.company@gmail.com', '$2y$10$Cdu9hLrVZAowb/BUs1wEHOrCPJDGbF71M91sjuxGQ5orT6wYBChVy', NULL, 'img/default-user.png', NULL, 'Administrador');

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `chat`
--
ALTER TABLE `chat`
  ADD CONSTRAINT `chat_ibfk_1` FOREIGN KEY (`id_trueque`) REFERENCES `trueque` (`id_trueque`) ON DELETE CASCADE;

--
-- Filtros para la tabla `confirmacion_trueque`
--
ALTER TABLE `confirmacion_trueque`
  ADD CONSTRAINT `confirmacion_trueque_ibfk_1` FOREIGN KEY (`id_trueque`) REFERENCES `trueque` (`id_trueque`) ON DELETE CASCADE,
  ADD CONSTRAINT `confirmacion_trueque_ibfk_2` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `detalle_trueque`
--
ALTER TABLE `detalle_trueque`
  ADD CONSTRAINT `fk_detalle_producto_objetivo` FOREIGN KEY (`id_producto_objetivo`) REFERENCES `producto` (`id_producto`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detalle_producto_ofrecido` FOREIGN KEY (`id_producto_ofrecido`) REFERENCES `producto` (`id_producto`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_detalle_trueque` FOREIGN KEY (`id_trueque`) REFERENCES `trueque` (`id_trueque`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `genera`
--
ALTER TABLE `genera`
  ADD CONSTRAINT `genera_ibfk_1` FOREIGN KEY (`id_trueque`) REFERENCES `trueque` (`id_trueque`) ON DELETE CASCADE,
  ADD CONSTRAINT `genera_ibfk_2` FOREIGN KEY (`id_chat`) REFERENCES `chat` (`id_chat`) ON DELETE CASCADE;

--
-- Filtros para la tabla `mensaje`
--
ALTER TABLE `mensaje`
  ADD CONSTRAINT `mensaje_ibfk_1` FOREIGN KEY (`id_chat`) REFERENCES `chat` (`id_chat`) ON DELETE CASCADE;

--
-- Filtros para la tabla `producto`
--
ALTER TABLE `producto`
  ADD CONSTRAINT `producto_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE,
  ADD CONSTRAINT `producto_ibfk_2` FOREIGN KEY (`id_categoria`) REFERENCES `categoria` (`id_categoria`);

--
-- Filtros para la tabla `reporte`
--
ALTER TABLE `reporte`
  ADD CONSTRAINT `reporte_ibfk_1` FOREIGN KEY (`id_reportante`) REFERENCES `usuario` (`id_usuario`),
  ADD CONSTRAINT `reporte_ibfk_2` FOREIGN KEY (`id_reportado`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE;

--
-- Filtros para la tabla `telefono_usuario`
--
ALTER TABLE `telefono_usuario`
  ADD CONSTRAINT `telefono_usuario_ibfk_1` FOREIGN KEY (`id_usuario`) REFERENCES `usuario` (`id_usuario`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
