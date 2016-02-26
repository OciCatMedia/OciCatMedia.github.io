CREATE DEFINER=`root`@`localhost` PROCEDURE `Email_Add`(
	IN v_userID INT(10) UNSIGNED,
	IN v_usermail VARCHAR(200),
	OUT ret_result VARCHAR(200)
)
BEGIN
	DECLARE lv_result BOOLEAN DEFAULT true;
	DECLARE lv_emailrank TINYINT(1) UNSIGNED;

	SET v_usermail = TRIM(v_usermail);

	IF !LENGTH(v_usermail) THEN
		SET lv_result = false;
		SET ret_result = 'Please enter an *Email*, the field cannot be left blank.';
	ELSE IF !v_usermail REGEXP "^[^@]+@[^@\.]+\.[^@\.]+$" THEN
		SET lv_result = false;
		SET ret_result = 'Please check the format of your *Email*, if this is in error, please contact the webmaster.';
	ELSE IF SELECT COUNT(Email_ID) FROM user_email WHERE Email_Address = v_usermail THEN
		SET lv_result = false;
		SET ret_result = CONCAT('The email *', v_usermail,'* is already in use.');
	END IF;
	
	IF lv_result THEN
		SELECT MAX(Email_Rank) + 1
		INTO lv_emailrank
		FROM user_email
		WHERE User_ID = v_userID;
		
		IF lv_emailrank IS NULL THEN
			SET lv_emailrank = 0;
		END IF;
		
		INSERT INTO user_email (Email_Address, Email_Rank, Email_Epoc, User_ID)
		VALUES (v_usermail, lv_emailrank, UNIX_TIMESTAMP(NOW()), v_userID);
		
		CASE lv_emailrank
			WHERE 1
				SET ret_result = CONCAT(lv_emailrank,'^st^');
			WHERE 2
				SET ret_result = CONCAT(lv_emailrank,'^nd^');
			WHERE 3
				SET ret_result = CONCAT(lv_emailrank,'^rd^');
			ELSE
				SET ret_result = CONCAT(lv_emailrank,'^th^');
		END CASE;
		
		SET ret_result = CONCAT('*', v_usermail,'* was successfully added as your *', ret_result, '* address.');
	
	END IF;

	SET ret_result = CONCAT_WS('|', lv_result, ret_result);

END;
