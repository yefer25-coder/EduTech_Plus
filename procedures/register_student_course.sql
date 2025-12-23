DELIMITER $$

CREATE PROCEDURE sp_register_student_course (
    IN p_student_id INT,
    IN p_course_id INT,
    IN p_period_id INT
)
BEGIN
    -- 1. Validate student exists and is active
    IF NOT EXISTS (
        SELECT 1 
        FROM students 
        WHERE student_id = p_student_id
          AND status = 'active'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Student does not exist or is inactive';
    END IF;

    -- 2. Validate course exists and is active
    IF NOT EXISTS (
        SELECT 1 
        FROM courses 
        WHERE course_id = p_course_id
          AND status = 'active'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Course does not exist or is inactive';
    END IF;

    -- 3. Validate academic period exists and is active
    IF NOT EXISTS (
        SELECT 1 
        FROM academic_periods 
        WHERE period_id = p_period_id
          AND status = 'active'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Academic period does not exist or is inactive';
    END IF;

    -- 4. Validate student is not already registered in the course for the period
    IF EXISTS (
        SELECT 1
        FROM registrations
        WHERE student_id = p_student_id
          AND course_id = p_course_id
          AND period_id = p_period_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Student is already registered in this course for the selected period';
    END IF;

    -- 5. Insert registration
    INSERT INTO registrations (
        registration_date,
        status,
        student_id,
        course_id,
        period_id
    )
    VALUES (
        CURDATE(),
        'active',
        p_student_id,
        p_course_id,
        p_period_id
    );

END$$

DELIMITER ;



CALL sp_register_student_course(1, 3, 2);
