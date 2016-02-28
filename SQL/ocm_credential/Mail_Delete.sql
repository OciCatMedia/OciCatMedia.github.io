CREATE DEFINER=`root`@`localhost` PROCEDURE `Mail_Delete`(
	IN v_mailID INT(10) UNSIGNED,
	IN v_userID INT(10) UNSIGNED,
	OUT ret_result VARCHAR(200)
)
BEGIN
	DECLARE lv_mailrank TINYINT(1);
	DECLARE lv_mailrankmax TINYINT(1);
	DECLARE lv_result BOOLEAN DEFAULT true;
	
	SELECT Mail_Rank
	INTO lv_mailrank
	FROM user_mail
	WHERE User_ID = v_userID
	AND Mail_ID = v_mailID;
	
	IF lv_mailrank IS NULL THEN
		SET lv_result = false;
		SET ret_result = 'That *email* isn\'t yours to modify.';
	END IF;
	
	IF lv_result THEN
		SELECT MAX(Mail_Rank)
		INTO lv_mailrankmax
		FROM user_mail
		WHERE User_ID = v_userID;
		
		DELETE FROM user_mail
		WHERE Mail_ID = v_mailID;
		
		IF lv_mailrank != lv_mailrankmax THEN
			UPDATE user_mail
			SET Mail_Rank = Mail_Rank - 1
			WHERE Mail_Rank > lv_mailrank;
		END IF;
		
        SET ret_result = 'your *email* has been deleted.';
	END IF;
    
	SET ret_result = CONCAT_WS('|',lv_result, ret_result);

END