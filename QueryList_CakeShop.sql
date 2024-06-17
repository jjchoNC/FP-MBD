-- Active: 1715666446348@@localhost@5432@cakeshop@public

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

CREATE OR REPLACE FUNCTION calculateSupplyBill(supply_supply_id CHAR(10))
RETURNS DECIMAL(10, 2) AS $$
DECLARE
    total DECIMAL(10, 2);
BEGIN
    SELECT SUM(ssi.item_amount * i.item_price)
    INTO total
    FROM supply_shop_item ssi
    INNER JOIN shop_item si ON ssi.shop_item_shop_item_id = si.shop_item_id
    INNER JOIN item i ON si.items_item_id = i.item_id
    WHERE ssi.supply_supply_id = supply_supply_id;

    RETURN COALESCE(total, 0);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION calculateCartBill(cart_cart_id CHAR(10))
RETURNS DECIMAL(10, 2) AS $$
DECLARE
    total DECIMAL(10, 2);
BEGIN
    SELECT SUM(csi.item_amount * i.item_price)
    INTO total
    FROM cart_shop_item csi
    INNER JOIN shop_item si ON csi.shop_item_shop_item_id = si.shop_item_id
    INNER JOIN item i ON si.items_item_id = i.item_id
    WHERE csi.cart_cart_id = cart_cart_id;

    RETURN COALESCE(total, 0);
END;
$$ LANGUAGE plpgsql;

# UC1
CREATE OR REPLACE FUNCTION userRegister(
    p_cst_id CHAR(10),
    p_cst_name VARCHAR(100),
    p_cst_phoneNumber VARCHAR(20),
    p_cst_address VARCHAR(100),
    p_cst_email VARCHAR(100),
    p_cst_password VARCHAR(100),
    p_cst_isLoggedIn BOOLEAN,
    p_cst_latitude DECIMAL(5,2),
    p_cst_longitude DECIMAL(5,2)
)
RETURNS VOID AS $$
DECLARE
    email_count INT;
BEGIN
    SELECT COUNT(*)
    INTO email_count
    FROM customer
    WHERE cst_email = p_cst_email;

    IF email_count > 0 THEN
        RAISE EXCEPTION 'Email % already exists. Please use a different email.', p_cst_email;
    END IF;

    INSERT INTO customer (
        cst_id, cst_name, cst_phoneNumber, cst_address, 
        cst_email, cst_password, cst_isLoggedIn, cst_latitude, cst_longitude
    )
    VALUES (
        p_cst_id, p_cst_name, p_cst_phoneNumber, p_cst_address, 
        p_cst_email, MD5(p_cst_password), p_cst_isLoggedIn, p_cst_latitude, p_cst_longitude
    );
END;
$$ LANGUAGE plpgsql;

## Example Usage
/* SELECT userRegister(
    'CST0000001', 
    'John Doe', 
    '1234567890', 
    '123 Main St', 
    'john.doe@example.com', 
    'securepassword', 
    FALSE, 
    37.77, 
    -122.42
); */

# UC2
CREATE OR REPLACE FUNCTION userLogin(
    p_cst_email VARCHAR(100),
    p_cst_password VARCHAR(100)
)
RETURNS BOOLEAN AS $$
DECLARE
    v_cst_id CHAR(10);
BEGIN
    SELECT cst_id
    INTO v_cst_id
    FROM customer
    WHERE cst_email = p_cst_email
    AND cst_password = MD5(p_cst_password);

    IF FOUND THEN
        UPDATE customer
        SET cst_isLoggedIn = TRUE
        WHERE cst_id = v_cst_id;
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

## Example Usage
/* SELECT userLogin('john.doe@example.com', 'securepassword'); */


## Fungsi untuk log out pengguna
CREATE OR REPLACE FUNCTION userLogout(
    p_cst_email VARCHAR(100)
)
RETURNS BOOLEAN AS $$
DECLARE
    v_cst_id CHAR(10);
BEGIN
    -- Cek apakah pengguna dengan email yang diberikan ada di dalam tabel customer
    SELECT cst_id
    INTO v_cst_id
    FROM customer
    WHERE cst_email = p_cst_email AND cst_isLoggedIn = TRUE;

    -- Jika pengguna ditemukan, lakukan logout dengan mengatur cst_isLoggedIn menjadi FALSE
    IF FOUND THEN
        UPDATE customer
        SET cst_isLoggedIn = FALSE
        WHERE cst_id = v_cst_id;
        RETURN TRUE;
    ELSE
        -- Jika pengguna tidak ditemukan, kembalikan FALSE
        RETURN FALSE;
    END IF;
END;
$$ LANGUAGE plpgsql;

## Example Usage 
/* SELECT userLogout('john.doe@example.com'); */


# UC3

# UC4
# Sebagai Pengguna, Tina mampu melakukan pencarian terhadap nama restoran yang menjual jenis atau nama kue tertentu.
CREATE OR REPLACE FUNCTION searchShopItem(
    p_item_name VARCHAR(100)
)
RETURNS TABLE (
    shop_id CHAR(10),
    shop_name VARCHAR(100),
    shop_address VARCHAR(100),
    shop_latitude DECIMAL(5,2),
    shop_longitude DECIMAL(5,2),
    item_id CHAR(10),
    item_name VARCHAR(100),
    item_price DECIMAL(10, 2),
    item_stock INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        s.shop_id, s.shop_name, s.shop_address, s.shop_latitude, s.shop_longitude,
        i.item_id, i.item_name, si.item_price, si.item_stock
    FROM shop s
    INNER JOIN shop_item si ON s.shop_id = si.shop_shop_id
    INNER JOIN item i ON si.items_item_id = i.item_id
    WHERE i.item_name ILIKE '%' || p_item_name || '%';
END;

# UC5

# UC6

# UC7

# UC8