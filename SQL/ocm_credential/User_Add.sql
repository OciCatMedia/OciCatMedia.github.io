CREATE DEFINER=`root`@`localhost` PROCEDURE `User_Create`(
	IN v_username VARCHAR(45),
	IN v_userpass CHAR(128),
	IN v_userIP VARCHAR(39),
	IN v_remtoken VARCHAR(138),
	OUT ret_result VARCHAR(200)
)
BEGIN
	DECLARE lv_epoch INT(10) UNSIGNED DEFAULT UNIX_TIMESTAMP(NOW());
	DECLARE lv_userID INT(10) UNSIGNED;
	DECLARE lv_userrole VARCHAR(10);
	DECLARE lv_userstat VARCHAR(10);
	DECLARE lv_result BOOLEAN DEFAULT true;

	SET v_username = TRIM(v_username);
	SET v_userpass = TRIM(v_userpass);
	SET v_IP = TRIM(UPPER(v_IP));

	IF !LENGTH(v_username) THEN
		SET lv_result = false;
		SET ret_result = 'Please enter a *Username*, the field cannot be left blank.';
	ELSE
		IF SELECT COUNT(User_ID) FROM user WHERE User_Name = v_username THEN
			SET lv_result = false;
			SET ret_result = CONCAT('The username *', v_username,'* is already in use.');
		END IF;
	END IF;

	IF !LENGTH(v_userpass) THEN
		SET lv_result = false;
		SET ret_result = CONCAT_WS('|',ret_result,'Please enter a *Password*, the field cannot be left blank.');
	ELSE
		SET v_userpass = SHA2(v_userpass ,512);
	END IF;
	
	IF lv_result THEN
		INSERT INTO user (User_Name, User_Pass)
		VALUES (v_username, v_userpass);
	
		SET lv_userID = LAST_INSERT_ID();
		
		INSERT INTO user_session (Session_In, Session_IP, User_ID)
		VALUES (UNIX_TIMESTAMP(NOW()), v_userIP, lv_userID);
		
		SELECT User_Role, User_Status
		INTO lv_userrole, lv_userstat
		FROM user
		WHERE user.User_ID = lv_userID

		IF LENGTH(v_remtoken) THEN
			CALL User_Remember (lv_userID, v_remtoken);
		END IF;
		
		SET ret_result = CONCAT('Welcome to OciCat Media, *', v_username,'*.');
	END IF;
	
	SET ret_result = CONCAT_WS('|', lv_result, ret_result, lv_userID, v_username, lv_userrole, lv_userstat, v_remtoken)
END
