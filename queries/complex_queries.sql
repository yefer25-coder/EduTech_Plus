-- 1. Students whose average is higher than the overall average
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



-- 2. Courses with the most enrolled students
SELECT
    c.course_name,
    COUNT(r.student_id) AS total_students
FROM courses c
JOIN registrations r ON c.course_id = r.course_id
GROUP BY c.course_id
ORDER BY total_students DESC;


-- 3. Total income per academic period
SELECT
    ap.period_name,
    SUM(p.amount) AS total_income
FROM payments p
JOIN academic_periods ap ON p.period_id = ap.period_id
WHERE p.payment_status = 'Paid'
GROUP BY ap.period_id;



-- 4. Students with no recorded payments
SELECT
    s.student_id,
    CONCAT(s.name, ' ', s.last_name) AS student_name
FROM students s
LEFT JOIN payments p ON s.student_id = p.student_id
WHERE p.payment_id IS NULL;



-- 5. Teachers with the most assigned courses
SELECT
    CONCAT(t.first_name, ' ', t.last_name) AS teacher_name,
    COUNT(c.course_id) AS total_courses
FROM teachers t
JOIN courses c ON t.teacher_id = c.teacher_id
GROUP BY t.teacher_id
ORDER BY total_courses DESC;



-- 6. Student's complete academic record
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




-- 7. Students who passed all enrolled courses
SELECT
    s.student_id,
    CONCAT(s.name, ' ', s.last_name) AS student_name
FROM students s
JOIN registrations r ON s.student_id = r.student_id
JOIN grades g ON r.registration_id = g.registration_id
GROUP BY s.student_id
HAVING MIN(g.note) >= 3.0;



-- 8. Academic programs with the most active students
SELECT
    ap.program_name,
    COUNT(s.student_id) AS total_students
FROM academic_programs ap
JOIN students s ON ap.program_id = s.program_id
WHERE s.status = 'active'
GROUP BY ap.program_id
ORDER BY total_students DESC;


-- 9. Student classification by performance (CASE WHEN)
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



-- 10. Periods with income above the historical average (CTE)
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


