CREATE DEFINER=`root`@`localhost` PROCEDURE `News_Add`(
IN v_newstitle VARCHAR(60),
IN v_newscontent TEXT,
IN v_newslive INT(10) UNSIGNED,
IN v_newsIP VARCHAR(39),
IN v_userID INT(10) UNSIGNED,
OUT ret_result VARCHAR(100)
)
BEGIN
	DECLARE lv_epoch INT(10) UNSIGNED DEFAULT UNIX_TIMESTAMP(NOW());
    DECLARE lv_result BOOLEAN DEFAULT true;
	
	SET v_newstitle = TRIM(v_newstitle);
	SET v_newscontent = TRIM(v_newscontent);
	SET v_newslive = TRIM(v_newslive);

	IF !LENGTH(v_newstitle) THEN
		SET lv_result = false;
		SET ret_result = 'Please enter a *Title*, the field cannot be left blank.';
	END IF;

	IF !LENGTH(v_newscontent) THEN
		SET lv_result = false;
		SET ret_result = 'Please enter *Content*, the field cannot be left blank.';
	END IF;
	
	IF lv_result THEN
		IF (v_newscontent IS NULL) OR (!LENGTH(v_newscontent)) OR (v_newscontent < lv_epoch) THEN
			SET v_newscontent = lv_epoch;
			SET ret_result = "has been posted now"
		ELSE
			SET ret_result = CONCAT('will be posted ',FROM_UNIXTIME(v_newslive, '%a %M %D, %Y'))
		END IF;
		
		INSERT INTO site_news (News_Title, News_Content, News_Epoch, News_Live, News_IP, User_ID)
		VALUES (v_newstitle, v_newscontent, lv_epoch, v_newslive, v_newsIP, v_userID)

		SET ret_result = CONCAT('News *', News_Title, '* ', ret_result, '*.');
	END IF;
	
	SET ret_result = CONCAT_WS('|',lv_result,ret_result);
END