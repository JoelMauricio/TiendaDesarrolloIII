use storeDB
go

--probando los procedimientos
/*=======================================================================     VENDOR(3/4)    ======================================================================================*/

--exec ppInsertVendor @vendor_name = 'Joel2', @tel = '8099999999', @correo = 'joel2@gmail.com', @dirección = 'n/a' --funciona perfectamente, pero no sé porque empezó con Id 2
--exec ppReadVendors --funciona perfectamente
--exec ppUpdateVendor @target = 2, @newDireccion = 'n/a 1' --funciona perfectamente
--exec ppDeleteVendor @target = 2 --funciona perfectamente

/*=======================================================================    CATEGORY(4/4)    =====================================================================================*/

--exec ppInsertCategory @category_name = 'Pruebas2', @descripción = 'Producto de pruebas' --funciona perfectamente
--exec ppReadCategories --funciona perfectamente
--exec ppUpdateCategory @target = 1, @newName = 'Producto de Prueba', @newDescripcion = 'Descripción' --funciona perfectamente
--exec pDeleteCategory @target = 2 --funciona perfectamente

/*=======================================================================    PRODUCT(3/4)   =======================================================================================*/

--exec ppInsertProduct @name = 'Libro2', @descripción = 'n/a', @category_id = 1, @vendor_id = 3, @price = 10 --funciona pero no genera bien los ID de los productos
--exec ppReadProducts --funciona perfectamente
--exec ppUpdateProduct @target = 3, @newPrice = 15 --funciona perfectamente
--exec ppDeleteProduct @target = 4

/*=======================================================================   INVENTORY(4/4)   ======================================================================================*/

--exec ppInsertInventory @productId = 3, @quantity = 10 --funciona perfectamente
--exec ppReadInventory --funciona perfectamente
--exec ppUpdateInventory @productTarget = 3, @newQuantity = 25 --funciona perfectamente
--exec ppDeleteInventory @productTarget =  3 --funciona perfectamente

/*===================================================================     CLIENT(3/4)       =======================================================================================*/

--exec ppInsertClient @person_id = 6, @secondary_email = 'try@email.com', @username = 'pruebaNombre', @password = 123456 --no inserta correctamente cuando el id no existe
--exec ppReadClients --funciona perfectamente
--exec ppUpdateClient @target = 4, @username = 'usuarioNombre', @password = 123455, @secondary_email = 'usuario@email.com' --funciona correctamente
--exec ppDeleteClient @target = 6 --funciona perfectamente

/*=====================================================================     CASHIER(3/4)   ========================================================================================*/

--exec ppInsertCashier @person_id = 7, @work_email ='try@email.com', @hire_date = null, @salary = 100, @nombre = 'Usuario1' --no inserta correctamente cuando el id no existe
--exec ppReadCashiers --funciona perfectamente
--exec ppUpdateCashier @target = 3, @newWork_email = 'try2@email.com', @newSalary = 110 --funciona correctamente
--exec ppDeleteCashier @target = 3 --funciona correctamente

/*=====================================================================     PERSON(3/4)    ========================================================================================*/

--exec ppInsertPerson @first_name = 'prueba', @last_name = '', @phone = '8099999999', @email = 'prueba@email.com', @citizen_id = 'pending' --funciona perfectamente
--exec ppReadPersons --funciona perfectamente
--exec ppUpdatePerson @target = 4, @newEmail = 'try@email.com',@newPhone = '8090000000' --funciona perfectamente
--exec ppDeletePerson @target = 5 --funciona perfectamente

/*================================================================      PERSONADDRESS(4/4)  =======================================================================================*/

--exec ppInsertAddress @person_id = 6, @address_line1 = '', @address_line2 = '', @city = 'Santo Domingo', @postal_code = 110203, @country = 'Dominican Republic', @telephone = '8099999999', @mobile = '' --funciona perfectamente
--exec ppReadAddresses --funciona perfectamente
--exec ppUpdateAddress @target= 2, @address_line1 = 'Ola', @address_line2 = 'bye', @postal_code = 110203 --funciona perfectamente
--exec ppDeleteAddress @target = 2 --funciona correctamente

/*================================================================      PAYMENTTYPE(4/4)     ======================================================================================*/

--exec ppInsertPayType @type_name = 'tarjeta' --funciona perfectamente
--exec ppReadPayTypes --funciona perfectamente
--exec ppUpdatePayType @target = 1, @newType_name = 'Tarjeta' --funciona perfectamente
--exec ppDeletePayType @target = 2 --funciona perfectamente

/*==================================================================     ORDERDETAIL(4/4)     =====================================================================================*/

--exec ppInsertOrder @client_id = 4, @cashier_id = null --funciona perfectamente
--exec ppReadOrders --funciona perfectamente
--exec ppUpdateOrder @targetOrder = 2, @total = 5 --funciona perfectamente
--exec ppDeleteOrder @targetOrder = 3 --funciona perfectamente

/*===================================================================     ORDERITEMS(2/4)     =====================================================================================*/

--exec ppInsertOrderItem @order_id = 4, @product_id = 3, @quantity = 5, @unit_price = 10, @clientId = 4 --revisar @tempOrderId
--exec ppReadOrderItems @order_id = 4 --funciona perfectamente
--exec ppUpdateOrderItem @targetItem = 2, @targetOrderId = 4, @quantity = 16 --funciona pero hay que arreglar el total y el cuantity
--exec ppDeleteOrderItem @item_Id = 2 --funciona perfectamente

/*================================================================      PAYMENTDETAILS(3/3)   =====================================================================================*/

--exec ppInsertPayDetail @order_id = 1, @amount = 0, @pType_id = 1--funciona perfectamente
--exec ppReadPayDetails--funciona perfectamente
--exec ppUpdatePayDetail @target = 1, @newAmount = 100, @status = 0 --funciona perfectamente

/*===============================================================     SHOPPINGCART(4/4)    ========================================================================================*/

--exec ppInsertCart @cart_id = 1, @product_id = 3, @client_id = 4, @quantity = 5 --funciona perfectamente
--exec ppReadCarts --funciona perfectamente
--exec ppUpdateCart @targetProduct = 3, @targetClient = 4, @newQuantity = 6 --funciona perfectamente
--exec ppDeleteCart @targetClient = 4, @targetCart = 1 --funciona perfectamente