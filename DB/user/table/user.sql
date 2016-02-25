CREATE TABLE user (
	User_ID INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	User_Name VARCHAR(45) NOT NULL,
	User_Pass CHAR(128) NOT NULL,
	User_Role ENUM('member','admin','webmaster') NOT NULL DEFAULT 'member',
	User_Status ENUM('register','active','disabled','deleted') NOT NULL DEFAULT 'register',
	User_Remember VARCHAR(128) DEFAULT NULL,
	PRIMARY KEY (User_ID),
	UNIQUE KEY User_Name_UNIQUE (User_Name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
