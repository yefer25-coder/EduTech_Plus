DELIMITER $$

CREATE PROCEDURE sp_generate_academic_certification (
    IN p_student_id INT,
    IN p_period_id INT
)
BEGIN
    DECLARE v_approved_courses INT;

    -- 1. Validate student exists
    IF NOT EXISTS (
        SELECT 1
        FROM students
        WHERE student_id = p_student_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Student does not exist';
    END IF;

    -- 2. Validate academic period exists
    IF NOT EXISTS (
        SELECT 1
        FROM academic_periods
        WHERE period_id = p_period_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Academic period does not exist';
    END IF;

    -- 3. Prevent duplicate certification
    IF EXISTS (
        SELECT 1
        FROM certifications
        WHERE student_id = p_student_id
          AND period_id = p_period_id
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Certification already exists for this student and period';
    END IF;

    -- 4. Count approved courses (average >= 3.0)
    SELECT COUNT(*)
    INTO v_approved_courses
    FROM (
        SELECT r.course_id
        FROM registrations r
        JOIN grades g ON r.registration_id = g.registration_id
        WHERE r.student_id = p_student_id
          AND r.period_id = p_period_id
        GROUP BY r.course_id
        HAVING AVG(g.note) >= 3.0
    ) AS courses_approved;

    -- 5. Validate at least one approved course
    IF v_approved_courses IS NULL OR v_approved_courses = 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Student has no approved courses for this period';
    END IF;

    -- 6. Insert certification
    INSERT INTO certifications (
        issue_date,
        certification_type,
        student_id,
        period_id
    )
    VALUES (
        CURDATE(),
        'Academic Certification',
        p_student_id,
        p_period_id
    );

END$$

DELIMITER ;


CALL sp_generate_academic_certification(1, 2);
