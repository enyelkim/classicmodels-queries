-- -----------------------------------------------------
-- Schema classicmodels
-- -----------------------------------------------------
DROP DATABASE IF EXISTS classicmodels;
CREATE DATABASE  `classicmodels` ;
USE `classicmodels`;

-- -----------------------------------------------------
-- Table `classicmodels`.`Offices`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `classicmodels`.`Offices` (
  `officeCode` VARCHAR(10) NOT NULL,
  `city` VARCHAR(50) NOT NULL,
  `phone` VARCHAR(50) NOT NULL,
  `addressLine1` VARCHAR(50) NOT NULL,
  `addressLine2` VARCHAR(50) NULL DEFAULT NULL,
  `state` VARCHAR(50) NULL DEFAULT NULL,
  `country` VARCHAR(50) NOT NULL,
  `postalCode` VARCHAR(15) NOT NULL,
  `territory` VARCHAR(10) NOT NULL,
  `officeLocation` POINT NOT NULL,
  PRIMARY KEY (`officeCode`))
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `classicmodels`.`Employees`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `classicmodels`.`Employees` (
  `employeeNumber` INT(11) NOT NULL,
  `lastName` VARCHAR(50) NOT NULL,
  `firstName` VARCHAR(50) NOT NULL,
  `extension` VARCHAR(10) NOT NULL,
  `email` VARCHAR(100) NOT NULL,
  `reportsTo` INT(11) NULL,
  `jobTitle` VARCHAR(50) NOT NULL,
  `officeCode` VARCHAR(10) NOT NULL,
  PRIMARY KEY (`employeeNumber`),
  INDEX `fk_Employees_Employees_idx` (`reportsTo` ASC),
  INDEX `fk_Employees_Offices_idx` (`officeCode` ASC),
  CONSTRAINT `fk_Employees_Employees`
    FOREIGN KEY (`reportsTo`)
    REFERENCES `classicmodels
  `.`Employees` (`employeeNumber`),
  CONSTRAINT `fk_Employees_Offices`
    FOREIGN KEY (`officeCode`)
    REFERENCES `classicmodels
  `.`Offices` (`officeCode`)
    )
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `classicmodels`.`Customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `classicmodels`.`Customers` (
  `customerNumber` INT(11) NOT NULL,
  `customerName` VARCHAR(50) NOT NULL,
  `contactLastName` VARCHAR(50) NOT NULL,
  `contactFirstName` VARCHAR(50) NOT NULL,
  `phone` VARCHAR(50) NOT NULL,
  `addressLine1` VARCHAR(50) NOT NULL,
  `addressLine2` VARCHAR(50) NULL DEFAULT NULL,
  `city` VARCHAR(50) NOT NULL,
  `state` VARCHAR(50) NULL DEFAULT NULL,
  `postalCode` VARCHAR(15) NULL DEFAULT NULL,
  `country` VARCHAR(50) NOT NULL,
  `salesRepEmployeeNumber` INT(11) NULL,
  `creditLimit` DOUBLE NULL DEFAULT NULL,
  `customerLocation` POINT NOT NULL,
  PRIMARY KEY (`customerNumber`),
  INDEX `fk_Customers_Employees_idx` (`salesRepEmployeeNumber` ASC),
  CONSTRAINT `fk_Customers_Employees`
    FOREIGN KEY (`salesRepEmployeeNumber`)
    REFERENCES `classicmodels
  `.`Employees` (`employeeNumber`)
    ON DELETE CASCADE)
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `classicmodels`.`ProductLines`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `classicmodels`.`ProductLines` (
  `productLine` VARCHAR(50) NOT NULL,
  `textDescription` VARCHAR(4000) NULL DEFAULT NULL,
  `htmlDescription` MEDIUMTEXT NULL DEFAULT NULL,
  `image` MEDIUMBLOB NULL DEFAULT NULL,
  PRIMARY KEY (`productLine`))
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `classicmodels`.`Products`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `classicmodels`.`Products` (
  `productCode` VARCHAR(15) NOT NULL,
  `productName` VARCHAR(70) NOT NULL,
  `productScale` VARCHAR(10) NOT NULL,
  `productVendor` VARCHAR(50) NOT NULL,
  `productDescription` TEXT NOT NULL,
  `quantityInStock` SMALLINT(6) NOT NULL,
  `buyPrice` DOUBLE NOT NULL,
  `MSRP` DOUBLE NOT NULL,
  `productLine` VARCHAR(50) NULL,
  PRIMARY KEY (`productCode`),
  INDEX `fk_Products_ProductLines_idx` (`productLine` ASC),
  CONSTRAINT `fk_Products_ProductLines`
    FOREIGN KEY (`productLine`)
    REFERENCES `classicmodels
  `.`ProductLines` (`productLine`)
    ON DELETE CASCADE)
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `classicmodels`.`Orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `classicmodels`.`Orders` (
  `orderNumber` INT(11) NOT NULL,
  `orderDate` DATETIME NOT NULL,
  `requiredDate` DATETIME NOT NULL,
  `shippedDate` DATETIME NULL DEFAULT NULL,
  `status` VARCHAR(15) NOT NULL,
  `comments` TEXT NULL DEFAULT NULL,
  `customerNumber` INT(11) NOT NULL,
  PRIMARY KEY (`orderNumber`),
  INDEX `fk_Orders_Customers_idx` (`customerNumber` ASC),
  CONSTRAINT `fk_Orders_Customers`
    FOREIGN KEY (`customerNumber`)
    REFERENCES `classicmodels
  `.`Customers` (`customerNumber`))
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `classicmodels`.`OrderDetails`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `classicmodels`.`OrderDetails` (
  `orderNumber` INT(11) NOT NULL,
  `productCode` VARCHAR(15) NOT NULL,
  `quantityOrdered` INT(11) NOT NULL,
  `priceEach` DOUBLE NOT NULL,
  `orderLineNumber` SMALLINT(6) NOT NULL,
  PRIMARY KEY (`productCode`, `orderNumber`),
  INDEX `fk_OrderDetails_Products_idx` (`productCode` ASC),
  INDEX `fk_OrderDetails_Orders_idx` (`orderNumber` ASC),
  CONSTRAINT `fk_OrderDetails_Products`
    FOREIGN KEY (`productCode`)
    REFERENCES `classicmodels
  `.`Products` (`productCode`),
  CONSTRAINT `fk_OrderDetails_Orders`
    FOREIGN KEY (`orderNumber`)
    REFERENCES `classicmodels
  `.`Orders` (`orderNumber`))
DEFAULT CHARACTER SET = utf8mb3;


-- -----------------------------------------------------
-- Table `classicmodels`.`Payments`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `classicmodels`.`Payments` (
  `checkNumber` VARCHAR(50) NOT NULL,
  `paymentDate` DATETIME NOT NULL,
  `amount` DOUBLE NOT NULL,
  `customerNumber` INT(11) NOT NULL,
  PRIMARY KEY (`checkNumber`),
  INDEX `fk_Payments_Customers_idx` (`customerNumber` ASC),
  CONSTRAINT `fk_Payments_Customers`
    FOREIGN KEY (`customerNumber`)
    REFERENCES `classicmodels
  `.`Customers` (`customerNumber`)
    )
DEFAULT CHARACTER SET = utf8mb3;

