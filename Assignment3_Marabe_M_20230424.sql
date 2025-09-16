USE [Assignment_22]
GO
/****** Object:  StoredProcedure [dbo].[Question1]    Script Date: 2023/04/24 15:43:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Question1]
@BookingID	int,
@BagID	int,
@BStatus_ShortDesc	varchar(30),
@SeatID	int,
@BoardingPassID	int

As
Begin
if @BookingID <> null
	begin transaction
			Update Bag_Status
				set BStatus_ShortDesc = 'Checked'
				where @BookingID = @BagID;
			if @@ERROR = 1
				rollback;
			else
				select @BoardingPassID
				from BoardingPass;
				if @@ERROR = 1
					rollback;
				else
					select @SeatID
					from Seat
					if @@ERROR = 1
						rollback;
					else
						commit;
End
GO
/****** Object:  StoredProcedure [dbo].[Question2]    Script Date: 2023/04/24 15:43:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[Question2]
AS
Begin 
--First Query
	select Pass_FirstName, Pass_LastName
	from Passenger
	right join Booking
	on Passenger.PassengerID = Booking.PassengerID
	left join BoardingPass
	on Booking.BookingID = BoardingPass.BookingID
	where BoardingPassID is null
	order by Pass_LastName, Pass_FirstName Asc

--Second Query

	select Pass_FirstName, Pass_LastName
	from Passenger
	join Booking
	on Passenger.PassengerID = Booking.PassengerID
	join BoardingPass
	on Booking.BookingID = BoardingPass.BookingID
	where BoardingPassID is null
	order by Pass_LastName, Pass_FirstName Asc



End
GO
/****** Object:  StoredProcedure [dbo].[Question3]    Script Date: 2023/04/24 15:43:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[Question3]
As
Begin 
Select Emp_LName, Emp_FName, CRole_ShortDesc
from Employee
join CabinCrew
on Employee.Employee_ID = CabinCrew.CabinCrewID
join CabinRole
on CabinRole.CabinRoleID = CabinCrew.CabinRoleID
End
GO
/****** Object:  StoredProcedure [dbo].[Question4]    Script Date: 2023/04/24 15:43:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create Procedure [dbo].[Question4]
as 
begin
declare @MaxWeight as int = 20
Declare @i as Int = 1
while @i <= (select count(BagID) from Bag
Do) 
	select BoardingPassID from bag
	where BagID <> BoardingPassID
	and Bag_weight < @MaxWeight
	Union Select BoardingPassID from bag
Set @i = @i +1;
end
GO
/****** Object:  StoredProcedure [dbo].[Question5]    Script Date: 2023/04/24 15:43:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
Create procedure [dbo].[Question5]
as
begin
Select Route_Desc, s.Airport_Name, e.Airport_Name
from Route
Join Airport s
on s.AirportID = Route.StartAirportID
join Airport e
on e.AirportID = Route.EndAirportID
where StartAirportID = s.AirportID
and EndAirportID = e.AirportID
end
GO

