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