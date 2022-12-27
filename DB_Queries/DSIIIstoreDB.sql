Create database storeDB
go

use storeDB
go

create table dbo.Product_Category(
	category_id int Primary key identity(1,1),
	name varchar(150) not null,
	descripción text not null,
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	deleted_state bit not null default 0
)
go

create table dbo.Product(
	product_id int Primary key identity(1,1),
	name VARCHAR(100) not null, 
	descripción text not null,
	category_id int not null, --foreign key
	price DECIMAL(19,4) not null,
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	deleted_state bit not null default 0
)
go

create table dbo.Product_Inventory(
	inventory_id int Primary key identity(1,1),
	product_id int not null, --foreign key
	quantity int not null default 0,
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	deleted_state bit not null default 0
)
go

create table dbo.Person(
	person_id	INT Primary key identity(1,1),
	first_name	VARCHAR(50) not null,
	last_name	VARCHAR(50) not null,
	phone	VARCHAR(15) not null,
	email	NVARCHAR(254) not null,
	citizen_id	VARCHAR(22) not null,
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	deleted_state bit not null default 0
)
go

create table dbo.Employee(
	employee_id	INT Primary key identity(1,1),
	person_id	INT not null, --foreign key
	work_email	NVARCHAR(250) not null,
	employee_number	INT not null, 
	hire_date	DATE not null,
	department_id	INt not null, --foreign key --se debe crear la tabla de 
	salary	DECIMAL(10,2) not null,
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	deleted_state bit not null default 0
)
go

create table dbo.Client(
	client_id	INT Primary key identity(1,1),
	person_id	INT not null,
	secondary_email	NVARCHAR(250),
	username	NVARCHAR(60) not null,
	password	CHAR(64) not null,
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	deleted_state bit not null default 0
)
go

create table dbo.Order_Details(
	details_id	INT Primary key identity(1,1), 
	user_id	INT not null, --foreign key
	total	DECIMAL(10,2)not null,
	payment_id	INT not null, --foreign key
	employee_id	INT,--foreign key
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	deleted_state bit not null default 0
)
go

create table dbo.Order_Items(
	items_id	INT Primary key identity(1,1), 
	product_id	INT not null, --foreign key
	quantity	INT not null,
	unit_price	DECIMAL(10,2) not null,
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate()
	--deleted_state bit not null default 0 --Debería de poder eliminarse los items de una orden
)
go

create table dbo.Payment_Details(
	payment_id	INT Primary key identity(1,1),
	order_id	INT not null, --foreign key
	amount	DECIMAL(10,2)not null,
	status	BIT not null,
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate()
)
go

create table dbo.Shopping_Cart(
	cart_id	INT Primary key identity(1,1),
	product_id	INT not null, --foreign key
	user_id	DECIMAL(10,2)not null, --foreign key
	quantity	INT not null,
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	deleted_state bit not null default 0
)
go

create table dbo.Person_Address(
	address_id	INT Primary key identity(1,1),
	person_id	INT not null, --foreign key
	address_line1	VARCHAR(150) not null,
	address_line2	VARCHAR(15),
	city	VARCHAR(150) not null,
	postal_code	VARCHAR(10) not null,
	country	VARCHAR(150) not null,
	telephone	VARCHAR(15),
	mobile	VARCHAR(15),
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	deleted_state bit not null default 0
)
go