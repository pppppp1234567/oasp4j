-- This is the SQL script for setting up the DDL for the h2 database
-- In a typical project you would only distinguish between main and test for flyway SQLs
-- However, in this sample application we provde support for multiple databases in parallel
-- You can simply choose the DB of your choice by setting spring.profiles.active=XXX in config/application.properties
-- Assuming that the preconfigured user exists with according credentials using the included SQLs

CREATE SEQUENCE HIBERNATE_SEQUENCE START WITH 1000000;

-- *** Staffmemeber ***
CREATE TABLE StaffMember(
  id BIGINT NOT NULL AUTO_INCREMENT,
  modificationCounter INTEGER NOT NULL,
  firstname VARCHAR(255),
  lastname VARCHAR(255),
  login VARCHAR(255),
  role INTEGER,
  CONSTRAINT PK_StaffMember PRIMARY KEY(id),
  CONSTRAINT UC_StaffMember_login UNIQUE(login)
);

-- *** Product ***
CREATE TABLE Product(
  dType VARCHAR(31) NOT NULL,
  id BIGINT NOT NULL AUTO_INCREMENT,
  modificationCounter INTEGER NOT NULL,
  description VARCHAR(255),
  name VARCHAR(255),
  alcoholic BOOLEAN,
  pictureId BIGINT,
  CONSTRAINT PK_Product PRIMARY KEY(id)
);

CREATE TABLE Product_AUD(
  revType TINYINT,
  description VARCHAR(255),
  name VARCHAR(255),
  pictureId BIGINT,
  alcoholic BOOLEAN,
  dType VARCHAR(31) NOT NULL,
  id BIGINT NOT NULL,
  rev BIGINT NOT NULL
);

-- *** Offer ***
CREATE TABLE Offer(
  id BIGINT NOT NULL AUTO_INCREMENT,
  modificationCounter INTEGER NOT NULL,
  description VARCHAR(255),
  name VARCHAR(255),
  price DECIMAL(19, 2),
  number BIGINT,
  state INTEGER,
  drinkId BIGINT,
  mealId BIGINT,
  sideDishId BIGINT,
  CONSTRAINT PK_Offer PRIMARY KEY(id),
  CONSTRAINT UC_Offer_name UNIQUE(name),
  CONSTRAINT UC_Offer_number UNIQUE(number),
  CONSTRAINT FK_Offer_sideDishId FOREIGN KEY(sideDishId) REFERENCES Product(id) NOCHECK,
  CONSTRAINT FK_Offer_mealId FOREIGN KEY(mealId) REFERENCES Product(id) NOCHECK,
  CONSTRAINT FK_Offer_drinkId FOREIGN KEY(drinkId) REFERENCES Product(id) NOCHECK

);

-- *** RestaurantTable (Table is a reserved keyword in Oracle) ***
CREATE TABLE RestaurantTable(
  id BIGINT NOT NULL AUTO_INCREMENT,
  modificationCounter INTEGER NOT NULL,
  number BIGINT NOT NULL CHECK (number >= 0),
  state INTEGER,
  waiterId BIGINT,
  CONSTRAINT PK_RestaurantTable PRIMARY KEY(id),
  CONSTRAINT UC_Table_number UNIQUE(number)

);

-- *** RestaurantOrder (Order is a reserved keyword in Oracle) ***
CREATE TABLE RestaurantOrder(
  id BIGINT NOT NULL AUTO_INCREMENT,
  modificationCounter INTEGER NOT NULL,
  state INTEGER,
  tableId BIGINT NOT NULL,
  CONSTRAINT PK_RestaurantOrder PRIMARY KEY(id)
);

-- *** OrderPosition ***
CREATE TABLE OrderPosition(
  id BIGINT NOT NULL AUTO_INCREMENT,
  modificationCounter INTEGER NOT NULL,
  comment VARCHAR(255),
  cookId BIGINT,
  offerId BIGINT,
  offerName VARCHAR(255),
  price DECIMAL(19, 2),
  state INTEGER,
  drinkState INTEGER,
  orderId BIGINT,
  CONSTRAINT PK_OrderPosition PRIMARY KEY(id),
  CONSTRAINT FK_OrderPosition_orderId FOREIGN KEY(orderId) REFERENCES RestaurantOrder(id) NOCHECK,
  CONSTRAINT FK_OrderPosition_cookId FOREIGN KEY(cookId) REFERENCES StaffMember(id) NOCHECK

);

-- *** Bill ***
CREATE TABLE Bill(
  id BIGINT NOT NULL AUTO_INCREMENT,
  modificationCounter INTEGER NOT NULL,
  payed BOOLEAN NOT NULL,
  tip DECIMAL(19, 2),
  total DECIMAL(19, 2),
  CONSTRAINT PK_Bill PRIMARY KEY(id)
);

CREATE TABLE BillOrderPosition(
  billId BIGINT NOT NULL AUTO_INCREMENT,
  orderPositionsId BIGINT NOT NULL,
  CONSTRAINT FK_BillOrderPosition_billId FOREIGN KEY(billId) REFERENCES Bill(id) NOCHECK,
  CONSTRAINT FK_BillOrderPosition_orderPositionsId FOREIGN KEY(orderPositionsId) REFERENCES OrderPosition(id) NOCHECK
);

-- *** BinaryObject (BLOBs) ***
CREATE TABLE BinaryObject (
  id BIGINT NOT NULL AUTO_INCREMENT,
  modificationCounter INTEGER NOT NULL,
  data BLOB(2147483647),
  size BIGINT NOT NULL,
  mimeType VARCHAR(255),
  PRIMARY KEY (ID)
);

-- *** RevInfo (Commit log for envers audit trail) ***
CREATE TABLE RevInfo(
  id BIGINT NOT NULL GENERATED BY DEFAULT AS IDENTITY (START WITH 1),
  timestamp BIGINT NOT NULL,
  userLogin VARCHAR(255)
);

-- Special --
CREATE TABLE Special(
    id BIGINT NOT NULL AUTO_INCREMENT,
    modificationCounter INTEGER NOT NULL,
    name VARCHAR(255),
    offerId BIGINT NOT NULL,
    startingDay INTEGER NOT NULL,
    startingHour INTEGER NOT NULL,
    endingDay INTEGER NOT NULL,
    endingHour INTEGER NOT NULL,
    specialPrice DECIMAL(19, 2),
    CONSTRAINT FK_SpecialOffer_offerId FOREIGN KEY(offerId) REFERENCES Offer(id) NOCHECK,
    CONSTRAINT PK_Special PRIMARY KEY(id),
    CONSTRAINT UC_Special_name UNIQUE(name)
);


