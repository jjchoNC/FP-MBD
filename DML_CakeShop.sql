-- Active: 1715773664265@@localhost@5432@cakeshop@public
INSERT INTO customer (cst_id, cst_name, cst_phoneNumber, cst_address) VALUES
('CST0000001', 'John Doe', '1234567890', '123 Main St'),
('CST0000002', 'Jane Smith', '2345678901', '456 Oak St'),
('CST0000003', 'Alice Johnson', '3456789012', '789 Pine St');

INSERT INTO employee (emp_id, emp_name, emp_phoneNumber, emp_address, emp_jobSection) VALUES
('EMP0000001', 'David Miller', '1234567890', '123 Main St', 'Manager'),
('EMP0000002', 'Emily Davis', '2345678901', '456 Oak St', 'Cashier'),
('EMP0000003', 'James Wilson', '3456789012', '789 Pine St', 'Development');

INSERT INTO item (item_id, item_name, item_price, item_category, item_stock) VALUES
('ITM0000001', 'Chocolate Cake', 125000, 'Birthday Cake', 30),
('ITM0000002', 'Cromboloni', 40000, 'Pastry', 15),
('ITM0000003', 'Red Velvet Cake', 175000, 'Birthday Cake', 25);

INSERT INTO supplier (sup_id, sup_name, sup_address, sup_phone) VALUES
('SUP0000001', 'Supply Co A', '100 Industrial Rd', '1234567890'),
('SUP0000002', 'Distributors B', '200 Market St', '2345678901'),
('SUP0000003', 'Wholesale C', '300 Commerce Blvd', '3456789012');

INSERT INTO supply (supply_id, supply_date, supply_paymentMethod, employee_emp_id, supplier_sup_id) VALUES 
('SPL0000001', '2024-06-11 12:00:00', 'Credit Card', 'EMP0000001', 'SUP0000001'),
('SPL0000002', '2024-06-12 09:00:00', 'Cash', 'EMP0000001', 'SUP0000002'),
('SPL0000003', '2024-06-13 15:30:00', 'Bank Transfer', 'EMP0000001', 'SUP0000003');

INSERT INTO supplier_item (supply_supply_id, item_item_id, item_amount) VALUES
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