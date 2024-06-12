-- Active: 1715773664265@@localhost@5432@cakeshop@public

-- Validasi jumlah kue tidak boleh negatif.
CREATE OR REPLACE FUNCTION validasi_jumlah_kue()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.item_amount < 0 THEN
        RAISE EXCEPTION 'Jumlah kue tidak boleh negatif';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


CREATE TRIGGER trigger_validasi_jumlah_kue
BEFORE INSERT OR UPDATE ON transaction_item
FOR EACH ROW
EXECUTE FUNCTION validasi_jumlah_kue();


-- Validasi stok kue tidak mencukupi.
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

CREATE TRIGGER check_supply
BEFORE INSERT OR UPDATE ON transaction_item
FOR EACH ROW
EXECUTE FUNCTION validateSupplierStock();

-- Metode pembayaran harus sesuai dengan yang ada di daftar.
CREATE OR REPLACE FUNCTION validatePaymentMethod()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.tr_paymentMethod NOT IN ('credit', 'cash', 'QRIS')) THEN
        RAISE EXCEPTION 'Metode pembayaran tidak valid';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_payment
BEFORE INSERT OR UPDATE ON transaction
FOR EACH ROW
EXECUTE FUNCTION validatePaymentMethod();

CREATE OR REPLACE FUNCTION calculate_total_bill(supply_supply_id CHAR(10))
RETURNS DECIMAL(10, 2) AS $$
DECLARE
    total DECIMAL(10, 2);
BEGIN
    SELECT SUM(si.item_amount * i.item_price)
    INTO total
    FROM supplier_item si
    JOIN items i ON si.item_item_id = i.item_id
    WHERE si.supply_supply_id = supply_supply_id;

    RETURN COALESCE(total, 0);
END;
$$ LANGUAGE plpgsql;