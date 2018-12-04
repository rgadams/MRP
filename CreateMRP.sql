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

CREATE TABLE Parts (
	PartID int IDENTITY(1,1) not null PRIMARY KEY,
	PartName varchar(50) not null,
	PartDescription varchar(200) null,
	PartType varchar(50) not null,
	PartCost money not null
)
GO

CREATE TABLE Resources (
	ResourceID int IDENTITY(1,1) not null PRIMARY KEY,
	ResourceName varchar(50) not null,
	ResourceStatus varchar(50) not null,
	MaintainanceDescription varchar(200) null,
	ReplacementDate date null
)
GO

CREATE TABLE BillOfMaterials (
	BillOfMaterialsID int IDENTITY(1,1) not null PRIMARY KEY,
	ProductAssemblyID int null FOREIGN KEY REFERENCES Parts(PartID),
	ComponentID int not null FOREIGN KEY REFERENCES Parts(PartID)
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
