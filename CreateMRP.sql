
-- Creates a new database: MRP
-- Roy Adams
USE master
GO

IF EXISTS(select * from sys.databases where name='MRP')
DROP DATABASE MRP

CREATE DATABASE MRP;
GO

USE MRP
GO

CREATE TABLE Resources (
	ResourceID int IDENTITY(1,1) not null PRIMARY KEY,
	ResourceName varchar(50) not null,
	ResourceStatus varchar(50) not null,
	MaintainanceDescription varchar(200) null,
	ReplacementDate date null
)
GO

CREATE TABLE Address (
	AddressID int IDENTITY(1,1) not null PRIMARY KEY,
	StreetAddress varchar(50) not null,
	City varchar(50) not null,
	State varchar(50) not null,
	Country varchar(50) not null,
	PostalCode varchar(10) not null
)
GO

CREATE TABLE Vendors (
	VendorID int IDENTITY(1,1) not null PRIMARY KEY,
	VendorName varchar(50) not null,
	ContactPerson varchar(50) null,
	PhoneNumber varchar(50) null,
	VendorAddressID int not null FOREIGN KEY REFERENCES Address(AddressID),
	VendorRating varchar(5) not null --DEFAULT 'A' 
)
GO

CREATE TABLE Parts (
	PartID int IDENTITY(1,1) not null PRIMARY KEY,
	PartName varchar(50) not null,
	PartDescription varchar(200) null,
	PartType varchar(50) not null,
	PartCost money not null,
	VendorID int null FOREIGN KEY REFERENCES Vendors(VendorID),
	EconomicOrderQty int null,
	SafetyStock int null,
	OnHandMax int null,
	OrderLeadTime int null,
)
GO

CREATE TABLE BillOfMaterials (
	BillOfMaterialsID int IDENTITY(1,1) not null PRIMARY KEY,
	ProductAssemblyID int null FOREIGN KEY REFERENCES Parts(PartID),
	ComponentID int not null FOREIGN KEY REFERENCES Parts(PartID)
)
GO

CREATE TABLE Credit (
	CreditID int IDENTITY(1,1) not null PRIMARY KEY,
	AccountNumber varchar(50) not null,
	CurrentBalance money not null
)
GO

CREATE TABLE Customer (
	CustomerID int IDENTITY(1,1) not null PRIMARY KEY,
	CustomerName varchar(50) not null,
	BillingAddressID int not null FOREIGN KEY REFERENCES Address(AddressID),
	ShippingAddressID int not null FOREIGN KEY REFERENCES Address(AddressID),
	CreditID int not null FOREIGN KEY REFERENCES Credit(CreditID)
)
GO

CREATE TABLE CustomerOrders (
	OrderID int IDENTITY(1,1) not null PRIMARY KEY,
	CustomerID int not null FOREIGN KEY REFERENCES Customer(CustomerID),
	ProductID int not null FOREIGN KEY REFERENCES Parts(PartID),
	Quantity int not null,
	DateAvailable date not null,
	OrderDate date not null,
	SplitShipments bit not null,
	Shipped bit not null
)
GO

CREATE TABLE VendorOrders (
	OrderID int IDENTITY(1,1) not null PRIMARY KEY,
	VendorID int not null FOREIGN KEY REFERENCES Vendors(VendorID),
	ProductID int not null FOREIGN KEY REFERENCES Parts(PartID),
	QuantityOrdered int not null,
	QuantityReceived int not null,
	OrderDate date not null,
	OrderStatus varchar(50) not null
)
GO

CREATE TABLE JobOrders (
	OrderID int IDENTITY(1,1) not null PRIMARY KEY,
	ProductID int not null FOREIGN KEY REFERENCES Parts(PartID),
	SerialNumber varchar(50) not null,
	OrderDate date not null,
	Completed bit not null,
	Quantity int not null
)
GO

CREATE TABLE Inventory (
	InventoryID int IDENTITY(1,1) not null PRIMARY KEY,
	ProductID int not null FOREIGN KEY REFERENCES Parts(PartID),
	InventoryLane int not null,
	InventoryRow char not null,
	InventoryBin int not null,
	Quantity int not null
)
GO

-- Inserts Test Data
-- Aaron Santucci

--Resources
INSERT INTO Resources(ResourceName,ResourceStatus,MaintainanceDescription,ReplacementDate) VALUES ('Ball Bearing Maker','In-Use','Passed monthly inspection','2018-12-12');
INSERT INTO Resources(ResourceName,ResourceStatus,MaintainanceDescription,ReplacementDate) VALUES ('Ball Bearing Maker 2.0','Broken','Daily tune ups','2018-09-11');
INSERT INTO Resources(ResourceName,ResourceStatus,MaintainanceDescription,ReplacementDate) VALUES ('Dave','On Break','3 meals/day','2050-11-11');
GO

--Address
INSERT INTO Address(StreetAddress,City,State,Country,Postalcode) VALUES ('6789 Road St SE','New New York City','NNY','USA',12345);
INSERT INTO Address(StreetAddress,City,State,Country,Postalcode) VALUES ('3201 Burton St SE','Grand Rapids','MI','USA',49546);
INSERT INTO Address(StreetAddress,City,State,Country,Postalcode) VALUES ('2468 Business St NW','Las Vegas','CA','USA',78945);
INSERT INTO Address(StreetAddress,City,State,Country,Postalcode) VALUES ('4568 Another St SW','Grand Rapids','MI','USA',89765);
INSERT INTO Address(StreetAddress,City,State,Country,Postalcode) VALUES ('1987 Testing St NS','New Chicago','MI','USA',79879);
GO

--Vendors
INSERT INTO Vendors(VendorName,ContactPerson,PhoneNumber,VendorAddressID,VendorRating) VALUES ('Planet Express','The Professor','616-111-1112',1,'C');
INSERT INTO Vendors(VendorName,ContactPerson,PhoneNumber,VendorAddressID,VendorRating) VALUES ('Calvin College','Patrick Bailey','616-222-1112',2,'AA');
INSERT INTO Vendors(VendorName,ContactPerson,PhoneNumber,VendorAddressID,VendorRating) VALUES ('Business Factory','Vincent Adultman','616-867-5309',3,'B');
GO

--Parts
INSERT INTO Parts(PartName,PartDescription ,PartType,PartCost ,VendorID,EconomicOrderQty,SafetyStock,OnHandMax,OrderLeadTime) VALUES ('BB Ball Bearing','Chromoly steel.',3,5,1,50,5,55,44);
INSERT INTO Parts(PartName,PartDescription ,PartType,PartCost ,VendorID,EconomicOrderQty,SafetyStock,OnHandMax,OrderLeadTime) VALUES ('BB Ball Bearing','Chromoly steel.',3,5,2,1,5,51,12);
INSERT INTO Parts(PartName,PartDescription ,PartType,PartCost ,VendorID,EconomicOrderQty,SafetyStock,OnHandMax,OrderLeadTime) VALUES ('BB Ball Bearing','Chromoly steel.',3,5,2,5,6,12,69);
INSERT INTO Parts(PartName,PartDescription ,PartType,PartCost ,VendorID,EconomicOrderQty,SafetyStock,OnHandMax,OrderLeadTime) VALUES ('BB Ball Bearing','Chromoly steel.',3,5,1,25,7,32,65);
GO

--BillOfMaterials
INSERT INTO BillOfMaterials(ProductAssemblyID,ComponentID) VALUES (3,1);
INSERT INTO BillOfMaterials(ProductAssemblyID,ComponentID) VALUES (3,2);
INSERT INTO BillOfMaterials(ProductAssemblyID,ComponentID) VALUES (4,2);
INSERT INTO BillOfMaterials(ProductAssemblyID,ComponentID) VALUES (4,1);
GO

--Credit
INSERT INTO Credit(AccountNumber,CurrentBalance) VALUES ('1000 1000 1000 1001',0);
INSERT INTO Credit(AccountNumber,CurrentBalance) VALUES ('1234 5678 9011 1213',10000000);
INSERT INTO Credit(AccountNumber,CurrentBalance) VALUES ('1111 2222 3333 4444',5);
GO

--Customer
INSERT INTO Customer(CustomerName,BillingAddressID,ShippingAddressID,CreditID) VALUES ('Aaron Santucci',2,2,1);
INSERT INTO Customer(CustomerName,BillingAddressID,ShippingAddressID,CreditID) VALUES ('Roy Adams',2,2,2);
INSERT INTO Customer(CustomerName,BillingAddressID,ShippingAddressID,CreditID) VALUES ('Someone Else',4,5,3);
GO

--CustomerOrders
INSERT INTO CustomerOrders(CustomerID,ProductID,Quantity,DateAvailable,OrderDate,SplitShipments,Shipped) VALUES (1,3,1,'2018-12-13','2018-12-13',0,1);
INSERT INTO CustomerOrders(CustomerID,ProductID,Quantity,DateAvailable,OrderDate,SplitShipments,Shipped) VALUES (2,3,3,'2018-12-14','2018-12-13',0,0);
INSERT INTO CustomerOrders(CustomerID,ProductID,Quantity,DateAvailable,OrderDate,SplitShipments,Shipped) VALUES (3,4,2,'2018-12-16','2018-12-13',1,0);
GO

--VendorOrders
INSERT INTO VendorOrders(VendorID,ProductID,QuantityOrdered,QuantityReceived,OrderDate,OrderStatus) VALUES (1,3,2,1,'2018-12-13','Shipped');
INSERT INTO VendorOrders(VendorID,ProductID,QuantityOrdered,QuantityReceived,OrderDate,OrderStatus) VALUES (2,3,2,2,'2018-12-14','Not Shipped');
INSERT INTO VendorOrders(VendorID,ProductID,QuantityOrdered,QuantityReceived,OrderDate,OrderStatus) VALUES (3,4,3,0,'2018-12-16','In Warehouse');
GO

--JobOrders
INSERT INTO JobOrders(ProductID,SerialNumber,OrderDate,Completed,Quantity) VALUES (3,111,'2018-12-13',0,5);
INSERT INTO JobOrders(ProductID,SerialNumber,OrderDate,Completed,Quantity) VALUES (4,222,'2018-12-14',0,6);
INSERT INTO JobOrders(ProductID,SerialNumber,OrderDate,Completed,Quantity) VALUES (4,444,'2018-12-13',1,7);
GO

--Inventory
INSERT INTO Inventory(ProductID,InventoryLane,InventoryRow,InventoryBin,Quantity) VALUES (3,18,2,1,5);
INSERT INTO Inventory(ProductID,InventoryLane,InventoryRow,InventoryBin,Quantity) VALUES (3,18,2,1,5);
INSERT INTO Inventory(ProductID,InventoryLane,InventoryRow,InventoryBin,Quantity) VALUES (4,10,3,6,1);
GO

CREATE OR ALTER PROCEDURE spInsertVendor
	@vendorName varchar(50),
	@vendorContact varchar(50),
	@vendorPhoneNumber varchar(50),
	@vendorAddressID int,
	@vendorRating varchar(5)
AS
BEGIN
	INSERT INTO Vendors (VendorName, ContactPerson, PhoneNumber, VendorAddressID, VendorRating)
	VALUES (@vendorName, @vendorContact, @vendorPhoneNumber, @vendorAddressID, @vendorRating)
END
GO

CREATE OR ALTER PROCEDURE spInsertAddress
	@streetAddress varchar(50),
	@city varchar(50),
	@state varchar(50),
	@country varchar(50),
	@postalCode varchar(10)
AS
BEGIN
	INSERT INTO Address (StreetAddress, City, State, Country, PostalCode)
	VALUES (@streetAddress, @city, @state, @country, @postalCode)
END
GO

CREATE OR ALTER PROCEDURE spChangePartVendor
	@partID int,
	@vendorID int
AS
BEGIN
	UPDATE Parts
	SET VendorID = @vendorID
	WHERE PartID = @partID
END
GO

/*
-- Stored Procedure tests
SELECT * FROM Address
SELECT * FROM Vendors
SELECT * FROM Parts

EXEC spInsertAddress '23 Burton Street', 'Denver', 'Colorado', 'USA', '12345'
EXEC spInsertVendor 'Vendor1', 'Joe Bob', '343-343-3434', 1, 'AA'
EXEC spChangePartVendor 1, 2

SELECT * FROM Address
SELECT * FROM Vendors
SELECT * FROM Parts
*/

/*
SELECT * FROM Parts
SELECT * FROM BillOfMaterials
SELECT * FROM Resources

SELECT * FROM Vendors
SELECT * FROM Address
SELECT * FROM Credit
SELECT * FROM Customer

SELECT * FROM CustomerOrders
SELECT * FROM VendorOrders
SELECT * FROM JobOrders
SELECT * FROM Inventory
*/

-- use master
DROP DATABASE MRP

