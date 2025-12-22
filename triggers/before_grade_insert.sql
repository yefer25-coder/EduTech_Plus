DELIMITER $$

CREATE TRIGGER trg_before_grade_insert
BEFORE INSERT ON grades
FOR EACH ROW
BEGIN
    IF NEW.note < 0 OR NEW.note > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Grade must be between 0 and 5';
    END IF;
END$$

DELIMITER ;


INSERT INTO grades (note, registration_date, evaluation_id, registration_id)
VALUES (7, CURDATE(), 1, 1);
