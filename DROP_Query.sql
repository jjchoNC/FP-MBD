-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-06-12 14:40:09.675

-- foreign keys
ALTER TABLE cart
    DROP CONSTRAINT cart_customer;

ALTER TABLE cart_shop_item
    DROP CONSTRAINT cart_shop_item_cart;

ALTER TABLE cart_shop_item
    DROP CONSTRAINT cart_shop_item_shop_item;

ALTER TABLE delivery
    DROP CONSTRAINT delivery_customer;

ALTER TABLE shop_item
    DROP CONSTRAINT shop_item_items;

ALTER TABLE shop_item
    DROP CONSTRAINT shop_item_shop;

ALTER TABLE supply
    DROP CONSTRAINT supply_employee;

ALTER TABLE supply_shop_item
    DROP CONSTRAINT supply_shop_item_shop_item;

ALTER TABLE supply_shop_item
    DROP CONSTRAINT supply_shop_item_supply;

ALTER TABLE supply
    DROP CONSTRAINT supply_supplier;

ALTER TABLE transaction
    DROP CONSTRAINT transaction_cart;

ALTER TABLE transaction
    DROP CONSTRAINT transaction_delivery;

-- tables
DROP TABLE cart;

DROP TABLE cart_shop_item;

DROP TABLE customer;

DROP TABLE delivery;

DROP TABLE employee;

DROP TABLE items;

DROP TABLE shop;

DROP TABLE shop_item;

DROP TABLE supplier;

DROP TABLE supply;

DROP TABLE supply_shop_item;

DROP TABLE transaction;

-- End of file.

