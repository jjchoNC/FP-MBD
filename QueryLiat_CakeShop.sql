-- Active: 1715773664265@@localhost@5432@cakeshop@public
# function validasi_jumlah_kue
CREATE OR REPLACE FUNCTION validasi_jumlah_kue()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.item_amount < 0 THEN
        RAISE EXCEPTION 'Jumlah kue tidak boleh negatif';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

# trigger function validasi_jumlah_kue
CREATE TRIGGER trigger_validasi_jumlah_kue
BEFORE INSERT OR UPDATE ON transaction_item
FOR EACH ROW
EXECUTE FUNCTION validasi_jumlah_kue();


CREATE OR REPLACE FUNCTION validateStock()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.item_amount > (SELECT item_stock FROM item WHERE item_id = NEW.item_item_id)) THEN
        RAISE EXCEPTION 'Stok tidak mencukupi untuk item %', NEW.item_item_id;
    END IF;
    RETURN NEW;
END;

$$ LANGUAGE plpgsql;

CREATE TRIGGER check_stock
BEFORE INSERT OR UPDATE ON transaction_item
FOR EACH ROW
EXECUTE FUNCTION validateStock();

-- Pemasok barang tidak boleh mengirimkan item yang berjumlah negatif.
CREATE OR REPLACE FUNCTION validateSupplierStock()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.item_stock < 0) THEN
        RAISE EXCEPTION 'Jumlah item tidak boleh negatif';
    END IF;
    RETURN NEW;
END;

$$ LANGUAGE plpgsql;