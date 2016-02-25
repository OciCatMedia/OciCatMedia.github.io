CREATE DEFINER=`root`@`localhost` PROCEDURE `User_Create`(
IN v_username VARCHAR(45),
IN v_userpass CHAR(128),
IN v_IP VARCHAR(39),
OUT ret_result VARCHAR(200)
)
BEGIN
DECLARE lv_epoch INT(10) UNSIGNED DEFAULT UNIX_TIMESTAMP(NOW());
DECLARE lv_userID INT(10) UNSIGNED;
DECLARE lv_result BOOLEAN DEFAULT true;

SET v_username = TRIM(v_username);
SET v_userpass = TRIM(v_userpass);
SET v_IP = TRIM(UPPER(v_IP));

IF !LENGTH(v_username) THEN
SET lv_result = false;
SET ret_result = 'The *Username* field is blank.';
ELSE
SELECT COUNT(User_ID) INTO lv_userID FROM user WHERE User_Name = v_username;
IF lv_userID THEN
SET lv_result = false;
SET ret_result = CONCAT('The username *', v_username,'* is already in use.');
END IF;
END IF;

IF !LENGTH(v_userpass) THEN
SET lv_result = false;
SET ret_result = CONCAT_WS('|',ret_result,'The *Password* field is blank.');
else
SET v_userpass = SHA2(v_userpass ,512);
END IF;






IF lv_result THEN
INSERT INTO user (User_Name, User_Pass)
VALUES (v_username, v_userpass);

SET lv_userID = LAST_INSERT_ID();

INSERT INTO user_act (Act_Name, Act_IP, Act_Epoch, User_ID)
VALUES ('register', v_IP, lv_epoch, lv_userID);

CALL User_Remember (lv_userID, ret_result);

SET ret_result = CONCAT_WS("|",CONCAT('User *', v_username, '* successfully created.'),ret_result);
END IF;

SET ret_result = CONCAT_WS(';',lv_result,ret_result);
END
