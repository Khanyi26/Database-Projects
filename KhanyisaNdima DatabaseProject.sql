-- 1.Create the database
Create database SportsComplexBooking;
use SportsComplexBooking;

-- 2.Creating Tables
Create table Members (ID int primary key, Password varchar(15) unique, Email varchar(50) unique, Member_Since datetime default current_timestamp, Payment_Due decimal(6,2));
Create table Pending_Terminations (ID int primary key, Email varchar(50) unique, Request_Date datetime default current_timestamp, Payment_Due decimal(6,2));
Create table Rooms (ID varchar(15) primary key, Room_Type varchar(60), Price decimal(6,2));
create table Bookings (Booking_ID int primary key, Room_ID varchar(40) , Booked_Date date, Booked_Time time,
 Member_ID int, foreign key (Member_ID) references Members(ID), Date_of_Booking datetime default current_timestamp,
 Payment_Status varchar(50), check(Payment_Status in ('Paid','Pending','Cancelled')));
drop table Pending_Terminations;

-- Display the tables
show tables;
select*from Members;
select*from Pending_Terminations;
select*from Rooms;
select*from Bookings;

-- 3.Inserting data into the tables
insert into Members values (( 1001, 'J@mes3341','jmams@yahoo.com','2015-11-10:15:55:35',0.00),
							(1010,'knse_1234','ndima@mail.com','2022-06-30:11:46:00',100.00),
                            (1002,'123knm@','kping@gmail.com','2017-01-28:10:56:23',1500.00),
                            (1003,'zim@7765','ntlemo@gmail.com','2016-08-10:13:10:10',500),
                            (1006,'jhnm&9909','hlavathic@yahoo.com','2017-03-22:16:23:40',0.00),
                            (1005,'4567_kmkl','fixson@gmail.com','2017-01-12:09:20:21',650.00),
                            (1007,'agc@789#','jb23@mail.com','2018-02-23:11:11:11',890.00),
                            (1008,'cbju987$','tmathe@gmail.com','2018-07-07:08:08:30',0.00),
                            (1009,'@17890mb','Bridgette2@mail.com','2019-06-29:10:15:30',1000.00),
                            (1004,'2@4yjm00','sinnak@gmail.com','2016-12-28:14:50:55',2000.00),
                            (1011,'&kmj8890@','thandi89@yahoo.com','2020-01-30:12:59:00',00.00),
                            (1012,'lkims@009','nyiko@mail.com','22-09-16:12:20:20',450.00));
                            
insert into Pending_Terminations values (1010,'ndima@mail.com','2022-07-15',100.00),(1002,'kping@gmail.com','2017-04-28',1500.00),
                            (1005,'fixson@gmail.com','2017-01-22',650.00),(1007,'jb23@mail.com','2018-04-07',890.00),
                            (1009,'Bridgette2@mail.com','2019-09-29',1000.00),(1004,'sinnak@gmail.com','2016-02-28',2000.00);
                            
                            
insert into Rooms  values ('AR','Archery Range',1500.00),('BC1','Badminton Courts',500.00),('BC2','Badminton Courts',550.00),
							('MF1','Multipurpose Field',1000.00),('MF2','Multipurpose Field',1200.00),('TC1','Tennis Court',700.00),
                            ('TC2','Tennis Court',790.00);                            
                            
insert into Bookings values (1,'AR','2015-11-10','15:55:35',1001,'2015-12-10:15:10','Paid'),
							(10,'BC2','2022-06-30','11:46:00',1010,'2022-07-15:10:45','Pending'),
                            (2,'TC1','2017-01-28','10:56:23','1002','2017-04-28:13:00','Cancelled'),
                            (3,'MP2','2016-08-10','13:10:10',1003, '2016-08-18:09:35','Paid'),
                            (6,'AR','2017-03-22','16:23:40',1006,'2017-05-29:08:00','Paid'),
                            (5,'MP1','2017-01-12','09:20:21',1005,'2017-01-22:16:40','Cancelled'),
                            (7,'TC1','2018-02-23','11:11:11',1007,'2018-04-07:11:35','Pending'),
                            (8,'BC1','2018-07-07','08:08:30',1008,'2018-07-30:17:00','Paid'),
                            (9,'AR','2019-06-29','10:15:30',1009,'2019-09-29','cancelled'),
                            (4,'MP2','2016-12-28','14:50:55',1004,'2016-02-28','Pending'),
                            (11,'TC2','2020-01-30','12:59:00',1011,'2020-07-30:18:45','Paid'),
                            (12,'BC1','22-09-16','2:20:20',1012,'2022-09-26:07:00','Paid');
                            
-- 4.Create new view to combine room table and booking table.
Create view member_bookings AS 
select * 
from rooms 
join bookings on Rooms.ID = Bookings.Room_ID;
 
 -- Display view shows all the booking details of a booking
 select * from member_bookings;

-- 5.Insert new member using procedure.
DELIMITER $$
Create procedure insert_new_member (IN ID1 int, IN Password1 varchar(15),
									IN Email1 varchar(50) , IN Member_Since1 datetime,
                                   IN Payment_Due1 decimal(6,2))    
                                 
BEGIN
       insert into  Members(ID,Password,Email,Member_Since,Payment_Due) 
      values (ID1,Password1,Email1,Member_Since1,Payment_Due1);
END ;
$$;
DELIMITER ;
-- Call procedure to insert a new member.
call insert_new_member (1013,'@kkml445','petberyy@gmail.com','2022-10-29:10:10:35',0.00);

-- 6.Find the ID of the 3rd person and Update the email address for the 3rd person
DELIMITER //
CREATE PROCEDURE UpdateEmailForThirdPerson(IN my_id int, IN my_email varchar(255))
BEGIN
    -- Find the ID of the 3rd person
    SELECT id 
    FROM members
    ORDER BY id
    LIMIT 1 OFFSET 2;
    
    -- Update the email address for the 3rd person
    UPDATE members
    SET email = my_email
    WHERE id =my_id;
    
    COMMIT;
END //
DELIMITER ;
 -- Update the email address for the 3rd person by calling procedure
 call  UpdateEmailForThirdPerson (  1003,'dotKay176@gmail.com');

-- 7.A code that will only return half of members table registration date and time.
set @myvalue=round((select count(*) from members)/2,0);
select @myvalue;
SELECT Member_Since
FROM members
ORDER BY Member_Since
limit 7;

-- 8.Joining room table and book table.
SELECT *
FROM Rooms AS R
INNER JOIN Bookings AS B
ON LEFT(B.room_id, 1) = R.room_type;

-- 9.Check Cancellation
DELIMITER //
CREATE PROCEDURE Check_Cancellation(IN my_member_id INT,OUT consecutive_cancellations INT)
BEGIN
    DECLARE previous_cancellation_date DATE;
    DECLARE consecutive_cancellations_count INT DEFAULT 0;

    SELECT MAX(cancellation_date)
    INTO previous_cancellation_date
    FROM Bookings
    WHERE member_id = my_member_id;

    IF previous_cancellation_date IS NOT NULL THEN
        SELECT COUNT(*)
        INTO consecutive_cancellations_count
        FROM Bookings
        WHERE member_id = my_member_id
        AND cancellation_date = DATE_SUB(CURDATE(), INTERVAL 1 DAY);

        IF consecutive_cancellations_count > 0 THEN
            SET consecutive_cancellations = consecutive_cancellations_count;
        ELSE
            SET consecutive_cancellations = 0;
        END IF;
    ELSE
        SET consecutive_cancellations = 0;
    END IF;
END //

