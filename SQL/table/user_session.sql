CREATE TABLE user_session (
	Session_ID BIGINT() PRIMARY KEY AUTOINCREMENT UNSIGNED NOT NULL,
	Session_In INT(10) UNSIGNED NOT NULL,
	Session_InType ENUM('manual','auto') NOT NULL DEFAULT 'manual',
	Session_Out INT(10) UNSIGNED,
	Session_OutType ENUM('manual','auto','app'),
	Session_IP VARCHAR(39) NOT NULL,
	User_ID INT(10) UNSIGNED NOT NULL
)
