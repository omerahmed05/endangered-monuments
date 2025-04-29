-- phpMyAdmin SQL Dump
-- version 4.7.1
-- https://www.phpmyadmin.net/
--
-- Host: sql5.freesqldatabase.com
-- Generation Time: Apr 29, 2025 at 02:27 AM
-- Server version: 5.5.62-0ubuntu0.14.04.1
-- PHP Version: 7.0.33-0ubuntu0.16.04.16

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `sql5770619`
--

-- --------------------------------------------------------

--
-- Table structure for table `ARCHAEOLOGIST`
--

CREATE TABLE `ARCHAEOLOGIST` (
  `ARCHAEOLOGIST_ID` int(11) NOT NULL,
  `PASSWORD` varchar(128) NOT NULL,
  `EXCAVATION_ID` int(11) DEFAULT NULL,
  `USERNAME` text,
  `EMAIL_ADDRESS` text,
  `MAIL_ADDRESS` text,
  `PHONE_NUMBER` text,
  `START_DATE` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `ARCHAEOLOGIST`
--

INSERT INTO `ARCHAEOLOGIST` (`ARCHAEOLOGIST_ID`, `PASSWORD`, `EXCAVATION_ID`, `USERNAME`, `EMAIL_ADDRESS`, `MAIL_ADDRESS`, `PHONE_NUMBER`, `START_DATE`) VALUES
(1, '', 1, 'MarkL', 'LehnerM@vt.edu', '123 Roanoke St', '5712356789', '2025-04-10'),
(6, 'pbkdf2:sha256:600000$4YPObj3EGIGykjar$7e33cc3f635347cb9c35ac5e94069f6e320c51eb449dc49a56d256084552775a', 1, 'test', 'test@vt.edu', '', '', '2025-04-09'),
(7, 'pbkdf2:sha256:600000$K99jK50gMHsOYHpg$3eca39de624844e046b0cadb8b9415219e56c728dd87982a0482e08033914a5d', 1, 'testUser', 'cristianc@vt.edu', '', '', '2025-04-10');

-- --------------------------------------------------------

--
-- Table structure for table `CITY`
--

CREATE TABLE `CITY` (
  `CITY_ID` int(11) NOT NULL,
  `NAME` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `CITY`
--

INSERT INTO `CITY` (`CITY_ID`, `NAME`) VALUES
(1, 'Giza'),
(2, 'Cairo');

-- --------------------------------------------------------

--
-- Table structure for table `CONTEXT`
--

CREATE TABLE `CONTEXT` (
  `CONTEXT` text NOT NULL,
  `MONUMENT_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `EXCAVATION_PROJECT`
--

CREATE TABLE `EXCAVATION_PROJECT` (
  `EXCAVATION_ID` int(11) NOT NULL,
  `NAME` text,
  `PROJECT_URL` text,
  `CITY_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `EXCAVATION_PROJECT`
--

INSERT INTO `EXCAVATION_PROJECT` (`EXCAVATION_ID`, `NAME`, `PROJECT_URL`, `CITY_ID`) VALUES
(1, 'ARCE Sphinx Project 1979-1983 Archive', 'https://opencontext.org/projects/141e814a-ba2d-4560-879f-80f1afb019e9', 1),
(2, 'Images Documenting The Ottoman Tiles of the Fakahani Mosque in Cairo', 'https://opencontext.org/projects/2bc1f77d-fe36-41eb-99b9-c0261edb4f18', 2);

-- --------------------------------------------------------

--
-- Table structure for table `MONUMENT`
--

CREATE TABLE `MONUMENT` (
  `MONUMENT_ID` int(11) NOT NULL,
  `NAME` text NOT NULL,
  `ITEM_CATEGORY` text,
  `ICON` text,
  `CITATION_URL` text,
  `THUMBNAIL` text NOT NULL,
  `LONGITUDE` decimal(10,0) DEFAULT NULL,
  `LATITUDE` decimal(10,0) DEFAULT NULL,
  `CITY_ID` int(11) DEFAULT NULL,
  `EXCAVATION_ID` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `MONUMENT`
--

INSERT INTO `MONUMENT` (`MONUMENT_ID`, `NAME`, `ITEM_CATEGORY`, `ICON`, `CITATION_URL`, `THUMBNAIL`, `LONGITUDE`, `LATITUDE`, `CITY_ID`, `EXCAVATION_ID`) VALUES
(0, 'Name', 'Item Category', 'URI', 'Citation_URI', 'Thumbnail', '0', '0', 0, 0),
(1, 'Unspecified Sphinx Area 7', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2j391d2s', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/BW-Photos/bw02432.jpg', '31', '30', 1, 1),
(2, 'Unspecified Sphinx Area 8', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2db89k81', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/BW-Photos/bw02601.jpg', '31', '30', 1, 1),
(3, 'Unspecified Sphinx Area 3', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2251wf98', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Color-Photos/020193.jpg', '31', '30', 1, 1),
(4, 'Unspecified Sphinx Area 4', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2xd15t29', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Color-Photos/020533.jpg', '31', '30', 1, 1),
(5, 'Unspecified Sphinx Area 5', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2sn0g09f', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Color-Photos/020812.jpg', '31', '30', 1, 1),
(6, 'Unspecified Sphinx Area 2', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k25t3wv9w', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Color-Photos/004344.jpg', '31', '30', 1, 1),
(7, 'Unspecified Sphinx Area 6', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2nv9r648', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Color-Photos/021074.jpg', '31', '30', 1, 1),
(8, 'Unspecified Sphinx Area 12', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2wd44x22', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Color-Photos/022942.jpg', '31', '30', 1, 1),
(9, 'Unspecified Sphinx Area 11', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2154vj8j', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Color-Photos/022600.jpg', '31', '30', 1, 1),
(10, 'Unspecified Sphinx Area 13', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2rn3f396', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Color-Photos/023211.jpg', '31', '30', 1, 1),
(11, 'Unspecified Sphinx Area 10', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k24x5kc20', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Color-Photos/022309.jpg', '31', '30', 1, 1),
(12, 'Unspecified Sphinx Area 9', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k28k7ks2x', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Color-Photos/022044.jpg', '31', '30', 1, 1),
(13, 'Sphinx Temple', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k24177v6v', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/BW-Photos/bw02388.jpg', '31', '30', 1, 1),
(14, 'Removal 16', 'Trench', 'https://opencontext.org/static/oc/icons-v2/oc-trench-icon.svg', 'https://n2t.net/ark:/28722/k2sx6k570', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-st-032.jpg', '31', '30', 1, 1),
(15, 'Feature FNWa1', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k22v2t61q', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-nw-006.jpg', '31', '30', 1, 1),
(16, 'Sphinx East', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2j96f59x', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-ss-005.jpg', '31', '30', 1, 1),
(17, 'Sphinx Statue', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k27s7zn9t', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/BW-Photos/bw02554.jpg', '31', '30', 1, 1),
(18, 'Unspecified Sphinx Area 1', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k29k4mp44', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Color-Photos/004090.jpg', '31', '30', 1, 1),
(19, 'Sphinx North', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2183jz3f', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-n-020.jpg', '31', '30', 1, 1),
(20, 'Khafre Valley Temple', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k28342t83', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-kvt-002.jpg', '31', '30', 1, 1),
(21, 'Sphinx Head', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2dj5qc49', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/BW-Photos/bw02487.jpg', '31', '30', 1, 1),
(22, 'Sphinx Northwest', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k25148r63', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-ss-031.jpg', '31', '30', 1, 1),
(23, 'Feature FEa3', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2cc18p6c', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-e-077.jpg', '31', '30', 1, 1),
(24, 'Feature FNWc1', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2bc47s7m', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-nw-015.jpg', '31', '30', 1, 1),
(25, 'Sphinx Southwest', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2h99d87q', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-sws-017.jpg', '31', '30', 1, 1),
(26, 'Sphinx Ditch', 'Site Area', 'https://opencontext.org/static/oc/icons-v2/noun-locally-made-compost-4476027.svg', 'https://n2t.net/ark:/28722/k2p27503p', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-ss-045.jpg', '31', '30', 1, 1),
(27, 'Feature FEc3', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2h13938p', 'https://opencontext.org/static/oc/images/icons/pdf-noun-89522.png', '31', '30', 1, 1),
(28, 'Feature FEa2', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2126555m', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-e-076.jpg', '31', '30', 1, 1),
(29, 'Feature FNWa2', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2pn9cb19', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/101-drawing-d-nw-004.jpg', '31', '30', 1, 1),
(30, 'Sphinx Northeast', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k28s50k0j', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-ss-032.jpg', '31', '30', 1, 1),
(31, 'Amenhotep II Temple', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2223624c', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-sa-001.jpg', '31', '30', 1, 1),
(32, 'Sphinx South', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2cj8pg23', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-sws-019.jpg', '31', '30', 1, 1),
(33, 'Unspecified Sphinx Area 14', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2mw2q96j', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Color-Photos/023246.jpg', '31', '30', 1, 1),
(34, 'Feature FNEh14', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2dz0hx5q', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-ne-034.jpg', '31', '30', 1, 1),
(35, 'East Chapel', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2x92gf0g', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-gen-051.jpg', '31', '30', 1, 1),
(36, 'Removal 2', 'Trench', 'https://opencontext.org/static/oc/icons-v2/oc-trench-icon.svg', 'https://n2t.net/ark:/28722/k2mc96b9q', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-nw-011.jpg', '31', '30', 1, 1),
(37, 'Sphinx Amphitheater', 'Site', 'https://opencontext.org/static/oc/icons-v2/noun-trowel-3586734.svg', 'https://n2t.net/ark:/28722/k2sq95d39', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/BW-Photos/bw01715.jpg', '31', '30', 1, 1),
(38, 'Feature FNEh16', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k21r72w6j', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/101-drawing-d-ne-018.jpg', '31', '30', 1, 1),
(39, 'East of Sphinx Temple', 'Site', 'https://opencontext.org/static/oc/icons-v2/noun-trowel-3586734.svg', 'https://n2t.net/ark:/28722/k2ns11t4x', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-gen-040.jpg', '31', '30', 1, 1),
(40, 'Removal 14', 'Trench', 'https://opencontext.org/static/oc/icons-v2/oc-trench-icon.svg', 'https://n2t.net/ark:/28722/k22f80m8p', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/101-drawing-d-n-008.jpg', '31', '30', 1, 1),
(41, 'Feature FTd1', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2gq75z0g', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-t-011.jpg', '31', '30', 1, 1),
(42, 'East of Khafre Valley Temple', 'Site', 'https://opencontext.org/static/oc/icons-v2/noun-trowel-3586734.svg', 'https://n2t.net/ark:/28722/k2sj1rm6q', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-kvt-003.jpg', '31', '30', 1, 1),
(43, 'Sphinx Rump Ledge', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2wh2v97c', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-ss-010.jpg', '31', '30', 1, 1),
(44, 'Feature FNEh15', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k25h7sq0x', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-ne-035.jpg', '31', '30', 1, 1),
(45, 'Removal 5', 'Trench', 'https://opencontext.org/static/oc/icons-v2/oc-trench-icon.svg', 'https://n2t.net/ark:/28722/k27371x9b', 'https://opencontext.org/static/oc/images/icons/pdf-noun-89522.png', '31', '30', 1, 1),
(46, 'Feature FEa1', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k28k7ks1f', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-e-069.jpg', '31', '30', 1, 1),
(47, 'ST Court', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2wq0832j', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/BW-Photos/bw01812.jpg', '31', '30', 1, 1),
(48, 'Removal 9', 'Trench', 'https://opencontext.org/static/oc/icons-v2/oc-trench-icon.svg', 'https://n2t.net/ark:/28722/k2q52w84w', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/BW-Photos/bw02259.jpg', '31', '30', 1, 1),
(49, 'Feature FNEh17', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2s75nf74', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-ne-037.jpg', '31', '30', 1, 1),
(50, 'Roman Pavement', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2571pj1w', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/BW-Photos/bw02004.jpg', '31', '30', 1, 1),
(51, 'Removal 6', 'Trench', 'https://opencontext.org/static/oc/icons-v2/oc-trench-icon.svg', 'https://n2t.net/ark:/28722/k23b6b444', 'https://opencontext.org/static/oc/images/icons/pdf-noun-89522.png', '31', '30', 1, 1),
(52, 'Removal 10', 'Trench', 'https://opencontext.org/static/oc/icons-v2/oc-trench-icon.svg', 'https://n2t.net/ark:/28722/k2kd25g04', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-ne-038.jpg', '31', '30', 1, 1),
(53, 'North Ledge', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2vx0mz91', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-sd-001.jpg', '31', '30', 1, 1),
(54, 'Squares N1, E9-E10', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2qv3t057', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-est-003.jpg', '31', '30', 1, 1),
(55, 'Removal 17', 'Trench', 'https://opencontext.org/static/oc/icons-v2/oc-trench-icon.svg', 'https://n2t.net/ark:/28722/k2p55vc4n', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-e-049.jpg', '31', '30', 1, 1),
(56, 'Removal 19', 'Trench', 'https://opencontext.org/static/oc/icons-v2/oc-trench-icon.svg', 'https://n2t.net/ark:/28722/k2dn4dr64', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-nw-018.jpg', '31', '30', 1, 1),
(57, 'ST East Colonnade', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2rx9j887', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-st-026.jpg', '31', '30', 1, 1),
(58, 'Feature FNEh5', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k24m9g63d', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-ne-030.jpg', '31', '30', 1, 1),
(59, 'Mound', 'Site', 'https://opencontext.org/static/oc/icons-v2/noun-trowel-3586734.svg', 'https://n2t.net/ark:/28722/k24b3c15v', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Color-Photos/021397.jpg', '31', '30', 1, 1),
(60, 'Removal 4', 'Trench', 'https://opencontext.org/static/oc/icons-v2/oc-trench-icon.svg', 'https://n2t.net/ark:/28722/k2bv7rr3d', 'https://opencontext.org/static/oc/images/icons/pdf-noun-89522.png', '31', '30', 1, 1),
(61, 'Removal 1', 'Trench', 'https://opencontext.org/static/oc/icons-v2/oc-trench-icon.svg', 'https://n2t.net/ark:/28722/k2r49x533', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Color-Photos/021915.jpg', '31', '30', 1, 1),
(62, 'Removal 8', 'Trench', 'https://opencontext.org/static/oc/icons-v2/oc-trench-icon.svg', 'https://n2t.net/ark:/28722/k2tx3m296', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/BW-Photos/bw02192.jpg', '31', '30', 1, 1),
(63, 'Sphinx Rump Passage', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2rv0tw6j', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/BW-Photos/bw02558.jpg', '31', '30', 1, 1),
(64, 'Sphinx Southeast', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2n30430j', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-ss-004.jpg', '31', '30', 1, 1),
(65, 'Khafre Causeway', 'Site', 'https://opencontext.org/static/oc/icons-v2/noun-trowel-3586734.svg', 'https://n2t.net/ark:/28722/k2cv4sn25', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-sa-005.jpg', '31', '30', 1, 1),
(66, 'Feature FNEc22', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k20s02068', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-ne-032.jpg', '31', '30', 1, 1),
(67, 'Square N11, E9', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2pv6s350', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Color-Photos/021398.jpg', '31', '30', 1, 1),
(68, 'ST North Colonnade', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2805cf68', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/BW-Photos/bw01441.jpg', '31', '30', 1, 1),
(69, 'Sphinx Top', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2086j21n', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/BW-Photos/bw01616.jpg', '31', '30', 1, 1),
(70, 'Feature FNEh1', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2z323j7w', 'https://opencontext.org/static/oc/images/icons/pdf-noun-89522.png', '31', '30', 1, 1),
(71, 'Feature FTd2', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2c255h7s', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-t-013.jpg', '31', '30', 1, 1),
(72, 'Feature FNEc17', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2ng4xn4g', 'https://opencontext.org/static/oc/images/icons/pdf-noun-89522.png', '31', '30', 1, 1),
(73, 'Feature FNEh13', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2pg1zj18', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/101-drawing-d-ne-009.jpg', '31', '30', 1, 1),
(74, 'Feature FNEh2', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2f47xq27', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/101-drawing-d-ne-006.jpg', '31', '30', 1, 1),
(75, 'Feature FNEc6', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2w66r48s', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-ne-029.jpg', '31', '30', 1, 1),
(76, 'Feature FNEd4', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2hx1mm4d', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/BW-Photos/bw01860.jpg', '31', '30', 1, 1),
(77, 'Removal 20', 'Trench', 'https://opencontext.org/static/oc/icons-v2/oc-trench-icon.svg', 'https://n2t.net/ark:/28722/k28w3pz1h', 'https://opencontext.org/static/oc/images/icons/pdf-noun-89522.png', '31', '30', 1, 1),
(78, 'Feature FNEh4', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2sf32748', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/101-drawing-d-ne-007.jpg', '31', '30', 1, 1),
(79, 'Feature FNEd3', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k21v5s900', 'https://opencontext.org/static/oc/images/icons/pdf-noun-89522.png', '31', '30', 1, 1),
(80, 'Feature FNEc19', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2cz3h15w', 'https://opencontext.org/static/oc/images/icons/pdf-noun-89522.png', '31', '30', 1, 1),
(81, 'Feature FNEc3', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k25m6h35m', 'https://opencontext.org/static/oc/images/icons/pdf-noun-89522.png', '31', '30', 1, 1),
(82, 'Removal 15', 'Trench', 'https://opencontext.org/static/oc/icons-v2/oc-trench-icon.svg', 'https://n2t.net/ark:/28722/k2xp79027', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-e-021.jpg', '31', '30', 1, 1),
(83, 'Feature FNEd1', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k26m3j04c', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-ne-001.jpg', '31', '30', 1, 1),
(84, 'Removal 11', 'Trench', 'https://opencontext.org/static/oc/icons-v2/oc-trench-icon.svg', 'https://n2t.net/ark:/28722/k2fn1fn7v', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/BW-Photos/bw02184.jpg', '31', '30', 1, 1),
(85, 'ST West Colonnade', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k26119n5v', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/BW-Photos/bw01564.jpg', '31', '30', 1, 1),
(86, 'Feature FSEd3', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2r78mj8c', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-se-001.jpg', '31', '30', 1, 1),
(87, 'GII.VT Roof Terrace West', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2s46z259', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-kvt-008.jpg', '31', '30', 1, 1),
(88, 'Feature FTd3', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2794fq25', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-t-010.jpg', '31', '30', 1, 1),
(89, 'Feature FEc9', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2kw5pd69', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-e-050.jpg', '31', '30', 1, 1),
(90, 'Removal 3', 'Trench', 'https://opencontext.org/static/oc/icons-v2/oc-trench-icon.svg', 'https://n2t.net/ark:/28722/k2gm8gj43', 'https://opencontext.org/static/oc/images/icons/pdf-noun-89522.png', '31', '30', 1, 1),
(91, 'Removal 18', 'Trench', 'https://opencontext.org/static/oc/icons-v2/oc-trench-icon.svg', 'https://n2t.net/ark:/28722/k2jd54k0w', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Color-Photos/022749.jpg', '31', '30', 1, 1),
(92, 'Removal 7', 'Trench', 'https://opencontext.org/static/oc/icons-v2/oc-trench-icon.svg', 'https://n2t.net/ark:/28722/k2zp49w3j', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/BW-Photos/bw02046.jpg', '31', '30', 1, 1),
(93, 'Feature FSEh3', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2mg7wr47', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/101-drawing-d-sws-003.jpg', '31', '30', 1, 1),
(94, 'Feature FNEd7', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2gx4kq5n', 'https://opencontext.org/static/oc/images/icons/pdf-noun-89522.png', '31', '30', 1, 1),
(95, 'Feature FNEc2', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2tb1cr1s', 'https://opencontext.org/static/oc/images/icons/pdf-noun-89522.png', '31', '30', 1, 1),
(96, 'Feature FNEc4', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2np2bd8j', 'https://opencontext.org/static/oc/images/icons/pdf-noun-89522.png', '31', '30', 1, 1),
(97, 'Feature FNEd2', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k29c76w8v', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-ne-023.jpg', '31', '30', 1, 1),
(98, 'Feature FEc10', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2g44zm2g', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-e-080.jpg', '31', '30', 1, 1),
(99, 'Feature p1', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2j10b09d', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-est-005.jpg', '31', '30', 1, 1),
(100, 'ST South Colonnade', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2377mq9t', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/BW-Photos/bw01443.jpg', '31', '30', 1, 1),
(101, 'Terrace 1', 'Site', 'https://opencontext.org/static/oc/icons-v2/noun-trowel-3586734.svg', 'https://n2t.net/ark:/28722/k2fb5bg7s', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/BW-Photos/bw00908.jpg', '31', '30', 1, 1),
(102, 'Feature FNEc14', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2jq17q9v', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/101-drawing-d-ne-003.jpg', '31', '30', 1, 1),
(103, 'Feature FNEc18', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2hq46v0q', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-ne-028.jpg', '31', '30', 1, 1),
(104, 'ST North Corridor', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2cn7cv6w', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Color-Photos/022642.jpg', '31', '30', 1, 1),
(105, 'Feature FNEc5', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2d50ws9g', 'https://opencontext.org/static/oc/images/icons/pdf-noun-89522.png', '31', '30', 1, 1),
(106, 'ST South Entrance', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2zg6x35b', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/BW-Photos/bw01805.jpg', '31', '30', 1, 1),
(107, 'GII.VT Causeway Corridor', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2kh0vv2k', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-kvt-004.jpg', '31', '30', 1, 1),
(108, 'South of Khafre Valley Temple', 'Site', 'https://opencontext.org/static/oc/icons-v2/noun-trowel-3586734.svg', 'https://n2t.net/ark:/28722/k2xg9w68j', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-kvt-005.jpg', '31', '30', 1, 1),
(109, 'West of Khafre Valley Temple', 'Site', 'https://opencontext.org/static/oc/icons-v2/noun-trowel-3586734.svg', 'https://n2t.net/ark:/28722/k2h420h3k', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings-B/d-gen-039.jpg', '31', '30', 1, 1),
(110, 'Removal 12', 'Trench', 'https://opencontext.org/static/oc/icons-v2/oc-trench-icon.svg', 'https://n2t.net/ark:/28722/k29w0qv3q', 'https://opencontext.org/static/oc/images/icons/pdf-noun-89522.png', '31', '30', 1, 1),
(111, 'Feature FNa2', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2jw8nh62', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/101-drawing-d-n-002.jpg', '31', '30', 1, 1),
(112, 'Feature FNEc8', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k23n2f93q', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-ne-024.jpg', '31', '30', 1, 1),
(113, 'ST North Entrance', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2474nn1n', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/BW-Photos/bw01806.jpg', '31', '30', 1, 1),
(114, 'Feature FEc7', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2v98dn1g', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/BW-Photos/bw01733.jpg', '31', '30', 1, 1),
(115, 'Feature FNEd8', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2000dw3p', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-ne-012.jpg', '31', '30', 1, 1),
(116, 'Feature FNEh12', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k2z03d49j', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-ne-022.jpg', '31', '30', 1, 1),
(117, 'Feature FNEh11', 'Feature', 'https://opencontext.org/static/oc/icons-v2/noun-trowl-foundation-4804020.svg', 'https://n2t.net/ark:/28722/k26d6467m', 'https://artiraq.org/static/opencontext/giza-sphinx/thumbs/Drawings/d-ne-031.jpg', '31', '30', 1, 1),
(118, 'Squares N6-N7, E26-E27', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2zc86q5f', '', '31', '30', 1, 1),
(119, 'Squares N6-N7, E27', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2tm7gx0t', '', '31', '30', 1, 1),
(120, 'Square N3, E8', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2m333596', '', '31', '30', 1, 1),
(121, 'Square N6, E15', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k23206z46', '', '31', '30', 1, 1),
(122, 'Square N5, E23', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2bk1nk3w', '', '31', '30', 1, 1),
(123, 'Square N6, E13', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k26t0xs07', '', '31', '30', 1, 1),
(124, 'Square N4, E20', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2gb2cc6j', '', '31', '30', 1, 1),
(125, 'North Amphitheater', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k20k2n707', '', '31', '30', 1, 1),
(126, 'GII.VT Roof Terrace North', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k25b0cx65', '', '31', '30', 1, 1),
(127, 'GII.VT Porter Room', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2pc38528', '', '31', '30', 1, 1),
(128, 'GII.VT Magazine 3 a-b', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2697dt3d', '', '31', '30', 1, 1),
(129, 'GII.VT Magazine 1 a-b', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2ft8vf1m', '', '31', '30', 1, 1),
(130, 'GII.VT Magazine 2 a-b', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k2b284m81', '', '31', '30', 1, 1),
(131, 'GII.VT Roof Terrace East', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k29313q9t', '', '31', '30', 1, 1),
(132, 'GII.VT Roof Terrace Perimeter', 'Area', 'https://opencontext.org/static/oc/icons-v2/noun-area-ground-1283937.svg', 'https://n2t.net/ark:/28722/k21j9p42w', '', '31', '30', 1, 1),
(133, 'Mausoleum of Ibrahim al-Kulshani', 'Image media', 'http://opencontext.org/media/46e574ee-6d60-4c9c-8d1e-85466eef40dc', 'https://n2t.net/ark:/28722/k2z03hx17', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.016.jpg', '31', '30', 2, 2),
(134, 'Mausoleum of Ibrahim al-Kulshani', 'Image media', 'http://opencontext.org/media/6d716b91-2aac-4844-9395-c95a6c794c9a', 'https://n2t.net/ark:/28722/k2tt51f5w', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.139.jpg', '31', '30', 2, 2),
(135, 'Mausoleum of Ibrahim al-Kulshani', 'Image media', 'http://opencontext.org/media/f71c277d-868a-4978-a085-72769c5b27fd', 'https://n2t.net/ark:/28722/k2b56zs4j', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.019.jpg', '31', '30', 2, 2),
(136, 'Fakahani Mosque', 'Image media', 'http://opencontext.org/media/9395a81b-623b-4c8d-856e-3a3e943e865c', 'https://n2t.net/ark:/28722/k2xp7dr3t', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.163.jpg', '31', '30', 2, 2),
(137, 'Mausoleum of Ibrahim al-Kulshani', 'Image media', 'http://opencontext.org/media/af1117fb-84b4-49ce-921c-6e8350ea7e9f', 'https://n2t.net/ark:/28722/k22n5j54g', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.017.jpg', '31', '30', 2, 2),
(138, 'Mausoleum of Ibrahim al-Kulshani', 'Image media', 'http://opencontext.org/media/b71eb738-28b4-4108-b209-4aabb78e1b04', 'https://n2t.net/ark:/28722/k2zw1vd9q', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.024.jpg', '31', '30', 2, 2),
(139, 'Sabil-kuttab of Shaykh Mutahhar', 'Image media', 'http://opencontext.org/media/efe63395-1e6f-4170-ab07-9351fd022d9c', 'https://n2t.net/ark:/28722/k2df74r00', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.097.jpg', '31', '30', 2, 2),
(140, 'Fakahani Mosque', 'Image media', 'http://opencontext.org/media/1618a5be-1b8f-4c30-b275-de3c8549121d', 'https://n2t.net/ark:/28722/k2902j37h', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.158.jpg', '31', '30', 2, 2),
(141, 'Mausoleum of Ibrahim al-Kulshani', 'Image media', 'http://opencontext.org/media/0325fbda-d555-4897-90ab-185967037082', 'https://n2t.net/ark:/28722/k2fx7pk7w', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.020.jpg', '31', '30', 2, 2),
(142, 'Fakahani Mosque', 'Image media', 'http://opencontext.org/media/5f541563-5703-4455-b41f-e5b96d6e8944', 'https://n2t.net/ark:/28722/k2dr37w9z', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.159.jpg', '31', '30', 2, 2),
(143, 'Sabil-kuttab of Yusuf Agha Dar al-Sa’ada', 'Image media', 'http://opencontext.org/media/0b32f0b5-39b0-4f1b-a69c-3c1e8639bab8', 'https://n2t.net/ark:/28722/k22239t6f', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.071.jpg', '31', '30', 2, 2),
(144, 'Fakahani Mosque', 'Image media', 'http://opencontext.org/media/b0c2b123-dd98-4312-8354-f54151fc3d42', 'https://n2t.net/ark:/28722/k2hq4bm3p', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.005.jpg', '31', '30', 2, 2),
(145, 'Mausoleum of Ibrahim al-Kulshani', 'Image media', 'http://opencontext.org/media/4a3e7825-0094-4f6a-b536-335f2ff8dad6', 'https://n2t.net/ark:/28722/k2jq1ch0g', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.013.jpg', '31', '30', 2, 2),
(146, 'Sabil-kuttab of Yusuf Agha Dar al-Sa’ada', 'Image media', 'http://opencontext.org/media/33c41863-84f2-4ebe-b0bc-b8055707482f', 'https://n2t.net/ark:/28722/k25q5b76g', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.072.jpg', '31', '30', 2, 2),
(147, 'Fakahani sabil', 'Image media', 'http://opencontext.org/media/85f2f93e-2388-4a1e-a186-ed542f476bb6', 'https://n2t.net/ark:/28722/k2r21bj2s', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.146.jpg', '31', '30', 2, 2),
(148, 'Mausoleum of Ibrahim al-Kulshani', 'Image media', 'http://opencontext.org/media/96cd1a0c-fc7c-42fb-9940-7a24d907c25a', 'https://n2t.net/ark:/28722/k2wq0cv15', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.155.jpg', '31', '30', 2, 2),
(149, 'Mosque of Ahmad al-Dardir', 'Image media', 'http://opencontext.org/media/e370cf8f-340e-4f1c-b67b-416f1b46d79a', 'https://n2t.net/ark:/28722/k2p278r48', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.130.jpg', '31', '30', 2, 2),
(150, 'Mausoleum of Ibrahim al-Kulshani', 'Image media', 'http://opencontext.org/media/4de54fec-5d4a-4b16-aff3-87c345f83632', 'https://n2t.net/ark:/28722/k2zk5r79n', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.140.jpg', '31', '30', 2, 2),
(151, 'Mosque of Muhammad Bey Abu al-Dhahab', 'Image media', 'http://opencontext.org/media/3e101b53-a3d8-480f-a328-c884e0c8ce06', 'https://n2t.net/ark:/28722/k21c2d34q', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.125.jpg', '31', '30', 2, 2),
(152, 'Fakahani Mosque', 'Image media', 'http://opencontext.org/media/88585c4c-31c7-48aa-a1a3-5e20674dac5c', 'https://n2t.net/ark:/28722/k2p84ph8z', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.161.jpg', '31', '30', 2, 2),
(153, 'Mosque of Muhammad Bey Abu al-Dhahab', 'Image media', 'http://opencontext.org/media/09775ae0-7e9e-456c-a567-5ba01bd7b5f5', 'https://n2t.net/ark:/28722/k2xk8qb9d', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.132.jpg', '31', '30', 2, 2),
(154, 'Sabil-kuttab of Abu al-Iqbal ‘Arifin Bey', 'Image media', 'http://opencontext.org/media/7a71bb69-a0e8-4d3d-a2d8-24bfa61dca32', 'https://n2t.net/ark:/28722/k29c7bn9v', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.042.jpg', '31', '30', 2, 2),
(155, 'Fakahani Mosque', 'Image media', 'http://opencontext.org/media/ba57dfbf-9d75-463c-8bc9-d06c8c35a3c2', 'https://n2t.net/ark:/28722/k2sx6px8k', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.162.jpg', '31', '30', 2, 2),
(156, 'Mausoleum of Ibrahim al-Kulshani', 'Image media', 'http://opencontext.org/media/f15929b2-e69b-4af6-90dd-626f51c891b3', 'https://n2t.net/ark:/28722/k2377rg9b', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.141.jpg', '31', '30', 2, 2),
(157, 'Fakahani Mosque', 'Image media', 'http://opencontext.org/media/e6fea776-c79c-4efa-a301-c2a0debe3cd7', 'https://n2t.net/ark:/28722/k2cz3ms7z', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.004.jpg', '31', '30', 2, 2),
(158, 'Fakahani Mosque', 'Image media', 'http://opencontext.org/media/b19fe8c1-dea4-4135-8bc7-36925912315b', 'https://n2t.net/ark:/28722/k2m90mq81', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.145.jpg', '31', '30', 2, 2),
(159, 'Mosque of Muhammad Bey Abu al-Dhahab', 'Image media', 'http://opencontext.org/media/731f2956-d334-42fa-9fd3-c4cf234db57a', 'https://n2t.net/ark:/28722/k2611fd4w', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.134.jpg', '31', '30', 2, 2),
(160, 'Mausoleum of Ibrahim al-Kulshani', 'Image media', 'http://opencontext.org/media/f8212595-40b1-40db-9659-5863a860e9b8', 'https://n2t.net/ark:/28722/k2t72t37w', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.015.jpg', '31', '30', 2, 2),
(161, 'Sabil-kuttab of Abu al-Iqbal ‘Arifin Bey', 'Image media', 'http://opencontext.org/media/7f03b675-d853-4afa-9be5-950b696595ca', 'https://n2t.net/ark:/28722/k25m6mv66', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.041.jpg', '31', '30', 2, 2),
(162, 'Fakahani Mosque', 'Image media', 'http://opencontext.org/media/83648792-cc4d-413f-b71a-c8d01d92d958', 'https://n2t.net/ark:/28722/k22f84d0s', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.164.jpg', '31', '30', 2, 2),
(163, 'Fakahani Mosque', 'Image media', 'http://opencontext.org/media/49defa24-2cc0-45d1-9a5e-84331ac39691', 'https://n2t.net/ark:/28722/k2862x022', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.003.jpg', '31', '30', 2, 2),
(164, 'Sabil-kuttab of Khalil Efendi al-Muqati’ji', 'Image media', 'http://opencontext.org/media/e5da411b-a795-4044-bcdf-b7f6ab58a2b0', 'https://n2t.net/ark:/28722/k2rj4vg9f', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.061.jpg', '31', '30', 2, 2),
(165, 'Sabil-kuttab of Yusuf Agha Dar al-Sa’ada', 'Image media', 'http://opencontext.org/media/7f0940eb-d639-4507-8777-ba65639035cb', 'https://n2t.net/ark:/28722/k2x92m61g', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.070.jpg', '31', '30', 2, 2),
(166, 'Zawiyya of Faraj ibn Barquq', 'Image media', 'http://opencontext.org/media/b58bbc50-40c0-4273-ac9c-b4562c287fd1', 'https://n2t.net/ark:/28722/k2ms44p5p', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.060.jpg', '31', '30', 2, 2),
(167, 'Mausoleum of Ibrahim al-Kulshani', 'Image media', 'http://opencontext.org/media/1f68adf7-8112-4b72-b01c-13f7b6547c11', 'https://n2t.net/ark:/28722/k26d67z9p', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.018.jpg', '31', '30', 2, 2),
(168, 'Mausoleum of Ibrahim al-Kulshani', 'Image media', 'http://opencontext.org/media/e1763398-d820-4219-b753-65acb2bc645e', 'https://n2t.net/ark:/28722/k2pg2392n', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.014.jpg', '31', '30', 2, 2),
(169, 'Sabil-kuttab of Yusuf Agha Dar al-Sa’ada', 'Image media', 'http://opencontext.org/media/f4771bae-9c8f-4607-8dc0-16e4cbbd2990', 'https://n2t.net/ark:/28722/k2sj1wc7q', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.069.jpg', '31', '30', 2, 2),
(170, 'Mosque of Muhammad Bey Abu al-Dhahab', 'Image media', 'http://opencontext.org/media/a4ea2174-2f0b-4855-9c50-3a13d08be2d2', 'https://n2t.net/ark:/28722/k22b9f05w', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.133.jpg', '31', '30', 2, 2),
(171, 'Fakahani Mosque', 'Image media', 'http://opencontext.org/media/7573bf6d-23fc-408d-86d7-1fd8cd159d99', 'https://n2t.net/ark:/28722/k2805h68r', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.150.jpg', '31', '30', 2, 2),
(172, 'Mausoleum of Ibrahim al-Kulshani', 'Image media', 'http://opencontext.org/media/f030b145-6598-470a-94df-e97d84aaf503', 'https://n2t.net/ark:/28722/k28p6dx7q', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.096.jpg', '31', '30', 2, 2),
(173, 'Fakahani Mosque', 'Image media', 'http://opencontext.org/media/962a1aec-6875-4ba1-94cb-779a7ae48be5', 'https://n2t.net/ark:/28722/k20s05r7v', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.001.jpg', '31', '30', 2, 2),
(174, 'Fakahani Mosque', 'Image media', 'http://opencontext.org/media/960a5fa2-9be4-44f5-b677-34195649b352', 'https://n2t.net/ark:/28722/k2gh9wx69', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.144.jpg', '31', '30', 2, 2),
(175, 'Fakahani Mosque', 'Image media', 'http://opencontext.org/media/f396aacc-9385-4bb3-8c60-f16f2bc721b1', 'https://n2t.net/ark:/28722/k2vt22b73', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.147.jpg', '31', '30', 2, 2),
(176, 'Sabil-kuttab of Abu al-Iqbal ‘Arifin Bey', 'Image media', 'http://opencontext.org/media/67b4ef21-c487-4206-bf86-0b3d996ef5c9', 'https://n2t.net/ark:/28722/k2f482g3m', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.043.jpg', '31', '30', 2, 2),
(177, 'Fakahani Mosque', 'Image media', 'http://opencontext.org/media/240c781c-d1b8-4159-a7f4-56135ec6d59f', 'https://n2t.net/ark:/28722/k2br96400', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.143.jpg', '31', '30', 2, 2),
(178, 'Fakahani Mosque', 'Image media', 'http://opencontext.org/media/bf07127a-5f79-451d-a4bb-f5b89f083a9e', 'https://n2t.net/ark:/28722/k24j0wk2q', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.002.jpg', '31', '30', 2, 2),
(179, '', 'Structure', 'http://opencontext.org/subjects/71fe2d88-2070-4037-a5e0-7da4d4f38c02', 'https://n2t.net/ark:/28722/k21g13g71', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.164.jpg', '31', '30', 2, 2),
(180, 'Fakahani Mosque', 'Image media', 'http://opencontext.org/media/a7c099d0-ffa4-44f6-8c7e-0c05c9fa3a07', 'https://n2t.net/ark:/28722/k2jh3zq3b', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.160.jpg', '31', '30', 2, 2),
(181, '', 'Structure', 'http://opencontext.org/subjects/b5719db3-c843-466c-a9e0-4a584b7c7482', 'https://n2t.net/ark:/28722/k22b9f06c', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.155.jpg', '31', '30', 2, 2),
(182, 'Fakahani Mosque', 'Image media', 'http://opencontext.org/media/5217e04a-21d9-45be-a351-5f3dd873bad2', 'https://n2t.net/ark:/28722/k20g42k88', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.148.jpg', '31', '30', 2, 2),
(183, 'Mausoleum of Ibrahim al-Kulshani', 'Image media', 'http://opencontext.org/media/20d84f93-3233-45be-9e44-a1557abc4a2a', 'https://n2t.net/ark:/28722/k2dz0np76', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.012.jpg', '31', '30', 2, 2),
(184, '', 'Structure', 'http://opencontext.org/subjects/91888aea-d626-4f8b-a00b-6f9f77df349a', 'https://n2t.net/ark:/28722/k23b6fw66', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.134.jpg', '31', '30', 2, 2),
(185, '', 'Structure', 'http://opencontext.org/subjects/c2c95aba-06ff-4024-acd5-98e879da239b', 'https://n2t.net/ark:/28722/k2dv1z95c', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.072.jpg', '31', '30', 2, 2),
(186, '', 'Structure', 'http://opencontext.org/subjects/1e4fa022-63a8-4ed6-b683-5005cbdb62c3', 'https://n2t.net/ark:/28722/k2mc9b41t', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.043.jpg', '31', '30', 2, 2),
(187, '', 'Structure', 'http://opencontext.org/subjects/75ff1c68-dd0a-4280-ad75-13e105ff5707', 'https://n2t.net/ark:/28722/k2cv4xd35', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.061.jpg', '31', '30', 2, 2),
(188, '', 'Structure', 'http://opencontext.org/subjects/77b5fa89-a0e7-40af-b02e-99adcf1c1efd', 'https://n2t.net/ark:/28722/k2ws93788', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.097.jpg', '31', '30', 2, 2),
(189, '', 'Structure', 'http://opencontext.org/subjects/69aecb06-d829-4606-a781-99322f4af8c2', 'https://n2t.net/ark:/28722/k2r78r99c', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.060.jpg', '31', '30', 2, 2),
(190, '', 'Structure', 'http://opencontext.org/subjects/93b968de-f53e-4fcf-aa3b-faa2bca43d9e', 'https://n2t.net/ark:/28722/k2q53116r', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.130.jpg', '31', '30', 2, 2),
(191, '', 'Structure', 'http://opencontext.org/subjects/027252f6-c444-4095-8e4e-8a7b97651e5a', 'https://n2t.net/ark:/28722/k25433w9x', 'https://artiraq.org/static/opencontext/ottoman-tiles-fakahani-mosque/thumbs/Fig.146.jpg', '31', '30', 2, 2);

-- --------------------------------------------------------

--
-- Table structure for table `RESEARCH`
--

CREATE TABLE `RESEARCH` (
  `EXCAVATION_ID` int(11) NOT NULL DEFAULT '0',
  `UPDATE_DATE` date DEFAULT NULL,
  `PUBLISHED_DATE` date DEFAULT NULL,
  `RESEARCH_ID` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `RESEARCHER`
--

CREATE TABLE `RESEARCHER` (
  `RESEARCHER_ID` int(11) NOT NULL,
  `PASSWORD` varchar(128) NOT NULL,
  `URL` text,
  `USERNAME` text,
  `PHONE_NUMBER` text,
  `MAIL_ADDRESS` text,
  `EMAIL_ADDRESS` text,
  `START_DATE` date DEFAULT NULL,
  `EXCAVATION_ID` int(11) DEFAULT NULL,
  `MANAGER` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `RESEARCHER`
--

INSERT INTO `RESEARCHER` (`RESEARCHER_ID`, `PASSWORD`, `URL`, `USERNAME`, `PHONE_NUMBER`, `MAIL_ADDRESS`, `EMAIL_ADDRESS`, `START_DATE`, `EXCAVATION_ID`, `MANAGER`) VALUES
(2, 'pbkdf2:sha256:600000$SoYQe7LPfMLUpYta$3e9fa6f11c6c7f9f96b86630edeb52b4020e2e44623037c40df51a8c4d099a11', '', 'testUser', '', 'test@vt.edu', '', '2025-04-28', 1, 1),
(9, 'pbkdf2:sha256:600000$bG6TSymWhEFSCeom$3e93b8452665461b9fe612dc0b0831a7ee59a7cce8c5819ffaa044f39faf40b8', NULL, 'omera', '5717236378', 'Blacksburg, VA', 'omera@vt.edu', '2005-02-06', 1, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ARCHAEOLOGIST`
--
ALTER TABLE `ARCHAEOLOGIST`
  ADD PRIMARY KEY (`ARCHAEOLOGIST_ID`),
  ADD KEY `EXCAVATION_ID` (`EXCAVATION_ID`);

--
-- Indexes for table `CITY`
--
ALTER TABLE `CITY`
  ADD PRIMARY KEY (`CITY_ID`);

--
-- Indexes for table `CONTEXT`
--
ALTER TABLE `CONTEXT`
  ADD PRIMARY KEY (`CONTEXT`(255)),
  ADD KEY `MONUMENT_ID` (`MONUMENT_ID`);

--
-- Indexes for table `EXCAVATION_PROJECT`
--
ALTER TABLE `EXCAVATION_PROJECT`
  ADD PRIMARY KEY (`EXCAVATION_ID`),
  ADD KEY `CITY_ID` (`CITY_ID`);

--
-- Indexes for table `MONUMENT`
--
ALTER TABLE `MONUMENT`
  ADD PRIMARY KEY (`MONUMENT_ID`),
  ADD KEY `CITY_ID` (`CITY_ID`),
  ADD KEY `EXCAVATION_ID` (`EXCAVATION_ID`);

--
-- Indexes for table `RESEARCH`
--
ALTER TABLE `RESEARCH`
  ADD PRIMARY KEY (`RESEARCH_ID`,`EXCAVATION_ID`),
  ADD KEY `EXCAVATION_ID` (`EXCAVATION_ID`);

--
-- Indexes for table `RESEARCHER`
--
ALTER TABLE `RESEARCHER`
  ADD PRIMARY KEY (`RESEARCHER_ID`),
  ADD KEY `EXCAVATION_ID` (`EXCAVATION_ID`),
  ADD KEY `MANAGER` (`MANAGER`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `ARCHAEOLOGIST`
--
ALTER TABLE `ARCHAEOLOGIST`
  MODIFY `ARCHAEOLOGIST_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- AUTO_INCREMENT for table `RESEARCHER`
--
ALTER TABLE `RESEARCHER`
  MODIFY `RESEARCHER_ID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `ARCHAEOLOGIST`
--
ALTER TABLE `ARCHAEOLOGIST`
  ADD CONSTRAINT `ARCHAEOLOGIST_ibfk_1` FOREIGN KEY (`EXCAVATION_ID`) REFERENCES `EXCAVATION_PROJECT` (`EXCAVATION_ID`);

--
-- Constraints for table `CONTEXT`
--
ALTER TABLE `CONTEXT`
  ADD CONSTRAINT `CONTEXT_ibfk_1` FOREIGN KEY (`MONUMENT_ID`) REFERENCES `MONUMENT` (`MONUMENT_ID`);

--
-- Constraints for table `EXCAVATION_PROJECT`
--
ALTER TABLE `EXCAVATION_PROJECT`
  ADD CONSTRAINT `EXCAVATION_PROJECT_ibfk_1` FOREIGN KEY (`CITY_ID`) REFERENCES `CITY` (`CITY_ID`);

--
-- Constraints for table `MONUMENT`
--
ALTER TABLE `MONUMENT`
  ADD CONSTRAINT `MONUMENT_ibfk_1` FOREIGN KEY (`CITY_ID`) REFERENCES `CITY` (`CITY_ID`),
  ADD CONSTRAINT `MONUMENT_ibfk_2` FOREIGN KEY (`EXCAVATION_ID`) REFERENCES `EXCAVATION_PROJECT` (`EXCAVATION_ID`);

--
-- Constraints for table `RESEARCH`
--
ALTER TABLE `RESEARCH`
  ADD CONSTRAINT `RESEARCH_ibfk_1` FOREIGN KEY (`EXCAVATION_ID`) REFERENCES `EXCAVATION_PROJECT` (`EXCAVATION_ID`);

--
-- Constraints for table `RESEARCHER`
--
ALTER TABLE `RESEARCHER`
  ADD CONSTRAINT `RESEARCHER_ibfk_1` FOREIGN KEY (`EXCAVATION_ID`) REFERENCES `EXCAVATION_PROJECT` (`EXCAVATION_ID`),
  ADD CONSTRAINT `RESEARCHER_ibfk_2` FOREIGN KEY (`MANAGER`) REFERENCES `ARCHAEOLOGIST` (`ARCHAEOLOGIST_ID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
