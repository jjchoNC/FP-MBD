-- Active: 1715739802341@@127.0.0.1@5432@tokokue@public
# Jericho Nathanael Chrisnanta
# Menacari customer dengan rata-rata jumlah jenis item dalam cart paling banyak

# Unoptimized [2327.465 ms]
EXPLAIN ANALYZE
SELECT * FROM (
    SELECT 
        c.customer_cst_id,
        AVG(item_counts.items) AS avg_item_category
    FROM
        cart c
    JOIN
        (
        SELECT 
            c.customer_cst_id, 
            c.cart_id, 
            COUNT(csi.shop_item_shop_item_id) AS items
        FROM
            cart c
        JOIN
            cart_shop_item csi ON c.cart_id = csi.cart_cart_id
        GROUP BY 
            c.cart_id, c.customer_cst_id
        ) AS item_counts ON c.cart_id = item_counts.cart_id
    GROUP BY
        c.customer_cst_id
    ORDER BY 
        avg_item_category DESC
)
WHERE avg_item_category = (
    SELECT 
        MAX(avg_item_category)
    FROM
        (
        SELECT 
            c.customer_cst_id,
            AVG(item_counts.items) AS avg_item_category
        FROM
            cart c
        JOIN
            (
            SELECT 
                c.customer_cst_id, 
                c.cart_id, 
                COUNT(csi.shop_item_shop_item_id) AS items
            FROM
                cart c
            JOIN
                cart_shop_item csi ON c.cart_id = csi.cart_cart_id
            GROUP BY 
                c.cart_id, c.customer_cst_id
            ) AS item_counts ON c.cart_id = item_counts.cart_id
        GROUP BY
            c.customer_cst_id
        ORDER BY 
            avg_item_category DESC
        ) AS avg_item_category
);

# Optimized [1171.097 ms]

EXPLAIN ANALYZE
WITH item_counts AS (
    SELECT 
        c.customer_cst_id, 
        c.cart_id, 
        COUNT(csi.shop_item_shop_item_id) AS items
    FROM
        cart c
    JOIN
        cart_shop_item csi ON c.cart_id = csi.cart_cart_id
    GROUP BY 
        c.cart_id, c.customer_cst_id
),
customer_avg_items AS (
    SELECT 
        c.customer_cst_id,
        AVG(ic.items) AS avg_item_category
    FROM
        cart c
    JOIN
        item_counts ic ON c.cart_id = ic.cart_id
    GROUP BY
        c.customer_cst_id
)
SELECT 
    *
FROM
    customer_avg_items
WHERE 
    avg_item_category = (SELECT MAX(avg_item_category) FROM customer_avg_items);


# Tunas Abdi Pranata / 5025221043
-- Menampilkan customer yang paling sering melakukan transaksi diurutkan secara descending

# 184.131 ms
-- EXPLAIN ANALYZE
SELECT 
    customer.cst_id, 
    customer.cst_name, 
    COUNT(transaction.tr_id) AS transaction_count
FROM 
    transaction
JOIN 
    cart ON transaction.cart_cart_id = cart.cart_id
JOIN 
    customer ON cart.customer_cst_id = customer.cst_id
GROUP BY 
    customer.cst_id, customer.cst_name
ORDER BY 
    transaction_count DESC

-- Optimized
CREATE INDEX idx_transaction_cart_id ON transaction(cart_cart_id);
CREATE INDEX idx_cart_id ON cart(cart_id);
CREATE INDEX idx_cart_customer_id ON cart(customer_cst_id);

-- EXPLAIN ANALYSE
WITH customer_transaction_counts AS (
    SELECT 
        ca.customer_cst_id, 
        COUNT(t.tr_id) AS transaction_count
    FROM 
        transaction t
    JOIN 
        cart ca ON t.cart_cart_id = ca.cart_id
    GROUP BY 
        ca.customer_cst_id
)
SELECT 
    c.cst_id, 
    c.cst_name, 
    ctc.transaction_count
FROM 
    customer_transaction_counts ctc
JOIN 
    customer c ON ctc.customer_cst_id = c.cst_id
ORDER BY 
    ctc.transaction_count DESC;


# Aditya Situmorang
-- membuat index yang akan digunakan untuk mempercepat query
CREATE INDEX idx_transaction_cart_id ON transaction(cart_cart_id);
CREATE INDEX idx_cart_cart_id ON cart(cart_id);
CREATE INDEX idx_cart_shop_item_cart_id ON cart_shop_item(cart_cart_id);
CREATE INDEX idx_cart_shop_item_shop_item_id ON cart_shop_item(shop_item_shop_item_id);
CREATE INDEX idx_shop_item_shop_id ON shop_item(shop_shop_id);
CREATE INDEX idx_shop_item_item_id ON shop_item(items_item_id);
CREATE INDEX idx_supply_shop_item_shop_item_id ON supply_shop_item(shop_item_shop_item_id);
CREATE INDEX idx_supply_shop_item_supply_id ON supply_shop_item(supply_supply_id);


# menampilkan pesanan yang paling sering dipesan untuk tiap toko
-- EXPLAIN ANALYZE
WITH ItemOrderQuantity AS (
    SELECT 
        si.shop_shop_id AS shop_id, 
        si.items_item_id AS item_id, 
        SUM(csi.item_amount) AS total_quantity
    FROM 
        transaction t
    JOIN 
        cart c ON t.cart_cart_id = c.cart_id
    JOIN 
        cart_shop_item csi ON c.cart_id = csi.cart_cart_id
    JOIN 
        shop_item si ON csi.shop_item_shop_item_id = si.shop_item_id
    GROUP BY 
        si.shop_shop_id, si.items_item_id
),
MaxItemOrder AS (
    SELECT
        shop_id,
        MAX(total_quantity) AS max_quantity
    FROM
        ItemOrderQuantity
    GROUP BY
        shop_id
)
SELECT 
    ioq.shop_id, 
    ioq.item_id, 
    ioq.total_quantity
FROM 
    ItemOrderQuantity ioq
JOIN 
    MaxItemOrder moi ON ioq.shop_id = moi.shop_id AND ioq.total_quantity = moi.max_quantity;


-- Menampilkan supply item yang paling sering di-supply oleh setiap toko
-- EXPLAIN ANALYZE
WITH SupplyItemQuantity AS (
    SELECT 
        si.shop_shop_id AS shop_id, 
        si.items_item_id AS item_id, 
        SUM(ssi.item_amount) AS total_quantity
    FROM 
        supply_shop_item ssi
    JOIN 
        shop_item si ON ssi.shop_item_shop_item_id = si.shop_item_id
    GROUP BY 
        si.shop_shop_id, si.items_item_id
),
MaxSupplyItem AS (
    SELECT
        shop_id,
        MAX(total_quantity) AS max_quantity
    FROM
        SupplyItemQuantity
    GROUP BY
        shop_id
)
SELECT 
    siq.shop_id, 
    siq.item_id, 
    siq.total_quantity
FROM 
    SupplyItemQuantity siq
JOIN 
    MaxSupplyItem msi ON siq.shop_id = msi.shop_id AND siq.total_quantity = msi.max_quantity;


# Muhammad Bimatara Indianto / 5025221260
# Mengidentifikasi item yang paling sering dimasukkan ke dalam keranjang belanja pada setiap toko.
EXPLAIN ANALYZE SELECT 
        s.shop_id,
        s.shop_name,
        i.item_id,
        i.item_name,
        i.item_price,
        i.item_category,
        SUM(csi.item_amount) AS total_order
    FROM 
        shop s
    INNER JOIN 
        shop_item si ON s.shop_id = si.shop_shop_id
    INNER JOIN 
        items i ON si.items_item_id = i.item_id
    INNER JOIN 
        cart_shop_item csi ON si.shop_item_id = csi.shop_item_shop_item_id
    GROUP BY 
        s.shop_id, s.shop_name, i.item_id, i.item_name, i.item_price, i.item_category
    ORDER BY 
        total_order DESC;

CREATE INDEX idx_shop_id ON shop(shop_id);
CREATE INDEX idx_shop_item_shop_id ON shop_item(shop_shop_id);
CREATE INDEX idx_shop_item_items_id ON shop_item(items_item_id);
CREATE INDEX idx_cart_shop_item_shop_item_id ON cart_shop_item(shop_item_shop_item_id);
CREATE INDEX idx_cart_shop_item_cart_id ON cart_shop_item(cart_cart_id);
CREATE INDEX idx_items_id ON items(item_id);

# 1m 27s
EXPLAIN ANALYZE SELECT 
    subquery.shop_id,
    subquery.shop_name,
    subquery.item_id,
    subquery.item_name,
    subquery.item_price,
    subquery.item_category,
    subquery.total_order
FROM (
    SELECT 
        s.shop_id,
        s.shop_name,
        i.item_id,
        i.item_name,
        i.item_price,
        i.item_category,
        (SELECT SUM(csi.item_amount) 
         FROM cart_shop_item csi 
         WHERE csi.shop_item_shop_item_id = si.shop_item_id) AS total_order
    FROM 
        shop s
    INNER JOIN 
        shop_item si ON s.shop_id = si.shop_shop_id
    INNER JOIN 
        items i ON si.items_item_id = i.item_id
    INNER JOIN 
        cart_shop_item csi ON si.shop_item_id = csi.shop_item_shop_item_id
    GROUP BY 
        s.shop_id, s.shop_name, i.item_id, i.item_name, i.item_price, i.item_category, si.shop_item_id
) AS subquery
ORDER BY 
    subquery.total_order DESC;


# Menampilkan semua atribut karyawan yang paling sering menangani Supply. 
EXPLAIN ANALYZE 
SELECT 
    e.emp_id, e.emp_name, e.emp_address, e.emp_phonenumber,
    COUNT(s.supply_id) AS total_supply
FROM 
    employee e
INNER JOIN 
    supply s ON e.emp_id = s.employee_emp_id
GROUP BY 
    e.emp_id, e.emp_name, e.emp_address, e.emp_phonenumber
ORDER BY 
    total_supply DESC;


CREATE INDEX idx_employee_emp_id ON employee(emp_id);
CREATE INDEX idx_supply_employee_emp_id ON supply(employee_emp_id);

EXPLAIN ANALYZE
SELECT 
    e.emp_id, 
    e.emp_name, 
    e.emp_address, 
    e.emp_phonenumber,
    COALESCE(s.total_supply, 0) AS total_supply
FROM 
    employee e
LEFT JOIN (
    SELECT 
        employee_emp_id, 
        COUNT(supply_id) AS total_supply
    FROM 
        supply
    GROUP BY 
        employee_emp_id
) s ON e.emp_id = s.employee_emp_id
ORDER BY 
    total_supply DESC;