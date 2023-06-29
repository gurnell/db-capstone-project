# task 1 :create a visual table
CREATE VIEW OrdersView AS
SELECT OrderID, Quantity, TotalCost
FROM orders
WHERE Quantity > 2;

# task 2 : join three tables
SELECT c.CustomerID, c.FullName, o.OrderID, o.TotalCost, m.MenuName, i.CourseName, i.StarterName
FROM customers c 
INNER JOIN orders 
ON c.CustomerID = o.customerID
INNER JOIN menus m ON o.MenuID = m.MenuID
INNER JOIN menu_items i ON i.MenuItemID = m.MenuItemID 
WHERE TotalCost > 150 
ORDER BY TotalCost DESC;

# task 3: subquery
SELECT MenuName
FROM menus
WHERE MenuName = ANY(
          SELECT Quantity
          FROM  orders
          WHERE Quantity > 2);

CREATE PROCEDURE GetMaxQuantity()

# task 1 stored procdure for max quantity
SELECT MAX(orders.Quantity)
FROM orders;

# task 2: procedure for getorderdetails
PREPARE GetOrderDetail from 'SELECT OrderID, Quantity, TotalCost from orders where OrderID=?';
SET @id = 1;
EXECUTE GetOrderDetail USING @id;

# task 3: cancelorder procedure
CREATE PROCEDURE CancelOrder(IN OrderID INT)
DELETE FROM orders;

CREATE PROCEDURE CheckBooking(IN BookingDate DATE, IN TableNumber INT)
SELECT BookingDate, TableNumber
WHERE exists (SELECT * from Booking where Date = BookingDate and TableNumber = TableNumber);

CREATE PROCEDURE AddValidBooking (IN BookingDate DATE, IN TableNumber INT)

START TRANSACTION;

SELECT BookingDate, TableNumber
WHERE exists (SELECT * from Booking where Date = BookingDate and TableNumber = TableNumber);

	INSERT INTO booking (date, table_number)
	VALUES (BookingDate, TableNumber);
    
	COMMIT;
    
CREATE PROCEDURE AddBooking (IN BookingID INT, IN CustomerID INT, IN TableNumber INT, IN BookingDate DATE)
BEGIN
INSERT INTO booking (bookingid, customerid, tablenumber, date) VALUES (BookingID, CustomerID, TableNumber, BookingDate)
END;

CREATE PROCEDURE UpdateBooking (IN BookingID INT, IN BookingDate DATE)
BEGIN
UPDATE booking SET date = BookingDate WHERE booking_id = BookingID
END;

CREATE DEFINER=`root`@`localhost` PROCEDURE `CancelBooking`(IN BookingID INT)
BEGIN
DELETE FROM booking WHERE booking_id = BookingID
END;
