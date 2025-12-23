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