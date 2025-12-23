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
