CREATE TABLE cart (
    cart_id char(10)  NOT NULL,
    cart_totalBill int  NOT NULL,
    customer_cst_id char(10)  NOT NULL,
    CONSTRAINT cart_pk PRIMARY KEY (cart_id)
);

CREATE TABLE cart_shop_item (
    cart_cart_id char(10)  NOT NULL,
    shop_item_shop_item_id char(10)  NOT NULL,
    CONSTRAINT cart_shop_item_pk PRIMARY KEY (cart_cart_id,shop_item_shop_item_id)
);

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

CREATE TABLE delivery (
    delivery_id char(10)  NOT NULL,
    delivery_address varchar(100)  NOT NULL,
    delivery_isArived boolean  NOT NULL,
    delivery_courier varchar(50)  NOT NULL,
    customer_cst_id char(10)  NOT NULL,
    CONSTRAINT delivery_pk PRIMARY KEY (delivery_id)
);

CREATE TABLE employee (
    emp_id char(10)  NOT NULL,
    emp_name varchar(100)  NOT NULL,
    emp_phoneNumber varchar(20)  NULL,
    emp_address varchar(100)  NOT NULL,
    CONSTRAINT employee_pk PRIMARY KEY (emp_id)
);

CREATE TABLE items (
    item_id char(10)  NOT NULL,
    item_name varchar(100)  NOT NULL,
    item_price money  NOT NULL,
    item_category varchar(50)  NOT NULL,
    CONSTRAINT items_pk PRIMARY KEY (item_id)
);

CREATE TABLE shop (
    shop_id char(10)  NOT NULL,
    shop_name varchar(100)  NOT NULL,
    shop_address varchar(100)  NOT NULL,
    shop_latitude decimal(5,2)  NOT NULL,
    shop_longitude decimal(5,2)  NOT NULL,
    CONSTRAINT shop_pk PRIMARY KEY (shop_id)
);

CREATE TABLE shop_item (
    shop_item_id char(10)  NOT NULL,
    shop_item_stock int  NOT NULL,
    shop_shop_id char(10)  NOT NULL,
    items_item_id char(10)  NOT NULL,
    CONSTRAINT shop_item_pk PRIMARY KEY (shop_item_id)
);

CREATE TABLE supplier (
    sup_id char(10)  NOT NULL,
    sup_name varchar(100)  NOT NULL,
    sup_address varchar(100)  NOT NULL,
    sup_phone varchar(20)  NULL,
    CONSTRAINT supplier_pk PRIMARY KEY (sup_id)
);

CREATE TABLE supply (
    supply_id char(10)  NOT NULL,
    supply_totalBill money  NOT NULL,
    supply_date timestamp  NOT NULL,
    supply_paymentMethod varchar(50)  NOT NULL,
    employee_emp_id char(10)  NOT NULL,
    supplier_sup_id char(10)  NOT NULL,
    CONSTRAINT supply_pk PRIMARY KEY (supply_id)
);

CREATE TABLE supply_shop_item (
    supply_supply_id char(10)  NOT NULL,
    shop_item_shop_item_id char(10)  NOT NULL,
    item_amount int  NOT NULL,
    CONSTRAINT supply_shop_item_pk PRIMARY KEY (supply_supply_id,shop_item_shop_item_id)
);

CREATE TABLE transaction (
    tr_id char(10)  NOT NULL,
    tr_timeStamp timestamp  NOT NULL,
    tr_paymentMethod varchar(50)  NOT NULL,
    cart_cart_id char(10)  NOT NULL,
    delivery_delivery_id char(10)  NOT NULL,
    CONSTRAINT transaction_pk PRIMARY KEY (tr_id)
);

ALTER TABLE cart ADD CONSTRAINT cart_customer
    FOREIGN KEY (customer_cst_id)
    REFERENCES customer (cst_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

ALTER TABLE cart_shop_item ADD CONSTRAINT cart_shop_item_cart
    FOREIGN KEY (cart_cart_id)
    REFERENCES cart (cart_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

ALTER TABLE cart_shop_item ADD CONSTRAINT cart_shop_item_shop_item
    FOREIGN KEY (shop_item_shop_item_id)
    REFERENCES shop_item (shop_item_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

ALTER TABLE delivery ADD CONSTRAINT delivery_customer
    FOREIGN KEY (customer_cst_id)
    REFERENCES customer (cst_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

ALTER TABLE shop_item ADD CONSTRAINT shop_item_items
    FOREIGN KEY (items_item_id)
    REFERENCES items (item_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

ALTER TABLE shop_item ADD CONSTRAINT shop_item_shop
    FOREIGN KEY (shop_shop_id)
    REFERENCES shop (shop_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

ALTER TABLE supply ADD CONSTRAINT supply_employee
    FOREIGN KEY (employee_emp_id)
    REFERENCES employee (emp_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

ALTER TABLE supply_shop_item ADD CONSTRAINT supply_shop_item_shop_item
    FOREIGN KEY (shop_item_shop_item_id)
    REFERENCES shop_item (shop_item_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

ALTER TABLE supply_shop_item ADD CONSTRAINT supply_shop_item_supply
    FOREIGN KEY (supply_supply_id)
    REFERENCES supply (supply_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

ALTER TABLE supply ADD CONSTRAINT supply_supplier
    FOREIGN KEY (supplier_sup_id)
    REFERENCES supplier (sup_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

ALTER TABLE transaction ADD CONSTRAINT transaction_cart
    FOREIGN KEY (cart_cart_id)
    REFERENCES cart (cart_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

ALTER TABLE transaction ADD CONSTRAINT transaction_delivery
    FOREIGN KEY (delivery_delivery_id)
    REFERENCES delivery (delivery_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;


