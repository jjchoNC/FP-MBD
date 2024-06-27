-- Active: 1715773664265@@localhost@5432@test@public


# UC1
DELETE FROM customer WHERE cst_name = "Tunas";
CREATE SEQUENCE cst_id_seq
    START WITH  300001
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 200000;
CREATE OR REPLACE FUNCTION userRegister(
    p_cst_name VARCHAR(100),
    p_cst_phoneNumber VARCHAR(20),
    p_cst_address VARCHAR(100),
    p_cst_email VARCHAR(100),
    p_cst_password VARCHAR(100),
    p_cst_latitude DECIMAL(10,6),
    p_cst_longitude DECIMAL(10,6)
)
RETURNS VOID AS $$
DECLARE
    isLoggedin BOOLEAN;
    p_cst_id CHAR(10);
BEGIN
    isLoggedin := False;
    p_cst_id := 'CST' || LPAD(NEXTVAL('cst_id_seq')::TEXT, 7, '0');

    IF NOT validateEmail(p_cst_email) THEN
        RAISE EXCEPTION 'Email already exists. Please use a different email.';
    END IF;

    IF NOT validatePassword(p_cst_password) THEN
        RAISE EXCEPTION 'Password lenght must be greater than 8';
    END IF;

    isLoggedin := False;
    p_cst_id := 'CST' || LPAD(NEXTVAL('cst_id_seq')::TEXT, 7, '0');

    BEGIN
        INSERT INTO customer (cst_id, cst_name, cst_phoneNumber, cst_address, 
                              cst_email, cst_password, cst_isLoggedIn, cst_latitude, cst_longitude)
        VALUES (p_cst_id, p_cst_name, p_cst_phoneNumber, p_cst_address, 
                p_cst_email, MD5(p_cst_password), FALSE, p_cst_latitude, p_cst_longitude);
        EXCEPTION
            WHEN others THEN
                RAISE NOTICE 'Error occurred: %', SQLERRM;
                ROLLBACK;
    END;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE userReg(
    IN p_cst_name VARCHAR(100),
    IN p_cst_phoneNumber VARCHAR(20),
    IN p_cst_address VARCHAR(100),
    IN p_cst_email VARCHAR(100),
    IN p_cst_password VARCHAR(100),
    IN p_cst_latitude DECIMAL(10,6),
    IN p_cst_longitude DECIMAL(10,6)
)
AS $$
DECLARE
    isLoggedin BOOLEAN;
    p_cst_id CHAR(10);
BEGIN
    IF NOT validateEmail(p_cst_email) THEN
        RAISE EXCEPTION 'Email already exists. Please use a different email.';
    END IF;

    IF NOT validatePassword(p_cst_password) THEN
        RAISE EXCEPTION 'Password lenght must be greater than 8';
    END IF;

    isLoggedin := False;
    p_cst_id := 'CST' || LPAD(NEXTVAL('cst_id_seq')::TEXT, 7, '0');

    BEGIN
        INSERT INTO customer (cst_id, cst_name, cst_phoneNumber, cst_address, 
                              cst_email, cst_password, cst_isLoggedIn, cst_latitude, cst_longitude)
        VALUES (p_cst_id, p_cst_name, p_cst_phoneNumber, p_cst_address, 
                p_cst_email, MD5(p_cst_password), FALSE, p_cst_latitude, p_cst_longitude);
        EXCEPTION
            WHEN others THEN
                RAISE NOTICE 'Error occurred: %', SQLERRM;
                ROLLBACK;
    END;
END;
$$ LANGUAGE plpgsql;

CALL userReg('Tunas', '081234567890', 'Jl. Kebon Jeruk No. 1', 'arema@gmail.com', 'aaaaaaaaaa', 0, 0);

ROLLBACK;
SELECT userRegister('asdasdasdasde', '08asdasd123', 'IasdasdTS', 'abasdasasddzxczasdasdaasdab@gmail.com', 'ahsdcunhoasadsudcs', 0, 0);

SELECT * FROM customer WHERE cst_name = 'Tunas';

DELETE FROM customer WHERE cst_name = 'asdasdasdasde';
    INSERT INTO customer
    VALUES (
        p_cst_id, p_cst_name, p_cst_phoneNumber, p_cst_address, 
        p_cst_email, MD5(p_cst_password), isLoggedin, p_cst_latitude, p_cst_longitude
    );
END;
$$ LANGUAGE plpgsql;

SELECT userRegister('Tunas', '08123', 'a', 'a', 'aremasingo', 0, 0);

SELECT * FROM customer WHERE cst_email = 'abasdasasddzxczasdasdaasdab@gmail.com';
## Example Usage
-- SELECT userRegister(
--     'CST0030001', 
--     'John Doe', 
--     '1234567890', 
--     '123 Main St', 
--     'john.doe@example.com', 
--     'securepassword', 
--     FALSE, 
--     37.77, 
--     -122.42
-- );

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
SELECT userLogin('a', 'aremasingo');
SELECT * FROM customer where cst_email = 'a';

## Fungsi untuk log out pengguna
CREATE OR REPLACE PROCEDURE userLogout(
    IN p_cst_email VARCHAR(100)
)
LANGUAGE plpgsql
AS $$
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
    END IF;
END;
$$;

## Example Usage 
CALL userLogout('a');


# UC3
-- Sebagai pengguna, Tina mampu melihat seluruh restoran terdekat yang tersedia
CREATE OR REPLACE FUNCTION getNearbyShops(
    p_latitude DECIMAL(10, 6),
    p_longitude DECIMAL(10, 6),
    p_filter INT
)
RETURNS TABLE (
    shop_id CHAR(10),
    shop_name VARCHAR(100),
    shop_address VARCHAR(100),
    distance FLOAT8
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        shop.shop_id,
        shop.shop_name,
        shop.shop_address,
        (point(p_longitude, p_latitude) <@> point(shop.shop_longitude, shop.shop_latitude)) AS distance
    FROM shop
    ORDER BY distance
    LIMIT p_filter;
END;
$$ LANGUAGE plpgsql;

-- WITH nearShops AS (
--     SELECT cst_address, shop_id, shop_name, shop_address, distance
--     FROM customer
--     CROSS JOIN getNearbyShops(customer.cst_latitude, customer.cst_longitude, 5)
--     WHERE customer.cst_id = 'CST0000010'
-- )
-- SELECT *
-- FROM nearShops;

# UC4
# Sebagai Pengguna, Tina mampu melakukan pencarian terhadap nama restoran yang menjual jenis atau nama kue tertentu.
CREATE OR REPLACE FUNCTION searchShopItem(
    p_item_name VARCHAR(100)
)
RETURNS TABLE (
    shop_id CHAR(10),
    shop_name VARCHAR(100),
    shop_address VARCHAR(100),
    shop_latitude DECIMAL(10,6),
    shop_longitude DECIMAL(10,6),
    item_id CHAR(10),
    item_name VARCHAR(100),
    item_price MONEY,
    item_stock INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        s.shop_id, s.shop_name, s.shop_address, s.shop_latitude, s.shop_longitude,
        i.item_id, i.item_name, i.item_price, si.shop_item_stock AS item_stock
    FROM shop s
    INNER JOIN shop_item si ON s.shop_id = si.shop_shop_id
    INNER JOIN items i ON si.items_item_id = i.item_id
    WHERE i.item_name ILIKE '%' || p_item_name || '%';
END;
$$ LANGUAGE plpgsql;

# Usage
SELECT *
FROM searchShopItem('Tiramisu');

# UC5
#Sebagai pengguna, Tina mampu melihat seluruh menu kue yang disediakan restoran tersebut

CREATE OR REPLACE FUNCTION getCakesByShop(shop_id CHAR(10))
RETURNS TABLE (
    item_id CHAR(10),
    item_name VARCHAR(100),
    item_price MONEY,
    item_category VARCHAR(50),
    shop_item_stock INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        i.item_id,
        i.item_name,
        i.item_price,
        i.item_category,
        si.shop_item_stock
    FROM 
        shop_item si
    INNER JOIN 
        items i ON si.items_item_id = i.item_id
    WHERE 
        si.shop_shop_id = shop_id
    ORDER BY
        i.item_id;
END;
$$ LANGUAGE plpgsql;
## usage
SELECT * FROM getCakesByShop('SHOP000001');

# UC6
# Sebagai pengguna, Tina mampu memilih dan memasukkan makanan ke dalam keranjang
CREATE SEQUENCE cart_seq
    START WITH  105001
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 200000;

DROP SEQUENCE cart_seq;

CREATE OR REPLACE FUNCTION add_to_cart(
    p_customer_cst_id CHAR(10),
    p_shop_item_id CHAR(10),
    p_item_amount INT
) RETURNS VOID AS $$
DECLARE
    v_cart_id CHAR(10);
    v_cart_totalBill MONEY;
    v_cart_isPaid BOOLEAN;
BEGIN
    -- Validate the item amount
    PERFORM validateAmount(p_item_amount);

    -- Validate the stock availability
    PERFORM validateStock(p_shop_item_id, p_item_amount);

    -- Get the customer's cart_id, create one if not exists
    SELECT cart_id
    INTO v_cart_id
    FROM cart
    WHERE customer_cst_id = p_customer_cst_id
    ORDER BY cart_id DESC
    LIMIT 1;

    SELECT EXISTS (
        SELECT cart_cart_id
        FROM transaction
        WHERE cart_cart_id = v_cart_id
    ) INTO v_cart_isPaid;

    IF v_cart_isPaid THEN
        v_cart_id := 'CRT' || LPAD(nextval('cart_seq')::TEXT, 7, '0');  -- Generating cart_id with the format CRT0000003
        INSERT INTO cart (cart_id, cart_totalBill, customer_cst_id)
        VALUES (v_cart_id, 0, p_customer_cst_id);
    END IF;

    -- Check if item already exists in the cart
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
        -- Add item to the cart
        INSERT INTO cart_shop_item (cart_cart_id, shop_item_shop_item_id, item_amount)
        VALUES (v_cart_id, p_shop_item_id, p_item_amount);
    END IF;

    -- Decrease the item stock
    UPDATE shop_item
    SET shop_item_stock = shop_item_stock - p_item_amount
    WHERE shop_item_id = p_shop_item_id;

    -- Calculate and update the cart's total bill
    v_cart_totalBill := calculateCartBill(v_cart_id);

    UPDATE cart
    SET cart_totalBill = v_cart_totalBill
    WHERE cart_id = v_cart_id;

    EXCEPTION
        WHEN others THEN
            RAISE NOTICE 'Error occurred: %', SQLERRM;
            ROLLBACK;
END;
$$ LANGUAGE plpgsql;

END;

-- SELECT add_to_cart('CST0000010', 'SHOPIT0007', 2);

-- SELECT checkouttrans('CRT0102171', 'cash', 'Go Food');

-- SELECT * FROM cart_shop_item JOIN cart ON cart_shop_item.cart_cart_id = cart.cart_id WHERE cart.customer_cst_id = 'CST0000010';

-- SELECT * FROM cart WHERE customer_cst_id = 'CST0000010';

-- SELECT * FROM transaction WHERE cart_cart_id = 'CRT0102171';

-- Example Usage
BEGIN;
SELECT add_to_cart('CST0000010', 'SHOPIT0002', 2);
COMMIT;
END;
# UC7
# Sebagai pengguna, Tina mampu melihat keranjang dan rincian pesanannya
-- Function to get cart and order details for a user
CREATE INDEX idx_cart_cart_id ON cart(cart_id);
CREATE INDEX idx_cart_customer_cst_id ON cart(customer_cst_id);
CREATE INDEX idx_cart_shop_item_cart_id ON cart_shop_item(cart_cart_id);
CREATE INDEX idx_cart_shop_item_shop_item_id ON cart_shop_item(shop_item_shop_item_id);
CREATE INDEX idx_shop_item_shop_item_id ON shop_item(shop_item_id);
CREATE INDEX idx_items_item_id ON items(item_id);

CREATE OR REPLACE FUNCTION get_cart_details(
    p_customer_cst_id CHAR(10)
) RETURNS TABLE (
    cart_id CHAR(10),
    item_id CHAR(10),
    item_name VARCHAR(100),
    item_price MONEY,
    item_amount INT,
    item_total MONEY,
    cart_total_bill MONEY
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        c.cart_id,
        si.shop_item_id AS item_id,
        i.item_name,
        i.item_price,
        csi.item_amount,
        (i.item_price * csi.item_amount) AS item_total,
        c.cart_totalBill AS cart_total_bill
    FROM 
        cart c
    INNER JOIN 
        cart_shop_item csi ON c.cart_id = csi.cart_cart_id
    INNER JOIN 
        shop_item si ON csi.shop_item_shop_item_id = si.shop_item_id
    INNER JOIN 
        items i ON si.items_item_id = i.item_id
    WHERE 
        c.customer_cst_id = p_customer_cst_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE call_get_cart_details(
    p_customer_cst_id CHAR(10)
)
LANGUAGE plpgsql
AS $$
BEGIN
    CREATE TEMP TABLE temp_cart_details (
        cart_id CHAR(10),
        item_id CHAR(10),
        item_name VARCHAR(100),
        item_price MONEY,
        item_amount INT,
        item_total MONEY,
        cart_total_bill MONEY
    );

    INSERT INTO temp_cart_details
    SELECT * FROM get_cart_details(p_customer_cst_id);
END;
$$; 
SELECT * FROM temp_cart_details;
BEGIN;
CALL call_get_cart_details('CST0000010');
SELECT * FROM temp_cart_details;
ROLLBACK; 
COMMIT;
END; 
-- Query the temporary table for the results



# UC8
DROP SEQUENCE transaction_seq;
CREATE SEQUENCE transaction_seq
    START WITH  90001
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE;

CREATE OR REPLACE FUNCTION CheckoutTrans(
    p_cart_id CHAR(10),
    p_paymentMethod VARCHAR(50),
    p_delivery VARCHAR(50)
)
RETURNS VOID AS $$
DECLARE
    v_tr_id CHAR(10);
    cart_exists BOOLEAN;
BEGIN
    
    BEGIN
    
    SELECT EXISTS (
        SELECT 1
        FROM transaction
        WHERE cart_cart_id = p_cart_id
    ) INTO cart_exists;

    IF NOT validatePayment(p_paymentMethod) THEN
        ROLLBACK;
        RAISE EXCEPTION 'Invalid payment method.';
    END IF;

    IF cart_exists THEN
        ROLLBACK; 
        RAISE EXCEPTION 'Cart % sudah ada dalam transaksi.', p_cart_id;
    END IF;

    CHECKPOINT; 
    v_tr_id := 'TRX' || LPAD(NEXTVAL('transaction_seq')::TEXT, 7, '0');
    

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
    END;
        
END;
$$ LANGUAGE plpgsql;

SELECT checkouttrans('CRT0090002', 'cash', 'Go Food');
SELECT * FROM transaction where tr_timestamp  > '2024-06-25';