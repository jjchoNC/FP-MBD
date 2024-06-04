
CREATE TABLE customer (
    cst_id char(6)  NOT NULL,
    cst_name varchar(100)  NOT NULL,
    cst_phoneNumber varchar(20)  NULL,
    cst_address varchar(100)  NOT NULL,
    CONSTRAINT customer_pk PRIMARY KEY (cst_id)
);

CREATE TABLE employee (
    emp_id char(6)  NOT NULL,
    emp_name varchar(100)  NOT NULL,
    emp_phoneNumber varchar(20)  NULL,
    emp_address varchar(100)  NOT NULL,
    emp_jobSection varchar(100)  NOT NULL,
    CONSTRAINT employee_pk PRIMARY KEY (emp_id)
);

CREATE TABLE item (
    item_id char(6)  NOT NULL,
    item_name varchar(100)  NOT NULL,
    item_price money  NOT NULL,
    item_category varchar(50)  NOT NULL,
    CONSTRAINT item_pk PRIMARY KEY (item_id)
);

CREATE TABLE supplier (
    sup_id char(6)  NOT NULL,
    sup_name varchar(100)  NOT NULL,
    sup_address varchar(100)  NOT NULL,
    sup_phone varchar(20)  NULL,
    CONSTRAINT supplier_pk PRIMARY KEY (sup_id)
);

CREATE TABLE supplier_item (
    supplier_sup_id char(6)  NOT NULL,
    item_item_id char(6)  NOT NULL,
    item_amount int  NOT NULL,
    CONSTRAINT supplier_item_pk PRIMARY KEY (supplier_sup_id,item_item_id)
);

CREATE TABLE transaction (
    tr_id char(6)  NOT NULL,
    tr_totalBill money  NOT NULL,
    tr_date date  NOT NULL,
    tr_paymentMethod varchar(50)  NOT NULL,
    customer_cst_id char(6)  NOT NULL,
    employee_emp_id char(6)  NOT NULL,
    CONSTRAINT transaction_pk PRIMARY KEY (tr_id)
);

CREATE TABLE transaction_item (
    transaction_tr_id char(6)  NOT NULL,
    item_item_id char(6)  NOT NULL,
    item_amount int  NOT NULL,
    CONSTRAINT transaction_item_pk PRIMARY KEY (transaction_tr_id,item_item_id)
);

ALTER TABLE supplier_item ADD CONSTRAINT supplier_item_item
    FOREIGN KEY (item_item_id)
    REFERENCES item (item_id)  
    NOT DEFERRABLE 
    INITIALLY IMMEDIATE
;

ALTER TABLE supplier_item ADD CONSTRAINT supplier_item_supplier
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


