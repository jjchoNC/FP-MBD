-- Created by Vertabelo (http://vertabelo.com)
-- Last modification date: 2024-06-12 14:40:09.675

-- tables
-- Table: cart
CREATE TABLE cart (
    cart_id char(10)  NOT NULL,
    cart_totalBill int  NOT NULL,
    customer_cst_id char(10)  NOT NULL,
    CONSTRAINT cart_pk PRIMARY KEY (cart_id)
);

-- Table: cart_shop_item
CREATE TABLE cart_shop_item (
    cart_cart_id char(10)  NOT NULL,
    shop_item_shop_item_id char(10)  NOT NULL,
    CONSTRAINT cart_shop_item_pk PRIMARY KEY (cart_cart_id,shop_item_shop_item_id)
);

-- Table: customer
CREATE TABLE customer (
    cst_id char(10)  NOT NULL,
    cst_name varchar(100)  NOT NULL,
    cst_phoneNumber varchar(20)  NULL,
    cst_address varchar(100)  NOT NULL,
    cst_email varchar(100)  NOT NULL,
    cst_password char(32)  NOT NULL,
    cst_isLoggedIn boolean  NOT NULL,
    cst_latitude decimal(5,2)  NOT NULL,
    cst_longitude decimal(5,2)  NOT NULL,
    CONSTRAINT customer_pk PRIMARY KEY (cst_id)
);

-- Table: delivery
CREATE TABLE delivery (
    delivery_id char(10)  NOT NULL,
    delivery_address varchar(100)  NOT NULL,
    delivery_isArived boolean  NOT NULL,
    delivery_courier varchar(50)  NOT NULL,
    customer_cst_id char(10)  NOT NULL,
    CONSTRAINT delivery_pk PRIMARY KEY (delivery_id)
);

-- Table: employee
CREATE TABLE employee (
    emp_id char(10)  NOT NULL,
    emp_name varchar(100)  NOT NULL,
    emp_phoneNumber varchar(20)  NULL,
    emp_address varchar(100)  NOT NULL,
    CONSTRAINT employee_pk PRIMARY KEY (emp_id)
);

-- Table: items
CREATE TABLE items (
    item_id char(10)  NOT NULL,
    item_name varchar(100)  NOT NULL,
    item_price money  NOT NULL,
    item_category varchar(50)  NOT NULL,
    CONSTRAINT items_pk PRIMARY KEY (item_id)
);

-- Table: shop
CREATE TABLE shop (
    shop_id char(10)  NOT NULL,
    shop_name varchar(100)  NOT NULL,
    shop_address varchar(100)  NOT NULL,
    shop_latitude decimal(5,2)  NOT NULL,
    shop_longitude decimal(5,2)  NOT NULL,
    CONSTRAINT shop_pk PRIMARY KEY (shop_id)
);

-- Table: shop_item
CREATE TABLE shop_item (
    shop_item_id char(10)  NOT NULL,
    shop_item_stock int  NOT NULL,
    shop_shop_id char(10)  NOT NULL,
    items_item_id char(10)  NOT NULL,
    CONSTRAINT shop_item_pk PRIMARY KEY (shop_item_id)
);

-- Table: supplier
CREATE TABLE supplier (
    sup_id char(10)  NOT NULL,
    sup_name varchar(100)  NOT NULL,
    sup_address varchar(100)  NOT NULL,
    sup_phone varchar(20)  NULL,
    CONSTRAINT supplier_pk PRIMARY KEY (sup_id)
);

-- Table: supply
CREATE TABLE supply (
    supply_id char(10)  NOT NULL,
    supply_totalBill money  NOT NULL,
    supply_date timestamp  NOT NULL,
    supply_paymentMethod varchar(50)  NOT NULL,
    employee_emp_id char(10)  NOT NULL,
    supplier_sup_id char(10)  NOT NULL,
    CONSTRAINT supply_pk PRIMARY KEY (supply_id)
);

-- Table: supply_shop_item
CREATE TABLE supply_shop_item (
    supply_supply_id char(10)  NOT NULL,
    shop_item_shop_item_id char(10)  NOT NULL,
    item_amount int  NOT NULL,
    CONSTRAINT supply_shop_item_pk PRIMARY KEY (supply_supply_id,shop_item_shop_item_id)
);

-- Table: transaction
CREATE TABLE transaction (
    tr_id char(10)  NOT NULL,
    tr_timeStamp timestamp  NOT NULL,
    tr_paymentMethod varchar(50)  NOT NULL,
    cart_cart_id char(10)  NOT NULL,
    delivery_delivery_id char(10)  NOT NULL,
    CONSTRAINT transaction_pk PRIMARY KEY (tr_id)
);

-- foreign keys
-- Reference: cart_customer (table: cart)
ALTER TABLE cart ADD CONSTRAINT cart_customer
    FOREIGN KEY (customer_cst_id)
    REFERENCES customer (cst_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: cart_shop_item_cart (table: cart_shop_item)
ALTER TABLE cart_shop_item ADD CONSTRAINT cart_shop_item_cart
    FOREIGN KEY (cart_cart_id)
    REFERENCES cart (cart_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: cart_shop_item_shop_item (table: cart_shop_item)
ALTER TABLE cart_shop_item ADD CONSTRAINT cart_shop_item_shop_item
    FOREIGN KEY (shop_item_shop_item_id)
    REFERENCES shop_item (shop_item_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: delivery_customer (table: delivery)
ALTER TABLE delivery ADD CONSTRAINT delivery_customer
    FOREIGN KEY (customer_cst_id)
    REFERENCES customer (cst_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: shop_item_items (table: shop_item)
ALTER TABLE shop_item ADD CONSTRAINT shop_item_items
    FOREIGN KEY (items_item_id)
    REFERENCES items (item_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: shop_item_shop (table: shop_item)
ALTER TABLE shop_item ADD CONSTRAINT shop_item_shop
    FOREIGN KEY (shop_shop_id)
    REFERENCES shop (shop_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: supply_employee (table: supply)
ALTER TABLE supply ADD CONSTRAINT supply_employee
    FOREIGN KEY (employee_emp_id)
    REFERENCES employee (emp_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: supply_shop_item_shop_item (table: supply_shop_item)
ALTER TABLE supply_shop_item ADD CONSTRAINT supply_shop_item_shop_item
    FOREIGN KEY (shop_item_shop_item_id)
    REFERENCES shop_item (shop_item_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: supply_shop_item_supply (table: supply_shop_item)
ALTER TABLE supply_shop_item ADD CONSTRAINT supply_shop_item_supply
    FOREIGN KEY (supply_supply_id)
    REFERENCES supply (supply_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: supply_supplier (table: supply)
ALTER TABLE supply ADD CONSTRAINT supply_supplier
    FOREIGN KEY (supplier_sup_id)
    REFERENCES supplier (sup_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: transaction_cart (table: transaction)
ALTER TABLE transaction ADD CONSTRAINT transaction_cart
    FOREIGN KEY (cart_cart_id)
    REFERENCES cart (cart_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- Reference: transaction_delivery (table: transaction)
ALTER TABLE transaction ADD CONSTRAINT transaction_delivery
    FOREIGN KEY (delivery_delivery_id)
    REFERENCES delivery (delivery_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

-- End of file.

