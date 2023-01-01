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

--
