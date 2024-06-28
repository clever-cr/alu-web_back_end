-- update quantity of items in the items table when a new order is placed
DELIMITER //

CREATE TRIGGER update_quantity_insert BEFORE INSERT ON orders
FOR EACH ROW
BEGIN
    DECLARE item_qt INT;

    SELECT quantity INTO item_qt
    FROM items
    WHERE name = NEW.item_name;

    UPDATE items
    SET quantity = item_qt - NEW.number
    WHERE name = NEW.item_name;
END;

//

DELIMITER ;