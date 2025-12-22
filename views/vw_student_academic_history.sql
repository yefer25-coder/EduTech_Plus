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


SELECT * FROM vw_student_academic_history;