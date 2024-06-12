-- Active: 1714479550472@@127.0.0.1@5432@fp_cakeshop@public








SELECT SUM(supply_item.item_amount * item.item_price)
FROM supply_item
INNER JOIN item ON supply_item.item_item_id = item.item_id
WHERE supply_item.supply_supply_id = 'SPL0000001';