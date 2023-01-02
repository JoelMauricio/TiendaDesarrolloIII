--Stored Procedures for TiendaDB

use storeDB
go


--procedimientos para categorias
create procedure ppInsertCategory
	@category_name varchar(150),
	@descripción text
as
insert into dbo.Product_Category(caegory_name,descripción) values
	(@category_name,@descripción)
go

create procedure ppReadCategories
as
select * from dbo.Product_Category where deleted_state = 0
go

create procedure ppUpdateCategory
	@target int,
	@newName varchar(150),
	@newDescripcion text
as
update dbo.Product_Category
set caegory_name = @newName, descripción = @newDescripcion, last_modification = GETDATE()
where category_id = @target
go

create procedure pDeleteCategory
	@target int
as
update dbo.Product_Category
set deleted_state = 1, last_modification = GETDATE()
where category_id = @target
go

--procedimientos de Vendedores
create procedure ppInsertVendor
	@vendor_name varchar(120),
	@tel varchar(10),
	@correo varchar(150),
	@dirección varchar(250)
as
insert into dbo.Vendor(vendor_name,tel,correo,dirección) values
	(@vendor_name,@tel,@correo,@dirección)
go

create procedure ppReadVendors
as
select * from dbo.Vendor where deleted_state = 0
go

create procedure ppUpdateVendor
	@target int,
	@newDireccion text
as
update dbo.Vendor
set dirección = @newDireccion, last_modification = GETDATE()
where vendor_id = @target
go

create procedure ppDeleteVendor
	@target int
as
update dbo.Vendor
set deleted_state = 1, last_modification = GETDATE()
where vendor_id = @target
go

--procedimientos de la tabla Product_Inventory
create procedure ppInsertInventory -- no creo que se deba usar este procedmiento
	@productId int,
	@quantity int
as
insert into dbo.Product_Inventory(product_id,quantity) values (@productId,@quantity)
go

create procedure ppReadInventory
as
select * from dbo.Product_Inventory where deleted_state = 0
go

create procedure ppUpdateInventory --pendiete por modificacion
	@productTarget int,
	@newQuantity int
as
	update dbo.Product_Inventory set quantity = @newQuantity, last_modification = GETDATE()
	where quantity = @newQuantity
go

create procedure ppDeleteInventory
	@productTarget int
as
	update dbo.Product_Inventory set deleted_state = 1, last_modification = GETDATE()
	where product_id = @productTarget
go

--procedimientos de Producto
create procedure ppInsertProduct
	@name VARCHAR(100), 
	@descripción text,
	@category_id int,
	@vendor_id int,
	@price DECIMAL(19,4)
as
	declare @insID int set @insID = (Select top 1 product_id from dbo.Product where name = @name and vendor_id = @vendor_id);
	
	if  not exists (Select 1 from dbo.Product where product_id = @insID) 
		begin
			insert into dbo.Product(name,descripción,category_id,vendor_id,price) values
			(@name,@descripción,@category_id,@vendor_id,@price) 

			declare @provId INT SET @provId = SCOPE_IDENTITY()

			--insert into dbo.Product_Inventory(product_id,quantity) values(@provId,1)
			exec ppInsertInventory @productId = @provID, @quantity = 1
		end
	else
		begin
			update dbo.Product_Inventory set quantity = quantity + 1, last_modification = GETDATE()
			where product_id = @insID
		end
go

create procedure ppReadProducts
as
select * from dbo.Product where deleted_state = 0
go

create procedure ppUpdateProduct
	@target int,
	@newPrice DECIMAL(19,4)
as
update dbo.Product set price = @newPrice, last_modification = GETDATE()
where product_id = @target
go

create procedure ppDeleteProduct
	@target int
as
	begin
		update dbo.Product set deleted_state = 1, last_modification = GETDATE()
		where product_id = @target

		exec ppDeleteInventory @productTarget = @target
	end
go

--procedimientos para Person
create procedure ppInsertPerson
	@first_name	VARCHAR(50),
	@last_name	VARCHAR(50),
	@phone	VARCHAR(15),
	@email	NVARCHAR(254),
	@citizen_id	VARCHAR(22)
as
	insert into dbo.Person(first_name,last_name,email,phone) values (@first_name,@last_name,@email,@phone)
go

create procedure ppReadPersons
as
	select * from dbo.Person where deleted_state = 0
go

create procedure ppUpdatePerson
	@target int,
	@newEmail nvarchar(254),
	@newPhone varchar(15)
as
	update dbo.Person set email = @newEmail, phone = @newPhone, last_modification = GETDATE()
	where person_id = @target
go

create procedure ppDeletePerson
	@target int
as
	update dbo.Person set deleted_state = 1, last_modification = GETDATE()
	where person_id = @target
go	

--creando procedimientos para Client
create procedure ppInsertClient
	@person_id	INT,
	@secondary_email	NVARCHAR(250),
	@username	NVARCHAR(60),
	@password	CHAR(64)
as
	if not exists (select 1 from dbo.Person where person_id = @person_id)
		begin
			exec ppInsertPerson @first_name = @username, @last_name = '', @phone = '8099999999', @email = @secondary_email, @citizen_id = ''

			declare @tempID int set @tempID = SCOPE_IDENTITY()

			insert into dbo.Client(person_id,username,secondary_email,password) 
			values(@tempID,@username,@secondary_email,@password)
		end
	else
		begin
			insert into dbo.Client(person_id,username,secondary_email,password) 
			values(@person_id,@username,@secondary_email,@password)
		end	
go

create procedure ppReadClients
as
	select * from dbo.Client where deleted_state = 0
go

create procedure ppUpdateClient
	@target int,
	@username nvarchar(60),
	@password char(64),
	@secondary_email nvarchar(250)
as
	update dbo.Client set username = @username,secondary_email = @secondary_email, password = @password, last_modification = GETDATE()
	where client_id = @target
go

create procedure ppDeleteClient
	@target int
as
	update dbo.Client set deleted_state = 1, last_modification = GETDATE()
	where client_id = @target
go

--creando los procedimientod de Cashier
create procedure ppInsertCashier
	@person_id	INT,
	@work_email	NVARCHAR(250),
	@hire_date	DATE,
	@salary	DECIMAL(10,2),
	@nombre varchar(100)
as
	if not exists (select 1 from dbo.Person where person_id = @person_id)
		begin
			exec ppInsertPerson @first_name = @nombre, @last_name = '', @phone = '8099999999', @email = @work_email, @citizen_id = ''

			declare @tempID int set @tempID = SCOPE_IDENTITY()

			insert into dbo.Cashier(person_id,work_email,hire_date,salary)
			values(@tempID,@work_email,iif(@hire_date is null, getdate(), @hiredate),@salary)
		end
	else
		begin
			insert into dbo.Cashier(person_id,work_email,hire_date,salary)
			values(@person_id,@work_email,iif(@hire_date is null, getdate(), @hiredate),@salary)
		end	
go

create procedure ppReadCashiers
as
	select * from dbo.Cashier where deleted_state = 0
go

create procedure ppUpdateCashier
	@target int,
	@newWork_email	NVARCHAR(250),
	@newSalary	DECIMAL(10,2)
as
	update dbo.Cashier set work_email = @newWork_email,salary = @newSalary,last_modification = GETDATE()
	where cashier_id = @target
go

create procedure ppDeleteCashier
	@target int
as
	update dbo.Cashier set deleted_state = 1, last_modification = GETDATE()
	where cashier_id = @target
go

