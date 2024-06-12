-- Active: 1714479550472@@127.0.0.1@5432@fp_cakeshop@public








INSERT INTO supply (supply_id, supply_date, supply_totalBill, supply_paymentMethod, employee_emp_id, supplier_sup_id) VALUES 
('SPL0000001', '2024-06-11 12:00:00', 20500000,'Credit Card', 'EMP0000001', 'SUP0000001'),
('SPL0000002', '2024-06-12 09:00:00', 26250000,'Cash', 'EMP0000001', 'SUP0000002');

INSERT INTO supply_item (supply_supply_id, item_item_id, item_amount) VALUES
('SPL0000001', 'ITM0000001', 100),
('SPL0000001', 'ITM0000002', 200),
('SPL0000002', 'ITM0000003', 150);

INSERT INTO transaction (tr_id, tr_totalBill, tr_date, tr_paymentMethod, customer_cst_id, employee_emp_id) VALUES
('TRX0000001', 370000, '2023-01-01', 'Credit Card', 'CST0000001', 'EMP0000002'),
('TRX0000002', 175000, '2023-01-02', 'Cash', 'CST0000002', 'EMP0000002'),
('TRX0000003', 175000, '2023-01-03', 'Debit Card', 'CST0000003', 'EMP0000002');

INSERT INTO transaction_item (transaction_tr_id, item_item_id, item_amount) VALUES
('TRX0000001', 'ITM0000001', 2),
('TRX0000001', 'ITM0000002', 3),
('TRX0000002', 'ITM0000003', 1),
('TRX0000003', 'ITM0000003', 1);


SELECT SUM(supply_item.item_amount * item.item_price)
FROM supply_item
INNER JOIN item ON supply_item.item_item_id = item.item_id
WHERE supply_item.supply_supply_id = 'SPL0000001';