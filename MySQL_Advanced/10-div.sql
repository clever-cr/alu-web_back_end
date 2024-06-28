-- divide function

DELIMITER //
CREATE FUNCTION safeDiv(
    numerator   INT,
    denominator INT
) RETURNS FLOAT
DETERMINISTIC 
BEGIN
    DECLARE result FLOAT;
    IF denominator = 0 THEN SET result = 0;
    ELSE SET result = numerator / denominator;
    END IF;
    RETURN result;
end //

DELIMITER ;