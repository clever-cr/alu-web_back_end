-- get average score for user
DELIMITER //

CREATE PROCEDURE ComputeAverageScoreForUser(IN input_user_id INT)
BEGIN
    DECLARE average_score FLOAT;
    SELECT AVG(score) INTO average_score FROM corrections WHERE user_id = input_user_id;
    UPDATE users SET average_score = average_score WHERE id = input_user_id;
end //

DELIMITER ;