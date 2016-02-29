CREATE DEFINER=`root`@`localhost` PROCEDURE `User_Login`(
	IN v_username VARCHAR(45),
	IN v_userpass VARCHAR(200),
	IN v_remtoken VARCHAR(138),
	IN v_userIP VARCHAR(39),
	OUT ret_result VARCHAR(200)
)
BEGIN
	DECLARE lv_userID INT(10) UNSIGNED;
	DECLARE lv_username VARCHAR(45);
	DECLARE lv_userrole VARCHAR(10);
	DECLARE lv_userstat VARCHAR(10);
	DECLARE lv_logintype VARCHAR(6) DEFAULT 'manual';
	DECLARE lv_result BOOLEAN DEFAULT TRUE;

	SET v_username = TRIM(v_username);
	SET v_userpass = SHA2(TRIM(v_userpass), 512);
	SET v_remtoken = TRIM(v_remtoken);
	SET v_userIP = TRIM(UPPER(v_userIP));

	IF v_username IS NULL THEN
		SET lv_logintype = 'auto';

		SELECT User_ID, User_Name, User_Role, User_Status
		INTO lv_userID, lv_username, lv_userrole, lv_userstat
		FROM cred_user
		INNER JOIN user_session
		ON cred_user.User_ID = user_session.User_ID
		AND user_session.Session_In = CONV(SUBSTR(v_remtoken, 129),36,10)
		WHERE cred_user.User_Remember = SUBSTR(v_remtoken,1,128);
	ELSE
		SELECT User_ID, User_Name, User_Role, User_Status
		INTO lv_userID, lv_username, lv_userrole, lv_userstat
		FROM cred_user
		WHERE cred_user.User_Name = v_username
		AND cred_user.User_pass = v_userpass;
	END IF;

	IF lv_userID IS NULL THEN
		SET lv_result = false;
		SET ret_result = 'That username and password combination don\'t seem to match.';
	ELSE
		CASE v_userstatus
			WHEN 'register' THEN
				SET lv_result = false;
				SET ret_result = CONCAT('sorry *', lv_username, '*, but your account has not been activated yet.');
			WHEN NOT 'active' THEN
				SET lv_result = false;
				SET ret_result = CONCAT('sorry *', lv_username, '*, but your account is currently *', lv_userstat, '*.');
			END CASE;
	END IF;

	IF lv_result THEN
		INSERT INTO user_session (Session_In, Session_InType, Session_IP, User_ID)
		VALUES (UNIX_TIMESTAMP(NOW()), lv_logintype, v_userIP, v_userID);

		IF LENGTH(v_remtoken) THEN
			CALL User_Remember (lv_userID, v_remtoken);
		END IF;

		SET ret_result = CONCAT('welcome back *', lv_username, '*.');
	END IF;

	SET ret_result = CONCAT_WS('|', lv_result, ret_result, lv_userID, lv_username, lv_userrole, lv_userstat, v_remtoken);
END;