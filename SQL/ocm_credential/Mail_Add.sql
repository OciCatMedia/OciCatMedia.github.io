CREATE DEFINER=`root`@`localhost` PROCEDURE `Mail_Add`(
	IN v_userID INT(10) UNSIGNED,
	IN v_usermail VARCHAR(200),
	OUT ret_result VARCHAR(200)
)
BEGIN
	DECLARE lv_mailrank TINYINT(1) UNSIGNED;
	DECLARE lv_result BOOLEAN DEFAULT true;

	SET v_usermail = TRIM(v_usermail);

	IF !LENGTH(v_usermail) THEN
		SET lv_result = false;
		SET ret_result = 'Please enter an *email*, the field cannot be left blank.';
	ELSEIF !(v_usermail REGEXP "^[^@]+@[^@]+\\.[^@\\.]+$") THEN
		SET lv_result = false;
		SET ret_result = 'Please check the format of your *email*, if this is in error, please contact the webmaster.';
	ELSEIF (SELECT COUNT(Mail_ID) FROM user_mail WHERE Mail_Address = v_usermail) THEN
		SET lv_result = false;
		SET ret_result = CONCAT('The email *', v_usermail,'* is already in use.');
	END IF;
	
	IF lv_result THEN
		SELECT MAX(Mail_Rank) + 1
		INTO lv_mailrank
		FROM user_mail
		WHERE User_ID = v_userID;
		
		IF lv_mailrank IS NULL THEN
			SET lv_mailrank = 0;
		END IF;
		
		INSERT INTO user_mail (Mail_Address, Mail_Rank, Mail_Epoc, User_ID)
		VALUES (v_usermail, lv_mailrank, UNIX_TIMESTAMP(NOW()), v_userID);
		
		CASE lv_mailrank
			WHEN 0 THEN
				SET ret_result = 'primary';
			WHEN 1 THEN
				SET ret_result = 'secondary';
			WHEN 2 THEN
				SET ret_result = CONCAT(lv_mailrank + 1,'^rd^');
			ELSE
				SET ret_result = CONCAT(lv_mailrank + 1,'^th^');
		END CASE;
		
		SET ret_result = CONCAT('*', v_usermail,'* was successfully added as your *', ret_result, '* address.');
	
	END IF;

	SET ret_result = CONCAT_WS('|', lv_result, ret_result);

END