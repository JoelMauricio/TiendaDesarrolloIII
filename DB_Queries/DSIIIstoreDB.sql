Create database storeDB
go

use storeDB
go

--drop database storeDB

create table dbo.Product_Category(
	category_id int Primary key identity(1,1),
	caegory_name varchar(150) not null,
	descripción text not null,
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	deleted_state bit not null default 0
)
go

create table dbo.Vendor(
	vendor_id int primary key identity(1,1),
	vendor_name varchar(120) not null,
	tel varchar(10) not null default '8099999999',
	correo varchar(150) not null,
	dirección varchar(250) not null default 'n/a',
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	deleted_state bit not null default 0,
)
go
--modificacion para actualizar la tabla
--alter table Vendor add 	
--created_at datetime not null default getdate(),
--last_modification datetime not null default getdate(),
--deleted_state bit not null default 0
--go


create table dbo.Product(
	product_id int Primary key identity(1,1),
	name VARCHAR(100) not null, 
	descripción text not null,
	category_id int not null, --foreign key
	vendor_id int not null, --foreign key
	price DECIMAL(19,4) not null,
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	deleted_state bit not null default 0,
	constraint FK_productCategory foreign key (category_id)
	references dbo.Product_Category(category_id),
	constraint FK_productVendor foreign key (vendor_id)
	references dbo.Vendor(vendor_id)
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

--no es realmente necesario

--create table dbo.Department(
--	department_id	INT Primary key identity(1,1),
--	department_name	VARCHAR(150) not null,
--	created_at datetime not null default getdate(),
--	last_modification datetime not null default getdate(),
--	deleted_state bit not null default 0
--)
--go

create table dbo.Cashier(
	cashier_id	INT Primary key identity(1,1),
	person_id	INT not null, --foreign key
	work_email	NVARCHAR(250) not null,
	hire_date	DATE not null,
	--department_id	INt not null, --foreign key
	salary	DECIMAL(10,2) not null,
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	deleted_state bit not null default 0,
	constraint FK_employeePerson foreign key (person_id)
	references dbo.Person(person_id)--,
	--constraint FK_employeeDepartment foreign key (department_id)
	--references dbo.Department(department_id)
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

create table dbo.Payment_Type(
	pType_id	INT Primary key identity(1,1),
	type_name varchar(150) not null,
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	deleted_state bit not null default 0
)
go

create table dbo.Payment_Details(
	payment_id	INT Primary key identity(1,1),
	order_id	INT not null, --foreign key --arreglar order_id
	amount	DECIMAL(10,2)not null,
	pType_id int not null,
	status	BIT not null,
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	constraint FK_paymentType foreign key (pType_id)
	references dbo.Payment_Type(pType_id)
)
go

create table dbo.OrderDetail(
	order_id	INT Primary key identity(1,1), 
	client_id	INT not null, --foreign key
	total	DECIMAL(10,2)not null default 0,
	--payment_id	INT not null, --foreign key -- no debe tener esto
	cashier_id	INT,--foreign key
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	deleted_state bit not null default 0,
	constraint FK_orderClient foreign key (client_id)
	references dbo.Client(client_id),
	--constraint FK_orderPayment foreign key (payment_id)
	--references dbo.Payment_Details(payment_id),
	constraint FK_orderCashier foreign key (cashier_id)
	references dbo.Cashier(cashier_id)
)
go

create table dbo.Order_Items(
	items_id	INT Primary key identity(1,1), 
	order_id	int not null, --foreign key
	product_id	INT not null, --foreign key
	quantity	INT not null,
	unit_price	DECIMAL(10,2) not null,
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	deleted_state bit not null default 0, --Debería de poder eliminarse los items de una orden
	constraint FK_orderProducts foreign key (product_id)
	references dbo.Product(product_id),
	constraint FK_orderOrders foreign key (order_id)
	references dbo.OrderDetail(order_id)
)
go

create table dbo.Shopping_Cart( -- revisar entidad
	cart_id	INT /*primary key identity(1,1)*/ not null, --no puede ser llave primaria sola
	client_id	int not null, --foreign key
	product_id	INT not null, --foreign key
	quantity	INT not null,
	created_at datetime not null default getdate(),
	last_modification datetime not null default getdate(),
	deleted_state bit not null default 0,
	constraint FK_cartProducts foreign key (product_id)
	references dbo.Product(product_id),
	constraint FK_cartClient foreign key (client_id)
	references dbo.Client(client_id),
	unique(cart_id,client_id,product_id)
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