-- Active: 1714479550472@@127.0.0.1@5432@fp_cakeshop@public
CREATE TABLE customer (
    cst_id char(10)  NOT NULL,
    cst_name varchar(100)  NOT NULL,
    cst_phoneNumber varchar(20)  NULL,
    cst_address varchar(100)  NOT NULL,
    CONSTRAINT customer_pk PRIMARY KEY (cst_id)
);

CREATE TABLE employee (
    emp_id char(10)  NOT NULL,
    emp_name varchar(100)  NOT NULL,
    emp_phoneNumber varchar(20)  NULL,
    emp_address varchar(100)  NOT NULL,
    emp_jobSection varchar(100)  NOT NULL,
    CONSTRAINT employee_pk PRIMARY KEY (emp_id)
);

CREATE TABLE item (
    item_id char(10)  NOT NULL,
    item_name varchar(100)  NOT NULL,
    item_price money  NOT NULL,
    item_category varchar(50)  NOT NULL,
    item_stock int  NOT NULL,
    CONSTRAINT item_pk PRIMARY KEY (item_id)
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
    supply_date timestamp  NOT NULL,
    supply_totalBill money  NOT NULL,
    supply_paymentMethod varchar(50)  NOT NULL,
    employee_emp_id char(10)  NOT NULL,
    supplier_sup_id char(10)  NOT NULL,
    CONSTRAINT supply_pk PRIMARY KEY (supply_id)
);

CREATE TABLE supply_item (
    supply_supply_id char(10)  NOT NULL,
    item_item_id char(10)  NOT NULL,
    item_amount int  NOT NULL,
    CONSTRAINT supply_item_pk PRIMARY KEY (supply_supply_id,item_item_id)
);

CREATE TABLE transaction (
    tr_id char(10)  NOT NULL,
    tr_totalBill money  NOT NULL,
    tr_date timestamp  NOT NULL,
    tr_paymentMethod varchar(50)  NOT NULL,
    customer_cst_id char(10)  NOT NULL,
    employee_emp_id char(10)  NOT NULL,
    CONSTRAINT transaction_pk PRIMARY KEY (tr_id)
);

CREATE TABLE transaction_item (
    transaction_tr_id char(10)  NOT NULL,
    item_item_id char(10)  NOT NULL,
    item_amount int  NOT NULL,
    CONSTRAINT transaction_item_pk PRIMARY KEY (transaction_tr_id,item_item_id)
);

ALTER TABLE supply ADD CONSTRAINT supply_employee
    FOREIGN KEY (employee_emp_id)
    REFERENCES employee (emp_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

ALTER TABLE supply_item ADD CONSTRAINT supply_item_item
    FOREIGN KEY (item_item_id)
    REFERENCES item (item_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

ALTER TABLE supply_item ADD CONSTRAINT supply_item_supply
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

ALTER TABLE transaction ADD CONSTRAINT transaction_customer
    FOREIGN KEY (customer_cst_id)
    REFERENCES customer (cst_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

ALTER TABLE transaction ADD CONSTRAINT transaction_employee
    FOREIGN KEY (employee_emp_id)
    REFERENCES employee (emp_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

ALTER TABLE transaction_item ADD CONSTRAINT transaction_item_item
    FOREIGN KEY (item_item_id)
    REFERENCES item (item_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

ALTER TABLE transaction_item ADD CONSTRAINT transaction_item_transaction
    FOREIGN KEY (transaction_tr_id)
    REFERENCES transaction (tr_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;


