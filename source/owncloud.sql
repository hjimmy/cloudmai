-- MySQL dump 10.13  Distrib 5.1.73, for redhat-linux-gnu (x86_64)
--
-- Host: localhost    Database: owncloud
-- ------------------------------------------------------
-- Server version	5.1.73

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `oc_activity`
--

DROP TABLE IF EXISTS `oc_activity`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_activity` (
  `activity_id` int(11) NOT NULL AUTO_INCREMENT,
  `timestamp` int(11) NOT NULL DEFAULT '0',
  `priority` int(11) NOT NULL DEFAULT '0',
  `type` int(11) NOT NULL DEFAULT '0',
  `user` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `affecteduser` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `app` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `subject` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `subjectparams` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `message` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `messageparams` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `link` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`activity_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_activity`
--

LOCK TABLES `oc_activity` WRITE;
/*!40000 ALTER TABLE `oc_activity` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_activity` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_appconfig`
--

DROP TABLE IF EXISTS `oc_appconfig`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_appconfig` (
  `appid` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `configkey` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `configvalue` longtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (`appid`,`configkey`),
  KEY `appconfig_config_key_index` (`configkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_appconfig`
--

LOCK TABLES `oc_appconfig` WRITE;
/*!40000 ALTER TABLE `oc_appconfig` DISABLE KEYS */;
INSERT INTO `oc_appconfig` VALUES ('activity','enabled','yes'),('activity','installed_version','1.1.2'),('activity','types','filesystem'),('backgroundjob','lastjob','2'),('calendar','enabled','yes'),('calendar','installed_version','0.6.3'),('calendar','types',''),('contacts','enabled','yes'),('contacts','installed_version','0.3'),('contacts','types',''),('core','global_cache_gc_lastrun','1449653359'),('core','installedat','1449653351.6264'),('core','lastupdatedat','1449653351.6578'),('core','public_caldav','calendar/share.php'),('core','public_calendar','calendar/share.php'),('core','public_documents','documents/public.php'),('core','public_files','files_sharing/public.php'),('core','public_gallery','gallery/public.php'),('core','public_webdav','files_sharing/public.php'),('core','remote_caldav','calendar/appinfo/remote.php'),('core','remote_calendar','calendar/appinfo/remote.php'),('core','remote_carddav','contacts/appinfo/remote.php'),('core','remote_contacts','contacts/appinfo/remote.php'),('core','remote_core.css','/core/minimizer.php'),('core','remote_core.js','/core/minimizer.php'),('core','remote_files','files/appinfo/remote.php'),('core','remote_filesync','files/appinfo/filesync.php'),('core','remote_webdav','files/appinfo/remote.php'),('documents','enabled','yes'),('documents','installed_version','0.8.1'),('documents','types',''),('files','backgroundwatcher_previous_file','6'),('files','backgroundwatcher_previous_folder','1'),('files','enabled','yes'),('files','installed_version','1.1.7'),('files','types','filesystem'),('files_pdfviewer','enabled','yes'),('files_pdfviewer','installed_version','0.3'),('files_pdfviewer','types',''),('files_sharing','enabled','yes'),('files_sharing','installed_version','0.3.5'),('files_sharing','types','filesystem'),('files_texteditor','enabled','yes'),('files_texteditor','installed_version','0.3'),('files_texteditor','types',''),('files_trashbin','enabled','yes'),('files_trashbin','installed_version','0.5'),('files_trashbin','types','filesystem'),('files_versions','enabled','yes'),('files_versions','installed_version','1.0.3'),('files_versions','types','filesystem'),('files_videoviewer','enabled','yes'),('files_videoviewer','installed_version','0.1.2'),('files_videoviewer','types',''),('firstrunwizard','enabled','yes'),('firstrunwizard','installed_version','1.0'),('firstrunwizard','types',''),('gallery','enabled','yes'),('gallery','installed_version','0.5.3'),('gallery','types','filesystem'),('search_lucene','enabled','yes'),('search_lucene','installed_version','0.5.2'),('search_lucene','types','filesystem'),('updater','enabled','yes'),('updater','installed_version','0.3.1'),('updater','types','');
/*!40000 ALTER TABLE `oc_appconfig` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_clndr_calendars`
--

DROP TABLE IF EXISTS `oc_clndr_calendars`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_clndr_calendars` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `userid` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `displayname` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `uri` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `active` int(11) NOT NULL DEFAULT '1',
  `ctag` int(10) unsigned NOT NULL DEFAULT '0',
  `calendarorder` int(10) unsigned NOT NULL DEFAULT '0',
  `calendarcolor` varchar(10) COLLATE utf8_unicode_ci DEFAULT NULL,
  `timezone` longtext COLLATE utf8_unicode_ci,
  `components` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_clndr_calendars`
--

LOCK TABLES `oc_clndr_calendars` WRITE;
/*!40000 ALTER TABLE `oc_clndr_calendars` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_clndr_calendars` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_clndr_objects`
--

DROP TABLE IF EXISTS `oc_clndr_objects`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_clndr_objects` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `calendarid` int(10) unsigned NOT NULL DEFAULT '0',
  `objecttype` varchar(40) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `startdate` datetime DEFAULT '1970-01-01 00:00:00',
  `enddate` datetime DEFAULT '1970-01-01 00:00:00',
  `repeating` int(11) DEFAULT '0',
  `summary` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `calendardata` longtext COLLATE utf8_unicode_ci,
  `uri` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastmodified` int(11) DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_clndr_objects`
--

LOCK TABLES `oc_clndr_objects` WRITE;
/*!40000 ALTER TABLE `oc_clndr_objects` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_clndr_objects` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_clndr_repeat`
--

DROP TABLE IF EXISTS `oc_clndr_repeat`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_clndr_repeat` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `eventid` int(10) unsigned NOT NULL DEFAULT '0',
  `calid` int(10) unsigned NOT NULL DEFAULT '0',
  `startdate` datetime DEFAULT '1970-01-01 00:00:00',
  `enddate` datetime DEFAULT '1970-01-01 00:00:00',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_clndr_repeat`
--

LOCK TABLES `oc_clndr_repeat` WRITE;
/*!40000 ALTER TABLE `oc_clndr_repeat` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_clndr_repeat` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_clndr_share_calendar`
--

DROP TABLE IF EXISTS `oc_clndr_share_calendar`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_clndr_share_calendar` (
  `owner` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `share` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `sharetype` varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  `calendarid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `permissions` smallint(6) NOT NULL,
  `active` int(11) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_clndr_share_calendar`
--

LOCK TABLES `oc_clndr_share_calendar` WRITE;
/*!40000 ALTER TABLE `oc_clndr_share_calendar` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_clndr_share_calendar` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_clndr_share_event`
--

DROP TABLE IF EXISTS `oc_clndr_share_event`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_clndr_share_event` (
  `owner` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `share` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `sharetype` varchar(6) COLLATE utf8_unicode_ci NOT NULL,
  `eventid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `permissions` smallint(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_clndr_share_event`
--

LOCK TABLES `oc_clndr_share_event` WRITE;
/*!40000 ALTER TABLE `oc_clndr_share_event` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_clndr_share_event` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_contacts_addressbooks`
--

DROP TABLE IF EXISTS `oc_contacts_addressbooks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_contacts_addressbooks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `userid` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `displayname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `uri` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `ctag` int(10) unsigned NOT NULL DEFAULT '1',
  `active` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_contacts_addressbooks`
--

LOCK TABLES `oc_contacts_addressbooks` WRITE;
/*!40000 ALTER TABLE `oc_contacts_addressbooks` DISABLE KEYS */;
INSERT INTO `oc_contacts_addressbooks` VALUES (1,'admin','联系人','联系人','',1449653355,1);
/*!40000 ALTER TABLE `oc_contacts_addressbooks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_contacts_cards`
--

DROP TABLE IF EXISTS `oc_contacts_cards`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_contacts_cards` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `addressbookid` int(10) unsigned NOT NULL DEFAULT '0',
  `fullname` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `carddata` longtext COLLATE utf8_unicode_ci,
  `uri` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL,
  `lastmodified` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_contacts_cards`
--

LOCK TABLES `oc_contacts_cards` WRITE;
/*!40000 ALTER TABLE `oc_contacts_cards` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_contacts_cards` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_contacts_cards_properties`
--

DROP TABLE IF EXISTS `oc_contacts_cards_properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_contacts_cards_properties` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `userid` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `contactid` int(10) unsigned NOT NULL DEFAULT '0',
  `name` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `value` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `preferred` int(11) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `cp_name_index` (`name`),
  KEY `cp_value_index` (`value`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_contacts_cards_properties`
--

LOCK TABLES `oc_contacts_cards_properties` WRITE;
/*!40000 ALTER TABLE `oc_contacts_cards_properties` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_contacts_cards_properties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_documents_invite`
--

DROP TABLE IF EXISTS `oc_documents_invite`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_documents_invite` (
  `es_id` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `uid` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `status` smallint(6) DEFAULT '0',
  `sent_on` int(10) unsigned DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_documents_invite`
--

LOCK TABLES `oc_documents_invite` WRITE;
/*!40000 ALTER TABLE `oc_documents_invite` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_documents_invite` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_documents_member`
--

DROP TABLE IF EXISTS `oc_documents_member`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_documents_member` (
  `member_id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `es_id` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `uid` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `color` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `last_activity` int(10) unsigned NOT NULL,
  `is_guest` smallint(5) unsigned NOT NULL DEFAULT '0',
  `token` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `status` smallint(5) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`member_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_documents_member`
--

LOCK TABLES `oc_documents_member` WRITE;
/*!40000 ALTER TABLE `oc_documents_member` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_documents_member` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_documents_op`
--

DROP TABLE IF EXISTS `oc_documents_op`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_documents_op` (
  `seq` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `es_id` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `member` int(10) unsigned NOT NULL DEFAULT '1',
  `opspec` longtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (`seq`),
  UNIQUE KEY `documents_op_eis_idx` (`es_id`,`seq`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_documents_op`
--

LOCK TABLES `oc_documents_op` WRITE;
/*!40000 ALTER TABLE `oc_documents_op` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_documents_op` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_documents_revisions`
--

DROP TABLE IF EXISTS `oc_documents_revisions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_documents_revisions` (
  `es_id` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `seq_head` int(10) unsigned NOT NULL,
  `member_id` int(10) unsigned NOT NULL,
  `file_id` varchar(512) COLLATE utf8_unicode_ci NOT NULL,
  `save_hash` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  UNIQUE KEY `documents_rev_eis_idx` (`es_id`,`seq_head`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_documents_revisions`
--

LOCK TABLES `oc_documents_revisions` WRITE;
/*!40000 ALTER TABLE `oc_documents_revisions` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_documents_revisions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_documents_session`
--

DROP TABLE IF EXISTS `oc_documents_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_documents_session` (
  `es_id` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `genesis_url` varchar(512) COLLATE utf8_unicode_ci NOT NULL,
  `genesis_hash` varchar(128) COLLATE utf8_unicode_ci NOT NULL,
  `file_id` varchar(512) COLLATE utf8_unicode_ci NOT NULL,
  `owner` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`es_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_documents_session`
--

LOCK TABLES `oc_documents_session` WRITE;
/*!40000 ALTER TABLE `oc_documents_session` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_documents_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_file_map`
--

DROP TABLE IF EXISTS `oc_file_map`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_file_map` (
  `logic_path` varchar(512) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `logic_path_hash` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `physic_path` varchar(512) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `physic_path_hash` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`logic_path_hash`),
  UNIQUE KEY `file_map_pp_index` (`physic_path_hash`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_file_map`
--

LOCK TABLES `oc_file_map` WRITE;
/*!40000 ALTER TABLE `oc_file_map` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_file_map` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_filecache`
--

DROP TABLE IF EXISTS `oc_filecache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_filecache` (
  `fileid` int(11) NOT NULL AUTO_INCREMENT,
  `storage` int(11) NOT NULL DEFAULT '0',
  `path` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL,
  `path_hash` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `parent` int(11) NOT NULL DEFAULT '0',
  `name` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mimetype` int(11) NOT NULL DEFAULT '0',
  `mimepart` int(11) NOT NULL DEFAULT '0',
  `size` bigint(20) NOT NULL DEFAULT '0',
  `mtime` int(11) NOT NULL DEFAULT '0',
  `storage_mtime` int(11) NOT NULL DEFAULT '0',
  `encrypted` int(11) NOT NULL DEFAULT '0',
  `unencrypted_size` bigint(20) NOT NULL DEFAULT '0',
  `etag` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`fileid`),
  UNIQUE KEY `fs_storage_path_hash` (`storage`,`path_hash`),
  KEY `fs_parent_name_hash` (`parent`,`name`),
  KEY `fs_storage_mimetype` (`storage`,`mimetype`),
  KEY `fs_storage_mimepart` (`storage`,`mimepart`)
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_filecache`
--

LOCK TABLES `oc_filecache` WRITE;
/*!40000 ALTER TABLE `oc_filecache` DISABLE KEYS */;
INSERT INTO `oc_filecache` VALUES (1,1,'','d41d8cd98f00b204e9800998ecf8427e',-1,'',2,1,6037392,1449653361,1449653355,0,0,'5667f47154301'),(2,1,'files','45b963397aa40d4a0063e0d85e4fe7a1',1,'files',2,1,6037392,1449653361,1449653355,0,0,'5667f471644f5'),(3,1,'files/music','1f8cfec283cd675038bb95b599fdc75a',2,'music',2,1,3764804,1449653361,1449653355,0,0,'5667f4717eb59'),(4,1,'files/documents','2d30f25cef1a92db784bc537e8bf128d',2,'documents',2,1,23383,1449653361,1449653355,0,0,'5667f47176a1b'),(5,1,'files/photos','923e51351db3e8726f22ba0fa1c04d5a',2,'photos',2,1,678556,1449653361,1449653355,0,0,'5667f47170c42'),(6,1,'files/ownCloudUserManual.pdf','c8edba2d1b8eb651c107b43532c34445',2,'ownCloudUserManual.pdf',4,3,1570649,1449653355,1449653355,0,0,'5667f46bee647'),(7,1,'files/photos/paris.jpg','65154b90b985bff20d4923f224ca1c33',5,'paris.jpg',6,5,228761,1449653355,1449653355,0,0,'5667f47014921'),(8,1,'files/photos/squirrel.jpg','e462c24fc17cb1a3fa3bca86d7f89593',5,'squirrel.jpg',6,5,233724,1449653355,1449653355,0,0,'5667f470159c2'),(9,1,'files/photos/san francisco.jpg','e86e87a4ecd557753734e1d34fbeecec',5,'san francisco.jpg',6,5,216071,1449653355,1449653355,0,0,'5667f47015ef5'),(10,1,'files/documents/example.odt','f51311bd6910ec7356d79286dcb24dec',4,'example.odt',7,3,23383,1449653355,1449653355,0,0,'5667f47037443'),(11,1,'files/music/projekteva-letitrain.mp3','da7d05a957a2bbbf0e74b12c1b5fcfee',3,'projekteva-letitrain.mp3',9,8,3764804,1449653355,1449653355,0,0,'5667f47057f68');
/*!40000 ALTER TABLE `oc_filecache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_files_trash`
--

DROP TABLE IF EXISTS `oc_files_trash`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_files_trash` (
  `id` varchar(250) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `user` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `timestamp` varchar(12) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `location` varchar(512) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `type` varchar(4) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `mime` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  KEY `id_index` (`id`),
  KEY `timestamp_index` (`timestamp`),
  KEY `user_index` (`user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_files_trash`
--

LOCK TABLES `oc_files_trash` WRITE;
/*!40000 ALTER TABLE `oc_files_trash` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_files_trash` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_files_trashsize`
--

DROP TABLE IF EXISTS `oc_files_trashsize`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_files_trashsize` (
  `user` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `size` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_files_trashsize`
--

LOCK TABLES `oc_files_trashsize` WRITE;
/*!40000 ALTER TABLE `oc_files_trashsize` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_files_trashsize` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_files_versions`
--

DROP TABLE IF EXISTS `oc_files_versions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_files_versions` (
  `user` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `size` varchar(50) COLLATE utf8_unicode_ci NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_files_versions`
--

LOCK TABLES `oc_files_versions` WRITE;
/*!40000 ALTER TABLE `oc_files_versions` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_files_versions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_gallery_sharing`
--

DROP TABLE IF EXISTS `oc_gallery_sharing`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_gallery_sharing` (
  `token` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `gallery_id` int(11) NOT NULL DEFAULT '0',
  `recursive` smallint(6) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_gallery_sharing`
--

LOCK TABLES `oc_gallery_sharing` WRITE;
/*!40000 ALTER TABLE `oc_gallery_sharing` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_gallery_sharing` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_group_admin`
--

DROP TABLE IF EXISTS `oc_group_admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_group_admin` (
  `gid` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `uid` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`gid`,`uid`),
  KEY `group_admin_uid` (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_group_admin`
--

LOCK TABLES `oc_group_admin` WRITE;
/*!40000 ALTER TABLE `oc_group_admin` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_group_admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_group_user`
--

DROP TABLE IF EXISTS `oc_group_user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_group_user` (
  `gid` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `uid` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`gid`,`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_group_user`
--

LOCK TABLES `oc_group_user` WRITE;
/*!40000 ALTER TABLE `oc_group_user` DISABLE KEYS */;
INSERT INTO `oc_group_user` VALUES ('admin','admin');
/*!40000 ALTER TABLE `oc_group_user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_groups`
--

DROP TABLE IF EXISTS `oc_groups`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_groups` (
  `gid` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`gid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_groups`
--

LOCK TABLES `oc_groups` WRITE;
/*!40000 ALTER TABLE `oc_groups` DISABLE KEYS */;
INSERT INTO `oc_groups` VALUES ('admin');
/*!40000 ALTER TABLE `oc_groups` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_jobs`
--

DROP TABLE IF EXISTS `oc_jobs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_jobs` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `class` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `argument` varchar(256) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `last_run` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `job_class_index` (`class`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_jobs`
--

LOCK TABLES `oc_jobs` WRITE;
/*!40000 ALTER TABLE `oc_jobs` DISABLE KEYS */;
INSERT INTO `oc_jobs` VALUES (1,'OC\\Cache\\FileGlobalGC','null',1449653359),(2,'OC\\BackgroundJob\\Legacy\\RegularJob','[\"\\\\OC\\\\Files\\\\Cache\\\\BackgroundWatcher\",\"checkNext\"]',1449653365);
/*!40000 ALTER TABLE `oc_jobs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_locks`
--

DROP TABLE IF EXISTS `oc_locks`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_locks` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `userid` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `owner` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `timeout` int(10) unsigned DEFAULT NULL,
  `created` bigint(20) DEFAULT NULL,
  `token` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `scope` smallint(6) DEFAULT NULL,
  `depth` smallint(6) DEFAULT NULL,
  `uri` longtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_locks`
--

LOCK TABLES `oc_locks` WRITE;
/*!40000 ALTER TABLE `oc_locks` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_locks` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_lucene_status`
--

DROP TABLE IF EXISTS `oc_lucene_status`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_lucene_status` (
  `fileid` int(11) NOT NULL DEFAULT '0',
  `status` varchar(1) COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`fileid`),
  KEY `status_index` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_lucene_status`
--

LOCK TABLES `oc_lucene_status` WRITE;
/*!40000 ALTER TABLE `oc_lucene_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_lucene_status` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_mimetypes`
--

DROP TABLE IF EXISTS `oc_mimetypes`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_mimetypes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `mimetype` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  UNIQUE KEY `mimetype_id_index` (`mimetype`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_mimetypes`
--

LOCK TABLES `oc_mimetypes` WRITE;
/*!40000 ALTER TABLE `oc_mimetypes` DISABLE KEYS */;
INSERT INTO `oc_mimetypes` VALUES (3,'application'),(4,'application/pdf'),(7,'application/vnd.oasis.opendocument.text'),(8,'audio'),(9,'audio/mpeg'),(1,'httpd'),(2,'httpd/unix-directory'),(5,'image'),(6,'image/jpeg');
/*!40000 ALTER TABLE `oc_mimetypes` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_permissions`
--

DROP TABLE IF EXISTS `oc_permissions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_permissions` (
  `fileid` int(11) NOT NULL DEFAULT '0',
  `user` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `permissions` int(11) NOT NULL DEFAULT '0',
  KEY `id_user_index` (`fileid`,`user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_permissions`
--

LOCK TABLES `oc_permissions` WRITE;
/*!40000 ALTER TABLE `oc_permissions` DISABLE KEYS */;
INSERT INTO `oc_permissions` VALUES (2,'admin',31);
/*!40000 ALTER TABLE `oc_permissions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_pictures_images_cache`
--

DROP TABLE IF EXISTS `oc_pictures_images_cache`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_pictures_images_cache` (
  `uid_owner` varchar(64) COLLATE utf8_unicode_ci NOT NULL,
  `path` varchar(256) COLLATE utf8_unicode_ci NOT NULL,
  `width` int(11) NOT NULL,
  `height` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_pictures_images_cache`
--

LOCK TABLES `oc_pictures_images_cache` WRITE;
/*!40000 ALTER TABLE `oc_pictures_images_cache` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_pictures_images_cache` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_preferences`
--

DROP TABLE IF EXISTS `oc_preferences`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_preferences` (
  `userid` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `appid` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `configkey` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `configvalue` longtext COLLATE utf8_unicode_ci,
  PRIMARY KEY (`userid`,`appid`,`configkey`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_preferences`
--

LOCK TABLES `oc_preferences` WRITE;
/*!40000 ALTER TABLE `oc_preferences` DISABLE KEYS */;
INSERT INTO `oc_preferences` VALUES ('admin','files','cache_version','5'),('admin','firstrunwizard','show','0');
/*!40000 ALTER TABLE `oc_preferences` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_privatedata`
--

DROP TABLE IF EXISTS `oc_privatedata`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_privatedata` (
  `keyid` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `user` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `app` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `key` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `value` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`keyid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_privatedata`
--

LOCK TABLES `oc_privatedata` WRITE;
/*!40000 ALTER TABLE `oc_privatedata` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_privatedata` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_properties`
--

DROP TABLE IF EXISTS `oc_properties`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_properties` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `userid` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `propertypath` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `propertyname` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `propertyvalue` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `property_index` (`userid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_properties`
--

LOCK TABLES `oc_properties` WRITE;
/*!40000 ALTER TABLE `oc_properties` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_properties` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_share`
--

DROP TABLE IF EXISTS `oc_share`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_share` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `share_type` smallint(6) NOT NULL DEFAULT '0',
  `share_with` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `uid_owner` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `parent` int(11) DEFAULT NULL,
  `item_type` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `item_source` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `item_target` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `file_source` int(11) DEFAULT NULL,
  `file_target` varchar(512) COLLATE utf8_unicode_ci DEFAULT NULL,
  `permissions` smallint(6) NOT NULL DEFAULT '0',
  `stime` bigint(20) NOT NULL DEFAULT '0',
  `accepted` smallint(6) NOT NULL DEFAULT '0',
  `expiration` datetime DEFAULT NULL,
  `token` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL,
  `mail_send` smallint(6) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `item_share_type_index` (`item_type`,`share_type`),
  KEY `file_source_index` (`file_source`),
  KEY `token_index` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_share`
--

LOCK TABLES `oc_share` WRITE;
/*!40000 ALTER TABLE `oc_share` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_share` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_storages`
--

DROP TABLE IF EXISTS `oc_storages`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_storages` (
  `id` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `numeric_id` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`numeric_id`),
  UNIQUE KEY `storages_id_index` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_storages`
--

LOCK TABLES `oc_storages` WRITE;
/*!40000 ALTER TABLE `oc_storages` DISABLE KEYS */;
INSERT INTO `oc_storages` VALUES ('home::admin',1),('local::/var/www/owncloud/data/',2);
/*!40000 ALTER TABLE `oc_storages` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_users`
--

DROP TABLE IF EXISTS `oc_users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_users` (
  `uid` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `displayname` varchar(64) COLLATE utf8_unicode_ci DEFAULT NULL,
  `password` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`uid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_users`
--

LOCK TABLES `oc_users` WRITE;
/*!40000 ALTER TABLE `oc_users` DISABLE KEYS */;
INSERT INTO `oc_users` VALUES ('admin',NULL,'$2a$08$GpcOSRKzVRoPF3v.CqpsfOj7YPoH5tHywnRlt2J4z1nSqDdJt.dNK');
/*!40000 ALTER TABLE `oc_users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_vcategory`
--

DROP TABLE IF EXISTS `oc_vcategory`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_vcategory` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `uid` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `type` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  `category` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `uid_index` (`uid`),
  KEY `type_index` (`type`),
  KEY `category_index` (`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_vcategory`
--

LOCK TABLES `oc_vcategory` WRITE;
/*!40000 ALTER TABLE `oc_vcategory` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_vcategory` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `oc_vcategory_to_object`
--

DROP TABLE IF EXISTS `oc_vcategory_to_object`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `oc_vcategory_to_object` (
  `objid` int(10) unsigned NOT NULL DEFAULT '0',
  `categoryid` int(10) unsigned NOT NULL DEFAULT '0',
  `type` varchar(64) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
  PRIMARY KEY (`categoryid`,`objid`,`type`),
  KEY `vcategory_objectd_index` (`objid`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `oc_vcategory_to_object`
--

LOCK TABLES `oc_vcategory_to_object` WRITE;
/*!40000 ALTER TABLE `oc_vcategory_to_object` DISABLE KEYS */;
/*!40000 ALTER TABLE `oc_vcategory_to_object` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2015-12-09 17:30:47
