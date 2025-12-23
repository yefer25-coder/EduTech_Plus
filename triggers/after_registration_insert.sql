DELIMITER $$

CREATE TRIGGER trg_after_registration_insert
AFTER INSERT ON registrations
FOR EACH ROW
BEGIN
    INSERT INTO audits (
        affected_table,
        action,
        action_date,
        user,
        description
    )
    VALUES (
        'registrations',
        'INSERT',
        NOW(),
        USER(),
        CONCAT(
            'Student ID ', NEW.student_id,
            ' registered in Course ID ', NEW.course_id,
            ' for Period ID ', NEW.period_id
        )
    );
END$$

DELIMITER ;
