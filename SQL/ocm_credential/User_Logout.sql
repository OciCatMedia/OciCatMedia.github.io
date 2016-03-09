CREATE DEFINER=`root`@`localhost` PROCEDURE `User_Logout`(
	IN v_userID INT(10) UNSIGNED,
	IN v_logouttype VARCHAR(6),
	OUT ret_result VARCHAR(200)
)
BEGIN
    IF v_logouttype = 'app' THEN
		UPDATE user_session
		SET Session_Out = UNIX_TIMESTAMP(NOW()), Session_OutType = v_logouttype
		WHERE Session_Out IS NULL;
	ELSE
		UPDATE user_session
		SET Session_Out = UNIX_TIMESTAMP(NOW()), Session_OutType = v_logouttype
		WHERE User_ID = v_userID
		AND Session_Out IS NULL;
		
		IF v_logouttype = 'manual' THEN
			UPDATE cred_user
			SET User_Remember = NULL
			WHERE User_ID = v_userID;
		END IF;
	END IF;
    
	SET ret_result = CONCAT_WS('|', 1, 'You have been logged out.');
END