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


SELECT * FROM vw_pending_payments;