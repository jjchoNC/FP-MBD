-- Drop foreign key constraints first
ALTER TABLE supply_item DROP CONSTRAINT supply_item_item;
ALTER TABLE supply_item DROP CONSTRAINT supply_item_supply;
ALTER TABLE supply DROP CONSTRAINT supply_employee;
ALTER TABLE supply DROP CONSTRAINT supply_supplier;
ALTER TABLE transaction DROP CONSTRAINT transaction_customer;
ALTER TABLE transaction DROP CONSTRAINT transaction_employee;
ALTER TABLE transaction_item DROP CONSTRAINT transaction_item_item;
ALTER TABLE transaction_item DROP CONSTRAINT transaction_item_transaction;
ALTER 

-- Drop tables in the correct order
DROP TABLE IF EXISTS transaction_item;
DROP TABLE IF EXISTS transaction;
DROP TABLE IF EXISTS supply_item;
DROP TABLE IF EXISTS supply;
DROP TABLE IF EXISTS supplier;
DROP TABLE IF EXISTS item;
DROP TABLE IF EXISTS employee;
DROP TABLE IF EXISTS customer;
