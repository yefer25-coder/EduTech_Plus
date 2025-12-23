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


SELECT * FROM vw_courses_teachers;