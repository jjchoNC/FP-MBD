INSERT INTO customer (cst_id, cst_name, cst_phoneNumber, cst_address) VALUES
('CST001', 'John Doe', '1234567890', '123 Main St'),
('CST002', 'Jane Smith', '2345678901', '456 Oak St'),
('CST003', 'Alice Johnson', '3456789012', '789 Pine St');

INSERT INTO employee (emp_id, emp_name, emp_phoneNumber, emp_address, emp_jobSection) VALUES
('EMP001', 'David Miller', '1234567890', '123 Main St', 'Sales'),
('EMP002', 'Emily Davis', '2345678901', '456 Oak St', 'Support'),
('EMP003', 'James Wilson', '3456789012', '789 Pine St', 'Development');

INSERT INTO item (item_id, item_name, item_price, item_category) VALUES
('ITM001', 'Chocolate Cake', 9.99, 'Birthday Cake'),
('ITM002', 'Cromboloni', 19.99, 'Pastry'),
('ITM003', 'Red Velvet cake', 14.99, 'Birthday Cake');

INSERT INTO supplier (sup_id, sup_name, sup_address, sup_phone) VALUES
('SUP001', 'Supply Co A', '100 Industrial Rd', '1234567890'),
('SUP002', 'Distributors B', '200 Market St', '2345678901'),
('SUP003', 'Wholesale C', '300 Commerce Blvd', '3456789012');

INSERT INTO supplier_item (supplier_sup_id, item_item_id, item_amount) VALUES
('SUP001', 'ITM001', 100),
('SUP001', 'ITM002', 200),
('SUP002', 'ITM003', 150);

INSERT INTO transaction (tr_id, tr_totalBill, tr_date, tr_paymentMethod, customer_cst_id, employee_emp_id) VALUES
('TRX001', 199.99, '2023-01-01', 'Credit Card', 'CST001', 'EMP001'),
('TRX002', 299.99, '2023-01-02', 'Cash', 'CST002', 'EMP002'),
('TRX003', 399.99, '2023-01-03', 'Debit Card', 'CST003', 'EMP003');

INSERT INTO transaction_item (transaction_tr_id, item_item_id, item_amount) VALUES
('TRX001', 'ITM001', 2),
('TRX001', 'ITM002', 3),
('TRX002', 'ITM003', 1);