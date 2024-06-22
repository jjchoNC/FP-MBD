-- Active: 1715666446348@@localhost@5432@cakeshop@public
# Jericho Nathanael Chrisnanta

# Tunas Abdi Pranata 

# Aditya Situmorang
# menampilkan pesanan yang paling sering dipesan untuk tiap toko
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
RankedItems AS (
    SELECT 
        shop_id, 
        item_id, 
        total_quantity,
        ROW_NUMBER() OVER (PARTITION BY shop_id ORDER BY total_quantity DESC) AS rank
    FROM 
        ItemOrderQuantity
)
SELECT 
    shop_id, 
    item_id, 
    total_quantity
FROM 
    RankedItems
WHERE 
    rank = 1;

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