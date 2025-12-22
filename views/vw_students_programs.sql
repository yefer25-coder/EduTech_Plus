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


SELECT * FROM vw_students_programs;