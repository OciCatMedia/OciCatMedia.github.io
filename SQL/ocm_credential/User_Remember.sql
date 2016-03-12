CREATE DEFINER=`root`@`localhost` PROCEDURE `User_Remember`(
	IN v_userID INT(10) UNSIGNED,
	OUT ret_result VARCHAR(138)
)
BEGIN
	DECLARE lv_remhash VARCHAR(128);
	DECLARE lv_epoch VARCHAR(10);

	SELECT cred_user.User_Name, MAX(user_session.Session_In) 
	INTO lv_remhash, lv_epoch
	FROM cred_user
	LEFT JOIN user_session
	ON cred_user.User_ID = user_session.User_ID
	WHERE cred_user.User_ID = v_userID;

	SET lv_remhash = SHA2(CONCAT(lv_remhash, lv_epoch) ,512);
	SET lv_epoch = CONV(lv_epoch,10,36);

	UPDATE cred_user
	SET User_Remember = lv_remhash
	WHERE User_ID = v_userID;

	SET ret_result = CONCAT(lv_remhash, lv_epoch);
END