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

CREATE OR REPLACE FUNCTION calculateSupplyBill(s_id CHAR(10))
RETURNS DECIMAL(10, 2) AS $$
DECLARE
    total DECIMAL(10, 2);
BEGIN
    SELECT SUM(ssi.item_amount * i.item_price)
    INTO total
    FROM supply_shop_item ssi
    INNER JOIN shop_item si ON ssi.shop_item_shop_item_id = si.shop_item_id
    INNER JOIN items i ON si.items_item_id = i.item_id
    WHERE ssi.supply_supply_id = s_id;

    RETURN COALESCE(total, 0);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION updateSupplyTotalBill()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE supply
    SET supply_totalBill = calculateSupplyBill(NEW.supply_supply_id)
    WHERE supply_id = NEW.supply_supply_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_updateSupplyTotalBill
AFTER INSERT ON supply_shop_item
FOR EACH ROW
EXECUTE FUNCTION updateSupplyTotalBill();

-- Function to calculate the total bill for a cart
CREATE OR REPLACE FUNCTION calculateCartBill(c_id CHAR(10))
RETURNS DECIMAL(10, 2) AS $$
DECLARE
    total DECIMAL(10, 2);
BEGIN
    SELECT SUM(csi.item_amount * i.item_price)
    INTO total
    FROM cart_shop_item csi
    INNER JOIN shop_item si ON csi.shop_item_shop_item_id = si.shop_item_id
    INNER JOIN items i ON si.items_item_id = i.item_id
    WHERE csi.cart_cart_id = c_id;

    RETURN COALESCE(total, 0);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION updateCartTotalBill()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE cart
    SET cart_totalBill = calculateCartBill(NEW.cart_cart_id)
    WHERE cart_id = NEW.cart_cart_id;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_updateCartTotalBill
AFTER INSERT ON cart_shop_item
FOR EACH ROW
EXECUTE FUNCTION updateCartTotalBill();

-- Function to validate stock for cart_item
CREATE OR REPLACE FUNCTION validateStock()
RETURNS TRIGGER AS $$
BEGIN
    IF (NEW.item_amount > (SELECT shop_item_stock FROM shop_item WHERE shop_item_id = NEW.shop_item_shop_item_id)) THEN
        RAISE EXCEPTION 'Stock tidak mencukupi untuk item %', NEW.shop_item_shop_item_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER check_stock
BEFORE INSERT OR UPDATE ON cart_shop_item
FOR EACH ROW
EXECUTE FUNCTION validateStock();