DELIMITER $$

CREATE PROCEDURE sp_register_student (
    IN p_document VARCHAR(20),
    IN p_name VARCHAR(100),
    IN p_last_name VARCHAR(100),
    IN p_email VARCHAR(100),
    IN p_phone VARCHAR(20),
    IN p_birthdate DATE,
    IN p_program_id INT
)
BEGIN
    -- 1. Validate duplicate document
    IF EXISTS (
        SELECT 1 
        FROM students 
        WHERE document = p_document
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Student with this document already exists';
    END IF;

    -- 2. Validate duplicate email
    IF EXISTS (
        SELECT 1 
        FROM students 
        WHERE email = p_email
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Student with this email already exists';
    END IF;

    -- 3. Validate academic program exists
    IF NOT EXISTS (
        SELECT 1 
        FROM academic_programs 
        WHERE program_id = p_program_id
          AND status = 'active'
    ) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Academic program does not exist or is inactive';
    END IF;

    -- 4. Insert student
    INSERT INTO students (
        document,
        name,
        last_name,
        email,
        phone,
        birthdate,
        registration_date,
        status,
        program_id
    )
    VALUES (
        p_document,
        p_name,
        p_last_name,
        p_email,
        p_phone,
        p_birthdate,
        CURDATE(),
        'active',
        p_program_id
    );

END$$

DELIMITER ;




CALL sp_register_student(
    '123456789',
    'Juan',
    'Perez',
    'juan.perez@email.com',
    '3001234567',
    '2000-05-10',
    1
);

