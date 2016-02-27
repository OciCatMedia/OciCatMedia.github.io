CREATE DEFINER=`root`@`localhost` PROCEDURE `Mail_Order`(
	IN v_userID INT(10) UNSIGNED,
	IN v_mailID INT(10) UNSIGNED,
	IN v_mailrank TINYINT(1) UNSIGNED,
	OUT ret_result VARCHAR(200)
)
BEGIN
	DECLARE lv_result BOOLEAN DEFAULT true;
	DECLARE lv_mailrank TINYINT(1);
	DECLARE lv_mailrankmax TINYINT(1);

	SELECT Mail_Rank
	INTO lv_mailrank
	FROM user_mail
	WHERE User_ID = v_userID
	AND Mail_ID = v_mailID;
	
	IF lv_mailrank IS NULL THEN
		SET lv_result = false;
		SET ret_result = 'That *email* isn\'t yours to modify.'; #'
	END IF;
	
	IF lv_result THEN
		SELECT MAX(Mail_Rank)
		INTO lv_mailrankmax
		FROM user_mail
		WHERE User_ID = v_userID;

		IF v_mailrank > lv_mailrankmax THEN
			SET v_mailrank = lv_mailrankmax;
		END IF;
			
	
		IF v_mailrank = lv_mailrank THEN
			SET lv_result = false;
			SET ret_result = 'The order of your *email* hasn\'t changed.'; #'
		ELSE
			IF v_mailrank > lv_mailrank THEN
				UPDATE user_mail
				SET Mail_Rank = Mail_Rank - 1
				WHERE Mail_Rank > lv_mailrank
				AND Mail_Rank <= v_mailrank;
			ELSE 
				UPDATE user_mail
				SET Mail_Rank = Mail_Rank + 1
				WHERE Mail_Rank < lv_mailrank
				AND Mail_Rank >= v_mailrank;
			END IF;
				
			SET ret_result = CONCAT('your *email* has been re-ordered.');
		END IF;
END;