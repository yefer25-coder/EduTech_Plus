DELIMITER $$

CREATE PROCEDURE sp_calculate_student_average (
    IN p_student_id INT,
    OUT p_average DECIMAL(4,2)
)
BEGIN
    -- 1. Validate student exists
    IF NOT EXISTS (
        SELECT 1
        FROM students
        WHERE student_id = p_student_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Student does not exist';
    END IF;

    -- 2. Calculate average grade
    SELECT AVG(g.note)
    INTO p_average
    FROM grades g
    JOIN registrations r ON g.registration_id = r.registration_id
    WHERE r.student_id = p_student_id;

    -- 3. If student has no grades
    IF p_average IS NULL THEN
        SET p_average = 0;
    END IF;

END$$

DELIMITER ;


CALL sp_calculate_student_average(1, @avg);
SELECT @avg AS student_average;
