CREATE DATABASE IF NOT EXISTS ocm_credential DEFAULT CHARACTER SET utf8;

CREATE TABLE IF NOT EXISTS ocm_credential.cred_user (
	User_ID INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	User_Name VARCHAR(45) NOT NULL,
	User_Pass CHAR(128) NOT NULL,
	User_Role ENUM('member','admin','webmaster') NOT NULL DEFAULT 'member',
	User_Status ENUM('register','active','disabled','deleted') NOT NULL DEFAULT 'active',
	User_Remember VARCHAR(128) DEFAULT NULL,
	PRIMARY KEY (User_ID),
	UNIQUE KEY UN_User_Name (User_Name)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ocm_credential.user_mail (
	Mail_ID INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	Mail_Address VARCHAR(200) NOT NULL,
	Mail_Rank TINYINT(1) UNSIGNED NOT NULL DEFAULT 0,
	Mail_Epoc INT(10) UNSIGNED NOT NULL,
	User_ID INT(10) UNSIGNED NOT NULL,
	PRIMARY KEY (Mail_ID)
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS ocm_credential.user_session (
	Session_ID BIGINT(20) UNSIGNED NOT NULL AUTO_INCREMENT,
	Session_In INT(10) UNSIGNED NOT NULL,
	Session_InType ENUM('manual','auto') NOT NULL DEFAULT 'manual',
	Session_Out INT(10) UNSIGNED DEFAULT NULL,
	Session_OutType ENUM('manual','auto','app') DEFAULT NULL,
	Session_IP VARCHAR(39) NOT NULL,
	User_ID INT(10) UNSIGNED NOT NULL,
	PRIMARY KEY (Session_ID)
) ENGINE=InnoDB;
