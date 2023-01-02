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
where category_id = @target and deleted_state = 0
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
where vendor_id = @target and deleted_state = 0
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
	where product_id = @productTarget and deleted_state = 0
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
		where product_id = @target and deleted_state = 0

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
	where person_id = @target and deleted_state = 0
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
	where client_id = @target and deleted_state = 0
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
			values(@tempID,@work_email,iif(@hire_date is null, getdate(), @hire_date),@salary)
		end
	else
		begin
			insert into dbo.Cashier(person_id,work_email,hire_date,salary)
			values(@person_id,@work_email,iif(@hire_date is null, getdate(), @hire_date),@salary)
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
	where cashier_id = @target and deleted_state = 0
go

--creando los procedimientos de Person_Address
create procedure ppInsertAddress
	@person_id	INT,
	@address_line1	VARCHAR(150),
	@address_line2	VARCHAR(15),
	@city	VARCHAR(150),
	@postal_code	VARCHAR(10),
	@country	VARCHAR(150),
	@telephone	VARCHAR(15),
	@mobile	VARCHAR(15)
as
	Insert into dbo.Person_Address(person_id,address_line1,address_line2,city,postal_code,country,telephone,mobile)
	values(@person_id,@address_line1,@address_line2,@city,@postal_code,@country,@telephone,@mobile)
go

create procedure ppReadAddresses
as
	select * from dbo.Person_Address where deleted_state = 0
go

create procedure ppUpdateAddress
	@target int,
	@address_line1	VARCHAR(150),
	@address_line2	VARCHAR(15),
	@postal_code	VARCHAR(10)
as
	update dbo.Person_Address
	set address_line1 = @address_line1, address_line2 =@address_line2, postal_code = @postal_code, last_modification = GETDATE()
	where address_id = @target
go

create procedure ppDeleteAddress
	@target int
as
	update dbo.Person_Address
	set deleted_state = 1, last_modification = GETDATE()
	where address_id = @target and deleted_state = 0
go

--creando procedimientos de paymentType
create procedure ppInsertPayType
	@type_name varchar(150)
as
	insert into dbo.Payment_Type(type_name) values(@type_name)
go

create procedure ppReadPayTypes
as
	Select * from dbo.Payment_Type where deleted_state = 0
go

create procedure ppUpdatePayType
	@target int,
	@newType_name varchar(150)
as
	update dbo.Payment_Type
	set type_name = @newType_name, last_modification = GETDATE()
	where pType_id = @target
go

create procedure ppDeletePayType
	@target int
as
	update dbo.Payment_Type
	set deleted_state = 1, last_modification = getdate()
	where pType_id = @target and deleted_state = 0
go

--procedimientos para la tabla payment_details
create procedure ppInsertPayDetail
	@order_id	INT,
	@amount	DECIMAL(10,2),
	@pType_id int
as
	insert into dbo.Payment_Details(order_id,amount,pType_id,status)
	values (@order_id,@amount,@pType_id,0)
go

create procedure ppReadPayDetails
as
	select * from dbo.Payment_Details
go

create procedure ppUpdatePayDetail
	@target int,
	@newAmount decimal(10,2),
	@status bit
as
	update dbo.Payment_Details
	set amount = iif(@newAmount is null, amount, @newAmount), status = @status, last_modification = GETDATE()
	where payment_id = @target
go

--No tiene delete

--creando los procedimientos de shoppingCart
create procedure ppInsertCart
	@product_id	INT,
	@client_id	int,
	@quantity	INT
as
	insert into dbo.Shopping_Cart(product_id,client_id,quantity) values(@product_id,@client_id,@quantity)
go

create procedure ppReadCarts
as
	select * from dbo.Shopping_Cart where deleted_state = 0 --una vez se haya cerrado la compra estos son "borrados"
go

create procedure ppUpdateCart
	@targetProduct int,
	@targetClient int,
	@newQuantity int
as
begin
	declare @cartID int set @cartID = 
	(select top 1 cart_id from dbo.Shopping_Cart where product_id = @targetProduct and client_id = @targetClient and deleted_state = 0 order by cart_id desc)
	update dbo.Shopping_Cart
	set quantity = @newQuantity, last_modification = GETDATE()
	where cart_id = @cartId and product_id = @targetProduct and client_id = @targetClient
end
go

create procedure ppDeleteCart
	@targetClient int,
	@targetCart int
as
	update dbo.Shopping_Cart
	set deleted_state = 1, last_modification = GETDATE()
	where client_id = @targetClient and cart_id = @targetCart and deleted_state = 0
go

--create procedure for orderdetails
Create procedure ppInsertOrder
	@client_id	INT,
	--@payment_id	INT, --no debe tener esto
	@cashier_id	INT
as
	insert into dbo.OrderDetail(client_id/*,payment_id*/,cashier_id)
	values (@client_id/*,@payment_id*/,@cashier_id)
go

create procedure ppReadOrders
as
	select * from dbo.OrderDetail where deleted_state = 0
go

create procedure ppUpdateOrder
	@targetOrder int,
	@total int
as
	update dbo.OrderDetail
	set total = total + @total, last_modification = getdate()
	where order_id = @targetOrder and deleted_state <> 1
go

create procedure ppDeleteOrder
	@targetOrder int
as 
	update dbo.OrderDetail
	set deleted_state = 1, last_modification = GETDATE()
	where order_id = @targetOrder and deleted_state <> 1
go

--creando procedimientos para Order_items
create procedure ppInsertOrderItem
	@order_id	int,
	@product_id	INT,
	@quantity	INT,
	@unit_price DECIMAL(10,2),
	@clientId int
as
	declare @currentTotal DECIMAL(10,2) set @currentTotal = @unit_price * @quantity

	if not exists (select 1 from dbo.OrderDetail where order_id = @order_id)
		begin
			exec ppInsertOrder @client_id = @clientId, @cashier_id = null

			declare @tempOrderId int set @tempOrderId = SCOPE_IDENTITY()

			insert into dbo.Order_Items(order_id,product_id,quantity,unit_price)
			values (@tempOrderId,@product_id,@quantity,@unit_price)

			exec ppUpdateOrder @TargetOrder = @tempOrderId, @total = @currentTotal
		end
	else
		begin
			insert into dbo.Order_Items(order_id,product_id,quantity,unit_price)
			values (@order_id,@product_id,@quantity,@unit_price)

			exec ppUpdateOrder @TargetOrder = @tempOrderId, @total = @currentTotal
		end
go

create procedure ppReadOrderItems
	@order_Id int
as
	select * from dbo.Order_Items where order_id = @order_Id and deleted_state = 0
go

create procedure ppUpdateOrderItem
	@targetItem int,
	@targetOrderId INT,
	@quantity int
as
	begin
		--agregar update de la entidad orderDetail para restar le viejo curretTotal del item en cuestion y luego sumar el nuevo currentTotal 
		declare @oldTotal DECIMAL(10,2) set @oldTotal = -(select top 1 quantity*unit_price from dbo.Order_Items where items_id = @targetItem)
		exec ppUpdateOrder @targetOrder = @targetOrderId, @total = @oldTotal

		update dbo.Order_Items
		set quantity = @quantity, last_modification = GETDATE()
		where items_id = @targetItem and deleted_state <> 1

		declare @newTotal Decimal(10,2) set @newTotal = (select top 1 quantity*unit_price from dbo.Order_Items where items_id = @targetItem)
		exec ppUpdateOrder @targetOrder = @targetOrderId, @total = @newTotal
	end
go

create procedure ppDeleteOrderItem
	@item_Id int
as
	update dbo.Order_Items
	set deleted_state = 1, last_modification = GETDATE()
	where items_id = @item_Id and deleted_state = 0
go
