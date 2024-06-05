CREATE OR REPLACE FUNCTION validateStock()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.item_amount > (SELECT item_stock FROM item WHERE item_id = NEW.item_item_id)) THEN
        RAISE EXCEPTION 'Not enough stock available for item %', NEW.item_item_id;
    END IF;
    RETURN NEW;
END;

$$ LANGUAGE plpgsql;

CREATE TRIGGER check_stock
BEFORE INSERT OR UPDATE ON transaction_item
FOR EACH ROW
EXECUTE FUNCTION validateStock();