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
# Sebagai pengguna, Tina mampu memilih dan memasukkan makanan ke dalam keranjang
CREATE OR REPLACE FUNCTION add_to_cart(
    p_customer_cst_id CHAR(10),
    p_shop_item_id CHAR(10),
    p_item_amount INT
) RETURNS VOID AS $$
DECLARE
    v_cart_id CHAR(10);
    v_shop_item_stock INT;
    v_cart_totalBill DECIMAL(10, 2);
BEGIN
    -- Check item shop masih ada
    SELECT shop_item_stock INTO v_shop_item_stock
    FROM shop_item
    WHERE shop_item_id = p_shop_item_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Shop item not found';
    END IF;

    -- Check bila stock masih ada
    IF v_shop_item_stock < p_item_amount THEN
        RAISE EXCEPTION 'Not enough stock';
    END IF;

    -- Get the customer's cart_id, create one if not exists
    SELECT cart_id INTO v_cart_id
    FROM cart
    WHERE customer_cst_id = p_customer_cst_id;

    IF NOT FOUND THEN
        v_cart_id := 'CRT' || LPAD(nextval('cart_seq')::TEXT, 7, '0');  -- Generating cart_id with the format CRT0000003
        INSERT INTO cart (cart_id, cart_totalBill, customer_cst_id)
        VALUES (v_cart_id, 0, p_customer_cst_id);
    END IF;

    -- Check item apabila sudah ada di cart
    PERFORM 1
    FROM cart_shop_item
    WHERE cart_cart_id = v_cart_id
    AND shop_item_shop_item_id = p_shop_item_id;

    IF FOUND THEN
        UPDATE cart_shop_item
        SET item_amount = item_amount + p_item_amount
        WHERE cart_cart_id = v_cart_id
        AND shop_item_shop_item_id = p_shop_item_id;
    ELSE
        -- Tambahkan item ke cart
        INSERT INTO cart_shop_item (cart_cart_id, shop_item_shop_item_id, item_amount)
        VALUES (v_cart_id, p_shop_item_id, p_item_amount);
    END IF;

    -- Mengurangi stock item
    UPDATE shop_item
    SET shop_item_stock = shop_item_stock - p_item_amount
    WHERE shop_item_id = p_shop_item_id;

    -- Panggil fungsi CartBill
    v_cart_totalBill := calculateCartBill(v_cart_id);

    UPDATE cart
    SET cart_totalBill = v_cart_totalBill
    WHERE cart_id = v_cart_id;

END;
$$ LANGUAGE plpgsql;


# UC7

# UC8

CREATE SEQUENCE transaction_seq
    START WITH  200000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 200000;

CREATE OR REPLACE FUNCTION checkout(
    p_cart_id CHAR(10),
    p_paymentMethod VARCHAR(50),
    p_delivery CHAR(10)
)
RETURNS VOID AS $$
DECLARE
    v_tr_id CHAR(10);
BEGIN
    v_tr_id := 'TRX' || LPAD(NEXTVAL('transaction_seq')::TEXT, 7, '0');

    DELETE FROM cart_shop_item
    WHERE cart_cart_id = p_cart_id;

    INSERT INTO transaction (
        tr_id, tr_timeStamp, tr_paymentMethod, tr_delivery, cart_cart_id
    )
    VALUES (
        v_tr_id,
        NOW(),
        p_paymentMethod,
        p_delivery,
        p_cart_id
    );

    UPDATE cart
    SET cart_totalBill = 0
    WHERE cart_id = p_cart_id;
END;
$$ LANGUAGE plpgsql;