-- ============================================================================
-- EDUTECH PLUS - COMPLETE DATABASE SETUP SCRIPT
-- ============================================================================
-- This script creates the complete EduTech Plus database system including:
-- 1. Database and Tables
-- 2. Referential Integrity (Foreign Keys)
-- 3. Stored Procedures
-- 4. Triggers
-- 5. Views
-- 6. Sample Data Insertions
-- 7. Complex Queries (Examples)
--
-- Execute this script in order to set up the entire system.
-- ============================================================================

-- ============================================================================
-- SECTION 1: DATABASE AND TABLES CREATION
-- ============================================================================

CREATE DATABASE edutech_plus;
USE edutech_plus;

CREATE TABLE students (
    student_id INT AUTO_INCREMENT PRIMARY KEY,
    document VARCHAR(20) UNIQUE NOT NULL,
    name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(20),
    birthdate DATE,
    status ENUM('active', 'inactive') DEFAULT 'active',
    registration_date DATE NOT NULL,
    program_id INT NOT NULL
);


CREATE TABLE teachers (
    teacher_id INT AUTO_INCREMENT PRIMARY KEY,
    document VARCHAR(20) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    specialty VARCHAR(100),
    status ENUM('active', 'inactive') DEFAULT 'active'
);


CREATE TABLE academic_programs (
    program_id INT AUTO_INCREMENT PRIMARY KEY,
    program_name VARCHAR(150) NOT NULL,
    description TEXT,
    level ENUM('Technical', 'Technological', 'Professional'),
    status ENUM('active', 'inactive') DEFAULT 'active'
);


CREATE TABLE courses (
    course_id INT AUTO_INCREMENT PRIMARY KEY,
    course_name VARCHAR(150) NOT NULL,
    credits INT NOT NULL,
    status ENUM('active', 'inactive') DEFAULT 'active',
    teacher_id INT NOT NULL,
    program_id INT NOT NULL
);



CREATE TABLE academic_periods (
    period_id INT AUTO_INCREMENT PRIMARY KEY,
    period_name VARCHAR(50) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('active', 'closed') DEFAULT 'active'
);


CREATE TABLE registrations (
    registration_id INT AUTO_INCREMENT PRIMARY KEY,
    registration_date DATE NOT NULL,
    status ENUM('active', 'cancelled') DEFAULT 'active',
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    period_id INT NOT NULL
);



CREATE TABLE evaluations (
    evaluation_id INT AUTO_INCREMENT PRIMARY KEY,
    evaluation_name VARCHAR(100) NOT NULL,
    percentage DECIMAL(5,2) NOT NULL,
    date DATE NOT NULL,
    course_id INT NOT NULL
);



CREATE TABLE grades (
    grade_id INT AUTO_INCREMENT PRIMARY KEY,
    note DECIMAL(3,2) NOT NULL,
    registration_date DATE NOT NULL,
    evaluation_id INT NOT NULL,
    registration_id INT NOT NULL
);



CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    amount DECIMAL(10,2) NOT NULL,
    payment_date DATE,
    payment_method VARCHAR(50),
    payment_status ENUM('Paid', 'Pending') DEFAULT 'Pending',
    student_id INT NOT NULL,
    period_id INT NOT NULL
);



CREATE TABLE certifications (
    certification_id INT AUTO_INCREMENT PRIMARY KEY,
    issue_date DATE NOT NULL,
    certification_type VARCHAR(100),
    student_id INT NOT NULL,
    period_id INT NOT NULL
);



CREATE TABLE audits (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    affected_table VARCHAR(50),
    action ENUM('INSERT', 'UPDATE', 'DELETE'),
    action_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    user VARCHAR(100),
    description TEXT
);


-- ============================================================================
-- SECTION 2: REFERENTIAL INTEGRITY (FOREIGN KEYS)
-- ============================================================================

ALTER TABLE students
ADD CONSTRAINT fk_students_program
FOREIGN KEY (program_id) REFERENCES academic_programs(program_id);

ALTER TABLE courses
ADD CONSTRAINT fk_courses_teacher
FOREIGN KEY (teacher_id) REFERENCES teachers(teacher_id),
ADD CONSTRAINT fk_courses_program
FOREIGN KEY (program_id) REFERENCES academic_programs(program_id);

ALTER TABLE registrations
ADD CONSTRAINT fk_reg_student
FOREIGN KEY (student_id) REFERENCES students(student_id),
ADD CONSTRAINT fk_reg_course
FOREIGN KEY (course_id) REFERENCES courses(course_id),
ADD CONSTRAINT fk_reg_period
FOREIGN KEY (period_id) REFERENCES academic_periods(period_id);

ALTER TABLE evaluations
ADD CONSTRAINT fk_eval_course
FOREIGN KEY (course_id) REFERENCES courses(course_id);

ALTER TABLE grades
ADD CONSTRAINT fk_grade_eval
FOREIGN KEY (evaluation_id) REFERENCES evaluations(evaluation_id),
ADD CONSTRAINT fk_grade_reg
FOREIGN KEY (registration_id) REFERENCES registrations(registration_id);

ALTER TABLE payments
ADD CONSTRAINT fk_payment_student
FOREIGN KEY (student_id) REFERENCES students(student_id),
ADD CONSTRAINT fk_payment_period
FOREIGN KEY (period_id) REFERENCES academic_periods(period_id);

ALTER TABLE certifications
ADD CONSTRAINT fk_cert_student
FOREIGN KEY (student_id) REFERENCES students(student_id),
ADD CONSTRAINT fk_cert_period
FOREIGN KEY (period_id) REFERENCES academic_periods(period_id);


-- ============================================================================
-- SECTION 3: STORED PROCEDURES
-- ============================================================================

-- Procedure 1: Register Student
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


-- Procedure 2: Register Student in Course
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


-- Procedure 3: Register Grade
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


-- Procedure 4: Calculate Student Average
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


-- Procedure 5: Generate Academic Certification
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


-- ============================================================================
-- SECTION 4: TRIGGERS
-- ============================================================================

-- Trigger 1: Audit Registration Inserts
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


-- Trigger 2: Audit Payment Updates
DELIMITER $$

CREATE TRIGGER trg_after_payment_update
AFTER UPDATE ON payments
FOR EACH ROW
BEGIN
    IF NEW.payment_status = 'Paid' AND OLD.payment_status <> 'Paid' THEN
        INSERT INTO audits (
            affected_table,
            action,
            action_date,
            user,
            description
        )
        VALUES (
            'payments',
            'UPDATE',
            NOW(),
            USER(),
            CONCAT(
                'Payment ID ', NEW.payment_id,
                ' marked as PAID for Student ID ', NEW.student_id
            )
        );
    END IF;
END$$

DELIMITER ;


-- Trigger 3: Validate Grade Range Before Insert
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


-- ============================================================================
-- SECTION 5: VIEWS
-- ============================================================================

-- View 1: Students with Programs
CREATE VIEW vw_students_programs AS
SELECT
    s.student_id,
    s.document,
    s.name,
    s.last_name,
    s.email,
    s.status,
    ap.program_name,
    ap.level
FROM students s
JOIN academic_programs ap ON s.program_id = ap.program_id;


-- View 2: Courses with Teachers
CREATE VIEW vw_courses_teachers AS
SELECT
    c.course_id,
    c.course_name,
    c.credits,
    c.status,
    CONCAT(t.first_name, ' ', t.last_name) AS teacher_name,
    ap.program_name
FROM courses c
JOIN teachers t ON c.teacher_id = t.teacher_id
JOIN academic_programs ap ON c.program_id = ap.program_id;


-- View 3: Student Academic History
CREATE VIEW vw_student_academic_history AS
SELECT
    s.student_id,
    CONCAT(s.name, ' ', s.last_name) AS student_name,
    ap.period_name,
    c.course_name,
    e.evaluation_name,
    g.note
FROM students s
JOIN registrations r ON s.student_id = r.student_id
JOIN academic_periods ap ON r.period_id = ap.period_id
JOIN courses c ON r.course_id = c.course_id
JOIN evaluations e ON c.course_id = e.course_id
LEFT JOIN grades g 
    ON g.registration_id = r.registration_id
    AND g.evaluation_id = e.evaluation_id;


-- View 4: Pending Payments
CREATE VIEW vw_pending_payments AS
SELECT
    p.payment_id,
    s.student_id,
    CONCAT(s.name, ' ', s.last_name) AS student_name,
    p.amount,
    p.payment_date,
    p.payment_status,
    ap.period_name
FROM payments p
JOIN students s ON p.student_id = s.student_id
JOIN academic_periods ap ON p.period_id = ap.period_id
WHERE p.payment_status = 'Pending';


-- ============================================================================
-- SECTION 6: SAMPLE DATA INSERTIONS
-- ============================================================================

-- Academic Programs
INSERT INTO academic_programs (program_name, description, level, status)
VALUES
('Software Development', NULL, 'Professional', 'active'),
('Information Systems', NULL, 'Professional', 'active'),
('Data Science', NULL, 'Professional', 'active'),
('Digital Marketing', NULL, 'Technical', 'active'),
('Cybersecurity Specialist', NULL, 'Professional', 'active');


-- Academic Periods
INSERT INTO academic_periods (period_name, start_date, end_date, status)
VALUES
('2024-1', '2024-01-15', '2024-06-15', 'closed'),
('2024-2', '2024-07-15', '2024-12-15', 'active');


-- Teachers
INSERT INTO teachers (document, first_name, last_name, email, specialty, status)
VALUES
('T001', 'Carlos', 'Ramirez', 'c.ramirez@edutech.com', 'Software Engineering', 'active'),
('T002', 'Laura', 'Gomez', 'l.gomez@edutech.com', 'Databases', 'active'),
('T003', 'Andres', 'Lopez', 'a.lopez@edutech.com', 'Systems Analysis', 'active'),
('T004', 'Maria', 'Fernandez', 'm.fernandez@edutech.com', 'Marketing', 'active'),
('T005', 'Jorge', 'Herrera', 'j.herrera@edutech.com', 'Cybersecurity', 'active');


-- Students
INSERT INTO students (document, name, last_name, email, phone, birthdate, registration_date, program_id, status)
VALUES
('1001', 'Juan', 'Perez', 'juan.perez@mail.com', '3001001001', '2000-01-01', CURDATE(), 1, 'active'),
('1002', 'Maria', 'Rodriguez', 'maria.ro@mail.com', '3001001002', '1999-05-15', CURDATE(), 1, 'active'),
('1003', 'Luis', 'Martinez', 'luis.mar@mail.com', '3001001003', '2001-08-20', CURDATE(), 2, 'active'),
('1004', 'Ana', 'Torres', 'ana.t@mail.com', '3001001004', '2002-02-10', CURDATE(), 3, 'inactive'),
('1005', 'Carlos', 'Ruiz', 'carlos.ruiz@mail.com', '3001001005', '2000-11-30', CURDATE(), 4, 'active'),
('1006', 'Sofia', 'Mendez', 'sofia.mendez@mail.com', '3001001006', '1998-07-25', CURDATE(), 5, 'active'),
('1007', 'Pedro', 'Aguilar', 'pedro.aguilar@mail.com', '3001001007', '1999-12-12', CURDATE(), 1, 'active'),
('1008', 'Lucia', 'Vargas', 'lucia.vargas@mail.com', '3001001008', '2001-03-05', CURDATE(), 2, 'active'),
('1009', 'Miguel', 'Castro', 'miguel.castro@mail.com', '3001001009', '2000-09-18', CURDATE(), 3, 'active'),
('1010', 'Elena', 'Rios', 'elena.rios@mail.com', '3001001010', '2002-06-22', CURDATE(), 4, 'active'),
('1011', 'David', 'Silva', 'david.silva@mail.com', '3001001011', '1997-04-14', CURDATE(), 5, 'inactive'),
('1012', 'Carmen', 'Ortiz', 'carmen.ortiz@mail.com', '3001001012', '1998-10-30', CURDATE(), 1, 'active'),
('1013', 'Jose', 'Gutierrez', 'jose.gutierrez@mail.com', '3001001013', '1999-01-20', CURDATE(), 2, 'active'),
('1014', 'Paula', 'Navarro', 'paula.navarro@mail.com', '3001001014', '2001-05-05', CURDATE(), 3, 'active'),
('1015', 'Fernando', 'Rojas', 'fernando.rojas@mail.com', '3001001015', '2000-08-08', CURDATE(), 4, 'active'),
('1016', 'Isabel', 'Mendoza', 'isabel.mendoza@mail.com', '3001001016', '2002-11-11', CURDATE(), 5, 'active'),
('1017', 'Diego', 'Salazar', 'diego.salazar@mail.com', '3001001017', '1996-02-28', CURDATE(), 1, 'active'),
('1018', 'Valentina', 'Paredes', 'valentina.paredes@mail.com', '3001001018', '1997-07-07', CURDATE(), 2, 'active'),
('1019', 'Gabriel', 'Mejia', 'gabriel.mejia@mail.com', '3001001019', '1998-12-01', CURDATE(), 3, 'active'),
('1020', 'Daniela', 'Cortes', 'daniela.cortes@mail.com', '3001001020', '2000-04-15', CURDATE(), 4, 'active');


-- Courses
INSERT INTO courses (course_name, credits, teacher_id, program_id, status)
VALUES
('Programming I', 3, 1, 1, 'active'),
('Databases', 4, 2, 1, 'active'),
('Systems Analysis', 3, 3, 2, 'active'),
('Machine Learning', 4, 1, 3, 'active'),
('Web Development', 3, 1, 1, 'active'),
('SEO Fundamentals', 2, 4, 4, 'active'),
('Social Media Marketing', 2, 4, 4, 'active'),
('Network Security', 4, 5, 5, 'active'),
('Ethical Hacking', 4, 5, 5, 'active'),
('IT Project Management', 3, 3, 2, 'active');


-- Evaluations
INSERT INTO evaluations (course_id, evaluation_name, percentage, date)
VALUES
-- Course 1: Programming I
(1, 'Midterm Exam', 40, '2024-08-15'),
(1, 'Final Exam', 60, '2024-11-20'),
-- Course 2: Databases
(2, 'Project', 50, '2024-09-10'),
(2, 'Final Exam', 50, '2024-11-25'),
-- Course 3: Systems Analysis
(3, 'Requirements Doc', 40, '2024-08-30'),
(3, 'Final Presentation', 60, '2024-11-15'),
-- Course 4: Machine Learning
(4, 'Final Project', 100, '2024-12-01'),
-- Course 5: Web Development
(5, 'Frontend Project', 50, '2024-09-20'),
(5, 'Backend Project', 50, '2024-11-30'),
-- Course 6: SEO
(6, 'Audit Report', 100, '2024-10-10'),
-- Course 7: Social Media
(7, 'Campaign Plan', 100, '2024-10-25'),
-- Course 8: Network Security
(8, 'Lab Practical', 50, '2024-09-15'),
(8, 'Theory Exam', 50, '2024-11-10'),
-- Course 9: Ethical Hacking
(9, 'CTF Challenge', 100, '2024-12-05'),
-- Course 10: IT Project
(10, 'Case Study', 100, '2024-11-05');


-- Registrations (Enrollments)
INSERT INTO registrations (student_id, course_id, period_id, registration_date, status)
VALUES
-- Period 2 (Active)
(1, 1, 2, CURDATE(), 'active'),
(1, 2, 2, CURDATE(), 'active'),
(2, 1, 2, CURDATE(), 'active'),
(2, 5, 2, CURDATE(), 'active'),
(3, 3, 2, CURDATE(), 'active'),
(3, 10, 2, CURDATE(), 'active'),
(4, 4, 1, DATE_SUB(CURDATE(), INTERVAL 6 MONTH), 'active'), -- Past period
(5, 6, 2, CURDATE(), 'active'),
(5, 7, 2, CURDATE(), 'active'),
(6, 8, 2, CURDATE(), 'active'),
(6, 9, 2, CURDATE(), 'active'),
(7, 1, 2, CURDATE(), 'active'),
(8, 3, 2, CURDATE(), 'active'),
(9, 4, 2, CURDATE(), 'active'),
(10, 6, 2, CURDATE(), 'active'),
(12, 1, 2, CURDATE(), 'active'),
(12, 5, 2, CURDATE(), 'active'),
(13, 10, 2, CURDATE(), 'active'),
(14, 4, 2, CURDATE(), 'active'),
(15, 7, 2, CURDATE(), 'active'),
(16, 9, 2, CURDATE(), 'active'),
(17, 2, 2, CURDATE(), 'active'),
(18, 3, 2, CURDATE(), 'active'),
(19, 4, 2, CURDATE(), 'active'),
(20, 6, 2, CURDATE(), 'active');


-- Grades
INSERT INTO grades (registration_id, evaluation_id, note, registration_date)
VALUES
-- Student 1
(1, 1, 3.8, CURDATE()), (1, 2, 4.2, CURDATE()),
(2, 3, 4.5, CURDATE()), (2, 4, 4.0, CURDATE()),
-- Student 2
(3, 1, 3.2, CURDATE()), (3, 2, 3.5, CURDATE()),
(4, 8, 4.0, CURDATE()), (4, 9, 3.8, CURDATE()), -- Web Dev
-- Student 3
(5, 5, 4.2, CURDATE()), (5, 6, 4.5, CURDATE()), -- Sys Analysis
-- Student 4 (Past period)
(7, 7, 4.8, CURDATE()), -- Machine Learning
-- Student 5
(8, 10, 3.5, CURDATE()), -- SEO
(9, 11, 4.0, CURDATE()), -- Social Media
-- Student 6
(10, 12, 4.6, CURDATE()), (10, 13, 4.4, CURDATE()), -- Net Security
(11, 14, 5.0, CURDATE()), -- Ethical Hacking
-- Random others
(12, 1, 2.5, CURDATE()), (12, 2, 2.8, CURDATE()), -- Student 7 (Failing)
(14, 7, 5.0, CURDATE()),
(15, 10, 1.5, CURDATE());


-- Payments
INSERT INTO payments (student_id, period_id, amount, payment_date, payment_status, payment_method)
VALUES
(1, 2, 1200000, CURDATE(), 'Paid', 'Credit Card'),
(2, 2, 1200000, CURDATE(), 'Pending', NULL),
(3, 2, 1400000, CURDATE(), 'Paid', 'Bank Transfer'),
(5, 2, 800000, CURDATE(), 'Paid', 'Cash'),
(6, 2, 2500000, CURDATE(), 'Paid', 'Credit Card'),
(7, 2, 1200000, CURDATE(), 'Pending', NULL),
(8, 2, 1400000, CURDATE(), 'Paid', 'Bank Transfer'),
(9, 2, 2000000, CURDATE(), 'Paid', 'Credit Card'),
(10, 2, 800000, CURDATE(), 'Pending', NULL),
(16, 2, 2500000, CURDATE(), 'Paid', 'Cash'),
(17, 2, 1200000, CURDATE(), 'Paid', 'Credit Card'),
(20, 2, 800000, CURDATE(), 'Pending', NULL);


-- ============================================================================
-- SECTION 7: COMPLEX QUERIES (EXAMPLES)
-- ============================================================================

-- Query 1: Students whose average is higher than the overall average
SELECT
    s.student_id,
    CONCAT(s.name, ' ', s.last_name) AS student_name,
    AVG(g.note) AS student_average
FROM students s
JOIN registrations r ON s.student_id = r.student_id
JOIN grades g ON r.registration_id = g.registration_id
GROUP BY s.student_id
HAVING AVG(g.note) > (
    SELECT AVG(note) FROM grades
);



-- Query 2: Courses with the most enrolled students
SELECT
    c.course_name,
    COUNT(r.student_id) AS total_students
FROM courses c
JOIN registrations r ON c.course_id = r.course_id
GROUP BY c.course_id
ORDER BY total_students DESC;


-- Query 3: Total income per academic period
SELECT
    ap.period_name,
    SUM(p.amount) AS total_income
FROM payments p
JOIN academic_periods ap ON p.period_id = ap.period_id
WHERE p.payment_status = 'Paid'
GROUP BY ap.period_id;



-- Query 4: Students with no recorded payments
SELECT
    s.student_id,
    CONCAT(s.name, ' ', s.last_name) AS student_name
FROM students s
LEFT JOIN payments p ON s.student_id = p.student_id
WHERE p.payment_id IS NULL;



-- Query 5: Teachers with the most assigned courses
SELECT
    CONCAT(t.first_name, ' ', t.last_name) AS teacher_name,
    COUNT(c.course_id) AS total_courses
FROM teachers t
JOIN courses c ON t.teacher_id = c.teacher_id
GROUP BY t.teacher_id
ORDER BY total_courses DESC;



-- Query 6: Student's complete academic record
SELECT
    CONCAT(s.name, ' ', s.last_name) AS student_name,
    ap.period_name,
    c.course_name,
    e.evaluation_name,
    g.note
FROM students s
JOIN registrations r ON s.student_id = r.student_id
JOIN academic_periods ap ON r.period_id = ap.period_id
JOIN courses c ON r.course_id = c.course_id
JOIN evaluations e ON c.course_id = e.course_id
LEFT JOIN grades g 
    ON g.registration_id = r.registration_id
    AND g.evaluation_id = e.evaluation_id
ORDER BY s.student_id, ap.period_name;




-- Query 7: Students who passed all enrolled courses
SELECT
    s.student_id,
    CONCAT(s.name, ' ', s.last_name) AS student_name
FROM students s
JOIN registrations r ON s.student_id = r.student_id
JOIN grades g ON r.registration_id = g.registration_id
GROUP BY s.student_id
HAVING MIN(g.note) >= 3.0;



-- Query 8: Academic programs with the most active students
SELECT
    ap.program_name,
    COUNT(s.student_id) AS total_students
FROM academic_programs ap
JOIN students s ON ap.program_id = s.program_id
WHERE s.status = 'active'
GROUP BY ap.program_id
ORDER BY total_students DESC;


-- Query 9: Student classification by performance (CASE WHEN)
SELECT
    s.student_id,
    CONCAT(s.name, ' ', s.last_name) AS student_name,
    AVG(g.note) AS average_grade,
    CASE
        WHEN AVG(g.note) >= 4.0 THEN 'High'
        WHEN AVG(g.note) >= 3.0 THEN 'Medium'
        ELSE 'Low'
    END AS performance
FROM students s
JOIN registrations r ON s.student_id = r.student_id
JOIN grades g ON r.registration_id = g.registration_id
GROUP BY s.student_id;



-- Query 10: Periods with income above the historical average (CTE)
WITH period_income AS (
    SELECT
        period_id,
        SUM(amount) AS total_income
    FROM payments
    WHERE payment_status = 'Paid'
    GROUP BY period_id
)
SELECT
    ap.period_name,
    pi.total_income
FROM period_income pi
JOIN academic_periods ap ON pi.period_id = ap.period_id
WHERE pi.total_income > (
    SELECT AVG(total_income) FROM period_income
);


-- ============================================================================
-- END OF SCRIPT
-- ============================================================================
-- Database setup complete!
-- You can now test the procedures, views, and queries.
-- ============================================================================
