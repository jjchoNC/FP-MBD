# Jerichi Nathanael Chrisnanta

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

# Muhammad Bimatara Indianto


