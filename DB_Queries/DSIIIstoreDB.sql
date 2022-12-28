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
	deleted_state bit not null default 0,
	constraint FK_productCategory foreign key (category_id)
	references dbo.Product_Category(category_id)
)
go

create table dbo.Product_Inventory(
	inventory_id int Primary key identity(1,1),
	product_id int not null, --foreign key
	quantity int not null default 0,
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	deleted_state bit not null default 0,
	constraint FK_inventoryProduct foreign key (product_id)
	references dbo.Product(product_id)
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

create table dbo.Department(
	department_id	INT Primary key identity(1,1),
	department_name	VARCHAR(150) not null,
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
	department_id	INt not null, --foreign key
	salary	DECIMAL(10,2) not null,
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	deleted_state bit not null default 0,
	constraint FK_employeePerson foreign key (person_id)
	references dbo.Person(person_id),
	constraint FK_employeeDepartment foreign key (department_id)
	references dbo.Department(department_id)
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

create table dbo.Payment_Details(
	payment_id	INT Primary key identity(1,1),
	order_id	INT not null, --foreign key --arreglar order_id
	amount	DECIMAL(10,2)not null,
	status	BIT not null,
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate()
)
go

create table dbo.Order_Details(
	details_id	INT Primary key identity(1,1), 
	client_id	INT not null, --foreign key
	total	DECIMAL(10,2)not null,
	payment_id	INT not null, --foreign key
	employee_id	INT,--foreign key
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	deleted_state bit not null default 0,
	constraint FK_orderClient foreign key (client_id)
	references dbo.Client(client_id),
	constraint FK_orderPayment foreign key (payment_id)
	references dbo.Payment_Details(payment_id),
	constraint FK_orderEmployee foreign key (employee_id)
	references dbo.Employee(employee_id)
)
go

create table dbo.Order_Items(
	items_id	INT Primary key identity(1,1), 
	product_id	INT not null, --foreign key
	quantity	INT not null,
	unit_price	DECIMAL(10,2) not null,
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	--deleted_state bit not null default 0 --Debería de poder eliminarse los items de una orden
	constraint FK_orderProducts foreign key (product_id)
	references dbo.Product(product_id)
)
go


create table dbo.Shopping_Cart(
	cart_id	INT Primary key identity(1,1),
	product_id	INT not null, --foreign key
	client_id	int not null, --foreign key
	quantity	INT not null,
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	deleted_state bit not null default 0,
	constraint FK_cartProducts foreign key (product_id)
	references dbo.Product(product_id),
	constraint FK_cartClient foreign key (client_id)
	references dbo.Client(client_id)
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
	deleted_state bit not null default 0,
	constraint FK_adressPerson foreign key (person_id)
	references dbo.Person(person_id)
)
go