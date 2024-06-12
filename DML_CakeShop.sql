-- Active: 1714479550472@@127.0.0.1@5432@fp_cakeshop@public
INSERT INTO customer (cst_id, cst_name, cst_phoneNumber, cst_address) VALUES
('CST0000001', 'John Doe', '1234567890', '123 Main St'),
('CST0000002', 'Jane Smith', '2345678901', '456 Oak St'),
('CST0000003', 'Alice Johnson', '3456789012', '789 Pine St');

INSERT INTO employee (emp_id, emp_name, emp_phoneNumber, emp_address, emp_jobSection) VALUES
('EMP0000001', 'David Miller', '1234567890', '123 Main St', 'Manager'),
('EMP0000002', 'Emily Davis', '2345678901', '456 Oak St', 'Cashier'),
('EMP0000003', 'James Wilson', '3456789012', '789 Pine St', 'Development');

INSERT INTO item (item_id, item_name, item_price, item_category, item_stock) VALUES
/* ('ITM0000001', 'Chocolate Cake', 125000, 'Birthday Cake', 30),
('ITM0000002', 'Cromboloni', 40000, 'Pastry', 15),
('ITM0000003', 'Red Velvet Cake', 175000, 'Birthday Cake', 25), */
('ITM0000004', 'Strawberry Shortcake', 140000, 'Cake', 20),
('ITM0000005', 'Blueberry Muffin', 30000, 'Pastry', 40),
('ITM0000006', 'Chocolate Chip Cookies', 50000, 'Cookies', 100),
('ITM0000007', 'Vanilla Pudding', 25000, 'Pudding', 50),
('ITM0000008', 'Chocolate Milkshake', 35000, 'Milkshake', 35),
('ITM0000009', 'Tiramisu', 70000, 'Cake', 10),
('ITM0000010', 'Lemon Tart', 45000, 'Pastry', 20),
('ITM0000011', 'Oatmeal Raisin Cookies', 45000, 'Cookies', 80),
('ITM0000012', 'Mango Pudding', 30000, 'Pudding', 30),
('ITM0000013', 'Strawberry Milkshake', 30000, 'Milkshake', 25),
('ITM0000014', 'Cheesecake', 150000, 'Cake', 15),
('ITM0000015', 'Croissant', 20000, 'Pastry', 25),
('ITM0000016', 'Peanut Butter Cookies', 40000, 'Cookies', 90),
('ITM0000017', 'Chocolate Pudding', 25000, 'Pudding', 35),
('ITM0000018', 'Banana Milkshake', 32000, 'Milkshake', 20),
('ITM0000019', 'Carrot Cake', 130000, 'Cake', 18),
('ITM0000020', 'Cinnamon Roll', 35000, 'Pastry', 15),
('ITM0000021', 'Almond Cookies', 47000, 'Cookies', 70),
('ITM0000022', 'Rice Pudding', 28000, 'Pudding', 40),
('ITM0000023', 'Vanilla Milkshake', 30000, 'Milkshake', 30),
('ITM0000024', 'Black Forest Cake', 160000, 'Birthday Cake', 22),
('ITM0000025', 'Chocolate Eclair', 50000, 'Pastry', 10),
('ITM0000026', 'Butter Cookies', 35000, 'Cookies', 60),
('ITM0000027', 'Butterscotch Pudding', 26000, 'Pudding', 45),
('ITM0000028', 'Coffee Milkshake', 33000, 'Milkshake', 18),
('ITM0000029', 'Lemon Drizzle Cake', 120000, 'Cake', 12),
('ITM0000030', 'Apple Turnover', 42000, 'Pastry', 30),
('ITM0000031', 'Shortbread Cookies', 38000, 'Cookies', 55),
('ITM0000032', 'Coconut Pudding', 27000, 'Pudding', 25),
('ITM0000033', 'Mango Milkshake', 34000, 'Milkshake', 20),
('ITM0000034', 'Pineapple Upside-Down Cake', 140000, 'Cake', 14),
('ITM0000035', 'Pain au Chocolat', 45000, 'Pastry', 15),
('ITM0000036', 'Snickerdoodle Cookies', 37000, 'Cookies', 65),
('ITM0000037', 'Vanilla Pudding', 24000, 'Pudding', 35),
('ITM0000038', 'Mixed Berry Milkshake', 35000, 'Milkshake', 22),
('ITM0000039', 'Funfetti Cake', 125000, 'Birthday Cake', 20),
('ITM0000040', 'Napoleon Pastry', 60000, 'Pastry', 12),
('ITM0000041', 'Gingerbread Cookies', 42000, 'Cookies', 75),
('ITM0000042', 'Egg Pudding', 25000, 'Pudding', 30),
('ITM0000043', 'Cherry Milkshake', 33000, 'Milkshake', 20),
('ITM0000044', 'Opera Cake', 165000, 'Cake', 10),
('ITM0000045', 'Cream Puff', 30000, 'Pastry', 18),
('ITM0000046', 'Macadamia Nut Cookies', 50000, 'Cookies', 85),
('ITM0000047', 'Caramel Pudding', 27000, 'Pudding', 30),
('ITM0000048', 'Matcha Milkshake', 36000, 'Milkshake', 15),
('ITM0000049', 'Rainbow Cake', 145000, 'Birthday Cake', 25),
('ITM0000050', 'Puff Pastry', 40000, 'Pastry', 20),
('ITM0000051', 'White Chocolate Macadamia Cookies', 52000, 'Cookies', 60),
('ITM0000052', 'Tapioca Pudding', 26000, 'Pudding', 30),
('ITM0000053', 'Pistachio Milkshake', 35000, 'Milkshake', 10),
('ITM0000054', 'Tres Leches Cake', 155000, 'Cake', 8),
('ITM0000055', 'Palmier', 28000, 'Pastry', 20),
('ITM0000056', 'Molasses Cookies', 39000, 'Cookies', 75),
('ITM0000057', 'Bread Pudding', 30000, 'Pudding', 25),
('ITM0000058', 'Hazelnut Milkshake', 37000, 'Milkshake', 12),
('ITM0000059', 'Meringue Cake', 150000, 'Birthday Cake', 18),
('ITM0000060', 'Choux Pastry', 45000, 'Pastry', 20),
('ITM0000061', 'Sugar Cookies', 32000, 'Cookies', 90),
('ITM0000062', 'Corn Pudding', 25000, 'Pudding', 20),
('ITM0000063', 'Peach Milkshake', 34000, 'Milkshake', 15),
('ITM0000064', 'Ice Cream Cake', 160000, 'Birthday Cake', 12),
('ITM0000065', 'Bear Claw Pastry', 50000, 'Pastry', 10),
('ITM0000066', 'Anzac Biscuits', 36000, 'Cookies', 70),
('ITM0000067', 'Sago Pudding', 27000, 'Pudding', 25),
('ITM0000068', 'Blackberry Milkshake', 35000, 'Milkshake', 10),
('ITM0000069', 'Fruit Cake', 130000, 'Cake', 14),
('ITM0000070', 'Danish Pastry', 42000, 'Pastry', 18),
('ITM0000071', 'Fortune Cookies', 30000, 'Cookies', 80),
('ITM0000072', 'Chia Pudding', 28000, 'Pudding', 30),
('ITM0000073', 'Papaya Milkshake', 32000, 'Milkshake', 20),
('ITM0000074', 'Marble Cake', 140000, 'Cake', 16),
('ITM0000075', 'Rugelach', 40000, 'Pastry', 20);

INSERT INTO supplier (sup_id, sup_name, sup_address, sup_phone) VALUES
('SUP0000001', 'Supply Co A', '100 Industrial Rd', '1234567890'),
('SUP0000002', 'Distributors B', '200 Market St', '2345678901'),
('SUP0000003', 'Wholesale C', '300 Commerce Blvd', '3456789012');

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