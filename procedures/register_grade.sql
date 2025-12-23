DELIMITER $$

CREATE PROCEDURE sp_register_grade (
    IN p_registration_id INT,
    IN p_evaluation_id INT,
    IN p_note DECIMAL(3,2)
)
BEGIN
    DECLARE v_course_id INT;

    -- 1. Validate grade range
    IF p_note < 0 OR p_note > 5 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Grade must be between 0 and 5';
    END IF;

    -- 2. Validate registration exists and is active
    IF NOT EXISTS (
        SELECT 1
        FROM registrations
        WHERE registration_id = p_registration_id
          AND status = 'active'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Registration does not exist or is inactive';
    END IF;

    -- 3. Validate evaluation exists
    IF NOT EXISTS (
        SELECT 1
        FROM evaluations
        WHERE evaluation_id = p_evaluation_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Evaluation does not exist';
    END IF;

    -- 4. Get course of the registration
    SELECT course_id
    INTO v_course_id
    FROM registrations
    WHERE registration_id = p_registration_id;

    -- 5. Validate evaluation belongs to the same course
    IF NOT EXISTS (
        SELECT 1
        FROM evaluations
        WHERE evaluation_id = p_evaluation_id
          AND course_id = v_course_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Evaluation does not belong to the course of this registration';
    END IF;

    -- 6. Prevent duplicate grade
    IF EXISTS (
        SELECT 1
        FROM grades
        WHERE registration_id = p_registration_id
          AND evaluation_id = p_evaluation_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Grade already exists for this evaluation';
    END IF;

    -- 7. Insert grade
    INSERT INTO grades (
        note,
        registration_date,
        evaluation_id,
        registration_id
    )
    VALUES (
        p_note,
        CURDATE(),
        p_evaluation_id,
        p_registration_id
    );

END$$

DELIMITER ;



CALL sp_register_grade(1, 2, 4.5);
