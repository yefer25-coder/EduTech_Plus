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
    document VARCHAR(20) UNIQUE NOT NULL,Procedures
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
    status ENUM('active', 'closed') DEFAULT 'active'Procedures
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


