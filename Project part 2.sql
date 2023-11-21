CREATE TABLE invoice(
	invoice_id int identity,
	invoice_number int not null,
	CONSTRAINT PK_invoice_id PRIMARY KEY(invoice_id)
)
CREATE TABLE payment(
	payment_id int identity,
	credit_card_number int,
	expiration_date datetime,
	CCV int,
	invoice_id int,
	CONSTRAINT PK_payment PRIMARY KEY(payment_id),
	CONSTRAINT FK1_payment FOREIGN KEY(invoice_id) REFERENCES invoice(invoice_id)
)

CREATE TABLE shopping_cart(
	shopping_cart_id int identity,
	amount_of_item int,
	sub_total int,
	payment_id int,
	CONSTRAINT PK_shopping_cart PRIMARY KEY(shopping_cart_id),
	CONSTRAINT FK1_shopping_cart FOREIGN KEY(payment_id) REFERENCES payment(payment_id)
)

CREATE TABLE order_item_detail(
	order_item_detail_id int identity,
	order_item_detail varchar(100),
	order_date datetime not null default GetDate(),
	shipping_date datetime,
	order_status varchar(20),
	shopping_cart_id int,
	CONSTRAINT PK_order_item_detail PRIMARY KEY(order_item_detail_id),
	CONSTRAINT FK1_order_item_detail FOREIGN KEY(shopping_cart_id) REFERENCES shopping_cart(shopping_cart_id) 
)

CREATE TABLE order_item(
	order_item_id int identity,
	order_item_detail_id int,
	comment varchar(50),
	CONSTRAINT PK_order_item PRIMARY KEY(order_item_id),
	CONSTRAINT FK1_order_item FOREIGN KEY(order_item_detail_id) REFERENCES order_item_detail(order_item_detail_id)
)

CREATE TABLE customer (
	customer_id int identity,
	first_name varchar(30) not null,
	middle_name varchar(10),
	last_name varchar(30),
	address_1 varchar(30),
	address_2 varchar(30),
	phone_number int,
	order_item_id int,
	CONSTRAINT PK_customer PRIMARY KEY(customer_id),
	CONSTRAINT FK1_customer FOREIGN KEY(order_item_id) REFERENCES order_item(order_item_id)
)

CREATE OR ALTER VIEW invoiceCount AS
SELECT COUNT(invoice_id) as invoice_number FROM invoice

SELECT * FROM invoiceCount

CREATE PROCEDURE PhoneNumberChange (@firstname varchar(30), @phonenum int)
AS
BEGIN 
	UPDATE customer SET phone_number = @phonenum
	WHERE first_name = @firstname
END
GO

EXEC PhoneNumberChange 'Russell', '9238472'

SELECT * FROM customer WHERE first_name = 'Russell' 

CREATE OR ALTER VIEW customerOrder AS
	SELECT 
	shipping_date
	,order_status
	FROM order_item_detail

SELECT * FROM customerOrder 

CREATE FUNCTION dbo.commentlookup(@itemid int)
RETURNS int AS 
BEGIN 
	DECLARE @returnValue int
	SELECT @returnValue = customer_id from customer
	WHERE order_item_id  = @itemid
	RETURN @returnValue
END
GO
drop function dbo.commentlookup;

SELECT
dbo.commentlookup(order_item_id) as customerID
,order_item.comment as customercomment
FROM order_item


