CREATE TABLE user (
	User_ID int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
	User_Name varchar(45) NOT NULL,
	User_Pass char(128) NOT NULL,
	User_Role enum('member','admin','webmaster') NOT NULL DEFAULT 'member',
	User_Status enum('register','acive','disable','delete') NOT NULL DEFAULT 'register',
	User_Remember varchar(128) DEFAULT NULL,
	PRIMARY KEY (User_ID),
	UNIQUE KEY User_Name_UNIQUE (User_Name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
